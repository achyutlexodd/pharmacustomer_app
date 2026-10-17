enum LoadStatus {
  uninitialized,
  hydrating,
  ready,
  refreshing,
  error,
}

abstract interface class PersistedProvider {
  Future<void> init();
  void bindUser(String? userId);
  Future<void> refresh();
  void reset();
}
