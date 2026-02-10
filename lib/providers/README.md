# Riverpod Providers Architecture

This directory contains all Riverpod providers for state management in the *arr stack app.

## Architecture Overview

The app uses **Riverpod 2.x** for state management with the following patterns:

- **Provider**: For dependency injection (services, repositories)
- **StateNotifierProvider**: For complex mutable state with business logic
- **FutureProvider**: For one-time async operations (API calls)
- **StreamProvider**: For real-time data streams
- **StateProvider**: For simple mutable state (filters, search query)

## Provider Files

### 1. `service_providers.dart`
**Purpose**: Service configuration and API service injection

**Key Providers**:
- `storageServiceProvider` - Singleton storage service
- `servicesProvider` - All configured services (StateNotifierProvider)
- `sonarrApiServiceProvider` - Sonarr API service instance
- `radarrApiServiceProvider` - Radarr API service instance
- `overseerrApiServiceProvider` - Overseerr API service instance
- `downloadClientServiceProvider` - Download client API service instance
- `activeSonarrConfigProvider` - Currently active Sonarr service
- `activeRadarrConfigProvider` - Currently active Radarr service

**Usage**:
```dart
// Watch API service
final sonarrApi = ref.watch(sonarrApiServiceProvider);
if (sonarrApi != null) {
  final series = await sonarrApi.getSeries();
}

// Add new service
ref.read(servicesProvider.notifier).addService(newService);
```

### 2. `media_providers.dart`
**Purpose**: Unified media browsing (movies + TV series)

**Key Providers**:
- `mediaProvider` - Unified media state (StateNotifierProvider)
- `filteredMediaProvider` - Media with current filters applied
- `moviesProvider` - Movies only
- `seriesProvider` - Series only
- `mediaStatsProvider` - Overall statistics
- `mediaFilterProvider` - Current filter type (all/movies/series)
- `mediaSearchProvider` - Search query string

**Media Statistics**:
- `MediaStatistics` - Overall stats (total items, size)
- `MovieStatistics` - Movie-specific stats
- `SeriesStatistics` - Series-specific stats

**Usage**:
```dart
// Browse all media
final media = ref.watch(filteredMediaProvider);

// Filter by type
ref.read(mediaFilterProvider.notifier).state = MediaFilter.movies;

// Search
ref.read(mediaSearchProvider.notifier).state = 'search query';

// Get statistics
final stats = ref.watch(mediaStatsProvider);
print('Total: ${stats.totalItems}');
```

### 3. `system_providers.dart`
**Purpose**: System health monitoring for overview/dashboard

**Key Providers**:
- `systemStatusProvider` - All service statuses (StateNotifierProvider)
- `systemHealthProvider` - Overall system health (bool)
- `criticalIssuesCountProvider` - Count of critical issues
- `warningIssuesCountProvider` - Count of warnings
- `totalDownloadSpeedProvider` - Combined download speed
- `totalUploadSpeedProvider` - Combined upload speed
- `diskSpaceProvider` - Disk space information
- `overviewStatsProvider` - Combined dashboard statistics

**Overview Statistics**:
```dart
final stats = ref.watch(overviewStatsProvider);
print('Healthy: ${stats.isHealthy}');
print('Critical: ${stats.criticalIssuesCount}');
print('Speed: ${stats.formattedDownloadSpeed}');
```

### 4. `download_providers.dart`
**Purpose**: Download queue monitoring for activity tab

**Key Providers**:
- `downloadQueueProvider` - Queue state (StateNotifierProvider)
- `activeDownloadsProvider` - Active downloads only
- `completedDownloadsProvider` - Completed downloads
- `failedDownloadsProvider` - Failed downloads
- `downloadStatsProvider` - Queue statistics
- `downloadStreamProvider` - Real-time stream (10s intervals)

**QueueItem Model**:
```dart
final queue = ref.watch(downloadQueueProvider);

// Get active downloads
final active = ref.watch(activeDownloadsProvider);

// Get statistics
final stats = ref.watch(downloadStatsProvider);
print('Active: ${stats.activeCount}');
print('Speed: ${stats.formattedDownloadSpeed}');
```

### 5. `request_providers.dart`
**Purpose**: Overseerr/Jellyseerr media request management

**Key Providers**:
- `requestsProvider` - All requests (StateNotifierProvider)
- `pendingRequestsProvider` - Pending requests only
- `approvedRequestsProvider` - Approved requests
- `requestCountsProvider` - Count by status
- `requestDetailProvider` - Individual request (.family)
- `trendingMediaProvider` - Trending media
- `upcomingMediaProvider` - Upcoming media

**MediaRequest Model**:
```dart
// Load requests
final requests = ref.watch(requestsProvider);

// Filter by status
final pending = ref.watch(pendingRequestsProvider);

// Approve request
await ref.read(requestsProvider.notifier).approveRequest(requestId);

// Get counts
final counts = ref.watch(requestCountsProvider);
print('Pending: ${counts.pending}');
```

### 6. `settings_providers.dart`
**Purpose**: App settings and service configuration UI

**Key Providers**:
- `appSettingsProvider` - App settings (StateNotifierProvider)
- `themeModeProvider` - Current theme mode
- `localeProvider` - Current locale
- `refreshIntervalProvider` - Auto-refresh interval
- `notificationsEnabledProvider` - Notifications setting
- `serviceConfigUiProvider` - Service configuration UI state
- `servicesByTypeProvider` - Services by type (.family)
- `settingsTabProvider` - Current settings tab

