## 1. Data Model Updates
- [x] 1.1 Add `serviceKey` field to `MediaItem` to track which service instance an item came from
- [x] 1.2 Update `MediaItem.fromJson` detection logic to use reliable Radarr vs Sonarr field detection (`movieFile`/`studio`/`tmdbId`/`inCinemas` vs `seasons`/`network`/`tvdbId`/`firstAired`)
- [x] 1.3 Change `mediaTypeFilterProvider` from `StateProvider<MediaType>` to `StateProvider<MediaType?>` (null = All)

## 2. Multi-Instance API Providers
- [x] 2.1 Add `allSonarrApisProvider` returning `FutureProvider<List<(String, SonarrApi)>>` - creates an API instance for each configured Sonarr service
- [x] 2.2 Add `allRadarrApisProvider` returning `FutureProvider<List<(String, RadarrApi)>>` - creates an API instance for each configured Radarr service
- [x] 2.3 Keep existing single-instance providers for backward compatibility (detail screens, etc.)

## 3. Unified Library AsyncNotifier
- [x] 3.1 Create `UnifiedLibraryNotifier extends AsyncNotifier<List<MediaItem>>` in `media_provider.dart`
- [x] 3.2 Implement `build()` that fetches from all Sonarr + Radarr instances in parallel using `Future.wait`
- [x] 3.3 Cache full result list internally (`_allMedia`), apply filter from `mediaTypeFilterProvider`
- [x] 3.4 Add `refresh()` method for pull-to-refresh
- [x] 3.5 Implement per-service error isolation (partial results if one service fails)
- [x] 3.6 Wire `unifiedLibraryProvider` as `AsyncNotifierProvider` replacing old `FutureProvider`

## 4. Library Page UI Updates
- [x] 4.1 Wire "All" chip to set `mediaTypeFilterProvider` to `null`
- [x] 4.2 Wire "Movies" chip to set filter to `MediaType.movie`
- [x] 4.3 Wire "TV Shows" chip to set filter to `MediaType.series`
- [x] 4.4 Update chip `isSelected` state to reflect current `mediaTypeFilterProvider` value
- [x] 4.5 Switch library page from `libraryProvider` to `unifiedLibraryProvider`
- [x] 4.6 Update empty state to handle null filter (All)

## 5. Cleanup
- [x] 5.1 Remove or deprecate old `libraryProvider` (replaced by unified)
- [x] 5.2 Search already works across unified library (searchResultsProvider queries both repos)
