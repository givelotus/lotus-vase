import 'dart:async';
import 'dart:isolate';
import 'dart:typed_data';

import 'package:cashew/bitcoincash/bitcoincash.dart';
import 'package:cashew/wallet/storage/seed.dart';
import 'package:pointycastle/digests/sha256.dart';

import 'storage/keys.dart';

Uint8List calculateScriptHash(Address address) {
  final scriptPubkey = P2PKHLockBuilder(address).getScriptPubkey();
  final rawScriptPubkey = scriptPubkey.buffer;
  final digest = SHA256Digest().process(rawScriptPubkey);
  final reversedDigest = Uint8List.fromList(digest.reversed.toList());
  return reversedDigest;
}

class KeyIsolateInput {
  KeyIsolateInput(this.seed, this.sendPort,
      {this.network = NetworkType.TEST,
      this.changeKeyCount = 1,
      this.externalKeyCount = 1});
  String seed;
  SendPort sendPort;
  NetworkType network;
  int changeKeyCount;
  int externalKeyCount;
}

class KeyInfo {
  BCHPrivateKey key;
  Address address;
  Uint8List scriptHash;
  bool isChange;

  KeyInfo(
      {this.key,
      this.isChange = false,
      NetworkType network = NetworkType.TEST}) {
    address = key.toAddress(networkType: network);
    scriptHash = calculateScriptHash(address);
  }
}

void _constructKeys(KeyIsolateInput input) {
  final seedHex = Mnemonic().toSeedHex(input.seed);
  //TOOD: Why do we use HEX everywhere? This library needs to be fixed.
  final rootKey = HDPrivateKey.fromSeed(seedHex, input.network);

  // TODO: Do this with child numbers
  final parentKey = rootKey.deriveChildKey("m/44'/145'");

  // Generate external keys, addresses and script hashes
  final parentExternalKey = parentKey.deriveChildNumber(0);

  final externalKeys = List<KeyInfo>.generate(
      input.externalKeyCount,
      (index) => KeyInfo(
          key: parentExternalKey.deriveChildNumber(index).privateKey,
          network: input.network));

  final parentChangeKey = parentKey.deriveChildNumber(1);
  final changeKeys = List<KeyInfo>.generate(
      input.externalKeyCount,
      (index) => KeyInfo(
            key: parentChangeKey.deriveChildNumber(index).privateKey,
            isChange: true,
            network: input.network,
          ));

  input.sendPort.send(Keys(externalKeys.followedBy(changeKeys).toList(),
      network: input.network));
}

class Keys {
  Keys(this.keys, {this.network = NetworkType.TEST});
  NetworkType network;

  List<KeyInfo> keys;

  Future<void> writeToDisk() async {
    // Write private keys
    final keyWrites = keys.asMap().entries.map((entry) {
      final index = entry.key;
      final keyInfo = entry.value;
      final storedKey = StoredKey.fromKeyInfo(keyInfo);
      return storedKey.writeToDisk(index);
    });
    await Future.wait(keyWrites);

    // Write metadata
    final metadata = KeyStorageMetadata(keys.length);
    await metadata.writeToDisk();
  }

  static Future<Keys> readFromDisk(NetworkType network) async {
    // Read metadata
    final metadata = await KeyStorageMetadata.readFromDisk();
    final keyCount = metadata.keyCount;

    // Read private keys
    final storedKeyFutures = List<Future<StoredKey>>.generate(
        keyCount, (index) => StoredKey.readFromDisk(index));
    final storedKeys = await Future.wait(storedKeyFutures);

    // Convert to key info
    final keyInfo =
        storedKeys.map((storedKey) => storedKey.toKeyInfo(network)).toList();

    return Keys(keyInfo, network: network);
  }

  /// Find the index of a script hash.
  KeyInfo findKeyByScriptHash(Uint8List scriptHash) {
    final keyInfo =
        keys.firstWhere((keyInfo) => scriptHash == keyInfo.scriptHash);
    return keyInfo;
  }

  static Future<Keys> construct(Bip39Seed seed) async {
    final receivePort = ReceivePort();

    // Construct key completer
    final completer = Completer();
    var completedKeys;
    receivePort.listen((keys) {
      completedKeys = keys;
      receivePort.close();
    }, onDone: () => completer.complete(completedKeys));

    // Start isolate
    await Isolate.spawn(
      _constructKeys,
      KeyIsolateInput(
        seed.seed,
        receivePort.sendPort,
      ),
    );

    return await completer.future;
  }
}
