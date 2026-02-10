import 'package:hive_flutter/hive_flutter.dart';
import 'package:arr/models/hive/models.dart';

/// Hive Database Manager
/// Centralized management of Hive boxes and adapters
class HiveDatabase {
  // Box names
  static const String servicesBox = 'servicesBox';
  static const String mediaUnifiedBox = 'mediaUnifiedBox';
  static const String sonarrCacheBox = 'sonarrCacheBox';
  static const String radarrCacheBox = 'radarrCacheBox';
  static const String overseerrCacheBox = 'overseerrCacheBox';
  static const String downloadQueueBox = 'downloadQueueBox';
  static const String episodeCacheBox = 'episodeCacheBox';
  static const String settingsBox = 'settingsBox';
  static const String syncStateBox = 'syncStateBox';
  static const String systemStatusBox = 'systemStatusBox';

  // Keep track of initialization state
  static bool _isInitialized = false;

  /// Initialize Hive and register all adapters
  static Future<void> init({bool clearOldData = false}) async {
    if (_isInitialized) {
      print('HiveDatabase already initialized');
      return;
    }

    try {
      await Hive.initFlutter();

      // Clear old data if requested (useful for schema changes)
      if (clearOldData) {
        await _clearAllData();
      }

      // Register all type adapters
      _registerAdapters();

      // Open all boxes
      await _openBoxes();

      _isInitialized = true;
      print('HiveDatabase initialized successfully');
    } catch (e, stackTrace) {
      print('Error initializing HiveDatabase: $e');
      print('Stack trace: $stackTrace');

      // If there's a schema mismatch, try clearing old data
      if (e.toString().contains('typeId') && !clearOldData) {
        print('Schema mismatch detected, clearing old data...');
        await _clearAllData();
        // Retry initialization
        await init(clearOldData: false);
        return;
      }

      rethrow;
    }
  }

  /// Register all Hive type adapters
  static void _registerAdapters() {
    // Enums (typeId: 100-199)
    Hive.registerAdapter(ServiceTypeAdapter());
    Hive.registerAdapter(MediaTypeAdapter());
    Hive.registerAdapter(MediaStatusAdapter());
    Hive.registerAdapter(SeriesStatusAdapter());
    Hive.registerAdapter(DownloadClientTypeAdapter());
    Hive.registerAdapter(ServiceSyncTypeAdapter());
    Hive.registerAdapter(SyncStatusAdapter());
    Hive.registerAdapter(HealthIssueTypeAdapter());

    // Image & Ratings (typeId: 110-119)
    Hive.registerAdapter(ImageHiveAdapter());
    Hive.registerAdapter(RatingsHiveAdapter());

    // Service Config (typeId: 120)
    Hive.registerAdapter(ServiceConfigAdapter());

    // Media Item (typeId: 130)
    Hive.registerAdapter(MediaItemAdapter());

    // Series (typeId: 140)
    Hive.registerAdapter(SeriesHiveAdapter());

    // Movie (typeId: 150)
    Hive.registerAdapter(MovieHiveAdapter());

    // Episode (typeId: 160)
    Hive.registerAdapter(EpisodeHiveAdapter());

    // App Settings (typeId: 170)
    Hive.registerAdapter(AppSettingsAdapter());

    // Sync State (typeId: 180-182)
    Hive.registerAdapter(SyncStateAdapter());

    // System Status (typeId: 190-194)
    Hive.registerAdapter(SystemStatusAdapter());
    Hive.registerAdapter(DiskSpaceInfoAdapter());
    Hive.registerAdapter(HealthIssueAdapter());
    Hive.registerAdapter(WikiLinkAdapter());

    print('All Hive adapters registered successfully');
  }

  /// Clear all Hive data (useful for schema changes during development)
  static Future<void> _clearAllData() async {
    try {
      // Clear all known boxes from disk
      await Hive.deleteBoxFromDisk(servicesBox);
      await Hive.deleteBoxFromDisk(mediaUnifiedBox);
      await Hive.deleteBoxFromDisk(sonarrCacheBox);
      await Hive.deleteBoxFromDisk(radarrCacheBox);
      await Hive.deleteBoxFromDisk(overseerrCacheBox);
      await Hive.deleteBoxFromDisk(downloadQueueBox);
      await Hive.deleteBoxFromDisk(episodeCacheBox);
      await Hive.deleteBoxFromDisk(settingsBox);
      await Hive.deleteBoxFromDisk(syncStateBox);
      await Hive.deleteBoxFromDisk(systemStatusBox);
      print('All Hive data cleared successfully');
    } catch (e) {
      print('Warning: Could not clear Hive data: $e');
    }
  }

