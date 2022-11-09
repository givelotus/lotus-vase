import 'package:collection/collection.dart';

import 'utils.dart';
import '../exceptions.dart';

const BASE58_ALPHABET =
    '123456789ABCDEFGHJKLMNPQRSTUVWXYZabcdefghijkmnopqrstuvwxyz';
const MAP_BASE58 = [
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
  -1,
  0,
  1,
  2,
  3,
  4,
  5,
  6,
  7,
  8,
  -1,
  -1,
  -1,
  -1,
  -1,
  -1,
  -1,
  9,
  10,
  11,
  12,
  13,
  14,
  15,
  16,
  -1,
  17,
  18,
  19,
  20,
  21,
  -1,
  22,
  23,
  24,
  25,
  26,
  27,
  28,
  29,
  30,
  31,
  32,
  -1,
  -1,
  -1,
  -1,
  -1,
  -1,
  33,
  34,
  35,
  36,
  37,
  38,
  39,
  40,
  41,
  42,
  43,
  -1,
  44,
  45,
  46,
  47,
  48,
  49,
  50,
  51,
  52,
  53,
  54,
  55,
  56,
  57,
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
];

List<int> decode(String input) {
  if (input.isEmpty) {
    return <int>[];
  }
  final inputBytes = List<int>.from(input.runes);
  // Count leading zeros. 48 = 0 in ASCII/Utf8
  var zeros = 0;
  while (zeros < inputBytes.length && inputBytes[zeros] == 49) {
    ++zeros;
  }

  // Convert the base58-encoded ASCII chars to a base58 byte sequence (base58 digits).
  final buffer = List<int>.filled(inputBytes.length * 733 ~/ 1000 + 1, 0);
  var length = 0;
  for (var idx = 0; idx < inputBytes.length; ++idx) {
    var c = inputBytes[idx];
    var carry = c < 256 ? MAP_BASE58[c] : -1;
    if (carry < 0) {
      throw AddressFormatException(
          'Illegal character ${inputBytes[idx]} at position ${idx.toString()}');
    }
    var i = 0;
    for (var bIdx = buffer.length - 1;
        (carry != 0 || i < length) && (bIdx >= 0);
        bIdx--, i++) {
      carry += 58 * buffer[bIdx];
      buffer[bIdx] = (carry % 256);
      carry ~/= 256;
    }
    assert(carry == 0);
    length = i;
  }
  // Return decoded data (including original number of leading zeros).
  return buffer.sublist(buffer.length - length - zeros);
}

/// Encodes the given bytes as a base58 string (no checksum is appended).
String encode(List<int> input) {
  if (input.isEmpty) {
    return '';
  }

  // Count leading zeros.
  var zeros = 0;
  while (zeros < input.length && input[zeros] == 0) {
    ++zeros;
  }

  final size = input.length * 138 ~/ 100 + 1;
  final b58 = List<int>.filled(size, 0);

  // Process the bytes.
  var length = 0;
  for (var idx = zeros; idx < input.length; idx++) {
    var carry = input[idx];
    var i = 0;
    // Apply "b58 = b58 * 256 + ch".
    for (var bIdx = b58.length - 1;
        (carry != 0 || i < length) && (bIdx >= 0);
        i++, bIdx--) {
      carry += 256 * b58[bIdx];
      b58[bIdx] = carry % 58;
      carry ~/= 58;
    }
    assert(carry == 0);
    length = i;
  }

  final outputBuffer = StringBuffer();
  for (; zeros > 0; zeros--) {
    // Write zero in ASCII
    outputBuffer.writeCharCode(49);
  }

  for (var i = b58.length - length; i < b58.length; i++) {
    var d = b58[i];
    outputBuffer.writeCharCode(BASE58_ALPHABET.codeUnitAt(d));
  }
  return outputBuffer.toString();
}

List<int> decodeChecked(String input) {
  var decoded = decode(input);
  if (decoded.length < 4) {
    throw AddressFormatException('Input too short');
  }

  var data = decoded.sublist(0, decoded.length - 4);
  var checksum = decoded.sublist(decoded.length - 4);
  var actualChecksum = sha256Twice(data).sublist(0, 4);
  if (!ListEquality().equals(checksum, actualChecksum)) {
    throw BadChecksumException('Checksum does not validate');
  }
  return data;
}
