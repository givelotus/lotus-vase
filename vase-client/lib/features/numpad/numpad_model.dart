import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';

const maxLength = 7;

class NumpadModel extends ChangeNotifier {
  final List<String> _items = ['0'];

  UnmodifiableListView<String> get items => UnmodifiableListView(_items);

  String get value => _items.join();

  void setValue(String value) {
    _items.clear();
    _items.addAll(value.split(''));
    notifyListeners();
  }

  void addValue(String value) {
    if (_items.length < maxLength) {
      if (_items.length == 1 && _items.first == '0' && value != '.') {
        _items.removeLast();
      }
      _items.add(value);
      notifyListeners();
    }
  }

  void removeLast() {
    if (_items.isNotEmpty) {
      _items.removeLast();
      if (_items.isEmpty) {
        _items.add('0');
      }
      notifyListeners();
    }
  }
}
