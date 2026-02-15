# Change: Add Calendar View as 5th Navigation Tab

## Why
Users need a dedicated calendar view to track upcoming TV episodes and movie releases. The existing "Coming Soon" horizontal scroll in the Overview tab only shows a flat list - a proper calendar with daily/weekly grouping makes it much easier to plan and anticipate new content. This is listed as the #1 high-priority feature in FEATURE_SUGGESTIONS.md.

## What Changes
- **New bottom nav tab**: Add "Calendar" as the 5th tab between "Overview" and "Library" in the bottom navigation bar
- **Calendar page**: Full-screen calendar page with two view modes:
  - **Week view** (default): Shows 7 days horizontally as selectable day chips, with a vertical list of items for the selected day
  - **Month view**: Standard month grid with dots/indicators on dates that have content, tapping a date shows that day's items
- **Unified calendar data**: Reuse and extend the existing `calendarProvider` from `airing_section.dart` - extract `_CalendarItem` into a shared public model so both the Overview's "Coming Soon" section and the new Calendar page can use it
- **Filter by service**: Optional filter chips to show only Sonarr (TV) or Radarr (Movies) items
- **Navigation**: Tapping a calendar item navigates to its media detail page
- **Date navigation**: Swipe or tap arrows to navigate between weeks/months

## Impact
- Affected specs: `calendar-view` (new)
- Affected code:
  - `lib/core/router/app_router.dart` - Add 5th navigation branch + tab
  - `lib/features/calendar/` - New feature module (page, providers, widgets)
  - `lib/features/overview/presentation/widgets/airing_section.dart` - Extract `_CalendarItem` to shared model
  - `lib/features/overview/presentation/providers/` - Move `calendarProvider` to shared location or calendar feature
