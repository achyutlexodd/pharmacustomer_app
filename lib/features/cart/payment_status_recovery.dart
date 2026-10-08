import 'package:flutter/material.dart';

import '../../core/theme.dart';
import 'payment_declined.dart';
import 'payment_processing.dart';

class PaymentStatusRecovery extends StatelessWidget {
  const PaymentStatusRecovery({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      title: const Text('HealthRx · AuraCare'),
      actions: const [
        Padding(padding: EdgeInsets.all(16), child: Text('🔒 256-BIT SYNC')),
      ],
    ),
    body: ListView(
      padding: const EdgeInsets.all(20),
      children: [
        const Text(
          '● TRANSACTION RECONCILIATION',
          style: TextStyle(
            fontSize: 11,
            color: AppTheme.primary,
            fontWeight: FontWeight.bold,
          ),
        ),
        const Text(
          'Verifying Payment & Syncing Order',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(22),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: AppTheme.outlineBorder),
          ),
          child: Column(
            children: [
              const CircleAvatar(
                radius: 38,
                backgroundColor: AppTheme.surfaceLow,
                child: Icon(Icons.sync, color: AppTheme.primary, size: 36),
              ),
              const SizedBox(height: 18),
              const Text(
                'Restoring Order Status…',
                style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              const Text(
                'We are verifying your transaction with your bank. If money was debited, your order will confirm automatically without double charge.',
                textAlign: TextAlign.center,
                style: TextStyle(height: 1.45, color: AppTheme.textSecondary),
              ),
              const Divider(height: 28),
              const Row(
                children: [
                  Expanded(
                    child: _Info('Order Reference', '#AC-9941 · ₹1,507.00'),
                  ),
                  SizedBox(width: 8),
                  Expanded(
                    child: _Info('Gateway Tracking', 'RZP_ORDER_98192746'),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(18),
          ),
          child: const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '▤ Medication Manifest',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 16),
              _Line('Janumet 50mg/500mg', '₹485.00'),
              Divider(),
              _Line('Rosuvas 10mg', '₹1,022.00'),
              Divider(),
              _Line('Total committed (incl. taxes)', '₹1,507.00', bold: true),
            ],
          ),
        ),
        const SizedBox(height: 16),
        const LinearProgressIndicator(value: .4, minHeight: 8),
        const SizedBox(height: 8),
        const Text(
          'Polling banking node · Auto refresh in 10s',
          textAlign: TextAlign.center,
          style: TextStyle(color: AppTheme.mutedText),
        ),
      ],
    ),
    bottomNavigationBar: SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () => Navigator.pushReplacement(
                  context,
                  MaterialPageRoute<void>(
                    builder: (_) => const PaymentProcessing(amount: 1507),
                  ),
                ),
                icon: const Icon(Icons.refresh),
                label: const Text('I have been debited · Check status now'),
              ),
            ),
            OutlinedButton.icon(
              onPressed: () => Navigator.pushReplacement(
                context,
                MaterialPageRoute<void>(
                  builder: (_) => const PaymentDeclined(),
                ),
              ),
              icon: const Icon(Icons.hourglass_bottom),
              label: const Text('Still pending · Retry options'),
            ),
          ],
        ),
      ),
    ),
  );
}

class _Info extends StatelessWidget {
  const _Info(this.label, this.value);
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(10),
    decoration: BoxDecoration(
      color: AppTheme.background,
      borderRadius: BorderRadius.circular(12),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 10, color: AppTheme.mutedText),
        ),
        Text(
          value,
          style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
        ),
      ],
    ),
  );
}

class _Line extends StatelessWidget {
  const _Line(this.name, this.value, {this.bold = false});
  final String name;
  final String value;
  final bool bold;

  @override
  Widget build(BuildContext context) => Row(
    children: [
      Expanded(
        child: Text(
          name,
          style: TextStyle(
            fontWeight: bold ? FontWeight.bold : FontWeight.w500,
          ),
        ),
      ),
      Text(
        value,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: bold ? AppTheme.primaryDark : AppTheme.text,
        ),
      ),
    ],
  );
}
