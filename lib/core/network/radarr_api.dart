import 'package:arr/core/constants/api_constants.dart';
import 'package:arr/features/settings/domain/entities/service_config.dart';
import 'package:arr/services/api/base_api_service.dart';

/// Radarr API service for movie management
class RadarrApi extends BaseApiService {
  final ServiceConfig config;

  RadarrApi({
    required this.config,
    Duration? connectTimeout,
    Duration? receiveTimeout,
    Duration? sendTimeout,
  }) : super(
          baseUrl: config.baseUrl,
          apiKey: config.apiKey ?? '',
          apiBasePath: ApiConstants.radarrBasePath,
          connectTimeout: connectTimeout,
          receiveTimeout: receiveTimeout,
          sendTimeout: sendTimeout,
        );

  /// Get all movies
  Future<List<Map<String, dynamic>>> getMovies() async {
    final response = await get('/movie');
    if (response.data is List) {
      return List<Map<String, dynamic>>.from(response.data);
    }
    return [];
  }

  /// Get movie by ID
  Future<Map<String, dynamic>> getMovieById(int id) async {
    final response = await get('/movie/$id');
    return response.data as Map<String, dynamic>;
  }

  /// Get calendar (upcoming movies)
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
    int? movieId,
  }) async {
    final queryParams = <String, dynamic>{
      'page': page,
      'pageSize': pageSize,
    };
    if (movieId != null) {
      queryParams['movieId'] = movieId;
    }

    final response = await get('/history', queryParameters: queryParams);
    return response.data as Map<String, dynamic>;
  }

  /// Search for movies to add
  Future<List<Map<String, dynamic>>> searchMovies(String term) async {
    final response = await get('/movie/lookup', queryParameters: {'term': term});
    if (response.data is List) {
      return List<Map<String, dynamic>>.from(response.data);
    }
    return [];
  }

  /// Add a new movie
  Future<Map<String, dynamic>> addMovie(Map<String, dynamic> data) async {
    final response = await post('/movie', data: data);
    return response.data as Map<String, dynamic>;
  }

  /// Update a movie
  Future<Map<String, dynamic>> updateMovie(int id, Map<String, dynamic> data) async {
    final response = await put('/movie/$id', data: data);
    return response.data as Map<String, dynamic>;
  }

  /// Delete a movie
  Future<void> deleteMovie(int id, {bool deleteFiles = false}) async {
    await delete('/movie/$id', queryParameters: {'deleteFiles': deleteFiles});
  }

  /// Trigger movie search
  Future<Map<String, dynamic>> searchMovieFiles(List<int> movieIds) async {
    final response = await post('/command', data: {
      'name': 'MoviesSearch',
      'movieIds': movieIds,
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

  /// Get exclusions list
  Future<List<Map<String, dynamic>>> getExclusions() async {
    final response = await get('/exclusions');
    if (response.data is List) {
      return List<Map<String, dynamic>>.from(response.data);
    }
    return [];
  }

  /// Add exclusion
  Future<Map<String, dynamic>> addExclusion({
    required int tmdbId,
    required String title,
    required int year,
  }) async {
    final response = await post('/exclusions', data: {
      'tmdbId': tmdbId,
      'movieTitle': title,
      'movieYear': year,
    });
    return response.data as Map<String, dynamic>;
  }

  /// Delete exclusion
  Future<void> deleteExclusion(int id) async {
    await delete('/exclusions/$id');
  }

  /// Test connection to this Radarr instance
  @override
  Future<bool> testConnection() async {
    try {
      final response = await get('/system/status');
      return response.statusCode == 200;
    } catch (_) {
      return false;
    }
  }
}
