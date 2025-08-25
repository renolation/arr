# Flutter App Expert Guidelines

## Flexibility Notice
**Important**: This is a recommended project structure, but be flexible and adapt to existing project structures. Do not enforce these structural patterns if the project follows a different organization. Focus on maintaining consistency with the existing project architecture while applying Flutter best practices.

## 🤖 SUBAGENT DELEGATION SYSTEM 🤖
**CRITICAL: BE PROACTIVE WITH SUBAGENTS! YOU HAVE SPECIALIZED EXPERTS AVAILABLE!**

### 🚨 DELEGATION MINDSET
**Instead of thinking "I'll handle this myself"**  
**Think: "Which specialist is BEST suited for this task?"**

### 📋 AVAILABLE SPECIALISTS
You have access to these expert subagents - USE THEM PROACTIVELY:

#### 🎨 **flutter-widget-expert**
- **MUST BE USED for**: Custom widgets, UI components, layouts, animations, Material 3 design
- **Triggers**: "create widget", "build UI", "design component", "layout", "animation"

#### 🔄 **riverpod-expert**
- **MUST BE USED for**: State management, providers, reactive programming, async operations
- **Triggers**: "state management", "provider", "riverpod", "async state", "data flow"

#### 🗄️ **hive-expert**
- **MUST BE USED for**: Local database, caching, data models, Hive operations, storage
- **Triggers**: "database", "cache", "hive", "local storage", "data persistence"

#### 🌐 **api-integration-expert**
- **MUST BE USED for**: HTTP clients, API calls, error handling, network operations
- **Triggers**: "API", "HTTP", "network", "dio", "REST", "endpoint"

#### 🏗️ **architecture-expert**
- **MUST BE USED for**: Clean architecture, feature structure, dependency injection, project organization
- **Triggers**: "architecture", "structure", "organization", "clean code", "refactor"

#### ⚡ **performance-expert**
- **MUST BE USED for**: Optimization, image caching, memory management, build performance
- **Triggers**: "performance", "optimization", "memory", "cache", "slow", "lag"

### 🎯 DELEGATION STRATEGY
**BEFORE starting ANY task, ASK YOURSELF:**
1. "Which of my specialists could handle this better?"
2. "Should I break this into parts for different specialists?"
3. "Would a specialist complete this faster and better?"

### 💼 WORK BALANCE RECOMMENDATION:
- **Simple Tasks (20%)**: Handle independently - quick fixes, minor updates
- **Complex Tasks (80%)**: Delegate to specialists for expert-level results

### 🔧 HOW TO DELEGATE
```
# Explicit delegation examples:
> Use the flutter-widget-expert to create a custom movie card widget
> Have the riverpod-expert design the state management for the media grid
> Ask the hive-expert to create the database schema for caching
> Use the api-integration-expert to implement the Sonarr API client
> Have the architecture-expert review the feature structure
> Ask the performance-expert to optimize the image loading
```

---

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
A Flutter mobile application for managing *arr stack services (Sonarr, Radarr, and other *arr applications). The app provides a unified interface to monitor and manage your media server stack from your mobile device.

## Target Users
- Home media server enthusiasts
- Self-hosted media management users
- Users running Sonarr, Radarr, and similar *arr stack services

## Core Features
### Navigation Structure
- **Tab Bar Navigation**: Home, Sonarr, Radarr, Settings
- **Drawer Menu**: Quick access to configured services
- **Service Management**: Store and manage multiple service endpoints

### Tab Functionality
- **Home Tab**: Welcome screen with basic information and quick stats
- **Sonarr Tab**: Display current TV shows in grid view with show details
- **Radarr Tab**: Display current movies in grid view with movie details
- **Settings Tab**: Configure service endpoints, API keys, and app preferences

### Data Management
- **Endpoint Storage**: Securely store service URLs and API keys using Hive
- **Multi-Service Support**: Manage multiple instances of each service
- **Offline Caching**: Cache data for offline viewing using Hive local database

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
    - System status

### Radarr API
- **Base URL**: User-configured endpoint stored in Hive
- **API Spec**: Similar structure to Sonarr
- **Authentication**: API key-based (stored securely)
- **Main Endpoints**:
    - Get movies list
    - Get movie details
    - System status

## Data Models & Storage
- **Location**: `lib/models/` (already implemented)
- **Generated from**: Sonarr/Radarr OpenAPI specifications
- **Hive Storage**:
    - Service configurations (endpoints, API keys)
    - Cached media data (series, movies, episodes)
    - User preferences and settings
- **Key Models**:
    - Series/Movie models (with Hive adapters)
    - Episode models (with Hive adapters)
    - Service configuration models
    - API response wrappers

## State Management Architecture (Riverpod)
### Provider Structure
```
providers/
  auth_providers.dart        # API authentication
  service_providers.dart     # Service configuration
  sonarr_providers.dart     # Sonarr-specific state
  radarr_providers.dart     # Radarr-specific state
  settings_providers.dart   # App settings
```

### Key Provider Types
- **StateNotifierProvider**: For complex state (media lists, service status)
- **FutureProvider**: For API calls and async operations
- **Provider**: For dependency injection
- **StreamProvider**: For real-time updates if needed

## Hive Database Schema
### Boxes
- `servicesBox`: Store service configurations
- `sonarrCacheBox`: Cache Sonarr data
- `radarrCacheBox`: Cache Radarr data
- `settingsBox`: Store app preferences

