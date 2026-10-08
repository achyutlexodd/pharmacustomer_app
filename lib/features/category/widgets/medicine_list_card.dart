import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/models/cart_item.dart';
import '../../../core/providers/cart_notifier.dart';
import '../../../core/theme.dart';

class MedicineListCard extends StatelessWidget {
  final String name;
  final String description;
  final String price;
  final String mrp;
  final String discount;
  final String badge;
  final bool requiresPrescription;
  final String? tag;
  final String? deliveryNote;
  final VoidCallback? onTap;

  const MedicineListCard({
    super.key,
    required this.name,
    required this.description,
    required this.price,
    required this.mrp,
    required this.discount,
    required this.badge,
    required this.requiresPrescription,
    this.tag,
    this.deliveryNote,
    this.onTap,
  });

  // Strip '₹' and commas to get a double for the cart
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
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppTheme.outlineBorder),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _MedicineIcon(tag: tag),
                const SizedBox(width: 12),
                Expanded(
                  child: _MedicineInfo(
                    badge: badge,
                    name: name,
                    description: description,
                    tag: tag,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _PriceRow(price: price, mrp: mrp, discount: discount),
                _CartControl(cartId: _cartId, name: name, pack: tag ?? '', price: _parsedPrice),
              ],
            ),
            if (deliveryNote != null) ...[
              const SizedBox(height: 6),
              Text(deliveryNote!, style: const TextStyle(fontSize: 11, color: AppTheme.mutedText)),
            ],
          ],
        ),
      ),
    );
  }
}

// ── Cart control (Add / counter) ──────────────────────────────────────────────

class _CartControl extends StatelessWidget {
  final String cartId;
  final String name;
  final String pack;
  final double price;

  const _CartControl({required this.cartId, required this.name, required this.pack, required this.price});

  @override
  Widget build(BuildContext context) {
    final cart = context.watch<CartNotifier>();
    final qty = cart.quantityOf(cartId);

    if (qty == 0) {
      return ElevatedButton(
        onPressed: () => context.read<CartNotifier>().add(
              CartItem(id: cartId, name: name, pack: pack, price: price),
            ),
        style: ElevatedButton.styleFrom(
          backgroundColor: AppTheme.primaryContainer,
          foregroundColor: AppTheme.primary,
          elevation: 0,
          minimumSize: const Size(80, 36),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
        child: const Text('+ Add', style: TextStyle(fontWeight: FontWeight.bold)),
      );
    }

    return Container(
      decoration: BoxDecoration(
        color: AppTheme.primaryContainer,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
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
                style: const TextStyle(fontWeight: FontWeight.bold, color: AppTheme.primary)),
          ),
          IconButton(
            icon: const Icon(Icons.add, size: 16, color: AppTheme.primary),
            onPressed: () => context.read<CartNotifier>().add(
                  CartItem(id: cartId, name: name, pack: pack, price: price),
                ),
          ),
        ],
      ),
    );
  }
}

// ── Private sub-widgets ───────────────────────────────────────────────────────

class _MedicineIcon extends StatelessWidget {
  final String? tag;
  const _MedicineIcon({this.tag});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 70,
      height: 70,
      decoration: BoxDecoration(color: AppTheme.primaryContainer, borderRadius: BorderRadius.circular(12)),
      child: Stack(
        alignment: Alignment.center,
        children: [
          const Icon(Icons.medication, color: AppTheme.primary, size: 34),
          if (tag != null)
            Positioned(
              bottom: 4,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
                decoration: BoxDecoration(color: Colors.white70, borderRadius: BorderRadius.circular(4)),
                child: Text(tag!, style: const TextStyle(fontSize: 8, fontWeight: FontWeight.bold, color: AppTheme.text)),
              ),
            ),
        ],
      ),
    );
  }
}

class _MedicineInfo extends StatelessWidget {
  final String badge;
  final String name;
  final String description;
  final String? tag;
  const _MedicineInfo({required this.badge, required this.name, required this.description, this.tag});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (tag != null) Text(tag!, style: const TextStyle(fontSize: 10, color: AppTheme.mutedText)),
        const SizedBox(height: 2),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
          decoration: BoxDecoration(color: AppTheme.errorBg, borderRadius: BorderRadius.circular(4)),
          child: Text(badge, style: const TextStyle(fontSize: 10, color: AppTheme.error, fontWeight: FontWeight.bold)),
        ),
        const SizedBox(height: 4),
        Text(name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: AppTheme.text)),
        const SizedBox(height: 2),
        Text(description, style: const TextStyle(color: AppTheme.mutedText, fontSize: 11)),
      ],
    );
  }
}

class _PriceRow extends StatelessWidget {
  final String price;
  final String mrp;
  final String discount;
  const _PriceRow({required this.price, required this.mrp, required this.discount});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(price, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: AppTheme.text)),
        const SizedBox(width: 6),
        Text(mrp, style: const TextStyle(decoration: TextDecoration.lineThrough, color: AppTheme.mutedText, fontSize: 12)),
        const SizedBox(width: 6),
        Text(discount, style: const TextStyle(color: AppTheme.successText, fontWeight: FontWeight.bold, fontSize: 12)),
      ],
    );
  }
}
