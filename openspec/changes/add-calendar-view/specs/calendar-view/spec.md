## ADDED Requirements

### Requirement: Calendar Navigation Tab
The app SHALL display a "Calendar" tab in the bottom navigation bar as the 2nd tab (between Overview and Library).

#### Scenario: Calendar tab visible
- **WHEN** the app loads
- **THEN** a "Calendar" tab with a calendar icon is visible in the bottom navigation bar

#### Scenario: Navigate to calendar
- **WHEN** user taps the Calendar tab
- **THEN** the calendar page is displayed with the current week in view

---

### Requirement: Calendar Week View
The calendar page SHALL display a week view as the default view mode, showing a horizontal row of 7 selectable day chips and a vertical list of items for the selected day.

#### Scenario: Week view displays current week
- **WHEN** user opens the calendar page
- **THEN** the current week's 7 days are shown as selectable chips with today pre-selected
- **AND** items for today are listed below

#### Scenario: Select a different day
- **WHEN** user taps a day chip
- **THEN** the item list updates to show only items for that selected day

#### Scenario: Navigate to previous/next week
- **WHEN** user taps the left or right navigation arrow
- **THEN** the day chips update to show the previous or next week

#### Scenario: No items for selected day
- **WHEN** user selects a day with no upcoming content
- **THEN** an empty state message is displayed

---

### Requirement: Calendar Month View
The calendar page SHALL provide a month view mode showing a standard calendar grid with indicators on dates that have content.

#### Scenario: Switch to month view
- **WHEN** user toggles from week view to month view
- **THEN** a monthly calendar grid is displayed with the current month

#### Scenario: Date indicators
- **WHEN** the month grid is displayed
- **THEN** dates with upcoming content show dot indicators

#### Scenario: Select date in month view
- **WHEN** user taps a date in the month grid
- **THEN** items for that date are shown in a list below the grid

#### Scenario: Navigate between months
- **WHEN** user taps previous or next month arrow
- **THEN** the grid updates to display the adjacent month

---

### Requirement: Calendar Service Filter
The calendar page SHALL allow users to filter items by service type (All, TV Shows, Movies).

#### Scenario: Filter by TV shows
- **WHEN** user selects "TV Shows" filter
- **THEN** only episodes from Sonarr are displayed

#### Scenario: Filter by Movies
- **WHEN** user selects "Movies" filter
- **THEN** only movies from Radarr are displayed

#### Scenario: Show all
- **WHEN** user selects "All" filter
- **THEN** items from both Sonarr and Radarr are displayed

---

### Requirement: Calendar Item Display
Each calendar item SHALL display a poster thumbnail, title, subtitle (episode info or movie year), date badge, and download status indicator.

#### Scenario: TV episode item
- **WHEN** a Sonarr episode is displayed
- **THEN** it shows the series poster, series title, episode number and title, and whether the file exists

#### Scenario: Movie item
- **WHEN** a Radarr movie is displayed
- **THEN** it shows the movie poster, title, year, and whether the file exists

---

### Requirement: Calendar Item Navigation
Tapping a calendar item SHALL navigate to the media detail page for that item.

#### Scenario: Tap TV episode
- **WHEN** user taps a TV episode in the calendar
- **THEN** the app navigates to the series detail page

#### Scenario: Tap movie
- **WHEN** user taps a movie in the calendar
- **THEN** the app navigates to the movie detail page

---

### Requirement: Shared Calendar Data Model
The calendar data model and provider SHALL be shared between the Calendar page and the Overview page's "Coming Soon" section.

#### Scenario: Both views use same data
- **WHEN** calendar data is fetched
- **THEN** both the Calendar page and the Overview "Coming Soon" section display consistent data from the same provider
