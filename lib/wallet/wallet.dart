import 'dart:typed_data';

import 'package:cashew/bitcoincash/bitcoincash.dart';
import 'package:cashew/wallet/vault.dart';
import 'package:hex/hex.dart';

import '../constants.dart';
import 'keys.dart';
import '../electrum/client.dart';

typedef BalanceUpdateHandler = void Function(int result);

class TransactionMetadata {
  List<Utxo> usedUtxos;
  Transaction transaction;
  TransactionMetadata({this.usedUtxos, this.transaction});
}

class Wallet {
  BalanceUpdateHandler balanceUpdateHandler;
  Wallet(this.keys, this.electrumFactory,
      {this.network, this.balanceUpdateHandler}) {
    electrumFactory.onConnected = (client) => startUtxoListeners(client);
  }

  NetworkType network;
  ElectrumFactory electrumFactory;

  Keys keys;

  final Vault _vault = Vault([]);

  int _balance = 0;

  /// Gets the fees per byte.
  Future<BigInt> fetchFeePerByte() async {
    // TODO: Refresh from electrum.
    return BigInt.from(defaultFeePerByte);
  }

  void addressUpdated(result) async {
    // Extract script hash from result (of form [scripthash, status])
    final scriptHash = result[0];
    final clientFuture = electrumFactory.build();
    final client = await clientFuture;

    final keyInfo =
        keys.findKeyByScriptHash(Uint8List.fromList(HEX.decode(scriptHash)));

    if (keyInfo == null) {
      throw Exception('Script hash not found'); // TODO: Handle this gracefully
    }

    // Remove all UTXOs at that index
    _vault.removeByKeyIndex(keyInfo.keyIndex);

    // Refresh UTXOs
    final unspentList =
        await client.blockchainScripthashListunspent(scriptHash);
    for (final unspent in unspentList) {
      final outpoint = Outpoint(unspent.tx_hash, unspent.tx_pos, unspent.value);

      final spendable = Utxo(outpoint, keyInfo.keyIndex);

      _vault.addUtxo(spendable);
    }
    refreshBalanceLocal();
  }

  /// Start UTXO listeners.
  Future<void> startUtxoListeners(ElectrumClient client) async {
    for (final keyInfo in keys.keys) {
      final hexScriptHash = HEX.encode(keyInfo.scriptHash);

      await client.blockchainScripthashSubscribe(hexScriptHash, addressUpdated);
    }
  }

  /// Fetch UTXOs from electrum then update vault.
  Future<void> updateUtxos(ElectrumClient client) async {
    var keyIndex = 0;
    for (final keyInfo in keys.keys) {
      final hexScriptHash = HEX.encode(keyInfo.scriptHash);

      final unspentUtxos =
          await client.blockchainScripthashListunspent(hexScriptHash);

      // TODO: Remove keyIndex concept. It is not particularly necessary;
      for (final unspent in unspentUtxos) {
        final outpoint =
            Outpoint(unspent.tx_hash, unspent.tx_pos, unspent.value);

        final spendable = Utxo(outpoint, keyIndex);

        _vault.addUtxo(spendable);
      }
      keyIndex += 1;
    }
  }

  /// Use locally stored UTXOs to refresh balance.
  void refreshBalanceLocal() {
    _balance = _vault.calculateBalance().toInt();
    if (balanceUpdateHandler != null) {
      balanceUpdateHandler(_balance);
    }
  }

  /// Use electrum to refresh balance.
  Future<void> refreshBalanceRemote() async {
    final clientFuture = electrumFactory.build();

    final client = await clientFuture;
    final responses = await Future.wait(keys.keys.map((keyInfo) {
      final scriptHashHex = HEX.encode(keyInfo.scriptHash);
      return client.blockchainScripthashGetBalance(scriptHashHex);
    }));

    final totalBalance = responses
        .map((response) => response.confirmed + response.unconfirmed)
        .fold(0, (p, c) => p + c);
    _balance = totalBalance;
  }

  Future<void> initialize() async {
    final clientFuture = electrumFactory.build();
    final client = await clientFuture;

    // Wipe out the vault before refreshing UTXOs
    await updateUtxos(client);
    refreshBalanceLocal();
    // TODO: we need a way to restart these when electrum connection dies
    // currently, we won't get any updates if we ever have to reconnect
    // again.
    await startUtxoListeners(client);
  }

