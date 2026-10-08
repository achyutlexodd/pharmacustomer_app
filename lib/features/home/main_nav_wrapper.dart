import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/providers/cart_notifier.dart';
import 'home.dart';
import 'search.dart';
import '../prescriptions/prescription_vault.dart';
import '../orders/order_history.dart';
import '../profile/profile_home.dart';

class MainNavWrapper extends StatefulWidget {
  final String name;
  final String location;
  const MainNavWrapper({
    super.key,
    required this.name,
    this.location = 'Set delivery location',
  });

  @override
  State<MainNavWrapper> createState() => _MainNavWrapperState();
}

class _MainNavWrapperState extends State<MainNavWrapper> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    // IndexedStack preserves scroll + state across tab switches
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: [
          Home(name: widget.name, location: widget.location),
          Search(onBack: () => setState(() => _currentIndex = 0)),
          const OrderHistory(),
          PrescriptionVault(
            patientName: widget.name,
            onBack: () => setState(() => _currentIndex = 0),
          ),
          ProfileHome(name: widget.name),
        ],
      ),
      bottomNavigationBar: Consumer<CartNotifier>(
        builder: (_, cart, _) => BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (i) => setState(() => _currentIndex = i),
          items: [
            const BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined),
              activeIcon: Icon(Icons.home),
              label: 'Home',
            ),
            const BottomNavigationBarItem(
              icon: Icon(Icons.search),
              label: 'Search',
            ),
            BottomNavigationBarItem(
              icon: _BadgedIcon(
                icon: Icons.receipt_long_outlined,
                count: cart.totalCount,
              ),
              label: 'Orders',
            ),
            const BottomNavigationBarItem(
              icon: Icon(Icons.description_outlined),
              label: 'Prescriptions',
            ),
            const BottomNavigationBarItem(
              icon: Icon(Icons.person_outline),
              label: 'Profile',
            ),
          ],
        ),
      ),
    );
  }
}

// ── Helper widgets ────────────────────────────────────────────────────────────

class _BadgedIcon extends StatelessWidget {
  final IconData icon;
  final int count;
  const _BadgedIcon({required this.icon, required this.count});

  @override
  Widget build(BuildContext context) {
    if (count == 0) return Icon(icon);
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Icon(icon),
        Positioned(
          right: -6,
          top: -4,
          child: Container(
            padding: const EdgeInsets.all(3),
            decoration: const BoxDecoration(
              color: Colors.red,
              shape: BoxShape.circle,
            ),
            child: Text(
              '$count',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 9,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
