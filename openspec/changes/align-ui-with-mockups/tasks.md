## 1. Update Color System
- [x] 1.1 Update `core/theme/colors.dart` to align with `main.dart` AppColors (primary=#1392EC, darkBackground=#101A22, darkSurface=#18242E, darkOutline=#2A3B4D)
- [x] 1.2 Update `core/theme/app_theme.dart` dark theme to use aligned color values

## 2. Redesign Trending Card
- [x] 2.1 Replace Column layout with full-poster Stack + gradient overlay (`LinearGradient from transparent to black 90%`)
- [x] 2.2 Move title, year, status badges inside the gradient overlay area at bottom
- [x] 2.3 Change request button to full-width semi-transparent style (white/10 bg, white/20 border)
- [x] 2.4 Move "Available" badge to top-right with solid green background
- [x] 2.5 Show "Requested" badge inside gradient area with primary color tint

## 3. Refine Library MediaCard Badges
- [x] 3.1 Update "Ended" badge to green background with black text
- [x] 3.2 Update "Returning" badge to yellow background with black text
- [x] 3.3 Update "Missing" badge to red background with white text
- [x] 3.4 Ensure missing items render with 0.6 opacity on poster
- [x] 3.5 Quality badge: ensure `black/80` bg, white text, `white/10` border

## 4. Redesign Approval Card
- [x] 4.1 Update card to use 1/3 poster image (full bleed) + 2/3 content layout matching mockup
- [x] 4.2 Add user avatar with colored gradient circle and initials
- [x] 4.3 Replace icon action buttons with text "Approve" (primary filled) and "Deny" (outlined) buttons
- [x] 4.4 Remove status chip and type badge (mockup doesn't show them)

## 5. Validate
- [x] 5.1 Run `dart analyze` to verify no errors
