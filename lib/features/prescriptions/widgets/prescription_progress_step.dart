import 'package:flutter/material.dart';

import '../../../core/theme.dart';

class PrescriptionProgressStep extends StatelessWidget {
  final IconData icon;
  final String title;
  final bool done;
  final bool active;

  const PrescriptionProgressStep({
    super.key,
    required this.icon,
    required this.title,
    this.done = false,
    this.active = false,
  });

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: 14),
    child: Row(
      children: [
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: done || active ? AppTheme.primary : const Color(0xFFDDF6FB),
            shape: BoxShape.circle,
          ),
          child: Icon(
            icon,
            size: 17,
            color: done || active ? Colors.white : AppTheme.mutedText,
          ),
        ),
        const SizedBox(width: 12),
        Text(
          title,
          style: TextStyle(
            fontSize: 14,
            fontWeight: active || done ? FontWeight.w600 : FontWeight.normal,
            color: active || done ? AppTheme.text : AppTheme.mutedText,
          ),
        ),
        if (active) ...[
          const SizedBox(width: 8),
          const Text(
            'IN PROGRESS',
            style: TextStyle(
              fontSize: 9,
              color: AppTheme.primary,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ],
    ),
  );
}
