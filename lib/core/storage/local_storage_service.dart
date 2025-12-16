import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Provider for SharedPreferences instance
final sharedPreferencesProvider = Provider<SharedPreferences>((ref) {
  throw UnimplementedError(
    'SharedPreferences must be initialized in main.dart',
  );
});

/// Local storage service for non-sensitive data
class LocalStorageService {
  final SharedPreferences _prefs;

  LocalStorageService(this._prefs);

  // Save string
  Future<bool> saveString(String key, String value) async {
    return await _prefs.setString(key, value);
  }

  // Get string
  String? getString(String key) {
    return _prefs.getString(key);
  }

  // Save int
  Future<bool> saveInt(String key, int value) async {
    return await _prefs.setInt(key, value);
  }

  // Get int
  int? getInt(String key) {
    return _prefs.getInt(key);
  }

  // Save bool
  Future<bool> saveBool(String key, bool value) async {
    return await _prefs.setBool(key, value);
  }

  // Get bool
  bool? getBool(String key) {
    return _prefs.getBool(key);
  }

  // Save double
  Future<bool> saveDouble(String key, double value) async {
    return await _prefs.setDouble(key, value);
  }

  // Get double
  double? getDouble(String key) {
    return _prefs.getDouble(key);
  }

  // Save list of strings
  Future<bool> saveStringList(String key, List<String> value) async {
    return await _prefs.setStringList(key, value);
  }

  // Get list of strings
  List<String>? getStringList(String key) {
    return _prefs.getStringList(key);
  }

  // Remove a key
  Future<bool> remove(String key) async {
    return await _prefs.remove(key);
  }

  // Check if key exists
  bool containsKey(String key) {
    return _prefs.containsKey(key);
  }

  // Clear all data
  Future<bool> clear() async {
    return await _prefs.clear();
  }

  // Get all keys
  Set<String> getAllKeys() {
    return _prefs.getKeys();
  }
}

/// Provider for LocalStorageService
final localStorageServiceProvider = Provider<LocalStorageService>((ref) {
  final prefs = ref.watch(sharedPreferencesProvider);
  return LocalStorageService(prefs);
});
