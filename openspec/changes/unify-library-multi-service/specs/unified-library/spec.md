## ADDED Requirements

### Requirement: Multi-Instance Service Aggregation
The system SHALL create API client instances for ALL configured services of each type (Sonarr, Radarr), not just the first one found.

#### Scenario: Multiple Radarr instances configured
- **WHEN** user has two Radarr services configured (e.g., "Radarr 4K" and "Radarr 1080p")
- **THEN** the system creates two RadarrApi instances and fetches movies from both

#### Scenario: Mixed services configured
- **WHEN** user has one Sonarr and two Radarr instances configured
- **THEN** the system fetches series from the Sonarr instance and movies from both Radarr instances in parallel

### Requirement: Unified Library Merging
The system SHALL merge media items from all configured service instances into a single unified list, sorted alphabetically by title.

#### Scenario: All filter shows everything
- **WHEN** the "All" filter chip is selected (mediaTypeFilter is null)
- **THEN** the library displays all media items from all configured services merged and sorted by title

#### Scenario: Movies filter
- **WHEN** the "Movies" filter chip is selected
- **THEN** the library displays only items where type == MediaType.movie, filtered from the already-fetched unified list (no re-fetch)

#### Scenario: TV Shows filter
- **WHEN** the "TV Shows" filter chip is selected
- **THEN** the library displays only items where type == MediaType.series, filtered from the already-fetched unified list (no re-fetch)

### Requirement: Reliable Media Type Detection
The system SHALL detect media type from JSON using definitive field presence: Radarr items contain `movieFile`/`studio`/`tmdbId`/`inCinemas`, Sonarr items contain `seasons`/`network`/`tvdbId`/`firstAired`.

#### Scenario: Radarr movie detection
- **WHEN** JSON contains `movieFile` or `studio` or `inCinemas` or (`tmdbId` without `tvdbId`)
- **THEN** the item is classified as MediaType.movie

#### Scenario: Sonarr series detection
- **WHEN** JSON contains `seasons` or `network` or `firstAired` with `tvdbId`
- **THEN** the item is classified as MediaType.series

### Requirement: Service Instance Tracking
Each MediaItem SHALL include a `serviceKey` field identifying which service instance it originated from.

#### Scenario: Item origin tracking
- **WHEN** a movie is fetched from the "Radarr 4K" service instance with key "radarr-4k"
- **THEN** the resulting MediaItem has serviceKey == "radarr-4k"

### Requirement: Partial Failure Resilience
The system SHALL display results from healthy services even when one or more service instances fail to respond.

#### Scenario: One service down
- **WHEN** "Radarr 4K" fails to respond but "Radarr 1080p" and "Sonarr" succeed
- **THEN** the library shows movies from "Radarr 1080p" and series from "Sonarr", and logs/surfaces the error for the failed instance
