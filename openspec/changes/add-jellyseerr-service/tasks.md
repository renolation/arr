## 1. Data Models
- [x] 1.1 Create `lib/core/network/models/jellyseerr_models.dart` with:
  - `JellyseerrMediaStatus` enum with `fromValue(int)` factory
  - `JellyseerrMediaInfo` model (status, downloadStatus, tmdbId, tvdbId)
  - `JellyseerrMediaResult` model (id, mediaType, title, overview, posterPath, backdropPath, releaseDate/firstAirDate, voteAverage, mediaInfo)
  - `JellyseerrRequest` model (id, status, mediaType, mediaInfo, requestedBy, createdAt, updatedAt, seasons)
  - `JellyseerrUser` model (id, displayName, avatar)
  - `PagedResponse<T>` generic wrapper (page, totalPages, totalResults, results)

## 2. Enhance OverseerrApi
- [x] 2.1 Add `getTrending({int page})` → `PagedResponse<JellyseerrMediaResult>` calling `GET /discover/trending`
- [x] 2.2 Add `getPopularMovies({int page})` → `PagedResponse<JellyseerrMediaResult>` calling `GET /discover/movies` with `sortBy=popularity.desc`
- [x] 2.3 Add `getUpcomingMovies({int page})` → `PagedResponse<JellyseerrMediaResult>` calling `GET /discover/movies/upcoming`
- [x] 2.4 Add `getPopularTv({int page})` → `PagedResponse<JellyseerrMediaResult>` calling `GET /discover/tv`
- [x] 2.5 Add typed `searchMedia(String query, {int page})` → `PagedResponse<JellyseerrMediaResult>` wrapping existing search
- [x] 2.6 Add typed `getRequestList({int take, int skip, String? filter, String? sort})` → `PagedResponse<JellyseerrRequest>`
- [x] 2.7 Add unified `createRequest({required String mediaType, required int mediaId, List<int> seasons, bool is4k, int? serverId, int? profileId, String? rootFolder})` → `JellyseerrRequest`

## 3. Validation
- [x] 3.1 Run `dart analyze` on changed files - no issues found
