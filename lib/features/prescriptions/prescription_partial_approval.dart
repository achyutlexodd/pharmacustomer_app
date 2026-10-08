import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/models/cart_item.dart';
import '../../core/providers/cart_notifier.dart';
import '../../core/theme.dart';
import 'prescription_status.dart';
import 'store_allocation_status.dart';

class PrescriptionPartialApproval extends StatefulWidget {
  const PrescriptionPartialApproval({super.key});
  @override
  State<PrescriptionPartialApproval> createState() =>
      _PrescriptionPartialApprovalState();
}

class _PrescriptionPartialApprovalState
    extends State<PrescriptionPartialApproval> {
  int _choice = 0;
  bool _authorize = true;

  void _confirm() {
    if (_choice == 1 && !_authorize) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Authorize the substitution to continue.'),
        ),
      );
      return;
    }
    final cart = context.read<CartNotifier>();
    for (final item in medicines.take(2)) {
      final id = 'rx_${item.$1}';
      if (cart.quantityOf(id) == 0) {
        cart.add(
          CartItem(id: id, name: item.$1, pack: item.$2, price: item.$3),
        );
      }
    }
    if (_choice == 0 && cart.quantityOf('rx_${medicines[2].$1}') == 0) {
      cart.add(
        CartItem(
          id: 'rx_${medicines[2].$1}',
          name: medicines[2].$1,
          pack: medicines[2].$2,
          price: medicines[2].$3,
        ),
      );
    }
    if (_choice == 1 && cart.quantityOf('rx_generic_${medicines[2].$1}') == 0) {
      cart.add(
        CartItem(
          id: 'rx_generic_${medicines[2].$1}',
          name: 'Storvas 20mg (Generic)',
          pack: '30 Tablets',
          price: 680,
        ),
      );
    }
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const StoreAllocationStatus()),
    );
  }

  @override
  Widget build(BuildContext context) => StatusScaffold(
    title: 'Prescription Clarification',
    bottom: SafeArea(
      child: Container(
        color: Colors.white,
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              _choice == 1 && !_authorize
                  ? 'Authorize substitution to continue'
                  : '${_choice == 2 ? 2 : 3} Items  •  Total: ₹${_choice == 1
                        ? '1,462'
                        : _choice == 2
                        ? '782'
                        : '1,507'}.00',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            ElevatedButton.icon(
              onPressed: _choice == 1 && !_authorize ? null : _confirm,
              icon: const Icon(Icons.arrow_forward),
              label: const Text('Confirm Selection & Add to Cart'),
            ),
          ],
        ),
      ),
    ),
    body: ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFFFFF8E8),
            border: Border.all(color: const Color(0xFFF6D79B)),
            borderRadius: BorderRadius.circular(16),
          ),
          child: const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Action Required',
                style: TextStyle(
                  color: Colors.orange,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                'Partial Approval',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
              Text(
                '2 of 3 prescribed medicines approved. 1 item needs your clinical preference.',
              ),
            ],
          ),
        ),
        const SizedBox(height: 18),
        const Text(
          '● Approved & Ready to Add',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
        ),
        for (final item in medicines.take(2))
          Padding(
            padding: const EdgeInsets.only(top: 10),
            child: statusPanel(child: MedicineRow(item, status: '✓ Ready')),
          ),
        const Padding(
          padding: EdgeInsets.only(top: 22, bottom: 10),
          child: Text(
            '● Decision Needed',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 17,
              color: Color(0xFF9A6700),
            ),
          ),
        ),
        statusPanel(
          border: const Color(0xFFF2C67D),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                medicines[2].$1,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              const Text('Atorvastatin Calcium 20mg • 30 Tablets • ₹725.00'),
              const Divider(height: 24),
              _option(
                0,
                'Wait for Original Atorva 20mg',
                'Warehouse dispatch from Central Hub • Delivers tomorrow by 9:00 AM',
                '₹725.00',
              ),
              _option(
                1,
                'Switch to Pharmacist Recommended Generic: Storvas 20mg',
                'Sun Pharma • Same composition • Express delivery (60 mins)',
                '₹680.00',
              ),
              _option(
                2,
                'Remove this item',
                'Proceed with 2 approved medicines only',
                '',
              ),
            ],
          ),
        ),
        CheckboxListTile(
          value: _authorize,
          onChanged: (v) => setState(() => _authorize = v ?? false),
          title: const Text(
            'I authorize the pharmacist substitution as per CDSCO Act guidelines.',
            style: TextStyle(fontSize: 13),
          ),
          controlAffinity: ListTileControlAffinity.leading,
          contentPadding: EdgeInsets.zero,
        ),
      ],
    ),
  );

  Widget _option(int value, String title, String detail, String price) =>
      InkWell(
        onTap: () => setState(() => _choice = value),
        child: Container(
          margin: const EdgeInsets.only(bottom: 10),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: _choice == value ? const Color(0xFFEAF9FD) : Colors.white,
            border: Border.all(
              color: _choice == value
                  ? AppTheme.primary
                  : AppTheme.outlineBorder,
              width: _choice == value ? 1.5 : 1,
            ),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                _choice == value
                    ? Icons.radio_button_checked
                    : Icons.radio_button_off,
                color: AppTheme.primary,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        color: value == 2 ? Colors.red : AppTheme.text,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      detail,
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppTheme.textSecondary,
                      ),
                    ),
                    if (price.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(top: 6),
                        child: Text(
                          price,
                          style: const TextStyle(fontWeight: FontWeight.bold),
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
