import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../../../../core/constants/storage_constants.dart';
import '../../../../core/database/hive_database.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/network/dio_client.dart';
import '../../data/datasources/media_remote_datasource.dart';
import '../../data/repositories/media_repository.dart';
import '../../domain/entities/media_item.dart';

/// Provider for cache box
final mediaCacheBoxProvider = Provider<Box<dynamic>>((ref) {
  return HiveDatabase.getBox<dynamic>(StorageConstants.mediaUnifiedBox);
});

/// Provider for remote data source
final mediaRemoteDataSourceProvider = Provider<MediaRemoteDataSource>((ref) {
  return MediaRemoteDataSource(
    dioClient: DioClient(),
  );
});

/// Provider for repository
final mediaRepositoryProvider = Provider<MediaRepositoryImpl>((ref) {
  return MediaRepositoryImpl(
    remoteDataSource: ref.watch(mediaRemoteDataSourceProvider),
    cacheBox: ref.watch(mediaCacheBoxProvider),
  );
});

/// Provider for all series
final allSeriesProvider = FutureProvider<List<MediaItem>>((ref) async {
  try {
    return await ref.watch(mediaRepositoryProvider).getAllSeries();
  } on ServerException catch (e) {
    throw Exception('Failed to load series: ${e.message}');
  } on NetworkException catch (e) {
    throw Exception('Network error: ${e.message}');
  } on CacheException catch (e) {
    throw Exception('Cache error: ${e.message}');
  } catch (e) {
    throw Exception('Unexpected error: ${e.toString()}');
  }
});

/// Provider for all movies
final allMoviesProvider = FutureProvider<List<MediaItem>>((ref) async {
  try {
    return await ref.watch(mediaRepositoryProvider).getAllMovies();
  } on ServerException catch (e) {
    throw Exception('Failed to load movies: ${e.message}');
  } on NetworkException catch (e) {
    throw Exception('Network error: ${e.message}');
  } on CacheException catch (e) {
    throw Exception('Cache error: ${e.message}');
  } catch (e) {
    throw Exception('Unexpected error: ${e.toString()}');
  }
});

/// Provider for cached series
final cachedSeriesProvider = FutureProvider<List<MediaItem>>((ref) async {
  try {
    return await ref.watch(mediaRepositoryProvider).getCachedSeries();
  } on CacheException catch (e) {
    throw Exception('Cache error: ${e.message}');
  } catch (e) {
    throw Exception('Unexpected error: ${e.toString()}');
  }
});

/// Provider for cached movies
final cachedMoviesProvider = FutureProvider<List<MediaItem>>((ref) async {
  try {
    return await ref.watch(mediaRepositoryProvider).getCachedMovies();
  } on CacheException catch (e) {
    throw Exception('Cache error: ${e.message}');
  } catch (e) {
    throw Exception('Unexpected error: ${e.toString()}');
  }
});

/// Provider for series by ID
final seriesProvider = FutureProvider.family<MediaItem, int>((ref, id) async {
  try {
    return await ref.watch(mediaRepositoryProvider).getSeriesById(id);
  } on ServerException catch (e) {
    throw Exception('Failed to load series: ${e.message}');
  } on NetworkException catch (e) {
    throw Exception('Network error: ${e.message}');
  } on NotFoundException catch (e) {
    throw Exception('Series not found: ${e.message}');
  } catch (e) {
    throw Exception('Unexpected error: ${e.toString()}');
  }
});

/// Provider for movie by ID
final movieProvider = FutureProvider.family<MediaItem, int>((ref, id) async {
  try {
    return await ref.watch(mediaRepositoryProvider).getMovieById(id);
  } on ServerException catch (e) {
    throw Exception('Failed to load movie: ${e.message}');
  } on NetworkException catch (e) {
    throw Exception('Network error: ${e.message}');
  } on NotFoundException catch (e) {
    throw Exception('Movie not found: ${e.message}');
  } catch (e) {
    throw Exception('Unexpected error: ${e.toString()}');
  }
});

/// Provider for search query
final searchQueryProvider = StateProvider<String>((ref) => '');

/// Provider for search results
final searchResultsProvider = FutureProvider<List<MediaItem>>((ref) async {
  final query = ref.watch(searchQueryProvider);
  if (query.isEmpty) {
    return <MediaItem>[];
  }
  try {
    return await ref.watch(mediaRepositoryProvider).searchMedia(query);
  } on ServerException catch (e) {
    throw Exception('Failed to search: ${e.message}');
  } on NetworkException catch (e) {
    throw Exception('Network error: ${e.message}');
  } catch (e) {
    throw Exception('Unexpected error: ${e.toString()}');
  }
});

/// Provider for selected media type filter
final mediaTypeFilterProvider = StateProvider<MediaType>((ref) => MediaType.series);

/// Provider for combined library (series + movies)
final libraryProvider = FutureProvider<List<MediaItem>>((ref) async {
  final filter = ref.watch(mediaTypeFilterProvider);

  try {
    if (filter == MediaType.series) {
      return await ref.watch(mediaRepositoryProvider).getAllSeries();
    } else {
      return await ref.watch(mediaRepositoryProvider).getAllMovies();
    }
  } on ServerException catch (e) {
    throw Exception('Failed to load library: ${e.message}');
  } on NetworkException catch (e) {
    throw Exception('Network error: ${e.message}');
  } on CacheException catch (e) {
    throw Exception('Cache error: ${e.message}');
  } catch (e) {
    throw Exception('Unexpected error: ${e.toString()}');
  }
});