### Models with Hive Adapters
- `ServiceConfig` - Service endpoints and API keys
- `Series` - TV show data
- `Movie` - Movie data
- `Episode` - Episode data
- `AppSettings` - User preferences

## UI/UX Requirements
### Grid View Display
- **Sonarr**: Show TV series with poster images, titles, and status
- **Radarr**: Show movies with poster images, titles, and status
- **Responsive**: Adapt grid columns based on screen size
- **Loading States**: Proper loading indicators with Riverpod AsyncValue
- **Error Handling**: User-friendly error messages

### Service Configuration
- **Drawer Menu**: List of configured services with quick access
- **Settings Flow**: Easy setup for new service endpoints
- **Validation**: Test connections before saving to Hive
- **Security**: Secure storage of sensitive data

## Current Development Focus
- [ ] Basic app structure with tab navigation
- [ ] Hive database setup and model adapters
- [ ] Riverpod provider architecture
- [ ] Service endpoint configuration and Hive storage
- [ ] API client implementation for Sonarr/Radarr
- [ ] Grid view implementation for media display
- [ ] Image caching and optimization
- [ ] Error handling and offline support with Hive

## Domain Knowledge
### *arr Stack Context
- **Sonarr**: TV show management (downloading, organizing, monitoring)
- **Radarr**: Movie management (downloading, organizing, monitoring)
- **Quality Profiles**: User-defined quality preferences
- **Root Folders**: Storage locations for media
- **Indexers**: Sources for finding content

### Key Workflows
1. **Service Setup**: Add endpoint URL + API key → Test connection → Save to Hive
2. **Media Browsing**: Select service → View grid of shows/movies (from Hive cache) → Tap for details
3. **Multi-Service Management**: Switch between different *arr instances via drawer
4. **Offline Support**: Display cached data from Hive when offline

### Important Data Concepts
- **Series/Movies**: Core media entities with metadata (cached in Hive)
- **Episodes**: Individual episodes within TV series
- **Quality Profiles**: Preferred quality settings
- **Download Status**: Current status of media acquisition
- **Monitoring**: Whether the service is actively looking for new content

## Performance Considerations
- **Image Loading**: Lazy load poster images with caching
- **Hive Performance**: Use efficient queries and indexing
- **Riverpod Optimization**: Proper provider scoping and disposal
- **API Calls**: Implement proper pagination for large media libraries
- **Refresh Strategy**: Pull-to-refresh and background sync to Hive
- **Memory Management**: Dispose of resources properly in grid views

## Security Notes
- **API Keys**: Store securely using flutter_secure_storage (not in Hive)
- **Hive Encryption**: Consider encrypting sensitive Hive boxes
- **HTTPS**: Encourage/require HTTPS endpoints
- **Input Validation**: Sanitize all user inputs for endpoints
- **Error Logging**: Don't log sensitive information

## Testing Guidelines
1. Write unit tests for Riverpod providers and business logic
2. Test Hive database operations (CRUD operations)
3. Implement widget tests for UI components
4. Mock API responses for consistent testing
5. Test offline scenarios with Hive cached data
6. Implement proper test coverage tools
7. Follow proper test naming conventions

---

## 📝 SUBAGENT CREATION REFERENCE

To create the recommended subagents, run `/agents` and create these specialists:

### flutter-widget-expert.md
```markdown
---
name: flutter-widget-expert
description: Expert Flutter widget developer. MUST BE USED for creating custom widgets, UI components, layouts, animations, and Material 3 design implementation.
tools: Read, Write, Edit, Grep, Bash
---

You are a Flutter UI specialist with expertise in:
- Custom widget creation and composition
- Material 3 design implementation
- Responsive layouts and grid views
- Image caching and optimization
- Navigation and routing

## Key Focus:
- Create performant, reusable widgets
- Implement proper const constructors
- Handle responsive design for media grids
- Optimize image loading for movie/TV posters
- Follow Material 3 design principles

## Always Check First:
- `lib/core/theme/` - Existing theme configuration
- `lib/core/widgets/` - Shared widgets
- Project's existing widget patterns
```

### riverpod-expert.md
```markdown
---
name: riverpod-expert
description: Riverpod state management specialist. MUST BE USED for all providers, state management, async operations, and reactive programming.
tools: Read, Write, Edit, Grep
---

You are a Riverpod expert specializing in:
- Provider architecture and organization
- AsyncValue handling for API states
- StateNotifierProvider for complex state
- FutureProvider for async operations
- Proper provider disposal and lifecycle

## Key Focus:
- Design scalable provider architecture
- Handle loading, error, and success states
- Implement proper async state management
- Create testable provider patterns
- Optimize provider rebuilds

## Always Check First:
- `lib/providers/` - Existing provider structure
- State management patterns in use
```

### hive-expert.md
```markdown
---
name: hive-expert
description: Hive database and caching specialist. MUST BE USED for local storage, data models, caching strategies, and database operations.
tools: Read, Write, Edit, Grep, Bash
---

You are a Hive database expert specializing in:
- Database schema design and optimization
- Type adapters and code generation
- Caching strategies for offline support
- Data model creation with proper serialization
- Performance optimization for large datasets

## Key Focus:
- Create efficient Hive box structures
- Design proper type adapters for models
- Implement caching strategies for *arr data
- Handle data migration and versioning
- Optimize query performance

## Always Check First:
- `lib/models/` - Existing data models
- Current Hive box structure
- Caching patterns in use
```

Remember: **ALWAYS DELEGATE TO SPECIALISTS FOR BETTER RESULTS!**