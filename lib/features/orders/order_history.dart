import 'package:flutter/material.dart';

import '../../core/theme.dart';
import '../cart/live_tracking.dart';
import '../cart/tax_invoice.dart';

class OrderHistory extends StatefulWidget {
  const OrderHistory({super.key});
  @override
  State<OrderHistory> createState() => _OrderHistoryState();
}

class _OrderHistoryState extends State<OrderHistory> {
  String filter = 'All';

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      title: const Text('Order History'),
      actions: [TextButton(onPressed: () {}, child: const Text('18 Orders'))],
    ),
    body: ListView(
      padding: const EdgeInsets.all(20),
      children: [
        const TextField(
          decoration: InputDecoration(
            prefixIcon: Icon(Icons.search),
            hintText: 'Search medicine, order ID, or doctor...',
          ),
        ),
        const SizedBox(height: 16),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: ['All', 'Delivered', 'Prescription Orders', 'Refills']
                .map(
                  (value) => Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: ChoiceChip(
                      label: Text(value),
                      selected: filter == value,
                      onSelected: (_) => setState(() => filter = value),
                      backgroundColor: AppTheme.mutedBg,
                      selectedColor: AppTheme.primaryContainer,
                      labelStyle: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: filter == value
                            ? AppTheme.primary
                            : AppTheme.textSecondary,
                      ),
                      side: BorderSide(
                        color: filter == value
                            ? AppTheme.primary
                            : AppTheme.outlineBorder,
                      ),
                    ),
                  ),
                )
                .toList(),
          ),
        ),
        const SizedBox(height: 16),
        _OrderCard(
          id: '#HRX-982310',
          status: 'Delivered Today · 2:45 PM',
          total: '₹1,507',
          items: const [
            'Insulin Glargine 100IU/ml · 2 Pens',
            'BD Ultra-Fine Needles 4mm · 1 Pack',
            'Alcohol Swabs (Sterile) · 1 Box',
          ],
          primary: true,
        ),
        const SizedBox(height: 16),
        _OrderCard(
          id: '#HRX-881294',
          status: 'Delivered 12 Aug · Express Delivery',
          total: '₹340',
          items: const ['Metformin Hydrochloride 500mg · Strip of 60'],
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: AppTheme.outlineBorder),
          ),
          child: const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '◷  Prescription Refill Scheduled',
                style: TextStyle(
                  color: AppTheme.warningText,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8),
              Text('Rosuvastatin Calcium 10mg · 30 Day Cycle'),
              Text(
                'Refills automatically on 28 Aug',
                style: TextStyle(color: AppTheme.textSecondary),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}

class _OrderCard extends StatelessWidget {
  const _OrderCard({
    required this.id,
    required this.status,
    required this.total,
    required this.items,
    this.primary = false,
  });
  final String id, status, total;
  final List<String> items;
  final bool primary;

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(16),
    clipBehavior: Clip.antiAlias,
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(20),
      border: Border.all(color: AppTheme.outlineBorder),
      boxShadow: const [
        BoxShadow(
          color: Color(0x08000000),
          blurRadius: 12,
          offset: Offset(0, 4),
        ),
      ],
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                '●  $status',
                style: const TextStyle(
                  color: AppTheme.successText,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            Text(
              total,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        const SizedBox(height: 6),
        Text(
          'ID: $id',
          style: const TextStyle(color: AppTheme.textSecondary, fontSize: 12),
        ),
        const Divider(height: 22),
        ...items.map(
          (item) => Padding(
            padding: const EdgeInsets.only(bottom: 9),
            child: Row(
              children: [
                const Icon(Icons.circle, size: 7, color: AppTheme.primary),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(item, style: const TextStyle(fontSize: 13)),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: OutlinedButton.icon(
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute<void>(builder: (_) => const TaxInvoice()),
                ),
                icon: const Icon(Icons.description_outlined),
                label: const Text('Invoice'),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: OutlinedButton.icon(
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute<void>(builder: (_) => const LiveTracking()),
                ),
                icon: const Icon(Icons.history),
                label: const Text('Track Details'),
              ),
            ),
          ],
        ),
        if (primary) ...[
          const SizedBox(height: 8),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.replay),
              label: const Text('Reorder in 1-Tap'),
            ),
          ),
        ],
      ],
    ),
  );
}
