import 'dart:typed_data';
import 'package:collection/collection.dart';

import 'exceptions.dart';
import 'networks.dart';
import 'encoding/base58check.dart' as base58;
import 'encoding/utils.dart';

const TOKEN_NAME = 'lotus';
const ALPHABET = '123456789ABCDEFGHJKLMNPQRSTUVWXYZabcdefghijkmnopqrstuvwxyz';

enum XAddressType {
  ScriptPubKey,
}

class XAddress {
  XAddressType type;
  NetworkType network;
  List<int> payload;

  String prefix;

  XAddress(
      {this.type = XAddressType.ScriptPubKey,
      this.network,
      this.payload,
      this.prefix = TOKEN_NAME});

  XAddress.Decode(String address) {
    final splitLocation = address.indexOf(RegExp(r'[A-Z_]'));
    prefix = address.substring(0, splitLocation);
    network =
        _GetNetworkType(address.substring(splitLocation, splitLocation + 1));
    final decodedBytes = base58.decode(address.substring(splitLocation + 1));
    type = _GetAddressType(decodedBytes.first);
    payload = decodedBytes.sublist(1, decodedBytes.length - 4);
    final checksum = _CreateChecksum(this);
    final legacyChecksum = _CreateChecksumLegacy(this);
    final decodedChecksum = decodedBytes.sublist(decodedBytes.length - 4);

    if (!ListEquality().equals(decodedChecksum, checksum) &&
        !ListEquality().equals(decodedChecksum, legacyChecksum)) {
      throw AddressFormatException('Invalid checksum');
    }
  }

  int get typeByte {
    switch (type) {
      case XAddressType.ScriptPubKey:
        return 0;
      default:
        throw AddressFormatException('Unknown address type');
    }
  }

  String get networkByte {
    switch (network) {
      case NetworkType.MAIN:
        return '_';
      case NetworkType.TEST:
        return 'T';
      case NetworkType.REGTEST:
        return 'R';
      default:
        throw AddressFormatException('Unknown network type');
    }
  }

  /// Encodes the given bytes as an xaddress string.
  String Encode() {
    final checkBytes = _CreateChecksum(this);
    final encodedPayload = _EncodePayload(this, checkBytes);
    final outputAddress = StringBuffer();
    outputAddress.write(prefix);
    outputAddress.write(networkByte);
    outputAddress.write(encodedPayload);
    return outputAddress.toString();
  }
}

List<int> _CreateChecksum(XAddress content) {
  final buffer = BytesBuilder();
  buffer.add(List.from(content.prefix.runes));
  buffer.addByte(content.networkByte.runes.first);
  buffer.addByte(content.typeByte);
  buffer.add(content.payload);
  final data = buffer.takeBytes();
  final digest = sha256(data);
  return digest.sublist(0, 4);
}

List<int> _CreateChecksumLegacy(XAddress content) {
  final buffer = BytesBuilder();
  buffer.add(varintBufNum(content.prefix.runes.length));
  buffer.add(List.from(content.prefix.runes));
  buffer.addByte(content.networkByte.runes.first);
  buffer.addByte(content.typeByte);
  buffer.add(varintBufNum(content.payload.length));
  buffer.add(content.payload);
  final data = buffer.takeBytes();
  final digest = sha256(data);
  return digest.sublist(0, 4);
}

String _EncodePayload(XAddress content, List<int> checkBytes) {
  final buffer = BytesBuilder();
  buffer.addByte(content.typeByte);
  buffer.add(content.payload);
  buffer.add(checkBytes);
  final bytes = buffer.takeBytes();
  final encodedPayload = base58.encode(bytes);
  return encodedPayload;
}

NetworkType _GetNetworkType(String network) {
  switch (network) {
    case '_':
      return NetworkType.MAIN;
    case 'T':
      return NetworkType.TEST;
    case 'R':
      return NetworkType.REGTEST;
    default:
      throw AddressFormatException('Unknown network type');
  }
}

XAddressType _GetAddressType(int type) {
  switch (type) {
    case 0:
      return XAddressType.ScriptPubKey;
    default:
      throw AddressFormatException('Unknown address type');
  }
}
