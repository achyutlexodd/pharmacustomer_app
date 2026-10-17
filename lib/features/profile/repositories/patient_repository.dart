import '../models/patient_profile.dart';

abstract interface class PatientRepository {
  Future<List<PatientProfile>> getProfiles();
  Future<void> addProfile(PatientProfile profile);
  Future<void> updateProfile(PatientProfile profile);
  Future<void> deleteProfile(String id);
}

/// In-memory demo data; replace this implementation with the patient API.
class MockPatientRepository implements PatientRepository {
  MockPatientRepository(String selfName) {
    _profiles ??= [
      PatientProfile(
        id: 'self',
        name: selfName.isEmpty ? 'You' : selfName,
        relation: PatientRelation.self,
        isSelf: true,
        isDefault: true,
        gender: 'Female',
        dob: DateTime(1992, 4, 15),
        chronicConditions: const ['Type 2 Diabetes'],
        allergies: const ['Penicillin'],
        prescriptionCount: 3,
        lastUpdated: DateTime(2026, 10, 12),
      ),
      PatientProfile(
        id: 'father',
        name: 'Rajesh Kumar',
        relation: PatientRelation.father,
        gender: 'Male',
        dob: DateTime(1964, 3, 2),
        chronicConditions: const ['Hypertension'],
        allergies: const ['Sulfa drugs'],
        prescriptionCount: 2,
        lastUpdated: DateTime(2026, 10, 9),
      ),
      PatientProfile(
        id: 'mother',
        name: 'Meena Kumar',
        relation: PatientRelation.mother,
        gender: 'Female',
        dob: DateTime(1968, 8, 21),
        chronicConditions: const ['Thyroid'],
        prescriptionCount: 1,
        lastUpdated: DateTime(2026, 10, 6),
      ),
    ];
  }

  static List<PatientProfile>? _profiles;
  List<PatientProfile> get _items => _profiles!;

  @override
  Future<List<PatientProfile>> getProfiles() async => List.unmodifiable(_items);
  @override
  Future<void> addProfile(PatientProfile profile) async => _items.add(profile);
  @override
  Future<void> updateProfile(PatientProfile profile) async {
    final index = _items.indexWhere((p) => p.id == profile.id);
    if (index >= 0) _items[index] = profile;
  }

  @override
  Future<void> deleteProfile(String id) async =>
      _items.removeWhere((p) => p.id == id);
}
