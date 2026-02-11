## Context
The app supports configuring multiple service instances (e.g., two Radarr servers for 4K and 1080p libraries). The current provider architecture creates a single API client per service type using `.firstOrNull`, ignoring additional instances. The library page needs to aggregate media from ALL configured instances.

## Goals / Non-Goals
- **Goals**:
  - Fetch media from all configured Sonarr and Radarr instances in parallel
  - Merge results into a single sorted list, deduplicated by title+year+type
  - Filter chips operate on the in-memory merged list (no re-fetch)
  - AsyncNotifierProvider for proper loading/error/data state management
  - Extensible for future service types (Lidarr, Readarr)
- **Non-Goals**:
  - Lidarr/Readarr implementation (just ensure the pattern supports it)
  - Streaming/real-time updates (fetch-on-demand with pull-to-refresh)
  - Cross-service deduplication (same movie on two Radarr instances shows twice - each has its own ID)

## Decisions

### 1. Multi-Instance API Provider Pattern
**Decision**: Create `allSonarrApisProvider` and `allRadarrApisProvider` that return `List<SonarrApi>` / `List<RadarrApi>` by filtering all configured services of that type.

**Why**: Minimal change to existing pattern. Each API instance already takes a `ServiceConfig`, so we just create one per matching config instead of taking `.firstOrNull`.

### 2. AsyncNotifierProvider for Unified Library
**Decision**: Use `AsyncNotifierProvider` (not `StreamProvider`) for the unified library state.

**Why**:
- We need fetch-on-demand, not continuous streaming
- `AsyncNotifier` gives us `build()` for initial load, plus methods like `refresh()` for pull-to-refresh
- It holds state properly - chip filter changes don't re-fetch, they just filter the cached `_allMedia` list
- Better error handling per-service (partial results if one service fails)

**Pattern**:
```dart
class UnifiedLibraryNotifier extends AsyncNotifier<List<MediaItem>> {
  List<MediaItem> _allMedia = [];  // cached full list

  @override
  Future<List<MediaItem>> build() async {
    // Fetch from all services in parallel
    final results = await Future.wait([
      ...sonarrApis.map((api) => _fetchSeries(api)),
      ...radarrApis.map((api) => _fetchMovies(api)),
    ]);
    _allMedia = results.expand((list) => list).toList()
      ..sort((a, b) => a.title.compareTo(b.title));
    return _applyFilter(_allMedia);
  }

  List<MediaItem> _applyFilter(List<MediaItem> items) {
    final filter = ref.read(mediaTypeFilterProvider);
    // null = All, MediaType.movie = Movies only, etc.
    if (filter == null) return items;
    return items.where((i) => i.type == filter).toList();
  }
}
```

### 3. Filter Chip as Client-Side Filter
**Decision**: Chip selection sets a `StateProvider<MediaType?>` (nullable, null = All). The notifier re-applies the filter on the cached list without re-fetching.

**Why**: Instant UI response. Data is already in memory.

### 4. MediaItem Type Detection (Radarr vs Sonarr JSON)
**Decision**: Use definitive field presence, not heuristics:

| Feature | Radarr (Movie) | Sonarr (TV Show) |
|---------|----------------|-------------------|
| Primary Key | `movieFile` | `seasons` |
| Organization | `studio` | `network` |
| ID System | `tmdbId` | `tvdbId` |
| Release Date | `inCinemas` | `firstAired` |

**Detection logic**:
```dart
final isMovie = json.containsKey('movieFile') ||
    json.containsKey('studio') ||
    (json.containsKey('tmdbId') && !json.containsKey('tvdbId')) ||
    json.containsKey('inCinemas');
```

**Why**: Current code uses an ambiguous `isSeries` check that can misclassify. Using Radarr-specific fields (`movieFile`, `studio`, `inCinemas`) is more reliable since those fields never appear in Sonarr responses and vice versa.

### 5. Per-Service Error Isolation
**Decision**: If one service instance fails, show its error but still display results from other services. Use a `PartialResult` pattern internally.

**Why**: User may have one server down but still want to browse media from working servers.

## Risks / Trade-offs
- **Large libraries**: Multiple instances could mean thousands of items in memory. Mitigation: pagination can be added later; for now, most home users have <5000 items total.
- **ID collisions**: Two Radarr instances may have items with the same `id`. Mitigation: MediaItem should include a `serviceKey` field to disambiguate. We'll add `String? serviceKey` to MediaItem.
- **Filter responsiveness**: Filtering a 5000-item list is instant in Dart, no concern.

## Open Questions
- None - straightforward aggregation pattern.
