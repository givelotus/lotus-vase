import 'package:hex/hex.dart';
import 'crypto/hdutils.dart';
import 'dart:convert';
import 'crypto/childnumber.dart';
import 'dart:typed_data';
import 'package:pointycastle/pointycastle.dart';

import 'hdpublickey.dart';
import 'publickey.dart';
import 'privatekey.dart';
import 'encoding/utils.dart';
import 'exceptions.dart';
import 'encoding/ckdserializer.dart';
import 'networks.dart';

/// Provides support for Extended Private keys (__Hierarchical Deterministic__ keys)
/// as described in the [BIP32 spec](https:// github.com/bitcoin/bips/blob/master/bip-0032.mediawiki).
///
/// This is essentially a method of having a __master private key__, and then using what is generally
/// referred to as a __derivation path__ to generate a *tree* of keypairs which can all be *deterministically*
/// derived from the original __master private key__.
///
/// This method of key generation is useful for enhancing one's privacy by avoiding key re-use.
///
/// ```
///  Extended Private Key Serialization Format
///  =============================================
///
///
///             depth[1]          chaincode[32]
///             \/                  \/
///  |_________|_|________|________________________|________________________|
///    |^              |^                                   |^
///    |^version[4]    |^fingerprint[4]                     |^key[33] <---> privkey(ser256(k))
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
///  33 bytes: 0x00 || ser256(k) for private keys
///
/// ```
class HDPrivateKey extends CKDSerializer {
  final _domainParams = ECDomainParameters('secp256k1');

  /// Private constructor. Internal use only.
  HDPrivateKey._(NetworkType networkType, KeyType keyType) {
    this.networkType = networkType;
    this.keyType = keyType;
  }

  /// Reconstruct a private key from a standard `xpriv` string.
  ///
  HDPrivateKey.fromXpriv(String vector) {
    networkType = NetworkType.MAIN;
    keyType = KeyType.PRIVATE;

    deserialize(vector);
  }

  /// Generate a private key from a seed, as described in BIP32
  ///
  HDPrivateKey.fromSeed(String seed, NetworkType networkType) {
    // I = HMAC-SHA512(Key = "Bitcoin seed", Data = S)
    var I = HDUtils.hmacSha512WithKey(
        utf8.encode('Bitcoin seed'), HEX.decode(seed));

    var masterKey = I.sublist(0, 32);
    var masterChainCode = I.sublist(32, 64);

    if (decodeBigInt(masterKey) == BigInt.zero ||
        decodeBigInt(masterKey) > _domainParams.n) {
      throw DerivationException('Invalid master key was generated.');
    }

    var paddedKey = Uint8List(33);
    paddedKey[0] = 0;
    paddedKey.setRange(1, 33, Uint8List.fromList(masterKey).toList());

    var dk = HDPrivateKey._(NetworkType.MAIN, KeyType.PRIVATE);
    dk = _copyParams(dk);

    nodeDepth = 0;
    parentFingerprint = List<int>(4)..fillRange(0, 4, 0);
    childNumber = List<int>(4)..fillRange(0, 4, 0);
    chainCode = masterChainCode;
    this.networkType = networkType;
    keyType = KeyType.PRIVATE;
    keyBuffer = paddedKey;
    versionBytes = getVersionBytes();
  }

  /// Returns the public key associated with this private key
  HDPublicKey get hdPublicKey {
    var hdPublicKey = HDPublicKey.fromXpub(xpubkey);
    return hdPublicKey;
  }

  /// Returns the serialized `xpriv`-encoded private key as a string.
  ///
  /// This method is an alias for the [xprivkey] property
  @override
  String toString() {
    return xprivkey;
  }

  /// Derives a child private key specified by the index
  HDPrivateKey deriveChildNumber(int index) {
    var elem = ChildNumber(index, false);
    var fingerprint = _calculateFingerprint();
    return _deriveChildPrivateKey(nodeDepth + 1, Uint8List.fromList(keyBuffer),
        elem, fingerprint, chainCode, publicKey.getEncoded(true));
  }

  /// Derives a child private key along the specified path
  ///
  /// E.g.
  /// ```
  /// var derived = privateKey.deriveChildKey("m/0'/1/2'");
  /// ```
  ///
  HDPrivateKey deriveChildKey(String path) {
    var children = HDUtils.parsePath(path);

    // some imperative madness to ensure children have their parents' fingerprint
    var fingerprint = _calculateFingerprint();
    var parentChainCode = chainCode;
    var lastChild;
    var pubkey = publicKey;
    var privkey = keyBuffer;
    var nd = 1;
    for (var elem in children) {
      lastChild = _deriveChildPrivateKey(nd, Uint8List.fromList(privkey), elem,
          fingerprint, parentChainCode, pubkey.getEncoded(true));
      fingerprint = lastChild._calculateFingerprint();
      parentChainCode = lastChild.chainCode;
      pubkey = lastChild.publicKey;
      privkey = lastChild.keyBuffer;
      nd++;
    }

    return lastChild;
  }

