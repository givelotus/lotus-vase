import 'dart:convert';
import 'dart:typed_data';

import 'package:hex/hex.dart';

import '../networks.dart';

import 'base58check.dart' as bs58check;
import 'utils.dart' as utils;

// TODO: This entire class should be using Uint8List entirely.
abstract class CKDSerializer {
  static final List<int> MAINNET_PUBLIC = HEX.decode('0488B21E');
  static final List<int> MAINNET_PRIVATE = HEX.decode('0488ADE4');
  static final List<int> TESTNET_PUBLIC = HEX.decode('043587CF');
  static final List<int> TESTNET_PRIVATE = HEX.decode('04358394');

  int? _nodeDepth;
  var _parentFingerprint = List.filled(4, 0, growable: false); // Uint32
  var _childNumber = List.filled(4, 0, growable: false); // Uint32
  var _chainCode = List.filled(32, 0, growable: false); // Uint8List(32)
  var _keyHex = List.filled(33, 0, growable: false); // Uint8List(33)
  var _versionBytes = List.filled(4, 0, growable: false); // Uint32
  NetworkType? _networkType;
  KeyType? _keyType;

  void deserialize(String vector) {
    var decoded = bs58check.decodeChecked(vector);

    _versionBytes = decoded.sublist(0, 4);
    _nodeDepth = decoded[4];
    _parentFingerprint = decoded.sublist(5, 9);
    _childNumber = decoded.sublist(9, 13);
    _chainCode = decoded.sublist(13, 45);
    _keyHex = decoded.sublist(45, 78);

    // ignore: unused_local_variable
    var version =
        HEX.encode(_versionBytes.map((elem) => elem!.toUnsigned(8)).toList());
  }

  // TODO: FIX Rewrite using the Buffer class
  String serialize() {
    var versionBytes = getVersionBytes();

    var serializedKey = List.filled(78, 0);
    serializedKey.setRange(0, 4, versionBytes);
    serializedKey.setRange(4, 5, [_nodeDepth!]);
    serializedKey.setRange(5, 9, _parentFingerprint);
    serializedKey.setRange(9, 13, _childNumber);
    serializedKey.setRange(13, 45, _chainCode);
    serializedKey.setRange(45, 78, _keyHex);

    // checksum calculation... doubleSha
    var doubleShaAddr = utils.sha256Twice(serializedKey);
    var checksum = doubleShaAddr.sublist(0, 4);

    return bs58check.encode(serializedKey + checksum);
  }

  List<int> getVersionBytes() {
    switch (_networkType) {
      case NetworkType.MAIN:
        {
          return _keyType == KeyType.PUBLIC ? MAINNET_PUBLIC : MAINNET_PRIVATE;
        }
      case NetworkType.REGTEST:
      case NetworkType.SCALINGTEST:
      case NetworkType.TEST:
        {
          return _keyType == KeyType.PUBLIC ? TESTNET_PUBLIC : TESTNET_PRIVATE;
        }
      default:
        {
          return _keyType == KeyType.PUBLIC ? TESTNET_PUBLIC : TESTNET_PRIVATE;
        }
    }
  }

  set chainCode(List<int> bytes) {
    _chainCode = bytes;
  }

  NetworkType? get networkType => _networkType;

  set networkType(NetworkType? value) {
    _networkType = value;
  }

  List<int> get chainCode {
    return _chainCode;
  }

  /// Initialize the key from a byte buffer
  ///
  /// `bytes` - Hexadecimal version of key encoded as a byte buffer
  set keyBuffer(List<int> bytes) {
    var paddedKey = List<int>.filled(33, 0);
    paddedKey.setRange(33 - bytes.length, 33, bytes);
    _keyHex = paddedKey;
  }

  /// Retrieves the key as a byte buffer
  ///
  List<int> get keyBuffer {
    // TODO: Why does this need to be converted to a Uin8list and back?
    // Simply duplicating the lists broke lots of the code.
    return Uint8List.fromList(_keyHex as List<int>).toList();
  }

  set versionBytes(List<int> bytes) {
    _versionBytes = bytes;
  }

  List<int> get versionBytes {
    return _versionBytes;
  }

  set nodeDepth(int? depth) {
    _nodeDepth = depth;
  }

  int? get nodeDepth {
    return _nodeDepth;
  }

  set parentFingerprint(List<int> bytes) {
    _parentFingerprint = bytes;
  }

  List<int> get parentFingerprint {
    return _parentFingerprint;
  }

  set childNumber(List<int> bytes) {
    _childNumber = bytes;
  }

  List<int> get childNumber {
    return _childNumber;
  }

  KeyType? get keyType => _keyType;

  set keyType(KeyType? value) {
    _keyType = value;
  }
}
