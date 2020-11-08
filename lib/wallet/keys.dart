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

void _constructKeys(KeyIsolateInput input) {
  final seedHex = Mnemonic().toSeedHex(input.seed);
  final rootKey = HDPrivateKey.fromSeed(seedHex, input.network);

  // TODO: Do this with child numbers
  final parentKey = rootKey.deriveChildKey("m/44'/145'");

  // Generate external keys, addresses and script hashes
  final parentExternalKey = parentKey.deriveChildNumber(0);
  final externalKeys = List<BCHPrivateKey>.generate(input.externalKeyCount,
      (index) => parentExternalKey.deriveChildNumber(index).privateKey);
  final externalAddresses = externalKeys
      .map((key) => key.toAddress(networkType: input.network))
      .toList();
  final externalScriptHashes =
      externalAddresses.map((address) => calculateScriptHash(address)).toList();

  // Generate change keys, addresses and script hashes
  final parentChangeKey = parentKey.deriveChildNumber(1);
  final changeKeys = List<BCHPrivateKey>.generate(input.changeKeyCount,
      (index) => parentChangeKey.deriveChildNumber(index).privateKey);
  final changeAddresses = externalKeys
      .map((key) => key.toAddress(networkType: input.network))
      .toList();
  final changeScriptHashes =
      changeAddresses.map((address) => calculateScriptHash(address)).toList();

  final keys = Keys(externalKeys, changeKeys, externalAddresses,
      changeAddresses, externalScriptHashes, changeScriptHashes);

  input.sendPort.send(keys);
}

class Keys {
  Keys(this.externalKeys, this.changeKeys, this.externalAddresses,
      this.changeAddresses, this.externalScriptHashes, this.changeScriptHashes,
      {this.network = NetworkType.TEST});
  NetworkType network;

  List<BCHPrivateKey> externalKeys;
  List<Address> externalAddresses;
  List<Uint8List> externalScriptHashes;

  List<BCHPrivateKey> changeKeys;
  List<Address> changeAddresses;
  List<Uint8List> changeScriptHashes;

  /// Find the index of a script hash.
  int findIndexByScriptHash(Uint8List scriptHash, bool isExternal) {
    if (isExternal) {
      return externalScriptHashes.indexOf(scriptHash);
    } else {
      return changeScriptHashes.indexOf(scriptHash);
    }
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
