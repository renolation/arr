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

  // Cached box instances to avoid type reification issues
  static Box<ServiceConfig>? _servicesBox;
  static Box<MediaItem>? _mediaUnifiedBox;
  static Box<SeriesHive>? _sonarrCacheBox;
  static Box<MovieHive>? _radarrCacheBox;
  static Box<EpisodeHive>? _episodeCacheBox;
  static Box? _overseerrCacheBox;
  static Box? _downloadQueueBox;
  static Box<AppSettings>? _settingsBoxInstance;
  static Box<SyncState>? _syncStateBox;
  static Box<SystemStatus>? _systemStatusBox;

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
    // Helper to safely register adapters (avoids errors on hot reload)
    void safeRegister<T>(TypeAdapter<T> adapter) {
      if (!Hive.isAdapterRegistered(adapter.typeId)) {
        Hive.registerAdapter(adapter);
      }
    }

    // Enums (typeId: 100-199)
    safeRegister(ServiceTypeAdapter());
    safeRegister(MediaTypeAdapter());
    safeRegister(MediaStatusAdapter());
    safeRegister(SeriesStatusAdapter());
    safeRegister(DownloadClientTypeAdapter());
    safeRegister(ServiceSyncTypeAdapter());
    safeRegister(SyncStatusAdapter());
    safeRegister(HealthIssueTypeAdapter());

    // Image & Ratings (typeId: 110-119)
    safeRegister(ImageHiveAdapter());
    safeRegister(RatingsHiveAdapter());

    // Service Config (typeId: 120)
    safeRegister(ServiceConfigAdapter());

    // Media Item (typeId: 130)
    safeRegister(MediaItemAdapter());

    // Series (typeId: 140)
    safeRegister(SeriesHiveAdapter());

    // Movie (typeId: 150)
    safeRegister(MovieHiveAdapter());

    // Episode (typeId: 160)
    safeRegister(EpisodeHiveAdapter());

    // App Settings (typeId: 170)
    safeRegister(AppSettingsAdapter());

    // Sync State (typeId: 180-182)
    safeRegister(SyncStateAdapter());

    // System Status (typeId: 190-194)
    safeRegister(SystemStatusAdapter());
    safeRegister(DiskSpaceInfoAdapter());
    safeRegister(HealthIssueAdapter());
    safeRegister(WikiLinkAdapter());

    print('All Hive adapters registered successfully');
  }

  /// Clear all Hive data (useful for schema changes during development)
  static Future<void> _clearAllData() async {
    try {
      // Close any open boxes first to avoid conflicts
      if (Hive.isBoxOpen(servicesBox)) await Hive.box(servicesBox).close();
      if (Hive.isBoxOpen(mediaUnifiedBox)) await Hive.box(mediaUnifiedBox).close();
      if (Hive.isBoxOpen(sonarrCacheBox)) await Hive.box(sonarrCacheBox).close();
      if (Hive.isBoxOpen(radarrCacheBox)) await Hive.box(radarrCacheBox).close();
      if (Hive.isBoxOpen(overseerrCacheBox)) await Hive.box(overseerrCacheBox).close();
      if (Hive.isBoxOpen(downloadQueueBox)) await Hive.box(downloadQueueBox).close();
      if (Hive.isBoxOpen(episodeCacheBox)) await Hive.box(episodeCacheBox).close();
      if (Hive.isBoxOpen(settingsBox)) await Hive.box(settingsBox).close();
      if (Hive.isBoxOpen(syncStateBox)) await Hive.box(syncStateBox).close();
      if (Hive.isBoxOpen(systemStatusBox)) await Hive.box(systemStatusBox).close();

      // Reset cached instances
      _servicesBox = null;
      _mediaUnifiedBox = null;
      _sonarrCacheBox = null;
      _radarrCacheBox = null;
      _episodeCacheBox = null;
      _overseerrCacheBox = null;
      _downloadQueueBox = null;
      _settingsBoxInstance = null;
      _syncStateBox = null;
      _systemStatusBox = null;

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

  /// Open all Hive boxes and cache references
  static Future<void> _openBoxes() async {
    // Service configuration boxes
    _servicesBox = Hive.isBoxOpen(servicesBox)
        ? Hive.box<ServiceConfig>(servicesBox)
        : await Hive.openBox<ServiceConfig>(servicesBox);

    // Media cache boxes
    _mediaUnifiedBox = Hive.isBoxOpen(mediaUnifiedBox)
        ? Hive.box<MediaItem>(mediaUnifiedBox)
        : await Hive.openBox<MediaItem>(mediaUnifiedBox);

    _sonarrCacheBox = Hive.isBoxOpen(sonarrCacheBox)
        ? Hive.box<SeriesHive>(sonarrCacheBox)
        : await Hive.openBox<SeriesHive>(sonarrCacheBox);

    _radarrCacheBox = Hive.isBoxOpen(radarrCacheBox)
        ? Hive.box<MovieHive>(radarrCacheBox)
        : await Hive.openBox<MovieHive>(radarrCacheBox);

    _episodeCacheBox = Hive.isBoxOpen(episodeCacheBox)
        ? Hive.box<EpisodeHive>(episodeCacheBox)
        : await Hive.openBox<EpisodeHive>(episodeCacheBox);

    _overseerrCacheBox = Hive.isBoxOpen(overseerrCacheBox)
        ? Hive.box(overseerrCacheBox)
        : await Hive.openBox(overseerrCacheBox);

    _downloadQueueBox = Hive.isBoxOpen(downloadQueueBox)
        ? Hive.box(downloadQueueBox)
        : await Hive.openBox(downloadQueueBox);

    // Settings and state boxes
    _settingsBoxInstance = Hive.isBoxOpen(settingsBox)
        ? Hive.box<AppSettings>(settingsBox)
        : await Hive.openBox<AppSettings>(settingsBox);

    _syncStateBox = Hive.isBoxOpen(syncStateBox)
        ? Hive.box<SyncState>(syncStateBox)
        : await Hive.openBox<SyncState>(syncStateBox);

    _systemStatusBox = Hive.isBoxOpen(systemStatusBox)
        ? Hive.box<SystemStatus>(systemStatusBox)
        : await Hive.openBox<SystemStatus>(systemStatusBox);

    print('All Hive boxes opened successfully');
  }

  /// Check if Hive is initialized
  static bool get isInitialized => _isInitialized;

  /// Get a specific box from cached instances
  static Box<T> getBox<T>(String boxName) {
    if (!_isInitialized) {
      throw StateError('HiveDatabase is not initialized. Call init() first.');
    }

    // Return cached box instances to avoid type reification issues
    final box = _getCachedBox(boxName);
    if (box == null) {
      throw StateError('Box "$boxName" not found. Make sure it was opened during initialization.');
    }
    return box as Box<T>;
  }

  /// Get cached box by name
  static Box? _getCachedBox(String boxName) {
    switch (boxName) {
      case servicesBox:
        return _servicesBox;
      case mediaUnifiedBox:
        return _mediaUnifiedBox;
      case sonarrCacheBox:
        return _sonarrCacheBox;
      case radarrCacheBox:
        return _radarrCacheBox;
      case episodeCacheBox:
        return _episodeCacheBox;
      case overseerrCacheBox:
        return _overseerrCacheBox;
      case downloadQueueBox:
        return _downloadQueueBox;
      case settingsBox:
        return _settingsBoxInstance;
      case syncStateBox:
        return _syncStateBox;
      case systemStatusBox:
        return _systemStatusBox;
      default:
        return null;
    }
  }

  /// Get settings box directly (type-safe convenience method)
  static Box<AppSettings> get settings {
    if (!_isInitialized || _settingsBoxInstance == null) {
      throw StateError('HiveDatabase is not initialized. Call init() first.');
    }
    return _settingsBoxInstance!;
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
    // Reset cached instances
    _servicesBox = null;
    _mediaUnifiedBox = null;
    _sonarrCacheBox = null;
    _radarrCacheBox = null;
    _episodeCacheBox = null;
    _overseerrCacheBox = null;
    _downloadQueueBox = null;
    _settingsBoxInstance = null;
    _syncStateBox = null;
    _systemStatusBox = null;
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
