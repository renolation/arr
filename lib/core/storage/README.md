// ========================================
// Hive Storage Quick Reference
// ========================================

## Common Usage Patterns

### 1. Initialize Hive (in main.dart)
```dart
import 'package:arr/core/database/hive_database.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await HiveDatabase.init();
  runApp(MyApp());
}
```

### 2. Access Storage Service
```dart
import 'package:arr/core/storage/storage_service.dart';

final storage = StorageService.instance;
```

### 3. Service Configuration Operations

#### Get All Services
```dart
final services = storage.getAllServices();
final sonarrServices = storage.getServicesByType(ServiceType.sonarr);
final enabledServices = storage.getEnabledServices();
```

#### Add/Update Service
```dart
final service = ServiceConfig(
  id: ServiceConfig.generateId(),
  name: 'My Sonarr',
  type: ServiceType.sonarr,
  baseUrl: 'http://localhost:8989',
  isEnabled: true,
);
await storage.addService(service);
```

#### Delete Service
```dart
await storage.deleteService(serviceId);
```

### 4. Media Operations

#### Get Media Items
```dart
// Get all media
final allMedia = storage.getAllMedia();

// Get by type
final series = storage.getMediaByType(MediaType.series);
final movies = storage.getMediaByType(MediaType.movie);

// Get by service
final serviceMedia = storage.getMediaByService(serviceId);

// Search
final results = storage.searchMedia('query');
```

#### Store Media Items
```dart
// Single item
await storage.putMediaItem(mediaItem);

// Batch items
await storage.putMediaItems(mediaItemList);
```

### 5. Series Operations

#### Get Series
```dart
// All series
final allSeries = storage.getAllSeries();

// By service
final serviceSeries = storage.getSeriesByService(serviceId);

// By ID
final series = storage.getSeries(seriesId);

// Filtered
final monitored = storage.getMonitoredSeries();
final continuing = storage.getContinuingSeries();
```

#### Store Series
```dart
// Single series
await storage.putSeries(seriesHive);

// Batch series
await storage.putSeriesList(seriesList);
```

### 6. Movie Operations

#### Get Movies
```dart
// All movies
final allMovies = storage.getAllMovies();

// By service
final serviceMovies = storage.getMoviesByService(serviceId);

// By ID
final movie = storage.getMovie(movieId);

// Filtered
final downloaded = storage.getDownloadedMovies();
final monitored = storage.getMonitoredMovies();
final upcoming = storage.getUpcomingMovies();
```

#### Store Movies
```dart
// Single movie
await storage.putMovie(movieHive);

// Batch movies
await storage.putMovieList(movieList);
```

### 7. Episode Operations

#### Get Episodes
```dart
// All episodes
final allEpisodes = storage.getAllEpisodes();

// By series
final seriesEpisodes = storage.getEpisodesBySeries(seriesId);

// By season
final seasonEpisodes = storage.getEpisodesBySeason(seriesId, seasonNumber);

// By composite key
final episode = storage.getEpisode(seriesId, seasonNumber, episodeNumber);

// Missing episodes
final missing = storage.getMissingEpisodes(seriesId);
```

#### Store Episodes
```dart
// Single episode
await storage.putEpisode(episodeHive);

// Batch episodes
await storage.putEpisodeList(episodeList);
```

### 8. Settings Operations

#### Get/Save Settings
```dart
// Get settings
final settings = storage.getSettings();

// Save settings
await storage.saveSettings(AppSettings(
  themeMode: 'dark',
  backgroundSync: true,
));
```

### 9. Sync State Operations

#### Get/Update Sync State
```dart
// Get sync state
final syncState = storage.getSyncState(serviceId, ServiceSyncType.series);

// Update sync state
await storage.updateSyncState(SyncState(
  serviceId: serviceId,
  syncType: ServiceSyncType.series,
  status: SyncStatus.syncing,
  itemsSynced: 0,
  totalItems: 100,
));
```

#### Get Stale Sync States
```dart
final staleStates = storage.getStaleSyncStates();
```

### 10. System Status Operations

#### Get/Update System Status
```dart
// Get system status
final status = storage.getSystemStatus(serviceId);

// Update system status
await storage.updateSystemStatus(SystemStatus(
  serviceId: serviceId,
  version: '4.0.0',
  diskSpace: DiskSpaceInfo(
    free: 100.0,
    total: 500.0,
  ),
));
```

## API Response to Hive Conversion

### Convert Series API Response
```dart
import 'package:arr/models/hive/series_hive.dart';

final seriesHive = SeriesHive.fromJson(
  json: apiResponseData,
  serviceId: serviceId,
);

await storage.putSeries(seriesHive);
```

### Convert Movie API Response
```dart
import 'package:arr/models/hive/movie_hive.dart';

final movieHive = MovieHive.fromJson(
  json: apiResponseData,
  serviceId: serviceId,
);

await storage.putMovie(movieHive);
```

### Convert Episode API Response
```dart
import 'package:arr/models/hive/episode_hive.dart';

final episodeHive = EpisodeHive.fromJson(
  json: apiResponseData,
  serviceId: serviceId,
);

await storage.putEpisode(episodeHive);
```

### Convert to MediaItem (Unified)
```dart
import 'package:arr/models/hive/media_item.dart';

// From series
final mediaItem = MediaItem.fromSeries(
  series: apiSeriesData,
  serviceId: serviceId,
);

// From movie
final mediaItem = MediaItem.fromMovie(
  movie: apiMovieData,
  serviceId: serviceId,
);

await storage.putMediaItem(mediaItem);
```

## Cache Management

### Clear All Cache
```dart
await HiveDatabase.clearMediaCache();
```

