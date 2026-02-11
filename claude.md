<!-- OPENSPEC:START -->
# OpenSpec Instructions

These instructions are for AI assistants working in this project.

Always open `@/openspec/AGENTS.md` when the request:
- Mentions planning or proposals (words like proposal, spec, change, plan)
- Introduces new capabilities, breaking changes, architecture shifts, or big performance/security work
- Sounds ambiguous and you need the authoritative spec before coding

Use `@/openspec/AGENTS.md` to learn:
- How to create and apply change proposals
- Spec format and conventions
- Project structure and guidelines

Keep this managed block so 'openspec update' can refresh the instructions.

<!-- OPENSPEC:END -->

# Flutter App Expert Guidelines

## Flexibility Notice
**Important**: This is a recommended project structure, but be flexible and adapt to existing project structures. Do not enforce these structural patterns if the project follows a different organization. Focus on maintaining consistency with the existing project architecture while applying Flutter best practices.

## Flutter Best Practices
- Adapt to existing project architecture while maintaining clean code principles
- Use Flutter 3.x features and Material 3 design
- Implement clean architecture with Riverpod pattern
- Follow proper state management principles
- Use proper dependency injection
- Implement proper error handling
- Follow platform-specific design guidelines
- Use proper localization techniques

## Preferred Project Structure
**Note**: This is a reference structure. Adapt to the project's existing organization.

```
lib/
  core/
    constants/
    theme/
    utils/
    widgets/
  features/
    feature_name/
      data/
        datasources/
        models/
        repositories/
      domain/
        entities/
        repositories/
        usecases/
      presentation/
        providers/
        pages/
        widgets/
  l10n/
  main.dart
test/
  unit/
  widget/
  integration/
```

## Coding Guidelines
1. Use proper null safety practices
2. Implement proper error handling with Either type
3. Follow proper naming conventions
4. Use proper widget composition
5. Implement proper routing using GoRouter
6. Use proper form validation
7. Follow proper state management with Riverpod
8. Implement proper dependency injection using GetIt
9. Use proper asset management

## Widget Guidelines
1. Keep widgets small and focused
2. Use const constructors when possible
3. Implement proper widget keys
4. Follow proper layout principles
5. Use proper widget lifecycle methods
6. Implement proper error boundaries
7. Use proper performance optimization techniques
8. Follow proper accessibility guidelines

## Performance Guidelines
1. Use proper image caching
2. Implement proper list view optimization
3. Use proper build methods optimization
4. Follow proper state management patterns
5. Implement proper memory management
6. Use proper platform channels when needed
7. Follow proper compilation optimization techniques

## Refactoring Instructions
When refactoring code:
- Always maintain existing project structure patterns
- Prioritize consistency with current codebase
- Apply Flutter best practices without breaking existing architecture
- Focus on incremental improvements
- Ensure all changes maintain backward compatibility

---

# App Context - *arr Stack Management App

## About This App
A Flutter mobile application for managing *arr stack services (Sonarr, Radarr, Overseerr, and Download Clients). The app provides a unified, function-based interface to monitor and manage your media server stack from your mobile device with a strict minimalist/Swiss design aesthetic.

## Target Users
- Home media server enthusiasts
- Self-hosted media management users
- Users running Sonarr, Radarr, Overseerr, and download client services

## Core Features
### Navigation Structure (Function-Based)
- **Bottom Navigation Bar**: 4 function-based tabs (NOT service-based)
  1. **Overview**: Dashboard with system status and quick stats
  2. **Library**: Unified view of all movies and TV shows (merged from Radarr + Sonarr)
  3. **Requests**: Content request management (Overseerr/Jellyseerr integration)
  4. **Activity**: Real-time download queue and history

### Tab Functionality
- **Overview Tab**:
  - System status cards (Disk Space, Download Speed, System Issues)
  - "Airing & Releasing" section (unified calendar showing upcoming movies and TV episodes)
  - "Active Downloads" section showing current download queue

- **Library Tab**:
  - Unified grid view of ALL media (movies + TV shows merged)
  - Filter options: ALL, MOVIES, TV SHOWS, MISSING
  - Search functionality across entire collection
  - Quality badges (4K, 1080p, etc.)
  - Status indicators (Ended, Missing, Returning)

