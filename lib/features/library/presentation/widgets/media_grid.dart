import 'package:flutter/material.dart';
import '../../domain/entities/media_item.dart';
import 'media_card.dart';
import '../../../../core/widgets/empty_state.dart';

/// Responsive grid widget for displaying media items
class MediaGrid extends StatelessWidget {
  final List<MediaItem> mediaItems;

  const MediaGrid({
    super.key,
    required this.mediaItems,
  });

  @override
  Widget build(BuildContext context) {
    if (mediaItems.isEmpty) {
      return const SizedBox(
        height: 400,
        child: EmptyState(
          message: 'No media found',
          icon: Icons.movie_outlined,
        ),
      );
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        // Calculate responsive grid columns
        final crossAxisCount = _getCrossAxisCount(constraints.maxWidth);
        const spacing = 16.0;
        const horizontalPadding = 20.0;
        final itemWidth = (constraints.maxWidth - (spacing * (crossAxisCount - 1)) - (horizontalPadding * 2)) / crossAxisCount;

        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: horizontalPadding),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            crossAxisSpacing: spacing,
            mainAxisSpacing: spacing,
            childAspectRatio: itemWidth / (itemWidth * (500 / 333) + MediaCard.textAreaHeight),
          ),
          itemCount: mediaItems.length,
          itemBuilder: (context, index) {
            return MediaCard(mediaItem: mediaItems[index]);
          },
        );
      },
    );
  }

  int _getCrossAxisCount(double width) {
    if (width < 600) return 2;
    if (width < 900) return 3;
    if (width < 1200) return 4;
    if (width < 1500) return 5;
    return 6;
  }
}
