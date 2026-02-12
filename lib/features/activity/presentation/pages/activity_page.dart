import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../main.dart';
import '../../../../core/widgets/loading_indicator.dart';
import '../../../../core/widgets/error_widget.dart';
import '../../domain/entities/download.dart';
import '../providers/download_provider.dart';

/// Activity page with Queue and History tabs
class ActivityPage extends ConsumerWidget {
  const ActivityPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final activeCount = ref.watch(activeDownloadsCountProvider);

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        body: NestedScrollView(
          headerSliverBuilder: (context, innerBoxIsScrolled) {
            return [
              SliverAppBar(
                pinned: true,
                floating: true,
                elevation: 0,
                backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                title: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.start,
                  spacing: 12,
                  children: [
                    const Text(
                      'Activity',
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        letterSpacing: -0.5,
                      ),
                    ),
                    if (activeCount > 0)
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.accentGreen.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Container(
                                  width: 8,
                                  height: 8,
                                  decoration: const BoxDecoration(
                                    color: AppColors.accentGreen,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  '$activeCount Downloading',
                                  style: const TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w500,
                                    color: AppColors.accentGreen,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                  ],
                ),
                bottom: TabBar(
                  labelColor: Theme.of(context).colorScheme.onSurface,
                  unselectedLabelColor:
                      Theme.of(context).colorScheme.onSurface.withOpacity(0.5),
                  indicatorColor: AppColors.primary,
                  indicatorWeight: 2,
                  labelStyle: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.5,
                  ),
                  unselectedLabelStyle: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    letterSpacing: 0.5,
                  ),
                  tabs: const [
                    Tab(text: 'QUEUE'),
                    Tab(text: 'HISTORY'),
                  ],
                ),
              ),
            ];
          },
          body: const TabBarView(
            children: [
              _QueueTab(),
              _HistoryTab(),
            ],
          ),
        ),
      ),
    );
  }
}

/// Queue tab - shows active downloads
class _QueueTab extends ConsumerWidget {
  const _QueueTab();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final queueAsync = ref.watch(unifiedQueueProvider);

    return queueAsync.when(
      data: (downloads) {
        if (downloads.isEmpty) {
          return _buildEmptyState(
            context,
            icon: Icons.download_outlined,
            title: 'No active downloads',
            subtitle: 'Queue items from Sonarr and Radarr will appear here',
          );
        }
        return RefreshIndicator(
          onRefresh: () => ref.read(unifiedQueueProvider.notifier).refresh(),
          child: ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: downloads.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (context, index) =>
                _QueueDownloadCard(download: downloads[index]),
          ),
        );
      },
      loading: () => const Center(child: LoadingIndicator()),
      error: (error, stack) => Center(
        child: ServerErrorWidget(
          onRetry: () => ref.read(unifiedQueueProvider.notifier).refresh(),
        ),
      ),
    );
  }
}

/// History tab - shows completed/failed items
class _HistoryTab extends ConsumerWidget {
  const _HistoryTab();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final historyAsync = ref.watch(unifiedHistoryProvider);

    return historyAsync.when(
      data: (downloads) {
        if (downloads.isEmpty) {
          return _buildEmptyState(
            context,
            icon: Icons.history_outlined,
            title: 'No history',
            subtitle: 'Completed and failed downloads will appear here',
          );
        }
        return RefreshIndicator(
          onRefresh: () => ref.read(unifiedHistoryProvider.notifier).refresh(),
          child: ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: downloads.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (context, index) =>
                _HistoryDownloadCard(download: downloads[index]),
          ),
        );
      },
      loading: () => const Center(child: LoadingIndicator()),
      error: (error, stack) => Center(
        child: ServerErrorWidget(
          onRetry: () => ref.read(unifiedHistoryProvider.notifier).refresh(),
        ),
      ),
    );
  }
}

