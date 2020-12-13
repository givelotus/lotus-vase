import 'dart:convert';

import './bitcoincash.dart';
import 'package:hex/hex.dart';

import 'encoding/utils.dart';

/// ## Bitcoin Signed Messages
///
/// The *Bitcoin Signed Message* "standard" takes a novel approach in relying on our ability
/// to recover a Public Key from an ECDSA signature.
/// Once we have the public key recovered we can then generate a corresponding bitcoin
/// wallet Address and verify that an *address corresponds to a signature*.
///
/// Private Key (is used to generate) ---> Signature (is used to recover) --->  Public Key (is used to create) --->  Address
///
/// Reference (section 4.1.6) : http:// www.secg.org/sec1-v2.pdf
class Message {
  List<int> _message;
  // TODO: FIX unused?
  // BCHPrivateKey _privateKey;

  final MAGIC_BYTES = 'Bitcoin Signed Message:\n';

  /// A double-sha256 digest unique to Bitcoin Signed Messages
  ///
  /// The hash is constructed from the double-sha256 of a buffer.
  /// The buffer is composed from appending the following elements in order:
  ///
  /// * The integer Length of MAGIC_BYTES
  /// * MAGIC_BYTES which is the string literal "Bitcoin Signed Message:\n"
  /// * The integer length of the message that needs to be signed
  /// * The message text
  ///
  /// Returns the double-sha256 of the buffer constructed as shown above
  List<int> magicHash() {
    var prefix1 = MAGIC_BYTES.length;
    var prefix2 = _message.length;
    var buf =
        HEX.encode([prefix1] + utf8.encode(MAGIC_BYTES) + [prefix2] + _message);
    var hash = sha256Twice(HEX.decode(buf));
    return hash;
  }

  /// Constructs a new Message object
  ///
  /// `message` - UTF-8 encoded byte buffer containing the message
  Message(List<int> message) {
    _message = message;
  }

  /// Sign the message using the private key
  ///
  /// `privateKey` - The private key to use in signing the message
  ///
  String sign(BCHPrivateKey privateKey) {
    var signature = BCHSignature.fromPrivateKey(privateKey);
    // TODO: FIX What is going on here with this class member?
    // _privateKey = privateKey;
    //  signature.signWithCalcI(HEX.encode(this.magicHash()));
    signature.sign(HEX.encode(magicHash()), forCompact: true);

    var compactSig = signature.toCompact();

    return base64Encode(compactSig);
  }

  /// Verify that this message was signed by the owner of corresponding Address in [address]
  ///
  /// `address` - The Address we want to use for signature verification. *NOTE* :
  ///             this is *the address derived from the public key, which belongs to the private key used to sign this message*.
  ///
  /// `sigBuffer` - The base64-encoded Signature
  ///
  /// Returns *true* if the signature was successfully verified using the address, *false* otherwise.
  bool verifyFromAddress(Address address, String sigBuffer) {
    var signature =
        BCHSignature.fromCompact(base64Decode(sigBuffer), magicHash());

    var recoveredPubKey = signature.publicKey;

    var recoveredAddress = recoveredPubKey.toAddress(address.networkType);

    // sanity check on address
    if (address.toBase58() != recoveredAddress.toBase58()) {
      return false;
    }

    return _verify(signature);
  }

  /// Verify that this message was signed by the owner of public key in [publicKey]
  ///
  /// `publicKey` - Public key to be used in signature verification
  ///
  ///`sigBuffer` - Base64-encoded Compact Signature
  ///
  /// Returns *true* if the signature is successfully verified using the public Key, *false* otherwise.
  bool verifyFromPublicKey(BCHPublicKey publicKey, String sigBuffer) {
    var signature =
        BCHSignature.fromCompact(base64Decode(sigBuffer), magicHash());

    var recoveredKey = signature.publicKey;

    // sanity check on public key
    if (recoveredKey.point != publicKey.point) {
      return false;
    }

    return _verify(signature);
  }

  bool _verify(BCHSignature signature) {
    var hash = magicHash();

    // TODO: FIX So much hoop-jumping ! I already have a Signature instance, why am I passing another signature into it's "verify" method !!???
    ///
    return signature.verify(HEX.encode(hash));
  }

  /// The message we are signing/verifying
  List<int> get message => _message;
}
