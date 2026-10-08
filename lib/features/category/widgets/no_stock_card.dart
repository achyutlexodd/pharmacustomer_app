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
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.outlineBorder),
      ),
      child: Column(
        children: [
          Stack(
            alignment: Alignment.bottomRight,
            children: [
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AppTheme.primaryContainer,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Icon(Icons.sensors, size: 48, color: AppTheme.primary),
              ),
              Container(
                padding: const EdgeInsets.all(4),
                decoration: const BoxDecoration(color: Colors.red, shape: BoxShape.circle),
                child: const Icon(Icons.access_time, color: Colors.white, size: 14),
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Text(
            'No Stock in Your Dark-Store\nCluster',
            textAlign: TextAlign.center,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: AppTheme.text),
          ),
          const SizedBox(height: 8),
          const Text(
            'This item is temporarily out of stock at your nearest hub.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 12, color: AppTheme.mutedText),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  child: _notified
                      ? Container(
                          key: const ValueKey('notified'),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          decoration: BoxDecoration(
                            color: AppTheme.successBg,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: AppTheme.successText.withValues(alpha: 0.4)),
                          ),
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.check_circle, color: AppTheme.successText, size: 18),
                              SizedBox(width: 8),
                              Text('Notification Set!',
                                  style: TextStyle(
                                      color: AppTheme.successText,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14)),
                            ],
                          ),
                        )
                      : ElevatedButton.icon(
                          key: const ValueKey('notify'),
                          onPressed: _onNotifyTap,
                          icon: const Icon(Icons.notifications_outlined, size: 16),
                          label: const Text('Notify Me When Available',
                              style: TextStyle(fontWeight: FontWeight.bold)),
                          style: ElevatedButton.styleFrom(
                            minimumSize: const Size(double.infinity, 48),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                        ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          OutlinedButton.icon(
            onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: const Text('Sourcing from nearby stores…'),
                behavior: SnackBarBehavior.floating,
                backgroundColor: AppTheme.primary,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
            ),
            icon: const Icon(Icons.store_outlined, size: 16),
            label: const Text('Check Nearby Stores'),
            style: OutlinedButton.styleFrom(
              minimumSize: const Size(double.infinity, 44),
              side: const BorderSide(color: AppTheme.outlineBorder),
              foregroundColor: AppTheme.text,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
          ),
        ],
      ),
    );
  }
}
