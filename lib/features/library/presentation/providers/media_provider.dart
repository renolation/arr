import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:arr/models/hive/app_settings.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/network/api_providers.dart';
import '../../../../core/theme/theme_provider.dart';
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

/// Sort field options for library
enum SortField { title, year, rating }

/// Library filter state
class LibraryFilter {
  final Set<MediaType> mediaTypes;
  final Set<MediaStatus> statuses;
  final Set<String> serviceTypes; // 'sonarr' or 'radarr'

  const LibraryFilter({
    this.mediaTypes = const {},
    this.statuses = const {},
    this.serviceTypes = const {},
  });

  bool get isActive =>
      mediaTypes.isNotEmpty || statuses.isNotEmpty || serviceTypes.isNotEmpty;

  LibraryFilter copyWith({
    Set<MediaType>? mediaTypes,
    Set<MediaStatus>? statuses,
    Set<String>? serviceTypes,
  }) {
    return LibraryFilter(
      mediaTypes: mediaTypes ?? this.mediaTypes,
      statuses: statuses ?? this.statuses,
      serviceTypes: serviceTypes ?? this.serviceTypes,
    );
  }
}

/// Library sort state
class LibrarySort {
  final SortField field;
  final bool ascending;

  const LibrarySort({this.field = SortField.title, this.ascending = true});

  LibrarySort copyWith({SortField? field, bool? ascending}) {
    return LibrarySort(
      field: field ?? this.field,
      ascending: ascending ?? this.ascending,
    );
  }
}

/// Provider for library filter state (persisted to Hive settings)
final libraryFilterProvider = StateNotifierProvider<LibraryFilterNotifier, LibraryFilter>((ref) {
  final settingsBox = ref.watch(settingsBoxProvider);
  return LibraryFilterNotifier(settingsBox);
});

class LibraryFilterNotifier extends StateNotifier<LibraryFilter> {
  static const _key = 'app_settings';
  final Box<AppSettings> _settingsBox;

  LibraryFilterNotifier(this._settingsBox) : super(const LibraryFilter()) {
    _loadFromSettings();
  }

  void _loadFromSettings() {
    final settings = _settingsBox.get(_key);
    if (settings == null) return;
    state = LibraryFilter(
      mediaTypes: settings.filterMediaTypes
          .map((s) => MediaType.values.firstWhere((e) => e.name == s, orElse: () => MediaType.movie))
          .whereType<MediaType>()
          .toSet(),
      statuses: settings.filterStatuses
          .map((s) => MediaStatus.values.firstWhere((e) => e.name == s, orElse: () => MediaStatus.continuing))
          .whereType<MediaStatus>()
          .toSet(),
      serviceTypes: settings.filterServiceTypes.toSet(),
    );
  }

  void _saveToSettings() {
    final current = _settingsBox.get(_key) ?? AppSettings.defaultSettings;
    final updated = current.copyWith(
      filterMediaTypes: state.mediaTypes.map((e) => e.name).toList(),
      filterStatuses: state.statuses.map((e) => e.name).toList(),
      filterServiceTypes: state.serviceTypes.toList(),
    );
    _settingsBox.put(_key, updated);
  }

  set filter(LibraryFilter value) {
    state = value;
    _saveToSettings();
  }
}

/// Provider for library sort state (persisted to Hive settings)
final librarySortProvider = StateNotifierProvider<LibrarySortNotifier, LibrarySort>((ref) {
  final settingsBox = ref.watch(settingsBoxProvider);
  return LibrarySortNotifier(settingsBox);
});

class LibrarySortNotifier extends StateNotifier<LibrarySort> {
  static const _key = 'app_settings';
  final Box<AppSettings> _settingsBox;

  LibrarySortNotifier(this._settingsBox) : super(const LibrarySort()) {
    _loadFromSettings();
  }

  void _loadFromSettings() {
    final settings = _settingsBox.get(_key);
    if (settings == null) return;
    final field = SortField.values.firstWhere(
      (e) => e.name == settings.sortBy,
      orElse: () => SortField.title,
    );
    state = LibrarySort(
      field: field,
      ascending: settings.sortOrder == 'asc',
    );
  }

  void _saveToSettings() {
    final current = _settingsBox.get(_key) ?? AppSettings.defaultSettings;
    final updated = current.copyWith(
      sortBy: state.field.name,
      sortOrder: state.ascending ? 'asc' : 'desc',
    );
    _settingsBox.put(_key, updated);
  }

  set sort(LibrarySort value) {
    state = value;
    _saveToSettings();
  }
}

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
    // Watch filter and sort so we rebuild when they change
    ref.watch(libraryFilterProvider);
    ref.watch(librarySortProvider);

    // Only re-fetch if cache is empty (filter/sort changes reuse cache)
    if (_allMedia.isEmpty) {
      await _fetchAll();
    }
    return _applyFilterAndSort();
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

  List<MediaItem> _applyFilterAndSort() {
    final filter = ref.read(libraryFilterProvider);
    final sort = ref.read(librarySortProvider);

    var result = List<MediaItem>.from(_allMedia);

    // Apply media type filter
    if (filter.mediaTypes.isNotEmpty) {
      result = result.where((item) => filter.mediaTypes.contains(item.type)).toList();
    }

    // Apply status filter
    if (filter.statuses.isNotEmpty) {
      result = result.where((item) => filter.statuses.contains(item.status)).toList();
    }

    // Apply service type filter (match serviceKey prefix: 'sonarr' or 'radarr')
    if (filter.serviceTypes.isNotEmpty) {
      result = result.where((item) {
        final key = item.serviceKey?.toLowerCase() ?? '';
        return filter.serviceTypes.any((st) => key.startsWith(st.toLowerCase()));
      }).toList();
    }

    // Apply sort
    result.sort((a, b) {
      int cmp;
      switch (sort.field) {
        case SortField.title:
          cmp = a.title.toLowerCase().compareTo(b.title.toLowerCase());
        case SortField.year:
          cmp = (a.year ?? 0).compareTo(b.year ?? 0);
        case SortField.rating:
          cmp = (a.rating ?? 0).compareTo(b.rating ?? 0);
      }
      return sort.ascending ? cmp : -cmp;
    });

    return result;
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
