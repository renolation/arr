import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:arr/models/hive/movie_hive.dart';

class MovieDetailPage extends ConsumerWidget {
  final MovieHive movie;

  const MovieDetailPage({
    super.key,
    required this.movie,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 400,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                movie.title ?? 'Unknown',
                style: const TextStyle(
                  shadows: [
                    Shadow(
                      offset: Offset(0, 1),
                      blurRadius: 3.0,
                      color: Colors.black54,
                    ),
                  ],
                ),
              ),
              background: Stack(
                fit: StackFit.expand,
                children: [
                  if (movie.posterUrl.isNotEmpty)
                    CachedNetworkImage(
                      imageUrl: movie.posterUrl,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => Container(
                        color: Theme.of(context).colorScheme.surfaceVariant,
                        child: const Center(child: CircularProgressIndicator()),
                      ),
                      errorWidget: (context, url, error) => Container(
                        color: Theme.of(context).colorScheme.surfaceVariant,
                        child: const Icon(Icons.movie, size: 64),
                      ),
                    )
                  else
                    Container(
                      color: Theme.of(context).colorScheme.surfaceVariant,
                      child: const Icon(Icons.movie, size: 64),
                    ),
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          Colors.black.withOpacity(0.7),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      _InfoChip(
                        icon: Icons.calendar_today,
                        label: movie.year?.toString() ?? 'Unknown',
                      ),
                      const SizedBox(width: 8),
                      if (movie.runtime != null && movie.runtime! > 0)
                        _InfoChip(
                          icon: Icons.schedule,
                          label: '${movie.runtime} min',
                        ),
                      const SizedBox(width: 8),
                      _InfoChip(
                        icon: movie.monitored == true
                            ? Icons.visibility
                            : Icons.visibility_off,
                        label: movie.monitored == true ? 'Monitored' : 'Not Monitored',
                        color: movie.monitored == true ? Colors.green : Colors.orange,
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      _InfoChip(
                        icon: movie.hasFile == true
                            ? Icons.check_circle
                            : Icons.radio_button_unchecked,
                        label: movie.hasFile == true ? 'Downloaded' : 'Missing',
                        color: movie.hasFile == true ? Colors.green : Colors.orange,
                      ),
                      const SizedBox(width: 8),
                      if (movie.certification != null && movie.certification!.isNotEmpty)
                        _InfoChip(
                          icon: Icons.local_movies,
                          label: movie.certification!,
                        ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  if (movie.ratings != null || movie.tmdbId != null)
                    Row(
                      children: [
                        if (movie.ratings?.imdb != null)
                          _InfoChip(
                            icon: Icons.star,
                            label: 'IMDb: ${movie.ratings!.imdb!.toStringAsFixed(1)}',
                            color: Colors.amber,
                          ),
                        if (movie.ratings?.imdb != null && movie.tmdbId != null)
                          const SizedBox(width: 8),
                        if (movie.tmdbId != null)
                          _InfoChip(
                            icon: Icons.movie_filter,
                            label: 'TMDB: ${movie.tmdbId}',
                          ),
                      ],
                    ),
                  const SizedBox(height: 16),
                  if (movie.overview != null) ...[
                    Text(
                      'Overview',
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      movie.overview!,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    const SizedBox(height: 24),
                  ],
                  if (movie.genres != null && movie.genres!.isNotEmpty) ...[
                    Text(
                      'Genres',
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: movie.genres!.map((genre) {
                        return Chip(
                          label: Text(genre),
                          backgroundColor: Theme.of(context).colorScheme.surfaceVariant,
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 24),
                  ],
                  if (movie.hasFile == true && movie.sizeOnDisk != null) ...[
                    Text(
                      'File Information',
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    const SizedBox(height: 8),
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _FileInfoRow(
                              label: 'Status',
                              value: 'Downloaded',
                            ),
                            if (movie.sizeOnDisk != null)
                              _FileInfoRow(
                                label: 'Size',
                                value: _formatBytes(movie.sizeOnDisk!),
                              ),
                            if (movie.added != null)
                              _FileInfoRow(
                                label: 'Date Added',
                                value: '${movie.added!.toLocal()}'.split(' ')[0],
                              ),
                            if (movie.path != null)
                              _FileInfoRow(
                                label: 'Path',
                                value: movie.path!,
                              ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                  ],
                  if (movie.studio != null && movie.studio!.isNotEmpty) ...[
                    Text(
                      'Studio',
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      movie.studio!,
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _formatBytes(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
    if (bytes < 1024 * 1024 * 1024) {
      return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
    }
    return '${(bytes / (1024 * 1024 * 1024)).toStringAsFixed(2)} GB';
  }
}

class _InfoChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color? color;

  const _InfoChip({
    required this.icon,
    required this.label,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: (color ?? Theme.of(context).colorScheme.primary).withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: (color ?? Theme.of(context).colorScheme.primary).withOpacity(0.3),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 16,
            color: color ?? Theme.of(context).colorScheme.primary,
          ),
          const SizedBox(width: 6),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: color ?? Theme.of(context).colorScheme.primary,
            ),
          ),
        ],
      ),
    );
  }
}

class _FileInfoRow extends StatelessWidget {
  final String label;
  final String value;

  const _FileInfoRow({
    required this.label,
    required this.value,
  });

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
                    fontWeight: FontWeight.w600,
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