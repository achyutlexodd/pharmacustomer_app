import 'package:flutter/material.dart';

import '../../core/theme.dart';
import 'delivery_options.dart';

class Address extends StatefulWidget {
  const Address({super.key});

  @override
  State<Address> createState() => _AddressState();
}

class _AddressState extends State<Address> {
  static const _initialAddresses = [
    (
      label: 'Home',
      details: 'Flat 402, Green Glen Layout, Bellandur, Bengaluru 560103',
      eta: '22 Mins Express',
    ),
    (
      label: 'Work / Office',
      details:
          'Tower 4, Ecospace Business Park, Outer Ring Rd, Bellandur, Bengaluru 560103',
      eta: 'Standard 45 Mins',
    ),
    (
      label: 'Parents’ Home',
      details: '12th Main, Indiranagar, Bengaluru 560038',
      eta: 'Next-day Morning Slot',
    ),
  ];

  final _addresses = [..._initialAddresses];
  int _selected = 0;
  bool _currentLocation = false;

  String get _selectedLabel =>
      _currentLocation ? 'Current Location' : _addresses[_selected].label;

  String get _selectedEta =>
      _currentLocation ? '22 Mins' : _addresses[_selected].eta;

  Future<void> _editAddress([int? index]) async {
    final result = await showDialog<(String, String)>(
      context: context,
      builder: (_) => _AddressEditorDialog(
        initialLabel: index == null ? '' : _addresses[index].label,
        initialDetails: index == null ? '' : _addresses[index].details,
      ),
    );
    if (!mounted || result == null || result.$1.isEmpty || result.$2.isEmpty) {
      return;
    }
    setState(() {
      final address = (
        label: result.$1,
        details: result.$2,
        eta: 'Standard 45 Mins',
      );
      if (index == null) {
        _addresses.add(address);
        _selected = _addresses.length - 1;
      } else {
        _addresses[index] = address;
        _selected = index;
      }
      _currentLocation = false;
    });
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: const Color(0xFFF0FAFD),
    appBar: AppBar(
      centerTitle: true,
      backgroundColor: Colors.white,
      leading: const BackButton(),
      title: const Text('Select Delivery Address'),
      actions: [
        TextButton.icon(
          onPressed: () => _editAddress(),
          icon: const Icon(Icons.add, size: 20),
          label: const Text('Add new'),
        ),
      ],
    ),
    body: ListView(
      padding: const EdgeInsets.fromLTRB(18, 20, 18, 16),
      children: [
        _CurrentLocationCard(
          selected: _currentLocation,
          onLocate: () => setState(() => _currentLocation = true),
        ),
        const Padding(
          padding: EdgeInsets.fromLTRB(2, 24, 2, 12),
          child: Text(
            'SAVED ADDRESSES',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              letterSpacing: 1,
              color: AppTheme.mutedText,
            ),
          ),
        ),
        ..._addresses.asMap().entries.map((entry) {
          final index = entry.key;
          final address = entry.value;
          return Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: _AddressCard(
              label: address.label,
              details: address.details,
              eta: address.eta,
              selected: !_currentLocation && _selected == index,
              isDefault: index == 0,
              onTap: () => setState(() {
                _selected = index;
                _currentLocation = false;
              }),
              onEdit: () => _editAddress(index),
            ),
          );
        }),
      ],
    ),
    bottomNavigationBar: SafeArea(
      minimum: const EdgeInsets.fromLTRB(18, 8, 18, 16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              const Icon(Icons.location_on, size: 18, color: AppTheme.primary),
              const SizedBox(width: 7),
              Expanded(
                child: Text(
                  'Delivering to: $_selectedLabel',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
              ),
              const Icon(Icons.bolt, size: 17, color: Colors.orange),
              Text(
                ' $_selectedEta',
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
            ],
          ),
          const SizedBox(height: 10),
          SizedBox(
            width: double.infinity,
            height: 58,
            child: ElevatedButton(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute<void>(
                  builder: (_) => const DeliveryOptions(),
                ),
              ),
              child: const Text('Deliver to this Address  →'),
            ),
          ),
        ],
      ),
    ),
  );
}

class _AddressEditorDialog extends StatefulWidget {
  const _AddressEditorDialog({
    required this.initialLabel,
    required this.initialDetails,
  });

  final String initialLabel;
  final String initialDetails;

  @override
  State<_AddressEditorDialog> createState() => _AddressEditorDialogState();
}

class _AddressEditorDialogState extends State<_AddressEditorDialog> {
  late final _label = TextEditingController(text: widget.initialLabel);
  late final _details = TextEditingController(text: widget.initialDetails);

  void _close([(String, String)? result]) {
    FocusScope.of(context).unfocus();
    Navigator.pop(context, result);
  }

  @override
  void dispose() {
    _label.dispose();
    _details.dispose();
    super.dispose();
  }

