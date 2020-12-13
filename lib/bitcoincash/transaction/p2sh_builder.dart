import 'package:hex/hex.dart';
import 'package:sprintf/sprintf.dart';

import '../exceptions.dart';
import './signed_unlock_builder.dart';
import './locking_script_builder.dart';
import './unlocking_script_builder.dart';
import '../script/bchscript.dart';
import '../signature.dart';
import '../encoding/utils.dart';

/// ** P2PMS (multisig) locking Script (output script / scriptPubkey) ***
mixin P2SHLockMixin on _P2SHLockBuilder implements LockingScriptBuilder {
  @override
  BCHScript getScriptPubkey() {
    // OP_HASH160 <the script hash> OP_EQUAL
    if (scriptHash == null || scriptHash.isEmpty) return BCHScript();

    var hashHex = HEX.decode(scriptHash);
    var script =
        sprintf('OP_HASH160 %s 0x%s OP_EQUAL', [hashHex.length, scriptHash]);

    return BCHScript.fromString(script);
  }
}

abstract class _P2SHLockBuilder implements LockingScriptBuilder {
  String scriptHash;

  _P2SHLockBuilder(this.scriptHash);

  /// In this case our fromScript() method won't assume that we are being passed
  /// a P2SH formatted script. I.e. the usual format of `OP_HASH160 <hash> OP_EQUAL`
  /// won't be assumed.
  ///
  /// [script] - Arbitrary script for which we want to generate a P2SH locking script
  @override
  void fromScript(BCHScript script) {
    if (script != null && script.buffer != null) {
      // create a hash of the serialized script
      var hash = hash160(HEX.decode(script.toHex()));

      scriptHash = HEX.encode(hash);
    } else {
      throw ScriptException('Invalid Script or Malformed Script.');
    }
  }
}

class P2SHLockBuilder extends _P2SHLockBuilder with P2SHLockMixin {
  P2SHLockBuilder(String hash) : super(hash);
}

/// P2SH unlocking Script
mixin P2SHUnlockMixin on _P2SHUnlockBuilder implements UnlockingScriptBuilder {
  @override
  BCHScript getScriptSig() {
    return script;
  }
}

/// Signatures are injected by the framework when you call Transaction().signInput()
/// Make consecutive calls to the signInput() function to had the signatures
/// added to the [SignedUnlockBuilder] instance associated with the [Transaction].
///
abstract class _P2SHUnlockBuilder extends SignedUnlockBuilder
    implements UnlockingScriptBuilder {
  @override
  List<BCHSignature> signatures = <BCHSignature>[];

  BCHScript script;

  _P2SHUnlockBuilder();

  @override
  void fromScript(BCHScript script) {
    if (script != null && script.buffer != null) {
      this.script = script;
    } else {
      throw ScriptException('Invalid Script or Malformed Script.');
    }
  }

  BCHScript get scriptSig => getScriptSig();
}

class P2SHUnlockBuilder extends _P2SHUnlockBuilder with P2SHUnlockMixin {
  P2SHUnlockBuilder() : super();
}
