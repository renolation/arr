/// API-related constants for *arr services
class ApiConstants {
  // Timeouts
  static const Duration connectTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 30);
  static const Duration sendTimeout = Duration(seconds: 30);

  // Retry Settings
  static const int maxRetries = 3;
  static const Duration retryDelay = Duration(seconds: 1);

  // Headers
  static const String contentTypeHeader = 'Content-Type';
  static const String authorizationHeader = 'X-Api-Key';
  static const String acceptHeader = 'Accept';
  static const String applicationJson = 'application/json';

  // Sonarr API
  static const String sonarrBasePath = '/api/v3';
  static const String sonarrEndpoint = '/series';
  static const String sonarrEpisodeEndpoint = '/episode';
  static const String sonarrQueueEndpoint = '/queue';
  static const String sonarrCommandEndpoint = '/command';

  // Radarr API
  static const String radarrBasePath = '/api/v3';
  static const String radarrEndpoint = '/movie';
  static const String radarrQueueEndpoint = '/queue';
  static const String radarrCommandEndpoint = '/command';
  static const String radarrReleaseEndpoint = '/release';

  // Overseerr API
  static const String overseerrBasePath = '/api/v1';
  static const String overseerrRequestsEndpoint = '/request';
  static const String overseerrMediaEndpoint = '/media';
  static const String overseerrUsersEndpoint = '/user';

  // Download Client APIs (generic)
  static const String downloadQueueEndpoint = '/queue';
  static const String downloadHistoryEndpoint = '/history';
  static const String downloadPauseEndpoint = '/pause';
  static const String downloadResumeEndpoint = '/resume';
}
