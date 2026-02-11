import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../domain/entities/media_item.dart';
import '../../../../main.dart';

/// Card widget for displaying a media item - Matching HTML design
class MediaCard extends StatelessWidget {
  /// Fixed height for the text area below the poster (title + year/type)
  static const double textAreaHeight = 60;

  final MediaItem mediaItem;

  const MediaCard({
    super.key,
    required this.mediaItem,
  });

  @override
  Widget build(BuildContext context) {
    final isMissing = mediaItem.isMissing;
    final isSeries = mediaItem.type == MediaType.series;

    return InkWell(
      onTap: () => _onCardTap(context),
      borderRadius: BorderRadius.circular(4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Poster with 9:16 aspect ratio
          Expanded(
            child: Stack(
              children: [
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Theme.of(context).brightness == Brightness.dark
                        ? AppColors.surfaceDark
                        : AppColors.surfaceLight,
                    borderRadius: BorderRadius.circular(4),
                    border: Border.all(
                      color: Theme.of(context).colorScheme.outline.withOpacity(0.5),
                    ),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: _buildPoster(context),
                  ),
                ),
                // Badges at top right
                Positioned(
                  top: 6,
                  right: 6,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (mediaItem.quality != null)
                        _Badge(
                          label: mediaItem.quality!,
                          backgroundColor: Colors.black.withOpacity(0.8),
                        ),
                      if (mediaItem.status == MediaStatus.downloaded)
                        const SizedBox(width: 4),
                      if (mediaItem.status == MediaStatus.downloaded)
                        const _Badge(
                          label: 'Ended',
                          backgroundColor: AppColors.accentGreen,
                        ),
                      if (mediaItem.status == MediaStatus.continuing)
                        const SizedBox(width: 4),
                      if (mediaItem.status == MediaStatus.continuing)
                        const _Badge(
                          label: 'Returning',
                          backgroundColor: AppColors.accentYellow,
                        ),
                    ],
                  ),
                ),
                // Missing badge
                if (isMissing)
                  const Positioned(
                    top: 6,
                    right: 6,
                    child: _Badge(
                      label: 'Missing',
                      backgroundColor: AppColors.accentRed,
                    ),
                  ),
                // Season badge at bottom left (for series)
                if (isSeries && mediaItem.episodeCount != null)
                  Positioned(
                    bottom: 6,
                    left: 6,
                    child: _Badge(
                      label: 'S1',
                      backgroundColor: Colors.black.withOpacity(0.6),
                    ),
                  ),
              ],
            ),
          ),
          // Fixed-height text area below poster
          SizedBox(
            height: MediaCard.textAreaHeight,
            child: Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 4,
                children: [
                  // Title - always reserves 2 lines of space
                  Text(
                    mediaItem.title,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      height: 1.2,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  // Year and type
                  Row(
                    children: [
                      Text(
                        mediaItem.year?.toString() ?? 'N/A',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w500,
                          color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        width: 2,
                        height: 2,
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.onSurface.withOpacity(0.4),
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        isSeries ? 'Series' : 'Movie',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w500,
                          color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPoster(BuildContext context) {
    if (!mediaItem.hasPoster) {
      return Icon(
        mediaItem.type == MediaType.series ? Icons.tv : Icons.movie,
        size: 48,
        color: Theme.of(context).colorScheme.onSurface.withOpacity(0.2),
      );
    }

    return ColorFiltered(
      colorFilter: mediaItem.isMissing
          ? const ColorFilter.mode(Colors.grey, BlendMode.saturation)
          : const ColorFilter.mode(Colors.transparent, BlendMode.srcOver),
      child: CachedNetworkImage(
        imageUrl: mediaItem.posterUrl!,
        fit: BoxFit.cover,
        placeholder: (context, url) => Container(
          color: Theme.of(context).colorScheme.surface,
          child: const Center(
            child: SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
          ),
        ),
        errorWidget: (context, url, error) => const Icon(Icons.broken_image, size: 32),
      ),
    );
  }

  void _onCardTap(BuildContext context) {
    // TODO: Navigate to detail
  }
}

class _Badge extends StatelessWidget {
  final String label;
  final Color backgroundColor;

  const _Badge({
    required this.label,
    required this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(4),
        border: Border.all(
          color: Colors.white.withOpacity(0.1),
          width: 1,
        ),
      ),
      child: Text(
        label.toUpperCase(),
        style: const TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
    );
  }
}
