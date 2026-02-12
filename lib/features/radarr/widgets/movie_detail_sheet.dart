import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:arr/models/hive/movie_hive.dart';

class MovieDetailSheet extends StatelessWidget {
  final MovieHive movie;
  
  const MovieDetailSheet({super.key, required this.movie});
  
  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.9,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      expand: false,
      builder: (context, scrollController) {
        return Container(
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
          ),
          child: ListView(
            controller: scrollController,
            padding: const EdgeInsets.all(16),
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  margin: const EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.onSurface.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: movie.posterUrl != null && movie.posterUrl!.isNotEmpty
                        ? CachedNetworkImage(
                            imageUrl: movie.posterUrl!,
                            width: 120,
                            height: 180,
                            fit: BoxFit.cover,
                            fadeInDuration: Duration.zero,
                            fadeOutDuration: Duration.zero,
                            memCacheWidth: 300,
                            errorWidget: (context, url, error) => Container(
                              width: 120,
                              height: 180,
                              color: Theme.of(context).colorScheme.surfaceVariant,
                              child: const Icon(Icons.movie, size: 48),
                            ),
                          )
                        : Container(
                            width: 120,
                            height: 180,
                            color: Theme.of(context).colorScheme.surfaceVariant,
                            child: const Icon(Icons.movie, size: 48),
                          ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          movie.title ?? 'Unknown',
                          style: Theme.of(context).textTheme.headlineSmall,
                        ),
                        if (movie.year != null)
                          Text(
                            '${movie.year}',
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                        const SizedBox(height: 8),
                        if (movie.studio != null)
                          Text(
                            movie.studio!,
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        if (movie.runtime != null)
                          Text(
                            '${movie.runtime} minutes',
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        const SizedBox(height: 8),
                        Wrap(
                          spacing: 8,
                          children: [
                            _StatusChip(
                              label: movie.hasFile == true ? 'Downloaded' : 'Missing',
                              color: movie.hasFile == true ? Colors.green : Colors.orange,
                            ),
                            _StatusChip(
                              label: movie.monitored == true ? 'Monitored' : 'Unmonitored',
                              color: movie.monitored == true ? Colors.blue : Colors.grey,
                            ),
                            if (movie.isAvailable == true)
                              const _StatusChip(
                                label: 'Available',
                                color: Colors.green,
                              ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              if (movie.overview != null) ...[
                Text(
                  'Overview',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 8),
                Text(
                  movie.overview!,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(height: 16),
              ],
              if (movie.genres != null && movie.genres!.isNotEmpty) ...[
                Text(
                  'Genres',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  children: movie.genres!.map((genre) => Chip(label: Text(genre))).toList(),
                ),
                const SizedBox(height: 16),
              ],
              if (movie.ratings != null) ...[
                Text(
                  'Ratings',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 8),
                if (movie.ratings!.value != null)
                  _RatingRow(
                    label: 'Rating',
                    rating: movie.ratings!.value!,
                    votes: movie.ratings!.votes?.toInt(),
                  ),
                const SizedBox(height: 16),
              ],
              if (movie.certification != null) ...[
                Text(
                  'Details',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 8),
                _DetailRow(label: 'Certification', value: movie.certification!),
                if (movie.inCinemas != null)
                  _DetailRow(
                    label: 'In Cinemas',
                    value: _formatDate(movie.inCinemas!),
                  ),
                if (movie.physicalRelease != null)
                  _DetailRow(
                    label: 'Physical Release',
                    value: _formatDate(movie.physicalRelease!),
                  ),
                if (movie.digitalRelease != null)
                  _DetailRow(
                    label: 'Digital Release',
                    value: _formatDate(movie.digitalRelease!),
                  ),
                if (movie.path != null)
                  _DetailRow(label: 'Path', value: movie.path!),
                if (movie.sizeOnDisk != null && movie.sizeOnDisk! > 0)
                  _DetailRow(
                    label: 'Size',
                    value: _formatFileSize(movie.sizeOnDisk!),
                  ),
              ],
            ],
          ),
        );
      },
    );
  }
  
  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
  
  String _formatFileSize(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(2)} KB';
    if (bytes < 1024 * 1024 * 1024) return '${(bytes / (1024 * 1024)).toStringAsFixed(2)} MB';
    return '${(bytes / (1024 * 1024 * 1024)).toStringAsFixed(2)} GB';
  }
}

class _StatusChip extends StatelessWidget {
  final String label;
  final Color color;
  
  const _StatusChip({required this.label, required this.color});
  
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.2),
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: color),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color,
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

class _RatingRow extends StatelessWidget {
  final String label;
  final double rating;
  final int? votes;
  
  const _RatingRow({
    required this.label,
    required this.rating,
    this.votes,
  });
  
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label),
          Row(
            children: [
              Icon(Icons.star, size: 16, color: Theme.of(context).colorScheme.primary),
              const SizedBox(width: 4),
              Text(
                rating.toStringAsFixed(1),
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              if (votes != null) ...[
                const SizedBox(width: 4),
                Text(
                  '($votes)',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  final String label;
  final String value;
  
  const _DetailRow({required this.label, required this.value});
  
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
        ],
      ),
    );
  }
}