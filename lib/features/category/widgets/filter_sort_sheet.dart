import 'package:flutter/material.dart';

import '../../../core/theme.dart';

// ── Data ──────────────────────────────────────────────────────────────────────

class _SortOption {
  final String label;
  final IconData? icon;
  const _SortOption(this.label, {this.icon});
}

class _TherapeuticClass {
  final String name;
  final String subtitle;
  final String count;
  _TherapeuticClass(this.name, this.subtitle, this.count);
}

// ── Sheet ─────────────────────────────────────────────────────────────────────

class FilterSortSheet extends StatefulWidget {
  final int totalItems;
  final String categoryName;

  const FilterSortSheet({
    super.key,
    required this.totalItems,
    required this.categoryName,
  });

  @override
  State<FilterSortSheet> createState() => _FilterSortSheetState();
}

class _FilterSortSheetState extends State<FilterSortSheet> {
  // ── State ──────────────────────────────────────────────────────────────────
  int _selectedSort = 0;
  int _selectedRx = 1;
  final Set<int> _selectedClasses = {0, 1, 4};
  // ── Lifted from _DosageFormFilter / _DispatchFilter ───────────────────────
  final Set<int> _selectedDosageForms = {0, 1};
  int _selectedDispatch = 0;

  static const List<_SortOption> _sortOptions = [
    _SortOption('Popularity'),
    _SortOption('Fastest Delivery (<15m)', icon: Icons.bolt),
    _SortOption('Price: Low to High', icon: Icons.arrow_upward),
    _SortOption('Highest Discount', icon: Icons.percent),
  ];

  final List<_TherapeuticClass> _classes = [
    _TherapeuticClass('Biguanides', 'Metformin HCl', '14 meds'),
    _TherapeuticClass('Basal & Fast-acting Insulins', 'Glargine, Aspart', '11 meds'),
    _TherapeuticClass('DPP-4 Inhibitors', 'Januvia, Galvus', '8 meds'),
    _TherapeuticClass('SGLT2 Inhibitors', 'Forxiga, Jardiance', '6 meds'),
    _TherapeuticClass('CGM Monitors & Test Strips', '', '9 devices'),
  ];

  int get _appliedCount =>
      _selectedClasses.length +
      (_selectedRx != 0 ? 1 : 0) +
      (_selectedDosageForms.isNotEmpty ? 1 : 0) +
      (_selectedDispatch != 0 ? 1 : 0);

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.9,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      expand: false,
      builder: (context, scrollController) => Column(
        children: [
          _SheetHandle(),
          _SheetHeader(
            totalItems: widget.totalItems,
            categoryName: widget.categoryName,
            onReset: () => setState(() {
              _selectedSort = 0;
              _selectedRx = 0;
              _selectedClasses.clear();
              _selectedDosageForms.clear();
              _selectedDispatch = 0;
            }),
            onClose: () => Navigator.pop(context),
          ),
          Expanded(
            child: ListView(
              controller: scrollController,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              children: [
                _sectionLabel('Sort By', trailing: '${_selectedSort == 0 ? 0 : 1} applied'),
                const SizedBox(height: 10),
                _SortGrid(
                  options: _sortOptions,
                  selected: _selectedSort,
                  onSelect: (i) => setState(() => _selectedSort = i),
                ),
                const SizedBox(height: 20),
                _sectionLabel('Prescription Type (Schedule)', trailing: 'GxP Verified', trailingIcon: Icons.verified),
                const SizedBox(height: 10),
                _RxFilter(selected: _selectedRx, onSelect: (i) => setState(() => _selectedRx = i)),
                const SizedBox(height: 20),
                _sectionLabel('Therapeutic Class / Drug Action', trailing: '5 Classes'),
                const SizedBox(height: 10),
                ..._classes.asMap().entries.map((e) => _ClassTile(
                      item: e.value,
                      selected: _selectedClasses.contains(e.key),
                      onToggle: () => setState(() {
                        if (_selectedClasses.contains(e.key)) {
                          _selectedClasses.remove(e.key);
                        } else {
                          _selectedClasses.add(e.key);
                        }
                      }),
                    )),
                const SizedBox(height: 20),
                _sectionLabel('Dosage Form'),
                const SizedBox(height: 10),
                _DosageFormFilter(
                  selected: _selectedDosageForms,
                  onToggle: (i) => setState(() {
                    if (_selectedDosageForms.contains(i)) { _selectedDosageForms.remove(i); } else { _selectedDosageForms.add(i); }
                  }),
                ),
                const SizedBox(height: 20),
                _sectionLabel('Fulfilment & Dispatch Speed', trailing: 'Priority'),
                const SizedBox(height: 10),
                _DispatchFilter(selected: _selectedDispatch, onSelect: (i) => setState(() => _selectedDispatch = i)),
                const SizedBox(height: 80),
              ],
            ),
          ),
          _BottomBar(
            appliedCount: _appliedCount,
            onClear: () => setState(() {
              _selectedSort = 0;
              _selectedRx = 0;
              _selectedClasses.clear();
              _selectedDosageForms.clear();
              _selectedDispatch = 0;
            }),
            onApply: () => Navigator.pop(context, _appliedCount),
          ),
        ],
      ),
    );
  }

  Widget _sectionLabel(String text, {String? trailing, IconData? trailingIcon}) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Row(
          children: [
            const Icon(Icons.list_alt_outlined, size: 16, color: AppTheme.primary),
            const SizedBox(width: 6),
            Text(text, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: AppTheme.text)),
            const Spacer(),
            if (trailingIcon != null) Icon(trailingIcon, size: 14, color: AppTheme.primary),
            if (trailing != null)
              Text(trailing, style: const TextStyle(fontSize: 11, color: AppTheme.primary, fontWeight: FontWeight.w600)),
          ],
        ),
      );
}

