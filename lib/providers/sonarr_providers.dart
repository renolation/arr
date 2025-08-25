import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:arr/models/hive/series_hive.dart';
import 'package:arr/models/hive/episode_hive.dart';
import 'package:arr/models/part_3.dart';
import 'package:arr/core/database/hive_database.dart';
import 'package:arr/providers/service_providers.dart';
import 'package:arr/data/api/sonarr_api.dart';

final sonarrCacheBoxProvider = Provider<Box<SeriesHive>>((ref) {
  return Hive.box<SeriesHive>(HiveDatabase.sonarrCacheBox);
});

final episodeCacheBoxProvider = Provider<Box<EpisodeHive>>((ref) {
  return Hive.box<EpisodeHive>(HiveDatabase.episodeCacheBox);
});

final seriesListProvider = FutureProvider<List<SeriesHive>>((ref) async {
  final api = ref.watch(sonarrApiProvider);
  final service = ref.watch(currentSonarrServiceProvider);
  final cacheBox = ref.watch(sonarrCacheBoxProvider);
  
  if (api == null || service == null) {
    // Return cached data if no API is available
    return cacheBox.values.where((series) => series.serviceId == service?.id).toList()
      ..sort((a, b) => (a.sortTitle ?? a.title ?? '').compareTo(b.sortTitle ?? b.title ?? ''));
  }
  
  try {
    // Try to fetch from API
    final seriesList = await api.getSeries();
    
    // Update cache
    final cachedSeries = <SeriesHive>[];
    for (final series in seriesList) {
      final hiveModel = SeriesHive.fromSeriesResource(series, service.id);
      await cacheBox.put('${service.id}_${series.id}', hiveModel);
      cachedSeries.add(hiveModel);
    }
    
    // Update last sync time
    service.lastSync = DateTime.now();
    await service.save();
    
    return cachedSeries..sort((a, b) => (a.sortTitle ?? a.title ?? '').compareTo(b.sortTitle ?? b.title ?? ''));
  } catch (e) {
    // If API call fails, return cached data
    final cachedData = cacheBox.values.where((series) => series.serviceId == service.id).toList()
      ..sort((a, b) => (a.sortTitle ?? a.title ?? '').compareTo(b.sortTitle ?? b.title ?? ''));
    
    if (cachedData.isEmpty) {
      throw Exception('No cached data available. Error: $e');
    }
    
    return cachedData;
  }
});

final seriesDetailProvider = FutureProvider.family<SeriesHive?, int>((ref, seriesId) async {
  final api = ref.watch(sonarrApiProvider);
  final service = ref.watch(currentSonarrServiceProvider);
  final cacheBox = ref.watch(sonarrCacheBoxProvider);
  
  if (service == null) return null;
  
  final cacheKey = '${service.id}_$seriesId';
  
  if (api == null) {
    // Return cached data if no API is available
    return cacheBox.get(cacheKey);
  }
  
  try {
    // Try to fetch from API
    final series = await api.getSeriesById(seriesId);
    final hiveModel = SeriesHive.fromSeriesResource(series, service.id);
    
    // Update cache
    await cacheBox.put(cacheKey, hiveModel);
    
    return hiveModel;
  } catch (e) {
    // If API call fails, return cached data
    final cachedData = cacheBox.get(cacheKey);
    if (cachedData == null) {
      throw Exception('No cached data available for series $seriesId. Error: $e');
    }
    return cachedData;
  }
});

