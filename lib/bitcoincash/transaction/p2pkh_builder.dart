import 'package:hex/hex.dart';
import 'package:sprintf/sprintf.dart';

import '../exceptions.dart';
import '../script/opcodes.dart';
import '../script/bchscript.dart';
import '../publickey.dart';
import '../networks.dart';
import '../address.dart';
import '../signature.dart';
import '../encoding/utils.dart';

import 'locking_script_builder.dart';
import 'unlocking_script_builder.dart';
import 'signed_unlock_builder.dart';

/// ** P2PKH locking Script ***
mixin P2PKHLockMixin on _P2PKHLockBuilder implements LockingScriptBuilder {
  @override
  BCHScript getScriptPubkey() {
    String destAddress;
    int addressLength;
    if (address != null) {
      destAddress = address.address; // hash160(pubkey) aka pubkeyHash

      addressLength = HEX.decode(destAddress).length;

      // TODO: FIX Another hack. For some reason some addresses don't have proper ripemd160 hashes of the hex value. Fix later !
      if (addressLength == 33) {
        addressLength = 20;
        destAddress = HEX.encode(hash160(HEX.decode(destAddress)));
      }
    } else if (pubkeyHash != null) {
      addressLength = pubkeyHash.length;
      destAddress = HEX.encode(pubkeyHash);
    } else {
      return BCHScript(); // return empty script if no pubkeyHash or Address
    }

    var scriptString = sprintf(
        'OP_DUP OP_HASH160 %s 0x%s OP_EQUALVERIFY OP_CHECKSIG',
        [addressLength, destAddress]);

    return BCHScript.fromString(scriptString);
  }
}

abstract class _P2PKHLockBuilder implements LockingScriptBuilder {
  Address address;
  List<int> pubkeyHash;

  _P2PKHLockBuilder(this.address);

  _P2PKHLockBuilder.fromPublicKey(BCHPublicKey publicKey,
      {NetworkType networkType = NetworkType.MAIN}) {
    address = publicKey.toAddress(networkType: networkType);
    pubkeyHash = HEX.decode(address.pubkeyHash160);
  }

  @override
  void fromScript(BCHScript script) {
    if (script != null && script.buffer != null) {
      var chunkList = script.chunks;

      if (chunkList.length != 5) {
        throw ScriptException(
            'Wrong number of data elements for P2PKH ScriptPubkey');
      }

      if (chunkList[2].len != 20) {
        throw ScriptException('Signature and Public Key values are malformed');
      }

      if (!(chunkList[0].opcodenum == OpCodes.OP_DUP &&
          chunkList[1].opcodenum == OpCodes.OP_HASH160 &&
          chunkList[3].opcodenum == OpCodes.OP_EQUALVERIFY &&
          chunkList[4].opcodenum == OpCodes.OP_CHECKSIG)) {
        throw ScriptException(
            'Malformed P2PKH ScriptPubkey script. Mismatched OP_CODES.');
      }

      pubkeyHash = chunkList[2].buf;
    } else {
      throw ScriptException('Invalid Script or Malformed Script.');
    }
  }
}

class P2PKHLockBuilder extends _P2PKHLockBuilder with P2PKHLockMixin {
  P2PKHLockBuilder(Address address) : super(address);
  P2PKHLockBuilder.fromPublicKey(BCHPublicKey publicKey,
      {NetworkType networkType = NetworkType.MAIN})
      : super.fromPublicKey(publicKey, networkType: networkType);
}

/// ** P2PKH unlocking Script (scriptSig / Input script) ***
mixin P2PKHUnlockMixin on _P2PKHUnlockBuilder
    implements UnlockingScriptBuilder {
  /// The developer is required to perform their own error handling when
  /// implementing this method. You should consider throwing an exception if
  /// your Signature value is null, because that guards you against trying to
  /// serialize an unsigned TX.
  @override
  BCHScript getScriptSig() {
    if (signatures == null || signatures.isEmpty || signerPubkey == null) {
      return BCHScript();
    }

    var pubKeySize = HEX.decode(signerPubkey.toString()).length;
    var signatureSize = HEX.decode(signatures[0].toTxFormat()).length;
    var scriptString = sprintf('%s 0x%s %s 0x%s', [
      signatureSize,
      signatures[0].toTxFormat(),
      pubKeySize,
      signerPubkey.toString()
    ]);

    return BCHScript.fromString(scriptString);
  }
}

abstract class _P2PKHUnlockBuilder extends SignedUnlockBuilder
    implements UnlockingScriptBuilder {
  BCHPublicKey signerPubkey;

  @override
  List<BCHSignature> signatures = <BCHSignature>[];

  // The signature *must* be injected later, because of the way SIGHASH works
  // Hence the contract enforced by SignedUnlockBuilder
  _P2PKHUnlockBuilder(this.signerPubkey);

  // Allow the scriptSig to be initialized from Script.
  // Parse signature and signerPubkey

  @override
  void fromScript(BCHScript script) {
    if (script != null && script.buffer != null) {
      var chunkList = script.chunks;

      if (chunkList.length != 2) {
        throw ScriptException(
            'Wrong number of data elements for P2PKH ScriptSig');
      }

      // removing for now... we might have compressed pubkey
      // if (chunkList[0].len != 73 && chunkList[1].len != 65){
      //   throw ScriptException("Signature and Public Key values are malformed");
      // }

      var sig = chunkList[0].buf;
      var pubKey = chunkList[1].buf;

      signerPubkey = BCHPublicKey.fromHex(HEX.encode(pubKey));
      signatures.add(BCHSignature.fromTxFormat(HEX.encode(sig)));
    } else {
      throw ScriptException('Invalid Script or Malformed Script.');
    }
  }

  BCHScript get scriptSig => getScriptSig();
}

// TODO: FIX We need to figure out a way to enforce the requirement of a "fromScript()"
// constructor here. Dunno if it's possible
class P2PKHUnlockBuilder extends _P2PKHUnlockBuilder with P2PKHUnlockMixin {
  // Expect the Signature to be injected after the fact. Input Signing is a
  // weird one.
  P2PKHUnlockBuilder(BCHPublicKey signerPubkey) : super(signerPubkey);
}
