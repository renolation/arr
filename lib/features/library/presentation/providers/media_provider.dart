import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../../../../core/constants/storage_constants.dart';
import '../../../../core/database/hive_database.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/network/api_providers.dart';
import '../../data/datasources/media_remote_datasource.dart';
import '../../data/repositories/media_repository.dart';
import '../../domain/entities/media_item.dart';

/// Provider for cache box
final mediaCacheBoxProvider = Provider<Box<dynamic>>((ref) {
  return HiveDatabase.getBox<dynamic>(StorageConstants.mediaUnifiedBox);
});

/// Provider for Sonarr remote data source (configured with service settings)
final sonarrRemoteDataSourceProvider = FutureProvider<SonarrRemoteDataSource?>((ref) async {
  final api = await ref.watch(sonarrApiProvider.future);
  if (api == null) {
    return null;
  }
  return SonarrRemoteDataSource(api: api);
});

/// Provider for Radarr remote data source (configured with service settings)
final radarrRemoteDataSourceProvider = FutureProvider<RadarrRemoteDataSource?>((ref) async {
  final api = await ref.watch(radarrApiProvider.future);
  if (api == null) {
    return null;
  }
  return RadarrRemoteDataSource(api: api);
});

/// Provider for series repository (Sonarr)
final seriesRepositoryProvider = FutureProvider<SeriesRepositoryImpl?>((ref) async {
  final dataSource = await ref.watch(sonarrRemoteDataSourceProvider.future);
  if (dataSource == null) {
    return null;
  }

  final cacheBox = ref.watch(mediaCacheBoxProvider);
  return SeriesRepositoryImpl(
    remoteDataSource: dataSource,
    cacheBox: cacheBox,
  );
});

/// Provider for movie repository (Radarr)
final movieRepositoryProvider = FutureProvider<MovieRepositoryImpl?>((ref) async {
  final dataSource = await ref.watch(radarrRemoteDataSourceProvider.future);
  if (dataSource == null) {
    return null;
  }

  final cacheBox = ref.watch(mediaCacheBoxProvider);
  return MovieRepositoryImpl(
    remoteDataSource: dataSource,
    cacheBox: cacheBox,
  );
});

/// Provider for all series
final allSeriesProvider = FutureProvider<List<MediaItem>>((ref) async {
  final repository = await ref.watch(seriesRepositoryProvider.future);
  if (repository == null) {
    throw Exception('Sonarr service not configured. Please configure in Settings.');
  }

  try {
    return await repository.getAllSeries();
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
  final repository = await ref.watch(movieRepositoryProvider.future);
  if (repository == null) {
    throw Exception('Radarr service not configured. Please configure in Settings.');
  }

  try {
    return await repository.getAllMovies();
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
  final repository = await ref.watch(seriesRepositoryProvider.future);
  if (repository == null) {
    return <MediaItem>[];
  }

  try {
    return await repository.getCachedSeries();
  } on CacheException catch (e) {
    throw Exception('Cache error: ${e.message}');
  } catch (e) {
    throw Exception('Unexpected error: ${e.toString()}');
  }
});

/// Provider for cached movies
final cachedMoviesProvider = FutureProvider<List<MediaItem>>((ref) async {
  final repository = await ref.watch(movieRepositoryProvider.future);
  if (repository == null) {
    return <MediaItem>[];
  }

  try {
    return await repository.getCachedMovies();
  } on CacheException catch (e) {
    throw Exception('Cache error: ${e.message}');
  } catch (e) {
    throw Exception('Unexpected error: ${e.toString()}');
  }
});

/// Provider for series by ID
final seriesProvider = FutureProvider.family<MediaItem, int>((ref, id) async {
  final repository = await ref.watch(seriesRepositoryProvider.future);
  if (repository == null) {
    throw Exception('Sonarr service not configured. Please configure in Settings.');
  }

  try {
    return await repository.getSeriesById(id);
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
  final repository = await ref.watch(movieRepositoryProvider.future);
  if (repository == null) {
    throw Exception('Radarr service not configured. Please configure in Settings.');
  }

  try {
    return await repository.getMovieById(id);
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

/// Provider for search results (searches both series and movies)
final searchResultsProvider = FutureProvider<List<MediaItem>>((ref) async {
  final query = ref.watch(searchQueryProvider);
  if (query.isEmpty) {
    return <MediaItem>[];
  }

  final seriesRepo = await ref.watch(seriesRepositoryProvider.future);
  final movieRepo = await ref.watch(movieRepositoryProvider.future);

  final results = <MediaItem>[];

  try {
    // Search series if Sonarr is configured
    if (seriesRepo != null) {
      final seriesResults = await seriesRepo.searchMedia(query);
      results.addAll(seriesResults);
    }

    // Search movies if Radarr is configured
    if (movieRepo != null) {
      final movieResults = await movieRepo.searchMedia(query);
      results.addAll(movieResults);
    }

    return results;
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

/// Provider for combined library (series + movies based on filter)
final libraryProvider = FutureProvider<List<MediaItem>>((ref) async {
  final filter = ref.watch(mediaTypeFilterProvider);

  try {
    if (filter == MediaType.series) {
      final repository = await ref.watch(seriesRepositoryProvider.future);
      if (repository == null) {
        throw Exception('Sonarr service not configured. Please configure in Settings.');
      }
      return await repository.getAllSeries();
    } else {
      final repository = await ref.watch(movieRepositoryProvider.future);
      if (repository == null) {
        throw Exception('Radarr service not configured. Please configure in Settings.');
      }
      return await repository.getAllMovies();
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

/// Provider for unified library (all media from all configured services)
final unifiedLibraryProvider = FutureProvider<List<MediaItem>>((ref) async {
  final seriesRepo = await ref.watch(seriesRepositoryProvider.future);
  final movieRepo = await ref.watch(movieRepositoryProvider.future);

  final allMedia = <MediaItem>[];

  try {
    // Get series if Sonarr is configured
    if (seriesRepo != null) {
      final series = await seriesRepo.getAllSeries();
      allMedia.addAll(series);
    }

    // Get movies if Radarr is configured
    if (movieRepo != null) {
      final movies = await movieRepo.getAllMovies();
      allMedia.addAll(movies);
    }

    if (allMedia.isEmpty && seriesRepo == null && movieRepo == null) {
      throw Exception('No media services configured. Please configure in Settings.');
    }

    // Sort by title
    allMedia.sort((a, b) => a.title.compareTo(b.title));

    return allMedia;
  } on ServerException catch (e) {
    throw Exception('Failed to load library: ${e.message}');
  } on NetworkException catch (e) {
    throw Exception('Network error: ${e.message}');
  } catch (e) {
    throw Exception('Unexpected error: ${e.toString()}');
  }
});
