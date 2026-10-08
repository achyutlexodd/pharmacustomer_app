import 'package:flutter/material.dart';

import '../../core/theme.dart';
import 'payment_processing.dart';
import 'payment_status_recovery.dart';

class PaymentDeclined extends StatefulWidget {
  const PaymentDeclined({super.key});

  @override
  State<PaymentDeclined> createState() => _PaymentDeclinedState();
}

class _PaymentDeclinedState extends State<PaymentDeclined> {
  String selected = 'UPI';

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      title: const Text('Payment Unsuccessful'),
      leading: const Icon(Icons.receipt_long_outlined),
      actions: [
        IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.close),
        ),
      ],
    ),
    body: ListView(
      padding: const EdgeInsets.all(20),
      children: [
        const SizedBox(height: 8),
        const CircleAvatar(
          radius: 34,
          backgroundColor: AppTheme.errorBg,
          child: Icon(
            Icons.warning_amber_rounded,
            size: 34,
            color: AppTheme.error,
          ),
        ),
        const SizedBox(height: 14),
        const Text(
          'Payment Declined by Bank',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        const Text(
          'Bank server timeout / transaction declined by UPI PSP',
          textAlign: TextAlign.center,
          style: TextStyle(color: AppTheme.error),
        ),
        const SizedBox(height: 20),
        _card(
          const ListTile(
            leading: Icon(
              Icons.inventory_2_outlined,
              color: AppTheme.warningText,
            ),
            title: Text(
              'Stock reserved for a limited time',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Text(
              'Your prescribed medicines remain held while you complete payment.',
            ),
          ),
        ),
        const SizedBox(height: 16),
        _card(
          const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Order Summary',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              Divider(height: 22),
              _Summary('Janumet 50/500mg', '₹685.20'),
              _Summary('Rosuvas 10mg', '₹660.34'),
              Divider(),
              _Summary('Total payable', '₹1,507.00', bold: true),
            ],
          ),
        ),
        const Padding(
          padding: EdgeInsets.symmetric(vertical: 18),
          child: Text(
            'Select Retry Method',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
        ),
        RadioGroup<String>(
          groupValue: selected,
          onChanged: (value) => setState(() => selected = value!),
          child: Column(
            children:
                [
                      (
                        'UPI',
                        Icons.account_balance_wallet_outlined,
                        'Google Pay, PhonePe, Paytm, BHIM · 1-tap fast retry',
                      ),
                      (
                        'Credit / Debit Card',
                        Icons.credit_card,
                        'Visa, Mastercard, RuPay',
                      ),
                      (
                        'Net Banking',
                        Icons.account_balance,
                        'All major Indian banks',
                      ),
                      (
                        'Cash on Delivery',
                        Icons.payments_outlined,
                        'Doorstep cash or UPI QR',
                      ),
                    ]
                    .map(
                      (item) => Card(
                        color: Colors.white,
                        child: RadioListTile<String>(
                          value: item.$1,
                          secondary: Icon(item.$2, color: AppTheme.primary),
                          title: Text(
                            item.$1,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Text(
                            item.$3,
                            style: const TextStyle(fontSize: 12),
                          ),
                        ),
                      ),
                    )
                    .toList(),
          ),
        ),
      ],
    ),
    bottomNavigationBar: SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () => Navigator.pushReplacement(
                  context,
                  MaterialPageRoute<void>(
                    builder: (_) => const PaymentProcessing(amount: 1507),
                  ),
                ),
                icon: const Icon(Icons.arrow_forward),
                label: const Text('Retry Payment (₹1,507.00)'),
              ),
            ),
            TextButton(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute<void>(
                  builder: (_) => const PaymentStatusRecovery(),
                ),
              ),
              child: const Text('I was charged · Check order status'),
            ),
          ],
        ),
      ),
    ),
  );
}

Widget _card(Widget child) => Container(
  padding: const EdgeInsets.all(16),
  decoration: BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(16),
    border: Border.all(color: AppTheme.outlineBorder),
  ),
  child: child,
);

class _Summary extends StatelessWidget {
  const _Summary(this.name, this.price, {this.bold = false});
  final String name;
  final String price;
  final bool bold;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 6),
    child: Row(
      children: [
        Expanded(
          child: Text(
            name,
            style: TextStyle(
              fontWeight: bold ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ),
        Text(
          price,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: bold ? AppTheme.primaryDark : AppTheme.text,
          ),
        ),
      ],
    ),
  );
}
