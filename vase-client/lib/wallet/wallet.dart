import 'dart:async';
import 'dart:typed_data';

import 'package:hex/hex.dart';
import 'package:pool/pool.dart';
import 'package:vase/chronik-client/client.dart';
import 'package:vase/chronik-client/client.types.dart';
import 'package:vase/lotus/lotus.dart';
import 'package:vase/wallet/vault.dart';

import '../config/constants.dart';
import 'keys.dart';

class TransactionMetadata {
  List<VaultUtxo>? usedUtxos;
  Transaction? transaction;
  TransactionMetadata({this.usedUtxos, this.transaction});
}

class WalletBalance {
  BigInt? balance;
  dynamic error;

  WalletBalance({this.balance, this.error});
}

typedef BalanceUpdateHandler = void Function(WalletBalance result);

class Wallet {
  BalanceUpdateHandler? balanceUpdateHandler;
  Wallet(
    this.keys, {
    this.network,
    this.balanceUpdateHandler,
    required this.chronik,
  }) {
    _ws = chronik.ws(WsConfig(onConnect: (m) => startUtxoListenersChronik()));
  }

  NetworkType? network;
  ChronikClient chronik;
  WsEndpoint? _ws;

  Keys keys;

  final Vault _vault = Vault([]);

  BigInt _balance = BigInt.zero;

  /// Gets the fees per byte.
  Future<BigInt> fetchFeePerByte() async {
    // TODO: Refresh from electrum.
    return BigInt.from(defaultFeePerByte);
  }

  void addressUpdated(result) async {
    // Extract script hash from result (of form [scripthash, status])
    final scriptHash = result[0];

    final keyInfo =
        keys.findKeyByScriptHash(Uint8List.fromList(HEX.decode(scriptHash)));

    // Remove all UTXOs at that index
    _vault.removeByKeyIndex(keyInfo.keyIndex);

    // Refresh UTXOs
    final unspentUtxos =
        await chronik.script(ScriptType.p2pkh, scriptHash).utxos();
    // TODO: Remove keyIndex concept. It is not particularly necessary;
    for (final unspent in unspentUtxos) {
      for (final uxto in unspent.utxos) {
        final spendable = VaultUtxo(
          VaultOutpoint(
            uxto.outpoint.txid,
            uxto.outpoint.outIdx,
            BigInt.from(int.parse(uxto.value)),
            uxto.blockHeight,
          ),
          keyInfo.keyIndex,
        );
        _vault.addUtxo(spendable);
      }
    }
    refreshBalanceLocal();
  }

  /// Start UTXO listeners.
  Future<void> startUtxoListenersChronik() async {
    for (final keyInfo in keys.keys!) {
      if (keyInfo.isDeprecated == true) {
        // We don't care about deprecated keys being listened to. Only load them
        // on startup. Listening to lots of keys is slow.
        continue;
      }
      final hexScriptHash = HEX.encode(keyInfo.scriptHash!);
      _ws?.subscribe(ScriptType.p2pkh, hexScriptHash);
    }
  }

  /// Fetch UTXOs from electrum then update vault.
  Future<void> updateUtxosChronik() async {
    final pool = Pool(5, timeout: const Duration(seconds: 60));

    final futures = keys.keys?.map((keyInfo) {
          final hexScriptHash = HEX.encode(keyInfo.scriptHash!);
          return pool.withResource(() async {
            final unspentUtxos =
                await chronik.script(ScriptType.p2pkh, hexScriptHash).utxos();
            // TODO: Remove keyIndex concept. It is not particularly necessary;
            for (final unspent in unspentUtxos) {
              for (final uxto in unspent.utxos) {
                final spendable = VaultUtxo(
                  VaultOutpoint(
                    uxto.outpoint.txid,
                    uxto.outpoint.outIdx,
                    BigInt.from(int.parse(uxto.value)),
                    uxto.blockHeight,
                  ),
                  keyInfo.keyIndex,
                );
                _vault.removeUtxo(spendable);
                _vault.addUtxo(spendable);
              }
            }
          });
        }) ??
        [];
    await Future.wait(futures);
  }

  void updateBalance(WalletBalance update) {
    if (balanceUpdateHandler != null) {
      balanceUpdateHandler!(update);
    }
  }

