## ADDED Requirements

### Requirement: Media detail page displays full item information
The app SHALL display a detail page when a user taps a media item in the Library grid.

#### Scenario: User taps a movie card
- **WHEN** the user taps a movie card in the Library grid
- **THEN** a detail page opens showing the movie poster, title, year, runtime, certification, quality badge, and rating
- **AND** three action buttons are displayed: Monitored, Search, Edit
- **AND** a status card shows the current download status and file size
- **AND** an overview section shows the synopsis and genre chips
- **AND** a file information section shows audio codec, video codec, resolution, and bitrate (if movie has a file)

#### Scenario: User taps a series card
- **WHEN** the user taps a series card in the Library grid
- **THEN** a detail page opens showing the series poster, title, year, runtime per episode, certification, and rating
- **AND** the status card shows the series status and network name
- **AND** the file information section is not shown (series have multiple files)

#### Scenario: Media item has no file
- **WHEN** the media item has no downloaded file (hasFile is false or missing)
- **THEN** the status card shows "Missing" status with a red indicator
- **AND** the file information section is not shown

#### Scenario: Back navigation
- **WHEN** the user taps the back button on the detail page
- **THEN** the app returns to the Library grid preserving scroll position and filter state
