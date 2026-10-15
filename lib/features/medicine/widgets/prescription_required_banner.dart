import 'package:flutter/material.dart';

import '../../../core/theme.dart';

/// Red banner shown when a prescription is mandatory for the medicine.
class PrescriptionRequiredBanner extends StatelessWidget {
  const PrescriptionRequiredBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.errorBg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.red.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.description_outlined,
                    color: AppTheme.error, size: 20),
              ),
              const SizedBox(width: 10),
              const Text('Prescription Required (Rx)',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                      color: AppTheme.error)),
            ],
          ),
          const SizedBox(height: 10),
          const Text(
            'A valid prescription from a registered medical practitioner is needed before this medicine can be dispensed. Upload it securely to continue.',
            style: TextStyle(color: AppTheme.error, fontSize: 12),
          ),
          const SizedBox(height: 10),
          const Row(
            children: [
              Icon(Icons.lock_outline, size: 12, color: AppTheme.error),
              SizedBox(width: 4),
              Text('100% Doctor Verified',
                  style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.error)),
            ],
          ),
        ],
      ),
    );
  }
}
