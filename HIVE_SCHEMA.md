# Hive Database Schema Documentation

## Overview

This document describes the Hive database schema for the *arr Stack Management App. Hive is used for local caching of media data and application settings.

## Architecture

### Database Manager
- **Location**: `/Users/phuocnguyen/Projects/arr/lib/core/database/hive_database.dart`
- **Purpose**: Centralized initialization and management of Hive boxes and adapters
- **Key Methods**:
  - `init()`: Initialize Hive, register adapters, and open boxes
  - `close()`: Close all boxes
  - `clearCache()`: Clear media cache
  - `getStats()`: Get database statistics

### Storage Service
- **Location**: `/Users/phuocnguyen/Projects/arr/lib/core/storage/storage_service.dart`
- **Purpose**: High-level interface for accessing Hive boxes
- **Pattern**: Singleton with convenient methods for CRUD operations

## Boxes Overview

### 1. servicesBox
**Box Name**: `'servicesBox'`
**Type**: `Box<ServiceConfig>`
**Purpose**: Store service configurations (Radarr, Sonarr, Overseerr, Download Clients)

**Schema**: `ServiceConfig` (typeId: 120)

| Field | Type | Description |
|-------|------|-------------|
| id | String | Unique service identifier (UUID) |
| name | String | User-friendly name |
| type | ServiceType | radarr, sonarr, overseerr, downloadClient |
| baseUrl | String | API endpoint URL |
| applicationUrl | String? | Optional application URL |
| port | int? | Optional port number |
| isEnabled | bool | Whether service is enabled |
| lastSync | DateTime? | Last successful sync timestamp |
| priority | int? | Service priority for ordering |
| settings | Map<String, dynamic>? | Additional service-specific settings |

**Security Note**: API keys are stored in `flutter_secure_storage`, NOT in Hive. The `apiKeyRef` field provides a reference key for secure storage.

### 2. mediaUnifiedBox
**Box Name**: `'mediaUnifiedBox'`
**Type**: `Box<MediaItem>`
**Purpose**: Unified cache for both movies and TV series (merged view)

**Schema**: `MediaItem` (typeId: 130)

| Field | Type | Description |
|-------|------|-------------|
| id | String | Composite key: "series_{id}" or "movie_{id}" |
| type | MediaType | series or movie |
| seriesId | int? | TV series ID (for series) |
| movieId | int? | Movie ID (for movies) |
| title | String | Media title |
| sortTitle | String? | Title for sorting |
| posterUrl | String? | Poster image URL |
| backdropUrl | String? | Backdrop image URL |
| year | int? | Release year |
| status | MediaStatus? | Current status |
| overview | String? | Plot summary |
| added | DateTime? | When added to library |
| lastUpdated | DateTime? | Last update timestamp |
| monitored | bool? | Whether monitored |
| sizeOnDisk | int? | Size in bytes |
| ratings | RatingsHive? | Ratings data |
| genres | List<String>? | Genre list |
| certification | String? | Content rating |
| runtime | int? | Runtime in minutes |
| serviceId | String? | Source service ID |
| metadata | Map<String, dynamic>? | Full API data as JSON |

### 3. sonarrCacheBox
**Box Name**: `'sonarrCacheBox'`
**Type**: `Box<SeriesHive>`
**Purpose**: Detailed TV series data from Sonarr

**Schema**: `SeriesHive` (typeId: 140)

| Field | Type | Description |
|-------|------|-------------|
| id | int? | Series ID |
| title | String? | Series title |
| sortTitle | String? | Sort title |
| status | SeriesStatus? | continuing, ended, upcoming, deleted |
| overview | String? | Plot summary |
| network | String? | TV network |
| airTime | String? | Air time |
| images | List<ImageHive>? | Image list |
| seasonCount | int? | Number of seasons |
| totalEpisodeCount | int? | Total episodes |
| episodeCount | int? | Episode count |
| episodeFileCount | int? | Episodes with files |
| sizeOnDisk | int? | Total size in bytes |
| seriesType | String? | Standard or Daily |
| added | DateTime? | When added |
| qualityProfileId | int? | Quality profile ID |
| languageProfileId | int? | Language profile ID |
| runtime | int? | Runtime in minutes |
| tvdbId | int? | TVDB ID |
| tvMazeId | int? | TVMaze ID |
| firstAired | DateTime? | First air date |
| lastInfoSync | DateTime? | Last info sync |
| cleanTitle | String? | Clean title |
| imdbId | String? | IMDB ID |
| titleSlug | String? | URL slug |
| rootFolderPath | String? | Root folder path |
| certification | String? | Content rating |
| genres | List<String>? | Genres |
| tags | List<String>? | Tags |
| monitored | bool? | Monitoring status |
| year | int? | Year |
| ratings | RatingsHive? | Ratings data |
| posterUrl | String? | Quick access poster URL |
| backdropUrl | String? | Quick access backdrop URL |
| serviceId | String? | Source service |
| cachedAt | DateTime? | Cache timestamp |

