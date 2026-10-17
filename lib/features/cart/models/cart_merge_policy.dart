import 'dart:math';
import '../../../core/models/cart_item.dart';

class CartMergePolicy {
  /// Merges two lists of cart items using max quantity per product, clamped to [maxQuantity] (default 10).
  static List<CartItem> mergeMaxQuantity(
    List<CartItem> localLines,
    List<CartItem> serverLines, {
    int maxQuantity = 10,
  }) {
    final Map<String, CartItem> merged = {};

    for (final item in localLines) {
      merged[item.id] = item;
    }

    for (final item in serverLines) {
      if (merged.containsKey(item.id)) {
        final existing = merged[item.id]!;
        final newQty = min(max(existing.quantity, item.quantity), maxQuantity);
        merged[item.id] = existing.copyWith(
          quantity: newQty,
          price: item.price, // Server price wins
          requiresPrescription: item.requiresPrescription,
        );
      } else {
        merged[item.id] = item.copyWith(
          quantity: min(item.quantity, maxQuantity),
        );
      }
    }

    return merged.values.toList();
  }
}
