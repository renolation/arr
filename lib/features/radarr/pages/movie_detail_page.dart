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
            elevation: 0,
            flexibleSpace: FlexibleSpaceBar(
              titlePadding: const EdgeInsets.only(left: 16, bottom: 16),
              title: Text(
                movie.title ?? 'Unknown',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  shadows: [
                    Shadow(
                      offset: Offset(0, 2),
                      blurRadius: 8.0,
                      color: Colors.black87,
                    ),
                  ],
                ),
              ),
              background: Stack(
                fit: StackFit.expand,
                children: [
                  if (movie.posterUrl != null && movie.posterUrl!.isNotEmpty)
                    CachedNetworkImage(
                      imageUrl: movie.posterUrl!,
                      fit: BoxFit.cover,
                      fadeInDuration: Duration.zero,
                      fadeOutDuration: Duration.zero,
                      memCacheWidth: 300,
                      placeholder: (context, url) => Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              Theme.of(context).colorScheme.surfaceContainerHighest,
                              Theme.of(context).colorScheme.surface,
                            ],
                          ),
                        ),
                        child: const Center(child: CircularProgressIndicator()),
                      ),
                      errorWidget: (context, url, error) => Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              Theme.of(context).colorScheme.surfaceContainerHighest,
                              Theme.of(context).colorScheme.surface,
                            ],
                          ),
                        ),
                        child: const Icon(Icons.movie_rounded, size: 64),
                      ),
                    )
                  else
                    Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            Theme.of(context).colorScheme.surfaceContainerHighest,
                            Theme.of(context).colorScheme.surface,
                          ],
                        ),
                      ),
                      child: const Icon(Icons.movie_rounded, size: 64),
                    ),
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          Colors.black.withOpacity(0.8),
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
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Info Chips Row 1
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      _InfoChip(
                        icon: Icons.calendar_today_rounded,
                        label: movie.year?.toString() ?? 'Unknown',
                      ),
                      if (movie.runtime != null && movie.runtime! > 0)
                        _InfoChip(
                          icon: Icons.schedule_rounded,
                          label: '${movie.runtime} min',
                        ),
                      _InfoChip(
                        icon: movie.monitored == true
                            ? Icons.visibility_rounded
                            : Icons.visibility_off_rounded,
                        label: movie.monitored == true ? 'Monitored' : 'Not Monitored',
                        color: movie.monitored == true ? Colors.green : Colors.orange,
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  // Info Chips Row 2
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      _InfoChip(
                        icon: movie.hasFile == true
                            ? Icons.check_circle_rounded
                            : Icons.radio_button_unchecked_rounded,
                        label: movie.hasFile == true ? 'Downloaded' : 'Missing',
                        color: movie.hasFile == true ? Colors.green : Colors.orange,
                      ),
                      if (movie.certification != null && movie.certification!.isNotEmpty)
                        _InfoChip(
                          icon: Icons.local_movies_rounded,
                          label: movie.certification!,
                        ),
                      if (movie.ratings?.value != null)
                        _InfoChip(
                          icon: Icons.star_rounded,
                          label: movie.ratings!.value!.toStringAsFixed(1),
                          color: Colors.amber,
                        ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // Overview Section
                  if (movie.overview != null) ...[
                    _SectionHeader(icon: Icons.info_outline_rounded, title: 'Overview'),
                    const SizedBox(height: 12),
                    Text(
                      movie.overview!,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            height: 1.6,
                            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.9),
                          ),
                    ),
                    const SizedBox(height: 24),
                  ],

                  // Genres Section
                  if (movie.genres != null && movie.genres!.isNotEmpty) ...[
                    _SectionHeader(icon: Icons.category_outlined, title: 'Genres'),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: movie.genres!.map((genre) {
                        return Chip(
                          label: Text(genre),
                          backgroundColor: Theme.of(context).colorScheme.surfaceContainerHighest,
                          side: BorderSide(
                            color: Theme.of(context).colorScheme.outline.withOpacity(0.2),
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 24),
                  ],

                  // File Information Section
                  if (movie.hasFile == true && movie.sizeOnDisk != null) ...[
                    _SectionHeader(icon: Icons.folder_open_rounded, title: 'File Information'),
                    const SizedBox(height: 12),
                    Card(
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                        side: BorderSide(
                          color: Theme.of(context).colorScheme.outline.withOpacity(0.15),
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _FileInfoRow(
                              label: 'Status',
                              value: 'Downloaded',
                              icon: Icons.check_circle_rounded,
                              iconColor: Colors.green,
                            ),
                            if (movie.sizeOnDisk != null)
                              _FileInfoRow(
                                label: 'Size',
                                value: _formatBytes(movie.sizeOnDisk!),
                                icon: Icons.storage_rounded,
                              ),
                            if (movie.added != null)
                              _FileInfoRow(
                                label: 'Date Added',
                                value: '${movie.added!.toLocal()}'.split(' ')[0],
                                icon: Icons.calendar_today_rounded,
                              ),
                            if (movie.path != null)
                              _FileInfoRow(
                                label: 'Path',
                                value: movie.path!,
                                icon: Icons.folder_rounded,
                              ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                  ],

                  // Studio Section
                  if (movie.studio != null && movie.studio!.isNotEmpty) ...[
                    _SectionHeader(icon: Icons.business_rounded, title: 'Studio'),
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.surfaceContainerHighest,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        movie.studio!,
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                      ),
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

class _SectionHeader extends StatelessWidget {
  final IconData icon;
  final String title;

  const _SectionHeader({
    required this.icon,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(
            icon,
            size: 20,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
        const SizedBox(width: 12),
        Text(
          title,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
      ],
    );
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
        color: (color ?? Theme.of(context).colorScheme.primary).withOpacity(0.12),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: (color ?? Theme.of(context).colorScheme.primary).withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 14,
            color: color ?? Theme.of(context).colorScheme.primary,
          ),
          const SizedBox(width: 6),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: color ?? Theme.of(context).colorScheme.primary,
              letterSpacing: 0.3,
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
  final IconData? icon;
  final Color? iconColor;

  const _FileInfoRow({
    required this.label,
    required this.value,
    this.icon,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (icon != null) ...[
            Icon(
              icon,
              size: 18,
              color: iconColor ?? Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
            ),
            const SizedBox(width: 8),
          ],
          Text(
            label,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              value,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onSurface.withOpacity(0.9),
                  ),
            ),
          ),
        ],
      ),
    );
  }
}