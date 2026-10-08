import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/providers/cart_notifier.dart';
import '../../core/theme.dart';

class AddressChange extends StatefulWidget {
  const AddressChange({super.key});
  @override
  State<AddressChange> createState() => _AddressChangeState();
}

class _AddressChangeState extends State<AddressChange> {
  bool accepted = true;
  int selected = 0;
  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Delivery Address & Serviceability')),
    body: ListView(
      padding: const EdgeInsets.all(18),
      children: [
        _panel(
          const Text(
            '⚠  Address Change Requires Order Re-validation\n\nChanging your delivery destination impacts pharmacy allocation, delivery distance, SLA, and applicable delivery fees.',
            style: TextStyle(
              height: 1.5,
              color: Color(0xFF805000),
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        const SizedBox(height: 14),
        _panel(
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  Text(
                    'ORIGIN VS DESTINATION',
                    style: TextStyle(
                      fontSize: 11,
                      letterSpacing: .8,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.textSecondary,
                    ),
                  ),
                  Text(
                    '⇄ Route Recalculation',
                    style: TextStyle(
                      fontSize: 11,
                      color: AppTheme.primaryDark,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const Divider(height: 22),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: AppTheme.surfaceLow,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '◉  Current Destination                                 ORIGINAL',
                      style: TextStyle(
                        fontSize: 11,
                        color: AppTheme.textSecondary,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Flat 402, Greenfield Apts, Sector 45, Gurugram',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'Within 15–25 min Dark Store Zone',
                      style: TextStyle(fontSize: 11, color: AppTheme.mutedText),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 18),
              const Text(
                'Select New Destination Address',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
              ),
              const SizedBox(height: 8),
              ...[
                (
                  Icons.home_outlined,
                  'Parents Home',
                  'Villa 12, Phase 2, DLF City, Gurugram · PIN 122002',
                ),
                (
                  Icons.business_outlined,
                  'Work',
                  'Cyber City Tower B, DLF Phase 3 · PIN 122003',
                ),
              ].asMap().entries.map(
                (entry) => Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                    side: BorderSide(
                      color: selected == entry.key
                          ? AppTheme.primary
                          : AppTheme.outlineBorder,
                      width: selected == entry.key ? 1.7 : 1,
                    ),
                  ),
                  child: ListTile(
                    onTap: () => setState(() => selected = entry.key),
                    leading: Icon(
                      selected == entry.key
                          ? Icons.radio_button_checked
                          : Icons.radio_button_off,
                      color: AppTheme.primary,
                    ),
                    title: Row(
                      children: [
                        Icon(entry.value.$1, size: 16, color: AppTheme.primary),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            entry.value.$2,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                        if (selected == entry.key)
                          const Chip(
                            label: Text('Selected'),
                            visualDensity: VisualDensity.compact,
                            labelStyle: TextStyle(fontSize: 10),
                          ),
                      ],
                    ),
                    subtitle: Padding(
                      padding: const EdgeInsets.only(left: 24, top: 4),
                      child: Text(entry.value.$3),
                    ),
                  ),
                ),
              ),
              OutlinedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.add_circle_outline),
                label: const Text('Add New Address'),
              ),
            ],
          ),
        ),
        const SizedBox(height: 14),
        _panel(
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppTheme.successBg,
                  border: Border.all(color: const Color(0xFFB7E4D0)),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '✓  PIN ${selected == 0 ? '122002' : '122003'} is fully serviceable by Partner Pharmacies',
                  style: const TextStyle(
                    color: AppTheme.successText,
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                  ),
                ),
              ),
              const SizedBox(height: 14),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppTheme.surfaceLow,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '▣  Partner Store Re-route\nApollo Pharmacy #${selected == 0 ? '12' : '08'}                  SLA: ~30 mins\nLicensed dispensary reassigned for updated zone',
                  style: const TextStyle(
                    height: 1.6,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const Divider(height: 24),
              const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Delivery Fee'),
                  Text('₹0.00', style: TextStyle(fontWeight: FontWeight.bold)),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Total Order Amount',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    '₹${context.watch<CartNotifier>().totalPrice.toStringAsFixed(2)}',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.primaryDark,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              const Align(
                alignment: Alignment.centerRight,
                child: Text(
                  'Pricing and medicine availability preserved with zero change',
                  style: TextStyle(fontSize: 10, color: AppTheme.mutedText),
                ),
              ),
            ],
          ),
        ),
        Card(
          child: CheckboxListTile(
            value: accepted,
            onChanged: (v) => setState(() => accepted = v ?? false),
            activeColor: AppTheme.primary,
            title: const Text(
              'I accept re-allocating to nearby licensed partner pharmacy and updated delivery estimate.',
            ),
          ),
        ),
      ],
    ),
    bottomNavigationBar: SafeArea(
      minimum: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ElevatedButton(
            onPressed: accepted ? () => Navigator.pop(context) : null,
            child: const Text('Confirm Address Change & Update Order  →'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Keep Original Delivery Address'),
          ),
        ],
      ),
    ),
  );
}

Widget _panel(Widget child) => Card(
  child: Padding(padding: const EdgeInsets.all(16), child: child),
);
