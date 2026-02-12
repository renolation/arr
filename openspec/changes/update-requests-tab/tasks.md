## 1. Rewrite Providers
- [x] 1.1 Rewrite `requests_provider.dart` to use `overseerrApiProvider` for all API calls
- [x] 1.2 Create `pendingRequestsProvider` (AsyncNotifierProvider) calling `api.getRequestList(filter: 'pending')`
- [x] 1.3 Create `trendingProvider` (FutureProvider) calling `api.getTrending()`
- [x] 1.4 Create `RequestActionsNotifier` with `approve(id)`, `decline(id)`, `createRequest(...)` methods that call the real API and refresh the request list

## 2. Update Widgets
- [x] 2.1 Update `approval_card.dart` to use `JellyseerrRequest` instead of `Request` entity, wire approve/decline to `RequestActionsNotifier`
- [x] 2.2 Create `trending_card.dart` widget showing poster, title, status overlay, and "+ Request" button

## 3. Redesign Requests Page
- [x] 3.1 Rewrite `requests_page.dart` with "Needs Approval" horizontal section and "Trending Now" grid section
- [x] 3.2 Add proper loading/error/empty states for both sections
- [x] 3.3 Wire create request action from trending cards

## 4. Cleanup
- [x] 4.1 Remove old data layer files (overseerr_remote_datasource.dart, requests_repository.dart, request.dart entity, requests_repository interface)
- [x] 4.2 Run `dart analyze` to verify no errors
