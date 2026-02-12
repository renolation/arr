import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../../core/network/models/jellyseerr_models.dart';
import '../../../../main.dart';
import '../providers/requests_provider.dart';

/// Card widget for trending media content with request functionality
class TrendingCard extends ConsumerWidget {
  final JellyseerrMediaResult media;

  const TrendingCard({
    super.key,
    required this.media,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Poster with status overlay
        AspectRatio(
          aspectRatio: 2 / 3,
          child: Stack(
            children: [
              // Poster image
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: media.fullPosterUrl != null
                    ? CachedNetworkImage(
                        imageUrl: media.fullPosterUrl!,
                        fit: BoxFit.cover,
                        width: double.infinity,
                        height: double.infinity,
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
                        errorWidget: (context, url, error) => _buildPlaceholder(context),
                      )
                    : _buildPlaceholder(context),
              ),
              // Status overlay
              Positioned(
                top: 8,
                left: 8,
                child: _buildStatusBadge(context),
              ),
              // Request button overlay (bottom)
              if (!media.isAvailable && !media.isPending && !media.isProcessing)
                Positioned(
                  bottom: 8,
                  right: 8,
                  child: _buildRequestButton(context, ref),
                ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        // Title
        Text(
          media.title,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        // Year and type
        Text(
          '${media.year ?? ''} ${media.mediaType == 'tv' ? 'TV Show' : 'Movie'}'.trim(),
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
              ),
          maxLines: 1,
        ),
      ],
    );
  }

  Widget _buildPlaceholder(BuildContext context) {
    return Container(
      color: Theme.of(context).colorScheme.surface,
      child: Center(
        child: Icon(
          media.mediaType == 'tv' ? Icons.tv_outlined : Icons.movie_outlined,
          size: 32,
          color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.3),
        ),
      ),
    );
  }

  Widget _buildStatusBadge(BuildContext context) {
    if (media.isAvailable) {
      return _badge(context, 'AVAILABLE', AppColors.accentGreen);
    }
    if (media.isPending || media.isProcessing) {
      return _badge(context, 'REQUESTED', AppColors.accentYellow);
    }
    return const SizedBox.shrink();
  }

  Widget _badge(BuildContext context, String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: color, width: 1),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color,
          fontSize: 10,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  Widget _buildRequestButton(BuildContext context, WidgetRef ref) {
    return Material(
      color: AppColors.primary,
      borderRadius: BorderRadius.circular(8),
      child: InkWell(
        borderRadius: BorderRadius.circular(8),
        onTap: () => _onRequest(context, ref),
        child: const Padding(
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.add, size: 14, color: Colors.white),
              SizedBox(width: 4),
              Text(
                'Request',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _onRequest(BuildContext context, WidgetRef ref) async {
    final success = await ref.read(requestActionsProvider.notifier).createRequest(
          mediaType: media.mediaType,
          mediaId: media.id,
        );
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(success ? '${media.title} requested' : 'Failed to request ${media.title}'),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
      );
    }
  }
}
