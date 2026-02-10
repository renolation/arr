# Hive Database Implementation Summary

## What Was Implemented

### 1. Hive Models (lib/models/hive/)

Created comprehensive Hive-compatible models for local storage:

#### Enums (`enums.dart` - typeId: 100-199)
- `ServiceType` - radarr, sonarr, overseerr, downloadClient
- `MediaType` - series, movie
- `MediaStatus` - downloading, completed, missing, monitored, etc.
- `SeriesStatus` - continuing, ended, upcoming, deleted
- `DownloadClientType` - transmission, deluge, qbittorrent, etc.
- `ServiceSyncType` - series, movies, episodes, requests, queue, system
- `SyncStatus` - idle, syncing, success, error, cancelled, partial
- `HealthIssueType` - info, notice, warning, error

#### Supporting Models
- `ImageHive` (typeId: 110) - Optimized image storage with URL extraction
- `RatingsHive` (typeId: 111) - Media ratings storage

#### Configuration Models
- `ServiceConfig` (typeId: 120) - Service endpoint configuration
  - Stores baseUrl, port, enabled status, priority
  - API keys stored in flutter_secure_storage (NOT Hive)
  - Includes settings map for service-specific config

#### Media Models
- `MediaItem` (typeId: 130) - Unified cache for movies and TV shows
  - Composite keys: "series_{id}" or "movie_{id}"
  - Quick access to poster, backdrop URLs
  - Stores full metadata as JSON for flexibility
  - Factory methods: `fromSeries()`, `fromMovie()`

- `SeriesHive` (typeId: 140) - Detailed TV series data
  - All Sonarr series fields
  - Cached timestamp for staleness checking
  - Helper methods: `downloadProgress`, `hasAllEpisodes`
  - Image optimization with quick access URLs

- `MovieHive` (typeId: 150) - Detailed movie data
  - All Radarr movie fields
  - Release dates (cinemas, physical, digital)
  - Helper methods: `isDownloaded`, `isReleased`
  - Cached timestamp for staleness checking

- `EpisodeHive` (typeId: 160) - Episode data
  - Composite key: `{seriesId}_{seasonNumber}_{episodeNumber}`
  - Helper methods: `hasAired`, `isDownloaded`, `isUpcoming`
  - Formatted episode number: "S01E05"
  - Size and quality information

#### Settings & State Models
- `AppSettings` (typeId: 170) - Application preferences
  - Theme, sync, cache settings
  - Grid layout preferences
  - Display options (show year, ratings, etc.)

- `SyncState` (typeId: 180) - Sync tracking
  - Per-service sync state
  - Failed attempts tracking with exponential backoff
  - Sync progress monitoring
  - Automatic sync scheduling based on type

- `SystemStatus` (typeId: 190) - System health
  - Service version and status
  - Disk space information
  - Health issues with wiki links
  - Download/upload speeds

### 2. Database Manager (lib/core/database/hive_database.dart)

Enhanced the existing `HiveDatabase` class with:

#### Box Management
- `servicesBox` - Service configurations
- `mediaUnifiedBox` - Unified media cache
- `sonarrCacheBox` - TV series cache
- `radarrCacheBox` - Movie cache
- `episodeCacheBox` - Episode cache
- `overseerrCacheBox` - Overseerr cache (dynamic)
- `downloadQueueBox` - Download queue (dynamic)
- `settingsBox` - App settings
- `syncStateBox` - Sync states
- `systemStatusBox` - System statuses

#### Features
- **Initialization**: Single `init()` call to setup everything
- **Adapter Registration**: All 23 adapters auto-registered
- **Box Access**: Type-safe box getter methods
- **Cache Management**: Clear all, per-service, or per-type
- **Statistics**: Get database stats and monitor growth
- **Compaction**: Manual database compaction for space savings
- **Error Handling**: Comprehensive error catching and logging

### 3. Storage Service (lib/core/storage/storage_service.dart)

Created a high-level storage service with:

#### Singleton Pattern
```dart
final storage = StorageService.instance;
```

#### Service Configuration Methods
- `getAllServices()` - List all services
- `getServicesByType(type)` - Filter by type
- `getEnabledServices()` - Get enabled only
- `getService(id)` - Get specific service
- `addService(service)` - Add new service
- `updateService(service)` - Update existing
- `deleteService(id)` - Delete and clear cache

#### Media Operations (Unified Box)
- `getAllMedia()` - All media items
- `getMediaByType(type)` - Filter by type
- `getMediaByService(serviceId)` - Filter by service
- `getMediaItem(id)` - Get specific item
- `searchMedia(query)` - Search by title
- `putMediaItem(item)` - Store single item
- `putMediaItems(items)` - Batch store