- **Requests Tab**:
  - "Needs Approval" section for pending user requests
  - "Trending Now" section showing popular content
  - Request status indicators (Requested, Available, Downloading)
  - User request management with approve/deny actions

- **Activity Tab**:
  - Real-time download queue with progress bars
  - Download speed and ETA information
  - Pause/Resume/Cancel controls
  - Status indicators (Downloading, Paused, Queued, Slow Speed)
  - "Recent History" section showing completed/failed downloads

### Data Management
- **Endpoint Storage**: Securely store service URLs and API keys using Hive
- **Multi-Service Support**: Manage multiple instances of each service (Radarr, Sonarr, Overseerr, Download Clients)
- **Offline Caching**: Cache data for offline viewing using Hive local database
- **Unified Data Model**: Merge movies and TV shows into a single browsable collection
- **Real-time Updates**: Live download progress and status updates

## Technical Stack
### Flutter & Dart
- Flutter 3.x with Material 3 design
- Dart 3.x with null safety

### Architecture & State Management
- Clean architecture with feature-first structure
- **Riverpod** for state management (NOT BLoC)
- Repository pattern for data layer
- **Hive** for local database and caching

### Key Dependencies
- `flutter_riverpod` / `riverpod` - State management
- `hive` / `hive_flutter` - Local database and caching
- `dio` - HTTP client for API calls
- `go_router` - Navigation
- `flutter_secure_storage` - Secure storage for sensitive API keys
- `cached_network_image` - Image caching for movie/show posters
- `json_annotation` / `freezed` - Model serialization
- `hive_generator` - Code generation for Hive adapters

## API Integration
### Sonarr API
- **Base URL**: User-configured endpoint stored in Hive
- **API Spec**: https://raw.githubusercontent.com/Sonarr/Sonarr/v5-develop/src/Sonarr.Api.V5/openapi.json
- **Authentication**: API key-based (stored securely)
- **Main Endpoints**:
  - Get series list
  - Get series details
  - Get episode information
  - Get calendar (upcoming episodes)
  - System status

### Radarr API
- **Base URL**: User-configured endpoint stored in Hive
- **API Spec**: Similar structure to Sonarr
- **Authentication**: API key-based (stored securely)
- **Main Endpoints**:
  - Get movies list
  - Get movie details
  - Get calendar (upcoming releases)
  - System status

### Overseerr/Jellyseerr API
- **Base URL**: User-configured endpoint stored in Hive
- **Authentication**: API key-based (stored securely)
- **Main Endpoints**:
  - Get pending requests
  - Approve/deny requests
  - Get trending content
  - Request new content
  - Get request status

### Download Client API (qBittorrent/Transmission/SABnzbd)
- **Base URL**: User-configured endpoint stored in Hive
- **Authentication**: Username/password or API key
- **Main Endpoints**:
  - Get active downloads/torrents
  - Get download queue
  - Pause/Resume/Delete downloads
  - Get download statistics
  - Get transfer speeds

## Data Models & Storage
- **Location**: `lib/models/` (already implemented)
- **Generated from**: Sonarr/Radarr/Overseerr OpenAPI specifications
- **Hive Storage**:
  - Service configurations (endpoints, API keys for all services)
  - Cached media data (unified movies + series, episodes)
  - User preferences and settings
  - Request data (Overseerr)
  - Download queue data (Download Clients)
- **Key Models**:
  - `MediaItem` - Unified model for both Series and Movies (with type discriminator)
  - `Series` models (with Hive adapters)
  - `Movie` models (with Hive adapters)
  - `Episode` models (with Hive adapters)
  - `Request` models (Overseerr requests)
  - `Download` models (Download client queue items)
  - `ServiceConfig` models (multi-service configuration)
  - `SystemStatus` models (disk space, speeds, issues)
  - API response wrappers

