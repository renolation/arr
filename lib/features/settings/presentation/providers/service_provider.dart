import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../../../../core/constants/storage_constants.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/network/dio_client.dart';
import '../../data/datasources/service_local_datasource.dart';
import '../../data/repositories/service_repository.dart' as impl;
import '../../domain/repositories/service_repository.dart';
import '../../domain/entities/service_config.dart';

part 'service_provider.freezed.dart';

/// Provider for secure storage
final secureStorageProvider = Provider<FlutterSecureStorage>((ref) {
  return const FlutterSecureStorage(
    aOptions: AndroidOptions(
      encryptedSharedPreferences: true,
    ),
  );
});

/// Provider for service local data source
final serviceLocalDataSourceProvider = Provider<ServiceLocalDataSource>((ref) {
  return ServiceLocalDataSource(
    hive: Hive,
    secureStorage: ref.watch(secureStorageProvider),
  );
});

/// Provider for service repository
final serviceRepositoryProvider = Provider<impl.ServiceRepositoryImpl>((ref) {
  return impl.ServiceRepositoryImpl(
    localDataSource: ref.watch(serviceLocalDataSourceProvider),
  );
});

/// Provider for all services
final allServicesProvider = FutureProvider<List<ServiceConfig>>((ref) async {
  try {
    return await ref.watch(serviceRepositoryProvider).getAllServices();
  } on CacheException catch (e) {
    throw Exception('Failed to load services: ${e.message}');
  } catch (e) {
    throw Exception('Unexpected error: ${e.toString()}');
  }
});

/// Provider for specific service by key
final serviceProvider = FutureProvider.family<ServiceConfig?, String>((ref, key) async {
  try {
    return await ref.watch(serviceRepositoryProvider).getService(key);
  } on NotFoundException catch (e) {
    throw Exception('Service not found: ${e.message}');
  } on CacheException catch (e) {
    throw Exception('Failed to load service: ${e.message}');
  } catch (e) {
    throw Exception('Unexpected error: ${e.toString()}');
  }
});

/// Provider for Sonarr service
final sonarrServiceProvider = FutureProvider<ServiceConfig?>((ref) async {
  try {
    return await ref.watch(serviceRepositoryProvider).getService(StorageConstants.sonarrServiceKey);
  } on CacheException catch (e) {
    throw Exception('Failed to load Sonarr service: ${e.message}');
  } catch (e) {
    throw Exception('Unexpected error: ${e.toString()}');
  }
});

/// Provider for Radarr service
final radarrServiceProvider = FutureProvider<ServiceConfig?>((ref) async {
  try {
    return await ref.watch(serviceRepositoryProvider).getService(StorageConstants.radarrServiceKey);
  } on CacheException catch (e) {
    throw Exception('Failed to load Radarr service: ${e.message}');
  } catch (e) {
    throw Exception('Unexpected error: ${e.toString()}');
  }
});

/// Provider for Overseerr service
final overseerrServiceProvider = FutureProvider<ServiceConfig?>((ref) async {
  try {
    return await ref.watch(serviceRepositoryProvider).getService(StorageConstants.overseerrServiceKey);
  } on CacheException catch (e) {
    throw Exception('Failed to load Overseerr service: ${e.message}');
  } catch (e) {
    throw Exception('Unexpected error: ${e.toString()}');
  }
});

/// Provider for configured services count
final configuredServicesCountProvider = Provider<int>((ref) {
  final servicesAsync = ref.watch(allServicesProvider);

  return servicesAsync.when(
    data: (services) => services.where((s) => s.isConfigured).length,
    loading: () => 0,
    error: (_, __) => 0,
  );
});

/// State notifier for service management
class ServiceNotifier extends StateNotifier<ServiceState> {
  final ServiceRepository repository;

  ServiceNotifier(this.repository) : super(const ServiceState.initial());

  Future<void> loadServices() async {
    state = const ServiceState.loading();
    try {
      final services = await repository.getAllServices();
      state = ServiceState.loaded(services);
    } on CacheException catch (e) {
      state = ServiceState.error('Failed to load services: ${e.message}');
    } catch (e) {
      state = ServiceState.error('Failed to load services: ${e.toString()}');
    }
  }

  Future<void> addService(ServiceConfig service) async {
    state = const ServiceState.loading();
    try {
      await repository.saveService(service);
      await loadServices();
    } on ValidationException catch (e) {
      state = ServiceState.error('Validation failed: ${e.message}');
    } on CacheException catch (e) {
      state = ServiceState.error('Failed to save service: ${e.message}');
    } catch (e) {
      state = ServiceState.error('Failed to save service: ${e.toString()}');
    }
  }

  Future<void> updateService(String key, Map<String, dynamic> updates) async {
    try {
      await repository.updateService(key, updates);
      await loadServices();
    } on ValidationException catch (e) {
      state = ServiceState.error('Validation failed: ${e.message}');
    } on NotFoundException catch (e) {
      state = ServiceState.error('Service not found: ${e.message}');
    } on CacheException catch (e) {
      state = ServiceState.error('Failed to update service: ${e.message}');
    } catch (e) {
      state = ServiceState.error('Failed to update service: ${e.toString()}');
    }
  }

  Future<void> deleteService(String key) async {
    try {
      await repository.deleteService(key);
      await loadServices();
    } on NotFoundException catch (e) {
      state = ServiceState.error('Service not found: ${e.message}');
    } on CacheException catch (e) {
      state = ServiceState.error('Failed to delete service: ${e.message}');
    } catch (e) {
      state = ServiceState.error('Failed to delete service: ${e.toString()}');
    }
  }

  Future<void> testConnection(ServiceConfig service) async {
    state = const ServiceState.testing();

    // TODO: Implement actual connection test
    await Future.delayed(const Duration(seconds: 2));
    state = const ServiceState.testSuccess();
  }
}

/// Provider for service state notifier
final serviceNotifierProvider = StateNotifierProvider<ServiceNotifier, ServiceState>((ref) {
  return ServiceNotifier(ref.watch(serviceRepositoryProvider));
});

/// Service states
@freezed
class ServiceState with _$ServiceState {
  const factory ServiceState.initial() = _Initial;
  const factory ServiceState.loading() = _Loading;
  const factory ServiceState.loaded(List<ServiceConfig> services) = _Loaded;
  const factory ServiceState.error(String message) = _Error;
  const factory ServiceState.testing() = _Testing;
  const factory ServiceState.testSuccess() = _TestSuccess;
  const factory ServiceState.testFailure(String message) = _TestFailure;
}
