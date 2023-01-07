import 'dart:core';
import 'dart:typed_data';

import 'package:dartz/dartz.dart';

// Pre-Init
const lutHex4b = [
  "0",
  "1",
  "2",
  "3",
  "4",
  "5",
  "6",
  "7",
  "8",
  "9",
  "a",
  "b",
  "c",
  "d",
  "e",
  "f",
];

final lutTuple = initLut8b();
final lutHex8b = lutTuple.value1;
final lutBin8b = lutTuple.value2;

Tuple2<List<String>, Map<String, int>> initLut8b() {
  final hex8b = List<String>.filled(0x100, '');
  final Map<String, int> bin8b = {};
  for (var n = 0; n < 0x100; n++) {
    final hex = '${lutHex4b[(n >>> 4) & 0xf]}${lutHex4b[n & 0xf]}';
    hex8b[n] = hex;
    bin8b[hex] = n;
  }
  return Tuple2(hex8b, bin8b);
}
// End Pre-Init

String toHex(List<int> buffer) {
  String out = "";
  for (var idx = 0, edx = buffer.length; idx < edx; ++idx) {
    out += lutHex8b[int.parse(buffer[idx].toString())];
  }
  return out;
}

String toHexRev(List<int> buffer) {
  String out = "";
  for (var idx = buffer.length - 1; idx >= 0; --idx) {
    out += lutHex8b[int.parse(buffer[idx].toString())];
  }
  return out;
}

Uint8List fromHex(String str) {
  if ((str.length & 1) != 0) {
    throw SimpleError('Odd hex length: $str');
  }
  final nBytes = str.length >> 1;
  final array = Uint8List(nBytes);
  for (var idx = 0; idx < str.length; idx += 2) {
    final pair = str.substring(idx, 2);
    final byte = lutBin8b[pair];
    if (byte == null) {
      throw SimpleError('Invalid hex pair: $pair, at index $idx');
    }
    array[idx >> 1] = byte;
  }
  return array;
}

Uint8List fromHexRev(String str) {
  final array = fromHex(str);
  array.reversed.toList();
  return array;
}

class SimpleError extends Error {
  final String message;
  SimpleError(this.message);
  @override
  String toString() => message;
}
