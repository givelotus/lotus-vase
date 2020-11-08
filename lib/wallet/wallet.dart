import 'dart:typed_data';

import 'package:cashew/bitcoincash/bitcoincash.dart';
import 'package:cashew/wallet/vault.dart';
import 'package:pointycastle/digests/sha256.dart';
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
  String bip39Seed;

  Vault _vault = Vault([]);

  int _balance = 0;

  /// Gets the fees per byte.
  Future<BigInt> fetchFeePerByte() async {
    // TODO: Refresh from electrum.
    return BigInt.from(defaultFeePerByte);
  }

  /// Start UTXO listeners.
  Future<void> startUtxoListeners() async {
    final clientFuture = electrumFactory.build();
    final externalScriptHashes = keys.getExternalScriptHashes();
    final changeScriptHashes = keys.getChangeScriptHashes();

    final client = await clientFuture;
    var keyIndex = 0;
    for (final scriptHash in externalScriptHashes) {
      final hexScriptHash = hex.encode(scriptHash);
      await client.blockchainScripthashSubscribe(hexScriptHash, (result) async {
        _vault.removeByKeyIndex(keyIndex, true);

        final unspentList =
            await client.blockchainScripthashListunspent(hexScriptHash);
        for (final unspent in unspentList) {
          final outpoint =
              Outpoint(unspent.tx_hash, unspent.tx_pos, unspent.value);

          final spendable = Utxo(outpoint, true, keyIndex);

          _vault.add(spendable);
        }
      });
      keyIndex += 1;
    }

    keyIndex = 0;
    for (final scriptHash in changeScriptHashes) {
      final hexScriptHash = hex.encode(scriptHash);
      await client.blockchainScripthashSubscribe(hexScriptHash, (result) async {
        _vault.removeByKeyIndex(keyIndex, false);

        final unspentList =
            await client.blockchainScripthashListunspent(hexScriptHash);
        for (final unspent in unspentList) {
          final outpoint =
              Outpoint(unspent.tx_hash, unspent.tx_pos, unspent.value);

          final spendable = Utxo(outpoint, false, keyIndex);

          _vault.add(spendable);
        }
      });
      keyIndex += 1;
    }
  }

  ///
  // Future<void> _updateUtxo(Int index, String scriptHashHex, )

  /// Fetch UTXOs from electrum then update vault.
  Future<void> updateUtxos() async {
    final clientFuture = electrumFactory.build();

    final externalScriptHashes = keys.getExternalScriptHashes();
    final changeScriptHashes = keys.getChangeScriptHashes();

    final client = await clientFuture;
    final externalFuts = externalScriptHashes.map((scriptHash) {
      final hexScriptHash = hex.encode(scriptHash);
      return client.blockchainScripthashListunspent(hexScriptHash);
    });
    final changeFuts = changeScriptHashes.map((scriptHash) {
      final hexScriptHash = hex.encode(scriptHash);
      return client.blockchainScripthashListunspent(hexScriptHash);
    });
    final externalUnspent = await Future.wait(externalFuts);
    final changeUnspent = await Future.wait(changeFuts);

    // Collect external unspent
    var keyIndex = 0;
    for (final unspentList in externalUnspent) {
      for (final unspent in unspentList) {
        final outpoint =
            Outpoint(unspent.tx_hash, unspent.tx_pos, unspent.value);

        final spendable = Utxo(outpoint, true, keyIndex);

        _vault.add(spendable);
      }
      keyIndex += 1;
    }

    // Collect change unspent
    keyIndex = 0;
    for (final unspentList in changeUnspent) {
      for (final unspent in unspentList) {
        final outpoint =
            Outpoint(unspent.tx_hash, unspent.tx_pos, unspent.value);

        final spendable = Utxo(outpoint, false, keyIndex);

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

    final externalScriptHashes = keys.getExternalScriptHashes();
    final changeScriptHashes = keys.getChangeScriptHashes();

    final scriptHashes = externalScriptHashes.followedBy(changeScriptHashes);

    final client = await clientFuture;
    final responses = await Future.wait(scriptHashes.map((scriptHash) {
      final scriptHashHex = hex.encode(scriptHash);
      return client.blockchainScripthashGetBalance(scriptHashHex);
    }));

    final totalBalance = responses
        .map((response) => response.confirmed + response.unconfirmed)
        .fold(0, (p, c) => p + c);
    _balance = totalBalance;
  }

  /// Read wallet file from disk. Returns true if successful.
  Future<bool> loadFromDisk() async {
    // TODO
    return false;
  }

  Future<void> writeToDisk() async {
    // TODO
  }

  /// Generate new random seed.
  String newSeed() {
    // TODO: Randomize and can we move to bytes
    // rather than string (crypto API awkard)?
    return 'festival shrimp feel before tackle pyramid immense banner fire wash steel fiscal';
  }

  /// Generate new wallet from scratch.
  Future<void> generateWallet() async {
    bip39Seed = newSeed();
    keys = await Keys.construct(bip39Seed);
  }

  /// Attempts to load wallet from disk, else constructs a new wallet.
  Future<void> initialize() async {
    final loaded = await loadFromDisk();
    if (!loaded) {
      await generateWallet();
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
      BCHPrivateKey privateKey;
      if (utxo.externalOutput) {
        privateKey = keys.externalKeys[utxo.keyIndex];
      } else {
        privateKey = keys.changeKeys[utxo.keyIndex];
      }
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

    final changeAddress = keys.getChangeAddress(0);
    tx = tx
        .spendTo(recipientAddress, amount)
        .sendChangeTo(changeAddress)
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

    await client.blockchainTransactionBroadcast(transactionHex);
    return transaction;
  }
}
