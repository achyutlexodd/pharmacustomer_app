import 'package:flutter/material.dart';

import '../../../core/theme.dart';

/// Thin teal banner at the top of MedicineDetailExtended showing
/// delivery address and stock status.
class DeliveryBanner extends StatelessWidget {
  const DeliveryBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: AppTheme.primaryContainer,
        borderRadius: BorderRadius.circular(8),
      ),
      child: const Row(
        children: [
          Icon(Icons.bolt, size: 14, color: AppTheme.primary),
          SizedBox(width: 6),
          Expanded(
            child: Text(
              'Available for delivery to your selected location',
              style: TextStyle(
                  fontSize: 11,
                  color: AppTheme.primary,
                  fontWeight: FontWeight.w600),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
