import 'dart:async';
import 'key_value_store.dart';
import 'write_coordinator.dart';

/// Central registry of all user-scoped data stores and coordinators.
/// Ensures all features properly wipe data on logout or flush during lifecycle changes.
class UserDataRegistry {
  final Set<UserScopedStore> _stores = {};
  final Set<WriteCoordinator> _coordinators = {};

  void registerStore(UserScopedStore store) {
    _stores.add(store);
  }

  void unregisterStore(UserScopedStore store) {
    _stores.remove(store);
  }

  void registerCoordinator(WriteCoordinator coordinator) {
    _coordinators.add(coordinator);
  }

  void unregisterCoordinator(WriteCoordinator coordinator) {
    _coordinators.remove(coordinator);
  }

  /// Flushes all coordinators concurrently.
  Future<void> flushAll() async {
    await Future.wait(
      _coordinators.map((c) => c.flush()),
      eagerError: false,
    );
  }

  /// Cancels and drops all pending writes across coordinators.
  void cancelAll() {
    for (final coordinator in _coordinators) {
      coordinator.cancelAndDrop();
    }
  }

  /// Wipes all data for [userId] across every registered store.
  Future<void> wipeUser(String userId) async {
    cancelAll();
    await Future.wait(
      _stores.map((s) => s.wipeUser(userId)),
      eagerError: false,
    );
  }
}