### Clear Service-Specific Cache
```dart
await HiveDatabase.clearServiceCache(serviceId);
```

### Get Database Statistics
```dart
final stats = storage.getStats();
print('Services: ${stats['services']}');
print('Media: ${stats['media']}');
print('Series: ${stats['series']}');
print('Movies: ${stats['movies']}');
print('Episodes: ${stats['episodes']}');
```

## Working with Riverpod

### Create a Storage Provider
```dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:arr/core/storage/storage_service.dart';

final storageServiceProvider = Provider<StorageService>((ref) {
  return StorageService.instance;
});

final allSeriesProvider = FutureProvider.autoDispose<List<SeriesHive>>((ref) async {
  final storage = ref.watch(storageServiceProvider);
  return storage.getAllSeries();
});
```

### Use in Widget
```dart
class SeriesListWidget extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final seriesAsync = ref.watch(allSeriesProvider);

    return seriesAsync.when(
      data: (series) => ListView.builder(
        itemCount: series.length,
        itemBuilder: (context, index) => SeriesCard(series: series[index]),
      ),
      loading: () => CircularProgressIndicator(),
      error: (err, stack) => Text('Error: $err'),
    );
  }
}
```

## Performance Tips

1. **Batch Operations**: Use batch methods when storing multiple items
   ```dart
   await storage.putSeriesList(seriesList); // Good
   for (final s in seriesList) await storage.putSeries(s); // Bad
   ```

2. **Lazy Loading**: Don't load all data at once
   ```dart
   // Good: Load paginated
   final page = storage.getAllSeries().skip(offset).take(limit);

   // Bad: Load everything
   final all = storage.getAllSeries();
   ```

3. **Filter at Source**: Use Hive's built-in filtering
   ```dart
   // Good: Filter in storage
   final monitored = storage.getMonitoredSeries();

   // Bad: Filter after loading
   final all = storage.getAllSeries();
   final monitored = all.where((s) => s.monitored == true).toList();
   ```

4. **Use Composite Keys**: For nested data
   ```dart
   // Good: Use composite key for episodes
   final episode = storage.getEpisode(seriesId, season, episode);

   // Bad: Search through all episodes
   final all = storage.getAllEpisodes();
   final episode = all.firstWhere(...);
   ```

## Error Handling

### Wrap Storage Operations
```dart
try {
  await storage.putSeries(seriesHive);
} catch (e) {
  // Handle error
  print('Error saving series: $e');
}
```

### Check for Null Values
```dart
final series = storage.getSeries(seriesId);
if (series != null) {
  // Process series
} else {
  // Handle not found
}
```

## Testing with Hive

### Setup Test Environment
```dart
import 'package:hive/hive.dart';
import 'package:hive_test/hive_test.dart';

void main() {
  setUp(() async {
    // Initialize Hive test environment
    await setUpTestHive();
    await HiveDatabase.init();
  });

  tearDown(() async {
    // Clean up
    await tearDownTestHive();
  });

  test('storage operations', () {
    // Test code here
  });
}
```

## Debugging

### Enable Hive Logging
```dart
import 'package:hive/hive.dart';

void main() async {
  // Enable debug logging
  Hive.init('./hive_debug');

  await HiveDatabase.init();
  runApp(MyApp());
}
```

### Inspect Box Contents
```dart
// Print all keys in a box
final box = Hive.box<SeriesHive>(HiveDatabase.sonarrCacheBox);
print('Keys: ${box.keys.toList()}');
print('Length: ${box.length}');

// Print specific item
final series = box.get(seriesId);
print('Series: ${series?.toJson()}');
```

## Common Patterns

### Repository Pattern Implementation
```dart
class SeriesRepository {
  final StorageService _storage;

  SeriesRepository(this._storage);

  Future<List<SeriesHive>> getAllSeries() async {
    return _storage.getAllSeries();
  }

  Future<List<SeriesHive>> getMonitoredSeries() async {
    return _storage.getMonitoredSeries();
  }

  Future<void> cacheSeries(List<SeriesHive> series) async {
    await _storage.putSeriesList(series);
  }

  Future<bool> isCacheValid() async {
    final series = _storage.getAllSeries();
    if (series.isEmpty) return false;

    final latest = series
        .map((s) => s.cachedAt)
        .whereType<DateTime>()
        .reduce((a, b) => a.isAfter(b) ? a : b);

    return DateTime.now().difference(latest) < Duration(hours: 6);
  }
}
```

### Background Sync Pattern
```dart
Future<void> syncSeries(String serviceId) async {
  final storage = StorageService.instance;

  // Update sync state
  await storage.updateSyncState(SyncState(
    serviceId: serviceId,
    syncType: ServiceSyncType.series,
    status: SyncStatus.syncing,
  ));

  try {
    // Fetch from API
    final apiSeries = await fetchSeriesFromAPI(serviceId);

    // Convert and cache
    final hiveSeries = apiSeries.map((s) => SeriesHive.fromJson(
      json: s,
      serviceId: serviceId,
    )).toList();

    await storage.putSeriesList(hiveSeries);

    // Update sync state
    await storage.updateSyncState(SyncState(
      serviceId: serviceId,
      syncType: ServiceSyncType.series,
      status: SyncStatus.success,
      itemsSynced: hiveSeries.length,
      lastSuccessfulSync: DateTime.now(),
    ));
  } catch (e) {
    // Update sync state with error
    await storage.updateSyncState(SyncState(
      serviceId: serviceId,
      syncType: ServiceSyncType.series,
      status: SyncStatus.error,
      errorMessage: e.toString(),
    ));
  }
}
```
