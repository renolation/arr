import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../main.dart';
import '../../../library/presentation/providers/media_provider.dart';
import '../../../settings/domain/entities/service_config.dart';
import '../../../settings/presentation/pages/settings_page.dart';
import '../providers/service_stats_provider.dart';
import '../widgets/airing_section.dart';

/// Overview/Dashboard page showing service stats and activity
class OverviewPage extends ConsumerWidget {
  const OverviewPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final libraryAsync = ref.watch(unifiedLibraryProvider);
    final serviceStats = ref.watch(serviceStatsProvider);

    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () async {
          ref.read(unifiedLibraryProvider.notifier).refresh();
        },
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              title: const Text('Dashboard'),
              floating: true,
              elevation: 0,
              actions: [
                IconButton(
                  icon: const Icon(Icons.settings_outlined),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const SettingsPage()),
                    );
                  },
                ),
              ],
            ),
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  const SizedBox(height: 8),

                  // Services Section
                  _buildSectionHeader(context, 'Services'),
                  const SizedBox(height: 16),

                  libraryAsync.when(
                    data: (_) => serviceStats.isEmpty
                        ? _buildEmptyState(context, 'No services configured')
                        : Column(
                            children: serviceStats
                                .map((stats) => Padding(
                                      padding: const EdgeInsets.only(bottom: 12),
                                      child: _ServiceStatsCard(stats: stats),
                                    ))
                                .toList(),
                          ),
                    loading: () => const SizedBox(
                      height: 120,
                      child: Center(
                        child: SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        ),
                      ),
                    ),
                    error: (error, _) => _buildErrorCard(context, error.toString(), () {
                      ref.read(unifiedLibraryProvider.notifier).refresh();
                    }),
                  ),

                  const SizedBox(height: 28),

                  // Airing Section
                  _buildSectionHeader(context, 'Coming Soon'),
                  const SizedBox(height: 16),
                  const AiringSection(),

                  const SizedBox(height: 32),
                ]),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context, String message) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Theme.of(context).colorScheme.outline.withOpacity(0.2),
        ),
      ),
      child: Center(
        child: Text(
          message,
          style: TextStyle(
            fontSize: 14,
            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5),
          ),
        ),
      ),
    );
  }

  Widget _buildErrorCard(BuildContext context, String error, VoidCallback onRetry) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Theme.of(context).colorScheme.outline.withOpacity(0.2),
        ),
      ),
      child: Column(
        children: [
          Icon(Icons.error_outline, size: 32,
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.3)),
          const SizedBox(height: 8),
          Text(
            error,
            style: TextStyle(
              fontSize: 13,
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5),
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 12),
          TextButton(onPressed: onRetry, child: const Text('Retry')),
        ],
      ),
    );
  }
}

/// Card showing stats for a single service
class _ServiceStatsCard extends StatelessWidget {
  final ServiceStats stats;

  const _ServiceStatsCard({required this.stats});

  IconData get _serviceIcon {
    switch (stats.serviceType) {
      case ServiceType.sonarr:
        return Icons.tv_outlined;
      case ServiceType.radarr:
        return Icons.movie_outlined;
      case ServiceType.overseerr:
        return Icons.request_page_outlined;
      case ServiceType.downloadClient:
        return Icons.download_outlined;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isSeries = stats.serviceType == ServiceType.sonarr;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Theme.of(context).colorScheme.outline.withOpacity(0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header: icon + name + online badge
          Row(
            children: [
              Icon(_serviceIcon, size: 22,
                  color: Theme.of(context).colorScheme.primary),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  stats.serviceName,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: AppColors.accentGreen.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 6,
                      height: 6,
                      decoration: const BoxDecoration(
                        color: AppColors.accentGreen,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 5),
                    const Text(
                      'Online',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: AppColors.accentGreen,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Stats grid (2 columns)
          Row(
            children: [
              Expanded(
                child: _StatItem(
                  label: stats.itemLabel,
                  value: '${stats.totalItems}',
                ),
              ),
              Expanded(
                child: _StatItem(
                  label: isSeries ? 'Episodes' : 'Files',
                  value: isSeries
                      ? '${stats.episodeFiles}/${stats.totalEpisodes}'
                      : '${stats.withFiles}',
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _StatItem(
                  label: 'Size on Disk',
                  value: stats.formattedSize,
                ),
              ),
              Expanded(
                child: _StatItem(
                  label: 'Missing',
                  value: '${stats.missing}',
                  valueColor: stats.missing > 0 ? AppColors.accentRed : null,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final String label;
  final String value;
  final Color? valueColor;

  const _StatItem({
    required this.label,
    required this.value,
    this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w500,
            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.45),
          ),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: valueColor,
          ),
        ),
      ],
    );
  }
}
