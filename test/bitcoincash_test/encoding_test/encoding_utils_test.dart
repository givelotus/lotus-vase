import 'package:cashew/bitcoincash/bitcoincash.dart';
import 'package:test/test.dart';

void main() {
  test('varintBufNum method', () {
    final toEncode = ['01', 'ab12', 'ab12cd34', '100000001'];
    final expected = <List<int>>[
      [1],
      [0xfd, 18, 171],
      [0xfe, 52, 205, 18, 171],
      [0xff, 1, 0, 0, 0, 1, 0, 0, 0],
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
}
