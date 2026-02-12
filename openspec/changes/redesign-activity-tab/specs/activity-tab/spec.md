## MODIFIED Requirements

### Requirement: Activity Tab displays unified queue and history
The Activity tab SHALL fetch download queue and history from all configured Sonarr and Radarr service instances and display them in two tab views.

#### Scenario: Queue tab shows active downloads
- **WHEN** the user views the Activity tab Queue section
- **THEN** all active downloads from all configured Sonarr and Radarr instances are shown in a list sorted by date descending
- **AND** each item shows title, quality, progress, size remaining, and source badge (Sonarr/Radarr)

#### Scenario: History tab shows completed/failed items
- **WHEN** the user switches to the History tab
- **THEN** all history records from all configured Sonarr and Radarr instances are shown sorted by date descending
- **AND** each item shows title, quality, event type, date, and source badge

#### Scenario: Multi-service error isolation
- **WHEN** one service instance fails to respond
- **THEN** results from other services are still displayed
- **AND** no crash occurs

#### Scenario: No services configured
- **WHEN** no Sonarr or Radarr services are configured
- **THEN** an empty state message is shown directing to Settings

#### Scenario: Dynamic header stats
- **WHEN** the queue has active downloads
- **THEN** the header shows the actual count of downloading items (not hardcoded)
