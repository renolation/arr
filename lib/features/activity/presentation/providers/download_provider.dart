import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/network/api_providers.dart';
import '../../domain/entities/download.dart';

/// Unified Queue Notifier - fetches queue from ALL configured Sonarr/Radarr instances
class UnifiedQueueNotifier extends AsyncNotifier<List<Download>> {
  List<String> _errors = [];

  List<String> get errors => _errors;

  @override
  Future<List<Download>> build() async {
    return _fetchAll();
  }

  Future<List<Download>> _fetchAll() async {
    final sonarrApis = await ref.read(allSonarrApisProvider.future);
    final radarrApis = await ref.read(allRadarrApisProvider.future);

    if (sonarrApis.isEmpty && radarrApis.isEmpty) {
      return [];
    }

    _errors = [];
    final allDownloads = <Download>[];
    final futures = <Future<List<Download>>>[];

    for (final (serviceKey, api) in sonarrApis) {
      futures.add(_fetchQueue(serviceKey, api, DownloadSource.sonarr));
    }
    for (final (serviceKey, api) in radarrApis) {
      futures.add(_fetchQueue(serviceKey, api, DownloadSource.radarr));
    }

    final results = await Future.wait(futures);
    for (final result in results) {
      allDownloads.addAll(result);
    }

    // Sort by date descending (newest first)
    allDownloads.sort((a, b) {
      final aDate = a.date ?? DateTime(1970);
      final bDate = b.date ?? DateTime(1970);
      return bDate.compareTo(aDate);
    });

    return allDownloads;
  }

  Future<List<Download>> _fetchQueue(
    String serviceKey,
    dynamic api,
    DownloadSource source,
  ) async {
    try {
      final queueData = await api.getQueue() as List<Map<String, dynamic>>;
      return queueData
          .map((json) => Download.fromJson(json, sourceOverride: source))
          .toList();
    } catch (e) {
      _errors.add('${source.name} ($serviceKey): $e');
      return [];
    }
  }

  Future<void> refresh() async {
    ref.invalidateSelf();
  }
}

/// Unified History Notifier - fetches history from ALL configured Sonarr/Radarr instances
class UnifiedHistoryNotifier extends AsyncNotifier<List<Download>> {
  List<String> _errors = [];

  List<String> get errors => _errors;

  @override
  Future<List<Download>> build() async {
    return _fetchAll();
  }

  Future<List<Download>> _fetchAll() async {
    final sonarrApis = await ref.read(allSonarrApisProvider.future);
    final radarrApis = await ref.read(allRadarrApisProvider.future);

    if (sonarrApis.isEmpty && radarrApis.isEmpty) {
      return [];
    }

    _errors = [];
    final allHistory = <Download>[];
    final futures = <Future<List<Download>>>[];

    for (final (serviceKey, api) in sonarrApis) {
      futures.add(_fetchHistory(serviceKey, api, DownloadSource.sonarr));
    }
    for (final (serviceKey, api) in radarrApis) {
      futures.add(_fetchHistory(serviceKey, api, DownloadSource.radarr));
    }

    final results = await Future.wait(futures);
    for (final result in results) {
      allHistory.addAll(result);
    }

    // Sort by date descending (newest first)
    allHistory.sort((a, b) {
      final aDate = a.date ?? DateTime(1970);
      final bDate = b.date ?? DateTime(1970);
      return bDate.compareTo(aDate);
    });

    return allHistory;
  }

  Future<List<Download>> _fetchHistory(
    String serviceKey,
    dynamic api,
    DownloadSource source,
  ) async {
    try {
      final historyData = await api.getHistory(pageSize: 50) as Map<String, dynamic>;
      final records = historyData['records'] as List? ?? [];
      return records
          .map((json) => Download.fromJson(
                json as Map<String, dynamic>,
                sourceOverride: source,
              ))
          .toList();
    } catch (e) {
      _errors.add('${source.name} ($serviceKey): $e');
      return [];
    }
  }

  Future<void> refresh() async {
    ref.invalidateSelf();
  }
}

/// Provider for unified queue (all active downloads from all services)
final unifiedQueueProvider =
    AsyncNotifierProvider<UnifiedQueueNotifier, List<Download>>(
  UnifiedQueueNotifier.new,
);

/// Provider for unified history (all history from all services)
final unifiedHistoryProvider =
    AsyncNotifierProvider<UnifiedHistoryNotifier, List<Download>>(
  UnifiedHistoryNotifier.new,
);

/// Provider for active downloads count
final activeDownloadsCountProvider = Provider<int>((ref) {
  final queueAsync = ref.watch(unifiedQueueProvider);

  return queueAsync.when(
    data: (downloads) => downloads.where((d) => d.isActive).length,
    loading: () => 0,
    error: (_, __) => 0,
  );
});
