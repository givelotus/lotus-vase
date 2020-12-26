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

    // Ensure the bytes are interpreted as positive by adding a padding.
    var masterKey = [0];
    masterKey.addAll(I.sublist(0, 32));
    var masterChainCode = I.sublist(32, 64);

    final masterKeyBigInt = decodeBigInt(masterKey);
    if (masterKeyBigInt == BigInt.zero || masterKeyBigInt > _domainParams.n) {
      throw DerivationException('Invalid master key was generated.');
    }

    var dk = HDPrivateKey._(NetworkType.MAIN, KeyType.PRIVATE);
    dk = _copyParams(dk);

    nodeDepth = 0;
    parentFingerprint = [0, 0, 0, 0];
    childNumber = [0, 0, 0, 0];
    chainCode = masterChainCode;
    this.networkType = networkType;
    keyType = KeyType.PRIVATE;
    keyBuffer = masterKey;
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
  HDPrivateKey deriveChildNumber(int index, {bool hardened = false}) {
    var elem = ChildNumber(index, hardened);
    return _deriveChildPrivateKey(
      nodeDepth + 1,
      elem,
    );
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
    var lastChild = this;
    var nd = 1;
    for (var elem in children) {
      lastChild = lastChild._deriveChildPrivateKey(
        nd,
        elem,
      );
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

  List<int> get fingerprint {
    return hash160(privateKey.publicKey.point.getEncoded(true)).sublist(0, 4);
  }

  HDPrivateKey _deriveChildPrivateKey(int nd, ChildNumber cn) {
    var seriList = Uint8List(4);
    seriList.buffer.asByteData(0, 4).setUint32(0, cn.i);

    final privateKeyList = Uint8List.fromList(keyBuffer);

    var dataConcat = cn.isHardened()
        ? privateKeyList + seriList
        : publicKey.point.getEncoded(true) + seriList;
    var I = HDUtils.hmacSha512WithKey(
        Uint8List.fromList(chainCode), Uint8List.fromList(dataConcat));

    var lhs = I.sublist(0, 32);
    var childChainCode = I.sublist(32, 64);
    var childKey =
        (decodeBigInt(lhs) + decodeBigInt(privateKeyList)) % _domainParams.n;

    var paddedKey = Uint8List(33);
    final encodedChildKey = encodeBigInt(childKey);
    paddedKey.setRange(33 - encodedChildKey.length, 33, encodeBigInt(childKey));

    var dk = HDPrivateKey._(NetworkType.MAIN, KeyType.PRIVATE);
    dk = _copyParams(dk);

    dk.nodeDepth = nd;
    dk.parentFingerprint = fingerprint;
    dk.childNumber = seriList;
    dk.chainCode = childChainCode;
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
    return BCHPrivateKey.fromBigInt(decodeBigInt(keyBuffer),
        networkType: networkType);
  }

  /// Returns the public key associated with this private key as a [BCHPublicKey]
  BCHPublicKey get publicKey {
    return privateKey.publicKey;
  }
}
