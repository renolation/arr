import 'package:arr/core/constants/api_constants.dart';
import 'package:arr/features/settings/domain/entities/service_config.dart';

import '../services/api/base_api_service.dart';
import 'models/jellyseerr_models.dart';

/// Overseerr/Jellyseerr API service for media requests management
class OverseerrApi extends BaseApiService {
  final ServiceConfig config;

  OverseerrApi({
    required this.config,
    super.connectTimeout,
    super.receiveTimeout,
    super.sendTimeout,
  }) : super(
          baseUrl: config.baseUrl,
          apiKey: config.apiKey ?? '',
          apiBasePath: ApiConstants.overseerrBasePath,
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
      'query': Uri.encodeComponent(query),
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
      // Use /request/count - lightweight, requires valid API key
      final response = await get('/request/count');
      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }

  Future<Map<String, dynamic>> getSystemStatus() async {
    return await getStatus();
  }

  // ──────────────────────────────────────────────
  // Typed API methods (Jellyseerr models)
  // ──────────────────────────────────────────────

  /// Get trending content (movies + TV mixed)
  Future<PagedResponse<JellyseerrMediaResult>> getTrending({int page = 1}) async {
    final response = await get('/discover/trending', queryParameters: {'page': page});
    return PagedResponse.fromJson(
      response.data as Map<String, dynamic>,
      JellyseerrMediaResult.fromJson,
    );
  }

  /// Get popular movies sorted by popularity
  Future<PagedResponse<JellyseerrMediaResult>> getPopularMovies({int page = 1}) async {
    final response = await get('/discover/movies', queryParameters: {
      'page': page,
      'sortBy': 'popularity.desc',
    });
    return PagedResponse.fromJson(
      response.data as Map<String, dynamic>,
      (json) => JellyseerrMediaResult.fromJson({...json, 'mediaType': 'movie'}),
    );
  }

  /// Get upcoming movies
  Future<PagedResponse<JellyseerrMediaResult>> getUpcomingMovies({int page = 1}) async {
    final response = await get('/discover/movies/upcoming', queryParameters: {'page': page});
    return PagedResponse.fromJson(
      response.data as Map<String, dynamic>,
      (json) => JellyseerrMediaResult.fromJson({...json, 'mediaType': 'movie'}),
    );
  }

  /// Get popular TV shows
  Future<PagedResponse<JellyseerrMediaResult>> getPopularTv({int page = 1}) async {
    final response = await get('/discover/tv', queryParameters: {'page': page});
    return PagedResponse.fromJson(
      response.data as Map<String, dynamic>,
      (json) => JellyseerrMediaResult.fromJson({...json, 'mediaType': 'tv'}),
    );
  }

  /// Typed search returning parsed media results with status info
  Future<PagedResponse<JellyseerrMediaResult>> searchMedia(String query, {int page = 1}) async {
    final response = await get('/search', queryParameters: {
      'query': Uri.encodeComponent(query),
      'page': page,
    });
    return PagedResponse.fromJson(
      response.data as Map<String, dynamic>,
      JellyseerrMediaResult.fromJson,
    );
  }

  /// Get requests as typed list with pagination and filtering
  Future<PagedResponse<JellyseerrRequest>> getRequestList({
    int take = 20,
    int skip = 0,
    String? filter,
    String sort = 'added',
  }) async {
    final queryParams = <String, dynamic>{
      'take': take,
      'skip': skip,
      'sort': sort,
    };
    if (filter != null) {
      queryParams['filter'] = filter;
    }

    final response = await get('/request', queryParameters: queryParams);
    return PagedResponse.fromJson(
      response.data as Map<String, dynamic>,
      JellyseerrRequest.fromJson,
    );
  }

  /// Get configured Radarr servers from Jellyseerr
  Future<List<JellyseerrServiceServer>> getRadarrServers() async {
    final response = await get('/service/radarr');
    return (response.data as List)
        .map((e) => JellyseerrServiceServer.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  /// Get configured Sonarr servers from Jellyseerr
  Future<List<JellyseerrServiceServer>> getSonarrServers() async {
    final response = await get('/service/sonarr');
    return (response.data as List)
        .map((e) => JellyseerrServiceServer.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  /// Get quality profiles for a specific Radarr server
  Future<List<JellyseerrServiceProfile>> getRadarrProfiles(int serverId) async {
    final response = await get('/service/radarr/$serverId');
    final data = response.data as Map<String, dynamic>;
    return (data['profiles'] as List)
        .map((e) => JellyseerrServiceProfile.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  /// Get quality profiles for a specific Sonarr server
  Future<List<JellyseerrServiceProfile>> getSonarrProfiles(int serverId) async {
    final response = await get('/service/sonarr/$serverId');
    final data = response.data as Map<String, dynamic>;
    return (data['profiles'] as List)
        .map((e) => JellyseerrServiceProfile.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  /// Create a media request (movie or TV) with full parameters
  Future<JellyseerrRequest> createRequest({
    required String mediaType,
    required int mediaId,
    List<int> seasons = const [],
    bool is4k = false,
    int? serverId,
    int? profileId,
    String? rootFolder,
  }) async {
    final body = <String, dynamic>{
      'mediaType': mediaType,
      'mediaId': mediaId,
      'seasons': seasons,
      'is4k': is4k,
    };
    if (serverId != null) body['serverId'] = serverId;
    if (profileId != null) body['profileId'] = profileId;
    if (rootFolder != null) body['rootFolder'] = rootFolder;

    final response = await post('/request', data: body);
    return JellyseerrRequest.fromJson(response.data as Map<String, dynamic>);
  }
}
