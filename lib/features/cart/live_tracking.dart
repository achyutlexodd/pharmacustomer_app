import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/providers/cart_notifier.dart';
import '../../core/theme.dart';
import 'doorstep_verification.dart';
import 'split_shipment_tracking.dart';

class LiveTracking extends StatelessWidget {
  const LiveTracking({super.key});

  @override
  Widget build(BuildContext context) {
    final cart = context.watch<CartNotifier>();
    return Scaffold(
      body: Stack(
        children: [
          const Positioned.fill(child: CustomPaint(painter: _MapPainter())),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        backgroundColor: Colors.white,
                        child: IconButton(
                          onPressed: () => Navigator.pop(context),
                          icon: const Icon(Icons.arrow_back),
                        ),
                      ),
                      const SizedBox(width: 12),
                      const Expanded(
                        child: Chip(
                          avatar: Icon(
                            Icons.circle,
                            size: 12,
                            color: AppTheme.primary,
                          ),
                          label: Text('On the Way · Out for Delivery'),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xFF17383F),
                      borderRadius: BorderRadius.circular(18),
                      boxShadow: const [
                        BoxShadow(color: Colors.black26, blurRadius: 12),
                      ],
                    ),
                    child: const Row(
                      children: [
                        Icon(
                          Icons.delivery_dining,
                          color: Color(0xFF8AE2E8),
                          size: 30,
                        ),
                        SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Arriving in 14 mins',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                'Dispensed from Bellandur Hub · Batch #RX-992',
                                style: TextStyle(
                                  color: Colors.white70,
                                  fontSize: 11,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Text(
                          '#8819',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Spacer(),
                  Container(
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: const [
                        BoxShadow(color: Colors.black12, blurRadius: 16),
                      ],
                    ),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            const CircleAvatar(
                              radius: 26,
                              backgroundColor: AppTheme.surfaceLow,
                              child: Icon(
                                Icons.person,
                                color: AppTheme.primary,
                              ),
                            ),
                            const SizedBox(width: 12),
                            const Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Ramesh Kumar  ⭐ 4.9',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                  Text(
                                    'AuraCare Express · Hero Electric',
                                    style: TextStyle(color: AppTheme.mutedText),
                                  ),
                                ],
                              ),
                            ),
                            IconButton.filledTonal(
                              onPressed: () {},
                              icon: const Icon(Icons.call_outlined),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Expanded(
                              child: OutlinedButton.icon(
                                onPressed: () =>
                                    _message(context, 'Delivery instructions'),
                                icon: const Icon(Icons.chat_bubble_outline),
                                label: const Text('Instructions'),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: OutlinedButton.icon(
                                onPressed: () =>
                                    _message(context, 'Trip link copied'),
                                icon: const Icon(Icons.share_outlined),
                                label: const Text('Share trip'),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        InkWell(
                          borderRadius: BorderRadius.circular(16),
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute<void>(
                              builder: (_) => const DoorstepVerification(),
                            ),
                          ),
                          child: Container(
                            padding: const EdgeInsets.all(14),
                            decoration: BoxDecoration(
                              color: AppTheme.surfaceLow,
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: const Row(
                              children: [
                                Icon(
                                  Icons.location_on_outlined,
                                  color: AppTheme.primary,
                                ),
                                SizedBox(width: 10),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'DELIVERY ADDRESS · HOME',
                                        style: TextStyle(
                                          fontSize: 10,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Text(
                                        'Flat 402, Green Glen Layout, Bellandur',
                                        style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      Text(
                                        'Bengaluru, Karnataka 560103',
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: AppTheme.textSecondary,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Text(
                                  'Change',
                                  style: TextStyle(
                                    color: AppTheme.primary,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        Container(
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color: const Color(0xFF17383F),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: const Row(
                            children: [
                              Icon(Icons.key, color: Color(0xFF8AE2E8)),
                              SizedBox(width: 10),
                              Expanded(
                                child: Text(
                                  'Handover verification code',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                              Text(
                                '8492',
                                style: TextStyle(
                                  color: Color(0xFF8AE2E8),
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 2,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            const Icon(
                              Icons.medication_outlined,
                              color: AppTheme.primary,
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                '${cart.totalCount} medicines in insulated pouch',
                              ),
                            ),
                            TextButton(
                              onPressed: () => Navigator.push(
                                context,
                                MaterialPageRoute<void>(
                                  builder: (_) => const SplitShipmentTracking(),
                                ),
                              ),
                              child: const Text('View shipments'),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _message(BuildContext context, String text) =>
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text)));
}

class _MapPainter extends CustomPainter {
  const _MapPainter();

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawColor(const Color(0xFFE4F3F5), BlendMode.src);
    final road = Paint()
      ..color = Colors.white
      ..strokeWidth = 10
      ..style = PaintingStyle.stroke;
    final fineRoad = Paint()
      ..color = const Color(0xFFD0E5E8)
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;
    for (var i = -2; i < 7; i++) {
      final path = Path()
        ..moveTo(i * 90.0, 0)
        ..lineTo(i * 90.0 + 80, size.height * .55);
      canvas.drawPath(path, road);
      canvas.drawPath(path, fineRoad);
    }
    final route = Path()
      ..moveTo(size.width * .25, size.height * .28)
      ..lineTo(size.width * .54, size.height * .35)
      ..lineTo(size.width * .44, size.height * .48)
      ..lineTo(size.width * .58, size.height * .60);
    canvas.drawPath(
      route,
      Paint()
        ..color = AppTheme.primary
        ..strokeWidth = 5
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round,
    );
    for (final point in [
      Offset(size.width * .25, size.height * .28),
      Offset(size.width * .58, size.height * .60),
    ]) {
      canvas.drawCircle(point, 11, Paint()..color = Colors.white);
      canvas.drawCircle(point, 7, Paint()..color = AppTheme.primary);
    }
  }

  @override
  bool shouldRepaint(covariant _MapPainter oldDelegate) => false;
}
