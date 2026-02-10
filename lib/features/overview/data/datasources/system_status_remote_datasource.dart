import '../../../../core/errors/exceptions.dart';
import '../../../../core/network/dio_client.dart';

/// Remote data source for system status from *arr services
class SystemStatusRemoteDataSource {
  final DioClient dioClient;

  SystemStatusRemoteDataSource({required this.dioClient});

  /// Fetch system status from Sonarr
  Future<Map<String, dynamic>> getSonarrSystemStatus() async {
    try {
      final response = await dioClient.get('/system/status');
      if (response.statusCode == 200) {
        return response.data as Map<String, dynamic>;
      }
      throw ServerException('Failed to fetch Sonarr status');
    } catch (e) {
      throw ServerException('Sonarr status error: $e');
    }
  }

  /// Fetch system status from Radarr
  Future<Map<String, dynamic>> getRadarrSystemStatus() async {
    try {
      final response = await dioClient.get('/system/status');
      if (response.statusCode == 200) {
        return response.data as Map<String, dynamic>;
      }
      throw ServerException('Failed to fetch Radarr status');
    } catch (e) {
      throw ServerException('Radarr status error: $e');
    }
  }

  /// Fetch system status from Overseerr
  Future<Map<String, dynamic>> getOverseerrSystemStatus() async {
    try {
      final response = await dioClient.get('/status');
      if (response.statusCode == 200) {
        return response.data as Map<String, dynamic>;
      }
      throw ServerException('Failed to fetch Overseerr status');
    } catch (e) {
      throw ServerException('Overseerr status error: $e');
    }
  }
}
