import 'package:flutter/material.dart';

import '../../core/theme.dart';
import 'prescription_status.dart';

class StoreAllocationStatus extends StatelessWidget {
  const StoreAllocationStatus({super.key});

  @override
  Widget build(BuildContext context) => StatusScaffold(
    title: 'Store Allocation Status',
    subtitle: '🟠 Reallocation Active',
    body: ListView(
      padding: const EdgeInsets.all(16),
      children: [
        statusPanel(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Text(
                '◷  Primary SLA Timed Out',
                style: TextStyle(
                  color: Color(0xFF9A5200),
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8),
              Text(
                'Re-routing to Nearby Partner Pharmacy',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
              SizedBox(height: 10),
              Text(
                'Primary store timed out (5:00 min SLA exceeded). Auto-allocating to Partner Pharmacy #08 (Attempt 1 of 1).',
                style: TextStyle(color: AppTheme.textSecondary, height: 1.4),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        statusPanel(
          child: const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '✓  Your Order & Payment are Protected',
                style: TextStyle(
                  color: AppTheme.primary,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              SizedBox(height: 7),
              Text(
                'Your reserved medicines are being matched with licensed inventory at our next closest partner store. No extra fee or delay impact.',
                style: TextStyle(color: AppTheme.textSecondary, height: 1.4),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        statusPanel(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Text(
                '◷  Live SLA Auto-Transfer     00:00 remaining',
                style: TextStyle(
                  color: AppTheme.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Divider(height: 24),
              _Step(
                'Store #14 Timed Out',
                'Did not confirm within guaranteed fulfillment window.',
                'Exceeded 5m',
                Colors.orange,
              ),
              _Step(
                'Reallocating to Store #08',
                'Matching complete prescription batch with verified stock.',
                'In Progress',
                AppTheme.primary,
              ),
              _Step(
                'Awaiting Store Acceptance',
                'Partner verified; awaiting pharmacist dispensing lock.',
                '',
                Colors.blueGrey,
              ),
              _Step(
                'Courier Dispatch',
                'Delivery partner reassigned automatically to new pickup hub.',
                '',
                Colors.blueGrey,
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        statusPanel(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Order Identifier'),
                      Text(
                        '#AC-9941',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 17,
                        ),
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text('Total Paid'),
                      Text(
                        '₹1,507.00',
                        style: TextStyle(
                          color: AppTheme.primary,
                          fontWeight: FontWeight.bold,
                          fontSize: 17,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const Divider(height: 22),
              MedicineRow(medicines[1], status: 'Stock Secured'),
              MedicineRow(medicines[2], status: 'Stock Secured'),
            ],
          ),
        ),
        const SizedBox(height: 18),
        OutlinedButton.icon(
          onPressed: () => showDialog<void>(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text('Cancel order?'),
              content: const Text(
                'Your prepaid amount will be refunded to the original payment method.',
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Keep Order'),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Cancellation request submitted.'),
                      ),
                    );
                  },
                  child: const Text('Cancel Order'),
                ),
              ],
            ),
          ),
          icon: const Icon(Icons.currency_rupee),
          label: const Text('Cancel Order & Instant Refund to Source'),
        ),
      ],
    ),
  );
}

class _Step extends StatelessWidget {
  final String title, detail, tag;
  final Color color;
  const _Step(this.title, this.detail, this.tag, this.color);
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: 20),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(Icons.circle, size: 14, color: color),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      title,
                      style: TextStyle(
                        color: color,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  if (tag.isNotEmpty)
                    Text(
                      tag,
                      style: TextStyle(
                        color: color,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                ],
              ),
              Text(
                detail,
                style: const TextStyle(
                  fontSize: 12,
                  color: AppTheme.textSecondary,
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}