## State Management Architecture (Riverpod)
### Provider Structure
```
providers/
  auth_providers.dart           # API authentication for all services
  service_providers.dart        # Service configuration (multi-service)
  media_providers.dart          # Unified media state (merged movies + TV)
  sonarr_providers.dart         # Sonarr-specific state
  radarr_providers.dart         # Radarr-specific state
  overseerr_providers.dart      # Overseerr request management
  download_providers.dart       # Download client state
  system_providers.dart         # System status (disk, speed, issues)
  settings_providers.dart       # App settings
```

### Key Provider Types
- **StateNotifierProvider**: For complex state (unified media lists, download queue, service status)
- **FutureProvider**: For API calls and async operations
- **Provider**: For dependency injection (API clients, repositories)
- **StreamProvider**: For real-time updates (download progress, system stats)

## Hive Database Schema
### Boxes
- `servicesBox`: Store all service configurations (Radarr, Sonarr, Overseerr, Download Clients)
- `mediaUnifiedBox`: Unified cache for merged movies and TV shows
- `sonarrCacheBox`: Cache Sonarr-specific data
- `radarrCacheBox`: Cache Radarr-specific data
- `overseerrCacheBox`: Cache Overseerr request data
- `downloadQueueBox`: Cache download client queue data
- `settingsBox`: Store app preferences
- `systemStatusBox`: Cache system status (disk space, speeds, issues)

### Models with Hive Adapters
- `ServiceConfig` - Multi-service endpoints and API keys
- `MediaItem` - Unified model for Movies and Series (with type discriminator)
- `Series` - TV show data
- `Movie` - Movie data
- `Episode` - Episode data
- `Request` - Overseerr/Jellyseerr request data
- `Download` - Download queue item data
- `SystemStatus` - System metrics (disk, speed, issues)
- `AppSettings` - User preferences

## Design System (Minimalist/Swiss Design)
### Core Principles
- **NO Glassmorphism**: No blur effects, transparency, or frosted glass aesthetics
- **Flat Design**: Elevation-free cards with subtle borders
- **High Contrast**: Clear, readable typography with strong color contrast
- **Functional**: Design serves purpose, not decoration
- **Consistent Spacing**: Strict grid system and spacing rules

### Color System
#### Light Mode
- **Background**: `Colors.white` or `Color(0xFFFAFAFA)`
- **Surface**: `Colors.grey[100]` or `Color(0xFFF5F5F5)`
- **Card Background**: `Colors.white` with `BorderSide(color: Colors.grey[300])`
- **Primary**: Blue (`Color(0xFF2196F3)`)
- **Text Primary**: `Colors.black87`
- **Text Secondary**: `Colors.grey[600]`
- **Success**: Green (`Color(0xFF4CAF50)`)
- **Warning**: Amber (`Color(0xFFFFC107)`)
- **Error**: Red (`Color(0xFFF44336)`)

#### Dark Mode
- **Background**: `Color(0xFF121212)`
- **Surface**: `Color(0xFF1E1E1E)`
- **Card Background**: `Color(0xFF2C2C2C)` with `BorderSide(color: Colors.grey[800])`
- **Primary**: Blue (`Color(0xFF42A5F5)`)
- **Text Primary**: `Colors.white`
- **Text Secondary**: `Colors.grey[400]`
- **Success**: Green (`Color(0xFF66BB6A)`)
- **Warning**: Amber (`Color(0xFFFFCA28)`)
- **Error**: Red (`Color(0xFFEF5350)`)

### Typography
- **Display Large**: 32px, FontWeight.bold, tight letter spacing
- **Headline**: 24px, FontWeight.w600
- **Title**: 20px, FontWeight.w600
- **Body Large**: 16px, FontWeight.normal
- **Body**: 14px, FontWeight.normal
- **Caption**: 12px, FontWeight.normal, reduced opacity
- **Label**: 12px, FontWeight.w500, uppercase, letter spacing

### Component Styles
#### Cards
```dart
Card(
  elevation: 0,
  color: isDark ? Color(0xFF2C2C2C) : Colors.white,
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(8),
    side: BorderSide(
      color: isDark ? Colors.grey[800]! : Colors.grey[300]!,
      width: 1,
    ),
  ),
)
```

