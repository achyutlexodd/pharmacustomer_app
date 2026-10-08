import 'package:flutter/material.dart';

import '../theme.dart';

/// Section header. Safe to use both standalone and inside a Row.
/// When [trailingLabel] is provided it renders as a Row; the title column
/// uses Expanded so it never requests unbounded width.
class SectionHeader extends StatelessWidget {
  final String title;
  final String? subtitle;
  final String? trailingLabel;
  final VoidCallback? onTrailingTap;

  const SectionHeader({
    super.key,
    required this.title,
    this.subtitle,
    this.trailingLabel,
    this.onTrailingTap,
  });

  @override
  Widget build(BuildContext context) {
    // When used standalone (not inside another Row) we always have bounded
    // width — Column → full width. Safe to use Expanded here.
    // Callers that embed this inside a Row must wrap it in Expanded themselves.
    final titleColumn = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(title,
            style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: AppTheme.text)),
        if (subtitle != null)
          Text(subtitle!,
              style: const TextStyle(
                  color: AppTheme.mutedText, fontSize: 12)),
      ],
    );

    if (trailingLabel == null) return titleColumn;

    return Row(
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(child: titleColumn),
        GestureDetector(
          onTap: onTrailingTap,
          child: Text(trailingLabel!,
              style: const TextStyle(
                  color: AppTheme.primary,
                  fontWeight: FontWeight.bold,
                  fontSize: 12)),
        ),
      ],
    );
  }
}
