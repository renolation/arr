import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../library/domain/entities/media_item.dart';
import '../../../library/presentation/providers/media_provider.dart';
import '../../../settings/domain/entities/service_config.dart';
import '../../../settings/presentation/providers/service_provider.dart';

/// Stats for a single service instance
class ServiceStats {
  final String serviceKey;
  final String serviceName;
  final ServiceType serviceType;
  final int totalItems;
  final int withFiles;
  final int missing;
  final int monitored;
  final int totalEpisodes;
  final int episodeFiles;
  final num sizeOnDisk;

  const ServiceStats({
    required this.serviceKey,
    required this.serviceName,
    required this.serviceType,
    this.totalItems = 0,
    this.withFiles = 0,
    this.missing = 0,
    this.monitored = 0,
    this.totalEpisodes = 0,
    this.episodeFiles = 0,
    this.sizeOnDisk = 0,
  });

  String get formattedSize {
    if (sizeOnDisk <= 0) return '0 B';
    final gb = sizeOnDisk / (1024 * 1024 * 1024);
    if (gb >= 1024) {
      final tb = gb / 1024;
      return '${tb.toStringAsFixed(1)} TB';
    }
    if (gb >= 1) return '${gb.toStringAsFixed(1)} GB';
    final mb = sizeOnDisk / (1024 * 1024);
    return '${mb.toStringAsFixed(0)} MB';
  }

  /// Label for item type based on service
  String get itemLabel {
    switch (serviceType) {
      case ServiceType.sonarr:
        return 'Series';
      case ServiceType.radarr:
        return 'Movies';
      default:
        return 'Items';
    }
  }
}

/// Provider that computes per-service stats from the unified library (unfiltered)
/// and service configs for name/type resolution.
final serviceStatsProvider = Provider<List<ServiceStats>>((ref) {
  final libraryAsync = ref.watch(unifiedLibraryProvider);
  final servicesAsync = ref.watch(allServicesProvider);

  if (!libraryAsync.hasValue || !servicesAsync.hasValue) return [];

  final notifier = ref.read(unifiedLibraryProvider.notifier);
  final allMedia = notifier.allMedia;
  final services = servicesAsync.value ?? [];

  // Index services by key for lookup
  final servicesByKey = <String, ServiceConfig>{};
  for (final svc in services) {
    servicesByKey[svc.key] = svc;
  }

  final statsByService = <String, ServiceStats>{};

  for (final item in allMedia) {
    final key = item.serviceKey ?? 'unknown';
    final meta = item.metadata ?? {};
    final existing = statsByService[key];

    // Look up actual service config
    final svcConfig = servicesByKey[key];
    final svcType = svcConfig?.type ??
        (item.type == MediaType.series ? ServiceType.sonarr : ServiceType.radarr);
    final svcName = svcConfig?.name ?? key;

    final stats = meta['statistics'] as Map<String, dynamic>?;
    final hasFile = meta['hasFile'] as bool? ?? false;
    final isMonitored = meta['monitored'] as bool? ?? false;
    final isMissing = item.isMissing;

    num itemSize = 0;
    int totalEps = 0;
    int fileEps = 0;

    if (stats != null) {
      itemSize = stats['sizeOnDisk'] as num? ?? 0;
      totalEps = stats['totalEpisodeCount'] as int? ?? 0;
      fileEps = stats['episodeFileCount'] as int? ?? 0;
    }
    if (itemSize == 0) {
      itemSize = meta['sizeOnDisk'] as num? ?? 0;
    }

    statsByService[key] = ServiceStats(
      serviceKey: key,
      serviceName: svcName,
      serviceType: svcType,
      totalItems: (existing?.totalItems ?? 0) + 1,
      withFiles: (existing?.withFiles ?? 0) + (hasFile || fileEps > 0 ? 1 : 0),
      missing: (existing?.missing ?? 0) + (isMissing ? 1 : 0),
      monitored: (existing?.monitored ?? 0) + (isMonitored ? 1 : 0),
      totalEpisodes: (existing?.totalEpisodes ?? 0) + totalEps,
      episodeFiles: (existing?.episodeFiles ?? 0) + fileEps,
      sizeOnDisk: (existing?.sizeOnDisk ?? 0) + itemSize,
    );
  }

  return statsByService.values.toList()
    ..sort((a, b) {
      final typeCompare = a.serviceType.index.compareTo(b.serviceType.index);
      if (typeCompare != 0) return typeCompare;
      return a.serviceKey.compareTo(b.serviceKey);
    });
});
