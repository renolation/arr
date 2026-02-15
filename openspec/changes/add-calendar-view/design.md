## Context
The app currently has 4 bottom nav tabs. A calendar view is the top requested feature. The existing `calendarProvider` and `_CalendarItem` model in `airing_section.dart` already fetch from all Sonarr/Radarr instances - we need to extract and reuse this logic rather than duplicate it.

## Goals / Non-Goals
- Goals:
  - Add a dedicated calendar tab with week and month views
  - Extract calendar data model and provider for shared use
  - Allow filtering by service type (TV/Movies)
  - Navigate to media details from calendar items
- Non-Goals:
  - iCal export (future enhancement)
  - Push notifications for upcoming items
  - Custom date range beyond what Sonarr/Radarr APIs provide

## Decisions
- **View modes**: Week view (default, most useful on mobile) + Month view toggle. Week view is a horizontal day selector with vertical item list below. Month view is a compact grid with indicators.
- **Shared model**: Extract `_CalendarItem` from `airing_section.dart` into `lib/features/calendar/domain/entities/calendar_item.dart` as a public `CalendarItem` class. Move `calendarProvider` to `lib/features/calendar/presentation/providers/calendar_provider.dart`.
- **Tab position**: Calendar goes between Overview and Library (index 1) since it's closely related to upcoming content.
- **Date range**: Fetch 30 days ahead (matching current behavior). For month view, fetch the full visible month range.
- **No external calendar library**: Use custom implementation with standard Flutter widgets to stay minimal and match the Swiss design aesthetic.

## Risks / Trade-offs
- Adding a 5th tab increases bottom nav density on small screens - Material 3 NavigationBar handles up to 5 destinations well
- Moving `calendarProvider` affects the Overview page's "Coming Soon" section - must update imports

## Open Questions
- None - straightforward feature with clear requirements
