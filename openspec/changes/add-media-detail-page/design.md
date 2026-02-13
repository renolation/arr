# Design: Add Media Detail Page

## Architecture

### Navigation
Use `Navigator.push` with `MaterialPageRoute` from `MediaCard._onCardTap`. Not a GoRouter route since it's a pushed detail view within the Library tab, not a top-level tab destination.

### Data Access
All data comes from `MediaItem` fields and `MediaItem.metadata` (the raw JSON from Sonarr/Radarr API). No new API calls or providers needed.

Key metadata paths:
- **runtime**: `metadata['runtime']` (int, minutes)
- **certification**: `metadata['certification']` (String, e.g. "PG-13", "TV-14")
- **genres**: `metadata['genres']` (List<dynamic>)
- **studio/network**: `metadata['studio']` (movies) or `metadata['network']` (series)
- **sizeOnDisk**: `metadata['sizeOnDisk']` (int, bytes)
- **hasFile**: `metadata['hasFile']` (bool)
- **movieFile.mediaInfo**: `metadata['movieFile']['mediaInfo']` — contains:
  - `videoCodec` (String), `audioCodec` (String), `audioChannels` (num)
  - `width` (int), `height` (int), `videoBitrate` (int)
- For series: `metadata['statistics']` for episode/file counts, `metadata['network']` for network name

## Page Layout (from mockup)
```
┌─────────────────────────┐
│ [Poster 5/12] [Meta 7/12]│  Grid layout, poster aligned left
│               Title       │  Large bold title
│               2014 • 2h49m│  Year, runtime, certification
│               BLURAY-1080P│  Quality format badge (primary color)
│               ★ 8.6/10    │  Star + rating
├───────────────────────────┤
│ [MONITORED] [SEARCH] [EDIT]│  3-column grid of action buttons
├───────────────────────────┤
│ STATUS      SIZE      📁  │  Bordered card, row layout
│ ● Downloaded  14.2 GB     │  Green dot for downloaded
├───────────────────────────┤
│ OVERVIEW                   │  Section label
│ Synopsis paragraph...      │  Body text
│ [Adventure] [Drama] [Sci-Fi]│ Outlined genre chips
├───────────────────────────┤
│ FILE INFORMATION           │  Movies with file only
│ Audio Codec    DTS-HD 5.1  │  Key-value rows
│ Video Codec    x264        │
│ Resolution     1920x1080   │
│ Bitrate        11.8 Mbps   │
└───────────────────────────┘
```

## Files Modified
- `lib/features/library/presentation/pages/media_detail_page.dart` — **NEW**: Detail page widget
- `lib/features/library/presentation/widgets/media_card.dart` — Wire `_onCardTap` to push detail page
- `lib/features/library/library.dart` — Export new page
