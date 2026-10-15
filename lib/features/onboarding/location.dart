import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

import '../../core/theme.dart';
import '../home/main_nav_wrapper.dart';

class Location extends StatefulWidget {
  final String name;
  final String phoneNumber;
  final String email;
  final String? profileImagePath;
  const Location({super.key, required this.name, this.phoneNumber = '', this.email = '', this.profileImagePath});

  @override
  State<Location> createState() => _LocationState();
}

class _LocationState extends State<Location> {
  final TextEditingController _pincodeController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _landmarkController = TextEditingController();
  String? _selectedCity;
  bool _isDetecting = false;

  Future<void> _selectCity() async {
    final city = await showModalBottomSheet<String>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _CityPicker(cities: _cities, selected: _selectedCity),
    );
    if (city != null) setState(() => _selectedCity = city);
  }

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
    try {
      if (!await Geolocator.isLocationServiceEnabled()) {
        throw Exception('Turn on Location Services and try again.');
      }
      var permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }
      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        throw Exception('Location permission is required to detect your location.');
      }
      final position = await Geolocator.getCurrentPosition();
      final places = await placemarkFromCoordinates(position.latitude, position.longitude);
      if (!mounted) return;
      final place = places.firstOrNull;
      final city = place?.locality ?? place?.subAdministrativeArea;
      setState(() {
        _pincodeController.text = place?.postalCode ?? '';
        _addressController.text = [place?.name, place?.subLocality, place?.thoroughfare]
            .whereType<String>().where((value) => value.isNotEmpty).join(', ');
        _selectedCity = city?.toLowerCase() == 'bengaluru'
            ? 'Bangalore'
            : _cities.where((value) => value.toLowerCase() == city?.toLowerCase()).firstOrNull;
      });
    } catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(error.toString().replaceFirst('Exception: ', ''))),
        );
      }
    } finally {
      if (mounted) setState(() => _isDetecting = false);
    }
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
      MaterialPageRoute(builder: (_) => MainNavWrapper(
        name: widget.name,
        phoneNumber: widget.phoneNumber,
        email: widget.email,
        location: '${_addressController.text.trim()}, ${_selectedCity!}',
        profileImagePath: widget.profileImagePath,
      )),
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
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          padding: const EdgeInsets.fromLTRB(22, 20, 22, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Where should we deliver?',
                  style: Theme.of(context).textTheme.headlineLarge?.copyWith(fontSize: 27, height: 1.16, letterSpacing: -0.7)),
              const SizedBox(height: 7),
              Text('Add an address for a smooth delivery.',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontSize: 14)),
              const SizedBox(height: 22),

              _DetectLocationButton(isDetecting: _isDetecting, onTap: _detectLocation),
              const SizedBox(height: 22),

              Row(children: [
                const Expanded(child: Divider()),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Text('or enter manually',
                      style: Theme.of(context).textTheme.labelMedium),
                ),
                const Expanded(child: Divider()),
              ]),
              const SizedBox(height: 20),

              _label(context, 'Pincode', required: true),
              TextField(
                controller: _pincodeController,
                keyboardType: TextInputType.number,
                maxLength: 6,
                decoration: const InputDecoration(
                  hintText: 'Enter 6-digit pincode',
                  prefixIcon: Icon(Icons.pin_drop_outlined),
                  counterText: '',
                  prefixIconColor: AppTheme.mutedText,
                ),
              ),
              const SizedBox(height: 18),

              _label(context, 'City', required: true),
              Semantics(
                button: true,
                label: 'City, ${_selectedCity ?? 'Select city'}',
                child: InkWell(
                  onTap: _selectCity,
                  borderRadius: BorderRadius.circular(14),
                  child: InputDecorator(
                    decoration: const InputDecoration(
                      prefixIcon: Icon(Icons.location_city_outlined),
                      prefixIconColor: AppTheme.mutedText,
                    ),
                    child: Row(children: [
                      Expanded(child: Text(_selectedCity ?? 'Select city', style: TextStyle(color: _selectedCity == null ? AppTheme.textDisabled : AppTheme.text))),
                      const Icon(Icons.keyboard_arrow_down_rounded, color: AppTheme.mutedText),
                    ]),
                  ),
                ),
              ),
              const SizedBox(height: 18),

              _label(context, 'Flat / house / street', required: true),
              TextField(
                controller: _addressController,
                decoration: const InputDecoration(
                  hintText: 'Enter flat no., building, street name',
                  prefixIcon: Icon(Icons.home_outlined),
                  prefixIconColor: AppTheme.mutedText,
                ),
              ),
              const SizedBox(height: 18),

              _label(context, 'Landmark', optional: true),
              TextField(
                controller: _landmarkController,
                decoration: const InputDecoration(
                  hintText: 'Near school, park, metro station…',
                  prefixIcon: Icon(Icons.place_outlined),
                  prefixIconColor: AppTheme.mutedText,
                ),
              ),
              const SizedBox(height: 26),

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

  Widget _label(BuildContext context, String text, {bool required = false, bool optional = false}) => Padding(
        padding: const EdgeInsets.only(bottom: 8),
        child: Row(children: [
          Text(text, style: Theme.of(context).textTheme.titleSmall?.copyWith(fontSize: 14, fontWeight: FontWeight.w700)),
          if (required) const Text(' *', style: TextStyle(color: AppTheme.primary, fontWeight: FontWeight.w700)),
          if (optional) const Padding(padding: EdgeInsets.only(left: 6), child: Text('OPTIONAL', style: TextStyle(color: AppTheme.mutedText, fontSize: 10, fontWeight: FontWeight.w700, letterSpacing: .5))),
        ]),
      );
}

class _CityPicker extends StatefulWidget {
  const _CityPicker({required this.cities, required this.selected});

  final List<String> cities;
  final String? selected;

  @override
  State<_CityPicker> createState() => _CityPickerState();
}

class _CityPickerState extends State<_CityPicker> {
  String _query = '';

  @override
  Widget build(BuildContext context) {
    final cities = widget.cities
        .where((city) => city.toLowerCase().contains(_query.toLowerCase()))
        .toList();
    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.viewInsetsOf(context).bottom),
      child: Material(
        color: Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        clipBehavior: Clip.antiAlias,
        child: SafeArea(
          top: false,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(22, 12, 22, 12),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(width: 38, height: 4, decoration: BoxDecoration(color: AppTheme.outlineBorder, borderRadius: BorderRadius.circular(4))),
                const SizedBox(height: 20),
                Row(children: [
                  Expanded(child: Text('Choose your city', style: Theme.of(context).textTheme.headlineSmall)),
                  IconButton(onPressed: () => Navigator.pop(context), icon: const Icon(Icons.close), tooltip: 'Close'),
                ]),
                const SizedBox(height: 8),
                TextField(
                  autofocus: true,
                  onChanged: (value) => setState(() => _query = value.trim()),
                  decoration: const InputDecoration(hintText: 'Search city', prefixIcon: Icon(Icons.search)),
                ),
                const SizedBox(height: 10),
                ConstrainedBox(
                  constraints: BoxConstraints(maxHeight: MediaQuery.sizeOf(context).height * .42),
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: cities.length,
                    itemBuilder: (context, index) {
                      final city = cities[index];
                      final selected = city == widget.selected;
                      return ListTile(
                        contentPadding: const EdgeInsets.symmetric(horizontal: 8),
                        title: Text(city, style: TextStyle(fontWeight: selected ? FontWeight.w700 : FontWeight.w500)),
                        trailing: selected ? const Icon(Icons.check_circle, color: AppTheme.primary) : null,
                        onTap: () => Navigator.pop(context, city),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
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
