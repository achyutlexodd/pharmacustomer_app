import 'package:flutter/material.dart';

import '../../core/theme.dart';

class CouponOffers extends StatefulWidget {
  const CouponOffers({super.key, required this.onApply, required this.applied});
  final ValueChanged<String> onApply;
  final bool applied;

  @override
  State<CouponOffers> createState() => _CouponOffersState();
}

class _CouponOffersState extends State<CouponOffers> {
  final controller = TextEditingController();
  @override
  void dispose() { controller.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) => SafeArea(child: Padding(padding: EdgeInsets.fromLTRB(20, 20, 20, MediaQuery.of(context).viewInsets.bottom + 20), child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
    Center(child: Container(width: 42, height: 4, decoration: BoxDecoration(color: AppTheme.outlineBorder, borderRadius: BorderRadius.circular(5)))),
    const SizedBox(height: 18), const Text('Coupons & Offers', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)), const Text('Maximize savings on your prescribed healthcare'),
    const SizedBox(height: 18), TextField(controller: controller, decoration: InputDecoration(hintText: 'Enter promo code', suffixIcon: TextButton(onPressed: () => _apply(controller.text), child: const Text('Apply')))),
    const SizedBox(height: 14), Material(color: Colors.transparent, child: ListTile(leading: const Icon(Icons.local_offer_outlined, color: AppTheme.primary), title: const Text('AURACARE50 · Flat ₹50 OFF'), subtitle: const Text('On your first prescription order above ₹999'), trailing: TextButton(onPressed: () => _apply('AURACARE50'), child: const Text('Apply')))),
    if (widget.applied) TextButton(onPressed: () { widget.onApply(''); Navigator.pop(context); }, child: const Text('Remove applied coupon')),
  ])));

  void _apply(String code) { widget.onApply(code.trim()); Navigator.pop(context); }
}