Widget _buildEmptyState(
  BuildContext context, {
  required IconData icon,
  required String title,
  required String subtitle,
}) {
  return Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          icon,
          size: 64,
          color: Theme.of(context).colorScheme.onSurface.withOpacity(0.2),
        ),
        const SizedBox(height: 16),
        Text(
          title,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: 8),
        Text(
          subtitle,
          style: TextStyle(
            fontSize: 14,
            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5),
          ),
        ),
      ],
    ),
  );
}

/// Card for queue items (active downloads)
class _QueueDownloadCard extends StatelessWidget {
  final Download download;

  const _QueueDownloadCard({required this.download});

  @override
  Widget build(BuildContext context) {
    final progress = (download.progress ?? 0) / 100;
    final sizeLeftGB = download.sizeLeft != null
        ? (download.sizeLeft! / (1024 * 1024 * 1024))
        : null;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: Theme.of(context).colorScheme.outline.withOpacity(0.3),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title row with source badge
          Row(
            children: [
              Expanded(
                child: Text(
                  download.title,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: 8),
              _SourceBadge(source: download.source),
            ],
          ),
          const SizedBox(height: 8),
          // Quality and progress info
          Row(
            children: [
              if (download.quality != null) ...[
                Text(
                  download.quality!,
                  style: TextStyle(
                    fontSize: 12,
                    color: Theme.of(context)
                        .colorScheme
                        .onSurface
                        .withOpacity(0.6),
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  '\u2022',
                  style: TextStyle(
                    color: Theme.of(context)
                        .colorScheme
                        .onSurface
                        .withOpacity(0.3),
                  ),
                ),
                const SizedBox(width: 8),
              ],
              Text(
                download.progressText,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: AppColors.primary,
                ),
              ),
              if (sizeLeftGB != null) ...[
                const SizedBox(width: 8),
                Text(
                  '\u2022',
                  style: TextStyle(
                    color: Theme.of(context)
                        .colorScheme
                        .onSurface
                        .withOpacity(0.3),
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  '${sizeLeftGB.toStringAsFixed(1)} GB left',
                  style: TextStyle(
                    fontSize: 12,
                    color: Theme.of(context)
                        .colorScheme
                        .onSurface
                        .withOpacity(0.6),
                    fontFamily: 'monospace',
                  ),
                ),
              ],
            ],
          ),
          const SizedBox(height: 10),
          // Progress bar
          ClipRRect(
            borderRadius: BorderRadius.circular(2),
            child: LinearProgressIndicator(
              value: progress.clamp(0.0, 1.0),
              minHeight: 4,
              backgroundColor:
                  Theme.of(context).colorScheme.onSurface.withOpacity(0.1),
              valueColor: AlwaysStoppedAnimation<Color>(
                download.isPaused ? AppColors.accentYellow : AppColors.primary,
              ),
            ),
          ),
          const SizedBox(height: 8),
          // Status row
          Row(
            children: [
              _StatusBadge(download: download),
              if (download.protocol != null) ...[
                const SizedBox(width: 8),
                Text(
                  download.protocol!.toUpperCase(),
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w500,
                    color: Theme.of(context)
                        .colorScheme
                        .onSurface
                        .withOpacity(0.4),
                    letterSpacing: 0.5,
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }
}

/// Card for history items
class _HistoryDownloadCard extends StatelessWidget {
  final Download download;

  const _HistoryDownloadCard({required this.download});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: Theme.of(context).colorScheme.outline.withOpacity(0.3),
        ),
      ),
      child: Row(
        children: [
          // Status icon
          _HistoryStatusIcon(download: download),
          const SizedBox(width: 12),
          // Content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  download.title,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    if (download.quality != null) ...[
                      Text(
                        download.quality!,
                        style: TextStyle(
                          fontSize: 12,
                          color: Theme.of(context)
                              .colorScheme
                              .onSurface
                              .withOpacity(0.6),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '\u2022',
                        style: TextStyle(
                          color: Theme.of(context)
                              .colorScheme
                              .onSurface
                              .withOpacity(0.3),
                        ),
                      ),
                      const SizedBox(width: 8),
                    ],
                    if (download.eventType != null)
                      Text(
                        _formatEventType(download.eventType!),
                        style: TextStyle(
                          fontSize: 12,
                          color: Theme.of(context)
                              .colorScheme
                              .onSurface
                              .withOpacity(0.6),
                        ),
                      ),
                    if (download.date != null) ...[
                      const SizedBox(width: 8),
                      Text(
                        '\u2022',
                        style: TextStyle(
                          color: Theme.of(context)
                              .colorScheme
                              .onSurface
                              .withOpacity(0.3),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        _formatTimeAgo(download.date!),
                        style: TextStyle(
                          fontSize: 12,
                          color: Theme.of(context)
                              .colorScheme
                              .onSurface
                              .withOpacity(0.5),
                        ),
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          _SourceBadge(source: download.source),
        ],
      ),
    );
  }

  String _formatEventType(String eventType) {
    switch (eventType) {
      case 'grabbed':
        return 'Grabbed';
      case 'downloadFolderImported':
      case 'downloadImported':
        return 'Imported';
      case 'downloadFailed':
        return 'Failed';
      case 'episodeFileDeleted':
      case 'movieFileDeleted':
        return 'Deleted';
      case 'episodeFileRenamed':
      case 'movieFileRenamed':
        return 'Renamed';
      default:
        return eventType;
    }
  }

  String _formatTimeAgo(DateTime date) {
    final now = DateTime.now();
    final diff = now.difference(date);

    if (diff.inMinutes < 1) return 'Just now';
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    if (diff.inDays < 7) return '${diff.inDays}d ago';
    return '${date.month}/${date.day}';
  }
}

/// History status icon
class _HistoryStatusIcon extends StatelessWidget {
  final Download download;

  const _HistoryStatusIcon({required this.download});

  @override
  Widget build(BuildContext context) {
    final (icon, color) = switch (download.status) {
      DownloadStatus.completed => (Icons.check_circle, AppColors.accentGreen),
      DownloadStatus.failed => (Icons.error, AppColors.accentRed),
      DownloadStatus.warning => (Icons.warning_amber_rounded, AppColors.accentYellow),
      DownloadStatus.downloading => (Icons.downloading, AppColors.primary),
      _ => (Icons.info_outline, Theme.of(context).colorScheme.onSurface.withOpacity(0.4)),
    };

    return Icon(icon, size: 24, color: color);
  }
}

/// Source badge (Sonarr/Radarr)
class _SourceBadge extends StatelessWidget {
  final DownloadSource source;

  const _SourceBadge({required this.source});

  @override
  Widget build(BuildContext context) {
    final isRadarr = source == DownloadSource.radarr;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: (isRadarr ? AppColors.accentYellow : AppColors.primary)
            .withOpacity(0.15),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        isRadarr ? 'RAD' : 'SON',
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w600,
          color: isRadarr ? AppColors.accentYellow : AppColors.primary,
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}

/// Status badge for queue items
class _StatusBadge extends StatelessWidget {
  final Download download;

  const _StatusBadge({required this.download});

  @override
  Widget build(BuildContext context) {
    final (label, color) = switch (download.status) {
      DownloadStatus.downloading => ('DOWNLOADING', AppColors.primary),
      DownloadStatus.queued => ('QUEUED', Theme.of(context).colorScheme.onSurface.withOpacity(0.5)),
      DownloadStatus.paused => ('PAUSED', AppColors.accentYellow),
      DownloadStatus.completed => ('COMPLETED', AppColors.accentGreen),
      DownloadStatus.failed => ('FAILED', AppColors.accentRed),
      DownloadStatus.warning => ('WARNING', AppColors.accentYellow),
    };

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w600,
          color: color,
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}
