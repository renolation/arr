## ADDED Requirements

### Requirement: Library Filter by Media Type
The library page SHALL allow users to filter media items by type (Movie, TV Show) via a filter bottom sheet.

#### Scenario: Filter by movies only
- **WHEN** user opens the filter sheet and selects "Movie"
- **THEN** the library grid displays only items where `type == MediaType.movie`

#### Scenario: Filter by TV shows only
- **WHEN** user opens the filter sheet and selects "TV Show"
- **THEN** the library grid displays only items where `type == MediaType.series`

#### Scenario: No media type filter selected
- **WHEN** no media type is selected in the filter sheet
- **THEN** the library grid displays all media types

---

### Requirement: Library Filter by Status
The library page SHALL allow users to filter media items by status (Upcoming, Complete, Downloading, Missing) via the filter bottom sheet.

#### Scenario: Filter by missing status
- **WHEN** user selects "Missing" status filter
- **THEN** only items with `status == MediaStatus.missing` are displayed

#### Scenario: Filter by downloading status
- **WHEN** user selects "Downloading" status filter
- **THEN** only items with `status == MediaStatus.downloading` are displayed

#### Scenario: Filter by complete status
- **WHEN** user selects "Complete" status filter
- **THEN** only items with `status == MediaStatus.downloaded` are displayed

#### Scenario: Filter by upcoming status
- **WHEN** user selects "Upcoming" status filter
- **THEN** only items with `status == MediaStatus.continuing` and a future `airDate` are displayed

---

### Requirement: Library Filter by Service
The library page SHALL allow users to filter media items by source service (Radarr, Sonarr) via the filter bottom sheet. Only configured services SHALL appear as options.

#### Scenario: Filter by Radarr service
- **WHEN** user selects "Radarr" service filter
- **THEN** only items originating from Radarr instances are displayed (matched via `serviceKey`)

#### Scenario: Filter by Sonarr service
- **WHEN** user selects "Sonarr" service filter
- **THEN** only items originating from Sonarr instances are displayed (matched via `serviceKey`)

#### Scenario: Unconfigured service not shown
- **WHEN** Radarr is not configured
- **THEN** "Radarr" does not appear as a filter option in the service section

---

### Requirement: Library Filter Reset
The filter bottom sheet SHALL provide a "Reset" action that clears all active filters.

#### Scenario: Reset all filters
- **WHEN** user taps "Reset" in the filter sheet
- **THEN** all filter selections (media type, status, service) are cleared and the full unfiltered library is shown

---

### Requirement: Library Filter Icon with Active Indicator
The library search header SHALL display a filter icon button. When any filter is active, the icon SHALL show a visual indicator (e.g., colored dot).

#### Scenario: No active filters
- **WHEN** no filters are applied
- **THEN** the filter icon appears in its default state without indicator

#### Scenario: Active filters present
- **WHEN** one or more filters are applied
- **THEN** the filter icon displays a small colored dot to indicate active filters

---

### Requirement: Library Sort by Field
The library page SHALL allow users to sort media items by Title, Year, or Rating via a sort bottom sheet.

#### Scenario: Sort by title ascending
- **WHEN** user selects sort by "Title" with ascending direction
- **THEN** the library grid displays items sorted alphabetically A-Z by title

#### Scenario: Sort by year descending
- **WHEN** user selects sort by "Year" with descending direction
- **THEN** the library grid displays items sorted from newest to oldest year

#### Scenario: Sort by rating descending
- **WHEN** user selects sort by "Rating" with descending direction
- **THEN** the library grid displays items sorted from highest to lowest rating

---

### Requirement: Library Sort Direction Toggle
The sort bottom sheet SHALL allow users to toggle between ascending and descending sort direction.

#### Scenario: Toggle from ascending to descending
- **WHEN** user changes direction from ascending to descending
- **THEN** the library grid re-sorts in the opposite order

---

### Requirement: Combined Filter and Sort
Filters and sort SHALL be applied together. Filters reduce the set of items, then sort orders the filtered results.

#### Scenario: Filter movies sorted by rating
- **WHEN** user filters by "Movie" type and sorts by "Rating" descending
- **THEN** only movies are shown, ordered from highest to lowest rating

---

### Requirement: Remove Inline Filter Chips
The existing horizontal filter chip row (All, Movies, TV Shows, Missing, Monitored) below the search bar SHALL be removed and replaced by the filter/sort icon buttons in the search header.

#### Scenario: Chips no longer visible
- **WHEN** the library page loads
- **THEN** no horizontal chip row is displayed below the search bar
- **AND** filter and sort icon buttons are visible in the search header row
