import 'package:hive_flutter/hive_flutter.dart';
import '../../../../core/constants/storage_constants.dart';
import '../../../../core/errors/exceptions.dart';
import '../datasources/media_remote_datasource.dart';
import '../../domain/entities/media_item.dart';
import '../../domain/repositories/media_repository.dart';

/// Repository implementation for media items
class MediaRepositoryImpl implements MediaRepository {
  final MediaRemoteDataSource remoteDataSource;
  final Box<dynamic> cacheBox;

  MediaRepositoryImpl({
    required this.remoteDataSource,
    required this.cacheBox,
  });

  @override
  Future<List<MediaItem>> getAllSeries() async {
    try {
      final seriesData = await remoteDataSource.getAllSeries();
      final series = seriesData.map((data) => MediaItem.fromJson(data)).toList();

      // Cache the results
      await cacheBox.put(StorageConstants.seriesListKey, seriesData);

      return series;
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
      final series = MediaItem.fromJson(seriesData);
      return series;
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
    try {
      final moviesData = await remoteDataSource.getAllMovies();
      final movies = moviesData.map((data) => MediaItem.fromJson(data)).toList();

      // Cache the results
      await cacheBox.put(StorageConstants.movieListKey, moviesData);

      return movies;
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
      final movie = MediaItem.fromJson(movieData);
      return movie;
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
    try {
      final cachedData = cacheBox.get(StorageConstants.seriesListKey);
      if (cachedData == null) {
        throw CacheException('No cached series found');
      }

      final seriesList = List<Map<String, dynamic>>.from(
        (cachedData as List).map((item) => Map<String, dynamic>.from(item)),
      );

      final series = seriesList.map((data) => MediaItem.fromJson(data)).toList();
      return series;
    } catch (e) {
      throw CacheException('Failed to load cached series: $e');
    }
  }

  @override
  Future<List<MediaItem>> getCachedMovies() async {
    try {
      final cachedData = cacheBox.get(StorageConstants.movieListKey);
      if (cachedData == null) {
        throw CacheException('No cached movies found');
      }

      final movieList = List<Map<String, dynamic>>.from(
        (cachedData as List).map((item) => Map<String, dynamic>.from(item)),
      );

      final movies = movieList.map((data) => MediaItem.fromJson(data)).toList();
      return movies;
    } catch (e) {
      throw CacheException('Failed to load cached movies: $e');
    }
  }

  @override
  Future<List<MediaItem>> searchMedia(String query) async {
    try {
      final resultsData = await remoteDataSource.searchMedia(query);
      final results = resultsData.map((data) => MediaItem.fromJson(data)).toList();
      return results;
    } on ServerException {
      rethrow;
    } on NetworkException {
      rethrow;
    } catch (e) {
      throw ServerException('Failed to search media: ${e.toString()}');
    }
  }
}