// ── Sub-widgets ───────────────────────────────────────────────────────────────

class _SheetHandle extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(top: 10, bottom: 4),
        child: Center(
          child: Container(width: 40, height: 4, decoration: BoxDecoration(color: Colors.grey.shade300, borderRadius: BorderRadius.circular(2))),
        ),
      );
}

class _SheetHeader extends StatelessWidget {
  final int totalItems;
  final String categoryName;
  final VoidCallback onReset;
  final VoidCallback onClose;

  const _SheetHeader({required this.totalItems, required this.categoryName, required this.onReset, required this.onClose});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text('Filter & Sort', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: AppTheme.text)),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(color: AppTheme.primaryContainer, borderRadius: BorderRadius.circular(20)),
                child: Text('$totalItems items', style: const TextStyle(fontSize: 11, color: AppTheme.primary, fontWeight: FontWeight.w600)),
              ),
              const Spacer(),
              TextButton(onPressed: onReset, child: const Text('Reset All', style: TextStyle(color: AppTheme.primary))),
              IconButton(onPressed: onClose, icon: const Icon(Icons.close, size: 20)),
            ],
          ),
          Text('Category: $categoryName', style: const TextStyle(fontSize: 12, color: AppTheme.mutedText)),
        ],
      ),
    );
  }
}

class _SortGrid extends StatelessWidget {
  final List<_SortOption> options;
  final int selected;
  final ValueChanged<int> onSelect;

  const _SortGrid({required this.options, required this.selected, required this.onSelect});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: options.asMap().entries.map((e) {
        final isSelected = e.key == selected;
        return GestureDetector(
          onTap: () => onSelect(e.key),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeInOut,
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              color: isSelected ? AppTheme.primary : Colors.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: isSelected ? AppTheme.primary : AppTheme.outlineBorder),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(e.value.label, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: isSelected ? Colors.white : AppTheme.text)),
                if (e.value.icon != null) ...[
                  const SizedBox(width: 4),
                  Icon(e.value.icon, size: 14, color: isSelected ? Colors.white : AppTheme.primary),
                ],
                if (isSelected) ...[
                  const SizedBox(width: 4),
                  const Icon(Icons.check, size: 14, color: Colors.white),
                ],
              ],
            ),
          ),
        );
      }).toList(),
    );
  }
}

class _RxFilter extends StatelessWidget {
  final int selected;
  final ValueChanged<int> onSelect;

  const _RxFilter({required this.selected, required this.onSelect});

  static const List<String> _labels = ['All', 'Rx Required (Schedule H/H1)', 'OTC & Devices (No Rx)'];

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: _labels.asMap().entries.map((e) {
        final isSelected = e.key == selected;
        return GestureDetector(
          onTap: () => onSelect(e.key),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeInOut,
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              color: isSelected ? AppTheme.primary : Colors.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: isSelected ? AppTheme.primary : AppTheme.outlineBorder),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (e.key == 1) Text('Rx ', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: isSelected ? Colors.white : AppTheme.primary)),
                Text(e.key == 1 ? 'Rx Required (Schedule H/H1)' : e.value,
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: isSelected ? Colors.white : AppTheme.text)),
                if (isSelected) ...[const SizedBox(width: 4), const Icon(Icons.check, size: 14, color: Colors.white)],
              ],
            ),
          ),
        );
      }).toList(),
    );
  }
}

class _ClassTile extends StatelessWidget {
  final _TherapeuticClass item;
  final bool selected;
  final VoidCallback onToggle;