#### Series Operations
- `getAllSeries()` - All series
- `getSeriesByService(serviceId)` - Filter by service
- `getSeries(id)` - Get by ID
- `putSeries(series)` - Store single
- `putSeriesList(seriesList)` - Batch store
- `getMonitoredSeries()` - Filtered query
- `getContinuingSeries()` - Filtered query

#### Movie Operations
- `getAllMovies()` - All movies
- `getMoviesByService(serviceId)` - Filter by service
- `getMovie(id)` - Get by ID
- `putMovie(movie)` - Store single
- `putMovieList(movieList)` - Batch store
- `getDownloadedMovies()` - Filtered query
- `getMonitoredMovies()` - Filtered query
- `getUpcomingMovies()` - Filtered query

#### Episode Operations
- `getAllEpisodes()` - All episodes
- `getEpisodesBySeries(seriesId)` - Filter by series
- `getEpisodesBySeason(seriesId, seasonNumber)` - Filter by season
- `getEpisode(seriesId, seasonNumber, episodeNumber)` - Get specific
- `putEpisode(episode)` - Store single
- `putEpisodeList(episodeList)` - Batch store
- `getMissingEpisodes(seriesId)` - Filtered query

#### Settings Operations
- `getSettings()` - Get app settings
- `saveSettings(settings)` - Save settings

#### Sync State Operations
- `getSyncState(serviceId, syncType)` - Get sync state
- `getSyncStates(serviceId)` - Get all states for service
- `updateSyncState(state)` - Update sync state
- `getStaleSyncStates()` - Get states needing sync

#### System Status Operations
- `getSystemStatus(serviceId)` - Get system status
- `updateSystemStatus(status)` - Update system status
- `getAllSystemStatuses()` - Get all statuses

#### Utility Methods
- `clearAllCache()` - Clear all cached data
- `getStats()` - Get storage statistics
- `dispose()` - Release box references

### 4. Generated Type Adapters

All Hive models have generated `.g.dart` files with:
- `HiveObject` extensions for automatic key management
- `Adapter` classes for serialization/deserialization
- Efficient binary serialization for performance

### 5. Documentation

#### Schema Documentation (HIVE_SCHEMA.md)
Comprehensive documentation including:
- Box overview and schema definitions
- Type adapter ID allocation
- Enum definitions
- Supporting model details
- Performance optimization strategies
- Security considerations
- Migration strategies
- Troubleshooting guide
- Best practices

#### Quick Reference (lib/core/storage/README.md)
Practical usage guide with:
- Common usage patterns
- API conversion examples
- Riverpod integration examples
- Performance tips
- Error handling patterns
- Testing patterns
- Debugging techniques

## Key Features

### 1. Unified Media Caching
- Single `MediaItem` model for both movies and TV shows
- Consistent interface for browsing all media
- Optimized for grid views and search

### 2. Flexible Data Storage
- Full API data preserved in `metadata` field
- Quick access to frequently used fields
- Optimized image URL extraction

### 3. Smart Sync Management
- Automatic sync scheduling based on data type
- Failed attempt tracking with exponential backoff
- Progress monitoring for large syncs
- Staleness detection

### 4. System Health Monitoring
- Track service versions and status
- Disk space monitoring
- Health issue tracking with wiki links
- Download/upload speed tracking

### 5. Performance Optimizations
- Batch operations for better performance
- Efficient key strategies
- Lazy loading support
- Database compaction
- Statistics monitoring

### 6. Developer Experience
- Type-safe storage operations
- Comprehensive error handling
- Singleton storage service
- Riverpod integration examples
- Extensive documentation

## Type Adapter ID Allocation

```
100-109: Enums
├── 100: ServiceType
├── 101: MediaType
├── 102: MediaStatus
├── 103: SeriesStatus
├── 104: DownloadClientType
├── 181: ServiceSyncType
├── 182: SyncStatus
└── 193: HealthIssueType

110-119: Supporting Models
├── 110: ImageHive
└── 111: RatingsHive

120-129: Configuration
└── 120: ServiceConfig

130-139: Unified Models
└── 130: MediaItem

140-149: Series Models
└── 140: SeriesHive

150-159: Movie Models
└── 150: MovieHive

160-169: Episode Models
└── 160: EpisodeHive

170-179: Settings
└── 170: AppSettings

180-189: Sync State
├── 180: SyncState
├── 181: ServiceSyncType
└── 182: SyncStatus

190-199: System Status
├── 190: SystemStatus
├── 191: DiskSpaceInfo
├── 192: HealthIssue
├── 193: HealthIssueType
└── 194: WikiLink
```