#### Buttons
```dart
// Primary Button
ElevatedButton(
  style: ElevatedButton.styleFrom(
    backgroundColor: Color(0xFF2196F3),
    foregroundColor: Colors.white,
    elevation: 0,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(8),
    ),
  ),
)

// Secondary Button
OutlinedButton(
  style: OutlinedButton.styleFrom(
    foregroundColor: Color(0xFF2196F3),
    side: BorderSide(color: Color(0xFF2196F3)),
    elevation: 0,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(8),
    ),
  ),
)
```

#### Status Badges
```dart
Container(
  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
  decoration: BoxDecoration(
    color: statusColor.withOpacity(0.15),
    borderRadius: BorderRadius.circular(4),
    border: Border.all(color: statusColor, width: 1),
  ),
  child: Text(
    status,
    style: TextStyle(
      color: statusColor,
      fontSize: 10,
      fontWeight: FontWeight.w600,
      letterSpacing: 0.5,
    ),
  ),
)
```

### Spacing System
- **xs**: 4px
- **sm**: 8px
- **md**: 16px
- **lg**: 24px
- **xl**: 32px
- **xxl**: 48px

### Grid System
- **Mobile**: 2 columns (portrait), 3 columns (landscape)
- **Tablet**: 3-4 columns
- **Card Aspect Ratio**: 2:3 (poster style)
- **Grid Spacing**: 16px gap between items


## UI/UX Requirements
### Overview Screen (Dashboard)
#### System Status Section
- **Layout**: Horizontal row of 3 flat stat cards
- **Card 1 - Disk Space**:
  - Icon: Storage/Disk icon
  - Primary text: "14 / 20 TB"
  - Secondary text: "70% Used"
  - Linear progress indicator
- **Card 2 - Download Speed**:
  - Icon: Download icon
  - Primary text: "45.2 MB/s"
  - Secondary text: "Active" (green status)
- **Card 3 - System Issues**:
  - Icon: Alert icon
  - Primary text: "0 Warnings"
  - Secondary text: "Healthy" (green status)

#### Airing & Releasing Section
- **Section Title**: "AIRING & RELEASING" with "View Calendar" link
- **Layout**: Horizontal scrollable list
- **Card Style**: Poster images (2:3 aspect ratio) with metadata
- **Metadata Display**:
  - Movie format: "Movie • 2160p"
  - Episode format: "S03 E01 • 1080p"
- **Calendar Badge**: "TODAY", "TMRW", "FRI" labels

#### Active Downloads Section
- **Section Title**: "ACTIVE DOWNLOADS"
- **Layout**: Vertical list of download items
- **Item Components**:
  - Leading: Poster thumbnail
  - Title: Media name with episode/quality info
  - Subtitle: Progress percentage, data left, speed
  - Progress bar: Linear indicator
  - Status badge: "Slow Speed", time remaining
  - Actions: Pause/Resume button, Cancel button

### Library Screen
#### Search and Filters
- **Search Bar**: Top of screen with "Search collection..." placeholder
- **Filter Chips**: Horizontal scrollable row
  - "ALL" (selected state with white background)
  - "MOVIES" (outlined)
  - "TV SHOWS" (outlined)
  - "MISSING" (outlined with red indicator)

#### Media Grid
- **Layout**: Responsive grid (2-3 columns based on screen size)
- **Card Components**:
  - Poster image (2:3 aspect ratio)
  - Quality badge: Top-left corner ("4K", "1080p", "4K HDR")
  - Status badge: Top-right corner ("Ended", "Missing", "Returning")
  - Title: Below poster
  - Metadata: Year • Type (Movie/Series)
- **Loading States**: Skeleton cards while loading
- **Empty State**: "No media found" message

### Requests Screen
#### Needs Approval Section
- **Section Title**: "NEEDS APPROVAL" with count badge
- **Layout**: Horizontal scrollable cards
- **Card Components**:
  - Poster image
  - Title and year
  - User avatar with "Req. by [Name]"
  - Action buttons: "Approve" (blue), "Deny" (outlined)

