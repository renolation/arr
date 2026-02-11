import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../main.dart';
import '../../../../core/widgets/loading_indicator.dart';
import '../../../../core/widgets/error_widget.dart';
import '../../domain/entities/media_item.dart';
import '../providers/media_provider.dart';
import '../widgets/media_grid.dart';

/// Library page - Matching library.html design
class LibraryPage extends ConsumerStatefulWidget {
  const LibraryPage({super.key});

  @override
  ConsumerState<LibraryPage> createState() => _LibraryPageState();
}

class _LibraryPageState extends ConsumerState<LibraryPage> {
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final mediaType = ref.watch(mediaTypeFilterProvider);
    final libraryAsync = ref.watch(libraryProvider);

    return Scaffold(
      body: CustomScrollView(
        controller: _scrollController,
        slivers: [
          // Search header
          SliverAppBar(
            pinned: true,
            elevation: 0,
            backgroundColor: Theme.of(context).brightness == Brightness.dark
                ? AppColors.backgroundDark.withOpacity(0.95)
                : AppColors.backgroundLight.withOpacity(0.95),
            title: Container(
              height: 42,
              decoration: BoxDecoration(
                color: Theme.of(context).brightness == Brightness.dark
                    ? AppColors.surfaceDark
                    : AppColors.backgroundLight,
                borderRadius: BorderRadius.circular(8),
              ),
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Search collection...',
                  hintStyle: TextStyle(
                    color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5),
                    fontSize: 14,
                  ),
                  prefixIcon: Icon(
                    Icons.search,
                    size: 20,
                    color: Theme.of(context).colorScheme.onSurface.withOpacity(0.4),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                ),
              ),
            ),
          ),
          // Filter chips
          SliverToBoxAdapter(
            child: Container(
              padding: const EdgeInsets.fromLTRB(24, 16, 24, 16),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: Theme.of(context).colorScheme.outline.withOpacity(0.3),
                  ),
                ),
              ),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    _FilterChip(
                      label: 'All',
                      isSelected: true,
                      onTap: () {},
                    ),
                    const SizedBox(width: 8),
                    _FilterChip(
                      label: 'Movies',
                      isSelected: false,
                      onTap: () {
                        ref.read(mediaTypeFilterProvider.notifier).state = MediaType.movie;
                      },
                    ),
                    const SizedBox(width: 8),
                    _FilterChip(
                      label: 'TV Shows',
                      isSelected: false,
                      onTap: () {
                        ref.read(mediaTypeFilterProvider.notifier).state = MediaType.series;
                      },
                    ),
                    const SizedBox(width: 8),
                    _FilterChip(
                      label: 'Missing',
                      icon: true,
                      isSelected: false,
                      onTap: () {},
                    ),
                    const SizedBox(width: 8),
                    _FilterChip(
                      label: 'Monitored',
                      isSelected: false,
                      onTap: () {},
                    ),
                  ],
                ),
              ),
            ),
          ),
          // Content
          SliverPadding(
            padding: const EdgeInsets.all(16),
            sliver: libraryAsync.when(
              data: (mediaItems) {
                if (mediaItems.isEmpty) {
                  return SliverToBoxAdapter(
                    child: _buildEmptyState(context, mediaType),
                  );
                }
                return SliverToBoxAdapter(
                  child: MediaGrid(mediaItems: mediaItems),
                );
              },
              loading: () => const SliverToBoxAdapter(
                child: SizedBox(
                  height: 300,
                  child: Center(child: LoadingIndicator()),
                ),
              ),
              error: (error, stack) => SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: AppErrorWidget(
                    message: error.toString(),
                    onRetry: () => ref.refresh(libraryProvider),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context, MediaType mediaType) {
    final isSeries = mediaType == MediaType.series;
    return SizedBox(
      height: 500,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            isSeries ? Icons.tv_outlined : Icons.movie_outlined,
            size: 64,
            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.3),
          ),
          const SizedBox(height: 16),
          Text(
            'No media found',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
        ],
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final bool icon;
  final VoidCallback onTap;

  const _FilterChip({
    required this.label,
    required this.isSelected,
    required this.onTap,
    this.icon = false,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(9999),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected
              ? (Theme.of(context).brightness == Brightness.dark
                  ? AppColors.backgroundDark
                  : AppColors.textPrimaryLight)
              : (Theme.of(context).brightness == Brightness.dark
                  ? AppColors.surfaceDark
                  : AppColors.backgroundLight),
          borderRadius: BorderRadius.circular(9999),
          border: Border.all(
            color: isSelected
                ? Colors.transparent
                : (Theme.of(context).brightness == Brightness.dark
                    ? AppColors.borderDark
                    : AppColors.borderLight),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon) ...[
              Container(
                width: 6,
                height: 6,
                decoration: const BoxDecoration(
                  color: AppColors.accentRed,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 6),
            ],
            Text(
              label.toUpperCase(),
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.bold,
                letterSpacing: 0.5,
                color: isSelected
                    ? (Theme.of(context).brightness == Brightness.dark
                        ? AppColors.backgroundDark
                        : AppColors.backgroundLight)
                    : Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Search delegate - Keeping for now but simplified
class MediaSearchDelegate extends SearchDelegate<String> {
  final WidgetRef ref;

  MediaSearchDelegate({required this.ref});

  @override
  String get searchFieldLabel => 'Search TV series or movies';

  @override
  ThemeData appBarTheme(BuildContext context) {
    return Theme.of(context);
  }

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      if (query.isNotEmpty)
        IconButton(
          icon: const Icon(Icons.clear),
          onPressed: () {
            query = '';
            ref.read(searchQueryProvider.notifier).state = '';
          },
        ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () => close(context, ''),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    ref.read(searchQueryProvider.notifier).state = query;
    final resultsAsync = ref.watch(searchResultsProvider);

    return resultsAsync.when(
      data: (mediaItems) {
        if (mediaItems.isEmpty) return _buildNoResults(context);
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: MediaGrid(mediaItems: mediaItems),
        );
      },
      loading: () => const Center(child: LoadingIndicator()),
      error: (error, stack) => Center(
        child: ServerErrorWidget(onRetry: () => ref.refresh(searchResultsProvider)),
      ),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    if (query.isEmpty) {
      return Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.search_outlined,
              size: 64,
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.3),
            ),
            const SizedBox(height: 16),
            Text(
              'Search Your Library',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
          ],
        ),
      );
    }
    return buildResults(context);
  }

  Widget _buildNoResults(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.search_off_outlined,
            size: 64,
            color: AppColors.accentRed.withOpacity(0.5),
          ),
          const SizedBox(height: 16),
          Text(
            'No Results Found',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
        ],
      ),
    );
  }
}