**Usage**:
```dart
// App settings
final theme = ref.watch(themeModeProvider);
ref.read(appSettingsProvider.notifier).updateThemeMode(ThemeMode.dark);

// Service configuration
final services = ref.watch(serviceConfigUiProvider);
ref.read(serviceConfigUiProvider.notifier).addService(newService);
ref.read(serviceConfigUiProvider.notifier).testConnection(service);
```

### 7. `providers.dart`
**Purpose**: Barrel file for easy importing

Export all providers from a single file:
```dart
import 'package:arr/providers/providers.dart';
```

## Provider Types Usage

### StateNotifierProvider
Use for complex state with business logic:
```dart
final myProvider = StateNotifierProvider<MyNotifier, MyState>((ref) {
  return MyNotifier(/* dependencies */);
});

// Watch state
final state = ref.watch(myProvider);

// Call methods
ref.read(myProvider.notifier).doSomething();
```

### FutureProvider
Use for one-time async operations:
```dart
final myProvider = FutureProvider.autoDispose<Data>((ref) async {
  final api = ref.watch(apiProvider);
  return await api.fetchData();
});

// Watch AsyncValue
final asyncValue = ref.watch(myProvider);
asyncValue.when(
  data: (data) => Text('Data: $data'),
  loading: () => CircularProgressIndicator(),
  error: (err, stack) => Text('Error: $err'),
);
```

### Provider
Use for dependency injection:
```dart
final myServiceProvider = Provider<MyService>((ref) {
  final config = ref.watch(configProvider);
  return MyService(config);
});

// Use in other providers
final dataProvider = FutureProvider((ref) {
  final service = ref.watch(myServiceProvider);
  return service.getData();
});
```

### StateProvider
Use for simple mutable state:
```dart
final filterProvider = StateProvider<Filter>((ref) => Filter.all);

// Watch
final filter = ref.watch(filterProvider);

// Update
ref.read(filterProvider.notifier).state = Filter.active;
```

### StreamProvider
Use for real-time data:
```dart
final streamProvider = StreamProvider<Data>((ref) {
  final service = ref.watch(myServiceProvider);
  return service.getDataStream();
});

// Watch AsyncValue with stream updates
final asyncValue = ref.watch(streamProvider);
```

## Best Practices

### 1. Use Proper Watching
```dart
// GOOD: Watch for reactive updates
final data = ref.watch(dataProvider);

// BAD: Read in build method (not reactive)
final data = ref.read(dataProvider); // Won't update on changes
```

### 2. Use Read for Actions
```dart
// GOOD: Read notifier for actions
ElevatedButton(
  onPressed: () => ref.read(myProvider.notifier).doSomething(),
)

// BAD: Watch notifier in build (rebuilds on every state change)
final notifier = ref.watch(myProvider.notifier); // Unnecessary
```

### 3. Use Select for Fine-grained Rebuilds
```dart
// GOOD: Select specific property
final count = ref.watch(myProvider.select((s) => s.items.length));

// BETTER: Use separate provider for derived data
final itemsCountProvider = Provider<int>((ref) {
  return ref.watch(myProvider).items.length;
});
```

### 4. Dispose Resources
```dart
class MyNotifier extends StateNotifier<MyState> {
  final StreamSubscription _subscription;

  MyNotifier(this._subscription) : super(MyState()) {
    _subscription.listen((data) {
      state = state.copyWith(data: data);
    });
  }

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}
```

### 5. Handle AsyncValue Properly
```dart
final dataProvider = FutureProvider<Data>((ref) async {
  return await api.fetchData();
});

class MyWidget extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncValue = ref.watch(dataProvider);

    return asyncValue.when(
      data: (data) => DataWidget(data),
      loading: () => LoadingWidget(),
      error: (err, stack) => ErrorWidget(err),
    );
  }
}
```

### 6. Use Family Modifiers
```dart
// Parameterized provider
final userProvider = FutureProvider.family<User, int>((ref, id) async {
  return await api.fetchUser(id);
});

// Use with parameter
final user = ref.watch(userProvider(userId));
```

### 7. AutoDispose for One-time Data
```dart
// Auto-dispose when no longer watched
final detailProvider = FutureProvider.autoDispose<Detail>((ref) async {
  return await api.fetchDetail();
});
```

## Error Handling

All providers should handle errors gracefully:

```dart
class MyNotifier extends StateNotifier<MyState> {
  Future<void> fetchData() async {
    try {
      state = state.copyWith(isLoading: true, error: null);
      final data = await _api.fetch();
      state = state.copyWith(data: data, isLoading: false);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }
}
```

## Testing Providers

```dart
test('fetches data successfully', () async {
  final container = ProviderContainer(
    overrides: [
      apiProvider.overrideWithValue(MockApi()),
    ],
  );

  final notifier = container.read(myProvider.notifier);
  await notifier.fetchData();

  expect(container.read(myProvider).data, isNotEmpty);
});
```

## Performance Optimization

1. **Use select()** to watch only needed properties
2. **Split large providers** into smaller, focused ones
3. **Use autoDispose** for one-time operations
4. **Cache expensive computations** in separate providers
5. **Debounce frequent updates** (search, filters)

## Migration Notes

The app previously used `SonarrApi` and `RadarrApi` classes. These are being replaced with:
- `SonarrApiService` (in `services/api/`)
- `RadarrApiService` (in `services/api/`)

New providers use these service classes while maintaining backward compatibility with existing providers in:
- `sonarr_providers.dart`
- `radarr_providers.dart`

These can be gradually migrated as needed.
