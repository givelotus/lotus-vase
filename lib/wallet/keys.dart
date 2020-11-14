import 'dart:async';
import 'dart:isolate';
import 'dart:typed_data';

import 'package:cashew/bitcoincash/bitcoincash.dart';
import 'package:pointycastle/digests/sha256.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

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

const KEY_COUNT = 'key_count';
const KEY_PREFIX = 'key';
const CHANGE_PREFIX = 'change';
const EXTERNAL_PREFIX = 'external';

const CHANGE_FLAG = 'c';

class Keys {
  Keys(this.keys, {this.network = NetworkType.TEST});
  NetworkType network;

  List<KeyInfo> keys;

  static Future<Keys> readFromDisk(NetworkType network) async {
    final storage = FlutterSecureStorage();
    final keyCount = int.parse(await storage.read(key: KEY_COUNT));
    final readFutures = List<Future<String>>.generate(keyCount,
        (index) => storage.read(key: KEY_PREFIX + '_' + index.toString()));
    final keyInfo = (await Future.wait(readFutures)).map((data) {
      final isChange = data[0] == CHANGE_FLAG;
      final keyString = data.substring(1);
      final key = BCHPrivateKey.fromHex(keyString, network);
      return KeyInfo(key: key, isChange: isChange, network: network);
    }).toList();

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
