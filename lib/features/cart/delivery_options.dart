import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/providers/cart_notifier.dart';
import '../../core/theme.dart';
import 'address_change.dart';
import 'payment.dart';

class DeliveryOptions extends StatefulWidget {
  const DeliveryOptions({super.key});
  @override
  State<DeliveryOptions> createState() => _DeliveryOptionsState();
}

class _DeliveryOptionsState extends State<DeliveryOptions> {
  int selected = 0;
  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      title: const Text('Delivery Options'),
      actions: const [
        Center(
          child: Padding(
            padding: EdgeInsets.only(right: 16),
            child: Text('Step 2 of 3'),
          ),
        ),
      ],
    ),
    body: ListView(
      padding: const EdgeInsets.all(20),
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: const LinearProgressIndicator(
            value: .66,
            minHeight: 4,
            backgroundColor: AppTheme.surfaceContainerDim,
          ),
        ),
        const SizedBox(height: 18),
        Card(
          child: ListTile(
            leading: Icon(Icons.location_on, color: AppTheme.primary),
            title: Text('Delivering to: Flat 402, Bellandur'),
            subtitle: const Text('Green Glen Layout · Bengaluru 560103'),
            trailing: TextButton(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute<void>(builder: (_) => const AddressChange()),
              ),
              child: const Text('Change'),
            ),
          ),
        ),
        const Padding(
          padding: EdgeInsets.symmetric(vertical: 18),
          child: Text(
            'Choose your delivery speed',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
        ...[
          (Icons.bolt, 'Lightning Express', 'Fastest option · 22 mins'),
          (
            Icons.calendar_month,
            'Eco / Scheduled Delivery',
            'Choose a convenient 2-hour window and save ₹20 eco-credit',
          ),
        ].asMap().entries.map(
          (entry) => Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18),
                    side: BorderSide(
                      color: selected == entry.key
                          ? AppTheme.primary
                          : AppTheme.outlineBorder,
                      width: selected == entry.key ? 2 : 1,
                    ),
                  ),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(18),
                    onTap: () => setState(() => selected = entry.key),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        children: [
                          Container(
                            width: 44,
                            height: 44,
                            decoration: BoxDecoration(
                              color: AppTheme.surfaceLow,
                              borderRadius: BorderRadius.circular(13),
                            ),
                            child: Icon(
                              entry.value.$1,
                              color: AppTheme.primary,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        entry.value.$2,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    if (entry.key == 0)
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 8,
                                          vertical: 4,
                                        ),
                                        decoration: BoxDecoration(
                                          color: AppTheme.successBg,
                                          borderRadius: BorderRadius.circular(
                                            12,
                                          ),
                                        ),
                                        child: const Text(
                                          '22 mins',
                                          style: TextStyle(
                                            fontSize: 10,
                                            color: AppTheme.successText,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                  ],
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  entry.value.$3,
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: AppTheme.textSecondary,
                                    height: 1.3,
                                  ),
                                ),
                                if (entry.key == 0) ...[
                                  const Divider(height: 20),
                                  const Text(
                                    'Fastest option · Bellandur Hub (1.8 km)',
                                    style: TextStyle(
                                      fontSize: 11,
                                      color: AppTheme.mutedText,
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          ),
                          const SizedBox(width: 8),
                          Icon(
                            selected == entry.key
                                ? Icons.check_circle
                                : Icons.radio_button_off,
                            color: selected == entry.key
                                ? AppTheme.primary
                                : AppTheme.textDisabled,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                if (entry.key == 0)
                  Positioned(
                    right: 18,
                    top: -9,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 3,
                      ),
                      decoration: BoxDecoration(
                        color: AppTheme.primary,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Text(
                        'RECOMMENDED',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 9,
                          fontWeight: FontWeight.bold,
                          letterSpacing: .4,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
        TextButton(
          onPressed: () => Navigator.push(
            context,
            MaterialPageRoute<void>(builder: (_) => const AddressChange()),
          ),
          child: const Text('View address change & serviceability'),
        ),
      ],
    ),
    bottomNavigationBar: SafeArea(
      minimum: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Row(
            children: [
              Icon(
                Icons.shield_outlined,
                size: 15,
                color: AppTheme.successText,
              ),
              SizedBox(width: 6),
              Expanded(
                child: Text(
                  'Insured medical courier transit',
                  style: TextStyle(fontSize: 11, color: AppTheme.textSecondary),
                ),
              ),
              Text(
                'All Items in Stock',
                style: TextStyle(
                  fontSize: 11,
                  color: AppTheme.primaryDark,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute<void>(builder: (_) => const Payment()),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        '₹${context.watch<CartNotifier>().totalPrice.toStringAsFixed(0)}',
                      ),
                      const Text(
                        'Inclusive of all medical taxes',
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                    ],
                  ),
                  const Text('Proceed to Payment   ➜'),
                ],
              ),
            ),
          ),
        ],
      ),
    ),
  );
}
