import 'dart:async';
import 'dart:isolate';
import 'dart:typed_data';
import 'package:collection/collection.dart';
import 'package:pointycastle/digests/sha256.dart';

import 'package:cashew/bitcoincash/bitcoincash.dart';
import 'package:cashew/constants.dart' as constants;

Uint8List calculateScriptHash(Address address) {
  final p2pkhBuilder = P2PKHLockBuilder(address);
  final script = p2pkhBuilder.getScriptPubkey();
  final scriptHash = SHA256Digest().process(script.buffer).toList();
  return Uint8List.fromList(scriptHash.reversed.toList());
}

class KeyIsolateInput {
  KeyIsolateInput(this.seed, this.sendPort,
      {this.network = constants.network,
      this.childKeyCount = constants.defaultNumberOfChildKeys});
  String seed;
  SendPort sendPort;
  NetworkType network;
  int childKeyCount;
}

class KeyInfo {
  BCHPrivateKey key;
  Address address;
  Uint8List scriptHash;
  bool isChange;
  int keyIndex;

  KeyInfo(
      {this.key,
      this.isChange = false,
      this.keyIndex,
      NetworkType network = constants.network}) {
    address = key.toAddress(networkType: network);
    scriptHash = calculateScriptHash(address);
  }
}

List<KeyInfo> constructChildKeys(
    {HDPrivateKey rootKey,
    int childKeyCount,
    NetworkType network = constants.network}) {
  // TODO: Do this with child numbers
  final parentKey = rootKey.deriveChildKey("m/44'/145'");

  // Generate external keys, addresses and script hashes
  final parentExternalKey = parentKey.deriveChildNumber(0);

  final externalKeys = List<KeyInfo>.generate(
      childKeyCount,
      (index) => KeyInfo(
          keyIndex: index,
          key: parentExternalKey.deriveChildNumber(index).privateKey,
          network: network));

  final parentChangeKey = parentKey.deriveChildNumber(1);
  final changeKeys = List<KeyInfo>.generate(
      childKeyCount,
      (index) => KeyInfo(
            // TODO: Remove this keyIndex crap. it makes it very hard to handle
            // finding various other values because we have this unnecessary
            // surrogate key
            keyIndex: index + childKeyCount,
            key: parentChangeKey.deriveChildNumber(index).privateKey,
            isChange: true,
            network: network,
          ));

  return externalKeys.followedBy(changeKeys).toList();
}

// Construct a brand new set of keys from a seed over a worker. Processing a
// seed to an HDPrivateKey is fairly time consuming, thus it is done this way.cas
void _constructKeys(KeyIsolateInput input) {
  final seedHex = Mnemonic().toSeedHex(input.seed);
  //TOOD: Why do we use HEX everywhere? This library needs to be fixed.
  final rootKey = HDPrivateKey.fromSeed(seedHex, input.network);

  final childKeys = constructChildKeys(
      rootKey: rootKey,
      childKeyCount: input.childKeyCount,
      network: input.network);

  input.sendPort
      .send(Keys(input.seed, rootKey, childKeys, network: input.network));
}

class Keys {
  NetworkType network;
  HDPrivateKey rootKey;
  String seed;
  List<KeyInfo> keys;

  Keys(this.seed, this.rootKey, this.keys, {this.network = constants.network});

  /// Find the index of a script hash.
  KeyInfo findKeyByScriptHash(Uint8List scriptHash) {
    final keyInfo = keys.firstWhere(
        (keyInfo) => ListEquality().equals(scriptHash, keyInfo.scriptHash));
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
