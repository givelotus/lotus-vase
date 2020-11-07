import 'package:flutter/foundation.dart';
import 'package:cashew/wallet/wallet.dart';
import 'package:cashew/bitcoincash/src/address.dart';

class CashewModel with ChangeNotifier {
  String _sendToAddress;
  int _sendAmount;

  Wallet _activeWallet;
  bool _initialized = false;
  bool _showSendInfoScreen = false;

  CashewModel(sendToAddress, activeWallet) {
    this.sendToAddress = _sendToAddress;
    this.activeWallet = activeWallet;
    _sendAmount = null;
    this.activeWallet.initialize().then((value) => initialized = true);
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

  Wallet get activeWallet => _activeWallet;

  set activeWallet(Wallet newValue) {
    _activeWallet = newValue;
    notifyListeners();
  }

  bool get showSendInfoScreen => _showSendInfoScreen;

  set showSendInfoScreen(bool newValue) {
    _showSendInfoScreen = newValue;
    notifyListeners();
  }

  String get sendToAddress => _sendToAddress;

  set sendToAddress(String newValue) {
    _sendToAddress = newValue;
    notifyListeners();
  }
}
