# Design: UI Alignment with Mockups

## Key Visual Differences (Current vs Mockup)

### 1. Trending Card (request.html)
**Current**: Poster image on top, title + year below as plain text, status badge top-left, request button bottom-right
**Mockup**: Full poster with gradient overlay (`from-black/90 via-black/20 to-transparent`) from bottom, title + year rendered inside the gradient area, request button is full-width semi-transparent (`bg-white/10 border-white/20`), "Available" badge is solid green top-right, "Requested" badge is blue/primary tinted

### 2. Library MediaCard (library.html)
**Current**: Close to mockup already - quality badge top-right with black bg, status badges, season badge bottom-left. Minor issues:
- Missing items need opacity reduction on poster (`opacity-60 grayscale-[50%]`)
- Badge text should use specific colors per type (Missing=red bg with white text, Ended=green bg with black text, Returning=yellow bg with black text)
- Quality badge: `bg-black/80` with white text
- Season badge: `bg-black/60` with white text
**Mockup differences are minor** - mostly about badge color values

### 3. Approval Card (request.html)
**Current**: Horizontal row with small poster placeholder (70x100) + info column with status chip + icon action buttons
**Mockup**: Horizontal card with poster taking 1/3 width (full bleed image), content 2/3, user shown with colored gradient avatar circle + initials, simple "Approve" (blue filled) and "Deny" (outlined) text buttons side by side at bottom

### 4. Filter Chips (library.html)
**Current**: Already pill-shaped, uppercase, inverted colors for selected state
**Mockup match is close** - selected "All" chip uses `bg-slate-900 text-white` (dark mode: `bg-white text-dark`), unselected uses `bg-gray-200` (dark: `bg-surface-dark`)

### 5. Settings Page (settings.html)
**Current**: Already has sharp corners, uppercase labels, Swiss-brutalist inputs
**Mockup differences are minimal** - the current implementation closely matches

## Implementation Approach

### Widget changes (no new files needed):
1. `trending_card.dart` - Replace Column layout with Stack + gradient overlay
2. `media_card.dart` - Refine badge colors and missing item opacity
3. `approval_card.dart` - Update layout proportions, add user avatar initials, simplify buttons
4. `library_page.dart` - Minor filter chip color tweaks if needed
5. `core/theme/colors.dart` - Align color constants with `main.dart` AppColors

### Colors to reconcile:
| Token | `main.dart` AppColors | `core/theme/colors.dart` | Mockup HTML |
|-------|----------------------|-------------------------|-------------|
| primary | `#1392EC` | `#0066CC` | `#1392ec` |
| dark bg | `#101A22` | `#121212` | `#101a22` |
| dark surface | `#18242E` | `#1E1E1E` | `#18242e` |
| dark card | `#16202A` | n/a | `#16202a` |
| dark border | `#2A3B4D` | `#424242` | `#2a3b4d` |

The `main.dart` colors are correct. The `core/theme/colors.dart` is stale and should be updated or deprecated.
