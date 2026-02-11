import '../../../../core/errors/exceptions.dart';
import '../datasources/media_remote_datasource.dart';
import '../../domain/entities/media_item.dart';
import '../../domain/repositories/media_repository.dart';

/// Repository implementation for series (Sonarr)
class SeriesRepositoryImpl implements MediaRepository {
  final SonarrRemoteDataSource remoteDataSource;

  /// In-memory cache for series data (raw JSON)
  List<Map<String, dynamic>>? _cachedSeriesData;

  SeriesRepositoryImpl({
    required this.remoteDataSource,
  });

  @override
  Future<List<MediaItem>> getAllSeries() async {
    try {
      final seriesData = await remoteDataSource.getAllSeries();
      _cachedSeriesData = seriesData;
      return seriesData.map((data) => MediaItem.fromJson(data)).toList();
    } on ServerException {
      rethrow;
    } on NetworkException {
      rethrow;
    } catch (e) {
      throw ServerException('Failed to get all series: ${e.toString()}');
    }
  }

  @override
  Future<MediaItem> getSeriesById(int id) async {
    try {
      final seriesData = await remoteDataSource.getSeriesById(id);
      return MediaItem.fromJson(seriesData);
    } on ServerException {
      rethrow;
    } on NetworkException {
      rethrow;
    } catch (e) {
      throw ServerException('Failed to get series by id: ${e.toString()}');
    }
  }

  @override
  Future<List<MediaItem>> getAllMovies() async {
    throw UnsupportedError('Use MovieRepositoryImpl for movies');
  }

  @override
  Future<MediaItem> getMovieById(int id) async {
    throw UnsupportedError('Use MovieRepositoryImpl for movies');
  }

  @override
  Future<List<MediaItem>> getCachedSeries() async {
    if (_cachedSeriesData == null) return [];
    try {
      return _cachedSeriesData!.map((data) => MediaItem.fromJson(data)).toList();
    } catch (e) {
      throw CacheException('Failed to load cached series: $e');
    }
  }

  @override
  Future<List<MediaItem>> getCachedMovies() async {
    return [];
  }

  @override
  Future<List<MediaItem>> searchMedia(String query) async {
    try {
      final resultsData = await remoteDataSource.searchSeries(query);
      return resultsData.map((data) => MediaItem.fromJson(data)).toList();
    } on ServerException {
      rethrow;
    } on NetworkException {
      rethrow;
    } catch (e) {
      throw ServerException('Failed to search series: ${e.toString()}');
    }
  }
}

/// Repository implementation for movies (Radarr)
class MovieRepositoryImpl implements MediaRepository {
  final RadarrRemoteDataSource remoteDataSource;

  /// In-memory cache for movie data (raw JSON)
  List<Map<String, dynamic>>? _cachedMovieData;

  MovieRepositoryImpl({
    required this.remoteDataSource,
  });

  @override
  Future<List<MediaItem>> getAllSeries() async {
    throw UnsupportedError('Use SeriesRepositoryImpl for series');
  }

  @override
  Future<MediaItem> getSeriesById(int id) async {
    throw UnsupportedError('Use SeriesRepositoryImpl for series');
  }

  @override
  Future<List<MediaItem>> getAllMovies() async {
    try {
      final moviesData = await remoteDataSource.getAllMovies();
      _cachedMovieData = moviesData;
      return moviesData.map((data) => MediaItem.fromJson(data)).toList();
    } on ServerException {
      rethrow;
    } on NetworkException {
      rethrow;
    } catch (e) {
      throw ServerException('Failed to get all movies: ${e.toString()}');
    }
  }

  @override
  Future<MediaItem> getMovieById(int id) async {
    try {
      final movieData = await remoteDataSource.getMovieById(id);
      return MediaItem.fromJson(movieData);
    } on ServerException {
      rethrow;
    } on NetworkException {
      rethrow;
    } catch (e) {
      throw ServerException('Failed to get movie by id: ${e.toString()}');
    }
  }

  @override
  Future<List<MediaItem>> getCachedSeries() async {
    return [];
  }

  @override
  Future<List<MediaItem>> getCachedMovies() async {
    if (_cachedMovieData == null) return [];
    try {
      return _cachedMovieData!.map((data) => MediaItem.fromJson(data)).toList();
    } catch (e) {
      throw CacheException('Failed to load cached movies: $e');
    }
  }

  @override
  Future<List<MediaItem>> searchMedia(String query) async {
    try {
      final resultsData = await remoteDataSource.searchMovies(query);
      return resultsData.map((data) => MediaItem.fromJson(data)).toList();
    } on ServerException {
      rethrow;
    } on NetworkException {
      rethrow;
    } catch (e) {
      throw ServerException('Failed to search movies: ${e.toString()}');
    }
  }
}
