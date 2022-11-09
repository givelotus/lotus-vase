import 'signed_unlock_builder.dart';
import 'locking_script_builder.dart';
import 'unlocking_script_builder.dart';
import '../script/bchscript.dart';
import '../signature.dart';

mixin DefaultLockMixin on _DefaultLockBuilder implements LockingScriptBuilder {
  @override
  BCHScript getScriptPubkey() {
    return script;
  }
}

abstract class _DefaultLockBuilder implements LockingScriptBuilder {
  BCHScript _script = BCHScript();
  _DefaultLockBuilder();

  BCHScript get scriptPubkey => getScriptPubkey();

  @override
  void fromScript(BCHScript script) {
    _script = script;
  }

  BCHScript get script => _script;
}

class DefaultLockBuilder extends _DefaultLockBuilder with DefaultLockMixin {
  DefaultLockBuilder() : super();
}

mixin DefaultUnlockMixin on _DefaultUnlockBuilder
    implements UnlockingScriptBuilder {
  @override
  BCHScript? getScriptSig() {
    return script;
  }
}

abstract class _DefaultUnlockBuilder extends SignedUnlockBuilder
    implements UnlockingScriptBuilder {
  BCHScript? _script = BCHScript();

  _DefaultUnlockBuilder();

  @override
  List<BCHSignature> signatures = <BCHSignature>[];

  BCHScript? get scriptSig => getScriptSig();

  @override
  void fromScript(BCHScript? script) {
    _script = script;
  }

  BCHScript? get script => _script;
}

class DefaultUnlockBuilder extends _DefaultUnlockBuilder
    with DefaultUnlockMixin {
  DefaultUnlockBuilder() : super();
}
