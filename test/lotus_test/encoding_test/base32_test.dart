import 'package:test/test.dart';
import 'package:dartz/dartz.dart';

import 'package:vase/lotus/encoding/base32.dart';

void main() {
  test('can encode to base32', () async {
    final base32encoded = 'qpzry9x8gf2tvdw0s3jn54khce6mua7l';

    var address = toBase32(iota(32).toList());
    expect(address, base32encoded);
  });

  test('can decode base32', () async {
    final base32encoded = 'qpzry9x8gf2tvdw0s3jn54khce6mua7l';

    var address = fromBase32(base32encoded);

    expect(address, iota(32).toList());
  });

  test('can encode and decode', () async {
    var runes = List<int>.from(iota(32).toList());
    runes.shuffle();

    var encoded = toBase32(runes);
    var decoded = fromBase32(encoded);

    expect(decoded, runes);
  });
}