#### Trending Now Section
- **Section Title**: "TRENDING NOW" with "View All" link
- **Layout**: 2-column grid
- **Card Components**:
  - Poster image
  - Status overlay: "REQUESTED", "AVAILABLE", indicator
  - Title and type
  - Request button: "+ Request" or "Play" for available

### Activity Screen
#### Header Stats
- **Layout**: Header showing aggregate stats
- **Display**: "3 Downloading • 45.2 MB/s Total"

#### Active Downloads Section
- **Layout**: Vertical list of download items
- **Item Components**:
  - Leading: Poster thumbnail
  - Title: Media name with episode/quality info
  - Subtitle: Progress %, data left, speed
  - Progress bar: Linear indicator with percentage
  - Status indicators: "Slow Speed" warning, time estimate
  - Actions: Pause/Resume, Cancel buttons

#### Recent History Section
- **Section Title**: "RECENT HISTORY"
- **Item Components**:
  - Success state: Green checkmark, "Completed 2h ago", file size
  - Failed state: Red error icon, "Failed • Missing files", "Retry" button

### Settings Screen
#### Service Configuration
- **Layout**: Vertical stack of expandable service cards
- **Card States**: Collapsed (icon + name + chevron), Expanded (form fields)
- **Service Types**:
  - "MOVIE SERVER (RADARR)" - Blue icon
  - "TV SERVER (SONARR)" - TV icon
  - "REQUESTS (OVERSEERR)" - Checkmark icon
  - "DOWNLOAD CLIENT" - Cloud icon

#### Configuration Form (Expanded)
- **Fields**:
  - Host URL: Text input with example
  - API Key: Password input (masked)
  - Port Number: Number input
- **Actions**:
  - "TEST CONNECTION" (outlined button)
  - "SAVE" (primary blue button)

#### Global Actions
- **Primary Actions**:
  - "SYNC ALL SERVICES" (large white button)
  - "RESET CONFIGURATION" (red text button)

### Search Screen (Manual Search)
- **Search Input**: Top with media title
- **Filter Options**: SIZE, PEERS, SEEDERS, QUALITY (chip buttons)
- **Results List**: Vertical list of torrent/release options
- **Result Card Components**:
  - Release name (truncated)
  - Quality badge: "2160P REMUX", "1080P BLURAY", "2160P WEB-DL"
  - File size: "24.5 GB"
  - Seeders/Peers: "S: 842 P: 45" (green for healthy)
  - Release group: "WAKANDA", "RARBG", "1337X"
  - Download button: Icon button
  - Block button: Prohibition icon (for unwanted releases)

### Detail Screen (Movie/Series)
- **Hero Section**:
  - Large poster image with white border/shadow
  - Title (large, bold)
  - Metadata: Year • Runtime • Rating
  - Quality badge: "BLURAY-1080P"
  - Rating: Star icon with score "8.6/10"

- **Action Buttons**:
  - "MONITORED" (primary blue) / "UNMONITORED" state
  - "SEARCH" (outlined) - Manual search
  - "EDIT" (outlined) - Edit metadata

- **Status Card**:
  - "CURRENT STATUS" label
  - Status: "Downloaded" (green) / other states
  - File size: "14.2 GB"
  - Folder icon indicator

- **Overview Section**:
  - "OVERVIEW" label
  - Synopsis text (paragraph)
  - Genre tags: "Adventure", "Drama", "Sci-Fi" (outlined chips)

- **File Information Section**:
  - "FILE INFORMATION" label
  - Technical details in rows:
    - Audio Codec: "DTS-HD MA 5.1"
    - Video Codec: "x264"
    - Resolution: "1920x1080"
    - Bitrate: "11.8 Mbps"

- **Recommendations Section**:
  - "YOU MIGHT ALSO LIKE" label
  - Horizontal scrollable list of related posters

### Grid View Display
- **Layout**: Responsive grid adapting to screen size
- **Card Style**: Poster-first with minimal text overlay
- **Quality Indicators**: Badge overlays (4K, 1080p, etc.)
- **Status Indicators**: Colored badges (Ended, Missing, Returning)
- **Loading States**: Skeleton loaders with proper Riverpod AsyncValue handling
- **Error Handling**: User-friendly error cards with retry option

