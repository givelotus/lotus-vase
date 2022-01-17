import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';
import 'package:vase/components/numpad/numpad.dart';

const MAX_LENGTH = 7;

class NumpadModel extends ChangeNotifier {
  final List<KeyValue> _items = [];

  /// An unmodifiable view of the items in the cart.
  UnmodifiableListView<KeyValue> get items => UnmodifiableListView(_items);

  void addValue(KeyValue value) {
    print('added');
    if (_items.length < MAX_LENGTH) {
      print('added');
      _items.add(value);
      notifyListeners();
    }
  }

  void removeLast() {
    print('added');
    if (_items.isNotEmpty) {
      _items.removeLast();
      notifyListeners();
    }
  }
}
