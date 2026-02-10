import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/widgets/loading_indicator.dart';
import '../../../../core/widgets/error_widget.dart';
import '../providers/system_status_provider.dart';
import '../widgets/status_card.dart';
import '../widgets/airing_section.dart';

/// Overview/Dashboard page showing system status and activity
class OverviewPage extends ConsumerWidget {
  const OverviewPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final allStatuses = ref.watch(allStatusesProvider);

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar.large(
            title: const Text('Dashboard'),
            floating: true,
            elevation: 0,
          ),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                // Welcome Section
                _buildWelcomeSection(context),
                const SizedBox(height: 28),

                // Service Status Section
                _buildSectionHeader(context, 'Services', Icons.dashboard_outlined),
                const SizedBox(height: 16),

                // Service Status Cards
                allStatuses.when(
                  data: (statuses) => Column(
                    children: [
                      StatusCard(
                        title: 'Sonarr',
                        status: statuses['sonarr'] != null ? 'Connected' : 'Disconnected',
                        version: statuses['sonarr']?.version ?? 'Not configured',
                        icon: Icons.tv_rounded,
                        isOnline: statuses['sonarr'] != null,
                      ),
                      const SizedBox(height: 12),
                      StatusCard(
                        title: 'Radarr',
                        status: statuses['radarr'] != null ? 'Connected' : 'Disconnected',
                        version: statuses['radarr']?.version ?? 'Not configured',
                        icon: Icons.movie_rounded,
                        isOnline: statuses['radarr'] != null,
                      ),
                      const SizedBox(height: 12),
                      StatusCard(
                        title: 'Overseerr',
                        status: statuses['overseerr'] != null ? 'Connected' : 'Disconnected',
                        version: statuses['overseerr']?.version ?? 'Not configured',
                        icon: Icons.request_page_rounded,
                        isOnline: statuses['overseerr'] != null,
                      ),
                    ],
                  ),
                  loading: () => const SizedBox(
                    height: 200,
                    child: Center(child: LoadingIndicator()),
                  ),
                  error: (error, stack) => ServerErrorWidget(
                    onRetry: () => ref.refresh(allStatusesProvider),
                  ),
                ),

                const SizedBox(height: 28),

                // Airing Section
                _buildSectionHeader(context, 'Coming Soon', Icons.upcoming_outlined),
                const SizedBox(height: 16),
                const AiringSection(),

                const SizedBox(height: 28),

                // Recent Activity Section
                _buildSectionHeader(context, 'Recent Activity', Icons.history_outlined),
                const SizedBox(height: 16),
                _buildRecentActivity(context),

                const SizedBox(height: 32),
              ]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWelcomeSection(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Theme.of(context).colorScheme.primary.withOpacity(0.1),
            Theme.of(context).colorScheme.secondary.withOpacity(0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Theme.of(context).colorScheme.primary.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary.withOpacity(0.15),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              Icons.dashboard_rounded,
              size: 28,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Welcome back',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Monitor your *arr stack services',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                      ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title, IconData icon) {
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

  Widget _buildRecentActivity(BuildContext context) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: Theme.of(context).colorScheme.outline.withOpacity(0.2),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.history,
                  size: 20,
                  color: Theme.of(context).colorScheme.primary,
                ),
                const SizedBox(width: 8),
                Text(
                  'Recent Downloads',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Center(
              child: Column(
                children: [
                  Icon(
                    Icons.inbox_outlined,
                    size: 48,
                    color: Theme.of(context).colorScheme.onSurface.withOpacity(0.3),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'No recent activity',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                        ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
