import 'package:flutter/material.dart';

import '../../../core/theme.dart';
import '../../../core/utils/prescription_uploader.dart';

/// Card showing guaranteed next-day sourcing from the central state hub.
class SourcingSolutionCard extends StatelessWidget {
  const SourcingSolutionCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Row(
          children: [
            Icon(Icons.check_circle_outline,
                color: AppTheme.primary, size: 18),
            SizedBox(width: 6),
            Text('Sourcing Solutions Available',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                    color: AppTheme.text)),
          ],
        ),
        const SizedBox(height: 12),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppTheme.outlineBorder),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _deliveryHeader(),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _productRow(),
                    const SizedBox(height: 12),
                    _priceRow(),
                    const SizedBox(height: 12),
                    _orderButton(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _deliveryHeader() => Container(
        width: double.infinity,
        padding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: const BoxDecoration(
          color: AppTheme.primaryContainer,
          borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
        ),
        child: const Row(
          children: [
            Icon(Icons.bolt, color: AppTheme.primary, size: 16),
            SizedBox(width: 6),
            Text('Guaranteed Delivery by Tomorrow, 10:00 AM',
                style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 12,
                    color: AppTheme.primary)),
          ],
        ),
      );

  Widget _productRow() => Row(
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: AppTheme.primaryContainer,
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(Icons.sensors,
                color: AppTheme.primary, size: 36),
          ),
          const SizedBox(width: 12),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('FreeStyle Libre Sensor Kit',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        color: AppTheme.text)),
                Text('Continuous Glucose Monitor • 1 Sensor Unit',
                    style: TextStyle(
                        fontSize: 11, color: AppTheme.mutedText)),
                SizedBox(height: 4),
                Row(
                  children: [
                    Icon(Icons.store_outlined,
                        size: 12, color: AppTheme.mutedText),
                    SizedBox(width: 4),
                    Text('Sourced from Central State Hub',
                        style: TextStyle(
                            fontSize: 11, color: AppTheme.mutedText)),
                  ],
                ),
              ],
            ),
          ),
          Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
            decoration: BoxDecoration(
              color: AppTheme.mutedBg,
              borderRadius: BorderRadius.circular(4),
            ),
            child: const Text('14-Day',
                style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.mutedText)),
          ),
        ],
      );

  Widget _priceRow() => const Row(
        children: [
          Text('₹4,899',
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: AppTheme.text)),
          SizedBox(width: 8),
          Text('₹5,499',
              style: TextStyle(
                  decoration: TextDecoration.lineThrough,
                  color: AppTheme.mutedText,
                  fontSize: 12)),
          SizedBox(width: 8),
          Text('11% OFF',
              style: TextStyle(
                  color: AppTheme.successText,
                  fontWeight: FontWeight.bold,
                  fontSize: 12)),
        ],
      );

  Widget _orderButton() => Builder(
        builder: (context) => SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: () => pickPrescription(context),
            icon: const Icon(Icons.local_shipping_outlined, size: 16),
            label: const Text('Order for Tomorrow, 10 AM',
                style: TextStyle(fontWeight: FontWeight.bold)),
            style: ElevatedButton.styleFrom(
              minimumSize: const Size(0, 48),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
          ),
        ),
      );
}
