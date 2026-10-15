import 'package:flutter/material.dart';

import '../../../core/theme.dart';

/// Full-width card shown when the local dark-store cluster has no stock.
/// Provides a "Notify Me" CTA so the user isn't left at a dead end.
class NoStockCard extends StatefulWidget {
  const NoStockCard({super.key});

  @override
  State<NoStockCard> createState() => _NoStockCardState();
}

class _NoStockCardState extends State<NoStockCard> {
  bool _notified = false;

  void _onNotifyTap() {
    setState(() => _notified = true);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text("We'll notify you as soon as stock arrives"),
        backgroundColor: AppTheme.primary,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF7ED),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFFED7AA)),
      ),
      child: Row(
        children: [
          const Icon(Icons.info_outline, color: Color(0xFFB45309), size: 22),
          const SizedBox(width: 10),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Unavailable at your nearby hub',
                    style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14, color: AppTheme.text)),
                SizedBox(height: 2),
                Text('We found another way to get it to you.',
                    style: TextStyle(fontSize: 12, color: AppTheme.mutedText)),
              ],
            ),
          ),
          const SizedBox(width: 8),
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 250),
            child: _notified
                ? const Icon(Icons.check_circle, key: ValueKey('notified'), color: AppTheme.successText, size: 22)
                : IconButton(
                    key: const ValueKey('notify'),
                    onPressed: _onNotifyTap,
                    tooltip: 'Notify me when available',
                    visualDensity: VisualDensity.compact,
                    icon: const Icon(Icons.notifications_active_outlined, color: AppTheme.primary),
                  ),
          ),
        ],
      ),
    );
  }
}
