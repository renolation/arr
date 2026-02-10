import '../../../../core/errors/exceptions.dart';
import '../../../../core/network/sonarr_api.dart';
import '../../../../core/network/radarr_api.dart';

/// Remote data source for series from Sonarr
class SonarrRemoteDataSource {
  final SonarrApi api;

  SonarrRemoteDataSource({required this.api});

  /// Fetch all series from Sonarr
  Future<List<Map<String, dynamic>>> getAllSeries() async {
    try {
      return await api.getSeries();
    } catch (e) {
      throw ServerException('Series fetch error: $e');
    }
  }

  /// Fetch series by ID
  Future<Map<String, dynamic>> getSeriesById(int id) async {
    try {
      return await api.getSeriesById(id);
    } catch (e) {
      throw ServerException('Series fetch error: $e');
    }
  }

  /// Search for series
  Future<List<Map<String, dynamic>>> searchSeries(String query) async {
    try {
      return await api.searchSeries(query);
    } catch (e) {
      throw ServerException('Search error: $e');
    }
  }

  /// Get calendar (upcoming episodes)
  Future<List<Map<String, dynamic>>> getCalendar({
    DateTime? start,
    DateTime? end,
  }) async {
    try {
      return await api.getCalendar(start: start, end: end);
    } catch (e) {
      throw ServerException('Calendar fetch error: $e');
    }
  }

  /// Get download queue
  Future<List<Map<String, dynamic>>> getQueue() async {
    try {
      return await api.getQueue();
    } catch (e) {
      throw ServerException('Queue fetch error: $e');
    }
  }
}

/// Remote data source for movies from Radarr
class RadarrRemoteDataSource {
  final RadarrApi api;

  RadarrRemoteDataSource({required this.api});

  /// Fetch all movies from Radarr
  Future<List<Map<String, dynamic>>> getAllMovies() async {
    try {
      return await api.getMovies();
    } catch (e) {
      throw ServerException('Movies fetch error: $e');
    }
  }

  /// Fetch movie by ID
  Future<Map<String, dynamic>> getMovieById(int id) async {
    try {
      return await api.getMovieById(id);
    } catch (e) {
      throw ServerException('Movie fetch error: $e');
    }
  }

  /// Search for movies
  Future<List<Map<String, dynamic>>> searchMovies(String query) async {
    try {
      return await api.searchMovies(query);
    } catch (e) {
      throw ServerException('Search error: $e');
    }
  }

  /// Get calendar (upcoming movies)
  Future<List<Map<String, dynamic>>> getCalendar({
    DateTime? start,
    DateTime? end,
  }) async {
    try {
      return await api.getCalendar(start: start, end: end);
    } catch (e) {
      throw ServerException('Calendar fetch error: $e');
    }
  }

  /// Get download queue
  Future<List<Map<String, dynamic>>> getQueue() async {
    try {
      return await api.getQueue();
    } catch (e) {
      throw ServerException('Queue fetch error: $e');
    }
  }
}
