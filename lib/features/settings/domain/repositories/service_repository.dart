import '../../../../core/errors/exceptions.dart';
import '../entities/service_config.dart';

/// Repository interface for service configuration operations
abstract class ServiceRepository {
  /// Get all configured services
  Future<List<ServiceConfig>> getAllServices();

  /// Get specific service by key
  Future<ServiceConfig?> getService(String key);

  /// Save service configuration
  Future<void> saveService(ServiceConfig service);

  /// Update service configuration
  Future<void> updateService(String key, Map<String, dynamic> updates);

  /// Delete service configuration
  Future<void> deleteService(String key);

  /// Get API key for service
  Future<String?> getApiKey(String key);

  /// Save API key for service
  Future<void> saveApiKey(String key, String apiKey);

  /// Check if service exists
  Future<bool> hasService(String key);

  /// Clear all services
  Future<void> clearAll();
}
