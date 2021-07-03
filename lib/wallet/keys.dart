import 'dart:async';
import 'dart:isolate';
import 'dart:typed_data';
import 'package:collection/collection.dart';
import 'package:pointycastle/digests/sha256.dart';

import 'package:vase/lotus/lotus.dart';
import 'package:vase/constants.dart' as constants;

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
  bool isDeprecated;
  int keyIndex;

  KeyInfo(
      {this.key,
      this.isChange = false,
      this.isDeprecated = false,
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
  // Default electron cash path
  final bchParentKey = rootKey.deriveChildKey("m/44'/145'");

  final generateKeys =
      (priorList, generationRootKey, isChange, isDeprecated, number) =>
          priorList.followedBy(List<KeyInfo>.generate(
              childKeyCount,
              (index) => KeyInfo(
                    // TODO: Remove this keyIndex crap. it makes it very hard to handle
                    // finding various other values because we have this unnecessary
                    // surrogate key
                    keyIndex: index + priorList.length,
                    key: generationRootKey.deriveChildNumber(index).privateKey,
                    isChange: isChange,
                    isDeprecated: isDeprecated,
                    network: network,
                  )));

  final ecashParentKey = rootKey.deriveChildKey("m/44'/899'");
  final lotusParentKey = rootKey.deriveChildKey("m/44'/10605'");

// Deprecated keys were incorrectly missing part of the deriviation path. We now
// include them only so that they load up the balance, but won't be used by the
// code elsewhere for change or receiving. We need to generally clean up this
// keystore stuff, as all the state is a bit annoying to deal with elsewhere.
  final withDeprecatedExternalKeys = generateKeys(<KeyInfo>[],
      bchParentKey.deriveChildNumber(0), false, true, childKeyCount);
  final withDeprecatedChangeKeys = generateKeys(withDeprecatedExternalKeys,
      bchParentKey.deriveChildNumber(1), true, true, childKeyCount);
  final withLegacyReceiveKeys = generateKeys(
      withDeprecatedChangeKeys,
      bchParentKey.deriveChildNumber(0, hardened: true).deriveChildNumber(0),
      false,
      true,
      childKeyCount);
  final withLegacyChangeKeys = generateKeys(
      withLegacyReceiveKeys,
      bchParentKey.deriveChildNumber(0, hardened: true).deriveChildNumber(1),
      true,
      true,
      childKeyCount);
  final withEcashDerivationKeys = generateKeys(
      withLegacyChangeKeys,
      ecashParentKey.deriveChildNumber(0, hardened: true).deriveChildNumber(0),
      false,
      true,
      childKeyCount);
  final withEcashChangeKeys = generateKeys(
      withEcashDerivationKeys,
      ecashParentKey.deriveChildNumber(0, hardened: true).deriveChildNumber(1),
      true,
      true,
      childKeyCount);
  final withLotusDerivationKeys = generateKeys(
      withEcashChangeKeys,
      lotusParentKey.deriveChildNumber(0, hardened: true).deriveChildNumber(0),
      false,
      false,
      childKeyCount);
  final withLotusChangeKeys = generateKeys(
      withLotusDerivationKeys,
      lotusParentKey.deriveChildNumber(0, hardened: true).deriveChildNumber(1),
      true,
      false,
      childKeyCount);

  return withLotusChangeKeys.toList();
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
  int totalKeys;

  Keys(this.seed, this.rootKey, this.keys,
      {this.network = constants.network,
      this.totalKeys = constants.defaultNumberOfChildKeys});

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
