import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/providers/cart_notifier.dart';
import '../../core/theme.dart';
import 'coupon_offers.dart';
import 'order_review.dart';
import 'payment_declined.dart';
import 'payment_status_recovery.dart';

class Payment extends StatefulWidget {
  const Payment({super.key});

  @override
  State<Payment> createState() => _PaymentState();
}

class _PaymentState extends State<Payment> {
  String method = 'UPI';
  bool applied = false;

  @override
  Widget build(BuildContext context) {
    final total = context.watch<CartNotifier>().totalPrice;
    final payable = (total - (applied ? 50 : 0)).clamp(0, total).toDouble();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Payment Options'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          const Padding(
            padding: EdgeInsets.all(16),
            child: Text('● AuraPay', style: TextStyle(color: AppTheme.primary)),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(18),
        children: [
          _panel(
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  '🛡  Rx Subsidy Applied · Total Savings ₹161',
                  style: TextStyle(
                    color: AppTheme.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Divider(height: 24),
                const Text(
                  'TO PAY',
                  style: TextStyle(fontSize: 11, color: AppTheme.mutedText),
                ),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        '₹${payable.toStringAsFixed(0)}',
                        style: const TextStyle(
                          fontSize: 27,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.primaryDark,
                        ),
                      ),
                    ),
                    TextButton(
                      onPressed: _showCoupon,
                      child: Text(
                        applied ? 'Coupon applied ✓' : 'Coupons & Offers',
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 22),
          const Text(
            '⚡  Recommended / Fastest',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          _panel(
            Column(
              children: [
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Rx Subsidy Applied · Total Savings ₹161',
                    style: TextStyle(
                      color: AppTheme.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const Divider(height: 22),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: ['GPay', 'PhonePe', 'Paytm', 'CRED']
                      .map(
                        (name) => ChoiceChip(
                          label: Text(name),
                          selected: method == name,
                          onSelected: (_) => setState(() => method = name),
                          backgroundColor: AppTheme.mutedBg,
                          selectedColor: AppTheme.primaryContainer,
                          labelStyle: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: method == name
                                ? AppTheme.primary
                                : AppTheme.textSecondary,
                          ),
                          side: BorderSide(
                            color: method == name
                                ? AppTheme.primary
                                : AppTheme.outlineBorder,
                          ),
                        ),
                      )
                      .toList(),
                ),
                const SizedBox(height: 14),
                TextField(
                  decoration: const InputDecoration(
                    hintText: 'Enter direct UPI ID / VPA',
                    suffixIcon: Icon(Icons.alternate_email),
                  ),
                  onChanged: (_) => setState(() => method = 'UPI'),
                ),
                const SizedBox(height: 12),
                RadioGroup<String>(
                  groupValue: method,
                  onChanged: (value) => setState(() => method = value!),
                  child: Column(
                    children: [
                      _methodTile(
                        'Credit / Debit Card',
                        Icons.credit_card,
                        'Cards saved securely',
                        'Card',
                      ),
                      _methodTile(
                        'Net Banking',
                        Icons.account_balance,
                        'All major Indian banks',
                        'Net Banking',
                      ),
                      _methodTile(
                        'Cash / QR on Delivery',
                        Icons.payments_outlined,
                        'Pay at your doorstep',
                        'COD',
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          TextButton.icon(
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute<void>(
                builder: (_) => const PaymentStatusRecovery(),
              ),
            ),
            icon: const Icon(Icons.sync),
            label: const Text('Check a pending payment'),
          ),
          TextButton(
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute<void>(builder: (_) => const PaymentDeclined()),
            ),
            child: const Text('Payment declined? View retry options'),
          ),
        ],
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: ElevatedButton.icon(
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute<void>(
                builder: (_) => OrderReview(amount: payable, method: method),
              ),
            ),
            icon: const Icon(Icons.lock_outline),
            label: Text('Continue · ₹${payable.toStringAsFixed(0)}'),
          ),
        ),
      ),
    );
  }

  Widget _methodTile(
    String title,
    IconData icon,
    String subtitle,
    String value,
  ) => RadioListTile<String>(
    contentPadding: EdgeInsets.zero,
    value: value,
    title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
    subtitle: Text(subtitle),
    secondary: Icon(icon, color: AppTheme.primary),
  );

  void _showCoupon() {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (_) => CouponOffers(
        applied: applied,
        onApply: (code) => setState(() => applied = code.isNotEmpty),
      ),
    );
  }
}

Widget _panel(Widget child) => Material(
  color: Colors.white,
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(20),
    side: const BorderSide(color: AppTheme.outlineBorder),
  ),
  clipBehavior: Clip.antiAlias,
  child: Padding(padding: const EdgeInsets.all(16), child: child),
);
