import 'package:flutter/foundation.dart';
import 'package:cashew/wallet/wallet.dart';

class CashewModel with ChangeNotifier {
  String _sendToAddress;
  int _sendAmount;

  Wallet _activeWallet;
  bool _initialized = false;

  CashewModel(sendToAddress, activeWallet) {
    this.sendToAddress = _sendToAddress;
    this.activeWallet = activeWallet;
    _sendAmount = null;
    this
        .activeWallet
        .initialize()
        .then((value) => this.activeWallet.updateUtxos())
        .then((value) => this.activeWallet.refreshBalanceLocal())
        .then((value) => initialized = true)
        .then((value) => this.activeWallet.startUtxoListeners());
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

  String get sendToAddress => _sendToAddress;

  set sendToAddress(String newValue) {
    _sendToAddress = newValue;
    notifyListeners();
  }
}
