import 'dart:async';
import 'dart:isolate';
import 'dart:typed_data';
import 'dart:convert';

import 'package:cashew/bitcoincash/bitcoincash.dart';
import 'package:pointycastle/digests/sha256.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:json_annotation/json_annotation.dart';

part 'keys.g.dart';

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

const SCHEMA_VERSION = 'schema_version';
const KEY_PREFIX = 'keys_';
const METADATA = 'metadata';
const KEY_COUNT = 'key_count';

Future<String> readSchemaVersion() {
  final storage = FlutterSecureStorage();
  return storage.read(key: SCHEMA_VERSION);
}

@JsonSerializable(nullable: false)
class KeyStorageMetadata {
  KeyStorageMetadata(this.keyCount);

  int keyCount;

  static Future<KeyStorageMetadata> readFromDisk() async {
    final storage = FlutterSecureStorage();
    final storageMetadataString =
        await storage.read(key: KEY_PREFIX + METADATA);
    final storageMetadataJson = jsonDecode(storageMetadataString);
    return KeyStorageMetadata.fromJson(storageMetadataJson);
  }

  factory KeyStorageMetadata.fromJson(Map<String, dynamic> json) =>
      _$KeyStorageMetadataFromJson(json);
  Map<String, dynamic> toJson() => _$KeyStorageMetadataToJson(this);
}

@JsonSerializable(nullable: false)
class StoredKey {
  StoredKey(this.privateKey, this.isChange);

  String privateKey;
  bool isChange;

  static Future<StoredKey> readFromDisk(int number) async {
    final storage = FlutterSecureStorage();
    final storageMetadataString =
        await storage.read(key: KEY_PREFIX + number.toString());
    final storageMetadataJson = jsonDecode(storageMetadataString);
    return StoredKey.fromJson(storageMetadataJson);
  }

  KeyInfo toKeyInfo(NetworkType network) {
    final key = BCHPrivateKey.fromWIF(privateKey);
    return KeyInfo(key: key, isChange: isChange, network: network);
  }

  factory StoredKey.fromJson(Map<String, dynamic> json) =>
      _$StoredKeyFromJson(json);
  Map<String, dynamic> toJson() => _$StoredKeyToJson(this);
}

class Keys {
  Keys(this.keys, {this.network = NetworkType.TEST});
  NetworkType network;

  List<KeyInfo> keys;

  static Future<Keys> readFromDisk(NetworkType network) async {
    // Check schema version
    final schemaVersion = await readSchemaVersion();
    if (schemaVersion != '0.1.0') {
      throw Exception('Unsupported version');
    }

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

  static Future<Keys> construct(String seedHex) async {
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
        _constructKeys, KeyIsolateInput(seedHex, receivePort.sendPort));

    return await completer.future;
  }
}
