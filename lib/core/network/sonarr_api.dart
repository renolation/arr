import 'package:arr/core/constants/api_constants.dart';
import 'package:arr/features/settings/domain/entities/service_config.dart';
import '../services/api/base_api_service.dart';

/// Sonarr API service for TV series management
class SonarrApi extends BaseApiService {
  final ServiceConfig config;

  SonarrApi({
    required this.config,
    super.connectTimeout,
    super.receiveTimeout,
    super.sendTimeout,
  }) : super(
          baseUrl: config.baseUrl,
          apiKey: config.apiKey ?? '',
          apiBasePath: ApiConstants.sonarrBasePath,
        );

  /// Get all series
  Future<List<Map<String, dynamic>>> getSeries() async {
    final response = await get('/series');
    if (response.data is List) {
      return List<Map<String, dynamic>>.from(response.data);
    }
    return [];
  }

  /// Get series by ID
  Future<Map<String, dynamic>> getSeriesById(int id) async {
    final response = await get('/series/$id');
    return response.data as Map<String, dynamic>;
  }

  /// Get episodes for a series
  Future<List<Map<String, dynamic>>> getEpisodes(int seriesId, {int? seasonNumber}) async {
    final queryParams = <String, dynamic>{'seriesId': seriesId};
    if (seasonNumber != null) {
      queryParams['seasonNumber'] = seasonNumber;
    }

    final response = await get('/episode', queryParameters: queryParams);
    if (response.data is List) {
      return List<Map<String, dynamic>>.from(response.data);
    }
    return [];
  }

  /// Get episode by ID
  Future<Map<String, dynamic>> getEpisodeById(int id) async {
    final response = await get('/episode/$id');
    return response.data as Map<String, dynamic>;
  }

  /// Get episode files for a series
  Future<List<Map<String, dynamic>>> getEpisodeFiles(int seriesId) async {
    final response = await get('/episodeFile', queryParameters: {'seriesId': seriesId});
    if (response.data is List) {
      return List<Map<String, dynamic>>.from(response.data);
    }
    return [];
  }

  /// Get calendar (upcoming episodes)
  Future<List<Map<String, dynamic>>> getCalendar({
    DateTime? start,
    DateTime? end,
  }) async {
    final queryParams = <String, dynamic>{};
    if (start != null) {
      queryParams['start'] = start.toIso8601String();
    }
    if (end != null) {
      queryParams['end'] = end.toIso8601String();
    }

    final response = await get('/calendar', queryParameters: queryParams);
    if (response.data is List) {
      return List<Map<String, dynamic>>.from(response.data);
    }
    return [];
  }

  /// Get download queue
  Future<List<Map<String, dynamic>>> getQueue() async {
    final response = await get('/queue');
    if (response.data is Map && response.data['records'] is List) {
      return List<Map<String, dynamic>>.from(response.data['records']);
    }
    return [];
  }

  /// Get history
  Future<Map<String, dynamic>> getHistory({
    int page = 1,
    int pageSize = 20,
    int? seriesId,
  }) async {
    final queryParams = <String, dynamic>{
      'page': page,
      'pageSize': pageSize,
    };
    if (seriesId != null) {
      queryParams['seriesId'] = seriesId;
    }

    final response = await get('/history', queryParameters: queryParams);
    return response.data as Map<String, dynamic>;
  }

  /// Search for series to add
  Future<List<Map<String, dynamic>>> searchSeries(String term) async {
    final response = await get('/series/lookup', queryParameters: {'term': term});
    if (response.data is List) {
      return List<Map<String, dynamic>>.from(response.data);
    }
    return [];
  }

  /// Add a new series
  Future<Map<String, dynamic>> addSeries(Map<String, dynamic> data) async {
    final response = await post('/series', data: data);
    return response.data as Map<String, dynamic>;
  }

  /// Update a series
  Future<Map<String, dynamic>> updateSeries(int id, Map<String, dynamic> data) async {
    final response = await put('/series/$id', data: data);
    return response.data as Map<String, dynamic>;
  }

  /// Delete a series
  Future<void> deleteSeries(int id, {bool deleteFiles = false}) async {
    await delete('/series/$id', queryParameters: {'deleteFiles': deleteFiles});
  }

  /// Trigger episode search
  Future<Map<String, dynamic>> searchEpisode(List<int> episodeIds) async {
    final response = await post('/command', data: {
      'name': 'EpisodeSearch',
      'episodeIds': episodeIds,
    });
    return response.data as Map<String, dynamic>;
  }

  /// Trigger series search
  Future<Map<String, dynamic>> searchSeriesEpisodes(int seriesId) async {
    final response = await post('/command', data: {
      'name': 'SeriesSearch',
      'seriesId': seriesId,
    });
    return response.data as Map<String, dynamic>;
  }

  /// Get quality profiles
  Future<List<Map<String, dynamic>>> getQualityProfiles() async {
    final response = await get('/qualityprofile');
    if (response.data is List) {
      return List<Map<String, dynamic>>.from(response.data);
    }
    return [];
  }

  /// Get root folders
  Future<List<Map<String, dynamic>>> getRootFolders() async {
    final response = await get('/rootfolder');
    if (response.data is List) {
      return List<Map<String, dynamic>>.from(response.data);
    }
    return [];
  }

  /// Get tags
  Future<List<Map<String, dynamic>>> getTags() async {
    final response = await get('/tag');
    if (response.data is List) {
      return List<Map<String, dynamic>>.from(response.data);
    }
    return [];
  }

  /// Get disk space
  Future<List<Map<String, dynamic>>> getDiskSpace() async {
    final response = await get('/diskspace');
    if (response.data is List) {
      return List<Map<String, dynamic>>.from(response.data);
    }
    return [];
  }

  /// Get health issues
  Future<List<Map<String, dynamic>>> getHealth() async {
    final response = await get('/health');
    if (response.data is List) {
      return List<Map<String, dynamic>>.from(response.data);
    }
    return [];
  }

  /// Test connection to this Sonarr instance via /health endpoint
  @override
  Future<bool> testConnection() async {
    try {
      final response = await get('/health');
      return response.statusCode == 200;
    } catch (_) {
      return false;
    }
  }
}
