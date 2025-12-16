import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Provider for FlutterSecureStorage instance
final flutterSecureStorageProvider = Provider<FlutterSecureStorage>((ref) {
  return const FlutterSecureStorage(
    aOptions: AndroidOptions(encryptedSharedPreferences: true),
  );
});

/// Secure storage service for sensitive data like tokens
class SecureStorageService {
  final FlutterSecureStorage _storage;

  SecureStorageService(this._storage);

  // Write data
  Future<void> write({required String key, required String value}) async {
    await _storage.write(key: key, value: value);
  }

  // Read data
  Future<String?> read({required String key}) async {
    return await _storage.read(key: key);
  }

  // Delete data
  Future<void> delete({required String key}) async {
    await _storage.delete(key: key);
  }

  // Check if key exists
  Future<bool> containsKey({required String key}) async {
    return await _storage.containsKey(key: key);
  }

  // Read all data
  Future<Map<String, String>> readAll() async {
    return await _storage.readAll();
  }

  // Delete all data
  Future<void> deleteAll() async {
    await _storage.deleteAll();
  }

  // Get all keys
  Future<List<String>> getAllKeys() async {
    final all = await _storage.readAll();
    return all.keys.toList();
  }
}

/// Provider for SecureStorageService
final secureStorageServiceProvider = Provider<SecureStorageService>((ref) {
  final storage = ref.watch(flutterSecureStorageProvider);
  return SecureStorageService(storage);
});
