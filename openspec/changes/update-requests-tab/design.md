## Context
The requests feature currently has its own data layer (`OverseerrRemoteDataSource`, `RequestsRepositoryImpl`, `Request` entity) that duplicates what the `OverseerrApi` already provides with proper auth. The UI is a flat list with stub approve/decline actions.

## Goals / Non-Goals
- **Goals**:
  - Wire requests tab to `OverseerrApi` via `overseerrApiProvider` (proper API key auth)
  - Use `JellyseerrRequest` and `JellyseerrMediaResult` models (no duplicate models)
  - "Needs Approval" section with horizontal scroll, approve/deny calling real API
  - "Trending Now" section using `getTrending()` with request status indicators
  - AsyncNotifierProvider for request actions (approve/decline/create) with optimistic UI
- **Non-Goals**:
  - Search within the requests tab (separate feature)
  - Detailed request creation flow with season picker (just basic request for now)

## Decisions

### 1. Flatten the Data Layer
**Decision**: Remove `OverseerrRemoteDataSource`, `RequestsRepositoryImpl`, and `Request` entity. Providers call `OverseerrApi` methods directly.

**Why**: The `OverseerrApi` already has typed methods (`getRequestList`, `approveRequest`, etc.) with proper auth. An extra repository/datasource layer adds no value here.

### 2. Provider Architecture
```
overseerrApiProvider (existing)
  ├── pendingRequestsProvider (AsyncNotifierProvider)
  │   └── calls api.getRequestList(filter: 'pending')
  ├── trendingProvider (FutureProvider)
  │   └── calls api.getTrending()
  └── requestActionsProvider (AsyncNotifierProvider)
      ├── approve(id) → calls api.approveRequest(id)
      ├── decline(id) → calls api.declineRequest(id)
      └── createRequest(...) → calls api.createRequest(...)
```

### 3. Page Layout (matching CLAUDE.md spec)
```
CustomScrollView
├── SliverAppBar (pinned, "Requests" title)
├── "NEEDS APPROVAL" section
│   ├── Section header with count badge
│   └── Horizontal scrollable approval cards
├── "TRENDING NOW" section
│   ├── Section header with "View All" link
│   └── 2-column grid of trending media cards
```

### 4. Approval Card Updates
- Keep existing visual design (it's well built)
- Replace `Request` entity references with `JellyseerrRequest`
- Wire approve/decline buttons to `requestActionsProvider`
- Show loading state during action, refresh list on success

### 5. Trending Card
- Poster image (2:3 ratio) with status overlay
- Title and media type below
- Status badge: "REQUESTED", "AVAILABLE", or "+ Request" button
- Tap to request (movie), or show season picker (TV - future)