  InputDecoration _fieldDecoration(String label, IconData icon) =>
      InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, size: 20),
        filled: true,
        fillColor: const Color(0xFFF5FAFB),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 14,
          vertical: 16,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: const BorderSide(color: Color(0xFFD7E8EC)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: const BorderSide(color: Color(0xFFD7E8EC)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: const BorderSide(color: AppTheme.primary, width: 1.5),
        ),
      );

  @override
  Widget build(BuildContext context) => Dialog(
    backgroundColor: Colors.white,
    insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
    child: ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 440),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(22, 20, 22, 18),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 42,
                    height: 42,
                    decoration: BoxDecoration(
                      color: const Color(0xFFE4F7FA),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: const Icon(
                      Icons.location_on_outlined,
                      color: AppTheme.primary,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      widget.initialLabel.isEmpty
                          ? 'Add new address'
                          : 'Edit address',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: AppTheme.text,
                      ),
                    ),
                  ),
                  IconButton(
                    tooltip: 'Close',
                    onPressed: _close,
                    icon: const Icon(
                      Icons.close,
                      color: AppTheme.textSecondary,
                    ),
                  ),
                ],
              ),
              const Padding(
                padding: EdgeInsets.only(left: 54, bottom: 20),
                child: Text(
                  'Choose a name and enter the complete delivery address.',
                  style: TextStyle(
                    fontSize: 13,
                    color: AppTheme.textSecondary,
                    height: 1.4,
                  ),
                ),
              ),
              TextField(
                controller: _label,
                textCapitalization: TextCapitalization.words,
                decoration: _fieldDecoration(
                  'Address name',
                  Icons.bookmark_outline,
                ),
              ),
              const SizedBox(height: 14),
              TextField(
                controller: _details,
                textCapitalization: TextCapitalization.sentences,
                minLines: 2,
                maxLines: 3,
                decoration: _fieldDecoration(
                  'Full address',
                  Icons.home_outlined,
                ),
              ),
              const SizedBox(height: 22),
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: () =>
                      _close((_label.text.trim(), _details.text.trim())),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primary,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    elevation: 0,
                  ),
                  child: const Text(
                    'Save address',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                  ),
                ),
              ),
              Center(
                child: TextButton(
                  onPressed: _close,
                  child: const Text('Cancel'),
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}

class _CurrentLocationCard extends StatelessWidget {
  const _CurrentLocationCard({required this.selected, required this.onLocate});
  final bool selected;
  final VoidCallback onLocate;

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: const Color(0xFFE0F7FC),
      borderRadius: BorderRadius.circular(24),
      border: Border.all(color: const Color(0xFFCDE8EF)),
    ),
    child: Column(
      children: [
        Row(
          children: [
            const CircleAvatar(
              radius: 25,
              backgroundColor: AppTheme.primary,
              child: Icon(Icons.my_location, color: Colors.white),
            ),
            const SizedBox(width: 12),
            const Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Deliver to Current Location',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                  SizedBox(height: 3),
                  Text(
                    'Bellandur Outer Ring Road, near Central Mall',
                    style: TextStyle(
                      fontSize: 13,
                      color: AppTheme.textSecondary,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        SizedBox(
          width: double.infinity,
          height: 54,
          child: ElevatedButton.icon(
            onPressed: onLocate,
            icon: const Icon(Icons.near_me_outlined),
            label: Text(
              selected ? 'Current Location Selected' : 'Locate Me  ›',
            ),
          ),
        ),
      ],
    ),
  );
}

class _AddressCard extends StatelessWidget {
  const _AddressCard({
    required this.label,
    required this.details,
    required this.eta,
    required this.selected,
    required this.isDefault,
    required this.onTap,
    required this.onEdit,
  });

  final String label, details, eta;
  final bool selected, isDefault;
  final VoidCallback onTap, onEdit;

  @override
  Widget build(BuildContext context) => Material(
    color: Colors.white,
    borderRadius: BorderRadius.circular(22),
    child: InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(22),
      child: Container(
        padding: const EdgeInsets.fromLTRB(14, 12, 12, 16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(22),
          border: Border.all(
            color: selected ? AppTheme.primary : const Color(0xFFD5E8ED),
            width: selected ? 2 : 1.3,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  selected
                      ? Icons.radio_button_checked
                      : Icons.radio_button_off,
                  color: selected ? AppTheme.primary : AppTheme.mutedText,
                  size: 23,
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Text(
                    label,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                if (isDefault)
                  const Padding(
                    padding: EdgeInsets.only(right: 2),
                    child: Text(
                      'DEFAULT',
                      style: TextStyle(
                        fontSize: 9,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.primary,
                      ),
                    ),
                  ),
                IconButton(
                  tooltip: 'Edit $label address',
                  onPressed: onEdit,
                  icon: const Icon(
                    Icons.edit_outlined,
                    size: 19,
                    color: AppTheme.textSecondary,
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(left: 37),
              child: Text(
                details,
                style: const TextStyle(
                  color: AppTheme.textSecondary,
                  height: 1.45,
                ),
              ),
            ),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.only(left: 37),
              child: Row(
                children: [
                  Icon(
                    eta.contains('Express') ? Icons.bolt : Icons.schedule,
                    size: 16,
                    color: AppTheme.primary,
                  ),
                  const SizedBox(width: 5),
                  Text(
                    eta,
                    style: const TextStyle(
                      fontSize: 13,
                      color: AppTheme.primaryDark,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
