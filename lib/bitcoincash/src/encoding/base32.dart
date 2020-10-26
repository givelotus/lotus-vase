import 'dart:core';
import 'dart:collection';

import '../exceptions.dart';

// Charset for converting to base32
const charset = [
  'q',
  'p',
  'z',
  'r',
  'y',
  '9',
  'x',
  '8',
  'g',
  'f',
  '2',
  't',
  'v',
  'd',
  'w',
  '0',
  's',
  '3',
  'j',
  'n',
  '5',
  '4',
  'k',
  'h',
  'c',
  'e',
  '6',
  'm',
  'u',
  'a',
  '7',
  'l',
];

// Charset for converting from base32
const reversedCharset = [
  -1,
  -1,
  -1,
  -1,
  -1,
  -1,
  -1,
  -1,
  -1,
  -1,
  -1,
  -1,
  -1,
  -1,
  -1,
  -1,
  -1,
  -1,
  -1,
  -1,
  -1,
  -1,
  -1,
  -1,
  -1,
  -1,
  -1,
  -1,
  -1,
  -1,
  -1,
  -1,
  -1,
  -1,
  -1,
  -1,
  -1,
  -1,
  -1,
  -1,
  -1,
  -1,
  -1,
  -1,
  -1,
  -1,
  -1,
  -1,
  15,
  -1,
  10,
  17,
  21,
  20,
  26,
  30,
  7,
  5,
  -1,
  -1,
  -1,
  -1,
  -1,
  -1,
  -1,
  29,
  -1,
  24,
  13,
  25,
  9,
  8,
  23,
  -1,
  18,
  22,
  31,
  27,
  19,
  -1,
  1,
  0,
  3,
  16,
  11,
  28,
  12,
  14,
  6,
  4,
  2,
  -1,
  -1,
  -1,
  -1,
  -1,
  -1,
  29,
  -1,
  24,
  13,
  25,
  9,
  8,
  23,
  -1,
  18,
  22,
  31,
  27,
  19,
  -1,
  1,
  0,
  3,
  16,
  11,
  28,
  12,
  14,
  6,
  4,
  2,
  -1,
  -1,
  -1,
  -1,
  -1
];

/// ToBase32 converts an input byte array into a base32 string.  It expects the
/// byte array to be 5-bit packed.
String toBase32(List<int> input) {
  final buffer = StringBuffer();

  for (final i in input) {
    if (i < 0 || i >= charset.length) {
      throw AddressFormatException('Illegal value $i');
    }
    buffer.write(charset[i]);
  }
  return buffer.toString();
}

/// FromBase32 takes a string in base32 format and returns a byte array that is
/// 5-bit packed.
List<int> fromBase32(String input) {
  var result = <int>[];

  for (final c in input.runes) {
    if (c >= reversedCharset.length) {
      throw AddressFormatException('Illegal value $c');
    }
    final val = reversedCharset[c];
    if (val == -1) {
      throw AddressFormatException('invalid base32 input string');
    }
    result.add(val);
  }
  return result;
}