  /// Open all Hive boxes
  static Future<void> _openBoxes() async {
    // Service configuration boxes
    if (!Hive.isBoxOpen(servicesBox)) {
      await Hive.openBox<ServiceConfig>(servicesBox);
    }

    // Media cache boxes
    if (!Hive.isBoxOpen(mediaUnifiedBox)) {
      await Hive.openBox<MediaItem>(mediaUnifiedBox);
    }
    if (!Hive.isBoxOpen(sonarrCacheBox)) {
      await Hive.openBox<SeriesHive>(sonarrCacheBox);
    }
    if (!Hive.isBoxOpen(radarrCacheBox)) {
      await Hive.openBox<MovieHive>(radarrCacheBox);
    }
    if (!Hive.isBoxOpen(episodeCacheBox)) {
      await Hive.openBox<EpisodeHive>(episodeCacheBox);
    }
    if (!Hive.isBoxOpen(overseerrCacheBox)) {
      await Hive.openBox(overseerrCacheBox);
    }
    if (!Hive.isBoxOpen(downloadQueueBox)) {
      await Hive.openBox(downloadQueueBox);
    }

    // Settings and state boxes
    if (!Hive.isBoxOpen(settingsBox)) {
      await Hive.openBox<AppSettings>(settingsBox);
    }
    if (!Hive.isBoxOpen(syncStateBox)) {
      await Hive.openBox<SyncState>(syncStateBox);
    }
    if (!Hive.isBoxOpen(systemStatusBox)) {
      await Hive.openBox<SystemStatus>(systemStatusBox);
    }

    print('All Hive boxes opened successfully');
  }

  /// Check if Hive is initialized
  static bool get isInitialized => _isInitialized;

  /// Get a specific box
  static Box<T> getBox<T>(String boxName) {
    if (!_isInitialized) {
      throw StateError('HiveDatabase is not initialized. Call init() first.');
    }
    return Hive.box<T>(boxName);
  }

  /// Clear all cached media data
  static Future<void> clearMediaCache() async {
    await getBox<MediaItem>(mediaUnifiedBox).clear();
    await getBox<SeriesHive>(sonarrCacheBox).clear();
    await getBox<MovieHive>(radarrCacheBox).clear();
    await getBox<EpisodeHive>(episodeCacheBox).clear();
    await getBox(overseerrCacheBox).clear();
    await getBox(downloadQueueBox).clear();
    print('Media cache cleared');
  }

  /// Clear specific service cache
  static Future<void> clearServiceCache(String serviceId) async {
    // Clear from unified media box
    final mediaBox = getBox<MediaItem>(mediaUnifiedBox);
    final keysToDelete = mediaBox.keys.where((key) {
      final item = mediaBox.get(key);
      return item?.serviceId == serviceId;
    }).toList();

    for (final key in keysToDelete) {
      await mediaBox.delete(key);
    }

    // Clear from series box
    final seriesBox = getBox<SeriesHive>(sonarrCacheBox);
    final seriesKeys = seriesBox.keys.where((key) {
      final item = seriesBox.get(key);
      return item?.serviceId == serviceId;
    }).toList();

    for (final key in seriesKeys) {
      await seriesBox.delete(key);
    }

    // Clear from movie box
    final movieBox = getBox<MovieHive>(radarrCacheBox);
    final movieKeys = movieBox.keys.where((key) {
      final item = movieBox.get(key);
      return item?.serviceId == serviceId;
    }).toList();

    for (final key in movieKeys) {
      await movieBox.delete(key);
    }

    // Clear from episode box
    final episodeBox = getBox<EpisodeHive>(episodeCacheBox);
    final episodeKeys = episodeBox.keys.where((key) {
      final item = episodeBox.get(key);
      return item?.serviceId == serviceId;
    }).toList();

    for (final key in episodeKeys) {
      await episodeBox.delete(key);
    }

    print('Cache cleared for service: $serviceId');
  }

  /// Clear all sync states
  static Future<void> clearSyncStates() async {
    await getBox<SyncState>(syncStateBox).clear();
    print('Sync states cleared');
  }

  /// Clear all system status data
  static Future<void> clearSystemStatus() async {
    await getBox<SystemStatus>(systemStatusBox).clear();
    print('System status cleared');
  }

  /// Get database statistics
  static Map<String, dynamic> getStats() {
    return {
      'services': getBox<ServiceConfig>(servicesBox).length,
      'mediaItems': getBox<MediaItem>(mediaUnifiedBox).length,
      'series': getBox<SeriesHive>(sonarrCacheBox).length,
      'movies': getBox<MovieHive>(radarrCacheBox).length,
      'episodes': getBox<EpisodeHive>(episodeCacheBox).length,
      'syncStates': getBox<SyncState>(syncStateBox).length,
      'systemStatus': getBox<SystemStatus>(systemStatusBox).length,
      'isInitialized': _isInitialized,
    };
  }

  /// Close all boxes and cleanup
  static Future<void> close() async {
    await Hive.close();
    _isInitialized = false;
    print('HiveDatabase closed');
  }

  /// Compact all boxes to free up space
  static Future<void> compact() async {
    // Hive automatically compacts on close, but we can force it
    // by closing and reopening
    final services = getBox<ServiceConfig>(servicesBox);
    final media = getBox<MediaItem>(mediaUnifiedBox);
    final series = getBox<SeriesHive>(sonarrCacheBox);
    final movies = getBox<MovieHive>(radarrCacheBox);
    final episodes = getBox<EpisodeHive>(episodeCacheBox);
    final sync = getBox<SyncState>(syncStateBox);
    final status = getBox<SystemStatus>(systemStatusBox);

    await Future.wait([
      services.compact(),
      media.compact(),
      series.compact(),
      movies.compact(),
      episodes.compact(),
      sync.compact(),
      status.compact(),
    ]);

    print('HiveDatabase compacted');
  }
}
