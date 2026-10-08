import 'package:flutter/material.dart';

import '../../core/theme.dart';

const prescriptionBg = Color(0xFFF0FAFD);
const medicines = <(String, String, double)>[
  ('Glycomet-GP 2 Forte', '30 Tablets • Strip Pack', 297),
  ('Januvia 100mg', '28 Tablets • Strip Pack', 485),
  ('Atorva 20mg', 'Atorvastatin Calcium 20mg • 30 Tablets', 725),
];

BoxDecoration statusCard({Color? color, Color? border}) => BoxDecoration(
  color: color ?? Colors.white,
  borderRadius: BorderRadius.circular(18),
  border: Border.all(color: border ?? const Color(0xFFD9EDF2)),
  boxShadow: [
    BoxShadow(
      color: Colors.black.withValues(alpha: .025),
      blurRadius: 10,
      offset: const Offset(0, 3),
    ),
  ],
);

class StatusScaffold extends StatelessWidget {
  final String title;
  final Widget body;
  final Widget? bottom;
  final String? subtitle;
  const StatusScaffold({
    super.key,
    required this.title,
    required this.body,
    this.bottom,
    this.subtitle,
  });

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: prescriptionBg,
    appBar: AppBar(
      backgroundColor: prescriptionBg,
      leading: BackButton(onPressed: () => Navigator.maybePop(context)),
      title: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(title),
          if (subtitle != null)
            Text(
              subtitle!,
              style: const TextStyle(
                fontSize: 10,
                color: AppTheme.textSecondary,
              ),
            ),
        ],
      ),
      centerTitle: true,
    ),
    body: SafeArea(top: false, child: body),
    bottomNavigationBar: bottom,
  );
}

class MedicineRow extends StatelessWidget {
  final (String, String, double) medicine;
  final String? status;
  const MedicineRow(this.medicine, {super.key, this.status});

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 10),
    child: Row(
      children: [
        const CircleAvatar(
          backgroundColor: Color(0xFFDDF6FB),
          child: Icon(Icons.medication_outlined, color: AppTheme.primary),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                medicine.$1,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(
                medicine.$2,
                style: const TextStyle(
                  fontSize: 12,
                  color: AppTheme.textSecondary,
                ),
              ),
              if (status != null)
                Text(
                  status!,
                  style: const TextStyle(fontSize: 11, color: Colors.teal),
                ),
            ],
          ),
        ),
        Text(
          '₹${medicine.$3.toStringAsFixed(2)}',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      ],
    ),
  );
}

Widget statusPanel({
  required Widget child,
  EdgeInsets padding = const EdgeInsets.all(16),
  Color? border,
}) => Container(
  padding: padding,
  decoration: statusCard(border: border),
  child: child,
);
