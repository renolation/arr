# Change: Unify Library to Fetch from All Configured Service Instances

## Why
The Library page currently creates one API/repository per service type (one Sonarr, one Radarr). The app supports multiple service instances of the same type (e.g., two Radarr servers), but the library only fetches from the first one found. The "All" chip doesn't actually merge results - it just picks one type. We need to fetch from ALL configured service instances in parallel and merge into a single unified list.

## What Changes
- **API providers**: Replace single-instance providers (`sonarrApiProvider`, `radarrApiProvider`) with multi-instance providers that return a list of API clients per service type
- **Media provider**: Replace `FutureProvider`-based `libraryProvider`/`unifiedLibraryProvider` with an `AsyncNotifierProvider` that fetches from all configured services in parallel, merges results, and exposes the full list
- **Filter chips**: "All" shows merged results; "Movies" and "TV Shows" filter by `MediaType` on the already-fetched unified list (no re-fetch)
- **MediaItem detection**: Update `fromJson` to use reliable field-based detection:
  - **Movie (Radarr)**: has `movieFile`, `studio`, `tmdbId`, `inCinemas`
  - **TV Show (Sonarr)**: has `seasons`, `network`, `tvdbId`, `firstAired`
- **Future extensibility**: Design allows adding Lidarr (music/albums) as a new `MediaType` and `ServiceType` without architectural changes

## Impact
- Affected specs: `unified-library` (new)
- Affected code:
  - `lib/core/network/api_providers.dart` - multi-instance API providers
  - `lib/features/library/presentation/providers/media_provider.dart` - AsyncNotifierProvider for unified library
  - `lib/features/library/presentation/pages/library_page.dart` - chip filter wiring
  - `lib/features/library/domain/entities/media_item.dart` - fromJson detection fix
  - `lib/features/library/data/repositories/media_repository.dart` - minor adjustments
