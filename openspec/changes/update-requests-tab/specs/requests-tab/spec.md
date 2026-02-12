## ADDED Requirements

### Requirement: Pending Requests Section
The Requests page SHALL display a "Needs Approval" section showing pending requests from Jellyseerr as a horizontal scrollable list of approval cards with working approve/decline actions.

#### Scenario: Pending requests displayed
- **WHEN** the Requests page loads and Overseerr is configured
- **THEN** pending requests are fetched via `OverseerrApi.getRequestList(filter: 'pending')` and displayed as horizontal approval cards

#### Scenario: Approve a request
- **WHEN** the user taps the approve button on a pending request
- **THEN** `OverseerrApi.approveRequest(id)` is called and the pending list refreshes

#### Scenario: Decline a request
- **WHEN** the user taps the decline button and confirms
- **THEN** `OverseerrApi.declineRequest(id)` is called and the pending list refreshes

### Requirement: Trending Content Section
The Requests page SHALL display a "Trending Now" section showing popular content from Jellyseerr with request status indicators and request buttons.

#### Scenario: Trending content displayed
- **WHEN** the Requests page loads and Overseerr is configured
- **THEN** trending content is fetched via `OverseerrApi.getTrending()` and displayed in a 2-column grid with poster images and status badges

#### Scenario: Request trending content
- **WHEN** the user taps "+ Request" on an unrequested trending item
- **THEN** `OverseerrApi.createRequest(mediaType, mediaId)` is called and the item status updates to "REQUESTED"

### Requirement: Jellyseerr Model Integration
The Requests feature SHALL use `JellyseerrRequest` and `JellyseerrMediaResult` models from `jellyseerr_models.dart` instead of the local `Request` entity.

#### Scenario: Models from shared layer
- **WHEN** request data is fetched from the API
- **THEN** it is parsed into `JellyseerrRequest` objects with proper `JellyseerrRequestStatus` and `JellyseerrMediaInfo` fields

### Requirement: Overseerr Not Configured State
The Requests page SHALL show a helpful empty state when Overseerr/Jellyseerr is not configured, directing the user to Settings.

#### Scenario: No Overseerr configured
- **WHEN** the Requests page loads and no Overseerr service is configured
- **THEN** an empty state is shown with a message to configure Overseerr in Settings