### Bottom Navigation
- **Style**: Flat, no elevation
- **Icons**: Simple, outlined style (not filled)
- **Labels**: Always visible, uppercase
- **Selected State**: Primary blue color with label
- **Unselected State**: Grey with reduced opacity

## Current Development Focus
### Phase 1: Core Infrastructure
- [x] Basic app structure with bottom navigation (function-based, not service-based)
- [x] Hive database setup and model adapters
- [ ] Riverpod provider architecture for all services
- [ ] Service endpoint configuration and Hive storage (multi-service)
- [ ] API client implementation for Sonarr/Radarr/Overseerr/Download Clients
- [ ] Unified data model for merged media (MediaItem)

### Phase 2: Overview Screen
- [ ] System status cards (Disk Space, Download Speed, System Issues)
- [ ] "Airing & Releasing" section with unified calendar
- [ ] "Active Downloads" section with real-time progress
- [ ] Pull-to-refresh functionality
- [ ] Loading and error states

### Phase 3: Library Screen
- [ ] Unified grid view for all media (movies + TV merged)
- [ ] Search functionality across entire collection
- [ ] Filter implementation (ALL, MOVIES, TV SHOWS, MISSING)
- [ ] Quality and status badge overlays
- [ ] Infinite scroll/pagination
- [ ] Skeleton loading states

### Phase 4: Requests Screen
- [ ] "Needs Approval" section with approve/deny actions
- [ ] "Trending Now" section with request functionality
- [ ] Overseerr API integration
- [ ] Request status indicators
- [ ] User management (if applicable)

### Phase 5: Activity Screen
- [ ] Real-time download queue display
- [ ] Progress bars and ETA calculations
- [ ] Pause/Resume/Cancel controls
- [ ] "Recent History" section
- [ ] Status indicators (Downloading, Paused, Failed, etc.)
- [ ] Stream updates for live data

### Phase 6: Detail Screen
- [ ] Movie/Series detail view
- [ ] Manual search functionality
- [ ] Edit metadata capabilities
- [ ] Monitor/Unmonitor toggle
- [ ] Recommendations section
- [ ] File information display

### Phase 7: Settings Screen
- [ ] Multi-service configuration UI
- [ ] Expandable service cards
- [ ] Connection testing
- [ ] Sync all services action
- [ ] Configuration import/export

### Phase 8: Polish & Optimization
- [ ] Image caching and optimization
- [ ] Error handling and offline support with Hive
- [ ] Performance optimization (grid scrolling, large lists)
- [ ] Accessibility improvements
- [ ] Dark mode refinement
- [ ] Animation polish

## Domain Knowledge
### *arr Stack Context
- **Sonarr**: TV show management (downloading, organizing, monitoring)
- **Radarr**: Movie management (downloading, organizing, monitoring)
- **Overseerr/Jellyseerr**: Request management for Plex/Jellyfin users
- **Download Clients**: qBittorrent, Transmission, SABnzbd, NZBGet
- **Quality Profiles**: User-defined quality preferences
- **Root Folders**: Storage locations for media
- **Indexers**: Sources for finding content (Torznab, Newznab)

### Key Workflows
1. **Service Setup**: Add all service endpoints (Radarr + Sonarr + Overseerr + Download Client) → Test connections → Save to Hive
2. **Media Browsing**: View unified library (merged movies + TV) → Tap for details → Manual search if needed
3. **Request Management**: View pending requests → Approve/Deny → Track status in Activity
4. **Download Monitoring**: View active downloads → Pause/Resume/Cancel → Check history for completed
5. **Multi-Service Management**: Switch between different service instances via Settings
6. **Offline Support**: Display cached data from Hive when offline

### Important Data Concepts
- **MediaItem**: Unified model representing either a Movie or Series
- **Series/Movies**: Core media entities with metadata (cached in Hive)
- **Episodes**: Individual episodes within TV series with air dates
- **Requests**: User-submitted content requests (Overseerr)
- **Downloads**: Active and queued downloads from download clients
- **Quality Profiles**: Preferred quality settings (1080p, 4K, etc.)
- **Download Status**: Current status of media acquisition (Downloading, Paused, Queued, Failed)
- **Monitoring**: Whether the service is actively looking for new content
- **Calendar Events**: Upcoming movie releases and TV episode air dates

