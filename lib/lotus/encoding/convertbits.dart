import 'dart:core';

// ConvertBits takes a byte array as `input`, and converts it from `frombits`
// bit representation to a `tobits` bit representation, while optionally
// padding it.  ConvertBits returns the new representation and a bool
// indicating that the output was not truncated.
List<int>? ConvertBits(int frombits, int tobits, List<int>? input, bool pad) {
  if (frombits > 8) {
    return null;
  }

  var acc = 0;
  var bits = 0;
  var out = <int>[];
  //(input.length * frombits ~/ tobits);

  var maxv = (1 << tobits) - 1;
  var max_acc = (1 << (frombits + tobits - 1)) - 1;
  for (var element in input!) {
    acc = ((acc << frombits) | (element)) & max_acc;
    bits += frombits;
    while (bits >= tobits) {
      bits -= tobits;
      var v = (acc >> bits) & maxv;
      out.add(v);
    }
  }

  // We have remaining bits to encode so we do pad.
  if (pad && bits > 0) {
    out.add(((acc << (tobits - bits)) & maxv));
  }

  return out;
}
