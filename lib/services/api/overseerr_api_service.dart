import 'package:dio/dio.dart';
import '../../core/constants/api_constants.dart';
import 'base_api_service.dart';

/// API service for Overseerr/Jellyseerr (media requests)
///
/// Provides methods for interacting with Overseerr's REST API including:
/// - Request management (create, approve, decline)
/// - Media discovery and search
/// - User management
/// - System status and settings
///
/// Note: Overseerr uses JWT token authentication instead of API keys.
/// This service can be configured with either JWT or API key depending on the backend.
class OverseerrApiService extends BaseApiService {
  OverseerrApiService({
    required super.baseUrl,
    required super.apiKey,
    super.apiBasePath = ApiConstants.overseerrBasePath,
    Duration? connectTimeout,
    Duration? receiveTimeout,
    Duration? sendTimeout,
  }) : super(
          connectTimeout: connectTimeout,
          receiveTimeout: receiveTimeout,
          sendTimeout: sendTimeout,
        );

  /// Get all requests
  ///
  /// Parameters:
  /// - [page]: Page number for pagination (default: 1)
  /// - [pageSize]: Number of items per page (default: 20)
  /// - [filter]: Filter type (all, pending, approved, available, etc.)
  ///
  /// Returns a paginated list of media requests.
  Future<Response> getRequests({
    int page = 1,
    int pageSize = 20,
    String filter = 'all',
  }) async {
    return await get(
      ApiConstants.overseerrRequestsEndpoint,
      queryParameters: {
        'page': page,
        'pageSize': pageSize,
        'filter': filter,
      },
    );
  }

  /// Get request by ID
  ///
  /// Returns detailed information about a specific request including:
  /// - Request status (pending, approved, declined)
  /// - Media details
  /// - User information
  /// - Creation and modification dates
  Future<Response> getRequestById(int id) async {
    return await get('${ApiConstants.overseerrRequestsEndpoint}/$id');
  }

  /// Get count of requests by status
  ///
  /// Returns counts of requests grouped by status.
  Future<Response> getRequestCount() async {
    return await get('${ApiConstants.overseerrRequestsEndpoint}/count');
  }

  /// Create a new media request
  ///
  /// Parameters:
  /// - [mediaId]: The TMDb ID of the media
  /// - [mediaType]: The type of media (movie, tv)
  /// - [seasons]: Optional list of seasons for TV shows
  /// - [serverId]: Optional server ID to use for the request
  /// - [profileId]: Optional quality profile ID
  ///
  /// Returns the created request with assigned ID.
  Future<Response> createRequest({
    required int mediaId,
    required String mediaType,
    List<int>? seasons,
    int? serverId,
    int? profileId,
  }) async {
    final data = <String, dynamic>{
      'mediaId': mediaId,
      'mediaType': mediaType,
    };

    if (seasons != null && mediaType == 'tv') {
      data['seasons'] = seasons;
    }

    if (serverId != null) {
      data['serverId'] = serverId;
    }

    if (profileId != null) {
      data['profileId'] = profileId;
    }

    return await post(
      ApiConstants.overseerrRequestsEndpoint,
      data: data,
    );
  }

  /// Approve a request
  ///
  /// Parameters:
  /// - [id]: The ID of the request to approve
  /// - [serverId]: Optional server ID to use for approval
  ///
  /// Returns the updated request.
  Future<Response> approveRequest(
    int id, {
    int? serverId,
  }) async {
    final data = <String, dynamic>{};
    if (serverId != null) {
      data['serverId'] = serverId;
    }

    return await post(
      '${ApiConstants.overseerrRequestsEndpoint}/$id/approve',
      data: data.isNotEmpty ? data : null,
    );
  }

  /// Decline a request
  ///
  /// Parameters:
  /// - [id]: The ID of the request to decline
  ///
  /// Returns the updated request.
  Future<Response> declineRequest(int id) async {
    return await post('${ApiConstants.overseerrRequestsEndpoint}/$id/decline');
  }

  /// Delete a request
  ///
  /// Parameters:
  /// - [id]: The ID of the request to delete
  ///
  /// Returns the response from the delete operation.
  Future<Response> deleteRequest(int id) async {
    return await delete('${ApiConstants.overseerrRequestsEndpoint}/$id');
  }

