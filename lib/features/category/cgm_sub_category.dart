import 'package:flutter/material.dart';

import '../../core/theme.dart';
import '../medicine/medicine_detail_extended.dart';
import 'widgets/in_stock_section.dart';
import 'widgets/no_stock_card.dart';
import 'widgets/sourcing_solution_card.dart';

class CgmSubCategory extends StatelessWidget {
  final String location;
  const CgmSubCategory({super.key, this.location = 'Set delivery location'});

  static const List<String> _tabs = ['All', 'Oral Meds', 'Insulin Pens', 'CGM Sensors'];

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: _tabs.length,
      initialIndex: 3,
      child: Scaffold(
        backgroundColor: AppTheme.background,
        appBar: _buildAppBar(context),
        body: TabBarView(
          children: [
            _CgmBody(onCardTap: _navigateToDetail(context)),
            const Center(child: Text('Oral Meds')),
            const Center(child: Text('Insulin Pens')),
            _CgmBody(onCardTap: _navigateToDetail(context)),
          ],
        ),
      ),
    );
  }

  VoidCallback _navigateToDetail(BuildContext context) => () => Navigator.push(
        context,
        MaterialPageRoute(
            builder: (_) => const MedicineDetailExtended()),
      );

  // ── AppBar ────────────────────────────────────────────────────────────────

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      leading: BackButton(
          color: AppTheme.text, onPressed: () => Navigator.pop(context)),
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: const Text('Diabetes Care & Management ›',
                style: TextStyle(fontSize: 11, color: AppTheme.mutedText)),
          ),
          const Text('CGM & Biosensors',
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: AppTheme.text)),
        ],
      ),
      actions: [
        IconButton(
            icon: const Icon(Icons.search, color: AppTheme.text),
            onPressed: () {}),
        Stack(
          children: [
            IconButton(
                icon: const Icon(Icons.notifications_outlined,
                    color: AppTheme.text),
                onPressed: () {}),
            const Positioned(
              right: 10,
              top: 10,
              child: CircleAvatar(
                  radius: 4, backgroundColor: Colors.red),
            ),
          ],
        ),
      ],
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(88),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(
                  horizontal: 16, vertical: 6),
              color: AppTheme.primaryContainer,
              child: Row(
                children: [
                  const Icon(Icons.location_on,
                      size: 14, color: AppTheme.primary),
                  const SizedBox(width: 4),
                  Text('$location  •  ',
                      style: TextStyle(
                          fontSize: 11, color: AppTheme.text)),
                  const Expanded(
                    child: Text('Cluster 04 (0 Local In...',
                        style: TextStyle(
                            fontSize: 11,
                            color: AppTheme.text,
                            overflow: TextOverflow.ellipsis)),
                  ),
                  GestureDetector(
                    onTap: () {},
                    child: const Text('Change',
                        style: TextStyle(
                            fontSize: 11,
                            color: AppTheme.primary,
                            fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
            ),
            TabBar(
              isScrollable: true,
              tabAlignment: TabAlignment.start,
              labelColor: Colors.white,
              unselectedLabelColor: AppTheme.text,
              indicator: BoxDecoration(
                color: AppTheme.primary,
                borderRadius: BorderRadius.circular(20),
              ),
              indicatorSize: TabBarIndicatorSize.label,
              labelPadding:
                  const EdgeInsets.symmetric(horizontal: 4),
              tabs: _tabs
                  .map((t) => Tab(child: _TabPill(label: t)))
                  .toList(),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Body widget ───────────────────────────────────────────────────────────────

class _CgmBody extends StatelessWidget {
  final VoidCallback onCardTap;
  const _CgmBody({required this.onCardTap});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const NoStockCard(),
          const SizedBox(height: 20),
          const SourcingSolutionCard(),
          const SizedBox(height: 20),
          InStockSection(onTap: onCardTap),
        ],
      ),
    );
  }
}

class _TabPill extends StatelessWidget {
  final String label;
  const _TabPill({required this.label});

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        child: Text(label,
            style: const TextStyle(
                fontSize: 13, fontWeight: FontWeight.w600)),
      );
}
