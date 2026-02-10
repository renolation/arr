import 'package:flutter/material.dart';

/// Empty state widget for when there's no data to display
class EmptyState extends StatelessWidget {
  final String message;
  final String? actionLabel;
  final VoidCallback? onAction;
  final IconData? icon;

  const EmptyState({
    super.key,
    required this.message,
    this.actionLabel,
    this.onAction,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon ?? Icons.inbox_outlined,
              size: 64,
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.3),
            ),
            const SizedBox(height: 16),
            Text(
              'Nothing Here',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                  ),
            ),
            const SizedBox(height: 8),
            Text(
              message,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5),
                  ),
              textAlign: TextAlign.center,
            ),
            if (actionLabel != null && onAction != null) ...[
              const SizedBox(height: 24),
              OutlinedButton.icon(
                onPressed: onAction,
                icon: const Icon(Icons.add),
                label: Text(actionLabel!),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// Empty state for search results
class SearchEmptyState extends StatelessWidget {
  final String query;

  const SearchEmptyState({
    super.key,
    required this.query,
  });

  @override
  Widget build(BuildContext context) {
    return EmptyState(
      icon: Icons.search_off,
      message: 'No results found for "$query"',
    );
  }
}

/// Empty state for library/media
class LibraryEmptyState extends StatelessWidget {
  final VoidCallback onAdd;

  const LibraryEmptyState({
    super.key,
    required this.onAdd,
  });

  @override
  Widget build(BuildContext context) {
    return EmptyState(
      icon: Icons.movie_outlined,
      message: 'Your library is empty. Start by adding some content.',
      actionLabel: 'Add Content',
      onAction: onAdd,
    );
  }
}

/// Empty state for activity/queue
class QueueEmptyState extends StatelessWidget {
  const QueueEmptyState({super.key});

  @override
  Widget build(BuildContext context) {
    return const EmptyState(
      icon: Icons.download_done_outlined,
      message: 'No active downloads. All caught up!',
    );
  }
}
