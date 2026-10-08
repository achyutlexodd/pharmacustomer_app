import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/providers/cart_notifier.dart';
import '../../core/theme.dart';

class SplitShipmentTracking extends StatelessWidget {
  const SplitShipmentTracking({super.key});

  @override
  Widget build(BuildContext context) {
    final cart = context.watch<CartNotifier>();
    final items = cart.items;
    final first = items.isNotEmpty ? items.first : null;
    final second = items.length > 1 ? items.skip(1).toList() : <dynamic>[];
    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(),
        title: const Column(
          children: [
            Text(
              'LIVE ORDER TRACKER',
              style: TextStyle(fontSize: 10, color: AppTheme.mutedText),
            ),
            Text('Track Order #AC-9941'),
          ],
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(18),
        children: [
          _card(
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'CONSOLIDATED ORDER',
                  style: TextStyle(fontSize: 10, color: AppTheme.mutedText),
                ),
                Text(
                  '₹${cart.totalPrice.toStringAsFixed(2)}',
                  style: const TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Divider(height: 20),
                const Text(
                  '🚚  Multi-Store Delivery',
                  style: TextStyle(
                    color: AppTheme.primaryDark,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Text(
                  'Your medicines are arriving in separate shipments from nearby licensed pharmacies.',
                  style: TextStyle(color: AppTheme.textSecondary, height: 1.4),
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),
          _shipment(
            'Shipment 1 of 2',
            'MedPlus Pharmacy #04',
            'Sector 14 · Dispatch verified',
            'Out for delivery · 8 mins',
            first?.name ?? 'Medicine order',
            first == null ? 0 : first.total,
            'Ramesh Kumar · Bike DL 04 AB 1234',
            true,
          ),
          const SizedBox(height: 14),
          _shipment(
            'Shipment 2 of 2',
            'Apollo Pharmacy #12',
            'Galleria Market · Pharmacist sorting',
            'Packing at pharmacy · ~35 mins',
            second.isEmpty
                ? 'Remaining medicines'
                : second.map((item) => item.name).join(', '),
            second.fold<double>(0, (sum, item) => sum + item.total),
            'Assigning nearby courier partner',
            false,
          ),
          const SizedBox(height: 14),
          _card(
            const ListTile(
              leading: Icon(
                Icons.location_on_outlined,
                color: AppTheme.primary,
              ),
              title: Text('Delivery Address & Payment'),
              subtitle: Text(
                'Home · Flat 402, Green Glen Layout\nPrepaid via UPI · Invoice available',
              ),
            ),
          ),
        ],
      ),
    );
  }
}

Widget _shipment(
  String title,
  String store,
  String detail,
  String status,
  String medicine,
  double price,
  String courier,
  bool active,
) => _card(
  Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Row(
        children: [
          Expanded(
            child: Text(
              title,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          Chip(
            label: Text(status, style: const TextStyle(fontSize: 10)),
            backgroundColor: active ? AppTheme.successBg : AppTheme.warningBg,
          ),
        ],
      ),
      ListTile(
        contentPadding: EdgeInsets.zero,
        leading: const Icon(Icons.storefront_outlined, color: AppTheme.primary),
        title: Text(store, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(detail),
      ),
      Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppTheme.background,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Row(
          children: [
            const Icon(Icons.medication_outlined, color: AppTheme.primary),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                medicine,
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
            ),
            Text(
              '₹${price.toStringAsFixed(2)}',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
      const SizedBox(height: 12),
      LinearProgressIndicator(
        value: active ? .75 : .35,
        color: active ? AppTheme.primary : AppTheme.warningText,
        backgroundColor: AppTheme.surfaceLow,
      ),
      const SizedBox(height: 10),
      Row(
        children: [
          const Icon(Icons.person_pin_circle_outlined, color: AppTheme.primary),
          const SizedBox(width: 8),
          Expanded(child: Text(courier, style: const TextStyle(fontSize: 12))),
          if (active)
            IconButton(onPressed: () {}, icon: const Icon(Icons.call_outlined)),
        ],
      ),
    ],
  ),
);

Widget _card(Widget child) => Container(
  padding: const EdgeInsets.all(16),
  decoration: BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(18),
    border: Border.all(color: AppTheme.outlineBorder),
    boxShadow: const [
      BoxShadow(color: Color(0x08000000), blurRadius: 10, offset: Offset(0, 3)),
    ],
  ),
  child: child,
);
