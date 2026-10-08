import 'package:flutter/material.dart';

import '../../../core/theme.dart';

Future<void> showPrescriptionRefillSheet(BuildContext context) =>
    showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      backgroundColor: Colors.white,
      builder: (sheetContext) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Dr. Rajiv Mehta, MD',
                style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              const Text('Metformin 500mg • 3 refills remaining'),
              const SizedBox(height: 16),
              Material(
                color: Colors.transparent,
                child: ListTile(
                  leading: const Icon(
                    Icons.shopping_bag_outlined,
                    color: AppTheme.primary,
                  ),
                  title: const Text('Order prescribed medicines'),
                  subtitle: const Text('Add available refills to your cart'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {
                    Navigator.pop(sheetContext);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Prescribed medicines added to cart'),
                      ),
                    );
                  },
                ),
              ),
              Material(
                color: Colors.transparent,
                child: ListTile(
                  leading: const Icon(Icons.history, color: AppTheme.primary),
                  title: const Text('View refill & dispense history'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => Navigator.pop(sheetContext),
                ),
              ),
            ],
          ),
        ),
      ),
    );
