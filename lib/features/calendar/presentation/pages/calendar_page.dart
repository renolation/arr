import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../../main.dart';
import '../../domain/entities/calendar_item.dart';
import '../providers/calendar_provider.dart';

enum _ViewMode { week, month }

enum _ServiceFilter { all, tv, movies }

class CalendarPage extends ConsumerStatefulWidget {
  const CalendarPage({super.key});

  @override
  ConsumerState<CalendarPage> createState() => _CalendarPageState();
}

class _CalendarPageState extends ConsumerState<CalendarPage> {
  _ViewMode _viewMode = _ViewMode.week;
  _ServiceFilter _filter = _ServiceFilter.all;
  late DateTime _selectedDate;
  late DateTime _weekStart;
  late DateTime _monthDate; // first day of displayed month

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    _selectedDate = DateTime(now.year, now.month, now.day);
    _weekStart = _selectedDate.subtract(Duration(days: _selectedDate.weekday - 1));
    _monthDate = DateTime(now.year, now.month, 1);
  }

  DateTime get _rangeStart {
    if (_viewMode == _ViewMode.week) {
      return _weekStart.subtract(const Duration(days: 1));
    }
    // For month view, include surrounding days
    final firstDayOfMonth = _monthDate;
    final startOffset = firstDayOfMonth.weekday - 1;
    return firstDayOfMonth.subtract(Duration(days: startOffset + 1));
  }

  DateTime get _rangeEnd {
    if (_viewMode == _ViewMode.week) {
      return _weekStart.add(const Duration(days: 8));
    }
    final lastDayOfMonth = DateTime(_monthDate.year, _monthDate.month + 1, 0);
    final endOffset = 7 - lastDayOfMonth.weekday;
    return lastDayOfMonth.add(Duration(days: endOffset + 1));
  }

  List<CalendarItem> _applyFilter(List<CalendarItem> items) {
    switch (_filter) {
      case _ServiceFilter.all:
        return items;
      case _ServiceFilter.tv:
        return items.where((i) => !i.isMovie).toList();
      case _ServiceFilter.movies:
        return items.where((i) => i.isMovie).toList();
    }
  }

  List<CalendarItem> _itemsForDate(List<CalendarItem> items, DateTime date) {
    return items.where((i) {
      final d = DateTime(i.date.year, i.date.month, i.date.day);
      return d.year == date.year && d.month == date.month && d.day == date.day;
    }).toList();
  }

  void _navigateWeek(int direction) {
    setState(() {
      _weekStart = _weekStart.add(Duration(days: 7 * direction));
      _selectedDate = _weekStart;
    });
  }

  void _navigateMonth(int direction) {
    setState(() {
      _monthDate = DateTime(_monthDate.year, _monthDate.month + direction, 1);
    });
  }

  @override
  Widget build(BuildContext context) {
    final calendarAsync = ref.watch(
      calendarProvider((start: _rangeStart, end: _rangeEnd)),
    );

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: true,
            elevation: 0,
            title: const Text('Calendar'),
            actions: [
              // View mode toggle
              IconButton(
                onPressed: () {
                  setState(() {
                    _viewMode = _viewMode == _ViewMode.week
                        ? _ViewMode.month
                        : _ViewMode.week;
                  });
                },
                icon: Icon(
                  _viewMode == _ViewMode.week
                      ? Icons.calendar_month_outlined
                      : Icons.view_week_outlined,
                  size: 22,
                ),
                tooltip: _viewMode == _ViewMode.week ? 'Month view' : 'Week view',
              ),
            ],
          ),
          // Filter chips
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 12),
              child: Row(
                children: [
                  _buildFilterChip('All', _filter == _ServiceFilter.all,
                      () => setState(() => _filter = _ServiceFilter.all)),
                  const SizedBox(width: 8),
                  _buildFilterChip('TV Shows', _filter == _ServiceFilter.tv,
                      () => setState(() => _filter = _ServiceFilter.tv)),
                  const SizedBox(width: 8),
                  _buildFilterChip('Movies', _filter == _ServiceFilter.movies,
                      () => setState(() => _filter = _ServiceFilter.movies)),
                ],
              ),
            ),
          ),
          // Calendar view
          calendarAsync.when(
            data: (allItems) {
              final items = _applyFilter(allItems);
              if (_viewMode == _ViewMode.week) {
                return _buildWeekView(context, items);
              } else {
                return _buildMonthView(context, items);
              }
            },
            loading: () => const SliverFillRemaining(
              child: Center(
                child: SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
              ),
            ),
            error: (_, __) => SliverFillRemaining(
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.calendar_today_outlined, size: 48,
                        color: Theme.of(context).colorScheme.onSurface.withOpacity(0.2)),
                    const SizedBox(height: 12),
                    Text(
                      'Could not load calendar',
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onSurface.withOpacity(0.4),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String label, bool selected, VoidCallback onTap) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
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
                : (isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight),
          ),
        ),
      ),
    );
  }

  // ─── Week View ───

  SliverList _buildWeekView(BuildContext context, List<CalendarItem> items) {
    final days = List.generate(7, (i) => _weekStart.add(Duration(days: i)));
    final selectedItems = _itemsForDate(items, _selectedDate);

    return SliverList(
      delegate: SliverChildListDelegate([
        // Week navigation
        _buildWeekNav(context),
        // Day chips
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
          child: Row(
            children: days.map((day) {
              final isSelected = day.year == _selectedDate.year &&
                  day.month == _selectedDate.month &&
                  day.day == _selectedDate.day;
              final isToday = _isToday(day);
              final hasItems = _itemsForDate(items, day).isNotEmpty;
              return Expanded(
                child: _DayChip(
                  date: day,
                  isSelected: isSelected,
                  isToday: isToday,
                  hasItems: hasItems,
                  onTap: () => setState(() => _selectedDate = day),
                ),
              );
            }).toList(),
          ),
        ),
        // Items list
        if (selectedItems.isEmpty)
          _buildEmptyDay(context)
        else
          ...selectedItems.map((item) => _CalendarListItem(item: item)),
        const SizedBox(height: 24),
      ]),
    );
  }

  Widget _buildWeekNav(BuildContext context) {
    final weekEnd = _weekStart.add(const Duration(days: 6));
    final months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
        'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];

    String label;
    if (_weekStart.month == weekEnd.month) {
      label = '${months[_weekStart.month - 1]} ${_weekStart.day} - ${weekEnd.day}, ${_weekStart.year}';
    } else {
      label = '${months[_weekStart.month - 1]} ${_weekStart.day} - ${months[weekEnd.month - 1]} ${weekEnd.day}';
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            onPressed: () => _navigateWeek(-1),
            icon: const Icon(Icons.chevron_left, size: 22),
          ),
          Text(
            label,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
          IconButton(
            onPressed: () => _navigateWeek(1),
            icon: const Icon(Icons.chevron_right, size: 22),
          ),
        ],
      ),
    );
  }

  // ─── Month View ───

  SliverList _buildMonthView(BuildContext context, List<CalendarItem> items) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final firstDay = _monthDate;
    final daysInMonth = DateTime(firstDay.year, firstDay.month + 1, 0).day;
    final startWeekday = firstDay.weekday; // 1=Mon
    final selectedItems = _itemsForDate(items, _selectedDate);

    final months = ['January', 'February', 'March', 'April', 'May', 'June',
        'July', 'August', 'September', 'October', 'November', 'December'];

    return SliverList(
      delegate: SliverChildListDelegate([
        // Month navigation
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                onPressed: () => _navigateMonth(-1),
                icon: const Icon(Icons.chevron_left, size: 22),
              ),
              Text(
                '${months[_monthDate.month - 1]} ${_monthDate.year}',
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
              IconButton(
                onPressed: () => _navigateMonth(1),
                icon: const Icon(Icons.chevron_right, size: 22),
              ),
            ],
          ),
        ),
        // Day-of-week headers
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            children: ['M', 'T', 'W', 'T', 'F', 'S', 'S']
                .map((d) => Expanded(
                      child: Center(
                        child: Text(
                          d,
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: isDark
                                ? AppColors.textSecondaryDark
                                : AppColors.textSecondaryLight,
                          ),
                        ),
                      ),
                    ))
                .toList(),
          ),
        ),
        const SizedBox(height: 8),
        // Month grid
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: _buildMonthGrid(
            context,
            items: items,
            daysInMonth: daysInMonth,
            startWeekday: startWeekday,
          ),
        ),
        const SizedBox(height: 16),
        // Selected day items
        if (selectedItems.isEmpty)
          _buildEmptyDay(context)
        else
          ...selectedItems.map((item) => _CalendarListItem(item: item)),
        const SizedBox(height: 24),
      ]),
    );
  }

  Widget _buildMonthGrid(
    BuildContext context, {
    required List<CalendarItem> items,
    required int daysInMonth,
    required int startWeekday,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final totalCells = ((startWeekday - 1) + daysInMonth + 6) ~/ 7 * 7;
    final rows = totalCells ~/ 7;

    return Column(
      children: List.generate(rows, (row) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 4),
          child: Row(
            children: List.generate(7, (col) {
              final cellIndex = row * 7 + col;
              final dayNum = cellIndex - (startWeekday - 1) + 1;

              if (dayNum < 1 || dayNum > daysInMonth) {
                return const Expanded(child: SizedBox(height: 40));
              }

              final date = DateTime(_monthDate.year, _monthDate.month, dayNum);
              final isSelected = date.year == _selectedDate.year &&
                  date.month == _selectedDate.month &&
                  date.day == _selectedDate.day;
              final isToday = _isToday(date);
              final dayItems = _itemsForDate(items, date);
              final hasItems = dayItems.isNotEmpty;
              final hasDownloaded = dayItems.any((i) => i.hasFile);

              return Expanded(
                child: GestureDetector(
                  onTap: () => setState(() => _selectedDate = date),
                  child: Container(
                    height: 40,
                    decoration: BoxDecoration(
                      color: isSelected
                          ? AppColors.primary.withOpacity(0.15)
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(8),
                      border: isToday && !isSelected
                          ? Border.all(color: AppColors.primary, width: 1)
                          : null,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          '$dayNum',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: isSelected || isToday
                                ? FontWeight.bold
                                : FontWeight.normal,
                            color: isSelected
                                ? AppColors.primary
                                : (isDark
                                    ? AppColors.textPrimaryDark
                                    : AppColors.textPrimaryLight),
                          ),
                        ),
                        if (hasItems)
                          Container(
                            margin: const EdgeInsets.only(top: 2),
                            width: 5,
                            height: 5,
                            decoration: BoxDecoration(
                              color: hasDownloaded
                                  ? AppColors.accentGreen
                                  : AppColors.primary,
                              shape: BoxShape.circle,
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              );
            }),
          ),
        );
      }),
    );
  }

  // ─── Shared Helpers ───

  Widget _buildEmptyDay(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(32),
      child: Center(
        child: Column(
          children: [
            Icon(
              Icons.event_available_outlined,
              size: 40,
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.15),
            ),
            const SizedBox(height: 8),
            Text(
              'Nothing scheduled',
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

  bool _isToday(DateTime date) {
    final now = DateTime.now();
    return date.year == now.year && date.month == now.month && date.day == now.day;
  }
}

// ─── Day Chip (Week View) ───

class _DayChip extends StatelessWidget {
  final DateTime date;
  final bool isSelected;
  final bool isToday;
  final bool hasItems;
  final VoidCallback onTap;

  const _DayChip({
    required this.date,
    required this.isSelected,
    required this.isToday,
    required this.hasItems,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final weekdays = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 2),
        padding: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primary.withOpacity(0.15)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(10),
          border: isToday && !isSelected
              ? Border.all(color: AppColors.primary, width: 1)
              : null,
        ),
        child: Column(
          children: [
            Text(
              weekdays[date.weekday - 1],
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w500,
                color: isSelected
                    ? AppColors.primary
                    : (isDark
                        ? AppColors.textSecondaryDark
                        : AppColors.textSecondaryLight),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              '${date.day}',
              style: TextStyle(
                fontSize: 16,
                fontWeight: isSelected || isToday ? FontWeight.bold : FontWeight.w500,
                color: isSelected
                    ? AppColors.primary
                    : (isDark
                        ? AppColors.textPrimaryDark
                        : AppColors.textPrimaryLight),
              ),
            ),
            const SizedBox(height: 4),
            Container(
              width: 5,
              height: 5,
              decoration: BoxDecoration(
                color: hasItems ? AppColors.primary : Colors.transparent,
                shape: BoxShape.circle,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Calendar List Item ───

class _CalendarListItem extends StatelessWidget {
  final CalendarItem item;

  const _CalendarListItem({required this.item});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isDark ? AppColors.cardDark : Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: isDark ? AppColors.borderDark : AppColors.borderLight,
          ),
        ),
        child: Row(
          children: [
            // Poster thumbnail
            Container(
              width: 44,
              height: 64,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(6),
                border: Border.all(
                  color: Theme.of(context).colorScheme.outline.withOpacity(0.15),
                ),
              ),
              clipBehavior: Clip.antiAlias,
              child: item.posterUrl != null
                  ? CachedNetworkImage(
                      imageUrl: item.posterUrl!,
                      fit: BoxFit.cover,
                      memCacheWidth: 100,
                      fadeInDuration: Duration.zero,
                      fadeOutDuration: Duration.zero,
                      errorWidget: (_, __, ___) => _posterPlaceholder(context),
                    )
                  : _posterPlaceholder(context),
            ),
            const SizedBox(width: 12),
            // Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.title,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 3),
                  Text(
                    item.subtitle,
                    style: TextStyle(
                      fontSize: 12,
                      color: isDark
                          ? AppColors.textSecondaryDark
                          : AppColors.textSecondaryLight,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            // Status
            if (item.hasFile)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.accentGreen.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: const Text(
                  'DOWNLOADED',
                  style: TextStyle(
                    fontSize: 9,
                    fontWeight: FontWeight.bold,
                    color: AppColors.accentGreen,
                  ),
                ),
              )
            else
              Icon(
                item.isMovie ? Icons.movie_outlined : Icons.tv_outlined,
                size: 18,
                color: isDark
                    ? AppColors.textSecondaryDark
                    : AppColors.textSecondaryLight,
              ),
          ],
        ),
      ),
    );
  }

  Widget _posterPlaceholder(BuildContext context) {
    return Container(
      color: Theme.of(context).colorScheme.surface,
      child: Center(
        child: Icon(
          item.isMovie ? Icons.movie_outlined : Icons.tv_outlined,
          size: 18,
          color: Theme.of(context).colorScheme.onSurface.withOpacity(0.15),
        ),
      ),
    );
  }
}
