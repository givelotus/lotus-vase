class AddressFormatException implements Exception {
  String message;

  AddressFormatException(this.message);
}

class BadChecksumException implements AddressFormatException {
  @override
  String message;

  BadChecksumException(this.message);
}

class BadParameterException implements Exception {
  String message;

  BadParameterException(this.message);
}

class InvalidPointException implements Exception {
  String? message;

  InvalidPointException(this.message);
}

class InvalidNetworkException implements Exception {
  String message;

  InvalidNetworkException(this.message);
}

class InvalidKeyException implements Exception {
  String message;

  InvalidKeyException(this.message);
}

class IllegalArgumentException implements Exception {
  String message;

  IllegalArgumentException(this.message);
}

class DerivationException implements Exception {
  String message;

  DerivationException(this.message);
}

class InvalidPathException implements Exception {
  String message;

  InvalidPathException(this.message);
}

class UTXOException implements Exception {
  String message;

  UTXOException(this.message);
}

class TransactionAmountException implements Exception {
  String message;

  TransactionAmountException(this.message);
}

class ScriptException implements Exception {
  String message;

  ScriptException(this.message);
}

class SignatureException implements Exception {
  String? message;

  SignatureException(this.message);
}

class TransactionFeeException implements Exception {
  String message;

  TransactionFeeException(this.message);
}

class InputScriptException implements Exception {
  String message;

  InputScriptException(this.message);
}

class TransactionException implements Exception {
  String message;

  TransactionException(this.message);
}

class LockTimeException implements Exception {
  String message;

  LockTimeException(this.message);
}

class InterpreterException implements Exception {
  String message;

  InterpreterException(this.message);
}

class BlockException implements Exception {
  String message;

  BlockException(this.message);
}

class MerkleTreeException implements Exception {
  String message;

  MerkleTreeException(this.message);
}
