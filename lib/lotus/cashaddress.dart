import 'networks.dart';
import 'exceptions.dart';
import 'encoding/base32.dart';
import 'encoding/convertbits.dart';

const defaultPrefix = 'bitcoincash';

class RawCashAddress {
  AddressType addressType;
  NetworkType networkType;
  List<int> addressBytes;

  String prefix;

  int get version {
    switch (addressType) {
      case AddressType.PUBKEY_HASH:
        return 0;
      case AddressType.SCRIPT_HASH:
        return 1;
      default:
        throw AddressFormatException('Unknown address type');
    }
  }

  RawCashAddress(
      {this.addressType,
      this.networkType,
      this.addressBytes,
      this.prefix = defaultPrefix});
}

const globalDefaultPrefix = 'bitcoincash';

/// polyMod is a BCH-encoding checksum function per the CashAddr specification.
int polyMod(List<int> v) {
  var c = 1;
  for (final d in v) {
    var c0 = c >> 35;
    c = ((c & 0x07ffffffff) << 5) ^ d;

    if (c0 & 0x01 != 0) {
      c ^= 0x98f2bc8e61;
    }
    if (c0 & 0x02 != 0) {
      c ^= 0x79b76d99e2;
    }
    if (c0 & 0x04 != 0) {
      c ^= 0xf33e5fb3c4;
    }
    if (c0 & 0x08 != 0) {
      c ^= 0xae2eabe2a8;
    }
    if (c0 & 0x10 != 0) {
      c ^= 0x1e4f43e470;
    }
  }

  return c ^ 1;
}

/// expandPrefix takes a string, and returns a byte array with each element
/// being the corropsonding character's right-most 5 bits.  Result additionally
/// includes a null termination byte.
List<int> expandPrefix(String prefix) {
  var out = <int>[]; //
  for (final r in prefix.runes) {
    // Grab the right most 5 bits
    out.add(r & 0x1F);
  }
  out.add(0);

  return out;
}

/// CalculateChecksum calculates a BCH checksum for a nibble-packed cashaddress
/// that properly includes the network prefix.
int calculateChecksum(String prefix, List<int> packedaddr) {
  var exphrp = expandPrefix(prefix);
  exphrp.addAll(packedaddr);
  return polyMod(exphrp);
}

/// FromCashAddr takes a CashAddr URI string, and returns and unpacked
/// RawAddress, and possible an error.
RawCashAddress Decode(String address,
    [String defaultPrefix = globalDefaultPrefix]) {
  final splitAddress = SplitAddress(address, defaultPrefix);
  if (splitAddress.address.toUpperCase() != splitAddress.address &&
      splitAddress.address.toLowerCase() != splitAddress.address) {
    throw AddressFormatException(
        'cashaddress contains mixed upper and lowercase characters');
  }

  final decoded = fromBase32(splitAddress.address);
  // Ensure the checksum is zero when decoding
  final chksum = calculateChecksum(splitAddress.prefix, decoded);
  if (chksum != 0) {
    throw AddressFormatException('checksum failed validation');
  }

  // Unpack the address without the checksum bits
  return unpackAddress(decoded.sublist(0, decoded.length - 8),
      splitAddress.prefix.toLowerCase());
}

// SplitAddress takes a cashaddr string and returns the network prefix, and
// the base32 payload separately.
class SplitAddress {
  String prefix;
  String address;

  SplitAddress(String fullAddress, String defaultPrefix) {
    final idx = fullAddress.indexOf(':');
    if (idx < 0) {
      prefix = defaultPrefix;
      address = fullAddress;
      return;
    }

    prefix = fullAddress.substring(0, idx);
    address = fullAddress.substring(idx + 1);
  }
}

