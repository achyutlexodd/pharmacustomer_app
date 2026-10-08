import 'package:flutter/foundation.dart';

import '../models/cart_item.dart';

class CartNotifier extends ChangeNotifier {
  final Map<String, CartItem> _items = {};

  List<CartItem> get items => _items.values.toList();

  int get totalCount => _items.values.fold(0, (sum, i) => sum + i.quantity);

  double get totalPrice => _items.values.fold(0.0, (sum, i) => sum + i.total);

  int quantityOf(String id) => _items[id]?.quantity ?? 0;

  void add(CartItem item) {
    if (_items.containsKey(item.id)) {
      final current = _items[item.id]!;
      if (current.quantity < 10) {
        current.quantity++;
        notifyListeners();
      }
    } else {
      _items[item.id] = item;
      notifyListeners();
    }
  }

  void remove(String id) {
    if (!_items.containsKey(id)) return;
    if (_items[id]!.quantity > 1) {
      _items[id]!.quantity--;
    } else {
      _items.remove(id);
    }
    notifyListeners();
  }

  void clear() {
    _items.clear();
    notifyListeners();
  }
}
