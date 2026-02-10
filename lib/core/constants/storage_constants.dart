/// Storage and Hive database constants
class StorageConstants {
  // Hive Box Names (must match HiveDatabase box names)
  static const String servicesBox = 'servicesBox';
  static const String settingsBox = 'settingsBox';
  static const String syncStateBox = 'syncStateBox';
  static const String systemStatusBox = 'systemStatusBox';
  static const String mediaUnifiedBox = 'mediaUnifiedBox';
  static const String sonarrCacheBox = 'sonarrCacheBox';
  static const String radarrCacheBox = 'radarrCacheBox';
  static const String overseerrCacheBox = 'overseerrCacheBox';
  static const String downloadQueueBox = 'downloadQueueBox';
  static const String episodeCacheBox = 'episodeCacheBox';

  // Cache Keys
  static const String seriesListKey = 'series_list';
  static const String movieListKey = 'movie_list';
  static const String requestListKey = 'request_list';
  static const String queueListKey = 'queue_list';
  static const String systemStatusKey = 'system_status';

  // Service Configuration Keys
  static const String sonarrServiceKey = 'sonarr_service';
  static const String radarrServiceKey = 'radarr_service';
  static const String overseerrServiceKey = 'overseerr_service';
  static const String downloadClientKey = 'download_client';

  // Settings Keys
  static const String themeKey = 'theme_mode';
  static const String languageKey = 'language';
  static const String autoRefreshKey = 'auto_refresh';
  static const String refreshIntervalKey = 'refresh_interval';

  // Cache Duration Keys
  static const String cacheTimestampKey = '_cache_timestamp';
  static const String lastSyncKey = '_last_sync';

  // Secure Storage Keys
  static const String apiKeyKey = '_api_key';
  static const String accessTokenKey = '_access_token';
}
