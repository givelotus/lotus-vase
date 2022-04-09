class AppException implements Exception {
  String message;

  AppException(this.message);
}

class AddressFormatException implements AppException {
  String message;

  AddressFormatException(this.message);
}

class BadChecksumException implements AppException {
  @override
  String message;

  BadChecksumException(this.message);
}

class BadParameterException implements AppException {
  @override
  String message;

  BadParameterException(this.message);
}

class InvalidPointException implements AppException {
  @override
  String message;

  InvalidPointException(this.message);
}

class InvalidNetworkException implements AppException {
  @override
  String message;

  InvalidNetworkException(this.message);
}

class InvalidKeyException implements AppException {
  @override
  String message;

  InvalidKeyException(this.message);
}

class IllegalArgumentException implements AppException {
  @override
  String message;

  IllegalArgumentException(this.message);
}

class DerivationException implements AppException {
  @override
  String message;

  DerivationException(this.message);
}

class InvalidPathException implements AppException {
  @override
  String message;

  InvalidPathException(this.message);
}

class UTXOException implements AppException {
  @override
  String message;

  UTXOException(this.message);
}

class TransactionAmountException implements AppException {
  @override
  String message;

  TransactionAmountException(this.message);
}

class ScriptException implements AppException {
  @override
  String message;

  ScriptException(this.message);
}

class SignatureException implements AppException {
  @override
  String message;

  SignatureException(this.message);
}

class TransactionFeeException implements AppException {
  @override
  String message;

  TransactionFeeException(this.message);
}

class InputScriptException implements AppException {
  @override
  String message;

  InputScriptException(this.message);
}

class TransactionException implements AppException {
  @override
  String message;

  TransactionException(this.message);
}

class LockTimeException implements AppException {
  @override
  String message;

  LockTimeException(this.message);
}

class InterpreterException implements AppException {
  @override
  String message;

  InterpreterException(this.message);
}

class BlockException implements AppException {
  @override
  String message;

  BlockException(this.message);
}

class MerkleTreeException implements AppException {
  @override
  String message;

  MerkleTreeException(this.message);
}
