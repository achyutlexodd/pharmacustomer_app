import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/providers/cart_notifier.dart';
import '../../core/models/cart_item.dart';
import '../../core/theme.dart';
import 'address.dart';

class Cart extends StatelessWidget {
  const Cart({super.key});

  @override
  Widget build(BuildContext context) {
    final cart = context.watch<CartNotifier>();
    return Scaffold(
      appBar: AppBar(
        title: Text('Shopping Cart (${cart.totalCount} items)'),
        actions: [
          IconButton(
            onPressed: () => cart.clear(),
            icon: const Icon(Icons.delete_outline),
          ),
        ],
      ),
      body: cart.items.isEmpty
          ? const Center(child: Text('Your cart is empty'))
          : ListView(
              padding: const EdgeInsets.all(16),
              children: [
                Card(
                  child: ListTile(
                    leading: const CircleAvatar(
                      backgroundColor: AppTheme.surfaceLow,
                      child: Icon(Icons.bolt, color: AppTheme.primary),
                    ),
                    title: const Text(
                      'EXPRESS 22-MIN DELIVERY',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.primary,
                      ),
                    ),
                    subtitle: const Text('Deliver to Bellandur, Bengaluru…'),
                    trailing: TextButton(
                      onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute<void>(
                          builder: (_) => const Address(),
                        ),
                      ),
                      child: const Text('Change'),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Prescription & Health Items',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                ...cart.items.map(
                  (item) => Card(
                    margin: const EdgeInsets.only(bottom: 10),
                    child: Padding(
                      padding: const EdgeInsets.all(14),
                      child: Row(
                        children: [
                          Container(
                            width: 50,
                            height: 50,
                            decoration: BoxDecoration(
                              color: AppTheme.surfaceLow,
                              borderRadius: BorderRadius.circular(14),
                            ),
                            child: const Icon(
                              Icons.medication_outlined,
                              color: AppTheme.primary,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  item.name,
                                  style: Theme.of(
                                    context,
                                  ).textTheme.titleMedium,
                                ),
                                Text(
                                  item.pack,
                                  style: const TextStyle(
                                    color: AppTheme.mutedText,
                                    fontSize: 12,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  '₹${item.total.toStringAsFixed(0)}',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          DecoratedBox(
                            decoration: BoxDecoration(
                              color: AppTheme.surfaceLow,
                              borderRadius: BorderRadius.circular(14),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  onPressed: () => cart.remove(item.id),
                                  icon: const Icon(Icons.remove, size: 18),
                                  visualDensity: VisualDensity.compact,
                                ),
                                Text(
                                  '${item.quantity}',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                IconButton(
                                  onPressed: () => cart.add(item),
                                  icon: const Icon(Icons.add, size: 18),
                                  visualDensity: VisualDensity.compact,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 2),
                const Text(
                  'Frequently Added Together',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const Text(
                  'Recommended daily wellness essentials',
                  style: TextStyle(fontSize: 11, color: AppTheme.mutedText),
                ),
                const SizedBox(height: 8),
                SizedBox(
                  height: 112,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: [
                      _SuggestedItem(
                        name: 'Vitamin C 500mg',
                        price: 120,
                        icon: Icons.medication_outlined,
                      ),
                      _SuggestedItem(
                        name: 'Electrolyte Sachets',
                        price: 80,
                        icon: Icons.water_drop_outlined,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 14),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(14),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(
                              Icons.receipt_long_outlined,
                              color: AppTheme.primary,
                            ),
                            const SizedBox(width: 8),
                            const Expanded(
                              child: Text(
                                'Prescription Fulfillment',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: AppTheme.successBg,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Text(
                                'Ready for verification',
                                style: TextStyle(
                                  fontSize: 10,
                                  color: AppTheme.successText,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const Divider(height: 20),
                        const Text(
                          'Add prescription & order everything together',
                          style: TextStyle(fontWeight: FontWeight.w600),
                        ),
                        const SizedBox(height: 4),
                        const Text(
                          'Upload or link your doctor’s prescription. Prescription medicines will be dispensed after pharmacist approval.',
                          style: TextStyle(
                            fontSize: 12,
                            color: AppTheme.textSecondary,
                            height: 1.4,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Bill Summary',
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                            Text(
                              '${cart.totalCount} items',
                              style: const TextStyle(color: AppTheme.mutedText),
                            ),
                          ],
                        ),
                        const Divider(height: 24),
                        _BillRow(
                          label: 'Items total',
                          value: '₹${cart.totalPrice.toStringAsFixed(0)}',
                        ),
                        const SizedBox(height: 8),
                        const _BillRow(
                          label: 'Delivery fee',
                          value: 'FREE',
                          valueColor: AppTheme.successText,
                        ),
                        const SizedBox(height: 8),
                        const _BillRow(
                          label: 'Handling & packaging',
                          value: 'FREE',
                          valueColor: AppTheme.successText,
                        ),
                        const SizedBox(height: 8),
                        const _BillRow(
                          label: 'Taxes (GST included)',
                          value: 'Included',
                        ),
                        const Divider(height: 24),
                        _BillRow(
                          label: 'Total payable',
                          value: '₹${cart.totalPrice.toStringAsFixed(0)}',
                          bold: true,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
      bottomNavigationBar: cart.items.isEmpty
          ? null
          : SafeArea(
              minimum: const EdgeInsets.all(16),
              child: ElevatedButton(
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute<void>(builder: (_) => const Address()),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          '₹${cart.totalPrice.toStringAsFixed(0)}',
                          style: const TextStyle(fontSize: 17),
                          ),
                        const Text(
                          'Inclusive of applicable taxes',
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                      ],
                    ),
                    ),
                  const SizedBox(width: 8),
                  const Expanded(
                    child: Text(
                      'Proceed to Checkout  →',
                      textAlign: TextAlign.end,
                    ),
                  ),
                  ],
                ),
              ),
            ),
    );
  }
}

class _SuggestedItem extends StatelessWidget {
  final String name;
  final double price;
  final IconData icon;
  const _SuggestedItem({
    required this.name,
    required this.price,
    required this.icon,
  });
  @override
  Widget build(BuildContext context) => Container(
    width: 205,
    margin: const EdgeInsets.only(right: 8),
    padding: const EdgeInsets.all(10),
    decoration: BoxDecoration(
      color: Colors.white,
      border: Border.all(color: AppTheme.outlineBorder),
      borderRadius: BorderRadius.circular(16),
    ),
    child: Row(
      children: [
        Icon(icon, color: AppTheme.primary),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                '₹${price.toStringAsFixed(0)}',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 4),
              SizedBox(
                height: 28,
                child: ElevatedButton(
                  onPressed: () => context.read<CartNotifier>().add(
                    CartItem(
                      id: name.toLowerCase().replaceAll(' ', '_'),
                      name: name,
                      pack: '20 tablets',
                      price: price,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    minimumSize: Size.zero,
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    textStyle: const TextStyle(fontSize: 11),
                  ),
                  child: const Text('+ Add'),
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}

class _BillRow extends StatelessWidget {
  final String label;
  final String value;
  final bool bold;
  final Color? valueColor;
  const _BillRow({
    required this.label,
    required this.value,
    this.bold = false,
    this.valueColor,
  });
  @override
  Widget build(BuildContext context) => Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Text(
        label,
        style: TextStyle(
          fontWeight: bold ? FontWeight.bold : FontWeight.normal,
        ),
      ),
      Text(
        value,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: valueColor ?? (bold ? AppTheme.primaryDark : AppTheme.text),
        ),
      ),
    ],
  );
}
