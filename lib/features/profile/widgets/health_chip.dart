import 'package:flutter/material.dart';
import '../../../core/theme.dart';

class HealthChip extends StatelessWidget {
  const HealthChip({super.key, required this.label, this.allergy = false});
  final String label;
  final bool allergy;

  @override
  Widget build(BuildContext context) => Semantics(
    label: allergy ? 'Allergy: $label' : 'Health condition: $label',
    child: Container(
      constraints: const BoxConstraints(minHeight: 30),
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
      decoration: BoxDecoration(
        color: allergy ? AppTheme.warningBg : AppTheme.primaryContainer,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (allergy) ...[
            const Icon(
              Icons.warning_amber_rounded,
              size: 14,
              color: AppTheme.warningText,
            ),
            const SizedBox(width: 4),
          ],
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              color: allergy ? AppTheme.warningText : AppTheme.primaryDark,
            ),
          ),
        ],
      ),
    ),
  );
}