  const _ClassTile({required this.item, required this.selected, required this.onToggle});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onToggle,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Row(
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeInOut,
              width: 22,
              height: 22,
              decoration: BoxDecoration(
                color: selected ? AppTheme.primary : Colors.white,
                borderRadius: BorderRadius.circular(4),
                border: Border.all(color: selected ? AppTheme.primary : AppTheme.outlineBorder, width: 2),
              ),
              child: selected ? const Icon(Icons.check, size: 14, color: Colors.white) : null,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: RichText(
                text: TextSpan(
                  text: item.name,
                  style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13, color: AppTheme.text),
                  children: item.subtitle.isNotEmpty
                      ? [TextSpan(text: '  (${item.subtitle})', style: const TextStyle(fontWeight: FontWeight.normal, color: AppTheme.mutedText, fontSize: 12))]
                      : [],
                ),
              ),
            ),
            Text(item.count, style: const TextStyle(fontSize: 12, color: AppTheme.mutedText)),
          ],
        ),
      ),
    );
  }
}

class _BottomBar extends StatelessWidget {
  final int appliedCount;
  final VoidCallback onClear;
  final VoidCallback onApply;

  const _BottomBar({required this.appliedCount, required this.onClear, required this.onApply});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 28),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: AppTheme.outlineBorder)),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: OutlinedButton(
              onPressed: onClear,
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: AppTheme.outlineBorder),
                minimumSize: const Size(0, 48),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: const Text('Clear', style: TextStyle(color: AppTheme.text)),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            flex: 5,
            child: ElevatedButton(
              onPressed: onApply,
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(0, 48),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Flexible(
                    child: Text(
                      'Apply Filters ($appliedCount Medicines)',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(width: 6),
                  const Icon(Icons.arrow_forward, size: 16),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Dosage Form ───────────────────────────────────────────────────────────────

class _DosageFormFilter extends StatefulWidget {
  final Set<int> selected;
  final ValueChanged<int> onToggle;
  const _DosageFormFilter({required this.selected, required this.onToggle});
  @override
  State<_DosageFormFilter> createState() => _DosageFormFilterState();
}

class _DosageFormFilterState extends State<_DosageFormFilter> {
  static const List<String> _forms = [
    'Tablets & Capsules',
    'Pre-filled Injection Pens',
    'Cartridges / Vials',
    'Syrups / Solutions',
  ];

  // Pre-select first two to match the screenshot

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: _forms.asMap().entries.map((e) {
        final isSelected = widget.selected.contains(e.key);
        return GestureDetector(
          onTap: () => widget.onToggle(e.key),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              color: isSelected ? AppTheme.primary : Colors.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                  color: isSelected ? AppTheme.primary : AppTheme.outlineBorder),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(e.value,
                    style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: isSelected ? Colors.white : AppTheme.text)),
                if (isSelected) ...[
                  const SizedBox(width: 4),
                  const Icon(Icons.check, size: 14, color: Colors.white),
                ],
              ],
            ),
          ),
        );
      }).toList(),
    );
  }
}

// ── Fulfilment & Dispatch Speed ───────────────────────────────────────────────

class _DispatchFilter extends StatefulWidget {
  final int selected;
  final ValueChanged<int> onSelect;
  const _DispatchFilter({required this.selected, required this.onSelect});
  @override
  State<_DispatchFilter> createState() => _DispatchFilterState();
}

class _DispatchFilterState extends State<_DispatchFilter> {

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(child: _option(0, Icons.bolt, 'Express 15–25m', 'Instant hub dispatch')),
        const SizedBox(width: 12),
        Expanded(child: _option(1, Icons.access_time_outlined, 'Standard Today', 'Free delivery by 7 PM')),
      ],
    );
  }

  Widget _option(int index, IconData icon, String title, String subtitle) {
    final isSelected = widget.selected == index;
    return GestureDetector(
      onTap: () => widget.onSelect(index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isSelected ? AppTheme.primaryContainer : Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
              color: isSelected ? AppTheme.primary : AppTheme.outlineBorder,
              width: isSelected ? 1.5 : 1),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon,
                    size: 16,
                    color: isSelected ? AppTheme.primary : AppTheme.mutedText),
                const Spacer(),
                if (isSelected)
                  Container(
                    width: 18,
                    height: 18,
                    decoration: const BoxDecoration(
                        color: AppTheme.primary, shape: BoxShape.circle),
                    child: const Icon(Icons.check, size: 12, color: Colors.white),
                  ),
              ],
            ),
            const SizedBox(height: 6),
            Text(title,
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                    color: isSelected ? AppTheme.primary : AppTheme.text)),
            const SizedBox(height: 2),
            Text(subtitle,
                style: const TextStyle(
                    fontSize: 10, color: AppTheme.mutedText)),
          ],
        ),
      ),
    );
  }
}
