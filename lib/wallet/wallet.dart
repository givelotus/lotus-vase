import 'package:cashew/bitcoincash/bitcoincash.dart';
import 'package:cashew/wallet/storage/schema.dart';
import 'package:cashew/wallet/storage/seed.dart';
import 'package:cashew/wallet/vault.dart';
import 'package:convert/convert.dart';

import '../constants.dart';
import 'keys.dart';
import '../electrum/client.dart';

class Wallet {
  Wallet(this.walletPath, this.electrumFactory, {this.network});

  NetworkType network;
  String walletPath;
  ElectrumFactory electrumFactory;

  Keys keys;
  Bip39Seed seed;

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

    // Lookup script hash
    var isExternal = true;
    var keyIndex;
    keyIndex = keys.findKeyByScriptHash(scriptHash);

    if (keyIndex == null) {
      throw Exception('Script hash not found'); // TODO: Handle this gracefully
    }

    // Remove all UTXOs at that index
    _vault.removeByKeyIndex(keyIndex, isExternal);

    // Refresh UTXOs
    final unspentList =
        await client.blockchainScripthashListunspent(scriptHash);
    for (final unspent in unspentList) {
      final outpoint = Outpoint(unspent.tx_hash, unspent.tx_pos, unspent.value);

      final spendable = Utxo(outpoint, isExternal, keyIndex);

      _vault.add(spendable);
    }
  }

  /// Start UTXO listeners.
  Future<void> startUtxoListeners() async {
    final clientFuture = electrumFactory.build();
    final client = await clientFuture;

    for (final keyInfo in keys.keys) {
      final hexScriptHash = hex.encode(keyInfo.scriptHash);

      await client.blockchainScripthashSubscribe(hexScriptHash, addressUpdated);
    }
  }

  /// Fetch UTXOs from electrum then update vault.
  Future<void> updateUtxos() async {
    final clientFuture = electrumFactory.build();

    final client = await clientFuture;

    var keyIndex = 0;
    for (final keyInfo in keys.keys) {
      final hexScriptHash = hex.encode(keyInfo.scriptHash);

      final unspentUtxos =
          await client.blockchainScripthashListunspent(hexScriptHash);

      // TODO: Remove keyIndex concept. It is not particularly necessary;
      for (final unspent in unspentUtxos) {
        final outpoint =
            Outpoint(unspent.tx_hash, unspent.tx_pos, unspent.value);

        final spendable = Utxo(outpoint, !keyInfo.isChange, keyIndex);

        _vault.add(spendable);
      }
      keyIndex += 1;
    }
  }

  /// Use locally stored UTXOs to refresh balance.
  void refreshBalanceLocal() {
    _balance = _vault.calculateBalance().toInt();
  }

  /// Use electrum to refresh balance.
  Future<void> refreshBalanceRemote() async {
    final clientFuture = electrumFactory.build();

    final client = await clientFuture;
    final responses = await Future.wait(keys.keys.map((keyInfo) {
      final scriptHashHex = hex.encode(keyInfo.scriptHash);
      return client.blockchainScripthashGetBalance(scriptHashHex);
    }));

    final totalBalance = responses
        .map((response) => response.confirmed + response.unconfirmed)
        .fold(0, (p, c) => p + c);
    _balance = totalBalance;
  }

  /// Read wallet file from disk. Returns true if successful.
  Future<void> loadFromDisk() async {
    // Check schema version
    final schemaVersion = await readSchemaVersion();
    if (schemaVersion != CURRENT_SCHEMA_VERSION) {
      throw Exception('Unsupported version');
    }

    // Read keys
    keys = await Keys.readFromDisk(network);

    // Read seed
    seed = await Bip39Seed.readFromDisk();

    // TODO: Load UTXOs
  }

  /// Generate new random seed.
  String newSeed() {
    // TODO: Randomize and can we move to bytes
    // rather than string (crypto API awkard)?
    return 'festival shrimp feel before tackle pyramid immense banner fire wash steel fiscal';
  }

  /// Generate new wallet from scratch.
  Future<void> generateWallet() async {
    seed = Bip39Seed(value: newSeed());

    keys = await Keys.construct(seed);
  }

  /// Attempts to load wallet from disk, else constructs a new wallet.
  Future<void> initialize() async {
    try {
      await loadFromDisk();
    } catch (err) {
      // TODO: Match on error - was failure due to first load (missing data)
      // or an error?
    }

    if (seed.value == null) {
      await generateWallet();

      // Persist schema version
      await writeSchemaVersion();

      // Persist keys
      await keys.writeToDisk();

      // Persist seed
      await seed.writeToDisk();
    }
  }

  /// Use electrum to update wallet.
  Future<void> updateWallet() async {}

  int balanceSatoshis() {
    return _balance;
  }

  Transaction _constructTransaction(
      Address recipientAddress, BigInt amount, BigInt feePerByte) {
    final baseFee = BigInt.from((10 + outputSize)) * feePerByte;
    final feePerInput = BigInt.from(outputSize) * feePerByte;

    // Collect UTXOs required for transaction
    final utxos = _vault.collectUtxos(amount, baseFee, feePerInput);

    var tx = Transaction();
    var privateKeys = [];

    // Add inputs
    for (final utxo in utxos) {
      // Get private key from store
      final keyInfo = keys.keys[utxo.keyIndex];
      final privateKey = keyInfo.key;
      privateKeys.add(privateKey);

      // Create input
      final unlockBuilder = P2PKHUnlockBuilder(privateKey.publicKey);
      final address = privateKey.toAddress(networkType: network);
      var output = TransactionOutput(scriptBuilder: P2PKHLockBuilder(null));
      output.satoshis = utxo.outpoint.amount;
      output.transactionId = utxo.outpoint.transactionId;
      output.outputIndex = utxo.outpoint.vout;
      output.script = P2PKHLockBuilder(address).getScriptPubkey();
      tx = tx.spendFromOutput(output, Transaction.NLOCKTIME_MAX_VALUE,
          scriptBuilder: unlockBuilder);
    }

    // TODO: Just generate a change address here...
    final shuffledKeys = keys.keys.sublist(0);
    shuffledKeys.shuffle();
    final changeKeyInfo =
        shuffledKeys.firstWhere((keyInfo) => keyInfo.isChange == true);

    tx = tx
        .spendTo(recipientAddress, amount)
        .sendChangeTo(changeKeyInfo.address)
        .withFeePerKb(1024 * feePerByte.toInt());

    // Sign transaction
    privateKeys.asMap().forEach((index, privateKey) {
      tx.signInput(index, privateKey,
          sighashType: SighashType.SIGHASH_ALL | SighashType.SIGHASH_FORKID);
    });

    return tx;
  }

  Future<Transaction> sendTransaction(
      Address recipientAddress, BigInt amount) async {
    final clientFuture = electrumFactory.build();
    final feePerByte = await fetchFeePerByte();
    final transaction =
        _constructTransaction(recipientAddress, amount, feePerByte);

    final transactionHex = transaction.serialize();
    final client = await clientFuture;

    try {
      await client.blockchainTransactionBroadcast(transactionHex);
    } catch (err) {
      print(err.message);
      rethrow;
    }
    return transaction;
  }
}
