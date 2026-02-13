## 1. Create Media Detail Page
- [x] 1.1 Create `MediaDetailPage` widget in `lib/features/library/presentation/pages/media_detail_page.dart`
- [x] 1.2 Implement header section: poster (5/12 grid) + metadata (7/12) with title, year, runtime, certification, quality badge, rating
- [x] 1.3 Implement action buttons row: Monitored (filled if true), Search, Edit — 3-column grid
- [x] 1.4 Implement status card: current status with colored dot + size on disk + folder icon
- [x] 1.5 Implement overview section: synopsis text + genre chips
- [x] 1.6 Implement file information section: audio codec, video codec, resolution, bitrate (movies with movieFile only)

## 2. Wire Navigation
- [x] 2.1 Update `MediaCard._onCardTap` to push `MediaDetailPage` via `Navigator.push`
- [x] 2.2 Export `media_detail_page.dart` from `library.dart` barrel file

## 3. Validate
- [x] 3.1 Run `dart analyze` to verify no errors
