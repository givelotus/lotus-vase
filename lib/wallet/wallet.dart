import 'dart:typed_data';

import 'package:cashew/bitcoincash/bitcoincash.dart';
import 'package:cashew/wallet/vault.dart';
import 'package:pointycastle/digests/sha256.dart';
import 'package:convert/convert.dart';

import 'keys.dart';
import '../electrum/client.dart';

Uint8List calculateScriptHash(Address address) {
  final scriptPubkey = P2PKHLockBuilder(address).getScriptPubkey();
  final rawScriptPubkey = scriptPubkey.buffer;
  final digest = SHA256Digest().process(rawScriptPubkey);
  final reversedDigest = digest.reversed.toList() as Uint8List;
  return reversedDigest;
}

class Wallet {
  Wallet(this.walletPath, this.electrumFactory, {this.network});

  NetworkType network;
  String walletPath;
  ElectrumFactory electrumFactory;

  Keys keys;
  String bip39Seed;

  Vault _vault = Vault([]);

  final BigInt _feePerByte = BigInt.one;
  int _balance = 0;

  /// Gets the fees per byte.
  Future<BigInt> feePerByte() async {
    // TODO: Refresh from electrum.
    return _feePerByte;
  }

  /// Fetch UTXOs from electrum then update vault.
  Future<void> updateUtxos() async {
    final clientFuture = electrumFactory.build();
    final externalScriptHashes = keys.externalKeys.map((privateKey) {
      final address = privateKey.toAddress(networkType: network);
      return calculateScriptHash(address);
    });
    final changeScriptHashes = keys.changeKeys.map((privateKey) {
      final address = privateKey.toAddress(networkType: network);
      return calculateScriptHash(address);
    });

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

  Future<void> refreshBalance() async {
    final client = await electrumFactory.build();
    const exampleScriptHash =
        '8b01df4e368ea28f8dc0423bcf7a4923e3a12d307c875e47a0cfbf90b5c39161';
    final response =
        await client.blockchainScripthashGetBalance(exampleScriptHash);

    final totalBalance = response.confirmed + response.unconfirmed;
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
    return 'witch collapse practice feed shame open despair creek road again ice least';
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

  Future<Transaction> send(Address address, int satoshis) async {
    // TODO
  }
}