### 4. radarrCacheBox
**Box Name**: `'radarrCacheBox'`
**Type**: `Box<MovieHive>`
**Purpose**: Detailed movie data from Radarr

**Schema**: `MovieHive` (typeId: 150)

| Field | Type | Description |
|-------|------|-------------|
| id | int? | Movie ID |
| title | String? | Movie title |
| sortTitle | String? | Sort title |
| sizeOnDisk | int? | Size in bytes |
| status | String? | Download status |
| overview | String? | Plot summary |
| inCinemas | DateTime? | Cinema release date |
| physicalRelease | DateTime? | Physical release date |
| digitalRelease | DateTime? | Digital release date |
| images | List<ImageHive>? | Image list |
| website | String? | Website URL |
| downloaded | bool? | Downloaded status |
| year | int? | Release year |
| hasFile | bool? | Has file status |
| youTubeTrailerId | String? | Trailer ID |
| studio | String? | Studio name |
| path | String? | File path |
| qualityProfileId | int? | Quality profile ID |
| monitored | bool? | Monitoring status |
| minimumAvailability | String? | Minimum availability |
| isAvailable | bool? | Availability status |
| folderName | String? | Folder name |
| runtime | int? | Runtime in minutes |
| cleanTitle | String? | Clean title |
| imdbId | String? | IMDB ID |
| tmdbId | int? | TMDB ID |
| titleSlug | String? | URL slug |
| certification | String? | Content rating |
| genres | List<String>? | Genres |
| tags | List<String>? | Tags |
| added | DateTime? | When added |
| ratings | RatingsHive? | Ratings data |
| posterUrl | String? | Quick access poster URL |
| backdropUrl | String? | Quick access backdrop URL |
| serviceId | String? | Source service |
| cachedAt | DateTime? | Cache timestamp |
| movieFile | Map<String, dynamic>? | File info |
| collection | Map<String, dynamic>? | Collection info |

### 5. episodeCacheBox
**Box Name**: `'episodeCacheBox'`
**Type**: `Box<EpisodeHive>`
**Purpose**: Episode data from Sonarr

**Schema**: `EpisodeHive` (typeId: 160)

| Field | Type | Description |
|-------|------|-------------|
| seriesId | int? | Parent series ID |
| episodeFileId | int? | Episode file ID |
| seasonNumber | int? | Season number |
| episodeNumber | int? | Episode number |
| title | String? | Episode title |
| airDate | String? | Air date |
| airDateTime | String? | Air date/time |
| overview | String? | Episode summary |
| hasFile | bool? | Has file status |
| monitored | bool? | Monitoring status |
| absoluteEpisodeNumber | int? | Absolute episode number |
| tvdbId | int? | TVDB ID |
| tvRageId | String? | TVRage ID |
| sceneSeasonNumber | String? | Scene season |
| sceneEpisodeNumber | String? | Scene episode |
| sceneAbsoluteEpisodeNumber | String? | Scene absolute |
| unverifiedSceneNumbering | int? | Unverified scene |
| lastInfoSync | DateTime? | Last sync |
| series | String? | Series name |
| endingAired | bool? | Has aired |
| endTime | String? | End time |
| grabDate | String? | Grab date |
| grabTitle | String? | Grab title |
| indexer | String? | Indexer |
| releaseGroup | String? | Release group |
| seasonCount | int? | Season count |
| seriesTitle | String? | Series title |
| sizeOnDisk | int? | File size |
| mediaInfo | String? | Media info |
| quality | String? | Quality name |
| serviceId | String? | Source service |
| cachedAt | DateTime? | Cache timestamp |
| language | String? | Language |
| subtitles | String? | Subtitles |
| episodeFile | Map<String, dynamic>? | File info |

**Composite Key**: `${seriesId}_${seasonNumber}_${episodeNumber}`

### 6. settingsBox
**Box Name**: `'settingsBox'`
**Type**: `Box<AppSettings>`
**Purpose**: Application preferences and settings

**Schema**: `AppSettings` (typeId: 170)

