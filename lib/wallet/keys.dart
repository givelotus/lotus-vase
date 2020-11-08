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
  final parentExternalKey = parentKey.deriveChildNumber(0);
  final parentChangeKey = parentKey.deriveChildNumber(1);
  final changeKeys = List<BCHPrivateKey>.generate(input.changeKeyCount,
      (index) => parentChangeKey.deriveChildNumber(index).privateKey);
  final externalKeys = List<BCHPrivateKey>.generate(input.externalKeyCount,
      (index) => parentExternalKey.deriveChildNumber(index).privateKey);
  final keys = Keys(externalKeys, changeKeys);

  input.sendPort.send(keys);
}

class Keys {
  Keys(this.externalKeys, this.changeKeys, {this.network = NetworkType.TEST});
  List<BCHPrivateKey> externalKeys;
  List<BCHPrivateKey> changeKeys;
  NetworkType network;
  // TODO: Cache addresses too?

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

  Address getExternalAddress(int index) {
    return externalKeys[index].toAddress(networkType: network);
  }

  Iterable<Uint8List> get externalScriptHashesPairs {
    return externalKeys.map((privateKey) {
      final address = privateKey.toAddress(networkType: network);
      return calculateScriptHash(address);
    });
  }

  Iterable<Uint8List> get externalScriptHashes {
    return externalKeys.map((privateKey) {
      final address = privateKey.toAddress(networkType: network);
      return calculateScriptHash(address);
    });
  }

  Iterable<Uint8List> get changeScriptHashes {
    return externalKeys.map((privateKey) {
      final address = privateKey.toAddress(networkType: network);
      return calculateScriptHash(address);
    });
  }

  Address getChangeAddress(int index) {
    return changeKeys[index].toAddress(networkType: network);
  }
}
