# Proposal: Redesign Activity Tab

## Summary
Redesign the Activity tab to fetch queue and history from all configured Sonarr and Radarr services, displayed in two tab bars: **Queue** (active downloads) and **History** (completed/failed). Follows the same multi-service merge pattern as the Library tab.

## Motivation
The current Activity tab uses a broken `DownloadRemoteDataSource` with a generic `DioClient` that doesn't target specific service instances. It needs to be rewritten to use the actual `SonarrApi` and `RadarrApi` instances via `allSonarrApisProvider`/`allRadarrApisProvider`, matching the Library tab's `UnifiedLibraryNotifier` pattern.

## Scope
- Rewrite provider layer to fetch directly from all configured Sonarr/Radarr APIs (bypass broken data source/repository layers)
- Add TabBar with Queue and History tabs
- Queue tab: active downloads from all services, sorted by date
- History tab: completed/failed items from all services, sorted by date
- Dynamic header showing actual download count
- Remove hardcoded placeholder values

## Out of Scope
- Real-time streaming updates (future enhancement)
- Pause/resume/cancel actions (future enhancement)
- Download client (qBittorrent) integration
