import 'dart:typed_data';

import 'package:buffer/buffer.dart';
import 'package:vase/lotus/lotus.dart';
import 'package:test/test.dart';

void main() {
  test('varintBufNum method', () {
    final toEncode = [
      '01',
      'ab12',
      'ab12cd34',
      '100000001',
      '7fffffffffffffff',
      'ffff',
      'ffffffff',
    ];

    final expected = <List<int>>[
      [1],
      [0xfd, 18, 171],
      [0xfe, 52, 205, 18, 171],
      [0xff, 1, 0, 0, 0, 1, 0, 0, 0],
      [0xff, 255, 255, 255, 255, 255, 255, 255, 127],
      [0xfd, 255, 255],
      [0xfe, 255, 255, 255, 255],
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

    expect(
      () => varintBufNum(-1),
      throwsA(
        predicate((dynamic e) =>
            e is BadParameterException &&
            e.message ==
                'varintBufNum:The provided length can not be a negative value:\t-1'),
      ),
    );
  });

  test('varIntWriter method', () {
    final toEncode = [
      '01',
      'ab12',
      'ab12cd34',
      '100000001',
      '7fffffffffffffff',
      'ffff',
      'ffffffff',
    ];
    final expected = <Uint8List>[
      Uint8List.fromList([1]),
      Uint8List.fromList([0xfd, 18, 171]),
      Uint8List.fromList([0xfe, 52, 205, 18, 171]),
      Uint8List.fromList([0xff, 1, 0, 0, 0, 1, 0, 0, 0]),
      Uint8List.fromList(
        [0xff, 255, 255, 255, 255, 255, 255, 255, 127],
      ),
      Uint8List.fromList([0xfd, 255, 255]),
      Uint8List.fromList([0xfe, 255, 255, 255, 255]),
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

    expect(
      () => varIntWriter(-1),
      throwsA(
        predicate((dynamic e) =>
            e is BadParameterException &&
            e.message ==
                'varIntWriter:The provided length can not be a negative value:\t-1'),
      ),
    );
  });

  test('readVarIntNum method', () {
    final reader = ByteDataReader();

    final toDecode = <List<int>>[
      [1],
      [253, 171, 18],
      [254, 171, 18, 205, 52],
      [255, 0, 0, 0, 0, 0, 0, 32, 0]
    ];
    final expected = <int>[
      1,
      4779,
      885854891,
      9007199254740992,
    ];

    for (var i = 0; i < toDecode.length; i++) {
      reader.add(toDecode[i]);
      final decoded = readVarIntNum(reader);

      expect(
        decoded,
        equals(expected[i]),
      );
    }
  });

  test('readVarInt method', () {
    final toDecode = <List<int>>[
      Uint8List.fromList([1]),
      Uint8List.fromList([253, 171, 18]),
      Uint8List.fromList([254, 171, 18, 205, 52]),
      Uint8List.fromList([255, 0, 0, 0, 0, 0, 0, 32, 0]),
      Uint8List.fromList([255, 171, 18, 205, 52, 171, 18, 205, 52]),
    ];
    final expected = <BigInt>[
      BigInt.from(1),
      BigInt.from(4779),
      BigInt.from(885854891),
      BigInt.from(9007199254740992),
      BigInt.from(3804717786732499627),
    ];

    for (var i = 0; i < toDecode.length; i++) {
      final decoded = readVarInt(toDecode[i] as Uint8List);

      expect(
        decoded,
        equals(expected[i]),
      );
    }
  });

  test('decodeUInt256 method', () {
    final toDecode = <List<int>>[
      [1],
      [18, 171],
      [52, 205, 18, 171],
      [32, 0, 0, 0, 0, 0, 0],
      [52, 205, 18, 171, 52, 205, 18, 171],
    ];
    final expected = <BigInt>[
      BigInt.from(1),
      BigInt.from(4779),
      BigInt.from(885854891),
      BigInt.from(9007199254740992),
      BigInt.from(3804717786732499627),
    ];

    for (var i = 0; i < toDecode.length; i++) {
      final decoded = decodeUInt256(toDecode[i]);

      expect(
        decoded,
        equals(expected[i]),
      );
    }
  });

  test('encodeUInt256 method', () {
    final toEncode = <BigInt>[
      BigInt.from(1),
      BigInt.from(4779),
      BigInt.from(885854891),
      BigInt.from(9007199254740992),
      BigInt.from(3804717786732499627),
    ];
    final expected = <List<int>>[
      Uint8List.fromList([1]),
      Uint8List.fromList([18, 171]),
      Uint8List.fromList([52, 205, 18, 171]),
      Uint8List.fromList([32, 0, 0, 0, 0, 0, 0]),
      Uint8List.fromList([52, 205, 18, 171, 52, 205, 18, 171]),
    ];

    for (var i = 0; i < toEncode.length; i++) {
      final encoded = encodeUInt256(toEncode[i]);

      expect(
        encoded,
        equals(expected[i]),
      );
    }
  });
}
