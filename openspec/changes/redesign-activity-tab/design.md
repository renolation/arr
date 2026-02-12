# Design: Redesign Activity Tab

## Architecture

### Provider Pattern (follows Library tab)
Instead of the broken `DownloadRemoteDataSource` → `DownloadRepositoryImpl` chain, create new providers that fetch directly from APIs:

```
ActivityPage (with TabBar: Queue | History)
  ├── Queue tab → unifiedQueueProvider
  │     → allSonarrApisProvider → api.getQueue() for each
  │     → allRadarrApisProvider → api.getQueue() for each
  │     → Merge + sort by date, tag with source
  └── History tab → unifiedHistoryProvider
        → allSonarrApisProvider → api.getHistory() for each
        → allRadarrApisProvider → api.getHistory() for each
        → Merge + sort by date, tag with source
```

### Key Decisions
1. **Skip broken data layer**: The existing `DownloadRemoteDataSource` uses generic `DioClient`. Rather than fixing it, create `UnifiedQueueNotifier` and `UnifiedHistoryNotifier` that call APIs directly (same pattern as `UnifiedLibraryNotifier`)
2. **Reuse Download entity**: The existing `Download.fromJson` already handles Sonarr/Radarr queue response format correctly
3. **TabBar approach**: Use `DefaultTabController` + `TabBarView` for Queue/History switching
4. **Error isolation**: Each service fetch is wrapped in try/catch, partial results shown if one service fails

## Page Layout
```
┌─────────────────────────┐
│ Activity                │ ← Title
│ [N Downloading]         │ ← Dynamic count from queue
├─────────────────────────┤
│ [  Queue  ] [ History ] │ ← TabBar
├─────────────────────────┤
│                         │
│  Download card list     │ ← TabBarView content
│  (reuse existing card)  │
│                         │
└─────────────────────────┘
```

## Files Modified
- `lib/features/activity/presentation/providers/download_provider.dart` - Rewrite with UnifiedQueueNotifier/UnifiedHistoryNotifier
- `lib/features/activity/presentation/pages/activity_page.dart` - Add TabBar, dynamic header, use new providers
- `lib/features/activity/domain/entities/download.dart` - Add `eventType` field for history items
