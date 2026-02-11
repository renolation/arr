# Change: Add Production-Ready Jellyseerr API Service with Typed Models

## Why
The existing `OverseerrApi` class returns raw `Map<String, dynamic>` for all endpoints and is missing several discovery endpoints (`/discover/trending`, `/discover/movies/upcoming`, popular with sort params). The Requests tab and Library integration need strongly-typed models (`JellyseerrMediaResult`, `JellyseerrRequest`, `PagedResponse`) for safe parsing, and the `createRequest` endpoint needs proper movie vs TV handling with `is4k`, `serverId`, `profileId`, and `rootFolder` parameters.

## What Changes
- **Enhance `OverseerrApi`**: Add missing discovery endpoints (trending, upcoming movies, popular movies with sort, popular TV) and update `createRequest` to support full movie/TV payloads
- **Add typed models** in `lib/core/network/models/jellyseerr_models.dart`:
  - `JellyseerrMediaResult` - parsed discovery/search result with `mediaType`, `mediaInfo` status
  - `JellyseerrRequest` - request object with status, requester, media info
  - `PagedResponse<T>` - generic paginated response wrapper (`results`, `page`, `totalPages`, `totalResults`)
  - `JellyseerrMediaStatus` enum - `UNKNOWN`, `PENDING`, `PROCESSING`, `PARTIALLY_AVAILABLE`, `AVAILABLE`
- **Update `api_providers.dart`**: No changes needed (existing `overseerrApiProvider` already provides `OverseerrApi`)

## Impact
- Affected specs: `jellyseerr-api` (new)
- Affected code:
  - `lib/core/network/overseerr_api.dart` - add discovery endpoints, typed return methods
  - `lib/core/network/models/jellyseerr_models.dart` - new file with typed models
