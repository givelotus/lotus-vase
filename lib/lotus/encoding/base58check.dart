import 'dart:typed_data';
import 'dart:convert';

import 'package:collection/collection.dart';

import 'utils.dart';
import '../exceptions.dart';

/*
    Ported from bitcoinj-sv 0.1.1
    by Stephan February
    7 April 2019
 */

var ALPHABET = '123456789ABCDEFGHJKLMNPQRSTUVWXYZabcdefghijkmnopqrstuvwxyz';

List<int> decode(String input) {
  if (input.isEmpty) {
    return <int>[];
  }

  var encodedInput = utf8.encode(input);
  var uintAlphabet = utf8.encode(ALPHABET);

  var INDEXES = List<int>(128)..fillRange(0, 128, -1);
  for (var i = 0; i < ALPHABET.length; i++) {
    INDEXES[uintAlphabet[i]] = i;
  }

  // Convert the base58-encoded ASCII chars to a base58 byte sequence (base58 digits).
  var input58 = List<int>(encodedInput.length);
  input58.fillRange(0, input58.length, 0);
  for (var i = 0; i < encodedInput.length; ++i) {
    var c = encodedInput[i];
    var digit = c < 128 ? INDEXES[c] : -1;
    if (digit < 0) {
      var buff = List<int>(1)..add(c);
      var invalidChar = utf8.decode(buff);
      throw AddressFormatException(
          'Illegal character ' + invalidChar + ' at position ' + i.toString());
    }
    input58[i] = digit;
  }

  // Count leading zeros.
  var zeros = 0;
  while (zeros < input58.length && input58[zeros] == 0) {
    ++zeros;
  }

  // Convert base-58 digits to base-256 digits.
  var decoded = List<int>(encodedInput.length);
  decoded.fillRange(0, decoded.length, 0);
  var outputStart = decoded.length;
  for (var inputStart = zeros; inputStart < input58.length;) {
    decoded[--outputStart] = divmod(input58, inputStart, 58, 256);
    if (input58[inputStart] == 0) {
      ++inputStart; // optimization - skip leading zeros
    }
  }

  // Ignore extra leading zeroes that were added during the calculation.
  while (outputStart < decoded.length && decoded[outputStart] == 0) {
    ++outputStart;
  }

  // Return decoded data (including original number of leading zeros).
  return decoded.sublist(outputStart - zeros, decoded.length);
}

/// Divides a number, represented as an array of bytes each containing a single digit
/// in the specified base, by the given divisor. The given number is modified in-place
/// to contain the quotient, and the return value is the remainder.
int divmod(List<int> number, int firstDigit, int base, int divisor) {
// this is just long division which accounts for the base of the input digits
  var remainder = 0;
  for (var i = firstDigit; i < number.length; i++) {
    var digit = number[i] & 0xFF;
    var temp = remainder * base + digit;
    number[i] = temp ~/ divisor;
    remainder = temp % divisor;
  }

  return remainder.toSigned(8);
}

/// Encodes the given bytes as a base58 string (no checksum is appended).
Uint8List encode(List<int> encodedInput) {
  var uintAlphabet = utf8.encode(ALPHABET);
  var ENCODED_ZERO = uintAlphabet[0];

  if (encodedInput.isEmpty) {
    return Uint8List(0);
  }

  // Count leading zeros.
  var zeros = 0;
  while (zeros < encodedInput.length && encodedInput[zeros] == 0) {
    ++zeros;
  }

  // Convert base-256 digits to base-58 digits (plus conversion to ASCII characters)
  // input = Arrays.copyOf(input, input.length); // since we modify it in-place
  var encoded = Uint8List(encodedInput.length * 2); // upper bound <----- ???
  var outputStart = encoded.length;
  for (var inputStart = zeros; inputStart < encodedInput.length;) {
    encoded[--outputStart] =
        uintAlphabet[divmod(encodedInput, inputStart, 256, 58)];
    if (encodedInput[inputStart] == 0) {
      // optimization - skip leading zeros
      ++inputStart;
    }
  }
  // Preserve exactly as many leading encoded zeros in output as there were leading zeros in input.
  while (outputStart < encoded.length && encoded[outputStart] == ENCODED_ZERO) {
    ++outputStart;
  }
  while (--zeros >= 0) {
    encoded[--outputStart] = ENCODED_ZERO;
  }
  // Return encoded string (including encoded leading zeros).
  return encoded.sublist(outputStart, encoded.length);
}

List<int> decodeChecked(String input) {
  var decoded = decode(input);
  if (decoded.length < 4) {
    throw AddressFormatException('Input too short');
  }

  var data = decoded.sublist(0, decoded.length - 4);
  var checksum = decoded.sublist(decoded.length - 4, decoded.length);
  var actualChecksum = sha256Twice(data).sublist(0, 4);

  // convert unsigned list back to signed
  var byteConverted = actualChecksum.map((elem) => elem.toSigned(8));
  if (!IterableEquality().equals(checksum, byteConverted)) {
    throw BadChecksumException('Checksum does not validate');
  }

  return data;
}
