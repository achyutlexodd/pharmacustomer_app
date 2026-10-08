import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/models/cart_item.dart';
import '../../../core/providers/cart_notifier.dart';
import '../../../core/theme.dart';

class DeviceGridCard extends StatelessWidget {
  final String name;
  final String description;
  final String price;
  final String mrp;
  final String discountBadge;
  final double rating;
  final String reviewCount;
  final VoidCallback? onTap;

  const DeviceGridCard({
    super.key,
    required this.name,
    required this.description,
    required this.price,
    required this.mrp,
    required this.discountBadge,
    required this.rating,
    required this.reviewCount,
    this.onTap,
  });

  double get _parsedPrice {
    final cleaned = price.replaceAll('₹', '').replaceAll(',', '').trim();
    return double.tryParse(cleaned) ?? 0;
  }

  String get _cartId => name.toLowerCase().replaceAll(' ', '_');

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppTheme.outlineBorder),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _DeviceImageSection(discountBadge: discountBadge, rating: rating, reviewCount: reviewCount),
            Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(name,
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: AppTheme.text)),
                  const SizedBox(height: 2),
                  Text(description,
                      style: const TextStyle(color: AppTheme.mutedText, fontSize: 10),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis),
                  const SizedBox(height: 8),
                  Text(price,
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: AppTheme.text)),
                  const SizedBox(height: 2),
                  Text(mrp,
                      style: const TextStyle(
                          decoration: TextDecoration.lineThrough, color: AppTheme.mutedText, fontSize: 11)),
                  const SizedBox(height: 10),
                  _DeviceCartButton(cartId: _cartId, name: name, price: _parsedPrice),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DeviceCartButton extends StatelessWidget {
  final String cartId;
  final String name;
  final double price;
  const _DeviceCartButton({required this.cartId, required this.name, required this.price});

  @override
  Widget build(BuildContext context) {
    final cart = context.watch<CartNotifier>();
    final qty = cart.quantityOf(cartId);

    if (qty == 0) {
      return SizedBox(
        width: double.infinity,
        child: ElevatedButton.icon(
          onPressed: () => context.read<CartNotifier>().add(
                CartItem(id: cartId, name: name, pack: '', price: price),
              ),
          icon: const Icon(Icons.shopping_bag_outlined, size: 14),
          label: const Text('Add to Cart', style: TextStyle(fontSize: 12)),
          style: ElevatedButton.styleFrom(
            backgroundColor: AppTheme.primary,
            minimumSize: const Size(0, 36),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          ),
        ),
      );
    }

    return Container(
      decoration: BoxDecoration(
        color: AppTheme.primaryContainer,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppTheme.primary),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: const Icon(Icons.remove, size: 16, color: AppTheme.primary),
            onPressed: () => context.read<CartNotifier>().remove(cartId),
          ),
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 200),
            transitionBuilder: (child, anim) => ScaleTransition(scale: anim, child: child),
            child: Text('$qty',
                key: ValueKey(qty),
                style: const TextStyle(fontWeight: FontWeight.bold, color: AppTheme.primary, fontSize: 14)),
          ),
          IconButton(
            icon: const Icon(Icons.add, size: 16, color: AppTheme.primary),
            onPressed: () => context.read<CartNotifier>().add(
                  CartItem(id: cartId, name: name, pack: '', price: price),
                ),
          ),
        ],
      ),
    );
  }
}

class _DeviceImageSection extends StatelessWidget {
  final String discountBadge;
  final double rating;
  final String reviewCount;
  const _DeviceImageSection({required this.discountBadge, required this.rating, required this.reviewCount});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          height: 110,
          width: double.infinity,
          decoration: const BoxDecoration(
            color: AppTheme.primaryContainer,
            borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
          ),
          child: const Icon(Icons.monitor_heart_outlined, color: AppTheme.primary, size: 48),
        ),
        Positioned(
          top: 8, left: 8,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
            decoration: BoxDecoration(color: Colors.red.shade400, borderRadius: BorderRadius.circular(6)),
            child: Text(discountBadge,
                style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
          ),
        ),
        Positioned(
          bottom: 8, left: 8,
          child: Row(
            children: [
              const Icon(Icons.star, color: Colors.amber, size: 12),
              const SizedBox(width: 2),
              Text('$rating ($reviewCount)',
                  style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: AppTheme.text)),
            ],
          ),
        ),
      ],
    );
  }
}
