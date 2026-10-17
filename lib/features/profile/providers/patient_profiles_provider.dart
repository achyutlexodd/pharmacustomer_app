import 'package:flutter/foundation.dart';

import '../models/patient_profile.dart';
import '../repositories/patient_repository.dart';

class PatientProfilesProvider extends ChangeNotifier {
  PatientProfilesProvider(this.repository);
  final PatientRepository repository;
  List<PatientProfile> profiles = const [];
  bool loading = true;
  String? error;

  Future<void> refresh() async {
    loading = true;
    error = null;
    notifyListeners();
    try {
      profiles = await repository.getProfiles();
    } catch (_) {
      error = 'We couldn’t load patient profiles.';
    }
    loading = false;
    notifyListeners();
  }

  Future<void> save(PatientProfile profile, {bool add = false}) async {
    if (add) {
      await repository.addProfile(profile);
    } else {
      await repository.updateProfile(profile);
    }
    await refresh();
  }

  Future<void> delete(String id) async {
    await repository.deleteProfile(id);
    await refresh();
  }

  Future<void> setDefault(PatientProfile profile) async {
    for (final patient in profiles) {
      await repository.updateProfile(
        patient.copyWith(isDefault: patient.id == profile.id),
      );
    }
    await refresh();
  }
}
