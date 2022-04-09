import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';

const maxLength = 7;

class SendModel extends ChangeNotifier {
  BigInt? _amount;
  String _address = '';

  final List<String> _items = ['0'];

  UnmodifiableListView<String> get items => UnmodifiableListView(_items);

  BigInt? get amount => _amount;
  String get address => _address;

  void setAmount(BigInt? amount) {
    _amount = amount;
    notifyListeners();
  }

  void setAddress(String address) {
    _address = address;
    notifyListeners();
  }
}
