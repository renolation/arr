import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../../../../core/database/hive_database.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../models/hive/service_config.dart' as hive_model;
import '../../../../models/hive/enums.dart' as hive_enums;

/// Local data source for service configurations using Hive and Secure Storage
class ServiceLocalDataSource {
  final HiveInterface hive;
  final FlutterSecureStorage secureStorage;

  ServiceLocalDataSource({
    required this.hive,
    required this.secureStorage,
  });

  /// Get services box from HiveDatabase cached instance
  Box<hive_model.ServiceConfig> get _servicesBox =>
      HiveDatabase.getBox<hive_model.ServiceConfig>(HiveDatabase.servicesBox);

  /// Get all service configurations
  Future<List<Map<String, dynamic>>> getAllServices() async {
    try {
      final services = _servicesBox.values.toList();
      final result = <Map<String, dynamic>>[];

      for (final service in services) {
        final map = _hiveToMap(service);
        // Add API key from secure storage
        final apiKey = await secureStorage.read(key: '${service.id}_api_key');
        if (apiKey != null) {
          map['apiKey'] = apiKey;
        }
        result.add(map);
      }

      return result;
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
      final serviceMap = _hiveToMap(service);

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
      }

      // Create ServiceConfig from map (without apiKey)
      final serviceConfig = _mapToHive(key, service);
      await _servicesBox.put(key, serviceConfig);
    } catch (e) {
      throw CacheException('Failed to save service: $e');
    }
  }

  /// Convert Hive model to domain map (uses 'key' field)
  Map<String, dynamic> _hiveToMap(hive_model.ServiceConfig config) {
    return {
      'key': config.id,
      'name': config.name,
      'type': config.type.name,
      'url': config.baseUrl,
      'port': config.port,
      'isActive': config.isEnabled,
      'lastSync': config.lastSync?.toIso8601String(),
      'settings': config.settings,
    };
  }

  /// Convert domain map to Hive model (uses 'id' field)
  hive_model.ServiceConfig _mapToHive(String key, Map<String, dynamic> map) {
    // Map service type from string to enum
    final typeStr = map['type'] as String? ?? 'sonarr';
    final type = hive_enums.ServiceType.values.firstWhere(
      (e) => e.name.toLowerCase() == typeStr.toLowerCase(),
      orElse: () => hive_enums.ServiceType.sonarr,
    );

    return hive_model.ServiceConfig(
      id: key,
      name: map['name'] as String? ?? '',
      type: type,
      baseUrl: map['url'] as String? ?? '',
      port: map['port'] as int?,
      isEnabled: map['isActive'] as bool? ?? true,
      lastSync: map['lastSync'] != null
          ? DateTime.tryParse(map['lastSync'] as String)
          : null,
      settings: map['settings'] as Map<String, dynamic>?,
    );
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
