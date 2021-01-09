import 'dart:typed_data';

import 'package:cashew/bitcoincash/bitcoincash.dart';
import 'package:test/test.dart';

void main() {
  test('varintBufNum method', () {
    final toEncode = [
      '01',
      'ab12',
      'ab12cd34',
      '100000001',
      '7fffffffffffffff'
    ];
    final expected = <List<int>>[
      [1],
      [0xfd, 18, 171],
      [0xfe, 52, 205, 18, 171],
      [0xff, 1, 0, 0, 0, 1, 0, 0, 0],
      [0xff, 255, 255, 255, 255, 255, 255, 255, 127],
    ];

    for (var i = 0; i < toEncode.length; i++) {
      final val = int.parse(
        toEncode[i],
        radix: 16,
      );
      final result = varintBufNum(val);

      expect(
        result,
        equals(expected[i]),
      );
    }
  });

  test('varIntWriter method', () {
    final toEncode = [
      '01',
      'ab12',
      'ab12cd34',
      '100000001',
      '7fffffffffffffff',
    ];
    final expected = <Uint8List>[
      Uint8List.fromList([1]),
      Uint8List.fromList([0xfd, 18, 171]),
      Uint8List.fromList([0xfe, 52, 205, 18, 171]),
      Uint8List.fromList([0xff, 1, 0, 0, 0, 1, 0, 0, 0]),
      Uint8List.fromList(
        [0xff, 255, 255, 255, 255, 255, 255, 255, 127],
      )
    ];

    for (var i = 0; i < toEncode.length; i++) {
      final val = int.parse(
        toEncode[i],
        radix: 16,
      );
      final result = varIntWriter(val);

      expect(
        result,
        equals(expected[i]),
      );
    }
  });
}
