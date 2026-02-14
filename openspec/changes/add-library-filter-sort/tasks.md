## 1. State & Provider Layer
- [ ] 1.1 Create `LibraryFilter` model (freezed) with fields: `mediaType`, `status`, `service` (each nullable/set)
- [ ] 1.2 Create `LibrarySort` model with fields: `sortBy` (title/year/rating), `ascending` (bool)
- [ ] 1.3 Add `libraryFilterProvider` (StateProvider<LibraryFilter>) and `librarySortProvider` (StateProvider<LibrarySort>) in `media_provider.dart`
- [ ] 1.4 Update `UnifiedLibraryNotifier` to watch both providers and apply multi-dimensional filter + sort in `_applyFilter()`

## 2. Filter Bottom Sheet Widget
- [ ] 2.1 Create `FilterBottomSheet` widget with three sections: Media Type, Status, Service
- [ ] 2.2 Each section uses selectable chips (multi-select within category)
- [ ] 2.3 Add "Reset" button that clears all filter selections
- [ ] 2.4 Service section dynamically shows only configured services (check sonarr/radarr API providers)
- [ ] 2.5 Apply button closes sheet and updates `libraryFilterProvider`

## 3. Sort Bottom Sheet Widget
- [ ] 3.1 Create `SortBottomSheet` widget with sort field options (Title, Year, Rating) and direction toggle (Asc/Desc)
- [ ] 3.2 Radio-style selection for sort field, toggle for direction
- [ ] 3.3 Apply updates `librarySortProvider` and closes sheet

## 4. Library Page UI Updates
- [ ] 4.1 Add filter icon button (with active indicator dot when filters applied) next to search field in `SliverAppBar`
- [ ] 4.2 Add sort icon button next to filter icon
- [ ] 4.3 Remove the existing `SliverToBoxAdapter` filter chips section (lines 72-127)
- [ ] 4.4 Remove `mediaTypeFilterProvider` usage (replaced by `libraryFilterProvider`)
- [ ] 4.5 Wire filter icon tap → show `FilterBottomSheet`, sort icon tap → show `SortBottomSheet`

## 5. Cleanup
- [ ] 5.1 Remove unused `_FilterChip` widget class
- [ ] 5.2 Remove `mediaTypeFilterProvider` if no longer referenced elsewhere
- [ ] 5.3 Verify search functionality still works alongside new filters
