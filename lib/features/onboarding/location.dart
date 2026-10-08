import 'package:flutter/material.dart';

import '../../core/theme.dart';
import '../home/main_nav_wrapper.dart';

class Location extends StatefulWidget {
  final String name;
  const Location({super.key, required this.name});

  @override
  State<Location> createState() => _LocationState();
}

class _LocationState extends State<Location> {
  final TextEditingController _pincodeController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _landmarkController = TextEditingController();
  String? _selectedCity;
  bool _isDetecting = false;

  static const List<String> _cities = [
    'Delhi', 'Mumbai', 'Bangalore', 'Hyderabad',
    'Chennai', 'Kolkata', 'Pune', 'Ahmedabad',
    'Jaipur', 'Lucknow', 'Noida', 'Gurugram',
  ];

  @override
  void dispose() {
    _pincodeController.dispose();
    _addressController.dispose();
    _landmarkController.dispose();
    super.dispose();
  }

  Future<void> _detectLocation() async {
    setState(() => _isDetecting = true);
    // ponytail: replace with geolocator + geocoding when location API is integrated
    await Future.delayed(const Duration(seconds: 1));
    if (!mounted) return;
    setState(() {
      _isDetecting = false;
      _pincodeController.text = '201301';
      _addressController.text = 'Sector 62, Indirapuram';
      _selectedCity = 'Noida';
    });
  }

  void _continue() {
    if (_addressController.text.trim().isEmpty || _selectedCity == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Please enter your delivery address'),
          backgroundColor: AppTheme.error,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
      );
      return;
    }
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => MainNavWrapper(name: widget.name, location: '${_addressController.text.trim()}, ${_selectedCity!}')),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(),
        title: const Text('Delivery Location'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Header ───────────────────────────────────────────────────
              Text('Where should we\ndeliver?',
                  style: Theme.of(context).textTheme.displaySmall),
              const SizedBox(height: 8),

              // ── Auto-detect button ───────────────────────────────────────
              _DetectLocationButton(isDetecting: _isDetecting, onTap: _detectLocation),
              const SizedBox(height: 24),

              // ── Divider ──────────────────────────────────────────────────
              Row(children: [
                const Expanded(child: Divider()),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Text('or enter manually',
                      style: Theme.of(context).textTheme.labelMedium),
                ),
                const Expanded(child: Divider()),
              ]),
              const SizedBox(height: 24),

              // ── Pincode ──────────────────────────────────────────────────
              _label(context, 'Pincode *'),
              TextField(
                controller: _pincodeController,
                keyboardType: TextInputType.number,
                maxLength: 6,
                decoration: const InputDecoration(
                  hintText: '6-digit pincode',
                  prefixIcon: Icon(Icons.pin_drop_outlined),
                  counterText: '',
                ),
              ),
              const SizedBox(height: 16),

              // ── City ─────────────────────────────────────────────────────
              _label(context, 'City *'),
              DropdownButtonFormField<String>(
                initialValue: _selectedCity,
                hint: const Text('Select city'),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: AppTheme.outlineBorder),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: AppTheme.outlineBorder),
                  ),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                ),
                items: _cities
                    .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                    .toList(),
                onChanged: (v) => setState(() => _selectedCity = v),
              ),
              const SizedBox(height: 16),

              // ── Address ──────────────────────────────────────────────────
              _label(context, 'Flat / House / Street *'),
              TextField(
                controller: _addressController,
                maxLines: 2,
                decoration: const InputDecoration(
                  hintText: 'Enter flat no., building, street name',
                  prefixIcon: Padding(
                    padding: EdgeInsets.only(bottom: 20),
                    child: Icon(Icons.home_outlined),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // ── Landmark ─────────────────────────────────────────────────
              _label(context, 'Landmark (Optional)'),
              TextField(
                controller: _landmarkController,
                decoration: const InputDecoration(
                  hintText: 'Near school, park, metro station…',
                  prefixIcon: Icon(Icons.place_outlined),
                ),
              ),
              const SizedBox(height: 32),

              ElevatedButton(
                onPressed: _continue,
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Save & Continue'),
                    SizedBox(width: 8),
                    Icon(Icons.arrow_forward, size: 18),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _label(BuildContext context, String text) => Padding(
        padding: const EdgeInsets.only(bottom: 8),
        child: Text(text, style: Theme.of(context).textTheme.titleSmall),
      );
}

// ── Detect location button ────────────────────────────────────────────────────

class _DetectLocationButton extends StatelessWidget {
  final bool isDetecting;
  final VoidCallback onTap;
  const _DetectLocationButton({required this.isDetecting, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: isDetecting ? null : onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppTheme.primaryContainer,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppTheme.primary.withValues(alpha: 0.4)),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: AppTheme.primary,
                borderRadius: BorderRadius.circular(10),
              ),
              child: isDetecting
                  ? const SizedBox(
                      width: 20, height: 20,
                      child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                    )
                  : const Icon(Icons.my_location, color: Colors.white, size: 20),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(isDetecting ? 'Detecting location…' : 'Use Current Location',
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: AppTheme.text)),
                  Text(isDetecting ? 'Please wait' : 'Auto-fill address using GPS',
                      style: const TextStyle(fontSize: 12, color: AppTheme.mutedText)),
                ],
              ),
            ),
            if (!isDetecting)
              const Icon(Icons.arrow_forward_ios, size: 14, color: AppTheme.mutedText),
          ],
        ),
      ),
    );
  }
}
