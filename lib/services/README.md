# API Services

This directory contains the API service layer for integrating with *arr stack services and related download clients.

## Architecture

### Base API Service (`base_api_service.dart`)

The abstract base class that provides common functionality for all API services:

- **HTTP Client**: Wraps Dio client with proper configuration
- **Authentication**: Automatic API key injection via X-Api-Key header
- **Error Handling**: Converts Dio errors to typed AppException subclasses
- **Response Parsing**: Helper methods for parsing JSON responses to typed models
- **Connection Testing**: Built-in method to verify service connectivity

#### Key Features:

- Automatic timeout handling (configurable)
- Type-safe response parsing with `parseList()` and `parseItem()`
- Consistent error handling across all services
- Easy configuration updates with `updateConfiguration()`

## Service Implementations

### Sonarr API Service (`sonarr_api_service.dart`)

Manages TV series through Sonarr's REST API (v5).

**Example Usage:**

```dart
final sonarr = SonarrApiService(
  baseUrl: 'http://localhost:8989',
  apiKey: 'your-api-key',
);

// Get all series
final series = await sonarr.getSeries();

// Get specific series
final series = await sonarr.getSeriesById(123);

// Search for series to add
final results = await sonarr.searchSeries('Breaking Bad');

// Add a new series
await sonarr.addSeries(
  series: searchResults.first,
  qualityProfileId: 1,
  rootFolderPath: '/tv',
  monitored: true,
);

// Get episodes for a series
final episodes = await sonarr.getEpisodes(123);

// Get episodes for specific season
final episodes = await sonarr.getEpisodes(123, seasonNumber: 1);

// Trigger episode search
await sonarr.searchEpisode(456);

// Delete a series
await sonarr.deleteSeries(123, deleteFiles: false);
```

### Radarr API Service (`radarr_api_service.dart`)

Manages movies through Radarr's REST API (v3).

**Example Usage:**

```dart
final radarr = RadarrApiService(
  baseUrl: 'http://localhost:7878',
  apiKey: 'your-api-key',
);

// Get all movies
final movies = await radarr.getMovies();

// Get specific movie
final movie = await radarr.getMovieById(456);

// Search for movies
final results = await radarr.searchMovies('Inception');

// Add a new movie
await radarr.addMovie(
  movie: searchResults.first,
  qualityProfileId: 4,
  rootFolderPath: '/movies',
  monitored: true,
  minimumAvailability: 'released',
);

// Search for releases
await radarr.searchMovie(123);

// Add exclusion
await radarr.addExclusion(
  tmdbId: 12345,
  title: 'Movie Title',
);

// Delete a movie
await radarr.deleteMovie(456, deleteFiles: false);
```

### Overseerr API Service (`overseerr_api_service.dart`)

Manages media requests through Overseerr/Jellyseerr's REST API (v1).

**Example Usage:**

```dart
final overseerr = OverseerrApiService(
  baseUrl: 'http://localhost:5055',
  apiKey: 'your-api-key',
);

// Get all requests
final requests = await overseerr.getRequests(
  page: 1,
  pageSize: 20,
  filter: 'all', // pending, approved, available, etc.
);

// Create a new request
await overseerr.createRequest(
  mediaId: 123,
  mediaType: 'movie', // or 'tv'
);

// Create TV show request with specific seasons
await overseerr.createRequest(
  mediaId: 456,
  mediaType: 'tv',
  seasons: [1, 2, 3],
);

// Approve a request
await overseerr.approveRequest(789);

// Decline a request
await overseerr.declineRequest(789);

// Get trending media
final trending = await overseerr.getTrending(
  page: 1,
  mediaType: 'all', // movie, tv, all
);

// Search media
final results = await overseerr.searchMedia('query');

// Get system status
final status = await overseerr.getSystemStatus();

// Get connected services
final services = await overseerr.getServices();
```

### Download Client API Service (`download_api_service.dart`)

Manages various download clients (qBittorrent, Transmission, SABnzbd, NZBGet, Deluge, rTorrent).

**Example Usage:**

