# Change: Rewire Requests Tab to Use Jellyseerr API Service

## Why
The Requests tab currently uses a standalone `OverseerrRemoteDataSource` with its own raw `DioClient` (no auth headers). It doesn't use the existing `OverseerrApi` or the typed Jellyseerr models. The approve/decline buttons are stubs. The "Trending Now" section is missing entirely.

## What Changes
- **Rewire providers**: Replace the standalone datasource/repository chain with providers that use the existing `OverseerrApi` (via `overseerrApiProvider`) and its typed methods (`getRequestList`, `getTrending`, `approveRequest`, `declineRequest`, `createRequest`)
- **Use Jellyseerr models**: Replace the `Request` entity with `JellyseerrRequest` from `jellyseerr_models.dart` throughout the requests feature
- **Add "Needs Approval" section**: Horizontal scrollable cards showing pending requests with working approve/deny actions
- **Add "Trending Now" section**: Grid of trending content with request status indicators and "+ Request" buttons
- **Working actions**: Approve, decline, and create request all call the real API
- **Proper states**: Loading, error, empty states for both sections

## Impact
- Affected specs: `requests-tab` (new)
- Affected code:
  - `lib/features/requests/presentation/providers/requests_provider.dart` - full rewrite using OverseerrApi
  - `lib/features/requests/presentation/pages/requests_page.dart` - redesign with two sections
  - `lib/features/requests/presentation/widgets/approval_card.dart` - update to use JellyseerrRequest
  - Add `lib/features/requests/presentation/widgets/trending_card.dart` - new widget for trending items
- Removed:
  - `lib/features/requests/data/datasources/overseerr_remote_datasource.dart` - replaced by OverseerrApi
  - `lib/features/requests/data/repositories/requests_repository.dart` - providers call API directly
  - `lib/features/requests/domain/entities/request.dart` - replaced by JellyseerrRequest
  - `lib/features/requests/domain/repositories/requests_repository.dart` - no longer needed
