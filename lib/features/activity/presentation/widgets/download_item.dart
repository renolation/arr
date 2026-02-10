import 'package:flutter/material.dart';
import '../../domain/entities/download.dart';
import '../../../../core/utils/formatters.dart';

/// Widget for displaying a download item
class DownloadItem extends StatelessWidget {
  final Download download;

  const DownloadItem({
    super.key,
    required this.download,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: Theme.of(context).colorScheme.outline.withOpacity(0.15),
          width: 1,
        ),
      ),
      child: InkWell(
        onTap: () => _showDetails(context),
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header: Title and Status
              Row(
                children: [
                  Expanded(
                    child: Text(
                      download.title,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(width: 12),
                  _buildStatusChip(context),
                ],
              ),

              const SizedBox(height: 16),

              // Progress Bar (if active)
              if (download.isActive || download.isPaused) ...[
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: LinearProgressIndicator(
                    value: download.hasProgress ? download.progress! / 100 : null,
                    backgroundColor: Theme.of(context).colorScheme.surfaceContainerHighest,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      _getProgressColor(context),
                    ),
                    minHeight: 6,
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Icon(
                      download.isActive ? Icons.downloading_rounded : Icons.pause_circle_rounded,
                      size: 16,
                      color: _getProgressColor(context),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      download.progressText,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: _getProgressColor(context),
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                    const Spacer(),
                    if (download.size != null)
                      Row(
                        children: [
                          Icon(
                            Icons.storage_rounded,
                            size: 14,
                            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '${Formatters.formatFileSize(download.size!.toInt())} / ${Formatters.formatFileSize(download.sizeLeft?.toInt() ?? 0)}',
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onSurface
                                      .withOpacity(0.7),
                                ),
                          ),
                        ],
                      ),
                  ],
                ),
              ] else if (download.isComplete) ...[
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: Colors.green.withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.check_rounded, size: 14, color: Colors.green),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Completed',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Colors.green,
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                    const Spacer(),
                    if (download.size != null)
                      Text(
                        Formatters.formatFileSize(download.size!.toInt()),
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                            ),
                      ),
                  ],
                ),
              ] else if (download.hasFailed) ...[
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: Colors.red.withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.error_rounded, size: 14, color: Colors.red),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        download.errorMessage ?? 'Download failed',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: Colors.red,
                            ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ],

              // Footer: Source and Actions
              const SizedBox(height: 12),
              Row(
                children: [
                  _buildSourceBadge(context),
                  const Spacer(),
                  if (download.isActive || download.isPaused) _buildActionButtons(context),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatusChip(BuildContext context) {
    final color = _getStatusColor(context);
    final icon = _getStatusIcon();

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: color.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: color),
          const SizedBox(width: 6),
          Text(
            download.statusText,
            style: Theme.of(context).textTheme.labelMedium?.copyWith(
                  color: color,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.3,
                ),
          ),
        ],
      ),
    );
  }

  Widget _buildSourceBadge(BuildContext context) {
    final isSonarr = download.source == DownloadSource.sonarr;
    final color = isSonarr
        ? Theme.of(context).colorScheme.primary
        : Theme.of(context).colorScheme.secondary;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: color.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            isSonarr ? Icons.tv_rounded : Icons.movie_rounded,
            size: 14,
            color: color,
          ),
          const SizedBox(width: 6),
          Text(
            isSonarr ? 'Sonarr' : 'Radarr',
            style: Theme.of(context).textTheme.labelMedium?.copyWith(
                  color: color,
                  fontWeight: FontWeight.w700,
                ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (download.isPaused)
          Container(
            decoration: BoxDecoration(
              color: Colors.green.withOpacity(0.12),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: Colors.green.withOpacity(0.3),
                width: 1,
              ),
            ),
            child: IconButton(
              onPressed: () => _onResume(context),
              icon: const Icon(Icons.play_arrow_rounded, size: 20),
              style: IconButton.styleFrom(
                foregroundColor: Colors.green,
                padding: const EdgeInsets.all(8),
              ),
              tooltip: 'Resume',
              constraints: const BoxConstraints(
                minWidth: 40,
                minHeight: 40,
              ),
            ),
          )
        else if (download.isActive)
          Container(
            decoration: BoxDecoration(
              color: Colors.orange.withOpacity(0.12),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: Colors.orange.withOpacity(0.3),
                width: 1,
              ),
            ),
            child: IconButton(
              onPressed: () => _onPause(context),
              icon: const Icon(Icons.pause_rounded, size: 20),
              style: IconButton.styleFrom(
                foregroundColor: Colors.orange,
                padding: const EdgeInsets.all(8),
              ),
              tooltip: 'Pause',
              constraints: const BoxConstraints(
                minWidth: 40,
                minHeight: 40,
              ),
            ),
          ),
        const SizedBox(width: 8),
        Container(
          decoration: BoxDecoration(
            color: Colors.red.withOpacity(0.12),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: Colors.red.withOpacity(0.3),
              width: 1,
            ),
          ),
          child: IconButton(
            onPressed: () => _onRemove(context),
            icon: const Icon(Icons.close_rounded, size: 20),
            style: IconButton.styleFrom(
              foregroundColor: Colors.red,
              padding: const EdgeInsets.all(8),
            ),
            tooltip: 'Remove',
            constraints: const BoxConstraints(
              minWidth: 40,
              minHeight: 40,
            ),
          ),
        ),
      ],
    );
  }

  Color _getStatusColor(BuildContext context) {
    switch (download.status) {
      case DownloadStatus.downloading:
        return Colors.blue;
      case DownloadStatus.paused:
        return Colors.orange;
      case DownloadStatus.completed:
        return Colors.green;
      case DownloadStatus.failed:
      case DownloadStatus.warning:
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  Color _getProgressColor(BuildContext context) {
    if (download.status == DownloadStatus.downloading) {
      return Colors.blue;
    } else if (download.status == DownloadStatus.paused) {
      return Colors.orange;
    }
    return Theme.of(context).colorScheme.primary;
  }

  IconData _getStatusIcon() {
    switch (download.status) {
      case DownloadStatus.downloading:
        return Icons.downloading_rounded;
      case DownloadStatus.paused:
        return Icons.pause_circle_rounded;
      case DownloadStatus.completed:
        return Icons.check_circle_rounded;
      case DownloadStatus.failed:
      case DownloadStatus.warning:
        return Icons.error_rounded;
      default:
        return Icons.pending_rounded;
    }
  }

  void _showDetails(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        ),
        padding: const EdgeInsets.all(20.0),
        child: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Handle bar
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.onSurface.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                download.title,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 16),
              if (download.quality != null) _buildDetailRow(context, 'Quality', download.quality!),
              if (download.protocol != null) _buildDetailRow(context, 'Protocol', download.protocol!),
              if (download.errorMessage != null)
                _buildDetailRow(context, 'Error', download.errorMessage!, isError: true),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(BuildContext context, String label, String value, {bool isError = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: isError ? Colors.red : null,
                  fontWeight: FontWeight.w500,
                ),
          ),
        ],
      ),
    );
  }

  void _onPause(BuildContext context) {
    // TODO: Implement pause action
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.pause_rounded, size: 20),
            const SizedBox(width: 8),
            Text('Pausing ${download.title}'),
          ],
        ),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  void _onResume(BuildContext context) {
    // TODO: Implement resume action
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.play_arrow_rounded, size: 20),
            const SizedBox(width: 8),
            Text('Resuming ${download.title}'),
          ],
        ),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  void _onRemove(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Remove Download'),
        content: const Text('Are you sure you want to remove this download?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              // TODO: Implement remove action
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Row(
                    children: [
                      const Icon(Icons.check_rounded, size: 20),
                      const SizedBox(width: 8),
                      Text('Removed ${download.title}'),
                    ],
                  ),
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
              );
            },
            child: const Text('Remove'),
          ),
        ],
      ),
    );
  }
}