### Status Types
#### Media Status
- **Available**: Downloaded and available
- **Missing**: Monitored but not downloaded
- **Downloading**: Currently being downloaded
- **Ended**: Series has ended
- **Returning**: Series will return with new episodes

#### Download Status
- **Downloading**: Actively downloading
- **Paused**: Temporarily stopped
- **Queued**: Waiting to start
- **Completed**: Successfully downloaded
- **Failed**: Download failed
- **Slow Speed**: Downloading but slower than expected

#### Request Status
- **Pending**: Awaiting approval
- **Approved**: Approved and searching
- **Available**: Content is available
- **Requested**: User has requested but not yet approved

## Performance Considerations
- **Image Loading**: Lazy load poster images with caching (use cached_network_image)
- **Hive Performance**: Use efficient queries and indexing for large media libraries
- **Riverpod Optimization**: Proper provider scoping and disposal, selective rebuilds
- **API Calls**: Implement proper pagination for large media libraries (50-100 items per page)
- **Refresh Strategy**: Pull-to-refresh and background sync to Hive
- **Memory Management**: Dispose of resources properly in grid views and image caches
- **Grid Scrolling**: Use ListView.builder with proper itemExtent for efficient scrolling
- **Real-time Updates**: Stream providers for download progress without excessive rebuilds
- **Unified Data**: Efficiently merge movies and TV shows without duplicate API calls
- **Download Monitoring**: Throttle status updates to avoid UI jank (2-5 second intervals)
- **Search Debouncing**: Debounce search input to reduce API calls (300-500ms delay)
- **Skeleton Loading**: Show skeleton UI immediately while loading for perceived performance

## Icon Guidelines
Use simple, outlined icons (not filled) for consistency with minimalist design:

### Primary Icons
- **Overview**: Grid/Dashboard icon
- **Library**: Film/Collection icon
- **Requests**: Download/Inbox icon
- **Activity**: Clock/History icon
- **Settings**: Gear/Cog icon

### Service Icons
- **Radarr**: Film reel or Movie icon (Blue)
- **Sonarr**: TV/Monitor icon (Blue)
- **Overseerr**: Checkmark/Request icon (Blue)
- **Download Client**: Cloud download icon (Blue)

### Status Icons
- **Downloaded**: Checkmark circle (Green)
- **Downloading**: Download arrow (Blue)
- **Missing**: Alert circle (Red)
- **Paused**: Pause icon (Amber)
- **Failed**: X circle (Red)
- **Queued**: Clock icon (Grey)

### Action Icons
- **Search**: Magnifying glass
- **Filter**: Filter/Funnel icon
- **Edit**: Pencil icon
- **Delete**: Trash icon
- **Pause/Resume**: Pause/Play icons
- **Refresh**: Circular arrow

Use FontAwesome Icons package for consistent icon set throughout the app.




## Security Notes
- **API Keys**: Store securely using flutter_secure_storage (not in Hive for all services)
- **Hive Encryption**: Consider encrypting sensitive Hive boxes (service configurations)
- **HTTPS**: Require HTTPS endpoints for all API connections
- **Input Validation**: Sanitize all user inputs for endpoints and configuration
- **Error Logging**: Don't log sensitive information (API keys, passwords)
- **Download Client Auth**: Securely store download client credentials
- **Request Validation**: Validate Overseerr requests to prevent abuse

## Testing Guidelines
1. Write unit tests for Riverpod providers and business logic
2. Test Hive database operations (CRUD operations for all boxes)
3. Implement widget tests for UI components (cards, grids, lists)
4. Mock API responses for consistent testing (all services)
5. Test offline scenarios with Hive cached data
6. Test unified media merging logic (movies + TV shows)
7. Test download queue updates and progress tracking
8. Test request approval/denial workflows
9. Implement proper test coverage tools (aim for >80% coverage)
10. Follow proper test naming conventions
11. Test error states and edge cases
12. Test real-time stream providers (download progress, system stats)