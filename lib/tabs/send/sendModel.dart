import 'package:flutter/foundation.dart';

class SendModel with ChangeNotifier {
  int? _sendAmount;
  String? _sendToAddress;
  List<String> _errors = [];

  // TODO: Storage should be injected
  SendModel() {
    _sendToAddress = '';
    _sendAmount = null;
  }

  int? get sendAmount => _sendAmount;

  String? get sendToAddress => _sendToAddress;

  List<String> get errors => _errors;

  set sendToAddress(String? newValue) {
    _sendToAddress = newValue;
    notifyListeners();
  }

  set sendAmount(int? newValue) {
    _sendAmount = newValue;
    notifyListeners();
  }

  set errors(List<String> newValue) {
    _errors = newValue;
    notifyListeners();
  }
}
