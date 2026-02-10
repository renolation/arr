import '../../../../core/errors/exceptions.dart';
import '../../../../core/network/dio_client.dart';

/// Remote data source for download queue from *arr services
class DownloadRemoteDataSource {
  final DioClient dioClient;

  DownloadRemoteDataSource({required this.dioClient});

  /// Fetch download queue from Sonarr
  Future<Map<String, dynamic>> getSonarrQueue() async {
    try {
      final response = await dioClient.get('/queue');
      if (response.statusCode == 200) {
        return response.data as Map<String, dynamic>;
      }
      throw ServerException('Failed to fetch Sonarr queue');
    } catch (e) {
      throw ServerException('Sonarr queue error: $e');
    }
  }

  /// Fetch download queue from Radarr
  Future<Map<String, dynamic>> getRadarrQueue() async {
    try {
      final response = await dioClient.get('/queue');
      if (response.statusCode == 200) {
        return response.data as Map<String, dynamic>;
      }
      throw ServerException('Failed to fetch Radarr queue');
    } catch (e) {
      throw ServerException('Radarr queue error: $e');
    }
  }

  /// Fetch download history from Sonarr
  Future<List<Map<String, dynamic>>> getSonarrHistory() async {
    try {
      final response = await dioClient.get('/history');
      if (response.statusCode == 200) {
        final data = response.data as Map<String, dynamic>;
        final records = data['records'] as List;
        return List<Map<String, dynamic>>.from(
          records.map((item) => item as Map<String, dynamic>),
        );
      }
      throw ServerException('Failed to fetch Sonarr history');
    } catch (e) {
      throw ServerException('Sonarr history error: $e');
    }
  }

  /// Fetch download history from Radarr
  Future<List<Map<String, dynamic>>> getRadarrHistory() async {
    try {
      final response = await dioClient.get('/history');
      if (response.statusCode == 200) {
        final data = response.data as Map<String, dynamic>;
        final records = data['records'] as List;
        return List<Map<String, dynamic>>.from(
          records.map((item) => item as Map<String, dynamic>),
        );
      }
      throw ServerException('Failed to fetch Radarr history');
    } catch (e) {
      throw ServerException('Radarr history error: $e');
    }
  }

  /// Pause a download
  Future<void> pauseDownload(String id, String service) async {
    try {
      await dioClient.post('/command', data: {
        'name': 'pausedownload',
        'downloadIds': [int.parse(id)],
      });
    } catch (e) {
      throw ServerException('Failed to pause download: $e');
    }
  }

  /// Resume a download
  Future<void> resumeDownload(String id, String service) async {
    try {
      await dioClient.post('/command', data: {
        'name': 'resumedownload',
        'downloadIds': [int.parse(id)],
      });
    } catch (e) {
      throw ServerException('Failed to resume download: $e');
    }
  }

  /// Remove a download
  Future<void> removeDownload(String id, String service, {bool blacklist = false}) async {
    try {
      await dioClient.delete('/queue/$id', data: {
        'removeFromClient': true,
        'blocklist': blacklist,
      });
    } catch (e) {
      throw ServerException('Failed to remove download: $e');
    }
  }
}
