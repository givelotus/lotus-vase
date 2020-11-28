import 'package:flutter/foundation.dart';

class SendModel with ChangeNotifier {
  int _sendAmount;
  String _sendToAddress;

  // TODO: Storage should be injected
  SendModel() {
    _sendToAddress = '';
    _sendAmount = null;
  }

  set sendAmount(int newValue) {
    _sendAmount = newValue;
    notifyListeners();
  }

  int get sendAmount => _sendAmount;

  String get sendToAddress => _sendToAddress;

  set sendToAddress(String newValue) {
    _sendToAddress = newValue;
    notifyListeners();
  }
}
