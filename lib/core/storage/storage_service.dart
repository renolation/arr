// ========================================
// Storage Service
// High-level interface for Hive storage operations
// ========================================

import 'package:hive/hive.dart';
import 'package:arr/core/database/hive_database.dart';
import 'package:arr/models/hive/models.dart';

/// Storage Service
/// Provides convenient methods for accessing Hive boxes
class StorageService {
  // Singleton pattern
  StorageService._private();
  static final StorageService _instance = StorageService._private();
  static StorageService get instance => _instance;

  // Box cache
  Box<ServiceConfig>? _servicesBox;
  Box<MediaItem>? _mediaBox;
  Box<SeriesHive>? _seriesBox;
  Box<MovieHive>? _movieBox;
  Box<EpisodeHive>? _episodeBox;
  Box<AppSettings>? _settingsBox;
  Box<SyncState>? _syncBox;
  Box<SystemStatus>? _statusBox;

  // Getters for boxes
  Box<ServiceConfig> get servicesBox =>
      _servicesBox ??= HiveDatabase.getBox<ServiceConfig>(HiveDatabase.servicesBox);

  Box<MediaItem> get mediaBox =>
      _mediaBox ??= HiveDatabase.getBox<MediaItem>(HiveDatabase.mediaUnifiedBox);

  Box<SeriesHive> get seriesBox =>
      _seriesBox ??= HiveDatabase.getBox<SeriesHive>(HiveDatabase.sonarrCacheBox);

  Box<MovieHive> get movieBox =>
      _movieBox ??= HiveDatabase.getBox<MovieHive>(HiveDatabase.radarrCacheBox);

  Box<EpisodeHive> get episodeBox =>
      _episodeBox ??= HiveDatabase.getBox<EpisodeHive>(HiveDatabase.episodeCacheBox);

  Box<AppSettings> get settingsBox =>
      _settingsBox ??= HiveDatabase.getBox<AppSettings>(HiveDatabase.settingsBox);

  Box<SyncState> get syncBox =>
      _syncBox ??= HiveDatabase.getBox<SyncState>(HiveDatabase.syncStateBox);

  Box<SystemStatus> get statusBox =>
      _statusBox ??= HiveDatabase.getBox<SystemStatus>(HiveDatabase.systemStatusBox);

  // Service Configuration Operations

  /// Get all services
  List<ServiceConfig> getAllServices() {
    return servicesBox.values.toList();
  }

  /// Get services by type
  List<ServiceConfig> getServicesByType(ServiceType type) {
    return servicesBox.values.where((s) => s.type == type).toList();
  }

  /// Get enabled services only
  List<ServiceConfig> getEnabledServices() {
    return servicesBox.values.where((s) => s.isEnabled).toList();
  }

  /// Get service by ID
  ServiceConfig? getService(String id) {
    return servicesBox.get(id);
  }

  /// Add service
  Future<void> addService(ServiceConfig service) async {
    await servicesBox.put(service.id, service);
  }

  /// Update service
  Future<void> updateService(ServiceConfig service) async {
    await servicesBox.put(service.id, service);
  }

  /// Delete service
  Future<void> deleteService(String id) async {
    await servicesBox.delete(id);
    // Also clear cache for this service
    await HiveDatabase.clearServiceCache(id);
  }

  // Media Operations (Unified Box)

  /// Get all media items
  List<MediaItem> getAllMedia() {
    return mediaBox.values.toList();
  }

  /// Get media items by type
  List<MediaItem> getMediaByType(MediaType type) {
    return mediaBox.values.where((m) => m.type == type).toList();
  }

  /// Get media items by service
  List<MediaItem> getMediaByService(String serviceId) {
    return mediaBox.values.where((m) => m.serviceId == serviceId).toList();
  }

  /// Get media item by ID
  MediaItem? getMediaItem(String id) {
    return mediaBox.get(id);
  }

  /// Search media by title
  List<MediaItem> searchMedia(String query) {
    final lowerQuery = query.toLowerCase();
    return mediaBox.values.where((m) =>
      m.title.toLowerCase().contains(lowerQuery) ||
      (m.sortTitle?.toLowerCase().contains(lowerQuery) ?? false)
    ).toList();
  }

  /// Add or update media item
  Future<void> putMediaItem(MediaItem item) async {
    await mediaBox.put(item.id, item);
  }

  /// Add multiple media items
  Future<void> putMediaItems(List<MediaItem> items) async {
    final Map<String, MediaItem> itemsMap = {};
    for (final item in items) {
      itemsMap[item.id] = item;
    }
    await mediaBox.putAll(itemsMap);
  }

  /// Delete media item
  Future<void> deleteMediaItem(String id) async {
    await mediaBox.delete(id);
  }

  // Series Operations

  /// Get all series
  List<SeriesHive> getAllSeries() {
    return seriesBox.values.toList();
  }

  /// Get series by service
  List<SeriesHive> getSeriesByService(String serviceId) {
    return seriesBox.values.where((s) => s.serviceId == serviceId).toList();
  }

  /// Get series by ID
  SeriesHive? getSeries(int id) {
    return seriesBox.get(id);
  }

  /// Add or update series
  Future<void> putSeries(SeriesHive series) async {
    await seriesBox.put(series.id!, series);
  }

  /// Add multiple series
  Future<void> putSeriesList(List<SeriesHive> seriesList) async {
    final Map<int, SeriesHive> seriesMap = {};
    for (final series in seriesList) {
      if (series.id != null) {
        seriesMap[series.id!] = series;
      }
    }
    await seriesBox.putAll(seriesMap);
  }

  /// Get monitored series
  List<SeriesHive> getMonitoredSeries() {
    return seriesBox.values.where((s) => s.monitored == true).toList();
  }

