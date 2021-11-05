import '../exceptions.dart';
import 'package:hex/hex.dart';
import 'package:meta/meta.dart';
import 'package:pointycastle/digests/ripemd160.dart';
import 'package:pointycastle/digests/sha256.dart';
import 'dart:typed_data';
import 'package:buffer/buffer.dart';
import 'dart:math';

import 'package:pointycastle/export.dart';

List<int> sha256Twice(List<int> bytes) {
  var first = SHA256Digest().process(Uint8List.fromList(bytes));
  var second = SHA256Digest().process(first);
  return second.toList();
}

List<int> sha256(List<int> bytes) {
  return SHA256Digest().process(Uint8List.fromList(bytes)).toList();
}

List<int> sha1(List<int> bytes) {
  return SHA1Digest().process(Uint8List.fromList(bytes)).toList();
}

List<int> hash160(List<int> bytes) {
  List<int> shaHash = SHA256Digest().process(Uint8List.fromList(bytes));
  var ripeHash = RIPEMD160Digest().process(shaHash as Uint8List);
  return ripeHash.toList();
}

List<int> ripemd160(List<int> bytes) {
  var ripeHash = RIPEMD160Digest().process(Uint8List.fromList(bytes));
  return ripeHash.toList();
}

int hexToUint16(List<int> hexBuffer) {
  return int.parse(HEX.encode(hexBuffer), radix: 16).toUnsigned(16);
}

int hexToInt32(List<int> hexBuffer) {
  return int.parse(HEX.encode(hexBuffer), radix: 16).toSigned(32);
}

int hexToUint32(List<int> hexBuffer) {
  return int.parse(HEX.encode(hexBuffer), radix: 16).toUnsigned(32);
}

int hexToInt64(List<int> hexBuffer) {
  return int.parse(HEX.encode(hexBuffer), radix: 16).toSigned(64);
}

BigInt hexToUint64(List<int> hexBuffer) {
  return BigInt.parse(HEX.encode(hexBuffer), radix: 16).toUnsigned(64);
}

List<int> varintBufNum(int n) {
  var writer = ByteDataWriter();

  if (n != null) {
    if (n.isNegative) {
      throw BadParameterException(
        'varintBufNum:The provided length can not be a negative value:\t$n',
      );
    }

    if (n < 253) {
      writer.writeUint8(n);
    } else if (n < 0x10000) {
      writer.writeUint8(253);
      writer.writeUint16(n, Endian.little);
    } else if (n < 0x100000000) {
      writer.writeUint8(254);
      writer.writeUint32(n, Endian.little);
    } else {
      writer.writeUint8(255);
      writer.writeInt64(n, Endian.little);
    }
  }

  return writer.toBytes().toList();
}

Uint8List varIntWriter(int length) {
  var writer = ByteDataWriter();

  if (length != null) {
    if (length.isNegative) {
      throw BadParameterException(
        'varIntWriter:The provided length can not be a negative value:\t$length',
      );
    }

    /// In Dart 1 the value `0xFFFFFFFFFFFFFFFF` was too large, so it became
    /// a [BigInt] and the comparison was ok, but in Dart 2 the same hex value
    /// evaluate to a negative int (`-1`), so it iss necessary to use the
    /// largest positive [int] value in Dart: `0x7fffffffffffffff`
    /// (only with 64 bits, in Dart Web this won't work).
    if (length < 0xFD) {
      writer.writeUint8(length);
    } else if (length < 0x10000) {
      writer.writeUint8(253);
      writer.writeUint16(length, Endian.little);
    } else if (length < 0x100000000) {
      writer.writeUint8(254);
      writer.writeUint32(length, Endian.little);
    } else if (length <= 0x7FFFFFFFFFFFFFFF) {
      writer.writeUint8(255);
      writer.writeInt64(length, Endian.little);
    }
  }

  return writer.toBytes();
}

// Implementation from bsv lib
int readVarIntNum(ByteDataReader reader) {
  var first = reader.readUint8();
  switch (first) {
    case 0xFD:
      return reader.readUint16(Endian.little);
      break;
    case 0xFE:
      return reader.readUint32(Endian.little);
      break;
    case 0xFF:
      var bn = BigInt.from(reader.readUint64(Endian.little));
      var n = bn.toInt();
      if (n <= pow(2, 53)) {
        return n;
      } else {
        throw Exception(
            'number too large to retain precision - use readVarintBN');
      }
      break;
    default:
      return first;
  }
}

BigInt readVarInt(Uint8List buffer) {
  final first = buffer.first;

  switch (first) {
    case 0xFD:
      return bytesToBigInt(
        bytes: buffer.sublist(1, 3),
        endian: Endian.little,
      ); // 2 bytes ==  Uint16

    case 0xFE:
      return bytesToBigInt(
        bytes: buffer.sublist(1, 5),
        endian: Endian.little,
      ); // 4 bytes == Uint32

    case 0xFF:
      return bytesToBigInt(
        bytes: buffer.sublist(1, 9),
        endian: Endian.little,
      ); // 8 bytes == Uint64

    default:
      return BigInt.from(first);
  }
}

