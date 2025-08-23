import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:arr/models/hive/service_config.dart';
import 'package:arr/core/database/hive_database.dart';
import 'package:arr/data/api/sonarr_api.dart';
import 'package:arr/data/api/radarr_api.dart';

final servicesBoxProvider = Provider<Box<ServiceConfig>>((ref) {
  return Hive.box<ServiceConfig>(HiveDatabase.servicesBox);
});

final serviceConfigsProvider = StateNotifierProvider<ServiceConfigNotifier, List<ServiceConfig>>((ref) {
  final box = ref.watch(servicesBoxProvider);
  return ServiceConfigNotifier(box);
});

class ServiceConfigNotifier extends StateNotifier<List<ServiceConfig>> {
  final Box<ServiceConfig> _box;
  
  ServiceConfigNotifier(this._box) : super([]) {
    _loadServices();
  }
  
  void _loadServices() {
    state = _box.values.toList();
  }
  
  Future<void> addService(ServiceConfig service) async {
    await _box.put(service.id, service);
    _loadServices();
  }
  
  Future<void> updateService(ServiceConfig service) async {
    await _box.put(service.id, service);
    _loadServices();
  }
  
  Future<void> deleteService(String id) async {
    await _box.delete(id);
    _loadServices();
  }
  
  Future<bool> testConnection(ServiceConfig service) async {
    try {
      if (service.serviceType == ServiceType.sonarr) {
        final api = SonarrApi(service);
        return await api.testConnection();
      } else if (service.serviceType == ServiceType.radarr) {
        final api = RadarrApi(service);
        return await api.testConnection();
      }
      return false;
    } catch (e) {
      return false;
    }
  }
  
  ServiceConfig? getDefaultService(ServiceType type) {
    return state.firstWhere(
      (service) => service.serviceType == type && service.isDefault,
      orElse: () => state.firstWhere(
        (service) => service.serviceType == type && service.isEnabled,
        orElse: () => state.firstWhere(
          (service) => service.serviceType == type,
          orElse: () => throw Exception('No $type service configured'),
        ),
      ),
    );
  }
  
  List<ServiceConfig> getServicesByType(ServiceType type) {
    return state.where((service) => service.serviceType == type).toList();
  }
}

final currentSonarrServiceProvider = Provider<ServiceConfig?>((ref) {
  final services = ref.watch(serviceConfigsProvider);
  try {
    return ref.watch(serviceConfigsProvider.notifier).getDefaultService(ServiceType.sonarr);
  } catch (e) {
    return null;
  }
});

final currentRadarrServiceProvider = Provider<ServiceConfig?>((ref) {
  final services = ref.watch(serviceConfigsProvider);
  try {
    return ref.watch(serviceConfigsProvider.notifier).getDefaultService(ServiceType.radarr);
  } catch (e) {
    return null;
  }
});

final sonarrApiProvider = Provider<SonarrApi?>((ref) {
  final service = ref.watch(currentSonarrServiceProvider);
  if (service == null) return null;
  return SonarrApi(service);
});

final radarrApiProvider = Provider<RadarrApi?>((ref) {
  final service = ref.watch(currentRadarrServiceProvider);
  if (service == null) return null;
  return RadarrApi(service);
});