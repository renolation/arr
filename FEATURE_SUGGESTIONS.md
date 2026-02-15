# ARR Stack Manager - Feature Suggestions

> This document outlines potential new features and enhancements for *arr Stack Manager app.

## Current Features

The app currently provides 5 main tabs for managing your homelab media stack:

| Tab | Description |
|-----|-------------|
| **Overview** | Service statistics, coming soon section, system status |
| **Library** | Unified media browser with filter/sort, grid view, media details |
| **Requests** | Overseerr request management and approvals |
| **Activity** | Download queue monitoring, history, and controls |
| **Settings** | Service configuration (Sonarr, Radarr, Overseerr, qBittorrent, etc.) |

---

## High Priority Features

These features would provide significant value and are essential for a complete homelab management experience.

### 1. Calendar View

Display upcoming TV episodes and movies in a calendar format.

**Why**: Essential for tracking when new content will be available.

**Features**:
- Monthly, weekly, and daily views
- Upcoming TV episodes from Sonarr
- Upcoming movies from Radarr
- Air dates with countdown
- Calendar navigation
- Click to view episode/movie details
- Filter by service (Sonarr/Radarr) or status
- Export calendar (iCal format)

**Technical Requirements**:
- Calendar widget library or custom implementation
- Episode/movie air date data from Sonarr/Radarr
- Date filtering and display logic
- Navigation state management

**Files to Add**:
- `lib/features/calendar/` (complete feature module)
- Calendar widget components
- Update router to add calendar tab or sub-route

---

### 2. Plex + Tautulli Integration

Add Tautulli analytics for comprehensive media statistics (focus on stats, not full Plex integration).

**Why**: Tautulli provides essential viewing statistics that help understand media consumption.

**Features**:
- View Tautulli statistics:
  - Watch time by user
  - Top played items
  - Top genres/studios
  - User activity timeline
- Playback history with timestamps
- Watched/unwatched tracking
- Dashboard with key metrics

**Technical Requirements**:
- Tautulli API integration
- Statistics aggregation and visualization
- Data caching for performance

**Files to Add**:
- `lib/core/services/api/tautulli_api_service.dart`
- `lib/features/tautulli/` module
- Statistics widgets and charts

**Note**: For Jellyfin users, consider integrating similar statistics via:
- **Jellyfin API** for recently added, recently played, and playback history
- **Custom stats service** to track viewing patterns without full integration

---

### 3. Advanced Library Filtering

Add powerful filtering options for library.

**Why**: Power users need fine-grained control over what they see.

**Features**:
- Quality profile filters (4K, 1080p, 720p, etc.)
- Video codec filters (H.264, H.265/HEVC, AV1)
- Audio codec filters (Dolby Digital, DTS, Dolby Atmos)
- Year range filters (slider or date picker)
- Size filters (min/max GB)
- Genre filters with multiple selection
- Network/Studio filters
- Monitor status filters
- Save custom filters as presets

**Technical Requirements**:
- Enhanced filter bottom sheet UI
- Filter state management (Riverpod)
- API queries with filter parameters
- Filter preset storage (Hive)

**Files to Modify**:
- `lib/features/library/presentation/widgets/filter_bottom_sheet.dart`
- `lib/features/library/presentation/providers/media_provider.dart`
- `lib/features/library/domain/entities/media_item.dart` (add codec fields)

---

## Medium Priority Features

These features enhance usability and provide additional value.

### 4. Health Dashboard

Comprehensive health monitoring for all services.

**Why**: Proactively monitor service health and disk space to prevent issues.

**Features**:
- Disk space monitoring:
  - Per-root-folder usage
  - Free space alerts
  - Growth trends
- Service health checks:
  - API connectivity
  - Response times
  - Error rates
- Missing media alerts:
  - Missing episodes
  - Missing movies
  - Failed downloads
- Service-specific health:
  - Sonarr import issues
  - Radarr upgrade notifications
  - Download client health
- Health notifications and alerts

**Files to Add**:
- `lib/features/health/` module
- Health check services
- Health status widgets
- Alert system

---

### 5. Statistics & Analytics

Visualize library and download statistics.

**Why**: Understand library growth, consumption patterns, and optimize storage.

**Features**:
- Library growth over time (charts)
- Download history by month/week
- Top genres, studios, networks
- Storage usage trends
- User request statistics
- Most watched items (via Tautulli)
- Download speed averages
- Quality profile distribution
- Interactive charts and graphs

**Files to Add**:
- `lib/features/statistics/` module
- Chart library integration (fl_chart)
- Statistics aggregation services
- Chart widgets and components

---

### 6. User Management & Authentication

Multi-user support with authentication.

**Why**: Enable proper user accounts with permissions and personalization.

**Features**:
- User authentication (login/register)
- User profiles with avatars
- Per-user request limits
- User-specific library filters and preferences
- User activity reports
- Role-based permissions (admin, user, guest)
- Session management
- Password reset

**Technical Requirements**:
- Authentication system (local or OAuth)
- User database storage (Hive or SQLite)
- Permission checking middleware
- Secure password storage (flutter_secure_storage)

**Files to Add**:
- `lib/features/auth/` module
- `lib/core/storage/auth_storage.dart`
- Login/register screens
- User profile management
- Permission services

---

### 7. Search & Add Media

Search TMDB/TVDB and add new content directly to Sonarr/Radarr.

**Why**: Convenient way to expand library without using web UI.

**Features**:
- Search TMDB (movies and TV shows)
- Search TVDB (TV shows)
- Preview before adding:
  - Trailer playback
  - Detailed info
  - Cast and crew
  - Similar titles
- Add to Sonarr (TV shows):
  - Select quality profile
  - Select root folder
  - Choose seasons to monitor