## Usage Example

### Initialize in main.dart
```dart
import 'package:arr/core/database/hive_database.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await HiveDatabase.init();
  runApp(MyApp());
}
```

### Use Storage Service
```dart
import 'package:arr/core/storage/storage_service.dart';

class MyRepository {
  final _storage = StorageService.instance;

  Future<void> cacheSeries(List<Map<String, dynamic>> apiData) async {
    final seriesList = apiData.map((data) => SeriesHive.fromJson(
      json: data,
      serviceId: 'my-sonarr',
    )).toList();

    await _storage.putSeriesList(seriesList);
  }

  Future<List<SeriesHive>> getMonitoredSeries() async {
    return _storage.getMonitoredSeries();
  }
}
```

## Benefits

1. **Offline-First Architecture**: All data cached locally
2. **Performance**: Quick access to cached data
3. **Type Safety**: Compile-time type checking
4. **Flexibility**: Store both structured and raw JSON data
5. **Scalability**: Handle large media libraries efficiently
6. **Maintainability**: Well-organized, documented code
7. **Testing**: Easy to test with predictable data storage
8. **Migration**: Clear strategy for schema changes

## Next Steps

1. **API Integration**: Connect to Sonarr/Radarr APIs
2. **Repository Layer**: Implement repository pattern
3. **Riverpod Providers**: Create state management providers
4. **UI Implementation**: Build views using cached data
5. **Sync Logic**: Implement background sync
6. **Error Handling**: Add comprehensive error handling
7. **Testing**: Write unit and integration tests
8. **Performance**: Optimize based on real-world usage

## Files Created/Modified

### Created
- `/Users/phuocnguyen/Projects/arr/lib/models/hive/models.dart` - Export file
- `/Users/phuocnguyen/Projects/arr/lib/models/hive/enums.dart` - Enum definitions
- `/Users/phuocnguyen/Projects/arr/lib/models/hive/image_hive.dart` - Image model
- `/Users/phuocnguyen/Projects/arr/lib/models/hive/ratings_hive.dart` - Ratings model
- `/Users/phuocnguyen/Projects/arr/lib/models/hive/service_config.dart` - Service config
- `/Users/phuocnguyen/Projects/arr/lib/models/hive/media_item.dart` - Unified media
- `/Users/phuocnguyen/Projects/arr/lib/models/hive/series_hive.dart` - Series model
- `/Users/phuocnguyen/Projects/arr/lib/models/hive/movie_hive.dart` - Movie model
- `/Users/phuocnguyen/Projects/arr/lib/models/hive/episode_hive.dart` - Episode model
- `/Users/phuocnguyen/Projects/arr/lib/models/hive/app_settings.dart` - Settings
- `/Users/phuocnguyen/Projects/arr/lib/models/hive/sync_state.dart` - Sync state
- `/Users/phuocnguyen/Projects/arr/lib/models/hive/system_status.dart` - System status
- `/Users/phuocnguyen/Projects/arr/lib/core/storage/storage_service.dart` - Storage service
- `/Users/phuocnguyen/Projects/arr/lib/core/storage/README.md` - Quick reference
- `/Users/phuocnguyen/Projects/arr/HIVE_SCHEMA.md` - Full schema documentation

### Generated (by build_runner)
- All `*.g.dart` files for Hive models

### Modified
- `/Users/phuocnguyen/Projects/arr/lib/core/database/hive_database.dart` - Enhanced
- `/Users/phuocnguyen/Projects/arr/lib/features/settings/presentation/providers/service_provider.dart` - Fixed imports
- `/Users/phuocnguyen/Projects/arr/lib/features/library/domain/entities/media_item.dart` - Fixed syntax
- `/Users/phuocnguyen/Projects/arr/lib/features/requests/data/datasources/overseerr_remote_datasource.dart` - Fixed async

## Dependencies Used

- `hive: ^2.2.3` - Core Hive database
- `hive_flutter: ^1.1.0` - Flutter integration
- `hive_generator: ^2.0.1` - Code generation
- `build_runner: ^2.4.8` - Build tool for code generation
- `flutter_secure_storage: ^9.0.0` - Secure API key storage

## Conclusion

This implementation provides a robust, scalable, and well-documented Hive database schema for the *arr Stack Management App. The architecture supports offline-first functionality, efficient caching, and flexible data storage for managing Sonarr, Radarr, and other *arr services.

The storage service abstraction layer provides a clean API for data access, while the comprehensive documentation ensures easy maintenance and future enhancements.
