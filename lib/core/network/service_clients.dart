import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../constants/api_constants.dart';
import '../../features/settings/domain/entities/service_config.dart';
import '../../features/settings/presentation/providers/service_provider.dart';
import 'dio_client.dart';

/// Configuration holder for a service client
class ServiceClientConfig {
  final String baseUrl;
  final String apiKey;
  final String? apiBasePath;

  const ServiceClientConfig({
    required this.baseUrl,
    required this.apiKey,
    this.apiBasePath,
  });

  bool get isValid => baseUrl.isNotEmpty && apiKey.isNotEmpty;

  String get fullBaseUrl {
    if (apiBasePath != null && apiBasePath!.isNotEmpty) {
      return '$baseUrl$apiBasePath';
    }
    return baseUrl;
  }
}

/// Provider for Sonarr service configuration
final sonarrConfigProvider = FutureProvider<ServiceClientConfig?>((ref) async {
  try {
    final services = await ref.watch(allServicesProvider.future);
    final sonarr = services.where((s) => s.type == ServiceType.sonarr).firstOrNull;

    if (sonarr == null || !sonarr.isConfigured) {
      return null;
    }

    return ServiceClientConfig(
      baseUrl: sonarr.baseUrl,
      apiKey: sonarr.apiKey ?? '',
      apiBasePath: ApiConstants.sonarrBasePath,
    );
  } catch (e) {
    return null;
  }
});

/// Provider for Radarr service configuration
final radarrConfigProvider = FutureProvider<ServiceClientConfig?>((ref) async {
  try {
    final services = await ref.watch(allServicesProvider.future);
    final radarr = services.where((s) => s.type == ServiceType.radarr).firstOrNull;

    if (radarr == null || !radarr.isConfigured) {
      return null;
    }

    return ServiceClientConfig(
      baseUrl: radarr.baseUrl,
      apiKey: radarr.apiKey ?? '',
      apiBasePath: ApiConstants.radarrBasePath,
    );
  } catch (e) {
    return null;
  }
});

/// Provider for Overseerr service configuration
final overseerrConfigProvider = FutureProvider<ServiceClientConfig?>((ref) async {
  try {
    final services = await ref.watch(allServicesProvider.future);
    final overseerr = services.where((s) => s.type == ServiceType.overseerr).firstOrNull;

    if (overseerr == null || !overseerr.isConfigured) {
      return null;
    }

    return ServiceClientConfig(
      baseUrl: overseerr.baseUrl,
      apiKey: overseerr.apiKey ?? '',
      apiBasePath: '/api/v1',
    );
  } catch (e) {
    return null;
  }
});

/// Provider for Download Client service configuration
final downloadClientConfigProvider = FutureProvider<ServiceClientConfig?>((ref) async {
  try {
    final services = await ref.watch(allServicesProvider.future);
    final downloadClient = services.where((s) => s.type == ServiceType.downloadClient).firstOrNull;

    if (downloadClient == null || !downloadClient.isConfigured) {
      return null;
    }

    return ServiceClientConfig(
      baseUrl: downloadClient.baseUrl,
      apiKey: downloadClient.apiKey ?? '',
    );
  } catch (e) {
    return null;
  }
});

/// Factory to create a configured DioClient for a specific service
class ServiceDioClient {
  final DioClient _client;
  final ServiceClientConfig config;

  ServiceDioClient._(this._client, this.config);

  /// Create a new ServiceDioClient with the given configuration
  factory ServiceDioClient.fromConfig(ServiceClientConfig config) {
    final client = DioClient();
    client.setBaseUrl(config.fullBaseUrl);
    client.setApiKey(config.apiKey);
    return ServiceDioClient._(client, config);
  }

  DioClient get client => _client;

  /// Check if the client is properly configured
  bool get isConfigured => config.isValid;
}

/// Provider for configured Sonarr Dio client
final sonarrDioClientProvider = FutureProvider<ServiceDioClient?>((ref) async {
  final config = await ref.watch(sonarrConfigProvider.future);
  if (config == null || !config.isValid) {
    return null;
  }
  return ServiceDioClient.fromConfig(config);
});

/// Provider for configured Radarr Dio client
final radarrDioClientProvider = FutureProvider<ServiceDioClient?>((ref) async {
  final config = await ref.watch(radarrConfigProvider.future);
  if (config == null || !config.isValid) {
    return null;
  }
  return ServiceDioClient.fromConfig(config);
});

/// Provider for configured Overseerr Dio client
final overseerrDioClientProvider = FutureProvider<ServiceDioClient?>((ref) async {
  final config = await ref.watch(overseerrConfigProvider.future);
  if (config == null || !config.isValid) {
    return null;
  }
  return ServiceDioClient.fromConfig(config);
});

/// Provider for configured Download Client Dio client
final downloadClientDioClientProvider = FutureProvider<ServiceDioClient?>((ref) async {
  final config = await ref.watch(downloadClientConfigProvider.future);
  if (config == null || !config.isValid) {
    return null;
  }
  return ServiceDioClient.fromConfig(config);
});

/// Check if any services are configured
final hasConfiguredServicesProvider = Provider<bool>((ref) {
  final sonarr = ref.watch(sonarrConfigProvider);
  final radarr = ref.watch(radarrConfigProvider);
  final overseerr = ref.watch(overseerrConfigProvider);

  return sonarr.maybeWhen(
        data: (config) => config?.isValid ?? false,
        orElse: () => false,
      ) ||
      radarr.maybeWhen(
        data: (config) => config?.isValid ?? false,
        orElse: () => false,
      ) ||
      overseerr.maybeWhen(
        data: (config) => config?.isValid ?? false,
        orElse: () => false,
      );
});

/// Check if Sonarr is configured
final isSonarrConfiguredProvider = Provider<bool>((ref) {
  return ref.watch(sonarrConfigProvider).maybeWhen(
        data: (config) => config?.isValid ?? false,
        orElse: () => false,
      );
});

/// Check if Radarr is configured
final isRadarrConfiguredProvider = Provider<bool>((ref) {
  return ref.watch(radarrConfigProvider).maybeWhen(
        data: (config) => config?.isValid ?? false,
        orElse: () => false,
      );
});

/// Check if Overseerr is configured
final isOverseerrConfiguredProvider = Provider<bool>((ref) {
  return ref.watch(overseerrConfigProvider).maybeWhen(
        data: (config) => config?.isValid ?? false,
        orElse: () => false,
      );
});

/// Check if Download Client is configured
final isDownloadClientConfiguredProvider = Provider<bool>((ref) {
  return ref.watch(downloadClientConfigProvider).maybeWhen(
        data: (config) => config?.isValid ?? false,
        orElse: () => false,
      );
});
