## Context
The existing `OverseerrApi` extends `BaseApiService` and already has basic methods (search, requests, discover). All return raw maps. The user wants production-ready typed models and full endpoint coverage matching the Jellyseerr/Overseerr API v1.

## Goals / Non-Goals
- **Goals**:
  - Typed models for all Jellyseerr responses (no raw maps in consuming code)
  - Full discovery endpoint coverage: trending, popular movies, upcoming movies, popular TV
  - Proper `createRequest` handling both movie and TV with all parameters
  - `JellyseerrMediaStatus` enum mapping from API integer status codes
  - Paginated response wrapper for list endpoints
- **Non-Goals**:
  - Replacing the existing `OverseerrApi` class name (keep it, add methods)
  - UI/provider changes (separate concern)
  - User management endpoints beyond what exists

## Decisions

### 1. Enhance Existing `OverseerrApi` Rather Than New Class
**Decision**: Add typed methods alongside existing raw map methods. New typed methods use a `Typed` suffix or replace existing ones.

**Why**: `OverseerrApi` already extends `BaseApiService` with correct auth. No need for a new class.

### 2. Model Design
**Decision**: Manual `fromJson` factories (no code generation).

**Why**:
- Consistent with existing `MediaItem.fromJson` pattern
- Avoids build_runner dependency for 3 simple models
- Jellyseerr API responses are flat enough for manual parsing

### 3. Media Status Mapping
Jellyseerr uses integer status codes in `mediaInfo.status`:
```
1 = UNKNOWN
2 = PENDING
3 = PROCESSING
4 = PARTIALLY_AVAILABLE
5 = AVAILABLE
```

**Decision**: Map to `JellyseerrMediaStatus` enum with `fromValue(int)` factory.

### 4. Request Creation Payload
**Decision**: Single `createRequest` method with named parameters. `mediaType` determines which fields are used.

```dart
Future<JellyseerrRequest> createRequest({
  required String mediaType, // 'movie' or 'tv'
  required int mediaId,      // TMDB ID
  List<int> seasons = const [],
  bool is4k = false,
  int? serverId,
  int? profileId,
  String? rootFolder,
})
```

### 5. PagedResponse Generic Wrapper
Jellyseerr paginated endpoints return:
```json
{
  "page": 1,
  "totalPages": 10,
  "totalResults": 200,
  "results": [...]
}
```

**Decision**: `PagedResponse<T>` generic class with `fromJson` taking a `T Function(Map<String, dynamic>)` item parser.

## Risks / Trade-offs
- **Breaking existing code**: Existing methods return raw maps. We'll add new typed methods and keep old ones to avoid breaking existing callers. Old methods can be deprecated later.