/// This function will return a [BigInt]. It has the same functionality
/// as the [decodeUInt256] method, but with the added [endian] parameter.
BigInt bytesToBigInt({
  required List<int> bytes,
  Endian endian = Endian.big,
}) {
  /// The line
  /// `BigInt.from(bytes[bytes.length - i - 1]) << (8 * i);`
  /// from [decodeBigInt] is the same as
  /// `BigInt.from(bytes[bytes.length - i - 1]) * BigInt.from(256).pow(i);`
  return decodeUInt256(
    endian == Endian.big ? bytes : Uint8List.fromList(bytes.reversed.toList()),
  );
}

/// Decode a BigInt from bytes in big-endian encoding.
BigInt decodeUInt256(List<int> bytes) {
  var result = BigInt.from(0);

  for (var i = 0; i < bytes.length; i++) {
    result += BigInt.from(bytes[bytes.length - i - 1]) << (8 * i);
  }

  return result;
}

var _byteMask = BigInt.from(0xff);

/// Encode a BigInt into bytes using big-endian encoding.
Uint8List encodeUInt256(BigInt number) {
  var size = (number.bitLength + 7) >> 3;

  var result = Uint8List(size);
  for (var i = 0; i < size; i++) {
    result[size - i - 1] = (number & _byteMask).toInt();
    number = number >> 8;
  }

  return result;
}

List<int> toScriptNumBuffer(BigInt value) {
  return toSM(value, endian: Endian.little);
}

BigInt fromScriptNumBuffer(Uint8List buf, bool fRequireMinimal,
    {int nMaxNumSize = 4}) {
  if (!(buf.length <= nMaxNumSize)) {
    throw ScriptException('script number overflow');
  }

  if (fRequireMinimal && buf.isNotEmpty) {
    // Check that the number is encoded with the minimum possible
    // number of bytes.
    //
    // If the most-significant-byte - excluding the sign bit - is zero
    // then we're not minimal. Note how this test also rejects the
    // negative-zero encoding, 0x80.
    if ((buf[buf.length - 1] & 0x7f) == 0) {
      // One exception: if there's more than one byte and the most
      // significant bit of the second-most-significant-byte is set
      // it would conflict with the sign bit. An example of this case
      // is +-255, which encode to 0xff00 and 0xff80 respectively.
      // (big-endian).
      if (buf.length <= 1 || (buf[buf.length - 2] & 0x80) == 0) {
        throw Exception('non-minimally encoded script number');
      }
    }
  }
  return fromSM(buf, endian: Endian.little);
}

List<int> toSM(BigInt value, {Endian endian = Endian.big}) {
  var buf = toSMBigEndian(value);

  if (endian == Endian.little) {
    buf = buf.reversed.toList();
  }
  return buf;
}

List<int> toSMBigEndian(BigInt value) {
  var buf = <int>[];
  if (value.compareTo(BigInt.zero) == -1) {
    buf = toBuffer(-value);
    if (buf[0] & 0x80 != 0) {
      buf = [0x80] + buf;
    } else {
      buf[0] = buf[0] | 0x80;
    }
  } else {
    buf = toBuffer(value);
    if (buf[0] & 0x80 != 0) {
      buf = [0x00] + buf;
    }
  }

  if (buf.length == 1 && buf[0] == 0) {
    buf = [];
  }
  return buf;
}

BigInt fromSM(Uint8List buf, {Endian endian = Endian.big}) {
  BigInt ret;
  var localBuffer = buf.toList();
  if (localBuffer.isEmpty) {
    return decodeUInt256([0]);
  }

  if (endian == Endian.little) {
    localBuffer = buf.reversed.toList();
  }

  if (localBuffer[0] & 0x80 != 0) {
    localBuffer[0] = localBuffer[0] & 0x7f;
    ret = decodeUInt256(localBuffer);
    ret = (-ret);
  } else {
    ret = decodeUInt256(localBuffer);
  }

  return ret;
}

// TODO: FIX New implementation. Untested
List<int> toBuffer(BigInt value, {int size = 0, Endian endian = Endian.big}) {
  String hex;
  var buf = <int>[];
  if (size != 0) {
    hex = value.toRadixString(16);
    var natlen = (hex.length / 2) as int;
    buf = HEX.decode(hex);

    if (natlen == size) {
      // buf = buf
    } else if (natlen > size) {
      buf = buf.sublist(natlen - buf.length, buf.length);
    } else if (natlen < size) {
      var padding = <int>[size];
      padding.fillRange(0, size, 0);
      buf.insertAll(0, padding);
    }
  } else {
    hex = value.toRadixString(16);
    buf = HEX.decode(hex);
  }

  if (endian == Endian.little) {
    buf = buf.reversed.toList();
  }

  return buf;
}
