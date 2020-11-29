import 'dart:async';
import 'dart:isolate';
import 'dart:typed_data';

import 'package:cashew/bitcoincash/bitcoincash.dart';
import 'package:pointycastle/digests/sha256.dart';

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

  input.sendPort.send(Keys(
      input.seed, rootKey, externalKeys.followedBy(changeKeys).toList(),
      network: input.network));
}

class Keys {
  NetworkType network;
  HDPrivateKey rootKey;
  String seed;
  List<KeyInfo> keys;

  Keys(this.seed, this.rootKey, this.keys, {this.network = NetworkType.TEST});

  /// Find the index of a script hash.
  KeyInfo findKeyByScriptHash(Uint8List scriptHash) {
    final keyInfo =
        keys.firstWhere((keyInfo) => scriptHash == keyInfo.scriptHash);
    return keyInfo;
  }

  static Future<Keys> construct(String seed) async {
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
        seed,
        receivePort.sendPort,
      ),
    );

    return await completer.future;
  }
}
