## 1. Extract Shared Calendar Model & Provider
- [ ] 1.1 Create `lib/features/calendar/domain/entities/calendar_item.dart` - extract `_CalendarItem` from `airing_section.dart` as public `CalendarItem`
- [ ] 1.2 Create `lib/features/calendar/presentation/providers/calendar_provider.dart` - move `calendarProvider` here, add configurable date range parameter
- [ ] 1.3 Update `airing_section.dart` to import from new shared location
- [ ] 1.4 Verify Overview "Coming Soon" section still works

## 2. Calendar Page - Week View
- [ ] 2.1 Create `lib/features/calendar/presentation/pages/calendar_page.dart` with week/month view toggle
- [ ] 2.2 Build horizontal day selector (7 day chips showing day name + date number, today highlighted)
- [ ] 2.3 Build vertical item list for selected day showing poster thumbnail, title, subtitle, date badge, and hasFile indicator
- [ ] 2.4 Add left/right navigation to shift the week window
- [ ] 2.5 Add service filter chips (All, TV Shows, Movies) at top

## 3. Calendar Page - Month View
- [ ] 3.1 Build month grid widget (standard 7-column calendar grid)
- [ ] 3.2 Show dot indicators on dates with content (green for downloaded, blue for upcoming)
- [ ] 3.3 Tapping a date selects it and shows that day's items in a list below the grid
- [ ] 3.4 Add month navigation (previous/next month arrows)

## 4. Navigation Integration
- [ ] 4.1 Add Calendar tab to bottom navigation in `app_router.dart` (5th tab, position between Overview and Library)
- [ ] 4.2 Add `/calendar` route with `CalendarPage`
- [ ] 4.3 Add calendar icon to NavigationDestination (calendar_today_outlined / calendar_today)

## 5. Item Interaction
- [ ] 5.1 Tapping a calendar item navigates to media detail page (reuse existing detail page navigation)
- [ ] 5.2 Show empty state when no items exist for selected date
