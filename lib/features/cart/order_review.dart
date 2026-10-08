import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/providers/cart_notifier.dart';
import '../../core/theme.dart';
import 'payment_processing.dart';

class OrderReview extends StatelessWidget {
  const OrderReview({super.key, required this.amount, required this.method});
  final double amount;
  final String method;

  @override
  Widget build(BuildContext context) {
    final cart = context.watch<CartNotifier>();
    return Scaffold(
      appBar: AppBar(title: const Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text('Review & Confirm Order'), Text('Draft  #ORD-9841', style: TextStyle(fontSize: 11, color: AppTheme.mutedText))])),
      body: ListView(padding: const EdgeInsets.all(18), children: [
        _card(const ListTile(leading: Icon(Icons.local_shipping_outlined, color: AppTheme.primary), title: Text('Express Delivery Slot', style: TextStyle(fontWeight: FontWeight.bold)), subtitle: Text('Home · Aditi Rao\nFlat 402, Green Glen Layout, Bellandur, Bengaluru'), trailing: Text('22 min', style: TextStyle(color: AppTheme.primary)))),
        const SizedBox(height: 16),
        _card(Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('Itemized Medicines (${cart.totalCount} Items)', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)), const Divider(height: 24),
          ...cart.items.map((item) => ListTile(contentPadding: EdgeInsets.zero, leading: const Icon(Icons.medication_outlined, color: AppTheme.primary), title: Text(item.name), subtitle: Text('${item.pack} · ${item.quantity} unit(s)'), trailing: Text('₹${item.total.toStringAsFixed(0)}'))),
          const Divider(), _row('Items total', '₹${cart.totalPrice.toStringAsFixed(0)}'), _row('Prescription subsidy & discount', '−₹${(cart.totalPrice - amount).toStringAsFixed(0)}', green: true), _row('Express delivery', 'FREE', green: true), const Divider(), _row('Total payable', '₹${amount.toStringAsFixed(0)}', bold: true),
        ])),
        const SizedBox(height: 16),
        _card(ListTile(leading: const Icon(Icons.account_balance_wallet_outlined, color: AppTheme.primary), title: const Text('Payment Method', style: TextStyle(fontWeight: FontWeight.bold)), subtitle: Text(method), trailing: TextButton(onPressed: () => Navigator.pop(context), child: const Text('Change')))),
        const SizedBox(height: 16),
        const Text('By authorizing, you confirm this order and agree to the pharmacy dispensing terms.', style: TextStyle(color: AppTheme.mutedText, height: 1.4)),
      ]),
      bottomNavigationBar: SafeArea(child: Padding(padding: const EdgeInsets.all(16), child: ElevatedButton.icon(onPressed: () => Navigator.push(context, MaterialPageRoute<void>(builder: (_) => PaymentProcessing(amount: amount))), icon: const Icon(Icons.verified_user_outlined), label: Text('Authorize & Pay  ·  ₹${amount.toStringAsFixed(0)}')))),
    );
  }
}

Widget _card(Widget child) => Material(
  color: Colors.white,
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(20),
    side: const BorderSide(color: AppTheme.outlineBorder),
  ),
  clipBehavior: Clip.antiAlias,
  child: Padding(padding: const EdgeInsets.all(16), child: child),
);
Widget _row(String label, String value, {bool bold = false, bool green = false}) => Padding(padding: const EdgeInsets.symmetric(vertical: 5), child: Row(children: [Expanded(child: Text(label, style: TextStyle(fontWeight: bold ? FontWeight.bold : FontWeight.normal))), Text(value, style: TextStyle(fontWeight: FontWeight.bold, color: green ? AppTheme.successText : (bold ? AppTheme.primaryDark : AppTheme.text)))]));
