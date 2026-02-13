# Proposal: Add Media Detail Page

## Summary
Add a detail page that opens when users tap a media item in the Library tab. Displays full metadata (title, year, runtime, certification, quality, rating), action buttons (Monitored, Search, Edit), download status card, overview with genre chips, and file information for movies. Follows the mockup in `docs/screenshot/detail.png`.

## Motivation
Currently tapping a media card in the Library does nothing (`_onCardTap` is a TODO). Users need to view detailed information about their media items — status, file quality, synopsis — without leaving the app.

## Scope
- New `MediaDetailPage` widget matching the mockup layout
- Navigation from Library media cards to the detail page
- All data sourced from `MediaItem.metadata` (raw Sonarr/Radarr JSON) — no new API calls
- Action buttons are visual only (Monitored shows current state; Search and Edit are placeholders for future enhancement)

## Out of Scope
- "You Might Also Like" recommendations (requires additional API calls)
- Interactive Monitored toggle (future enhancement)
- Manual search from detail page (future enhancement)
- Edit metadata from detail page (future enhancement)