  /// Get continuing series
  List<SeriesHive> getContinuingSeries() {
    return seriesBox.values.where((s) => s.status == SeriesStatus.continuing).toList();
  }

  // Movie Operations

  /// Get all movies
  List<MovieHive> getAllMovies() {
    return movieBox.values.toList();
  }

  /// Get movies by service
  List<MovieHive> getMoviesByService(String serviceId) {
    return movieBox.values.where((m) => m.serviceId == serviceId).toList();
  }

  /// Get movie by ID
  MovieHive? getMovie(int id) {
    return movieBox.get(id);
  }

  /// Add or update movie
  Future<void> putMovie(MovieHive movie) async {
    await movieBox.put(movie.id!, movie);
  }

  /// Add multiple movies
  Future<void> putMovieList(List<MovieHive> movieList) async {
    final Map<int, MovieHive> movieMap = {};
    for (final movie in movieList) {
      if (movie.id != null) {
        movieMap[movie.id!] = movie;
      }
    }
    await movieBox.putAll(movieMap);
  }

  /// Get downloaded movies
  List<MovieHive> getDownloadedMovies() {
    return movieBox.values.where((m) => m.isDownloaded).toList();
  }

  /// Get monitored movies
  List<MovieHive> getMonitoredMovies() {
    return movieBox.values.where((m) => m.monitored == true).toList();
  }

  /// Get upcoming movies
  List<MovieHive> getUpcomingMovies() {
    final now = DateTime.now();
    return movieBox.values.where((m) =>
      m.inCinemas != null &&
      m.inCinemas!.isAfter(now)
    ).toList();
  }

  // Episode Operations

  /// Get all episodes
  List<EpisodeHive> getAllEpisodes() {
    return episodeBox.values.toList();
  }

  /// Get episodes by series ID
  List<EpisodeHive> getEpisodesBySeries(int seriesId) {
    return episodeBox.values.where((e) => e.seriesId == seriesId).toList();
  }

  /// Get episodes by season
  List<EpisodeHive> getEpisodesBySeason(int seriesId, int seasonNumber) {
    return episodeBox.values.where((e) =>
      e.seriesId == seriesId &&
      e.seasonNumber == seasonNumber
    ).toList();
  }

  /// Get episode by composite key
  EpisodeHive? getEpisode(int seriesId, int seasonNumber, int episodeNumber) {
    final key = '${seriesId}_${seasonNumber}_${episodeNumber}';
    return episodeBox.get(key);
  }

  /// Add or update episode
  Future<void> putEpisode(EpisodeHive episode) async {
    await episodeBox.put(episode.episodeKey, episode);
  }

  /// Add multiple episodes
  Future<void> putEpisodeList(List<EpisodeHive> episodeList) async {
    final Map<String, EpisodeHive> episodeMap = {};
    for (final episode in episodeList) {
      episodeMap[episode.episodeKey] = episode;
    }
    await episodeBox.putAll(episodeMap);
  }

  /// Get missing episodes
  List<EpisodeHive> getMissingEpisodes(int seriesId) {
    return episodeBox.values.where((e) =>
      e.seriesId == seriesId &&
      e.hasAired &&
      !e.isDownloaded &&
      e.monitored == true
    ).toList();
  }

  // Settings Operations

  /// Get app settings
  AppSettings? getSettings() {
    return settingsBox.get('app_settings');
  }

  /// Save app settings
  Future<void> saveSettings(AppSettings settings) async {
    await settingsBox.put('app_settings', settings);
  }

  // Sync State Operations

  /// Get sync state for a service
  SyncState? getSyncState(String serviceId, ServiceSyncType syncType) {
    return syncBox.values.where((s) =>
      s.serviceId == serviceId &&
      s.syncType == syncType
    ).firstOrNull;
  }

  /// Get all sync states for a service
  List<SyncState> getSyncStates(String serviceId) {
    return syncBox.values.where((s) => s.serviceId == serviceId).toList();
  }

  /// Update sync state
  Future<void> updateSyncState(SyncState state) async {
    final key = '${state.serviceId}_${state.syncType.name}';
    await syncBox.put(key, state);
  }

  /// Get all sync states that need syncing
  List<SyncState> getStaleSyncStates() {
    return syncBox.values.where((s) => s.needsSync).toList();
  }

  // System Status Operations

  /// Get system status for a service
  SystemStatus? getSystemStatus(String serviceId) {
    return statusBox.get(serviceId);
  }

  /// Update system status
  Future<void> updateSystemStatus(SystemStatus status) async {
    await statusBox.put(status.serviceId, status);
  }

  /// Get all system statuses
  List<SystemStatus> getAllSystemStatuses() {
    return statusBox.values.toList();
  }

  // Utility Methods

  /// Clear all cached data (keeps settings and services)
  Future<void> clearAllCache() async {
    await HiveDatabase.clearMediaCache();
    await HiveDatabase.clearSyncStates();
    await HiveDatabase.clearSystemStatus();
  }

  /// Get storage statistics
  Map<String, dynamic> getStats() {
    return {
      'services': servicesBox.length,
      'media': mediaBox.length,
      'series': seriesBox.length,
      'movies': movieBox.length,
      'episodes': episodeBox.length,
      'syncStates': syncBox.length,
      'systemStatus': statusBox.length,
      'hasSettings': getSettings() != null,
    };
  }

  /// Dispose all box references
  void dispose() {
    _servicesBox = null;
    _mediaBox = null;
    _seriesBox = null;
    _movieBox = null;
    _episodeBox = null;
    _settingsBox = null;
    _syncBox = null;
    _statusBox = null;
  }
}
