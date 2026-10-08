import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/providers/cart_notifier.dart';
import '../../core/theme.dart';
import '../prescriptions/store_allocation_status.dart';

class Fulfillment extends StatelessWidget {
  const Fulfillment({super.key});
  @override
  Widget build(BuildContext context) {
    final items = context.watch<CartNotifier>().items;
    final refund = items.isEmpty ? 0.0 : items.last.total;
    final retained =
        items.fold<double>(0, (sum, item) => sum + item.total) - refund;
    return Scaffold(
      appBar: AppBar(
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Fulfillment Update'),
            Text(
              'Order #AC-9941',
              style: TextStyle(fontSize: 11, color: AppTheme.textSecondary),
            ),
          ],
        ),
        actions: [
          Center(
            child: Padding(
              padding: const EdgeInsets.only(right: 16),
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: AppTheme.surfaceLow,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  child: Text(
                    'Audit Active',
                    style: TextStyle(
                      fontSize: 10,
                      color: AppTheme.primaryDark,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(18),
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFFFFFAEA),
              border: Border.all(color: const Color(0xFFFFD76B)),
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.warning_amber_rounded, color: Color(0xFF9A4B00)),
                SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Partial Stock Shortage Identified at Store',
                        style: TextStyle(
                          color: Color(0xFF8A3E00),
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      SizedBox(height: 6),
                      Text(
                        'During physical picking, 1 item was found damaged in partner dispensary stock. Your remaining items are safe.',
                        style: TextStyle(color: Color(0xFF9A5200), height: 1.4),
                      ),
                      SizedBox(height: 8),
                      Chip(
                        avatar: Icon(Icons.verified_user_outlined, size: 14),
                        label: Text('Exception Protocol 45.1 Activated'),
                        visualDensity: VisualDensity.compact,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 18),
            child: Text(
              'Items in your order',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          ...items.asMap().entries.map((entry) {
            final damaged = entry.key == items.length - 1;
            final item = entry.value;
            return Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
                side: BorderSide(
                  color: damaged
                      ? const Color(0xFFFFD2D2)
                      : AppTheme.outlineBorder,
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(
                          damaged
                              ? Icons.report_gmailerrorred_outlined
                              : Icons.medication_outlined,
                          color: damaged ? AppTheme.error : AppTheme.primary,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                item.name,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                '${item.quantity} × ${item.pack}',
                                style: const TextStyle(
                                  color: AppTheme.textSecondary,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              '₹${item.total.toStringAsFixed(2)}',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: damaged ? AppTheme.error : AppTheme.text,
                              ),
                            ),
                            if (damaged)
                              const Text(
                                'Refunding',
                                style: TextStyle(
                                  fontSize: 10,
                                  color: AppTheme.error,
                                ),
                              ),
                          ],
                        ),
                      ],
                    ),
                    const Divider(height: 20),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 7,
                        ),
                        decoration: BoxDecoration(
                          color: damaged
                              ? AppTheme.errorBg
                              : AppTheme.successBg,
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: Text(
                          damaged
                              ? '⊘ Damaged stock · Not dispensed'
                              : '● Fulfillment confirmed · In transit',
                          style: TextStyle(
                            fontSize: 11,
                            color: damaged
                                ? AppTheme.error
                                : AppTheme.successText,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                    if (damaged)
                      const Padding(
                        padding: EdgeInsets.only(top: 8),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'Audit note: Partner inspection failed batch physical integrity. This item will not be dispensed.',
                            style: TextStyle(
                              fontSize: 12,
                              height: 1.4,
                              color: AppTheme.textSecondary,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            );
          }),
          _panel(
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(
                      Icons.currency_rupee,
                      color: AppTheme.successText,
                    ),
                    const SizedBox(width: 8),
                    const Expanded(
                      child: Text(
                        'Financial Recalculation',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 17,
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: AppTheme.surfaceLow,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Text(
                        'Reconciled',
                        style: TextStyle(
                          fontSize: 10,
                          color: AppTheme.primaryDark,
                        ),
                      ),
                    ),
                  ],
                ),
                const Divider(height: 24),
                _MoneyRow(
                  'Original Total Paid',
                  '₹${(retained + refund).toStringAsFixed(2)}',
                ),
                const SizedBox(height: 8),
                _MoneyRow(
                  'Retained Subtotal',
                  '₹${retained.toStringAsFixed(2)}',
                ),
                const Divider(height: 24),
                _MoneyRow(
                  'Auto-Refund Credited',
                  '₹${refund.toStringAsFixed(2)}',
                  emphasize: true,
                ),
                const SizedBox(height: 12),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: const Color(0xFFEAFBF4),
                    border: Border.all(color: const Color(0xFFA9EFCB)),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Text(
                    '✓  Instant refund initiated\nCrediting to your original UPI account within 2–4 hours. No manual claim required.',
                    style: TextStyle(color: AppTheme.successText, height: 1.5),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: SafeArea(
        minimum: const EdgeInsets.all(16),
        child: ElevatedButton(
          onPressed: () => Navigator.pushReplacement(
            context,
            MaterialPageRoute<void>(
              builder: (_) => const StoreAllocationStatus(),
            ),
          ),
          child: const Text('Continue Tracking Dispatched Items  →'),
        ),
      ),
    );
  }
}

class _MoneyRow extends StatelessWidget {
  final String label, value;
  final bool emphasize;
  const _MoneyRow(this.label, this.value, {this.emphasize = false});
  @override
  Widget build(BuildContext context) => Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Text(
        label,
        style: TextStyle(
          color: emphasize ? AppTheme.successText : AppTheme.textSecondary,
          fontWeight: emphasize ? FontWeight.bold : FontWeight.normal,
        ),
      ),
      Text(
        value,
        style: TextStyle(
          color: emphasize ? AppTheme.successText : AppTheme.text,
          fontWeight: FontWeight.bold,
          fontSize: emphasize ? 17 : 14,
        ),
      ),
    ],
  );
}

Widget _panel(Widget child) => Card(
  child: Padding(padding: const EdgeInsets.all(16), child: child),
);