  int balanceSatoshis() {
    return _balance;
  }

  Transaction _finalizeTransaction(Transaction transaction, BigInt feePerByte,
      {List<BCHPrivateKey> signingKeys}) {
    final shuffledKeys = keys.keys.sublist(0);
    shuffledKeys.shuffle();
    final changeKeyInfo =
        shuffledKeys.firstWhere((keyInfo) => keyInfo.isChange == true);

    // NOTE: 35 is the number of bytes required for a standard output
    final changeAmount = transaction.inputAmount -
        transaction.outputAmount -
        (BigInt.from(35 + transaction.estimatedSize) * feePerByte);

    // If the change is larger than a reasonable dust limit, create an output, otherwise
    // donate it to the miners.
    if (changeAmount > BigInt.from(512)) {
      transaction = transaction.spendTo(changeKeyInfo.address, changeAmount);
    }

    // BIP69 sorting
    // transaction.sort();

    // TODO: Shuffle outputs here to obfuscate change.

    // Sign transaction
    signingKeys.asMap().forEach((index, privateKey) {
      transaction.signInput(index, privateKey,
          sighashType: SighashType.SIGHASH_ALL | SighashType.SIGHASH_FORKID);
    });

    return transaction;
  }

  TransactionMetadata constructTransaction(List<TransactionOutput> outputs,
      {BigInt feePerByte}) {
    var transaction = Transaction();

    var amountRequired = BigInt.from(0);
    // Add outputs
    for (final output in outputs) {
      amountRequired += output.satoshis;
      transaction.addOutput(output);
    }

    // Coin selection
    final signingKeys = <BCHPrivateKey>[];
    final usedUtxos = <Utxo>[];

    final utxos = _vault.values;
    final allUtxos = utxos.expand((utxos) => utxos).toList();
    allUtxos.shuffle();
    var satoshis = BigInt.from(0);

    for (final utxo in allUtxos) {
      final txnSize = transaction.estimatedSize;
      if (satoshis > amountRequired + BigInt.from(txnSize) * feePerByte) {
        break;
      }
      final privateKeyInfo = keys.keys[utxo.keyIndex];
      final privateKey = privateKeyInfo.key;

      usedUtxos.add(utxo);
      _vault.removeUtxo(utxo);
      signingKeys.add(privateKey);

      // Create input
      final unlockBuilder = P2PKHUnlockBuilder(privateKey.publicKey);
      final address = privateKey.toAddress(networkType: network);
      var output = TransactionOutput(scriptBuilder: P2PKHLockBuilder(address));
      output.satoshis = utxo.outpoint.amount;
      output.transactionId = utxo.outpoint.transactionId;
      output.outputIndex = utxo.outpoint.vout;
      transaction = transaction.spendFromOutput(
          output, Transaction.NLOCKTIME_MAX_VALUE,
          scriptBuilder: unlockBuilder);
      satoshis += utxo.outpoint.amount;
    }

    if (satoshis < amountRequired) {
      throw Exception('Not enough funds to construct transaction');
    }

    // TODO: Need change UTXOs here so we can add them to the vault and spend from
    // them before confirmation
    transaction =
        _finalizeTransaction(transaction, feePerByte, signingKeys: signingKeys);

    return TransactionMetadata(transaction: transaction, usedUtxos: usedUtxos);
  }

  Future<Transaction> sendTransaction(
      Address recipientAddress, BigInt amount) async {
    final clientFuture = electrumFactory.build();
    final feePerByte = await fetchFeePerByte();
    final output =
        TransactionOutput(scriptBuilder: P2PKHLockBuilder(recipientAddress));
    output.satoshis = amount;
    final txnMetadata = constructTransaction([output], feePerByte: feePerByte);
    final transactionHex = txnMetadata.transaction.serialize();

    try {
      final client = await clientFuture;

      await client.blockchainTransactionBroadcast(transactionHex);
    } catch (err) {
      _vault.addAllUtxos(txnMetadata.usedUtxos);
      print(err.message);
      rethrow;
    } finally {
      refreshBalanceLocal();
    }

    return txnMetadata.transaction;
  }

  Future<void> updateSeedPhrase(String newSeed) async {
    keys = await Keys.construct(newSeed);
    await initialize();
  }
}