/// networkTypeFromPrefix converts a cashaddr prefix into the
/// appropriate [NetworkType] for internal representations.
NetworkType getNetworkTypeFromPrefix(String prefix) {
  switch (prefix) {
    case 'bitcoincash':
      return NetworkType.MAIN;
    case 'ecash':
      return NetworkType.MAIN;
    case 'tecash':
      return NetworkType.TEST;
    case 'bchtest':
      return NetworkType.TEST;
    case 'bchreg':
      return NetworkType.REGTEST;
    default:
      return NetworkType.MAIN;
  }
}

/// getAddressTypeFromByte converts a address type into the
/// appropriate [AddressType] for internal representations.
AddressType getAddressTypeFromByte(int addressType) {
  switch (addressType) {
    case 0:
      return AddressType.PUBKEY_HASH;
    case 1:
      return AddressType.SCRIPT_HASH;
    default:
      throw AddressFormatException(
          'unknown address type specified in cashaddr verison byte');
  }
}

/// unpackAddress takes a byte array in a raw (not base32 encoded) cashaddr
/// format. The checksum bits must already be removed.
RawCashAddress unpackAddress(List<int> packedaddr, String prefix) {
  // Re-pack the 5-bit packed address to 8bits.
  final output = ConvertBits(5, 8, packedaddr, false);

  final extrabits = output.length * 5 % 8;
  if (extrabits >= 5) {
    throw AddressFormatException('non-zero padding');
  }

  final version_byte = output[0];
  final addrtype = version_byte >> 3;

  var decoded_size = 20 + 4 * (version_byte & 0x03);
  if (version_byte & 0x04 == 0x04) {
    decoded_size = decoded_size * 2;
  }
  final actualSize = output.length - 1;
  if (decoded_size != actualSize) {
    throw AddressFormatException(
        'invalid size information ($decoded_size != $actualSize)');
  }

  return RawCashAddress(
      addressBytes: output.sublist(1),
      networkType: getNetworkTypeFromPrefix(prefix),
      addressType: getAddressTypeFromByte(addrtype));
}

// ToCashAddr expects a RawAddress and a prefix, and returns the CashAddr URI,
// and possibly an error.
String Encode(RawCashAddress address) {
  final packed = packAddress(address);
  final paddingForChecksum = packed.sublist(0);
  paddingForChecksum.addAll([0, 0, 0, 0, 0, 0, 0, 0]);

  // Calculate the a checksum.  Provide 8 bytes of padding.
  final poly = calculateChecksum(address.prefix, paddingForChecksum);
  final wchk = appendChecksum(packed, poly);
  final base32 = toBase32(wchk);

  return '${address.prefix}:${base32}';
}

// packAddress takes a RawAddress and converts it's payload to a 5-bit packed
// representation.  The first byte represents the address type, and the size
// of the payload.
List<int> packAddress(RawCashAddress address) {
  final version = address.version << 3;
  final size = address.addressBytes.length;
  var encodedSize = 0;
  switch (size * 8) {
    case 160:
      encodedSize = 0;
      break;
    case 192:
      encodedSize = 1;
      break;
    case 224:
      encodedSize = 2;
      break;
    case 256:
      encodedSize = 3;
      break;
    case 320:
      encodedSize = 4;
      break;
    case 384:
      encodedSize = 5;
      break;
    case 448:
      encodedSize = 6;
      break;
    case 512:
      encodedSize = 7;
      break;
    default:
      throw AddressFormatException('invalid address size');
  }

  final version_byte = version | encodedSize;
  final input = <int>[];
  input.add(version_byte);
  input.addAll(address.addressBytes);
  final out = ConvertBits(8, 5, input, true);

  return out;
}

// appendChecksum returns packedaddr with 8 appended checksum bytes from
// PolyMod.
List<int> appendChecksum(List<int> packedAddress, int poly) {
  var chkarr = <int>[];
  for (var i = 0; i < 8; i++) {
    chkarr.add((poly >> (5 * (7 - i))) & 0x1F);
  }
  var withChecksum = packedAddress.sublist(0);
  withChecksum.addAll(chkarr);
  return withChecksum;
}