final seriesEpisodesProvider = FutureProvider.family<List<EpisodeHive>, int>((ref, seriesId) async {
  final api = ref.watch(sonarrApiProvider);
  final service = ref.watch(currentSonarrServiceProvider);
  final cacheBox = ref.watch(episodeCacheBoxProvider);
  
  if (service == null) return [];
  
  // Filter cached episodes for this series and service
  final cachedEpisodes = cacheBox.values
      .where((episode) => episode.seriesId == seriesId && episode.serviceId == service.id)
      .toList()
    ..sort((a, b) {
      // Sort by season number, then episode number
      final seasonComparison = (a.seasonNumber ?? 0).compareTo(b.seasonNumber ?? 0);
      if (seasonComparison != 0) return seasonComparison;
      return (a.episodeNumber ?? 0).compareTo(b.episodeNumber ?? 0);
    });
  
  if (api == null) {
    // Return cached data if no API is available
    return cachedEpisodes;
  }
  
  try {
    // Try to fetch from API
    final episodes = await api.getEpisodesBySeries(seriesId);
    
    // Update cache
    final cachedEpisodesList = <EpisodeHive>[];
    for (final episode in episodes) {
      final hiveModel = EpisodeHive.fromEpisodeResource(episode, service.id);
      final cacheKey = '${service.id}_${episode.seriesId}_${episode.id}';
      await cacheBox.put(cacheKey, hiveModel);
      cachedEpisodesList.add(hiveModel);
    }
    
    // Clean up old cached episodes for this series that are no longer returned by API
    final currentEpisodeIds = episodes.map((e) => e.id).toSet();
    final keysToDelete = <String>[];
    for (final entry in cacheBox.toMap().entries) {
      final episode = entry.value;
      if (episode.seriesId == seriesId && episode.serviceId == service.id) {
        if (!currentEpisodeIds.contains(episode.id)) {
          keysToDelete.add(entry.key);
        }
      }
    }
    for (final key in keysToDelete) {
      await cacheBox.delete(key);
    }
    
    return cachedEpisodesList..sort((a, b) {
      // Sort by season number, then episode number
      final seasonComparison = (a.seasonNumber ?? 0).compareTo(b.seasonNumber ?? 0);
      if (seasonComparison != 0) return seasonComparison;
      return (a.episodeNumber ?? 0).compareTo(b.episodeNumber ?? 0);
    });
  } catch (e) {
    // If API call fails, return cached data
    if (cachedEpisodes.isEmpty) {
      throw Exception('No cached episodes available for series $seriesId. Error: $e');
    }
    
    return cachedEpisodes;
  }
});

final seriesEpisodesBySeasonProvider = Provider.family<Map<int, List<EpisodeHive>>, int>((ref, seriesId) {
  final episodes = ref.watch(seriesEpisodesProvider(seriesId)).valueOrNull ?? [];
  
  final episodesBySeason = <int, List<EpisodeHive>>{};
  for (final episode in episodes) {
    final season = episode.seasonNumber ?? 0;
    episodesBySeason[season] ??= [];
    episodesBySeason[season]!.add(episode);
  }
  
  // Sort episodes within each season by episode number
  for (final seasonEpisodes in episodesBySeason.values) {
    seasonEpisodes.sort((a, b) => (a.episodeNumber ?? 0).compareTo(b.episodeNumber ?? 0));
  }
  
  return episodesBySeason;
});

final seriesSearchProvider = StateProvider<String>((ref) => '');

final filteredSeriesProvider = Provider<List<SeriesHive>>((ref) {
  final seriesList = ref.watch(seriesListProvider).valueOrNull ?? [];
  final searchQuery = ref.watch(seriesSearchProvider).toLowerCase();
  
  if (searchQuery.isEmpty) {
    return seriesList;
  }
  
  return seriesList.where((series) {
    final title = series.title?.toLowerCase() ?? '';
    final overview = series.overview?.toLowerCase() ?? '';
    return title.contains(searchQuery) || overview.contains(searchQuery);
  }).toList();
});

final seriesStatsProvider = Provider<SeriesStats>((ref) {
  final seriesList = ref.watch(seriesListProvider).valueOrNull ?? [];
  
  return SeriesStats(
    total: seriesList.length,
    monitored: seriesList.where((s) => s.monitored == true).length,
    unmonitored: seriesList.where((s) => s.monitored == false).length,
    continuing: seriesList.where((s) => s.status == 'continuing').length,
    ended: seriesList.where((s) => s.status == 'ended').length,
    totalEpisodes: seriesList.fold(0, (sum, s) => sum + (s.totalEpisodeCount ?? 0)),
    totalSize: seriesList.fold(0, (sum, s) => sum + (s.sizeOnDisk ?? 0)),
  );
});

class SeriesStats {
  final int total;
  final int monitored;
  final int unmonitored;
  final int continuing;
  final int ended;
  final int totalEpisodes;
  final int totalSize;
  
  SeriesStats({
    required this.total,
    required this.monitored,
    required this.unmonitored,
    required this.continuing,
    required this.ended,
    required this.totalEpisodes,
    required this.totalSize,
  });
  
  String get formattedSize {
    if (totalSize < 1024) return '$totalSize B';
    if (totalSize < 1024 * 1024) return '${(totalSize / 1024).toStringAsFixed(2)} KB';
    if (totalSize < 1024 * 1024 * 1024) return '${(totalSize / (1024 * 1024)).toStringAsFixed(2)} MB';
    return '${(totalSize / (1024 * 1024 * 1024)).toStringAsFixed(2)} GB';
  }
}