```dart
final downloader = DownloadApiService(
  baseUrl: 'http://localhost:8080',
  apiKey: 'your-api-key',
  clientType: DownloadClientType.qbittorrent,
);

// Get queue
final queue = await downloader.getQueue();

// Get history
final history = await downloader.getHistory();

// Pause a download
await downloader.pauseDownload('torrent-hash');

// Resume a download
await downloader.resumeDownload('torrent-hash');

// Remove a download
await downloader.removeDownload('torrent-hash', deleteFiles: true);

// Pause all
await downloader.pauseAll();

// Resume all
await downloader.resumeAll();

// Get download speed
final speed = await downloader.getDownloadSpeed();

// Add torrent/magnet
await downloader.addTorrent(
  'magnet:?xt=urn:btih:...',
  savePath: '/downloads',
);

// Test connection
final connected = await downloader.testConnection();
```

## Error Handling

All API services throw typed exceptions that extend `AppException`:

```dart
try {
  final series = await sonarr.getSeries();
} on AuthException catch (e) {
  // Invalid API key - 401
  print('Authentication failed: ${e.message}');
} on NetworkException catch (e) {
  // No internet connection
  print('Network error: ${e.message}');
} on TimeoutException catch (e) {
  // Request timeout
  print('Timeout: ${e.message}');
} on NotFoundException catch (e) {
  // Resource not found - 404
  print('Not found: ${e.message}');
} on ServerException catch (e) {
  // Server error - 500, 502, 503
  print('Server error: ${e.message} (code: ${e.code})');
} on ValidationException catch (e) {
  // Bad request - 400
  print('Validation error: ${e.message}');
} on ParseException catch (e) {
  // JSON parsing error
  print('Parse error: ${e.message}');
} on AppException catch (e) {
  // Generic error
  print('Error: ${e.message}');
}
```

## Configuration

### Timeout Configuration

All services support custom timeouts:

```dart
final service = SonarrApiService(
  baseUrl: 'http://localhost:8989',
  apiKey: 'your-api-key',
  connectTimeout: Duration(seconds: 10),
  receiveTimeout: Duration(seconds: 30),
  sendTimeout: Duration(seconds: 30),
);
```

### Dynamic Configuration Update

Update service configuration at runtime:

```dart
service.updateConfiguration(
  baseUrl: 'http://new-server:8989',
  apiKey: 'new-api-key',
);
```

### Connection Testing

Test service connectivity before making requests:

```dart
final isConnected = await service.testConnection();
if (!isConnected) {
  print('Service is unreachable');
}
```

## Models

All services return typed models from `lib/models/`:

- **Sonarr**: `SeriesResource`, `EpisodeResource`
- **Radarr**: `MovieResource`
- **Overseerr**: Raw `Response` (model-specific parsing can be added)
- **Download Clients**: Raw `Response` (varies by client type)

Models include `fromJson()` and `toJson()` methods for serialization.

## API Version Support

- **Sonarr**: API v5 (uses `/api/v3` base path)
- **Radarr**: API v3 (uses `/api/v3` base path)
- **Overseerr**: API v1 (uses `/api/v1` base path)
- **Download Clients**: Varies by client (specified in service methods)

## Best Practices

1. **Always handle exceptions**: Wrap API calls in try-catch blocks
2. **Use connection testing**: Verify connectivity before critical operations
3. **Leverage typed models**: Use `parseList()` and `parseItem()` for type safety
4. **Implement retry logic**: Handle network failures gracefully
5. **Cache responses**: Store frequently accessed data locally (Hive)
6. **Monitor queues**: Check download queues for status updates
7. **Validate inputs**: Ensure IDs and parameters are valid before making requests

## Testing

Mock API services for testing:

```dart
class MockSonarrApiService extends BaseApiService {
  MockSonarrApiService() : super(
    baseUrl: 'http://test',
    apiKey: 'test-key',
  );

  @override
  Future<List<SeriesResource>> getSeries() async {
    return [/* mock data */];
  }
}
```

## Future Enhancements

- Add WebSocket support for real-time queue updates
- Implement request batching for bulk operations
- Add response caching with TTL
- Implement retry logic with exponential backoff
- Add request logging and debugging tools
- Create provider/ Riverpod integration examples
