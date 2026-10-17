import 'dart:async';
import 'package:flutter/foundation.dart';
import '../../../core/providers/load_status.dart';
import '../repositories/prescription_repository.dart';

class PrescriptionProvider extends ChangeNotifier implements PersistedProvider {
  final PrescriptionRepository? _repository;
  final List<Prescription> _prescriptions = [];

  String? _userId;
  LoadStatus _status = LoadStatus.uninitialized;
  bool _disposed = false;

  PrescriptionProvider([this._repository, List<Prescription>? initial]) {
    if (initial != null) {
      _prescriptions.addAll(initial);
      _status = LoadStatus.ready;
    }
  }

  List<Prescription> get prescriptions => List.unmodifiable(_prescriptions);
  LoadStatus get status => _status;

  PrescriptionStatus get latestStatus {
    if (_prescriptions.isEmpty) return PrescriptionStatus.noneAttached;
    return _prescriptions.first.status;
  }

  void _safeNotify() {
    if (!_disposed) {
      notifyListeners();
    }
  }

  void addPrescription(Prescription prescription) {
    _prescriptions.insert(0, prescription);
    if (_repository != null && _userId != null) {
      _repository.schedulePersist(_userId!, _prescriptions);
    }
    _safeNotify();
  }

  @override
  Future<void> init() async {
    if (_repository == null || _userId == null) {
      _status = LoadStatus.ready;
      _safeNotify();
      return;
    }

    _status = LoadStatus.hydrating;
    _safeNotify();

    final loaded = await _repository.hydrate(_userId!);
    _prescriptions.clear();
    _prescriptions.addAll(loaded);

    _status = LoadStatus.ready;
    _safeNotify();
  }

  @override
  void bindUser(String? userId) {
    if (_userId == userId) return;
    _userId = userId;

    scheduleMicrotask(() async {
      if (_disposed) return;
      await init();
    });
  }

  @override
  Future<void> refresh() async {
    await init();
  }

  @override
  void reset() {
    _prescriptions.clear();
    _status = LoadStatus.ready;
    _safeNotify();
  }

  @override
  void dispose() {
    _disposed = true;
    super.dispose();
  }
}
