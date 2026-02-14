import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../main.dart';
import '../../domain/entities/media_item.dart';
import '../providers/media_provider.dart';

class FilterBottomSheet extends ConsumerStatefulWidget {
  const FilterBottomSheet({super.key});

  @override
  ConsumerState<FilterBottomSheet> createState() => _FilterBottomSheetState();
}

class _FilterBottomSheetState extends ConsumerState<FilterBottomSheet> {
  late Set<MediaType> _mediaTypes;
  late Set<MediaStatus> _statuses;
  late Set<String> _serviceTypes;

  @override
  void initState() {
    super.initState();
    final current = ref.read(libraryFilterProvider);
    _mediaTypes = Set.from(current.mediaTypes);
    _statuses = Set.from(current.statuses);
    _serviceTypes = Set.from(current.serviceTypes);
  }

  bool get _hasChanges =>
      _mediaTypes.isNotEmpty || _statuses.isNotEmpty || _serviceTypes.isNotEmpty;

  void _reset() {
    setState(() {
      _mediaTypes.clear();
      _statuses.clear();
      _serviceTypes.clear();
    });
  }

  void _apply() {
    ref.read(libraryFilterProvider.notifier).filter = LibraryFilter(
      mediaTypes: _mediaTypes,
      statuses: _statuses,
      serviceTypes: _serviceTypes,
    );
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Handle bar
          Center(
            child: Container(
              margin: const EdgeInsets.only(top: 12),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: isDark ? AppColors.borderDark : AppColors.borderLight,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          // Header
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 20, 24, 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'FILTER',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1,
                    color: isDark
                        ? AppColors.textPrimaryDark
                        : AppColors.textPrimaryLight,
                  ),
                ),
                if (_hasChanges)
                  GestureDetector(
                    onTap: _reset,
                    child: Text(
                      'RESET',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.5,
                        color: AppColors.primary,
                      ),
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          // Media Type section
          _buildSection(
            context,
            title: 'MEDIA TYPE',
            children: [
              _buildChip(
                context,
                label: 'Movie',
                selected: _mediaTypes.contains(MediaType.movie),
                onTap: () => setState(() {
                  _mediaTypes.contains(MediaType.movie)
                      ? _mediaTypes.remove(MediaType.movie)
                      : _mediaTypes.add(MediaType.movie);
                }),
              ),
              _buildChip(
                context,
                label: 'TV Show',
                selected: _mediaTypes.contains(MediaType.series),
                onTap: () => setState(() {
                  _mediaTypes.contains(MediaType.series)
                      ? _mediaTypes.remove(MediaType.series)
                      : _mediaTypes.add(MediaType.series);
                }),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Status section
          _buildSection(
            context,
            title: 'STATUS',
            children: [
              _buildChip(
                context,
                label: 'Upcoming',
                selected: _statuses.contains(MediaStatus.continuing),
                onTap: () => setState(() {
                  _statuses.contains(MediaStatus.continuing)
                      ? _statuses.remove(MediaStatus.continuing)
                      : _statuses.add(MediaStatus.continuing);
                }),
              ),
              _buildChip(
                context,
                label: 'Complete',
                selected: _statuses.contains(MediaStatus.downloaded),
                onTap: () => setState(() {
                  _statuses.contains(MediaStatus.downloaded)
                      ? _statuses.remove(MediaStatus.downloaded)
                      : _statuses.add(MediaStatus.downloaded);
                }),
              ),
              _buildChip(
                context,
                label: 'Downloading',
                selected: _statuses.contains(MediaStatus.downloading),
                onTap: () => setState(() {
                  _statuses.contains(MediaStatus.downloading)
                      ? _statuses.remove(MediaStatus.downloading)
                      : _statuses.add(MediaStatus.downloading);
                }),
              ),
              _buildChip(
                context,
                label: 'Missing',
                selected: _statuses.contains(MediaStatus.missing),
                onTap: () => setState(() {
                  _statuses.contains(MediaStatus.missing)
                      ? _statuses.remove(MediaStatus.missing)
                      : _statuses.add(MediaStatus.missing);
                }),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Service section
          _buildSection(
            context,
            title: 'SERVICE',
            children: [
              _buildChip(
                context,
                label: 'Radarr',
                selected: _serviceTypes.contains('radarr'),
                onTap: () => setState(() {
                  _serviceTypes.contains('radarr')
                      ? _serviceTypes.remove('radarr')
                      : _serviceTypes.add('radarr');
                }),
              ),
              _buildChip(
                context,
                label: 'Sonarr',
                selected: _serviceTypes.contains('sonarr'),
                onTap: () => setState(() {
                  _serviceTypes.contains('sonarr')
                      ? _serviceTypes.remove('sonarr')
                      : _serviceTypes.add('sonarr');
                }),
              ),
            ],
          ),
          const SizedBox(height: 24),
          // Apply button
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _apply,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  'APPLY',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSection(
    BuildContext context, {
    required String title,
    required List<Widget> children,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.bold,
              letterSpacing: 1,
              color: isDark
                  ? AppColors.textSecondaryDark
                  : AppColors.textSecondaryLight,
            ),
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: children,
          ),
        ],
      ),
    );
  }

  Widget _buildChip(
    BuildContext context, {
    required String label,
    required bool selected,
    required VoidCallback onTap,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: selected
              ? AppColors.primary.withOpacity(0.15)
              : (isDark ? AppColors.cardDark : AppColors.backgroundLight),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: selected
                ? AppColors.primary
                : (isDark ? AppColors.borderDark : AppColors.borderLight),
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: selected
                ? AppColors.primary
                : (isDark
                    ? AppColors.textPrimaryDark
                    : AppColors.textPrimaryLight),
          ),
        ),
      ),
    );
  }
}
