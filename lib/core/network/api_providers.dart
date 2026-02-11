import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../features/settings/domain/entities/service_config.dart';
import '../../features/settings/presentation/providers/service_provider.dart';
import 'sonarr_api.dart';
import 'radarr_api.dart';
import 'overseerr_api.dart';

/// Provider for Sonarr API instance
/// Returns null if Sonarr is not configured
final sonarrApiProvider = FutureProvider<SonarrApi?>((ref) async {
  try {
    final services = await ref.watch(allServicesProvider.future);
    final sonarr = services.where((s) => s.type == ServiceType.sonarr).firstOrNull;

    if (sonarr == null || !sonarr.isConfigured) {
      return null;
    }

    return SonarrApi(config: sonarr);
  } catch (e) {
    return null;
  }
});

/// Provider for Radarr API instance
/// Returns null if Radarr is not configured
final radarrApiProvider = FutureProvider<RadarrApi?>((ref) async {
  try {
    final services = await ref.watch(allServicesProvider.future);
    final radarr = services.where((s) => s.type == ServiceType.radarr).firstOrNull;

    if (radarr == null || !radarr.isConfigured) {
      return null;
    }

    return RadarrApi(config: radarr);
  } catch (e) {
    return null;
  }
});

/// Provider for Overseerr API instance
/// Returns null if Overseerr is not configured
final overseerrApiProvider = FutureProvider<OverseerrApi?>((ref) async {
  try {
    final services = await ref.watch(allServicesProvider.future);
    final overseerr = services.where((s) => s.type == ServiceType.overseerr).firstOrNull;

    if (overseerr == null || !overseerr.isConfigured) {
      return null;
    }

    return OverseerrApi(config: overseerr);
  } catch (e) {
    return null;
  }
});

/// Provider for ALL configured Sonarr API instances (multi-instance support)
/// Returns a list of (serviceKey, SonarrApi) pairs for each configured Sonarr service
final allSonarrApisProvider = FutureProvider<List<(String, SonarrApi)>>((ref) async {
  try {
    final services = await ref.watch(allServicesProvider.future);
    final sonarrServices = services.where((s) => s.type == ServiceType.sonarr && s.isConfigured);
    return sonarrServices.map((s) => (s.key, SonarrApi(config: s))).toList();
  } catch (e) {
    return [];
  }
});

/// Provider for ALL configured Radarr API instances (multi-instance support)
/// Returns a list of (serviceKey, RadarrApi) pairs for each configured Radarr service
final allRadarrApisProvider = FutureProvider<List<(String, RadarrApi)>>((ref) async {
  try {
    final services = await ref.watch(allServicesProvider.future);
    final radarrServices = services.where((s) => s.type == ServiceType.radarr && s.isConfigured);
    return radarrServices.map((s) => (s.key, RadarrApi(config: s))).toList();
  } catch (e) {
    return [];
  }
});

/// Check if Sonarr is configured and working
final isSonarrAvailableProvider = FutureProvider<bool>((ref) async {
  final api = await ref.watch(sonarrApiProvider.future);
  if (api == null) return false;

  try {
    return await api.testConnection();
  } catch (e) {
    return false;
  }
});

/// Check if Radarr is configured and working
final isRadarrAvailableProvider = FutureProvider<bool>((ref) async {
  final api = await ref.watch(radarrApiProvider.future);
  if (api == null) return false;

  try {
    return await api.testConnection();
  } catch (e) {
    return false;
  }
});

/// Check if Overseerr is configured and working
final isOverseerrAvailableProvider = FutureProvider<bool>((ref) async {
  final api = await ref.watch(overseerrApiProvider.future);
  if (api == null) return false;

  try {
    return await api.testConnection();
  } catch (e) {
    return false;
  }
});

/// Check if any media service is available
final hasMediaServiceProvider = Provider<bool>((ref) {
  final sonarr = ref.watch(sonarrApiProvider);
  final radarr = ref.watch(radarrApiProvider);

  return sonarr.maybeWhen(
        data: (api) => api != null,
        orElse: () => false,
      ) ||
      radarr.maybeWhen(
        data: (api) => api != null,
        orElse: () => false,
      );
});

/// Get service configuration status
final serviceStatusProvider = FutureProvider<Map<ServiceType, bool>>((ref) async {
  final services = await ref.watch(allServicesProvider.future);

  final status = <ServiceType, bool>{};
  for (final type in ServiceType.values) {
    final service = services.where((s) => s.type == type).firstOrNull;
    status[type] = service?.isConfigured ?? false;
  }

  return status;
});