  /// Use locally stored UTXOs to refresh balance.
  void refreshBalanceLocal() {
    _balance = _vault.calculateBalance();
    updateBalance(WalletBalance(balance: _balance));
  }

  void initialize() async {
    // Wipe out the vault before refreshing UTXOs
    try {
      await updateUtxosChronik();
    } catch (err) {
      print(err);
      updateBalance(WalletBalance(balance: null, error: err));
      return;
    }
    refreshBalanceLocal();
  }

  BigInt balanceSatoshis() {
    return _balance;
  }

  Transaction _finalizeTransaction(Transaction transaction, BigInt feePerByte,
      {required List<BCHPrivateKey> signingKeys}) {
    final shuffledKeys = keys.keys!.sublist(0);
    shuffledKeys.shuffle();
    final changeKeyInfo = shuffledKeys.firstWhere(
        (keyInfo) => keyInfo.isChange == true && keyInfo.isDeprecated == false);

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
      {BigInt? feePerByte}) {
    var transaction = Transaction();

    var amountRequired = BigInt.from(0);
    // Add outputs
    for (final output in outputs) {
      amountRequired += output.satoshis;
      transaction.addOutput(output);
    }

    // Coin selection
    final signingKeys = <BCHPrivateKey>[];
    final usedUtxos = <VaultUtxo>[];

    final Iterable<List<VaultUtxo>> utxos = _vault.values;
    final allUtxos = utxos.expand((utxos) => utxos).toList();
    // Use oldest outpoints first
    allUtxos.sort(
        (VaultUtxo a, VaultUtxo b) => a.outpoint.height! - b.outpoint.height!);
    var satoshis = BigInt.from(0);

    for (final utxo in allUtxos) {
      final txnSize = transaction.estimatedSize;
      if (satoshis > amountRequired + BigInt.from(txnSize) * feePerByte!) {
        break;
      }
      final privateKeyInfo = keys.keys![utxo.keyIndex!];
      final privateKey = privateKeyInfo.key;

      usedUtxos.add(utxo);
      _vault.removeUtxo(utxo);
      signingKeys.add(privateKey);

      // Create input
      final unlockBuilder = P2PKHUnlockBuilder(privateKey.publicKey);
      final address = privateKey.toAddress(networkType: network);
      assert(address.toBase58() == privateKeyInfo.address!.toBase58(),
          'Key info corrupt for $address != ${privateKeyInfo.address}');
      var output = TransactionOutput(scriptBuilder: P2PKHLockBuilder(address));
      output.satoshis = utxo.outpoint.amount;
      output.transactionId = utxo.outpoint.transactionId;
      output.outputIndex = utxo.outpoint.vout;
      transaction = transaction.spendFromOutput(output, NLOCKTIME_MAX_VALUE,
          scriptBuilder: unlockBuilder);
      satoshis += utxo.outpoint.amount;
    }

    if (satoshis < amountRequired) {
      throw Exception('Not enough funds to construct transaction');
    }

    // TODO: Need change UTXOs here so we can add them to the vault and spend from
    // them before confirmation
    transaction = _finalizeTransaction(transaction, feePerByte!,
        signingKeys: signingKeys);

    return TransactionMetadata(transaction: transaction, usedUtxos: usedUtxos);
  }

  Future<Transaction?> sendTransaction(
      Address recipientAddress, BigInt amount) async {
    final feePerByte = await fetchFeePerByte();
    final output =
        TransactionOutput(scriptBuilder: P2PKHLockBuilder(recipientAddress));
    output.satoshis = amount;
    final txnMetadata = constructTransaction([output], feePerByte: feePerByte);
    final transactionHex = txnMetadata.transaction!.serialize();

    try {
      await chronik.broadcastTx(rawTx: transactionHex);
    } catch (err) {
      _vault.addAllUtxos(txnMetadata.usedUtxos!);
      print(err.toString());
      rethrow;
    } finally {
      refreshBalanceLocal();
    }

    return txnMetadata.transaction;
  }

  Future<void> updateSeedPhrase(String newSeed, [String password = '']) async {
    keys = await Keys.construct(newSeed, password);
    initialize();
  }
}
