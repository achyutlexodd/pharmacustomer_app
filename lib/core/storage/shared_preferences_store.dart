import 'package:shared_preferences/shared_preferences.dart';
import 'key_value_store.dart';

/// Implementation of [KeyValueStore] using the recommended [SharedPreferencesAsync].
class SharedPreferencesStore implements KeyValueStore {
  final SharedPreferencesAsync _prefs;

  SharedPreferencesStore([SharedPreferencesAsync? prefs])
      : _prefs = prefs ?? SharedPreferencesAsync();

  @override
  Future<String?> read(String key) async {
    return _prefs.getString(key);
  }

  @override
  Future<void> write(String key, String value) async {
    await _prefs.setString(key, value);
  }

  @override
  Future<void> remove(String key) async {
    await _prefs.remove(key);
  }

  @override
  Future<Set<String>> keys({String? prefix}) async {
    final allKeys = await _prefs.getKeys();
    if (prefix == null || prefix.isEmpty) {
      return allKeys;
    }
    return allKeys.where((k) => k.startsWith(prefix)).toSet();
  }
}

/// In-memory implementation of [KeyValueStore] for tests and fast execution.
class InMemoryKeyValueStore implements KeyValueStore {
  final Map<String, String> _data = {};

  InMemoryKeyValueStore([Map<String, String>? initial]) {
    if (initial != null) {
      _data.addAll(initial);
    }
  }

  @override
  Future<String?> read(String key) async => _data[key];

  @override
  Future<void> write(String key, String value) async {
    _data[key] = value;
  }

  @override
  Future<void> remove(String key) async {
    _data.remove(key);
  }

  @override
  Future<Set<String>> keys({String? prefix}) async {
    if (prefix == null || prefix.isEmpty) {
      return _data.keys.toSet();
    }
    return _data.keys.where((k) => k.startsWith(prefix)).toSet();
  }

  void clear() => _data.clear();
}
