import 'dart:typed_data';
import 'package:pointycastle/pointycastle.dart';

import 'exceptions.dart';
import 'privatekey.dart';
import 'encoding/utils.dart';
import 'encoding/ckdserializer.dart';
import 'crypto/hdutils.dart';
import 'crypto/childnumber.dart';
import 'publickey.dart';
import 'networks.dart';

/// Provides support for Extended Public keys (__Hierarchical Deterministic__ keys)
/// as described in the [BIP32 spec](https:// github.com/bitcoin/bips/blob/master/bip-0032.mediawiki).
///
/// Additional child pubkeys can be derived from this, but no further private keys can be directly derived.
///
/// ```
///  Extended PubKey Serialization Format
///  =============================================
///
///
///             depth[1]          chaincode[32]
///             \/                  \/
///  |_________|_|________|________________________|________________________|
///    |^              |^                                   |^
///    |^version[4]    |^fingerprint[4]                     |^key[33] <---> pubkey(serP(K))
///
///  4 bytes: version bytes (
///              mainnet:
///                      public: 0x0488B21E ,
///                      private: 0x0488ADE4 ;
///              testnet:
///                      public: 0x043587CF ,
///                      private: 0x04358394 )
///
///  1 byte:
///      depth: 0x00 for master nodes,
///             0x01 for level-1 derived keys, ....
///
///  4 bytes: the fingerprint of the parent key (0x00000000 if master key)
///  4 bytes: child number. This is ser32(i) for i in xi = xpar/i, with xi the key being serialized. (0x00000000 if master key)
///  32 bytes: the chain code
///  33 bytes: the public key (serP(K) for public keys
///
/// ```
class HDPublicKey extends CKDSerializer {
  final _domainParams = ECDomainParameters('secp256k1');

  /// Private constructor. Internal use only.
  HDPublicKey._(NetworkType networkType, KeyType keyType) {
    this.networkType = networkType;
    this.keyType = keyType;
  }

  /// Constructs a public key from it's matching HD private key parameters
  HDPublicKey(
      BCHPublicKey publicKey,
      NetworkType? networkType,
      int? nodeDepth,
      List<int> parentFingerprint,
      List<int> childNumber,
      List<int> chainCode,
      List<int> versionBytes) {
    this.nodeDepth = nodeDepth;
    this.parentFingerprint = parentFingerprint;
    this.childNumber = childNumber;
    this.chainCode = chainCode;
    this.versionBytes = versionBytes;
    keyType = KeyType.PUBLIC;
    this.networkType = networkType;
    keyBuffer = publicKey.point!.getEncoded(true);
  }

  /// Constructs a new public key from it's `xpub`-encoded representation
  HDPublicKey.fromXpub(String vector) {
    networkType = NetworkType.MAIN;
    keyType = KeyType.PUBLIC;
    deserialize(vector);
  }

  /// Constructs a new public key from it's `xpub`-encoded representation
  BCHPublicKey get publicKey {
    final point = _domainParams.curve.decodePoint(keyBuffer)!;
    return BCHPublicKey.fromPoint(point);
  }

  /// Renders the public key in it's `xpub`-encoded form
  @override
  String toString() {
    return xpubkey;
  }

  /// Derive a new child public key at `index`
  HDPublicKey deriveChildNumber(int index) {
    var elem = ChildNumber(index, false);
    return _deriveChildPublicKey(nodeDepth!, elem);
  }

  /// Derive a new child public key using the indicated path
  ///
  /// E.g.
  /// ```
  /// var derived = publicKey.deriveChildKey("m/0/1/2");
  /// ```
  HDPublicKey deriveChildKey(String path) {
    var children = HDUtils.parsePath(path);

    // some imperative madness to ensure children have their parents' fingerprint
    HDPublicKey lastChild = this;
    var nd = nodeDepth;
    for (var elem in children) {
      if (elem.isHardened()) {
        throw DerivationException(
            "Can't derived hardened public keys without private keys");
      }

      lastChild = lastChild._deriveChildPublicKey(
        nd!,
        elem,
      );
      nd++;
    }

    return lastChild;
  }

  List<int> get fingerprint {
    return hash160(publicKey.point!.getEncoded(true)).sublist(0, 4);
  }

  HDPublicKey _deriveChildPublicKey(
    int nd,
    ChildNumber cn,
  ) {
    var seriList = Uint8List(4);
    seriList.buffer.asByteData(0, 4).setUint32(0, cn.i);
    final publicKeyPoint = publicKey.point!;
    var dataConcat = publicKeyPoint.getEncoded(true) + seriList;
    var I = HDUtils.hmacSha512WithKey(
        chainCode as Uint8List, Uint8List.fromList(dataConcat));

// Ensure value is interpreted as positive by padding.
    var lhs = I.sublist(0, 32);
    var childChainCode = I.sublist(32, 64);

    var privateKey =
        BCHPrivateKey.fromBigInt(decodeUInt256(lhs), networkType: networkType);
    var derivedPoint = (privateKey.publicKey!.point! + publicKeyPoint)!;

    // TODO: Validate that the point is on the curve !

    var dk = HDPublicKey._(NetworkType.MAIN, KeyType.PUBLIC);
    dk = _copyParams(dk);

    dk.nodeDepth = nd + 1;
    dk.parentFingerprint = fingerprint;
    dk.childNumber = seriList;
    dk.chainCode = childChainCode;
    dk.keyBuffer = derivedPoint.getEncoded(true);

    return dk;
  }

  HDPublicKey _copyParams(HDPublicKey hdPublicKey) {
    // all other serializer params should be the same ?
    hdPublicKey.nodeDepth = nodeDepth;
    hdPublicKey.parentFingerprint = parentFingerprint;
    hdPublicKey.childNumber = childNumber;
    hdPublicKey.chainCode = chainCode;
    hdPublicKey.versionBytes = versionBytes;

    return hdPublicKey;
  }

  /// Returns the serialized representation of the extended public key.
  ///
  ///    4 byte: version bytes (mainnet: 0x0488B21E public, 0x0488ADE4 private; testnet: 0x043587CF public, 0x04358394 private)
  ///    1 byte: depth: 0x00 for master nodes, 0x01 for level-1 derived keys, ....
  ///    4 bytes: the fingerprint of the parent's key (0x00000000 if master key)
  ///    4 bytes: child number. This is ser32(i) for i in xi = xpar/i, with xi the key being serialized. (0x00000000 if master key)
  ///    32 bytes: the chain code
  ///    33 bytes: the public key data ( serP(K) )
  ///
  String get xpubkey {
    return serialize();
  }
}
