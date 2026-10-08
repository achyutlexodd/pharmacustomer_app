import 'package:flutter/material.dart';

import '../../../core/theme.dart';
import '../../category/category_detail.dart';

/// Single icon + label used in the "Browse by Condition" row.
class ConditionItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color iconColor;
  final String categoryName;

  const ConditionItem({
    super.key,
    required this.icon,
    required this.label,
    required this.iconColor,
    required this.categoryName,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => CategoryDetail(categoryName: categoryName)),
      ),
      child: Column(
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 150),
            width: 54,
            height: 54,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.grey.shade200),
              boxShadow: [
                BoxShadow(color: iconColor.withValues(alpha: 0.12), blurRadius: 8, offset: const Offset(0, 3)),
              ],
            ),
            child: Icon(icon, color: iconColor, size: 24),
          ),
          const SizedBox(height: 6),
          Text(label,
              style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w500, color: AppTheme.text)),
        ],
      ),
    );
  }
}
