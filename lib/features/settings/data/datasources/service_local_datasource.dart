import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../../../../core/constants/storage_constants.dart';
import '../../../../core/errors/exceptions.dart';

/// Local data source for service configurations using Hive and Secure Storage
class ServiceLocalDataSource {
  final HiveInterface hive;
  final FlutterSecureStorage secureStorage;

  ServiceLocalDataSource({
    required this.hive,
    required this.secureStorage,
  });

  /// Get services box
  Box<Map> get _servicesBox => hive.box(StorageConstants.servicesBox);

  /// Get all service configurations
  Future<List<Map<String, dynamic>>> getAllServices() async {
    try {
      final services = _servicesBox.values.toList();
      return services.map((e) => Map<String, dynamic>.from(e)).toList();
    } catch (e) {
      throw CacheException('Failed to load services: $e');
    }
  }

  /// Get service by key
  Future<Map<String, dynamic>?> getService(String key) async {
    try {
      final service = _servicesBox.get(key);
      if (service == null) return null;

      // Convert to Map<String, dynamic>
      final serviceMap = Map<String, dynamic>.from(service);

      // Add API key from secure storage
      final apiKey = await secureStorage.read(key: '${key}_api_key');
      if (apiKey != null) {
        serviceMap['apiKey'] = apiKey;
      }

      return serviceMap;
    } catch (e) {
      throw CacheException('Failed to load service: $e');
    }
  }

  /// Save service configuration
  Future<void> saveService(String key, Map<String, dynamic> service) async {
    try {
      // Extract API key and store securely
      final apiKey = service['apiKey'] as String?;
      if (apiKey != null) {
        await secureStorage.write(key: '${key}_api_key', value: apiKey);
        service = Map<String, dynamic>.from(service);
        service.remove('apiKey');
      }

      await _servicesBox.put(key, service);
    } catch (e) {
      throw CacheException('Failed to save service: $e');
    }
  }

  /// Update service configuration
  Future<void> updateService(String key, Map<String, dynamic> updates) async {
    try {
      final current = await getService(key);
      if (current == null) {
        throw const CacheException('Service not found');
      }

      final updated = Map<String, dynamic>.from(current);
      updated.addAll(updates);

      await saveService(key, updated);
    } catch (e) {
      throw CacheException('Failed to update service: $e');
    }
  }

  /// Delete service configuration
  Future<void> deleteService(String key) async {
    try {
      await _servicesBox.delete(key);
      await secureStorage.delete(key: '${key}_api_key');
    } catch (e) {
      throw CacheException('Failed to delete service: $e');
    }
  }

  /// Get API key for service
  Future<String?> getApiKey(String key) async {
    try {
      return await secureStorage.read(key: '${key}_api_key');
    } catch (e) {
      throw CacheException('Failed to get API key: $e');
    }
  }

  /// Save API key for service
  Future<void> saveApiKey(String key, String apiKey) async {
    try {
      await secureStorage.write(key: '${key}_api_key', value: apiKey);
    } catch (e) {
      throw CacheException('Failed to save API key: $e');
    }
  }

  /// Clear all services
  Future<void> clearAll() async {
    try {
      await _servicesBox.clear();
      await secureStorage.deleteAll();
    } catch (e) {
      throw CacheException('Failed to clear services: $e');
    }
  }

  /// Check if service exists
  Future<bool> hasService(String key) async {
    try {
      return _servicesBox.containsKey(key);
    } catch (e) {
      throw CacheException('Failed to check service: $e');
    }
  }
}
