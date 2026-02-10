import 'package:arr/core/constants/api_constants.dart';
import 'package:arr/features/settings/domain/entities/service_config.dart';
import 'package:arr/services/api/base_api_service.dart';

/// Overseerr/Jellyseerr API service for media requests management
class OverseerrApi extends BaseApiService {
  final ServiceConfig config;

  OverseerrApi({
    required this.config,
    Duration? connectTimeout,
    Duration? receiveTimeout,
    Duration? sendTimeout,
  }) : super(
          baseUrl: config.baseUrl,
          apiKey: config.apiKey ?? '',
          apiBasePath: ApiConstants.overseerrBasePath,
          connectTimeout: connectTimeout,
          receiveTimeout: receiveTimeout,
          sendTimeout: sendTimeout,
        );

  /// Get all requests
  Future<Map<String, dynamic>> getRequests({
    int take = 20,
    int skip = 0,
    String? filter, // all, approved, pending, available, processing, unavailable
    String? sort, // added, modified
  }) async {
    final queryParams = <String, dynamic>{
      'take': take,
      'skip': skip,
    };
    if (filter != null) {
      queryParams['filter'] = filter;
    }
    if (sort != null) {
      queryParams['sort'] = sort;
    }

    final response = await get('/request', queryParameters: queryParams);
    return response.data as Map<String, dynamic>;
  }

  /// Get request by ID
  Future<Map<String, dynamic>> getRequestById(int id) async {
    final response = await get('/request/$id');
    return response.data as Map<String, dynamic>;
  }

  /// Get pending requests count
  Future<Map<String, dynamic>> getRequestCount() async {
    final response = await get('/request/count');
    return response.data as Map<String, dynamic>;
  }

  /// Approve a request
  Future<Map<String, dynamic>> approveRequest(int id) async {
    final response = await post('/request/$id/approve');
    return response.data as Map<String, dynamic>;
  }

  /// Decline a request
  Future<void> declineRequest(int id) async {
    await post('/request/$id/decline');
  }

  /// Delete a request
  Future<void> deleteRequest(int id) async {
    await delete('/request/$id');
  }

  /// Create a movie request
  Future<Map<String, dynamic>> requestMovie({
    required int mediaId,
    String mediaType = 'movie',
  }) async {
    final response = await post('/request', data: {
      'mediaId': mediaId,
      'mediaType': mediaType,
    });
    return response.data as Map<String, dynamic>;
  }

  /// Create a TV request
  Future<Map<String, dynamic>> requestTv({
    required int mediaId,
    List<int>? seasons,
  }) async {
    final response = await post('/request', data: {
      'mediaId': mediaId,
      'mediaType': 'tv',
      if (seasons != null) 'seasons': seasons,
    });
    return response.data as Map<String, dynamic>;
  }

  /// Search for media
  Future<Map<String, dynamic>> search(String query, {int page = 1}) async {
    final response = await get('/search', queryParameters: {
      'query': query,
      'page': page,
    });
    return response.data as Map<String, dynamic>;
  }

  /// Get trending movies
  Future<Map<String, dynamic>> getTrendingMovies({int page = 1}) async {
    final response = await get('/discover/movies', queryParameters: {'page': page});
    return response.data as Map<String, dynamic>;
  }

  /// Get trending TV shows
  Future<Map<String, dynamic>> getTrendingTv({int page = 1}) async {
    final response = await get('/discover/tv', queryParameters: {'page': page});
    return response.data as Map<String, dynamic>;
  }

  /// Get movie details
  Future<Map<String, dynamic>> getMovieDetails(int tmdbId) async {
    final response = await get('/movie/$tmdbId');
    return response.data as Map<String, dynamic>;
  }

  /// Get TV show details
  Future<Map<String, dynamic>> getTvDetails(int tmdbId) async {
    final response = await get('/tv/$tmdbId');
    return response.data as Map<String, dynamic>;
  }

  /// Get current user
  Future<Map<String, dynamic>> getCurrentUser() async {
    final response = await get('/auth/me');
    return response.data as Map<String, dynamic>;
  }

  /// Get all users
  Future<Map<String, dynamic>> getUsers({int take = 20, int skip = 0}) async {
    final response = await get('/user', queryParameters: {
      'take': take,
      'skip': skip,
    });
    return response.data as Map<String, dynamic>;
  }

  /// Get user by ID
  Future<Map<String, dynamic>> getUserById(int id) async {
    final response = await get('/user/$id');
    return response.data as Map<String, dynamic>;
  }

  /// Get status/settings
  Future<Map<String, dynamic>> getStatus() async {
    final response = await get('/status');
    return response.data as Map<String, dynamic>;
  }

  /// Get app info
  Future<Map<String, dynamic>> getAppInfo() async {
    final response = await get('/status/appdata');
    return response.data as Map<String, dynamic>;
  }

  @override
  Future<bool> testConnection() async {
    try {
      final response = await get('/status');
      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }

  Future<Map<String, dynamic>> getSystemStatus() async {
    return await getStatus();
  }
}
