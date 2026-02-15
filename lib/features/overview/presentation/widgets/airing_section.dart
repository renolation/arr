import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../../main.dart';
import '../../../calendar/domain/entities/calendar_item.dart';
import '../../../calendar/presentation/providers/calendar_provider.dart';

/// Section displaying upcoming/airing shows and movies
class AiringSection extends ConsumerWidget {
  const AiringSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final calendarAsync = ref.watch(defaultCalendarProvider);

    return calendarAsync.when(
      data: (items) {
        if (items.isEmpty) {
          return _buildEmpty(context);
        }
        return SizedBox(
          height: 200,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: items.length,
            separatorBuilder: (_, __) => const SizedBox(width: 12),
            itemBuilder: (context, index) => _CalendarCard(item: items[index]),
          ),
        );
      },
      loading: () => const SizedBox(
        height: 200,
        child: Center(
          child: SizedBox(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(strokeWidth: 2),
          ),
        ),
      ),
      error: (_, __) => _buildEmpty(context),
    );
  }

  Widget _buildEmpty(BuildContext context) {
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
        child: Column(
          children: [
            Icon(Icons.calendar_today_outlined, size: 32,
                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.2)),
            const SizedBox(height: 8),
            Text(
              'Nothing coming up',
              style: TextStyle(
                fontSize: 13,
                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.4),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Calendar card for a single upcoming item
class _CalendarCard extends StatelessWidget {
  final CalendarItem item;

  const _CalendarCard({required this.item});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 120,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Poster with date badge
          Expanded(
            child: Stack(
              children: [
                Container(
                  width: 120,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: Theme.of(context).colorScheme.outline.withOpacity(0.2),
                    ),
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: item.posterUrl != null
                      ? CachedNetworkImage(
                          imageUrl: item.posterUrl!,
                          fit: BoxFit.cover,
                          fadeInDuration: Duration.zero,
                          fadeOutDuration: Duration.zero,
                          memCacheWidth: 200,
                          placeholder: (_, __) => Container(
                            color: Theme.of(context).colorScheme.surface,
                          ),
                          errorWidget: (_, __, ___) => _placeholder(context),
                        )
                      : _placeholder(context),
                ),
                // Date badge
                Positioned(
                  top: 6,
                  left: 6,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                    decoration: BoxDecoration(
                      color: _dateBadgeColor,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      _dateBadgeText,
                      style: const TextStyle(
                        fontSize: 9,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                // Has file indicator
                if (item.hasFile)
                  Positioned(
                    top: 6,
                    right: 6,
                    child: Container(
                      width: 18,
                      height: 18,
                      decoration: BoxDecoration(
                        color: AppColors.accentGreen,
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 1.5),
                      ),
                      child: const Icon(Icons.check, size: 10, color: Colors.white),
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          // Title
          Text(
            item.title,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              height: 1.2,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 2),
          // Subtitle
          Text(
            item.subtitle,
            style: TextStyle(
              fontSize: 11,
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5),
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _placeholder(BuildContext context) {
    return Container(
      color: Theme.of(context).colorScheme.surface,
      child: Center(
        child: Icon(
          item.isMovie ? Icons.movie_outlined : Icons.tv_outlined,
          size: 28,
          color: Theme.of(context).colorScheme.onSurface.withOpacity(0.15),
        ),
      ),
    );
  }

  String get _dateBadgeText {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final itemDay = DateTime(item.date.year, item.date.month, item.date.day);
    final diff = itemDay.difference(today).inDays;

    if (diff < 0) return 'AIRED';
    if (diff == 0) return 'TODAY';
    if (diff == 1) return 'TMRW';

    final weekdays = ['MON', 'TUE', 'WED', 'THU', 'FRI', 'SAT', 'SUN'];
    if (diff <= 6) return weekdays[item.date.weekday - 1];

    final months = ['JAN', 'FEB', 'MAR', 'APR', 'MAY', 'JUN',
        'JUL', 'AUG', 'SEP', 'OCT', 'NOV', 'DEC'];
    return '${months[item.date.month - 1]} ${item.date.day}';
  }

  Color get _dateBadgeColor {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final itemDay = DateTime(item.date.year, item.date.month, item.date.day);
    final diff = itemDay.difference(today).inDays;

    if (diff < 0) return Colors.grey;
    if (diff == 0) return AppColors.accentGreen;
    if (diff <= 2) return AppColors.primary;
    return Colors.blueGrey;
  }
}
