import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/network/models/jellyseerr_models.dart';
import '../../../../core/utils/formatters.dart';
import '../../../../main.dart';
import '../providers/requests_provider.dart';

/// Card widget for displaying and approving requests - 1/3 poster + 2/3 content
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
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Card(
      elevation: 0,
      margin: const EdgeInsets.only(bottom: 12),
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(4),
        side: BorderSide(
          color: isDark ? AppColors.borderDark : AppColors.borderLight,
          width: 1,
        ),
      ),
      child: IntrinsicHeight(
        child: Row(
          children: [
            // Left 1/3 - Poster (full bleed)
            SizedBox(
              width: 100,
              child: _buildPoster(context),
            ),
            // Right 2/3 - Content
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title
                    Text(
                      'Request #${request.id}',
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    // Year / genre placeholder
                    Text(
                      request.mediaType == 'tv' ? 'TV Show' : 'Movie',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Theme.of(context)
                                .colorScheme
                                .onSurface
                                .withOpacity(0.6),
                          ),
                    ),
                    const SizedBox(height: 8),
                    // Requester with avatar
                    if (request.requestedBy?.displayName != null)
                      Row(
                        children: [
                          _buildUserAvatar(context),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              request.requestedBy!.displayName!,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall
                                  ?.copyWith(
                                    fontWeight: FontWeight.w500,
                                  ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    if (request.createdAt != null) ...[
                      const SizedBox(height: 4),
                      Text(
                        Formatters.getRelativeTime(request.createdAt!),
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: Theme.of(context)
                                  .colorScheme
                                  .onSurface
                                  .withOpacity(0.5),
                              fontSize: 11,
                            ),
                      ),
                    ],
                    const Spacer(),
                    // Action buttons
                    if (request.isPending && !isLoading)
                      Row(
                        children: [
                          Expanded(
                            child: SizedBox(
                              height: 32,
                              child: ElevatedButton(
                                onPressed: () => _onApprove(context, ref),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.primary,
                                  foregroundColor: Colors.white,
                                  elevation: 0,
                                  padding: EdgeInsets.zero,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                ),
                                child: const Text(
                                  'Approve',
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: SizedBox(
                              height: 32,
                              child: OutlinedButton(
                                onPressed: () => _onDecline(context, ref),
                                style: OutlinedButton.styleFrom(
                                  foregroundColor: Theme.of(context)
                                      .colorScheme
                                      .onSurface
                                      .withOpacity(0.7),
                                  padding: EdgeInsets.zero,
                                  side: BorderSide(
                                    color: isDark
                                        ? AppColors.borderDark
                                        : AppColors.borderLight,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                ),
                                child: const Text(
                                  'Deny',
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    if (isLoading)
                      const Center(
                        child: SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPoster(BuildContext context) {
    return Container(
      color: Theme.of(context).brightness == Brightness.dark
          ? AppColors.surfaceDark
          : AppColors.surfaceLight,
      child: Center(
        child: Icon(
          request.mediaType == 'tv' ? Icons.tv_outlined : Icons.movie_outlined,
          size: 36,
          color:
              Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.3),
        ),
      ),
    );
  }

  Widget _buildUserAvatar(BuildContext context) {
    final name = request.requestedBy?.displayName ?? '?';
    final initial = name.isNotEmpty ? name[0].toUpperCase() : '?';
    // Generate a color based on the name
    final colorIndex = name.codeUnits.fold<int>(0, (a, b) => a + b) % 5;
    final colors = [
      AppColors.primary,
      AppColors.accentGreen,
      AppColors.accentYellow,
      AppColors.accentRed,
      const Color(0xFF8B5CF6),
    ];

    return Container(
      width: 24,
      height: 24,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            colors[colorIndex],
            colors[colorIndex].withOpacity(0.7),
          ],
        ),
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Text(
          initial,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 11,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  void _onApprove(BuildContext context, WidgetRef ref) async {
    final success =
        await ref.read(requestActionsProvider.notifier).approve(request.id);
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content:
              Text(success ? 'Request approved' : 'Failed to approve request'),
          behavior: SnackBarBehavior.floating,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
      );
    }
  }

  void _onDecline(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        title: const Text('Decline Request'),
        content:
            Text('Are you sure you want to decline request #${request.id}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(ctx);
              final success = await ref
                  .read(requestActionsProvider.notifier)
                  .decline(request.id);
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(success
                        ? 'Request declined'
                        : 'Failed to decline request'),
                    behavior: SnackBarBehavior.floating,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
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
