import '../../../../core/errors/exceptions.dart';
import '../../../../core/network/dio_client.dart';

/// Remote data source for media requests from Overseerr
class OverseerrRemoteDataSource {
  final DioClient dioClient;

  OverseerrRemoteDataSource({required this.dioClient});

  /// Fetch all media requests
  Future<List<Map<String, dynamic>>> getAllRequests() async {
    try {
      final response = await dioClient.get('/request');
      if (response.statusCode == 200) {
        final data = response.data as Map<String, dynamic>;
        final results = data['results'] as List;
        return List<Map<String, dynamic>>.from(
          results.map((item) => item as Map<String, dynamic>),
        );
      }
      throw ServerException('Failed to fetch requests');
    } catch (e) {
      throw ServerException('Requests fetch error: $e');
    }
  }

  /// Fetch pending requests
  Future<List<Map<String, dynamic>>> getPendingRequests() async {
    try {
      final response = await dioClient.get(
        '/request',
        queryParameters: {'filter': 'pending'},
      );
      if (response.statusCode == 200) {
        final data = response.data as Map<String, dynamic>;
        final results = data['results'] as List;
        return List<Map<String, dynamic>>.from(
          results.map((item) => item as Map<String, dynamic>),
        );
      }
      throw ServerException('Failed to fetch pending requests');
    } catch (e) {
      throw ServerException('Pending requests error: $e');
    }
  }

  /// Fetch request by ID
  Future<Map<String, dynamic>> getRequestById(int id) async {
    try {
      final response = await dioClient.get('/request/$id');
      if (response.statusCode == 200) {
        return response.data as Map<String, dynamic>;
      }
      throw ServerException('Failed to fetch request');
    } catch (e) {
      throw ServerException('Request fetch error: $e');
    }
  }

  /// Approve a request
  Future<Map<String, dynamic>> approveRequest(int id) async {
    try {
      final response = await dioClient.post('/request/$id/approve');
      if (response.statusCode == 200) {
        return response.data as Map<String, dynamic>;
      }
      throw ServerException('Failed to approve request');
    } catch (e) {
      throw ServerException('Request approval error: $e');
    }
  }

  /// Decline a request
  Future<Map<String, dynamic>> declineRequest(int id) async {
    try {
      final response = await dioClient.post('/request/$id/decline');
      if (response.statusCode == 200) {
        return response.data as Map<String, dynamic>;
      }
      throw ServerException('Failed to decline request');
    } catch (e) {
      throw ServerException('Request decline error: $e');
    }
  }
}
