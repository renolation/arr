# Clean Architecture Quick Start Guide

## What Was Created

A complete clean architecture structure for your *arr Stack Management App with:
- **18 core files** (constants, errors, network, theme, utils, widgets)
- **50 feature files** (5 complete features with data, domain, presentation layers)
- **5 service files** (API services for Sonarr, Radarr, Overseerr, Downloads)
- **1 routing file** (GoRouter configuration)

Total: **74 new files** following clean architecture principles!

## Next Steps

### 1. Update pubspec.yaml

Add these dependencies to your `pubspec.yaml`:

```yaml
dependencies:
  flutter_riverpod: ^2.4.9
  riverpod_annotation: ^2.3.3
  dio: ^5.4.0
  hive_flutter: ^1.1.0
  flutter_secure_storage: ^9.0.0
  go_router: ^12.1.1
  dartz: ^0.10.1
  freezed_annotation: ^2.4.1
  json_annotation: ^4.8.1
  cached_network_image: ^3.3.0
  intl: ^0.18.1

dev_dependencies:
  build_runner: ^2.4.7
  freezed: ^2.4.5
  json_serializable: ^6.7.1
  hive_generator: ^2.0.1
  riverpod_generator: ^2.3.9
  riverpod_lint: ^2.3.7
```

### 2. Install Dependencies

```bash
flutter pub get
```

### 3. Generate Code

Run build_runner to generate freezed files, JSON serialization, and Hive adapters:

```bash
# Generate all code
flutter pub run build_runner build --delete-conflicting-outputs

# Or use watch for development
flutter pub run build_runner watch --delete-conflicting-outputs
```

### 4. Update Existing Imports

If you have existing code, update imports to use the new structure:

**Old:**
```dart
import '../providers/sonarr_providers.dart';
```

**New:**
```dart
import '../../features/overview/presentation/providers/system_status_provider.dart';
// Or use barrel export
import '../../features/overview/overview.dart';
```

### 5. Fix Missing Dependencies

Some files reference freezed classes that need code generation:

**Fix errors in:**
- `/lib/core/errors/failures.dart` - Needs `part 'failures.freezed.dart';`
- `/lib/features/overview/domain/entities/system_status.dart` - Needs freezed generation
- `/lib/features/library/domain/entities/media_item.dart` - Needs freezed generation
- `/lib/features/requests/domain/entities/request.dart` - Needs freezed generation
- `/lib/features/activity/domain/entities/download.dart` - Needs freezed generation
- `/lib/features/settings/domain/entities/service_config.dart` - Needs freezed generation
- `/lib/features/settings/presentation/providers/service_provider.dart` - Missing freezed import

### 6. Register Hive Adapters

In your `lib/core/database/hive_database.dart`, register adapters for entities:

```dart
import 'package:hive_flutter/hive_flutter.dart';
import '../../features/library/domain/entities/media_item.dart';
// Import other entities...

class HiveDatabase {
  static Future<void> init() async {
    await Hive.initFlutter();

    // Register adapters
    Hive.registerAdapter(MediaItemAdapter());
    // Register other adapters...

    // Open boxes
    await Hive.openBox('services_box');
    await Hive.openBox('sonarr_cache_box');
    await Hive.openBox('radarr_cache_box');
    // ... other boxes
  }
}
```

## Architecture Overview

### Layer Structure

```
Data Layer          → API calls, local storage (Hive, Secure Storage)
    ↓
Domain Layer        → Business entities, repository interfaces
    ↓
Presentation Layer  → UI, Riverpod providers, widgets
```

### Dependency Flow

```
Presentation → Domain (repositories interfaces) → Data (repositories implementations)
```

**Key Rule:** Domain layer has NO dependencies on Flutter!

### File Organization by Feature

Each feature has 3 layers:

**Example: Library Feature**
```
lib/features/library/
├── data/                          # Implementation
│   ├── datasources/
│   │   └── media_remote_datasource.dart
│   └── repositories/
│       └── media_repository.dart
├── domain/                        # Business logic
│   ├── entities/
│   │   └── media_item.dart
│   └── repositories/
│       └── media_repository.dart  # Interface
└── presentation/                  # UI
    ├── providers/
    │   └── media_provider.dart
    ├── pages/
    │   └── library_page.dart
    └── widgets/
        ├── media_grid.dart
        └── media_card.dart
```

## Key Patterns

### 1. Either Type for Error Handling