| Field | Type | Default | Description |
|-------|------|---------|-------------|
| themeMode | String | 'system' | Theme mode (system, light, dark) |
| useDynamicTheme | bool | true | Use dynamic theming |
| accentColor | String? | null | Accent color |
| enableNotifications | bool | true | Enable notifications |
| backgroundSync | bool | true | Background sync |
| syncInterval | int | 30 | Sync interval (minutes) |
| cacheImages | bool | true | Cache images |
| maxCacheSize | int | 500 | Max cache size (MB) |
| defaultServiceType | String | 'sonarr' | Default service |
| defaultSonarrService | String? | null | Default Sonarr service |
| defaultRadarrService | String? | null | Default Radarr service |
| showDownloadProgress | bool | true | Show progress |
| autoRefresh | bool | true | Auto refresh |
| autoRefreshInterval | int | 300 | Refresh interval (seconds) |
| gridLayout | String | 'comfortable' | Grid layout |
| gridColumns | int | 2 | Grid columns |
| showYear | bool | true | Show year |
| showRatings | bool | true | Show ratings |
| sortBy | String | 'title' | Sort by field |
| sortOrder | String | 'asc' | Sort order |
| enableHapticFeedback | bool | true | Haptic feedback |
| enableDebugMode | bool | false | Debug mode |
| lastUpdated | DateTime? | now | Last update |

### 7. syncStateBox
**Box Name**: `'syncStateBox'`
**Type**: `Box<SyncState>`
**Purpose**: Track data freshness and sync status

**Schema**: `SyncState` (typeId: 180)

| Field | Type | Description |
|-------|------|-------------|
| serviceId | String | Service identifier |
| syncType | ServiceSyncType | Type of sync (series, movies, episodes, etc.) |
| lastSyncTime | DateTime? | Last sync attempt |
| status | SyncStatus | Current sync status |
| errorMessage | String? | Error message if failed |
| itemsSynced | int? | Items synced |
| totalItems | int? | Total items to sync |
| lastSuccessfulSync | DateTime? | Last successful sync |
| failedAttempts | int | Number of failed attempts |
| isSyncing | bool | Currently syncing |
| nextScheduledSync | DateTime? | Next scheduled sync |

**Sync Intervals**:
- Series/Movies: 6 hours
- Episodes: 1 hour
- Requests: 15 minutes
- Queue: 5 minutes
- System: 30 minutes

### 8. systemStatusBox
**Box Name**: `'systemStatusBox'`
**Type**: `Box<SystemStatus>`
**Purpose**: System metrics and health information

**Schema**: `SystemStatus` (typeId: 190)

| Field | Type | Description |
|-------|------|-------------|
| serviceId | String | Service identifier |
| timestamp | DateTime? | Status timestamp |
| version | String? | Service version |
| buildTime | String? | Build time |
| isMigration | bool? | Migration status |
| appName | String? | App name |
| instanceName | String? | Instance name |
| diskSpace | DiskSpaceInfo? | Disk space info |
| healthIssues | List<HealthIssue>? | Health issues |
| queueSize | int? | Queue size |
| missingMovies | int? | Missing movies count |
| missingEpisodes | int? | Missing episodes count |
| downloadSpeed | double? | Download speed (MB/s) |
| uploadSpeed | double? | Upload speed (MB/s) |
| status | String? | Overall status |
| metadata | Map<String, dynamic>? | Additional metadata |

## Supporting Models

### Enums

#### ServiceType (typeId: 100)
```dart
enum ServiceType {
  radarr,
  sonarr,
  overseerr,
  downloadClient,
}
```

#### MediaType (typeId: 101)
```dart
enum MediaType {
  series,
  movie,
}
```

#### MediaStatus (typeId: 102)
```dart
enum MediaStatus {
  downloading,
  completed,
  missing,
  monitored,
  continuing,
  ended,
  upcoming,
}
```

#### SeriesStatus (typeId: 103)
```dart
enum SeriesStatus {
  continuing,
  ended,
  upcoming,
  deleted,
}
```

#### DownloadClientType (typeId: 104)
```dart
enum DownloadClientType {
  transmission,
  deluge,
  qbittorrent,
  utorrent,
  sabnzbd,
  nzbget,
  other,
}
```

#### ServiceSyncType (typeId: 181)
```dart
enum ServiceSyncType {
  series,
  movies,
  episodes,
  requests,
  queue,
  system,
}
```

#### SyncStatus (typeId: 182)
```dart
enum SyncStatus {
  idle,
  syncing,
  success,
  error,
  cancelled,
  partial,
}
```

#### HealthIssueType (typeId: 193)
```dart
enum HealthIssueType {
  info,
  notice,
  warning,
  error,
}
```

### ImageHive (typeId: 110)
Optimized image storage with URL extraction:
- `coverType`: Image type (poster, fanart, etc.)
- `url`: Local URL
- `remoteUrl`: Remote URL
- `bestUrl`: Getter for best available URL

### RatingsHive (typeId: 111)
Store media ratings:
- `votes`: Vote count
- `value`: Rating value
- `tmdbId`: TMDB ID
- `imdbId`: IMDB ID

