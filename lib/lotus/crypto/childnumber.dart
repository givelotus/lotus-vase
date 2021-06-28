import '../exceptions.dart';
import 'package:sprintf/sprintf.dart';

/*
Ported from BitcoinJ-SV
 */
class ChildNumber implements Comparable<ChildNumber> {
  ///
  /// The bit that's set in the child number to indicate whether this key is "hardened". Given a hardened key, it is
  /// not possible to derive a child public key if you know only the hardened public key. With a non-hardened key this
  /// is possible, so you can derive trees of public keys given only a public parent, but the downside is that it's
  /// possible to leak private keys if you disclose a parent public key and a child private key (elliptic curve maths
  /// allows you to work upwards).
  ///
  static final int HARDENED_BIT = 0x80000000;

  static final ChildNumber ZERO = ChildNumber.fromIndex(0);
  static final ChildNumber ONE = ChildNumber.fromIndex(1);
  static final ChildNumber ZERO_HARDENED = ChildNumber(0, true);

  /// Integer i as per BIP 32 spec, including the MSB denoting derivation type (0 = public, 1 = private) **/
  int _i = 0;

  ChildNumber(int childNumber, bool isHardened) {
    if (_hasHardenedBit(childNumber)) {
      throw IllegalArgumentException(
          "Most significant bit is reserved and shouldn't be set: " +
              childNumber.toString());
    }
    _i = isHardened ? (childNumber | HARDENED_BIT) : childNumber;
  }

  ChildNumber.fromIndex(int i) {
    _i = i;
  }

  /// Returns the uint32 encoded form of the path element, including the most significant bit. */
  int get i {
    return _i;
  }

  bool isHardened() {
    return _hasHardenedBit(_i);
  }

  static bool _hasHardenedBit(int a) {
    return (a & HARDENED_BIT) != 0;
  }

  /// Returns the child number without the hardening bit set (i.e. index in that part of the tree). */
  int num() {
    return _i & (~HARDENED_BIT);
  }

  @override
  String toString() {
    return sprintf('%d%s', [num(), isHardened() ? 'H' : '']);
  }

  @override
  bool operator ==(otherChild) {
    if (runtimeType != otherChild.runtimeType) {
      return false;
    }

    return _i == otherChild.i;
  }

  @override
  int get hashCode {
    return _i;
  }

  @override
  int compareTo(ChildNumber other) {
    return num().compareTo(other.num());
  }
}
