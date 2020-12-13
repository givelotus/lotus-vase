import 'package:hex/hex.dart';
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

// TODO: FIX What is going on here. These are never used?
  // String _publicVector;
  // HDPrivateKey _hdPrivateKey;

  /// Private constructor. Internal use only.
  HDPublicKey._(NetworkType networkType, KeyType keyType) {
    this.networkType = networkType;
    this.keyType = keyType;
  }

  /// Constructs a public key from it's matching HD private key parameters
  HDPublicKey(
      BCHPublicKey publicKey,
      NetworkType networkType,
      int nodeDepth,
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
    keyBuffer = HEX.decode(publicKey.getEncoded(true));
  }

  /// Constructs a new public key from it's `xpub`-encoded representation
  HDPublicKey.fromXpub(String vector) {
    networkType = NetworkType.MAIN;
    keyType = KeyType.PUBLIC;
    deserialize(vector);
    // TODO: FIX not used?
    // _publicVector = vector;
  }

  /// Renders the public key in it's `xpub`-encoded form
  @override
  String toString() {
    return xpubkey;
  }

  /// Derive a new child public key at `index`
  HDPublicKey deriveChildNumber(int index) {
    var elem = ChildNumber(index, false);
    var fingerprint = _calculateFingerprint();
    var pubkey = HEX.encode(Uint8List.fromList(keyBuffer).toList());
    return _deriveChildPublicKey(
        nodeDepth, elem, fingerprint, chainCode, pubkey);
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
    var fingerprint = _calculateFingerprint();
    var parentChainCode = chainCode;
    var lastChild;
    var pubkey = HEX.encode(Uint8List.fromList(keyBuffer).toList());
    var nd = nodeDepth;
    for (var elem in children) {
      if (elem.isHardened()) {
        throw DerivationException(
            "Can't derived hardened public keys without private keys");
      }

      lastChild =
          _deriveChildPublicKey(nd, elem, fingerprint, parentChainCode, pubkey);
      fingerprint = lastChild._calculateFingerprint();
      parentChainCode = lastChild.chainCode;
      pubkey = HEX.encode(lastChild.keyBuffer);
      nd++;
    }

    return lastChild;
  }

  List<int> _calculateFingerprint() {
    var normalisedKey = keyBuffer.map((elem) => elem.toUnsigned(8));
    var pubKey = BCHPublicKey.fromHex(HEX.encode(normalisedKey.toList()));
    var encoded = pubKey.getEncoded(true);

    return hash160(HEX.decode(encoded).toList()).sublist(0, 4);
  }

  HDPublicKey _deriveChildPublicKey(int nd, ChildNumber cn,
      List<int> fingerprint, List<int> parentChainCode, String pubkey) {
    // TODO: This hoopjumping is irritating. What's the better way ?
    var seriList = List<int>(4);
    seriList.fillRange(0, 4, 0);
    var seriHexVal = HEX.decode(cn.i.toRadixString(16).padLeft(8, '0'));
    seriList.setRange(0, seriHexVal.length, seriHexVal);

    var dataConcat = HEX.decode(pubkey) + seriList;
    var I = HDUtils.hmacSha512WithKey(
        Uint8List.fromList(parentChainCode), Uint8List.fromList(dataConcat));

    var lhs = I.sublist(0, 32);
    var chainCode = I.sublist(32, 64);

    var parentPoint = _domainParams.curve.decodePoint(HEX.decode(pubkey));
    var privateKey = BCHPrivateKey.fromHex(HEX.encode(lhs), networkType);
    var pubKeyHex = HEX.decode(privateKey.publicKey.getEncoded(true));
    var thisPoint = _domainParams.curve.decodePoint(pubKeyHex);
    var derivedPoint = thisPoint + parentPoint;

    // TODO: Validate that the point is on the curve !

    var dk = HDPublicKey._(NetworkType.MAIN, KeyType.PUBLIC);
    dk = _copyParams(dk);

    dk.nodeDepth = nd + 1;
    dk.parentFingerprint = fingerprint;
    dk.childNumber = seriList;
    dk.chainCode = chainCode;
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
