abstract interface class KeyValueStore {
  Future<String?> read(String key);
  Future<void> write(String key, String value);
  Future<void> remove(String key);
  Future<Set<String>> keys({String? prefix});
}

abstract interface class UserScopedStore {
  /// Remove everything held for [userId]: keys, files, caches.
  Future<void> wipeUser(String userId);
}
