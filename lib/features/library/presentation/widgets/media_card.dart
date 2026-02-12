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
                      color: Theme.of(context)
                          .colorScheme
                          .outline
                          .withOpacity(0.5),
                    ),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: Opacity(
                      opacity: isMissing ? 0.6 : 1.0,
                      child: _buildPoster(context),
                    ),
                  ),
                ),
                // Quality badge at top right
                if (mediaItem.quality != null)
                  Positioned(
                    top: 6,
                    right: 6,
                    child: _Badge(
                      label: mediaItem.quality!,
                      backgroundColor: Colors.black.withOpacity(0.8),
                      textColor: Colors.white,
                      borderColor: Colors.white.withOpacity(0.1),
                    ),
                  ),
                // Status badge at top right (below quality if present)
                if (!isMissing)
                  Positioned(
                    top: mediaItem.quality != null ? 28 : 6,
                    right: 6,
                    child: _buildStatusBadge(),
                  ),
                // Missing badge at top right
                if (isMissing)
                  Positioned(
                    top: mediaItem.quality != null ? 28 : 6,
                    right: 6,
                    child: const _Badge(
                      label: 'Missing',
                      backgroundColor: AppColors.accentRed,
                      textColor: Colors.white,
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
                      textColor: Colors.white,
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
                  Row(
                    children: [
                      Text(
                        mediaItem.year?.toString() ?? 'N/A',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w500,
                          color: Theme.of(context)
                              .colorScheme
                              .onSurface
                              .withOpacity(0.6),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        width: 2,
                        height: 2,
                        decoration: BoxDecoration(
                          color: Theme.of(context)
                              .colorScheme
                              .onSurface
                              .withOpacity(0.4),
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        isSeries ? 'Series' : 'Movie',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w500,
                          color: Theme.of(context)
                              .colorScheme
                              .onSurface
                              .withOpacity(0.6),
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

  Widget _buildStatusBadge() {
    if (mediaItem.status == MediaStatus.downloaded) {
      return const _Badge(
        label: 'Ended',
        backgroundColor: AppColors.accentGreen,
        textColor: Colors.black,
      );
    }
    if (mediaItem.status == MediaStatus.continuing) {
      return const _Badge(
        label: 'Returning',
        backgroundColor: AppColors.accentYellow,
        textColor: Colors.black,
      );
    }
    return const SizedBox.shrink();
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
        errorWidget: (context, url, error) =>
            const Icon(Icons.broken_image, size: 32),
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
  final Color textColor;
  final Color? borderColor;

  const _Badge({
    required this.label,
    required this.backgroundColor,
    this.textColor = Colors.white,
    this.borderColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(4),
        border: borderColor != null
            ? Border.all(color: borderColor!, width: 1)
            : null,
      ),
      child: Text(
        label.toUpperCase(),
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.bold,
          color: textColor,
        ),
      ),
    );
  }
}
