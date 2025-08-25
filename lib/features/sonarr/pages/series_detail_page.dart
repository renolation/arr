import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:arr/models/hive/series_hive.dart';
import 'package:arr/providers/sonarr_providers.dart';

class SeriesDetailPage extends ConsumerWidget {
  final SeriesHive series;

  const SeriesDetailPage({
    super.key,
    required this.series,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final episodesAsync = ref.watch(seriesEpisodesProvider(series.id ?? 0));

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 400,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                series.title ?? 'Unknown',
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
                  if (series.posterUrl.isNotEmpty)
                    CachedNetworkImage(
                      imageUrl: series.posterUrl,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => Container(
                        color: Theme.of(context).colorScheme.surfaceVariant,
                        child: const Center(child: CircularProgressIndicator()),
                      ),
                      errorWidget: (context, url, error) => Container(
                        color: Theme.of(context).colorScheme.surfaceVariant,
                        child: const Icon(Icons.tv, size: 64),
                      ),
                    )
                  else
                    Container(
                      color: Theme.of(context).colorScheme.surfaceVariant,
                      child: const Icon(Icons.tv, size: 64),
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
                        label: series.year?.toString() ?? 'Unknown',
                      ),
                      const SizedBox(width: 8),
                      _InfoChip(
                        icon: Icons.library_books,
                        label: '${series.seasonCount ?? 0} Seasons',
                      ),
                      const SizedBox(width: 8),
                      _InfoChip(
                        icon: series.monitored == true
                            ? Icons.visibility
                            : Icons.visibility_off,
                        label: series.monitored == true ? 'Monitored' : 'Not Monitored',
                        color: series.monitored == true ? Colors.green : Colors.orange,
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      _InfoChip(
                        icon: Icons.info,
                        label: _getStatusText(series),
                        color: _getStatusColor(series),
                      ),
                      const SizedBox(width: 8),
                      if (series.network != null)
                        _InfoChip(
                          icon: Icons.tv_outlined,
                          label: series.network!,
                        ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  if (series.overview != null) ...[
                    Text(
                      'Overview',
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      series.overview!,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    const SizedBox(height: 24),
                  ],
                  Text(
                    'Episodes',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 16),
                  episodesAsync.when(
                    data: (episodes) {
                      if (episodes.isEmpty) {
                        return const Center(
                          child: Padding(
                            padding: EdgeInsets.all(32.0),
                            child: Text('No episodes found'),
                          ),
                        );
                      }

                      final groupedEpisodes = <int, List<dynamic>>{};
                      for (final episode in episodes) {
                        final season = episode.seasonNumber ?? 0;
                        groupedEpisodes[season] ??= [];
                        groupedEpisodes[season]!.add(episode);
                      }

                      final seasons = groupedEpisodes.keys.toList()..sort();

                      return Column(
                        children: seasons.map((season) {
                          final seasonEpisodes = groupedEpisodes[season]!;
                          return ExpansionTile(
                            title: Text(
                              season == 0 ? 'Specials' : 'Season $season',
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                            subtitle: Text('${seasonEpisodes.length} episodes'),
                            children: seasonEpisodes.map((episode) {
                              return ListTile(
                                leading: CircleAvatar(
                                  child: Text('${episode.episodeNumber ?? 0}'),
                                ),
                                title: Text(
                                  episode.title ?? 'Episode ${episode.episodeNumber}',
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                subtitle: Text(
                                  episode.airDate ?? 'Air date unknown',
                                ),
                                trailing: episode.hasFile == true
                                    ? const Icon(Icons.check_circle, color: Colors.green)
                                    : const Icon(Icons.radio_button_unchecked),
                              );
                            }).toList(),
                          );
                        }).toList(),
                      );
                    },
                    loading: () => const Center(
                      child: Padding(
                        padding: EdgeInsets.all(32.0),
                        child: CircularProgressIndicator(),
                      ),
                    ),
                    error: (error, stack) => Center(
                      child: Padding(
                        padding: const EdgeInsets.all(32.0),
                        child: Column(
                          children: [
                            const Icon(Icons.error_outline, size: 48),
                            const SizedBox(height: 8),
                            Text('Error loading episodes: $error'),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Color _getStatusColor(SeriesHive series) {
    if (series.status == 'ended') return Colors.red;
    if (series.status == 'continuing') return Colors.green;
    return Colors.orange;
  }

  String _getStatusText(SeriesHive series) {
    if (series.status == 'ended') return 'Ended';
    if (series.status == 'continuing') return 'Continuing';
    return series.status ?? 'Unknown';
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