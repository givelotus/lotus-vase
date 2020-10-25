import 'package:hex/hex.dart';
import 'package:sprintf/sprintf.dart';

import '../exceptions.dart';
import '../script/opcodes.dart';
import '../../bitcoincash.dart';

import 'signed_unlock_builder.dart';

/// ** P2PMS (multisig) locking Script (output script / scriptPubkey) ***
mixin P2MSLockMixin on _P2MSLockBuilder implements LockingScriptBuilder {
  @override
  BCHScript getScriptPubkey() {
    if (publicKeys == null || requiredSigs == 0) return BCHScript();

    if (publicKeys.length > 15) {
      throw ScriptException(
          'Too many public keys. P2MS limit is 15 public keys');
    }

    if (requiredSigs > publicKeys.length) {
      throw ScriptException("You can't have more signatures than public keys");
    }

    if (sorting) {
      publicKeys.sort((a, b) =>
          a.toString().compareTo(b.toString())); // sort the keys by default
    }
    var pubKeyString = publicKeys.fold(
        '',
        (prev, elem) =>
            prev +
            sprintf(
                ' %s 0x%s', [HEX.decode(elem.toHex()).length, elem.toHex()]));

    var scriptString = sprintf('OP_%s %s OP_%s OP_CHECKMULTISIG',
        [requiredSigs, pubKeyString, publicKeys.length]);

    // OP_3 <pubKey1> <pubKey2> <pubKey3> <pubKey4> <pubKey5> OP_5 OP_CHECKMULTISIG
    return BCHScript.fromString(scriptString);
  }
}

abstract class _P2MSLockBuilder implements LockingScriptBuilder {
  List<BCHPublicKey> publicKeys;
  int requiredSigs;
  bool sorting;

  _P2MSLockBuilder(this.publicKeys, this.requiredSigs, this.sorting);

  @override
  void fromScript(BCHScript script) {
    if (script != null && script.buffer != null) {
      var chunkList = script.chunks;

      if (chunkList[chunkList.length - 1].opcodenum !=
          OpCodes.OP_CHECKMULTISIG) {
        throw ScriptException(
            'Malformed multisig script. OP_CHECKMULTISIG is missing.');
      }

      var keyCount = chunkList[0].opcodenum - 80;

      publicKeys = <BCHPublicKey>[];
      for (var i = 1; i < keyCount + 1; i++) {
        publicKeys.add(BCHPublicKey.fromDER(chunkList[i].buf));
      }

      requiredSigs = chunkList[keyCount + 1].opcodenum - 80;
    } else {
      throw ScriptException('Invalid Script or Malformed Script.');
    }
  }
}

class P2MSLockBuilder extends _P2MSLockBuilder with P2MSLockMixin {
  P2MSLockBuilder(List<BCHPublicKey> publicKeys, int requiredSigs,
      {sorting = true})
      : super(publicKeys, requiredSigs, sorting);
}

/// ** P2MS (multisig) unlocking Script (scriptSig / Input script) ***
mixin P2MSUnlockMixin on _P2MSUnlockBuilder implements UnlockingScriptBuilder {
  @override
  BCHScript getScriptSig() {
    var multiSigs = signatures.fold(
        '',
        (prev, elem) =>
            prev +
            sprintf(' %s 0x%s',
                [HEX.decode(elem.toTxFormat()).length, elem.toTxFormat()]));

    return BCHScript.fromString('OP_0 ${multiSigs}');
  }
}

/// Signatures are injected by the framework when you call Transaction().signInput()
/// Make consecutive calls to the signInput() function to had the signatures
/// added to the [SignedUnlockBuilder] instance associated with the [Transaction].
///
abstract class _P2MSUnlockBuilder extends SignedUnlockBuilder
    implements UnlockingScriptBuilder {
  @override
  List<BCHSignature> signatures = <BCHSignature>[];

  _P2MSUnlockBuilder();

  @override
  void fromScript(BCHScript script) {
    if (script != null && script.buffer != null) {
      var chunkList = script.chunks;

      // skip first chunk. typically OP_O
      for (var i = 1; i < chunkList.length; i++) {
        signatures.add(BCHSignature.fromTxFormat(HEX.encode(chunkList[i].buf)));
      }
    } else {
      throw ScriptException('Invalid Script or Malformed Script.');
    }
  }

  BCHScript get scriptSig => getScriptSig();
}

class P2MSUnlockBuilder extends _P2MSUnlockBuilder with P2MSUnlockMixin {
  // Expect the Signature to be injected after the fact. Input Signing is a
  // weird one.
  P2MSUnlockBuilder() : super();
}
