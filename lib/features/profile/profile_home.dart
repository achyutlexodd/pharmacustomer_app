import 'package:flutter/material.dart';

import '../../core/theme.dart';
import '../orders/order_history.dart';
import '../prescriptions/prescription_vault.dart';

class ProfileHome extends StatelessWidget {
  const ProfileHome({super.key, required this.name});
  final String name;

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      automaticallyImplyLeading: false,
      title: const Text('HealthRx'),
      actions: [
        IconButton(
          onPressed: () {},
          icon: const Icon(Icons.notifications_none),
        ),
      ],
    ),
    body: ListView(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
      children: [
        _panel(
          ListTile(
            leading: const CircleAvatar(
              radius: 27,
              backgroundColor: AppTheme.surfaceLow,
              child: Icon(Icons.person, color: AppTheme.primary, size: 30),
            ),
            title: Text(
              name.isEmpty ? 'Achyut' : name,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
            ),
            subtitle: const Text('+91 7488882789'),
            trailing: IconButton(
              onPressed: () {},
              icon: const Icon(Icons.edit_outlined, color: AppTheme.primary),
            ),
          ),
        ),
        const SizedBox(height: 22),
        const Text(
          'Medical Records & Conditions',
          style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            Expanded(
              child: _panel(
                const ListTile(
                  leading: Icon(
                    Icons.monitor_heart_outlined,
                    color: AppTheme.primary,
                  ),
                  title: Text(
                    'Chronic Condition',
                    style: TextStyle(fontSize: 11),
                  ),
                  subtitle: Text(
                    'Type 2 Diabetes',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: _panel(
                const ListTile(
                  leading: Icon(
                    Icons.warning_amber_outlined,
                    color: AppTheme.warningText,
                  ),
                  title: Text('Known Allergy', style: TextStyle(fontSize: 11)),
                  subtitle: Text(
                    'Penicillin sensitivity',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        _panel(
          const ListTile(
            leading: Icon(Icons.emergency_outlined, color: AppTheme.error),
            title: Text('Emergency Contact'),
            subtitle: Text('Dr. Mehta, Cardiologist · +91 94220 54321'),
          ),
        ),
        const SizedBox(height: 22),
        const Text(
          'Account Management',
          style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        _panel(
          Column(
            children: [
              ListTile(
                leading: const Icon(
                  Icons.people_outline,
                  color: AppTheme.primary,
                ),
                title: const Text('Saved Patient Profiles'),
                subtitle: const Text('Self, Mother, Spouse'),
                trailing: const Icon(Icons.chevron_right),
                onTap: () {},
              ),
              const Divider(height: 1),
              ListTile(
                leading: const Icon(
                  Icons.description_outlined,
                  color: AppTheme.primary,
                ),
                title: const Text('Prescription Vault'),
                subtitle: const Text(
                  'Digital copies signed by licensed clinics',
                ),
                trailing: const Icon(Icons.chevron_right),
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute<void>(
                    builder: (_) =>
                        const PrescriptionVault(patientName: 'Aditi Rao'),
                  ),
                ),
              ),
              const Divider(height: 1),
              ListTile(
                leading: const Icon(
                  Icons.receipt_long_outlined,
                  color: AppTheme.primary,
                ),
                title: const Text('Order History'),
                subtitle: const Text('Invoices, tracking and refills'),
                trailing: const Icon(Icons.chevron_right),
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute<void>(builder: (_) => const OrderHistory()),
                ),
              ),
              const Divider(height: 1),
              const ListTile(
                leading: Icon(Icons.autorenew, color: AppTheme.primary),
                title: Text('Auto-Refill Subscriptions'),
                subtitle: Text('2 active · Next refill 12 June'),
                trailing: Icon(Icons.chevron_right),
              ),
              const Divider(height: 1),
              const ListTile(
                leading: Icon(
                  Icons.health_and_safety_outlined,
                  color: AppTheme.primary,
                ),
                title: Text('Insurance & Corporate Subsidies'),
                subtitle: Text('Star Health Allied · 80% cashless co-pay'),
                trailing: Icon(Icons.chevron_right),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}

Widget _panel(Widget child) => Material(
  color: Colors.white,
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(20),
    side: const BorderSide(color: AppTheme.outlineBorder),
  ),
  clipBehavior: Clip.antiAlias,
  child: child,
);
