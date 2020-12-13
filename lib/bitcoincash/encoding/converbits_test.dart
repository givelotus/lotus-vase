import 'package:test/test.dart';

import 'convertbits.dart';

void main() {
  test('can convert back and forth between 8 and 5 bit format', () async {
    final inputArray = [255];
    var newBits = ConvertBits(8, 5, inputArray, true);
    expect(newBits, [31, 28]);
    var reconverted = ConvertBits(5, 8, newBits, false);
    expect(reconverted, inputArray);
  });
}
