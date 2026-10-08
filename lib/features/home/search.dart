import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/providers/cart_notifier.dart';
import '../../core/models/mock_medicines.dart';
import '../../core/models/cart_item.dart';
import '../cart/cart.dart';
import '../../core/theme.dart';
import '../../core/utils/prescription_uploader.dart';
import '../../core/constants/app_strings.dart';
import '../category/category_detail.dart';
import '../medicine/medicine_detail.dart';

class Search extends StatefulWidget {
  final VoidCallback? onBack;
  const Search({super.key, this.onBack});

  @override
  State<Search> createState() => _SearchState();
}

class _SearchState extends State<Search> {
  final TextEditingController _searchController = TextEditingController();
  bool _filterColdChain = false;
  int _itemCount = 1;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final query = _searchController.text.trim();

    return Scaffold(
      backgroundColor: const Color(0xFFF7FCFC),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: BackButton(
          color: AppTheme.text,
          onPressed: widget.onBack ?? () => Navigator.pop(context),
        ),
        title: Container(
          height: 44,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(30),
            border: Border.all(color: Colors.teal.shade100),
          ),
          child: TextField(
            controller: _searchController,
            onChanged: (val) => setState(() {}),
            decoration: InputDecoration(
              hintText: AppStrings.searchHint,
              prefixIcon: const Icon(
                Icons.search,
                color: AppTheme.primary,
                size: 20,
              ),
              suffixIcon: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (_searchController.text.isNotEmpty)
                    IconButton(
                      icon: const Icon(
                        Icons.close,
                        size: 18,
                        color: Colors.grey,
                      ),
                      onPressed: () =>
                          setState(() => _searchController.clear()),
                    ),
                ],
              ),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(vertical: 10),
            ),
          ),
        ),
        actions: [
          Consumer<CartNotifier>(
            builder: (context, cart, child) => Stack(
              children: [
                IconButton(
                  icon: const Icon(
                    Icons.shopping_cart_outlined,
                    color: AppTheme.primary,
                  ),
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute<void>(builder: (_) => const Cart()),
                  ),
                ),
                if (cart.totalCount > 0)
                  Positioned(
                    right: 6,
                    top: 6,
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: const BoxDecoration(
                        color: Colors.red,
                        shape: BoxShape.circle,
                      ),
                      child: Text(
                        '${cart.totalCount}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
      body: _buildBody(query),
    );
  }

  // ── View routing ──────────────────────────────────────────────────────────

  Widget _buildBody(String query) {
    if (query.toLowerCase() == 'pirfenidone 800mg') {
      return _buildNotFoundView();
    } else if (query.toLowerCase() == 'diabetes care' ||
        query.toLowerCase() == 'metformin') {
      return _filterColdChain
          ? _buildNoFilterMatchView()
          : _buildSearchResultsView();
    }
    return _buildBrowseCategoriesView();
  }

  // ── Browse categories ─────────────────────────────────────────────────────

  Widget _buildBrowseCategoriesView() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.shield_outlined, color: AppTheme.primary, size: 18),
              SizedBox(width: 8),
              Text(
                'Browse by Health Concern',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: AppTheme.text,
                ),
              ),
            ],
          ),
          const Padding(
            padding: EdgeInsets.only(left: 26.0, top: 2),
            child: Text(
              'Find certified prescription & OTC medicines',
              style: TextStyle(color: Colors.grey, fontSize: 12),
            ),
          ),
          const SizedBox(height: 16),
          GestureDetector(
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => const CategoryDetail(
                  categoryName: 'Diabetes Care & Management',
                ),
              ),
            ),
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.teal.shade50.withValues(alpha: 0.6),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.teal.shade100),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.teal.shade100,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.water_drop,
                          color: AppTheme.primary,
                        ),
                      ),
                      const SizedBox(width: 12),
                      const Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Diabetes Care',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: AppTheme.text,
                              ),
                            ),
                            Text(
                              'Insulin, Metformin, strips & monitors',
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Icon(
                        Icons.arrow_forward_ios,
                        size: 16,
                        color: Colors.grey,
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      _chip('Metformin 500mg'),
                      const SizedBox(width: 6),
                      _chip('Glimepiride'),
                      const SizedBox(width: 6),
                      _chip('Vildagliptin'),
                      const Spacer(),
                      const Text(
                        '140+ Items',
                        style: TextStyle(
                          color: AppTheme.primary,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 8),
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            childAspectRatio: 0.95,
            children: [
              _buildCategoryCard(
                'Heart & BP',
                'Statins, monitors & ACE',
                '120+ Items',
                Icons.favorite,
                Colors.red,
              ),
              _buildCategoryCard(
                'Fever & Pain',
                'Analgesics, sprays, gels',
                '85+ Items',
                Icons.healing,
                Colors.teal,
              ),
              _buildCategoryCard(
                'Stomach & Gut',
                'Antacids, probiotics & gas',
                '95+ Items',
                Icons.medication,
                Colors.cyan,
              ),
              _buildCategoryCard(
                'Skin & Hair',
                'Dermatology, lotions, scalp',
                '110+ Items',
                Icons.clean_hands,
                Colors.pink,
              ),
              _buildCategoryCard(
                'Respiratory & Cold',
                'Inhalers, syrups, anti-allergy',
                '70+ Items',
                Icons.air,
                Colors.teal,
              ),
              _buildCategoryCard(
                'Vitamins & Daily',
                'Vitamin D3, B12, Zinc, Iron',
                '160+ Items',
                Icons.show_chart,
                Colors.teal,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _chip(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        text,
        style: const TextStyle(fontSize: 10, color: Colors.black87),
      ),
    );
  }

  Widget _buildCategoryCard(
    String title,
    String subtitle,
    String count,
    IconData icon,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, color: color, size: 20),
              ),
              Text(
                count,
                style: const TextStyle(
                  color: AppTheme.primary,
                  fontWeight: FontWeight.bold,
                  fontSize: 11,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 14,
              color: AppTheme.text,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: const TextStyle(color: Colors.grey, fontSize: 11),
            maxLines: 2,
          ),
        ],
      ),
    );
  }

  // ── Search results ────────────────────────────────────────────────────────

  Widget _buildSearchResultsView() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Showing 48 medicines for',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: AppTheme.text,
                      ),
                    ),
                    Text(
                      'Diabetes Care',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: AppTheme.text,
                      ),
                    ),
                    Text(
                      'Verified authentic supplies from certified pharmacies',
                      style: TextStyle(color: Colors.grey, fontSize: 11),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              OutlinedButton.icon(
                onPressed: () =>
                    setState(() => _filterColdChain = !_filterColdChain),
                icon: const Icon(
                  Icons.filter_list,
                  size: 16,
                  color: AppTheme.primary,
                ),
                label: const Text(
                  'Filters',
                  style: TextStyle(color: AppTheme.primary, fontSize: 12),
                ),
                style: OutlinedButton.styleFrom(
                  side: BorderSide(color: Colors.teal.shade200),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildMedicineCard(
            medicineIndex: 1,
            name: 'Glycomet 500mg SR T...',
            desc: '10 Tablets • USV Ltd\nContains Metformin (500mg)',
            price: '₹24.50',
            mrp: '₹28.00',
            discount: '12% OFF',
            badge: 'Req Required',
            isCounter: true,
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) =>
                    MedicineDetail(medicine: mockMedicines[1]),
              ),
            ),
          ),
          const SizedBox(height: 12),
          _buildMedicineCard(
            medicineIndex: 2,
            name: 'Januvia 100mg Tablet',
            desc: '7 Tablets • MSD\nSitagliptin phosphate oral formulation',
            price: '₹310.00',
            mrp: '₹345.00',
            discount: '10% OFF',
            badge: 'Req Required',
            footer: 'Standard delivery by tomorrow',
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) =>
                    MedicineDetail(medicine: mockMedicines[2]),
              ),
            ),
          ),
          const SizedBox(height: 12),
          _buildMedicineCard(
            medicineIndex: 3,
            name: 'Accu-Chek Active Test...',
            desc: '50 Strips • Roche\nBlood glucose self-monitoring strips',
            price: '₹925.00',
            mrp: '₹1050.00',
            discount: '12% OFF',
            badge: 'OTC - No Rx needed',
            footer: '⚡ In Stock - 22 min delivery',
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) =>
                    MedicineDetail(medicine: mockMedicines[3]),
              ),
            ),
          ),
          const SizedBox(height: 12),
          _buildMedicineCard(
            medicineIndex: 4,
            name: 'Glucerna Diabetes Car...',
            desc:
                'Vanilla 400g • Abbott Nutrition\nSlow-release carbohydrate blend',
            price: '₹680.00',
            mrp: '₹750.00',
            discount: '9% OFF',
            badge: 'OTC',
            footer: 'Only 3 units left',
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) =>
                    MedicineDetail(medicine: mockMedicines[4]),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMedicineCard({
    required int medicineIndex,
    required String name,
    required String desc,
    required String price,
    required String mrp,
    required String discount,
    required String badge,
    bool isCounter = false,
    String? footer,
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 70,
                  height: 70,
                  decoration: BoxDecoration(
                    color: Colors.teal.shade50,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.medication,
                    color: AppTheme.primary,
                    size: 36,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.red.shade50,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          badge,
                          style: TextStyle(
                            fontSize: 10,
                            color: Colors.red.shade700,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        name,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                          color: AppTheme.text,
                        ),
                      ),
                      Text(
                        desc,
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Text(
                      price,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: AppTheme.text,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      mrp,
                      style: const TextStyle(
                        decoration: TextDecoration.lineThrough,
                        color: Colors.grey,
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      discount,
                      style: const TextStyle(
                        color: Colors.green,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
                if (isCounter)
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.teal.shade50,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      children: [
                        IconButton(
                          icon: const Icon(
                            Icons.remove,
                            size: 16,
                            color: AppTheme.primary,
                          ),
                          onPressed: () {
                            if (_itemCount > 0) setState(() => _itemCount--);
                          },
                        ),
                        Text(
                          '$_itemCount',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: AppTheme.primary,
                          ),
                        ),
                        IconButton(
                          icon: const Icon(
                            Icons.add,
                            size: 16,
                            color: AppTheme.primary,
                          ),
                          onPressed: () {
                            if (_itemCount < 10) setState(() => _itemCount++);
                          },
                        ),
                      ],
                    ),
                  )
                else
                  ElevatedButton(
                    onPressed: () => context.read<CartNotifier>().add(
                      CartItem(
                        id: 'search_$name',
                        name: name,
                        pack: desc.split('\n').first,
                        price: double.parse(price.replaceAll('₹', '')),
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.teal.shade50,
                      foregroundColor: AppTheme.primary,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      minimumSize: const Size(80, 36),
                    ),
                    child: const Text(
                      '+ Add',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
              ],
            ),
            if (footer != null) ...[
              const SizedBox(height: 6),
              Text(
                footer,
                style: const TextStyle(fontSize: 11, color: Colors.grey),
              ),
            ],
          ],
        ),
      ), // Container
    ); // GestureDetector
  }

  // ── Not found ─────────────────────────────────────────────────────────────

  Widget _buildNotFoundView() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 16),
          Stack(
            alignment: Alignment.topRight,
            children: [
              Container(
                width: 70,
                height: 70,
                decoration: BoxDecoration(
                  color: Colors.teal.shade50,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.manage_search,
                  size: 36,
                  color: AppTheme.primary,
                ),
              ),
              Container(
                padding: const EdgeInsets.all(4),
                decoration: const BoxDecoration(
                  color: Colors.red,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.priority_high,
                  color: Colors.white,
                  size: 12,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Text(
            'Medicine Not Found in Local\nInventory',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
              color: AppTheme.text,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'We couldn\'t find an exact match for "Pirfenidone 800mg" across our 20 dark-store pharmacy clusters.',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.grey, fontSize: 12),
          ),
          const SizedBox(height: 24),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.teal.shade50.withValues(alpha: 0.5),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.teal.shade100),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Upload Prescription & Pharmacist Will Source It',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    color: AppTheme.text,
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  'Our platform pharmacist team will locate this exact molecule or an authorized bio-equivalent substitute directly from central state hubs.',
                  style: TextStyle(color: Colors.black54, fontSize: 11),
                ),
                const SizedBox(height: 12),
                ElevatedButton.icon(
                  onPressed: () => pickPrescription(context),
                  icon: const Icon(Icons.camera_alt_outlined, size: 16),
                  label: const Text('Upload Prescription Now'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primary,
                    minimumSize: const Size(double.infinity, 40),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Available Therapeutic Alternatives',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                  color: AppTheme.text,
                ),
              ),
              Text(
                'View All (4) >',
                style: TextStyle(
                  color: AppTheme.primary,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          _buildAlternativeCard(
            'Pirfenex 200mg',
            'Cipla Ltd • 10 Capsules (Pirfenidone)',
            '₹420.00',
            '₹480',
            'In Stock',
          ),
          const SizedBox(height: 12),
          _buildAlternativeCard(
            'Nintedanib 100mg',
            'Boehringer Ingelheim • 10 Softgels',
            '₹1,250.00',
            '',
            'Same Salt Group',
            isDetails: true,
          ),
        ],
      ),
    );
  }

  // ── No filter match ───────────────────────────────────────────────────────

  Widget _buildNoFilterMatchView() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Row(
            children: [
              FilterChip(
                label: const Text('Filters 3'),
                selected: true,
                onSelected: (_) {},
                backgroundColor: Colors.teal.shade50,
              ),
              const SizedBox(width: 8),
              FilterChip(
                label: const Text('Cold-Chain (2°C-8°C) ✕'),
                selected: true,
                onSelected: (_) => setState(() => _filterColdChain = false),
                backgroundColor: AppTheme.primary,
                labelStyle: const TextStyle(color: Colors.white),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Column(
              children: [
                Icon(Icons.filter_alt_off, size: 48, color: AppTheme.primary),
                SizedBox(height: 12),
                Text(
                  'No Medicines Match These Exact Filters',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: AppTheme.text,
                  ),
                ),
                SizedBox(height: 6),
                Text(
                  'We found 0 matches for "Diabetes Care"',
                  style: TextStyle(color: Colors.grey, fontSize: 12),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          const Row(
            children: [
              Text(
                'Popular in Diabetes Care',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: AppTheme.text,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          _buildAlternativeCard(
            'Glycomet 500mg SR',
            'Metformin Hydrochloride • Tablet',
            '₹20.50',
            '₹24.00',
            'STRIP 10',
          ),
          const SizedBox(height: 12),
          _buildAlternativeCard(
            'Lantus Solostar 100IU/ml',
            'Insulin Glargine • Sanofi',
            '₹648.50',
            '₹720.00',
            '3ML PEN',
          ),
        ],
      ),
    );
  }

  // ── Shared card ───────────────────────────────────────────────────────────

  Widget _buildAlternativeCard(
    String name,
    String desc,
    String price,
    String mrp,
    String tag, {
    bool isDetails = false,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: Colors.teal.shade50,
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(Icons.medication, color: AppTheme.primary),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Flexible(
                      child: Text(
                        name,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                          color: AppTheme.text,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 4,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        tag,
                        style: const TextStyle(fontSize: 9, color: Colors.grey),
                      ),
                    ),
                  ],
                ),
                Text(
                  desc,
                  style: const TextStyle(color: Colors.grey, fontSize: 11),
                ),
                const SizedBox(height: 6),
                Text(
                  price,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    color: AppTheme.text,
                  ),
                ),
              ],
            ),
          ),
          if (isDetails)
            OutlinedButton(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const MedicineDetail()),
              ),
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: AppTheme.primary),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text(
                'View Details >',
                style: TextStyle(color: AppTheme.primary, fontSize: 11),
              ),
            )
          else
            ElevatedButton(
              onPressed: () => context.read<CartNotifier>().add(
                CartItem(
                  id: 'suggestion_$name',
                  name: name,
                  pack: tag,
                  price: double.parse(price.replaceAll('₹', '')),
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primary,
                minimumSize: const Size(80, 36),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text('Add to Cart', style: TextStyle(fontSize: 11)),
            ),
        ],
      ),
    );
  }
}
