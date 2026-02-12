import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/network/models/jellyseerr_models.dart';
import '../../../../core/utils/formatters.dart';
import '../providers/requests_provider.dart';

/// Card widget for displaying and approving requests
class ApprovalCard extends ConsumerWidget {
  final JellyseerrRequest request;

  const ApprovalCard({
    super.key,
    required this.request,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final actionState = ref.watch(requestActionsProvider);
    final isLoading = actionState is AsyncLoading;

    return Card(
      elevation: 0,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.15),
          width: 1,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            _buildPoster(context),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title and Type Badge
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          _getTitle(),
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: 8),
                      _buildTypeBadge(context),
                    ],
                  ),
                  const SizedBox(height: 8),
                  // Requester
                  if (request.requestedBy?.displayName != null)
                    Row(
                      children: [
                        Icon(
                          Icons.person_outline_rounded,
                          size: 14,
                          color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
                        ),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            'Req. by ${request.requestedBy!.displayName}',
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                  color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7),
                                ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  if (request.createdAt != null) ...[
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(
                          Icons.schedule_outlined,
                          size: 14,
                          color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.5),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          Formatters.getRelativeTime(request.createdAt!),
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
                              ),
                        ),
                      ],
                    ),
                  ],
                  const SizedBox(height: 12),
                  // Status and Actions
                  Row(
                    children: [
                      _buildStatusChip(context),
                      const Spacer(),
                      if (request.isPending && !isLoading) _buildActionButtons(context, ref),
                      if (isLoading)
                        const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        ),
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

  String _getTitle() {
    // JellyseerrRequest doesn't have a title field directly -
    // the media object has tmdbId but not the title.
    // We show the media type + ID as fallback
    return 'Request #${request.id}';
  }

  Widget _buildPoster(BuildContext context) {
    // JellyseerrRequest media object doesn't have poster URL directly
    return Container(
      width: 70,
      height: 100,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: Icon(
        request.mediaType == 'tv' ? Icons.tv_outlined : Icons.movie_outlined,
        size: 32,
        color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.3),
      ),
    );
  }

  Widget _buildTypeBadge(BuildContext context) {
    final isTv = request.mediaType == 'tv';
    final color = isTv
        ? Theme.of(context).colorScheme.primary
        : Theme.of(context).colorScheme.secondary;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withValues(alpha: 0.3), width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(isTv ? Icons.tv_rounded : Icons.movie_rounded, size: 10, color: color),
          const SizedBox(width: 4),
          Text(
            isTv ? 'TV' : 'MOV',
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: color,
                  fontWeight: FontWeight.w700,
                  fontSize: 10,
                ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusChip(BuildContext context) {
    final (color, icon, label) = _getStatusInfo(context);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: color.withValues(alpha: 0.3), width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: color),
          const SizedBox(width: 6),
          Text(
            label,
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

  (Color, IconData, String) _getStatusInfo(BuildContext context) {
    switch (request.status) {
      case JellyseerrRequestStatus.pendingApproval:
        return (Colors.orange, Icons.pending_rounded, 'PENDING');
      case JellyseerrRequestStatus.approved:
        return (Colors.green, Icons.check_circle_rounded, 'APPROVED');
      case JellyseerrRequestStatus.declined:
        return (Colors.red, Icons.cancel_rounded, 'DECLINED');
    }
  }

  Widget _buildActionButtons(BuildContext context, WidgetRef ref) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Approve
        Container(
          decoration: BoxDecoration(
            color: Colors.green.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Colors.green.withValues(alpha: 0.3), width: 1),
          ),
          child: IconButton(
            onPressed: () => _onApprove(context, ref),
            icon: const Icon(Icons.check_rounded, size: 20),
            style: IconButton.styleFrom(
              foregroundColor: Colors.green,
              padding: const EdgeInsets.all(8),
            ),
            tooltip: 'Approve',
            constraints: const BoxConstraints(minWidth: 40, minHeight: 40),
          ),
        ),
        const SizedBox(width: 8),
        // Decline
        Container(
          decoration: BoxDecoration(
            color: Colors.red.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Colors.red.withValues(alpha: 0.3), width: 1),
          ),
          child: IconButton(
            onPressed: () => _onDecline(context, ref),
            icon: const Icon(Icons.close_rounded, size: 20),
            style: IconButton.styleFrom(
              foregroundColor: Colors.red,
              padding: const EdgeInsets.all(8),
            ),
            tooltip: 'Decline',
            constraints: const BoxConstraints(minWidth: 40, minHeight: 40),
          ),
        ),
      ],
    );
  }

  void _onApprove(BuildContext context, WidgetRef ref) async {
    final success = await ref.read(requestActionsProvider.notifier).approve(request.id);
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(success ? 'Request approved' : 'Failed to approve request'),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
      );
    }
  }

  void _onDecline(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Decline Request'),
        content: Text('Are you sure you want to decline request #${request.id}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(ctx);
              final success = await ref.read(requestActionsProvider.notifier).decline(request.id);
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(success ? 'Request declined' : 'Failed to decline request'),
                    behavior: SnackBarBehavior.floating,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                );
              }
            },
            child: const Text('Decline'),
          ),
        ],
      ),
    );
  }
}
