import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/models/cart_item.dart';
import '../../../core/providers/cart_notifier.dart';
import '../../../core/theme.dart';

class InStockSection extends StatelessWidget {
  final VoidCallback onTap;
  const InStockSection({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Row(
          children: [
            CircleAvatar(radius: 5, backgroundColor: AppTheme.successText),
            SizedBox(width: 8),
            Text('In Stock Right Now',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: AppTheme.text)),
          ],
        ),
        const SizedBox(height: 12),
        _InStockCard(
          cartId: 'accu_chek_strips',
          label: '15 min express',
          name: 'Accu-Chek Active Test Strips',
          description: 'Pack of 50 Strips • Diagnostic',
          price: 975.0,
          priceLabel: '₹975.00',
          discount: '12% OFF',
          onTap: onTap,
        ),
        const SizedBox(height: 10),
        _InStockCard(
          cartId: 'onetouch_simple',
          label: '15 min express',
          name: 'OneTouch Select Plus Simple',
          description: 'Full Glucometer Kit + 10 Lancets',
          price: 1100.0,
          priceLabel: '₹1,100.00',
          discount: '8% OFF',
          onTap: onTap,
        ),
      ],
    );
  }
}

class _InStockCard extends StatelessWidget {
  final String cartId;
  final String label;
  final String name;
  final String description;
  final double price;
  final String priceLabel;
  final String discount;
  final VoidCallback onTap;

  const _InStockCard({
    required this.cartId,
    required this.label,
    required this.name,
    required this.description,
    required this.price,
    required this.priceLabel,
    required this.discount,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final qty = context.watch<CartNotifier>().quantityOf(cartId);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppTheme.outlineBorder),
        ),
        child: Row(
          children: [
            Container(
              width: 70,
              height: 70,
              decoration: BoxDecoration(color: AppTheme.primaryContainer, borderRadius: BorderRadius.circular(10)),
              child: const Icon(Icons.biotech_outlined, color: AppTheme.primary, size: 32),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(color: AppTheme.primaryContainer, borderRadius: BorderRadius.circular(4)),
                    child: Text(label,
                        style: const TextStyle(fontSize: 10, color: AppTheme.primary, fontWeight: FontWeight.bold)),
                  ),
                  const SizedBox(height: 4),
                  Text(name,
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: AppTheme.text)),
                  Text(description, style: const TextStyle(fontSize: 11, color: AppTheme.mutedText)),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      Text(priceLabel,
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: AppTheme.text)),
                      const SizedBox(width: 6),
                      Text(discount,
                          style: const TextStyle(color: AppTheme.successText, fontSize: 12, fontWeight: FontWeight.bold)),
                    ],
                  ),
                ],
              ),
            ),
            if (qty == 0)
              ElevatedButton(
                onPressed: () => context.read<CartNotifier>().add(
                      CartItem(id: cartId, name: name, pack: '', price: price),
                    ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.primaryContainer,
                  foregroundColor: AppTheme.primary,
                  elevation: 0,
                  minimumSize: const Size(64, 36),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
                child: const Text('+ Add', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
              )
            else
              Container(
                decoration: BoxDecoration(
                  color: AppTheme.primaryContainer,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.remove, size: 14, color: AppTheme.primary),
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
                      icon: const Icon(Icons.add, size: 14, color: AppTheme.primary),
                      onPressed: () => context.read<CartNotifier>().add(
                            CartItem(id: cartId, name: name, pack: '', price: price),
                          ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}
