# Change: Add Filter & Sort Controls to Library Search Header

## Why
The library page currently only supports filtering by media type via hardcoded chips. Users need richer filtering (by status, by source service) and sorting (by title, year, rating) to efficiently browse large unified libraries. The current filter chips will be replaced by a filter icon that opens a bottom sheet with all filter categories, plus a separate sort button.

## What Changes
- **Search header UI**: Add a filter icon button and a sort icon button next to the search text field in the `SliverAppBar`
- **Filter bottom sheet**: Tapping the filter icon opens a bottom sheet with three filter categories:
  - **Media Type**: Movie, TV Show (replaces current inline chips)
  - **Status**: Upcoming, Complete, Downloading, Missing
  - **Service**: Radarr, Sonarr (dynamic based on configured services)
  - **Reset** button to clear all filters
- **Sort bottom sheet**: Tapping the sort icon opens a bottom sheet with:
  - Sort by: Title, Year, Rating
  - Direction: Ascending, Descending
- **Remove inline filter chips**: The current horizontal chip row below the search bar is replaced by the filter/sort icon buttons
- **Provider changes**: New state providers for filter selections and sort options; update `UnifiedLibraryNotifier._applyFilter()` to handle multi-dimensional filtering and sorting
- **MediaStatus mapping**: Map filter statuses to existing `MediaStatus` enum values (Upcoming → `continuing` with future airDate, Complete → `downloaded`, Downloading → `downloading`, Missing → `missing`)

## Impact
- Affected specs: `library-filter-sort` (new)
- Affected code:
  - `lib/features/library/presentation/pages/library_page.dart` - UI changes (search header, remove chips, add filter/sort icons)
  - `lib/features/library/presentation/providers/media_provider.dart` - New filter/sort state providers, updated filtering/sorting logic
  - New widget files for filter and sort bottom sheets