### DiskSpaceInfo (typeId: 191)
Disk space information:
- `label`: Disk label
- `path`: Disk path
- `free`: Free space in GB
- `total`: Total space in GB
- `usagePercentage`: Calculated usage percentage

### HealthIssue (typeId: 192)
Health issue tracking:
- `id`: Issue ID
- `source`: Source service
- `type`: Issue type (info, notice, warning, error)
- `message`: Issue message
- `wiki`: WikiLink for more info
- `timestamp`: Issue timestamp

### WikiLink (typeId: 194)
Documentation link:
- `name`: Link name
- `url`: Link URL

## Type Adapter ID Allocation

### Range Allocation Strategy
- **100-109**: Enums (basic types)
- **110-119**: Supporting models (Image, Ratings)
- **120-129**: Configuration models
- **130-139**: Unified models
- **140-149**: Series-specific models
- **150-159**: Movie-specific models
- **160-169**: Episode-specific models
- **170-179**: Settings models
- **180-189**: Sync state models
- **190-199**: System status models

## Usage Examples

### Initialize Hive
```dart
import 'package:arr/core/database/hive_database.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await HiveDatabase.init();
  runApp(MyApp());
}
```

### Access Storage Service
```dart
import 'package:arr/core/storage/storage_service.dart';

final storage = StorageService.instance;

// Get all series
final series = storage.getAllSeries();

// Add a series
await storage.putSeries(seriesHive);

// Search media
final results = storage.searchMedia('Breaking Bad');
```

### Repository Pattern
```dart
import 'package:arr/features/settings/data/repositories/service_repository.dart';

final repo = ServiceRepositoryImpl();
final services = await repo.getAllServices();
```

## Performance Optimization

### Box Management
- Boxes are opened once during initialization
- All boxes remain open for app lifetime
- Lazy box access can be implemented for rarely-used data

### Query Optimization
- Use proper key strategies (integer keys preferred)
- Implement indexes for frequent queries
- Cache frequently accessed data in memory

### Data Compaction
- Hive automatically compacts on close
- Can manually trigger: `await HiveDatabase.compact()`
- Recommended: Compact periodically based on database size

### Cache Invalidation
- Time-based expiration (configurable per sync type)
- Manual cache clear: `await HiveDatabase.clearCache()`
- Per-service cache clear: `await HiveDatabase.clearServiceCache(id)`

## Security Considerations

1. **API Keys**: NEVER store in Hive. Use `flutter_secure_storage` instead.
2. **Sensitive URLs**: Consider encrypting if needed
3. **Hive Encryption**: Available but not implemented by default
4. **Data Validation**: Always validate data before storage
5. **Error Handling**: Handle corrupted data gracefully

## Migration Strategy

### Schema Versioning
- Hive doesn't have built-in schema versioning
- Implement version tracking in settings
- Use migration scripts when schema changes

### Migration Steps
1. Export existing data to JSON
2. Clear old boxes
3. Update model classes and adapters
4. Run `build_runner` to regenerate adapters
5. Import data from JSON (transform if needed)
6. Verify migration success

## Monitoring

### Database Statistics
```dart
final stats = HiveDatabase.getStats();
print('Total series: ${stats['series']}');
print('Total movies: ${stats['movies']}');
print('Database size: ${stats['databaseSize']}');
```

### Performance Metrics
- Monitor box size and growth
- Track query performance
- Monitor cache hit rates
- Profile storage operations

## Troubleshooting

### Common Issues

1. **Adapter Not Registered**
   - Ensure all adapters are registered in `HiveDatabase._registerAdapters()`
   - Run `flutter pub run build_runner build` after model changes

2. **Box Not Found**
   - Ensure box is opened in `HiveDatabase._openBoxes()`
   - Check box name spelling

3. **Type Mismatch**
   - Verify typeId assignments are unique
   - Check generated `.g.dart` files for correct adapters

4. **Corrupted Data**
   - Implement data validation before storage
   - Handle exceptions when reading from Hive
   - Consider implementing backup/restore

## Best Practices

1. **Always initialize Hive before use**
2. **Use transactions for multi-step operations**
3. **Implement proper error handling**
4. **Keep database operations off main thread**
5. **Use appropriate key strategies**
6. **Implement cache invalidation logic**
7. **Monitor database size**
8. **Test data migrations thoroughly**
9. **Document schema changes**
10. **Use type-safe models (HiveObject)**

## Future Enhancements

1. **Lazy Box Loading**: For rarely-accessed data
2. **Query Indexing**: For improved query performance
3. **Data Encryption**: For sensitive data
4. **Automatic Backups**: Periodic data backup
5. **Conflict Resolution**: For multi-device sync
6. **Incremental Sync**: Sync only changed data
7. **Compression**: For large text fields
8. **Relationship Mapping**: For complex data relationships