  HDPrivateKey _copyParams(HDPrivateKey hdPrivateKey) {
    // all other serializer params should be the same ?
    hdPrivateKey.nodeDepth = nodeDepth;
    hdPrivateKey.parentFingerprint = parentFingerprint;
    hdPrivateKey.childNumber = childNumber;
    hdPrivateKey.chainCode = chainCode;
    hdPrivateKey.versionBytes = versionBytes;

    return hdPrivateKey;
  }

  List<int> _calculateFingerprint() {
    var normalisedKey = keyBuffer.map((elem) => elem.toUnsigned(8));
    var privKey =
        BCHPrivateKey.fromHex(HEX.encode(normalisedKey.toList()), networkType);
    var pubKey = BCHPublicKey.fromPrivateKey(privKey);
    var encoded = pubKey.getEncoded(true);

    return hash160(HEX.decode(encoded).toList()).sublist(0, 4);
  }

  HDPrivateKey _deriveChildPrivateKey(
      int nd,
      List<int> privateKey,
      ChildNumber cn,
      List<int> fingerprint,
      List<int> parentChainCode,
      String pubkey) {
    // TODO: This hoopjumping is irritating. What's the better way ?
    var seriList = List<int>(4);
    seriList.fillRange(0, 4, 0);
    var seriHexVal = HEX.decode(cn.i.toRadixString(16).padLeft(8, '0'));
    seriList.setRange(0, seriHexVal.length, seriHexVal);

    var dataConcat =
        cn.isHardened() ? privateKey + seriList : HEX.decode(pubkey) + seriList;
    var I = HDUtils.hmacSha512WithKey(
        Uint8List.fromList(parentChainCode), Uint8List.fromList(dataConcat));

    var lhs = I.sublist(0, 32);
    var chainCode = I.sublist(32, 64);
    var normalisedKey = Uint8List.fromList(privateKey);
    var childKey = (BigInt.parse(HEX.encode(lhs), radix: 16) +
            BigInt.parse(HEX.encode(normalisedKey), radix: 16)) %
        _domainParams.n;

    var paddedKey = Uint8List(33);
    paddedKey[0] = 0;
    paddedKey.setRange(1, 33, encodeBigInt(childKey));

    var dk = HDPrivateKey._(NetworkType.MAIN, KeyType.PRIVATE);
    dk = _copyParams(dk);

    dk.nodeDepth = nd;
    dk.parentFingerprint = fingerprint;
    dk.childNumber = seriList;
    dk.chainCode = chainCode;
    dk.keyBuffer = paddedKey;

    return dk;
  }

  HDPublicKey _generatePubKey() {
    var hdPublicKey = HDPublicKey(publicKey, networkType, nodeDepth,
        parentFingerprint, childNumber, chainCode, versionBytes);
    return hdPublicKey;
  }

  /// Returns the serialized `xpub`-encoded public key associated with this private key as a string
  String get xpubkey {
    var pubkey = _generatePubKey();

    return pubkey.serialize();
  }

  /// Returns the serialized representation of the extended private key.
  ///
  /// ```
  ///    4 byte: version bytes (mainnet: 0x0488B21E public, 0x0488ADE4 private; testnet: 0x043587CF public, 0x04358394 private)
  ///    1 byte: depth: 0x00 for master nodes, 0x01 for level-1 derived keys, ....
  ///    4 bytes: the fingerprint of the parent's key (0x00000000 if master key)
  ///    4 bytes: child number. This is ser32(i) for i in xi = xpar/i, with xi the key being serialized. (0x00000000 if master key)
  ///    32 bytes: the chain code
  ///    33 bytes: the private key data ( 0x00 or ser256(k) )
  /// ```
  String get xprivkey {
    return serialize();
  }

  /// Converts the [HDPrivateKey] instance to a [BCHPrivateKey].
  /// The generic APIs require [BCHPrivateKey]s, with [HDPrivateKey]
  /// only being used as a means to expose BIP32 wallet functionality
  BCHPrivateKey get privateKey {
    var pk = keyBuffer;

    var normalisedPK = pk.map((elem) => elem.toUnsigned(8)).toList();
    return BCHPrivateKey.fromHex(HEX.encode(normalisedPK), networkType);
  }

  /// Returns the public key associated with this private key as a [BCHPublicKey]
  BCHPublicKey get publicKey {
    var buffer = keyBuffer;

    var privateKey = BCHPrivateKey.fromHex(
        HEX.encode(Uint8List.fromList(buffer)), networkType);

    return privateKey.publicKey;
  }
}