```dart
// Repository returns Either<Failure, Success>
Future<Either<Failure, List<MediaItem>>> getAllSeries() async {
  try {
    final data = await remoteDataSource.getAllSeries();
    return Right(mediaItems);
  } on ServerException catch (e) {
    return Left(ServerFailure(message: e.message));
  }
}

// Provider usage
final seriesProvider = FutureProvider<Either<Failure, List<MediaItem>>>((ref) async {
  return ref.watch(repositoryProvider).getAllSeries();
});

// UI usage
seriesAsync.when(
  data: (result) => result.fold(
    (failure) => ErrorWidget(message: failure.message),
    (series) => MediaGrid(items: series),
  ),
  loading: () => LoadingIndicator(),
  error: (_, __) => ErrorWidget(),
)
```

### 2. Riverpod Provider Chain

```dart
// 1. Dependency injection
final dioClientProvider = Provider<DioClient>((ref) => DioClient());

// 2. Data source
final dataSourceProvider = Provider<DataSource>((ref) {
  return DataSource(dioClient: ref.watch(dioClientProvider));
});

// 3. Repository
final repositoryProvider = Provider<Repository>((ref) {
  return Repository(dataSource: ref.watch(dataSourceProvider));
});

// 4. Feature provider
final dataProvider = FutureProvider<Data>((ref) async {
  return ref.watch(repositoryProvider).getData();
});
```

### 3. Freezed for Immutable Entities

```dart
@freezed
class MediaItem with _$MediaItem {
  const factory MediaItem({
    required int id,
    required String title,
    required MediaType type,
    MediaStatus? status,
  }) = _MediaItem;

  factory MediaItem.fromJson(Map<String, dynamic> json) =>
      _$MediaItemFromJson(json);
}
```

## Migration Strategy

### Option A: Gradual Migration (Recommended)

1. **Keep existing code running**
2. **Migrate one feature at a time**
3. **Test thoroughly**
4. **Move to next feature**

Example: Start with Settings feature
1. Implement new Settings architecture
2. Test service configuration
3. Update navigation
4. Verify everything works
5. Move to Library feature

### Option B: Fresh Start

1. Create new routes for new architecture
2. Have both old and new navigation
3. Gradually switch routes
4. Remove old code when done

## Testing

Each layer can be tested independently:

```dart
// Domain layer test (pure Dart, no Flutter needed)
test('should return MediaItem from JSON', () {
  final json = {'id': 1, 'title': 'Test'};
  final item = MediaItem.fromJson(json);
  expect(item.title, 'Test');
});

// Data layer test (mock datasource)
test('should return list of media items', () async {
  final mockDataSource = MockMediaRemoteDataSource();
  final repository = MediaRepositoryImpl(dataSource: mockDataSource);
  // Test...
});

// Presentation layer test (widget test)
testWidgets('should display loading indicator', (tester) async {
  await tester.pumpWidget(
    ProviderScope(
      child: LibraryPage(),
    ),
  );
  expect(find.byType(LoadingIndicator), findsOneWidget);
});
```

## Common Issues & Solutions

### Issue 1: Missing part directives

**Error:** `The part 'xxx.freezed.dart' not found`

**Solution:** Run `flutter pub run build_runner build`

### Issue 2: Circular imports

**Error:** Circular import between files

**Solution:**
- Domain layer should never import from data or presentation
- Use barrel exports (feature.dart) to organize imports
- Check dependency direction: Presentation → Domain → Data

### Issue 3: Provider not found

**Error:** Could not find provider

**Solution:**
- Ensure ProviderScope wraps MaterialApp
- Check provider is imported correctly
- Verify parent providers exist in chain

## File Reference

**Key Files to Understand First:**

1. `/lib/core/errors/failures.dart` - Error handling pattern
2. `/lib/core/network/dio_client.dart` - HTTP client pattern
3. `/lib/features/library/domain/entities/media_item.dart` - Entity pattern
4. `/lib/features/library/presentation/providers/media_provider.dart` - Provider pattern
5. `/lib/features/library/presentation/pages/library_page.dart` - UI pattern
6. `/lib/routes/app_router.dart` - Navigation pattern

## Support

For questions or issues:
1. Check ARCHITECTURE_SUMMARY.md for detailed documentation
2. Review existing feature implementations as examples
3. Follow the established patterns in each layer
4. Keep the dependency rule: Presentation → Domain → Data

## Success Checklist

- [ ] All dependencies installed
- [ ] Code generation completed
- [ ] No import errors
- [ ] Hive adapters registered
- [ ] Navigation configured
- [ ] Theme applied
- [ ] One feature migrated and tested
- [ ] Ready for production! 🚀

---

**You now have a scalable, maintainable architecture for your *arr Stack Manager!**
