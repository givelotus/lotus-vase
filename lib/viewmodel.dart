import 'package:flutter/foundation.dart';
import 'package:cashew/wallet/wallet.dart';

class CashewModel with ChangeNotifier {
  String _sendToAddress;
  Wallet _activeWallet;
  bool _initialized = false;

  CashewModel(sendToAddress, activeWallet) {
    this.sendToAddress = _sendToAddress;
    this.activeWallet = activeWallet;
    this.activeWallet.initialize().then((value) => initialized = true);
  }

  Wallet get activeWallet => _activeWallet;

  set initialized(bool newValue) {
    _initialized = newValue;
    notifyListeners();
  }

  bool get initialized => _initialized;

  set activeWallet(Wallet newValue) {
    _activeWallet = newValue;
    notifyListeners();
  }

  String get sendToAddress => _sendToAddress;

  set sendToAddress(String newValue) {
    _sendToAddress = newValue;
    notifyListeners();
  }
}
