# Align UI with HTML/PNG Design Mockups

## Summary
Update the Library, Requests, and Settings page widgets to match the visual design specified in `docs/screenshot/*.html` and `*.png` files. The current implementations deviate from the mockups in card styling, badge placement, gradient overlays, filter chip styling, and color usage.

## Motivation
The HTML mockups in `docs/screenshot/` represent the target design. The current Flutter widgets were built functionally but don't match the visual details: trending cards show text below poster instead of overlaid with gradients, library card badges need refinement, approval cards need poster images, filter chips need color adjustments, and the color system in `core/theme/colors.dart` is disconnected from the actual design tokens in `main.dart`.

## Scope
- **Trending Card**: Gradient overlay with title/year/buttons rendered ON the poster image
- **Library MediaCard**: Refine badge styling (black/80 bg for quality, colored for status), missing items with reduced opacity, season badge bottom-left
- **Library Filter Chips**: Already mostly correct, minor color/selection state tweaks
- **Approval Card**: Horizontal layout with poster left (1/3) + content right (2/3), user avatar initials, Approve/Deny buttons matching mockup
- **Settings Page**: Already mostly correct (sharp corners, uppercase labels) - minor border and spacing tweaks
- **Color System Cleanup**: Consolidate `core/theme/colors.dart` to align with `main.dart` AppColors tokens

## Out of Scope
- Home/Dashboard page (separate effort)
- Activity page (separate effort)
- Detail/Search pages (separate effort)
- Font family change (Space Grotesk requires adding a package)
- Bottom navigation bar changes
