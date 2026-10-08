import 'package:flutter/material.dart';

import '../../core/theme.dart';
import '../../core/constants/app_strings.dart';
import 'search.dart';
import 'widgets/condition_item.dart';
import 'widgets/prescription_banner.dart';
import 'widgets/trending_card.dart';

class Home extends StatelessWidget {
  final String name;
  final String location;
  const Home({super.key, required this.name, this.location = 'Set delivery location'});

  // ── Time-of-day greeting ───────────────────────────────────────────────────
  String get _greeting {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Good Morning';
    if (hour < 17) return 'Good Afternoon';
    return 'Good Evening';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: _buildAppBar(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _welcomeRow(context),
            const SizedBox(height: 16),
            Row(children: [const Icon(Icons.location_on_outlined, size: 16, color: AppTheme.primary), const SizedBox(width: 4), Expanded(child: Text(location, style: Theme.of(context).textTheme.bodySmall, overflow: TextOverflow.ellipsis))]),
            const SizedBox(height: 12),
            _searchBar(context),
            const SizedBox(height: 20),
            const PrescriptionBanner(),
            const SizedBox(height: 24),
            _browseByConcernHeader(context),
            const SizedBox(height: 12),
            _conditionRow(),
            const SizedBox(height: 24),
            Text('Trending Health Essentials',
                style: Theme.of(context).textTheme.headlineSmall),
            const SizedBox(height: 12),
            _trendingRow(),
          ],
        ),
      ),
    );
  }

  // ── AppBar ────────────────────────────────────────────────────────────────

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      automaticallyImplyLeading: false,
      title: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: AppTheme.primary,
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(Icons.local_pharmacy_outlined, color: Colors.white, size: 20),
          ),
          const SizedBox(width: 10),
          Text(AppStrings.appName,
              style: TextStyle(color: AppTheme.primary, fontWeight: FontWeight.bold, fontSize: 17)),
        ],
      ),
      actions: [
        Stack(
          children: [
            IconButton(
              icon: const Icon(Icons.notifications_outlined),
              onPressed: () {},
            ),
            Positioned(
              right: 10, top: 10,
              child: Container(
                width: 8, height: 8,
                decoration: const BoxDecoration(color: Colors.red, shape: BoxShape.circle),
              ),
            ),
          ],
        ),
        const SizedBox(width: 4),
      ],
    );
  }

  // ── Section builders ───────────────────────────────────────────────────────

  Widget _welcomeRow(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('WELCOME BACK',
                style: Theme.of(context)
                    .textTheme
                    .labelSmall
                    ?.copyWith(color: AppTheme.mutedText, letterSpacing: 1)),
            const SizedBox(height: 4),
            Text('$_greeting, $name',
                style: Theme.of(context).textTheme.headlineMedium),
          ],
        ),
        Container(
          padding: const EdgeInsets.all(3),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: AppTheme.primary.withValues(alpha: 0.4), width: 2),
          ),
          child: const CircleAvatar(
            radius: 20,
            backgroundColor: AppTheme.primaryContainer,
            child: Icon(Icons.person, color: AppTheme.primary),
          ),
        ),
      ],
    );
  }

  Widget _searchBar(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const Search()),
      ),
      child: Container(
        height: 50,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(30),
          border: Border.all(color: AppTheme.outlineBorder),
          boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 8)],
        ),
        child: Row(
          children: [
            const Icon(Icons.search, color: AppTheme.primary, size: 20),
            const SizedBox(width: 10),
            Text('Search medicines, brands, generics...',
                style: TextStyle(color: AppTheme.textDisabled, fontSize: 14)),
            const Spacer(),
            const Icon(Icons.mic_outlined, color: AppTheme.primary, size: 20),
          ],
        ),
      ),
    );
  }

  Widget _browseByConcernHeader(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text('Browse by Condition', style: Theme.of(context).textTheme.headlineSmall),
        GestureDetector(
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const Search()),
          ),
          child: const Text('View All >',
              style: TextStyle(color: AppTheme.primary, fontWeight: FontWeight.bold, fontSize: 12)),
        ),
      ],
    );
  }

  Widget _conditionRow() {
    return const Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        ConditionItem(icon: Icons.favorite_outline,    label: 'Cardio',    iconColor: Colors.red,   categoryName: 'Heart & BP'),
        ConditionItem(icon: Icons.water_drop_outlined, label: 'Diabetes',  iconColor: Colors.teal,  categoryName: 'Diabetes Care & Management'),
        ConditionItem(icon: Icons.psychology_outlined, label: 'Neuro',     iconColor: Colors.cyan,  categoryName: 'Neuro & Mental Health'),
        ConditionItem(icon: Icons.spa_outlined,        label: 'Wellness',  iconColor: Colors.green, categoryName: 'Vitamins & Daily'),
        ConditionItem(icon: Icons.air,                 label: 'Respiratory', iconColor: Colors.teal, categoryName: 'Respiratory & Cold'),
      ],
    );
  }

  Widget _trendingRow() {
    return Row(
      children: [
        Expanded(
          child: TrendingCard(
            title: 'Vitamin D3',
            subtitle: '4 Capsules • Weekly',
            price: '₹120',
            tag: 'OTC',
            tagColor: Colors.teal.shade50,
            tagTextColor: Colors.teal.shade800,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: TrendingCard(
            title: 'Omega-3 Fish Oil',
            subtitle: '60 Softgels • 1000mg',
            price: '₹649',
            tag: 'OTC',
            tagColor: Colors.teal.shade50,
            tagTextColor: Colors.teal.shade800,
          ),
        ),
      ],
    );
  }
}