- Add to Radarr (movies):
  - Select quality profile
  - Select root folder
  - Set minimum availability
- Search history

**Files to Add**:
- `lib/features/search/` module
- TMDB/TVDB API services
- Media preview/detail screens
- Add to library forms

---

### 8. Push Notifications

Send notifications for important events on device.

**Why**: Stay informed without constantly checking the app.

**Prerequisites**: Authentication system (User Management) must be implemented first.

**Features**:
- Download completed notifications
- New request pending (for approvers)
- Failed download alerts
- New episodes available
- Service health issues
- Custom notification preferences per event type
- Notification history

**Technical Requirements**:
- Push notification service (Firebase Cloud Messaging or local)
- Background sync for checking events
- Notification permission handling
- Service polling or webhook integration

**Files to Add**:
- `lib/core/notifications/` module
- Notification providers and services
- Notification permission handling
- Settings for notification preferences

---

## Nice to Have Features

These features provide convenience and polish.

### 9. Webhooks

Send notifications to external services.

**Why**: Integrate with existing notification workflows (Discord, Slack, etc.).

**Features**:
- Discord webhook notifications
- Slack webhook notifications
- Telegram bot integration
- Custom webhook URLs
- Event triggers (download complete, request approved, etc.)
- Custom message templates
- Webhook test functionality

**Technical Requirements**:
- Webhook service with retry logic
- Template engine for custom messages
- Webhook history and logging
- Configuration UI

**Files to Add**:
- `lib/features/webhooks/` module
- Webhook service
- Webhook configuration UI
- Template management

---

### 10. Quick Actions

Convenient one-tap actions from dashboard.

**Why**: Perform common operations quickly without navigating through menus.

**Features**:
- "Refresh All Services" button
- "Clear Cache" button
- "Force Re-sync" for individual services
- "Pause All Downloads" quick action
- "Export Settings" for backup
- Custom quick actions (user-defined)

**Files to Add**:
- Quick action widget components
- Action execution services
- Settings for quick action customization

---

## Implementation Priority

### Phase 1 (Core Enhancements)
1. Calendar View
2. Advanced Library Filtering
3. Health Dashboard

### Phase 2 (Statistics & Integration)
4. Plex + Tautulli Integration (or Jellyfin stats alternative)
5. Statistics & Analytics
6. User Management & Authentication

### Phase 3 (Convenience Features)
7. Search & Add Media
8. Quick Actions

### Phase 4 (Advanced Features)
9. Push Notifications (requires auth)
10. Webhooks (lower priority)

---

## Architecture Considerations

### New Service Integration Pattern

When adding new services (Tautulli, etc.):

1. Create API service in `lib/core/services/api/`
2. Add feature module in `lib/features/[service]/`
3. Follow clean architecture pattern (data/domain/presentation)
4. Add service configuration to settings
5. Update router with new routes
6. Add service types to `ServiceType` enum
7. Update storage constants for new Hive boxes

### Authentication Strategy

For User Management & Authentication:

**Option 1: Local Authentication (Simple)**
- Username/password stored locally
- Session tokens in secure storage
- No backend required
- Good for single-user or small group

**Option 2: OAuth with Media Servers (Recommended)**
- Use Jellyfin/Plex OAuth for authentication
- Single sign-on
- Managed by existing services
- Better for multi-user setups

**Option 3: Custom Backend (Complex)**
- Full authentication server
- User database
- API token management
- Overkill for this use case

**Recommendation**: Start with Option 1, add Option 2 integration later.

### Storage Strategy

- **Hive**: Cache library data, settings, preferences, user profiles
- **Secure Storage**: API keys, tokens, passwords, sensitive data
- **SQLite** (optional): Statistics, playback history, complex queries

### Performance Optimization

- Implement pagination for large libraries
- Use image caching for posters/backdrops
- Debounce search queries
- Lazy load calendar views
- Implement request batching
- Cache statistics data (refresh periodically)

---

## Jellyfin Statistics Alternative

Instead of full Jellyfin integration, consider a lightweight stats approach:

### Jellyfin Statistics Service

**Why**: Provide viewing analytics without full integration complexity.

**Features**:
- Recently added items
- Recently played items
- Playback history
- Watch time tracking
- Most played content
- User activity (if multi-user)

**Technical Approach**:
- Use Jellyfin API endpoints:
  - `/Users/{userId}/Items/Latest`
  - `/Users/{userId}/Items/Resume`
  - `/Users/{userId}/Items/RecentlyAdded`
- Cache statistics locally
- Simple display in statistics dashboard

**Files to Add**:
- `lib/core/services/api/jellyfin_stats_service.dart` (lightweight)
- `lib/features/jellyfin_stats/` module (dashboard only)

This provides value without the complexity of full playback integration.

---

## Related OpenSpec Proposals

Current active proposals that align with these suggestions:

- `add-jellyseerr-service` - Jellyseerr API integration
- `add-library-filter-sort` - Library filtering enhancements
- `add-media-detail-page` - Media detail view improvements

## Existing Features

The following features are already implemented:

- ✅ Season detail view - `lib/features/library/presentation/pages/season_detail_page.dart`
- ✅ Media detail view - `lib/features/library/presentation/pages/media_detail_page.dart`
- ✅ Library filtering - `lib/features/library/presentation/widgets/filter_bottom_sheet.dart`
- ✅ Library sorting - `lib/features/library/presentation/widgets/sort_bottom_sheet.dart`

---

## Feedback & Discussion

Feel free to discuss these features and provide feedback on:
- Priority of features
- Specific implementation details
- Additional features not listed
- Architectural concerns
- Authentication approach preferences

---

*Last updated: 2026-02-15*
