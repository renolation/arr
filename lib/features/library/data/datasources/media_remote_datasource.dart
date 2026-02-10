import '../../../../core/errors/exceptions.dart';
import '../../../../core/network/dio_client.dart';

/// Remote data source for media (series/movies) from *arr services
class MediaRemoteDataSource {
  final DioClient dioClient;

  MediaRemoteDataSource({required this.dioClient});

  /// Fetch all series from Sonarr
  Future<List<Map<String, dynamic>>> getAllSeries() async {
    try {
      final response = await dioClient.get('/series');
      if (response.statusCode == 200) {
        return List<Map<String, dynamic>>.from(
          response.data.map((item) => item as Map<String, dynamic>),
        );
      }
      throw ServerException('Failed to fetch series');
    } catch (e) {
      throw ServerException('Series fetch error: $e');
    }
  }

  /// Fetch series by ID
  Future<Map<String, dynamic>> getSeriesById(int id) async {
    try {
      final response = await dioClient.get('/series/$id');
      if (response.statusCode == 200) {
        return response.data as Map<String, dynamic>;
      }
      throw ServerException('Failed to fetch series');
    } catch (e) {
      throw ServerException('Series fetch error: $e');
    }
  }

  /// Fetch all movies from Radarr
  Future<List<Map<String, dynamic>>> getAllMovies() async {
    try {
      final response = await dioClient.get('/movie');
      if (response.statusCode == 200) {
        return List<Map<String, dynamic>>.from(
          response.data.map((item) => item as Map<String, dynamic>),
        );
      }
      throw ServerException('Failed to fetch movies');
    } catch (e) {
      throw ServerException('Movies fetch error: $e');
    }
  }

  /// Fetch movie by ID
  Future<Map<String, dynamic>> getMovieById(int id) async {
    try {
      final response = await dioClient.get('/movie/$id');
      if (response.statusCode == 200) {
        return response.data as Map<String, dynamic>;
      }
      throw ServerException('Failed to fetch movie');
    } catch (e) {
      throw ServerException('Movie fetch error: $e');
    }
  }

  /// Search for media
  Future<List<Map<String, dynamic>>> searchMedia(String query) async {
    try {
      final response = await dioClient.get(
        '/series/lookup',
        queryParameters: {'term': query},
      );
      if (response.statusCode == 200) {
        return List<Map<String, dynamic>>.from(
          response.data.map((item) => item as Map<String, dynamic>),
        );
      }
      throw ServerException('Failed to search media');
    } catch (e) {
      throw ServerException('Search error: $e');
    }
  }
}
