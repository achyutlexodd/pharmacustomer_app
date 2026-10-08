import 'package:flutter/material.dart';

import '../../../core/theme.dart';

Future<void> showPrescriptionDetailSheet(
  BuildContext context, {
  required VoidCallback onArchive,
}) => showModalBottomSheet<void>(
  context: context,
  isScrollControlled: true,
  backgroundColor: Colors.transparent,
  builder: (sheetContext) => Material(
    color: Colors.white,
    borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
    child: SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 28),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: const Color(0xFFD8E0E0),
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            const SizedBox(height: 18),
            Row(
              children: [
                _IconTile(Icons.medical_information_outlined, size: 52),
                const SizedBox(width: 12),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Dr. Rajesh Sharma, MD',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'Diabetologist • Apollo Clinics',
                        style: TextStyle(
                          fontSize: 12,
                          color: AppTheme.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.pop(sheetContext),
                  icon: const Icon(Icons.close),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFFDFF7FB),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Text(
                'Janumet 50/500mg • 3 Refills remaining',
                style: TextStyle(fontSize: 12, color: AppTheme.textSecondary),
              ),
            ),
            const SizedBox(height: 8),
            ListTile(
              leading: _IconTile(Icons.shopping_bag_outlined),
              title: const Text('Order Prescribed Medicines'),
              subtitle: const Text(
                'Automated cart loading • Express 22-min delivery',
              ),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => Navigator.pop(sheetContext),
            ),
            ListTile(
              leading: _IconTile(Icons.history),
              title: const Text('View Refill & Dispense History'),
              subtitle: const Text('Past 2 fulfillments: 14 Oct & 12 Nov'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => Navigator.pop(sheetContext),
            ),
            ListTile(
              leading: _IconTile(Icons.archive_outlined),
              title: const Text(
                'Archive / Deactivate Prescription',
                style: TextStyle(color: Colors.red),
              ),
              subtitle: const Text('Stops reminder cadence • Move to inactive'),
              trailing: const Icon(Icons.delete_outline, color: Colors.red),
              onTap: () {
                Navigator.pop(sheetContext);
                onArchive();
              },
            ),
            const SizedBox(height: 8),
            SizedBox(
              width: double.infinity,
              child: TextButton(
                onPressed: () => Navigator.pop(sheetContext),
                child: const Text('Close Sheet'),
              ),
            ),
          ],
        ),
      ),
    ),
  ),
);

class _IconTile extends StatelessWidget {
  final IconData icon;
  final double size;
  const _IconTile(this.icon, {this.size = 44});

  @override
  Widget build(BuildContext context) => Container(
    width: size,
    height: size,
    decoration: BoxDecoration(
      color: const Color(0xFFDDF6FB),
      borderRadius: BorderRadius.circular(12),
    ),
    child: Icon(icon, color: AppTheme.primary, size: size * .48),
  );
}
