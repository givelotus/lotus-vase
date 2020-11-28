import 'package:flutter/foundation.dart';
import 'package:cashew/wallet/wallet.dart';

class CashewModel with ChangeNotifier {
  String _sendToAddress;
  int _sendAmount;

  Wallet wallet;
  bool _initialized = false;

  CashewModel(sendToAddress, wallet) {
    this.sendToAddress = _sendToAddress;
    this.wallet = wallet;

    this.wallet.initialize().then((value) => initialized = true);
    _sendAmount = null;
  }

  set initialized(bool newValue) {
    _initialized = newValue;
    notifyListeners();
  }

  bool get initialized => _initialized;

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
