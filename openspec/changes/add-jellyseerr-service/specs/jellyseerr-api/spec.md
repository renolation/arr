## ADDED Requirements

### Requirement: Jellyseerr Typed Data Models
The system SHALL provide typed Dart models for Jellyseerr API responses including `JellyseerrMediaResult`, `JellyseerrRequest`, `JellyseerrMediaInfo`, `JellyseerrUser`, `JellyseerrMediaStatus` enum, and a generic `PagedResponse<T>` wrapper.

#### Scenario: Media status mapping from integer
- **WHEN** the API returns `mediaInfo.status` as integer 5
- **THEN** the model maps it to `JellyseerrMediaStatus.available`

#### Scenario: Parsing a search result
- **WHEN** the API returns a search result with `mediaType: "movie"` and `mediaInfo: {status: 5}`
- **THEN** a `JellyseerrMediaResult` is created with `mediaType == "movie"` and `mediaInfo.status == JellyseerrMediaStatus.available`

### Requirement: Discovery Endpoints
The `OverseerrApi` class SHALL provide typed methods for all Jellyseerr discovery endpoints: `getTrending`, `getPopularMovies`, `getUpcomingMovies`, and `getPopularTv`, each returning `PagedResponse<JellyseerrMediaResult>`.

#### Scenario: Fetch trending content
- **WHEN** `getTrending(page: 1)` is called
- **THEN** a `GET /discover/trending?page=1` request is made and the response is parsed into `PagedResponse<JellyseerrMediaResult>`

#### Scenario: Fetch popular movies sorted by popularity
- **WHEN** `getPopularMovies(page: 1)` is called
- **THEN** a `GET /discover/movies?page=1&sortBy=popularity.desc` request is made

#### Scenario: Fetch upcoming movies
- **WHEN** `getUpcomingMovies()` is called
- **THEN** a `GET /discover/movies/upcoming` request is made

### Requirement: Typed Search
The `OverseerrApi` class SHALL provide a `searchMedia` method returning `PagedResponse<JellyseerrMediaResult>` with parsed media status.

#### Scenario: Search returns mixed results
- **WHEN** `searchMedia("Batman")` is called
- **THEN** results contain both movie and TV items with their respective `mediaType` and `mediaInfo` fields parsed

### Requirement: Typed Request Management
The `OverseerrApi` class SHALL provide `getRequestList` returning `PagedResponse<JellyseerrRequest>` with pagination and filtering support.

#### Scenario: Fetch pending requests
- **WHEN** `getRequestList(filter: "pending", take: 10)` is called
- **THEN** a `GET /request?filter=pending&take=10&sort=added` request is made and results are parsed into `JellyseerrRequest` objects

### Requirement: Unified Create Request
The `OverseerrApi` class SHALL provide a single `createRequest` method that handles both movie and TV requests with `mediaType`, `mediaId`, `seasons`, `is4k`, `serverId`, `profileId`, and `rootFolder` parameters.

#### Scenario: Create movie request
- **WHEN** `createRequest(mediaType: "movie", mediaId: 12345)` is called
- **THEN** a POST to `/request` is made with `{"mediaType": "movie", "mediaId": 12345, "seasons": [], "is4k": false}`

#### Scenario: Create TV request with specific seasons
- **WHEN** `createRequest(mediaType: "tv", mediaId: 67890, seasons: [1, 2])` is called
- **THEN** a POST to `/request` is made with `{"mediaType": "tv", "mediaId": 67890, "seasons": [1, 2], "is4k": false}`
