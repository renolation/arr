import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/network/api_providers.dart';
import '../../data/datasources/media_remote_datasource.dart';
import '../../data/repositories/media_repository.dart';
import '../../domain/entities/media_item.dart';

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

  return SeriesRepositoryImpl(
    remoteDataSource: dataSource,
  );
});

/// Provider for movie repository (Radarr)
final movieRepositoryProvider = FutureProvider<MovieRepositoryImpl?>((ref) async {
  final dataSource = await ref.watch(radarrRemoteDataSourceProvider.future);
  if (dataSource == null) {
    return null;
  }

  return MovieRepositoryImpl(
    remoteDataSource: dataSource,
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

/// Provider for selected media type filter (null = All)
final mediaTypeFilterProvider = StateProvider<MediaType?>((ref) => null);

/// Unified library notifier - fetches from ALL configured service instances
class UnifiedLibraryNotifier extends AsyncNotifier<List<MediaItem>> {
  List<MediaItem> _allMedia = [];
  List<String> _errors = [];

  /// Errors from individual services (partial failure info)
  List<String> get errors => _errors;

  /// All media items (unfiltered) for stats/overview use
  List<MediaItem> get allMedia => List.unmodifiable(_allMedia);

  @override
  Future<List<MediaItem>> build() async {
    // Watch the filter so we rebuild when it changes
    ref.watch(mediaTypeFilterProvider);

    // Only re-fetch if cache is empty (filter changes reuse cache)
    if (_allMedia.isEmpty) {
      await _fetchAll();
    }
    return _applyFilter();
  }

  Future<void> _fetchAll() async {
    final sonarrApis = await ref.read(allSonarrApisProvider.future);
    final radarrApis = await ref.read(allRadarrApisProvider.future);

    if (sonarrApis.isEmpty && radarrApis.isEmpty) {
      throw Exception('No media services configured. Please configure in Settings.');
    }

    _allMedia = [];
    _errors = [];

    // Fetch from all services in parallel with error isolation
    final futures = <Future<List<MediaItem>>>[];

    for (final (serviceKey, api) in sonarrApis) {
      futures.add(_fetchSeries(serviceKey, api));
    }
    for (final (serviceKey, api) in radarrApis) {
      futures.add(_fetchMovies(serviceKey, api));
    }

    final results = await Future.wait(futures);
    for (final result in results) {
      _allMedia.addAll(result);
    }

    _allMedia.sort((a, b) => a.title.compareTo(b.title));
  }

  Future<List<MediaItem>> _fetchSeries(String serviceKey, dynamic api) async {
    try {
      final seriesData = await api.getSeries() as List<Map<String, dynamic>>;
      return seriesData
          .map((data) => MediaItem.fromJson(data, serviceKey: serviceKey))
          .toList();
    } catch (e) {
      _errors.add('Sonarr ($serviceKey): $e');
      return [];
    }
  }

  Future<List<MediaItem>> _fetchMovies(String serviceKey, dynamic api) async {
    try {
      final moviesData = await api.getMovies() as List<Map<String, dynamic>>;
      return moviesData
          .map((data) => MediaItem.fromJson(data, serviceKey: serviceKey))
          .toList();
    } catch (e) {
      _errors.add('Radarr ($serviceKey): $e');
      return [];
    }
  }

  List<MediaItem> _applyFilter() {
    final filter = ref.read(mediaTypeFilterProvider);
    if (filter == null) return List.unmodifiable(_allMedia);
    return _allMedia.where((item) => item.type == filter).toList();
  }

  /// Force refresh from all services
  Future<void> refresh() async {
    _allMedia = [];
    ref.invalidateSelf();
  }
}

/// Provider for unified library (all media from all configured services)
final unifiedLibraryProvider =
    AsyncNotifierProvider<UnifiedLibraryNotifier, List<MediaItem>>(
  UnifiedLibraryNotifier.new,
);
