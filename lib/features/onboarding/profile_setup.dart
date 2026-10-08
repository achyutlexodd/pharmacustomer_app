import 'package:flutter/material.dart';

import '../../core/theme.dart';
import 'location.dart';

class ProfileSetup extends StatefulWidget {
  const ProfileSetup({super.key});

  @override
  State<ProfileSetup> createState() => _ProfileSetupState();
}

class _ProfileSetupState extends State<ProfileSetup> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _dobController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  String? _selectedGender;

  static const List<String> _genders = ['Female', 'Male', 'Other', 'Prefer not to say'];

  @override
  void dispose() {
    _nameController.dispose();
    _dobController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _selectDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime(1995, 1, 1),
      firstDate: DateTime(1940),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() {
        _dobController.text =
            '${picked.day.toString().padLeft(2, '0')} / ${picked.month.toString().padLeft(2, '0')} / ${picked.year}';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: const BackButton(color: AppTheme.text),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Complete Your Profile',
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: AppTheme.text),
              ),
              const SizedBox(height: 8),
              const Text(
                'Help us personalize your medicine delivery and order receipts',
                style: TextStyle(color: Colors.grey, fontSize: 14),
              ),
              const SizedBox(height: 32),
              Center(
                child: GestureDetector(
                  onTap: () => ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: const Text('Photo upload coming soon'),
                      backgroundColor: AppTheme.primary,
                      behavior: SnackBarBehavior.floating,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Stack(
                        alignment: Alignment.bottomRight,
                        children: [
                          Container(
                            width: 100,
                            height: 100,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.teal.withValues(alpha: 0.2), width: 4),
                            ),
                            child: const Icon(Icons.person_outline, size: 48, color: AppTheme.primary),
                          ),
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: const BoxDecoration(color: AppTheme.primary, shape: BoxShape.circle),
                            child: const Icon(Icons.camera_alt, color: Colors.white, size: 16),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      const Text('Add patient profile photo', style: TextStyle(color: Colors.grey, fontSize: 12)),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 32),
              _buildLabel('Full Name *', 'As per Gov ID'),
              TextField(
                controller: _nameController,
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.badge_outlined),
                  hintText: 'Enter full name',
                ),
              ),
              const SizedBox(height: 20),
              _buildLabel('Date of Birth *', ''),
              TextField(
                controller: _dobController,
                readOnly: true,
                onTap: _selectDate,
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.calendar_today_outlined),
                  hintText: 'DD / MM / YYYY',
                ),
              ),
              const SizedBox(height: 20),
              _buildLabel('Email Address (Optional)', ''),
              TextField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.email_outlined),
                  hintText: 'Enter email address',
                ),
              ),
              const SizedBox(height: 20),
              const Text('Gender', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: AppTheme.text)),
              const SizedBox(height: 8),
              Wrap(
                spacing: 12,
                runSpacing: 12,
                children: _genders.map((gender) {
                  final isSelected = _selectedGender == gender;
                  return SizedBox(
                    width: (MediaQuery.of(context).size.width - 60) / 2,
                    child: OutlinedButton(
                      onPressed: () => setState(() => _selectedGender = gender),
                      style: OutlinedButton.styleFrom(
                        backgroundColor: isSelected ? AppTheme.primary : Colors.white,
                        foregroundColor: isSelected ? Colors.white : AppTheme.text,
                        side: BorderSide(color: isSelected ? AppTheme.primary : Colors.grey.shade300),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                      child: Text(gender),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 48),
              ElevatedButton(
                onPressed: () {
                  final name = _nameController.text.trim();
                  if (name.isEmpty || _dobController.text.isEmpty || _selectedGender == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: const Text('Please enter your name, date of birth, and gender'),
                        backgroundColor: AppTheme.error,
                        behavior: SnackBarBehavior.floating,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                    );
                    return;
                  }
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => Location(name: name)),
                  );
                },
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Continue to Location'),
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

  // ── Helpers ───────────────────────────────────────────────────────────────

  Widget _buildLabel(String main, String sub) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(main, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: AppTheme.text)),
          if (sub.isNotEmpty) Text(sub, style: const TextStyle(fontSize: 12, color: Colors.grey)),
        ],
      ),
    );
  }
}
