## MODIFIED Requirements

### Requirement: Trending Card Design
The trending card SHALL display poster images with a gradient overlay containing title, year, status badges, and request buttons rendered on the poster.

#### Scenario: Unrequested trending item
- **WHEN** a trending item has no request status
- **THEN** the card shows the poster with a bottom gradient overlay (`LinearGradient from transparent to black/90`), year and title text inside the gradient, and a full-width semi-transparent "Request" button (`white/10 bg, white/20 border`)

#### Scenario: Available trending item
- **WHEN** a trending item has `isAvailable == true`
- **THEN** a solid green "Available" badge is shown at the top-right of the poster, and no request button is shown

#### Scenario: Requested trending item
- **WHEN** a trending item has `isPending || isProcessing`
- **THEN** a "Requested" badge with primary color tint is shown inside the gradient overlay area

### Requirement: Library Card Badge Styling
The library media card SHALL use specific badge color schemes matching the design mockups.

#### Scenario: Quality badge displayed
- **WHEN** a media item has a quality value
- **THEN** a badge with `black/80` background, white text, and subtle `white/10` border is shown at the top-right

#### Scenario: Missing media item
- **WHEN** a media item has status `missing`
- **THEN** the poster is shown with reduced opacity (0.6) and partial grayscale, and a red "Missing" badge with white text is shown at top-right

#### Scenario: Ended series
- **WHEN** a series has `downloaded` status (ended)
- **THEN** a green badge with black text reading "Ended" is shown at top-right

#### Scenario: Returning series
- **WHEN** a series has `continuing` status
- **THEN** a yellow/amber badge with black text reading "Returning" is shown at top-right

### Requirement: Approval Card Layout
The approval card SHALL use a horizontal layout with the poster image taking 1/3 of the card width and content taking 2/3.

#### Scenario: Pending request displayed
- **WHEN** a pending request is shown
- **THEN** the card displays: left 1/3 poster image (full bleed), right 2/3 content with title, year/genre, requester with colored avatar initials, and "Approve" (primary filled) + "Deny" (outlined) buttons at bottom

### Requirement: Color System Alignment
The `core/theme/colors.dart` color constants SHALL match the design tokens defined in `main.dart` AppColors.

#### Scenario: Dark theme colors match mockup
- **WHEN** the app renders in dark mode
- **THEN** the background is `#101A22`, surface is `#18242E`, card is `#16202A`, border is `#2A3B4D`, and primary is `#1392EC`
