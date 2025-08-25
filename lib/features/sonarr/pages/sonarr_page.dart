import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:go_router/go_router.dart';
import 'package:arr/providers/sonarr_providers.dart';
import 'package:arr/models/hive/series_hive.dart';

class SonarrPage extends ConsumerWidget {
  const SonarrPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final seriesAsync = ref.watch(seriesListProvider);
    final filteredSeries = ref.watch(filteredSeriesProvider);
    final searchQuery = ref.watch(seriesSearchProvider);
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('TV Shows'),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search TV shows...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: searchQuery.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          ref.read(seriesSearchProvider.notifier).state = '';
                        },
                      )
                    : null,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                filled: true,
                fillColor: Theme.of(context).colorScheme.surface,
              ),
              onChanged: (value) {
                ref.read(seriesSearchProvider.notifier).state = value;
              },
            ),
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              ref.invalidate(seriesListProvider);
            },
          ),
        ],
      ),
      body: seriesAsync.when(
        data: (series) {
          if (filteredSeries.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.tv_outlined,
                    size: 64,
                    color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    searchQuery.isNotEmpty ? 'No TV shows found' : 'No TV shows in library',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  if (searchQuery.isNotEmpty) ...[
                    const SizedBox(height: 8),
                    TextButton(
                      onPressed: () {
                        ref.read(seriesSearchProvider.notifier).state = '';
                      },
                      child: const Text('Clear search'),
                    ),
                  ],
                ],
              ),
            );
          }
          
          return RefreshIndicator(
            onRefresh: () async {
              ref.invalidate(seriesListProvider);
            },
            child: GridView.builder(
              padding: const EdgeInsets.all(8),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: _getGridCrossAxisCount(context),
                childAspectRatio: 0.65,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
              ),
              itemCount: filteredSeries.length,
              itemBuilder: (context, index) {
                final series = filteredSeries[index];
                return _SeriesGridItem(series: series);
              },
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.error_outline,
                size: 64,
                color: Theme.of(context).colorScheme.error,
              ),
              const SizedBox(height: 16),
              Text(
                'Error loading TV shows',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 8),
              Text(
                error.toString(),
                style: Theme.of(context).textTheme.bodyMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              ElevatedButton.icon(
                onPressed: () {
                  ref.invalidate(seriesListProvider);
                },
                icon: const Icon(Icons.refresh),
                label: const Text('Retry'),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          _showSeriesStats(context, ref);
        },
        icon: const Icon(Icons.analytics),
        label: const Text('Stats'),
      ),
    );
  }
  
  int _getGridCrossAxisCount(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    if (width < 600) return 2;
    if (width < 900) return 3;
    if (width < 1200) return 4;
    return 5;
  }
  
  void _showSeriesStats(BuildContext context, WidgetRef ref) {
    final stats = ref.read(seriesStatsProvider);
    
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'TV Show Statistics',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 16),
            _StatRow(label: 'Total Shows', value: stats.total.toString()),
            _StatRow(label: 'Monitored', value: stats.monitored.toString()),
            _StatRow(label: 'Continuing', value: stats.continuing.toString()),
            _StatRow(label: 'Ended', value: stats.ended.toString()),
            _StatRow(label: 'Total Episodes', value: stats.totalEpisodes.toString()),
            _StatRow(label: 'Total Size', value: stats.formattedSize),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}

class _SeriesGridItem extends StatelessWidget {
  final SeriesHive series;
  
  const _SeriesGridItem({required this.series});
  
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        context.push('/sonarr/series/${series.id}', extra: series);
      },
      child: Card(
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: Stack(
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
                        child: const Icon(Icons.tv, size: 48),
                      ),
                    )
                  else
                    Container(
                      color: Theme.of(context).colorScheme.surfaceVariant,
                      child: const Icon(Icons.tv, size: 48),
                    ),
                  Positioned(
                    top: 8,
                    right: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: _getStatusColor(series),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        _getStatusText(series),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  if (series.monitored == false)
                    Positioned.fill(
                      child: Container(
                        color: Colors.black54,
                        child: const Center(
                          child: Icon(
                            Icons.visibility_off,
                            color: Colors.white70,
                            size: 32,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.all(8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    series.title ?? 'Unknown',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Row(
                    children: [
                      if (series.year != null)
                        Text(
                          series.year.toString(),
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      if (series.seasonCount != null) ...[
                        if (series.year != null) const Text(' • ', style: TextStyle(fontSize: 12)),
                        Text(
                          '${series.seasonCount} ${series.seasonCount == 1 ? 'Season' : 'Seasons'}',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
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

class _StatRow extends StatelessWidget {
  final String label;
  final String value;
  
  const _StatRow({required this.label, required this.value});
  
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label),
          Text(
            value,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}