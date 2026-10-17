import 'dart:async';
import 'package:flutter/foundation.dart';
import '../../features/profile/repositories/profile_repository.dart';
import 'load_status.dart';

class ProfileNotifier extends ChangeNotifier implements PersistedProvider {
  final ProfileRepository? _repository;

  String _userId = '';
  String name = '';
  String phoneNumber = '';
  String email = '';
  String address = '';
  String workAddress = 'Tower 4, Ecospace Business Park, Outer Ring Rd, Bellandur, Bengaluru 560103';
  String parentsAddress = '12th Main, Indiranagar, Bengaluru 560038';
  String? profileImagePath;

  LoadStatus _status = LoadStatus.uninitialized;
  bool _disposed = false;

  ProfileNotifier([this._repository, UserProfile? initial]) {
    if (initial != null) {
      _applyProfile(initial);
      _status = LoadStatus.ready;
    }
  }

  LoadStatus get status => _status;

  void _safeNotify() {
    if (!_disposed) {
      notifyListeners();
    }
  }

  void _applyProfile(UserProfile p) {
    _userId = p.id;
    name = p.name;
    phoneNumber = p.phoneNumber;
    email = p.email;
    address = p.address;
    workAddress = p.workAddress;
    parentsAddress = p.parentsAddress;
    profileImagePath = p.profileImagePath;
  }

  UserProfile _toProfile() {
    return UserProfile(
      id: _userId.isNotEmpty ? _userId : 'u_guest',
      name: name,
      phoneNumber: phoneNumber,
      email: email,
      address: address,
      workAddress: workAddress,
      parentsAddress: parentsAddress,
      profileImagePath: profileImagePath,
      updatedAt: DateTime.now().toUtc(),
    );
  }

  void _schedulePersist() {
    if (_repository != null && _userId.isNotEmpty) {
      _repository.schedulePersist(_toProfile());
    }
  }

  void initialize({
    required String name,
    required String phoneNumber,
    required String email,
    required String address,
    required String workAddress,
    required String parentsAddress,
    required String? profileImagePath,
  }) {
    this.name = name;
    this.phoneNumber = phoneNumber;
    this.email = email;
    this.address = address;
    this.workAddress = workAddress;
    this.parentsAddress = parentsAddress;
    this.profileImagePath = profileImagePath;
  }

  void update({
    required String name,
    required String phoneNumber,
    required String email,
    required String address,
    required String workAddress,
    required String parentsAddress,
    required String? profileImagePath,
  }) {
    initialize(
      name: name,
      phoneNumber: phoneNumber,
      email: email,
      address: address,
      workAddress: workAddress,
      parentsAddress: parentsAddress,
      profileImagePath: profileImagePath,
    );
    _schedulePersist();
    _safeNotify();
  }

  void updateAddress(String label, String value) {
    if (label == 'Home') address = value;
    if (label == 'Work / Office') workAddress = value;
    if (label == 'Parents’ Home') parentsAddress = value;
    _schedulePersist();
    _safeNotify();
  }

  @override
  Future<void> init() async {
    if (_repository == null || _userId.isEmpty) {
      _status = LoadStatus.ready;
      _safeNotify();
      return;
    }
    _status = LoadStatus.hydrating;
    _safeNotify();

    final profile = await _repository.hydrate(_userId);
    if (profile != null) {
      _applyProfile(profile);
    }
    _status = LoadStatus.ready;
    _safeNotify();
  }

  @override
  void bindUser(String? userId) {
    final nextId = userId ?? '';
    if (_userId == nextId) return;
    _userId = nextId;

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
    name = '';
    phoneNumber = '';
    email = '';
    address = '';
    profileImagePath = null;
    _status = LoadStatus.ready;
    _safeNotify();
  }

  @override
  void dispose() {
    _disposed = true;
    super.dispose();
  }
}
