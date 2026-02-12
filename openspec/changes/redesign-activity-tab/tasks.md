## 1. Rewrite Activity Providers
- [x] 1.1 Create `UnifiedQueueNotifier` in `download_provider.dart` using `allSonarrApisProvider`/`allRadarrApisProvider` pattern
- [x] 1.2 Create `UnifiedHistoryNotifier` in `download_provider.dart` with same pattern for history
- [x] 1.3 Add `eventType` field to `Download` entity for history event types (grabbed, downloadFolderImported, etc.)
- [x] 1.4 Keep `activeDownloadsCountProvider` working with new queue provider

## 2. Redesign Activity Page
- [x] 2.1 Convert `ActivityPage` to use `DefaultTabController` with Queue and History tabs
- [x] 2.2 Replace hardcoded header stats with dynamic count from `activeDownloadsCountProvider`
- [x] 2.3 Queue tab: display list from `unifiedQueueProvider` with `_QueueDownloadCard`
- [x] 2.4 History tab: display list from `unifiedHistoryProvider` with history-specific card layout
- [x] 2.5 Add pull-to-refresh on both tabs
- [x] 2.6 Handle empty/loading/error states for each tab independently

## 3. Validate
- [x] 3.1 Run `dart analyze` to verify no errors
