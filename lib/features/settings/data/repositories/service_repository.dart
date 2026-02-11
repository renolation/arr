import '../../../../core/errors/exceptions.dart';
import '../datasources/service_local_datasource.dart';
import '../../domain/entities/service_config.dart';
import '../../domain/repositories/service_repository.dart';

/// Repository implementation for service configurations
class ServiceRepositoryImpl implements ServiceRepository {
  final ServiceLocalDataSource localDataSource;

  ServiceRepositoryImpl({required this.localDataSource});

  @override
  Future<List<ServiceConfig>> getAllServices() async {
    try {
      final servicesData = await localDataSource.getAllServices();
      final services = servicesData
          .map((data) => ServiceConfig.fromJson(data))
          .toList();
      return services;
    } on CacheException {
      rethrow;
    } catch (e) {
      throw CacheException('Failed to get all services: ${e.toString()}');
    }
  }

  @override
  Future<ServiceConfig?> getService(String key) async {
    try {
      final serviceData = await localDataSource.getService(key);
      if (serviceData == null) {
        return null;
      }
      final service = ServiceConfig.fromJson(serviceData);
      return service;
    } on CacheException {
      rethrow;
    } catch (e) {
      throw CacheException('Failed to get service: ${e.toString()}');
    }
  }

  @override
  Future<void> saveService(ServiceConfig service) async {
    try {
      final json = service.toJson();
      // toJson() excludes apiKey for security, so add it back for storage
      if (service.apiKey != null) {
        json['apiKey'] = service.apiKey;
      }
      await localDataSource.saveService(service.key, json);
    } on CacheException {
      rethrow;
    } catch (e) {
      throw CacheException('Failed to save service: ${e.toString()}');
    }
  }

  @override
  Future<void> updateService(String key, Map<String, dynamic> updates) async {
    try {
      await localDataSource.updateService(key, updates);
    } on CacheException {
      rethrow;
    } catch (e) {
      throw CacheException('Failed to update service: ${e.toString()}');
    }
  }

  @override
  Future<void> deleteService(String key) async {
    try {
      await localDataSource.deleteService(key);
    } on CacheException {
      rethrow;
    } catch (e) {
      throw CacheException('Failed to delete service: ${e.toString()}');
    }
  }

  @override
  Future<String?> getApiKey(String key) async {
    try {
      final apiKey = await localDataSource.getApiKey(key);
      return apiKey;
    } on CacheException {
      rethrow;
    } catch (e) {
      throw CacheException('Failed to get API key: ${e.toString()}');
    }
  }

  @override
  Future<void> saveApiKey(String key, String apiKey) async {
    try {
      await localDataSource.saveApiKey(key, apiKey);
    } on CacheException {
      rethrow;
    } catch (e) {
      throw CacheException('Failed to save API key: ${e.toString()}');
    }
  }

  @override
  Future<bool> hasService(String key) async {
    try {
      final hasService = await localDataSource.hasService(key);
      return hasService;
    } on CacheException {
      rethrow;
    } catch (e) {
      throw CacheException('Failed to check service: ${e.toString()}');
    }
  }

  @override
  Future<void> clearAll() async {
    try {
      await localDataSource.clearAll();
    } on CacheException {
      rethrow;
    } catch (e) {
      throw CacheException('Failed to clear all services: ${e.toString()}');
    }
  }
}
