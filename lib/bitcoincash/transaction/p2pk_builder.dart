import 'package:hex/hex.dart';
import 'package:sprintf/sprintf.dart';

import '../exceptions.dart';
import './signed_unlock_builder.dart';
import './locking_script_builder.dart';
import './unlocking_script_builder.dart';
import '../script/bchscript.dart';
import '../signature.dart';
import '../publickey.dart';

mixin P2PKLockMixin on _P2PKLockBuilder implements LockingScriptBuilder {
  @override
  BCHScript getScriptPubkey() {
    if (signerPubkey == null) return BCHScript();

    var pubKeySize = HEX.decode(signerPubkey.toString()).length;
    var scriptString =
        sprintf('%s 0x%s OP_CHECKSIG', [pubKeySize, signerPubkey.toString()]);

    return BCHScript.fromString(scriptString);
  }
}

abstract class _P2PKLockBuilder implements LockingScriptBuilder {
  BCHPublicKey signerPubkey;

  _P2PKLockBuilder(this.signerPubkey);

  // BCHScript get scriptPubkey => getScriptPubkey();

  @override
  void fromScript(BCHScript script) {
    if (script != null && script.buffer != null) {
      var chunkList = script.chunks;

      if (chunkList.length != 2) {
        throw ScriptException(
            'Wrong number of data elements for P2PK ScriptPubkey');
      }

      signerPubkey = BCHPublicKey.fromDER(chunkList[0].buf);
    } else {
      throw ScriptException('Invalid Script or Malformed Script.');
    }
  }
}

class P2PKLockBuilder extends _P2PKLockBuilder with P2PKLockMixin {
  P2PKLockBuilder(BCHPublicKey signerPubkey) : super(signerPubkey);
}

mixin P2PKUnlockMixin on _P2PKUnlockBuilder implements UnlockingScriptBuilder {
  @override
  BCHScript getScriptSig() {
    if (signatures.isEmpty) return BCHScript();

    var signatureSize = HEX.decode(signatures[0].toTxFormat()).length;
    var scriptString =
        sprintf('%s 0x%s', [signatureSize, signatures[0].toTxFormat()]);

    return BCHScript.fromString(scriptString);
  }
}

abstract class _P2PKUnlockBuilder extends SignedUnlockBuilder
    implements UnlockingScriptBuilder {
  _P2PKUnlockBuilder();

  @override
  List<BCHSignature> signatures = <BCHSignature>[];

  BCHScript get scriptSig => getScriptSig();

  @override
  void fromScript(BCHScript script) {
    throw UnimplementedError();
  }
}

class P2PKUnlockBuilder extends _P2PKUnlockBuilder with P2PKUnlockMixin {
  P2PKUnlockBuilder() : super();
}
