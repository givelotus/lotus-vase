import 'package:flutter/foundation.dart';

const maxLength = 7;

class SendModel extends ChangeNotifier {
  BigInt _amount = BigInt.zero;
  String _address = '';

  BigInt get amount => _amount;
  String get address => _address;

  void setAmount(BigInt amount) {
    _amount = amount;
    notifyListeners();
  }

  void setAddress(String address) {
    _address = address;
    notifyListeners();
  }
}