  /// Get media by ID
  ///
  /// Returns detailed information about media including:
  /// - Media details (title, overview, release date)
  /// - Request status
  /// - Availability status
  /// - Ratings and popularity
  Future<Response> getMedia(int id) async {
    return await get('${ApiConstants.overseerrMediaEndpoint}/$id');
  }

  /// Get trending media
  ///
  /// Parameters:
  /// - [page]: Page number for pagination (default: 1)
  /// - [mediaType]: Type of media (movie, tv, all)
  ///
  /// Returns a list of trending media items.
  Future<Response> getTrending({
    int page = 1,
    String mediaType = 'all',
  }) async {
    return await get(
      '/media/trending',
      queryParameters: {
        'page': page,
        'type': mediaType,
      },
    );
  }

  /// Get upcoming media
  ///
  /// Parameters:
  /// - [page]: Page number for pagination (default: 1)
  /// - [mediaType]: Type of media (movie, tv, all)
  ///
  /// Returns a list of upcoming media items.
  Future<Response> getUpcoming({
    int page = 1,
    String mediaType = 'all',
  }) async {
    return await get(
      '/media/upcoming',
      queryParameters: {
        'page': page,
        'type': mediaType,
      },
    );
  }

  /// Search for media
  ///
  /// Parameters:
  /// - [query]: The search query
  /// - [page]: Page number for pagination (default: 1)
  /// - [mediaType]: Type of media (movie, tv, all)
  ///
  /// Returns a list of media matching the search query.
  Future<Response> searchMedia(
    String query, {
    int page = 1,
    String mediaType = 'all',
  }) async {
    return await get(
      '/search',
      queryParameters: {
        'query': query,
        'page': page,
        'type': mediaType,
      },
    );
  }

  /// Get all users
  ///
  /// Returns a list of all users in the system.
  Future<Response> getUsers() async {
    return await get(ApiConstants.overseerrUsersEndpoint);
  }

  /// Get user by ID
  ///
  /// Returns detailed information about a specific user including:
  /// - User profile
  /// - Permissions
  /// - Request counts
  Future<Response> getUserById(int id) async {
    return await get('${ApiConstants.overseerrUsersEndpoint}/$id');
  }

  /// Get current user
  ///
  /// Returns information about the authenticated user.
  Future<Response> getCurrentUser() async {
    return await get('/auth/me');
  }

  /// Get user requests
  ///
  /// Parameters:
  /// - [userId]: The ID of the user to get requests for
  /// - [page]: Page number for pagination (default: 1)
  /// - [pageSize]: Number of items per page (default: 20)
  ///
  /// Returns a paginated list of requests from the user.
  Future<Response> getUserRequests(
    int userId, {
    int page = 1,
    int pageSize = 20,
  }) async {
    return await get(
      '${ApiConstants.overseerrUsersEndpoint}/$userId/requests',
      queryParameters: {
        'page': page,
        'pageSize': pageSize,
      },
    );
  }

  /// Get system status
  ///
  /// Returns system information including:
  /// - Version information
  /// - Database status
  /// - Connected services status
  Future<Response> getSystemStatus() async {
    return await get('/status');
  }

  /// Get settings
  ///
  /// Returns the application settings.
  Future<Response> getSettings() async {
    return await get('/settings');
  }

  /// Get connected services
  ///
  /// Returns information about connected *arr services.
  Future<Response> getServices() async {
    return await get('/service');
  }

  /// Test connection to a service
  ///
  /// Parameters:
  /// - [type]: The type of service (sonarr, radarr, etc.)
  /// - [config]: The service configuration to test
  ///
  /// Returns the test result.
  Future<Response> testService({
    required String type,
    required Map<String, dynamic> config,
  }) async {
    return await post(
      '/service/test/$type',
      data: config,
    );
  }

  /// Get notifications
  ///
  /// Returns a list of notifications for the current user.
  Future<Response> getNotifications() async {
    return await get('/notification');
  }

  /// Mark notification as read
  ///
  /// Parameters:
  /// - [id]: The ID of the notification to mark as read
  ///
  /// Returns the updated notification.
  Future<Response> markNotificationRead(int id) async {
    return await post('/notification/$id/read');
  }

  /// Mark all notifications as read
  ///
  /// Returns the response from the operation.
  Future<Response> markAllNotificationsRead() async {
    return await post('/notification/read-all');
  }
}
