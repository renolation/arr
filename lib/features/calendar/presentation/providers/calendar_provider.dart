import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/network/api_providers.dart';
import '../../domain/entities/calendar_item.dart';

/// Fetches calendar from all configured Sonarr + Radarr services
/// Uses a configurable date range (default: yesterday to 30 days ahead)
final calendarProvider = FutureProvider.family<List<CalendarItem>, ({DateTime start, DateTime end})>(
  (ref, range) async {
    final sonarrApis = await ref.watch(allSonarrApisProvider.future);
    final radarrApis = await ref.watch(allRadarrApisProvider.future);

    final items = <CalendarItem>[];

    for (final (_, api) in sonarrApis) {
      try {
        final data = await api.getCalendar(start: range.start, end: range.end);
        for (final ep in data) {
          items.add(CalendarItem.fromSonarr(ep));
        }
      } catch (_) {}
    }

    for (final (_, api) in radarrApis) {
      try {
        final data = await api.getCalendar(start: range.start, end: range.end);
        for (final movie in data) {
          items.add(CalendarItem.fromRadarr(movie));
        }
      } catch (_) {}
    }

    items.sort((a, b) => a.date.compareTo(b.date));
    return items;
  },
);

/// Default calendar provider for overview (30-day window)
final defaultCalendarProvider = FutureProvider<List<CalendarItem>>((ref) async {
  final now = DateTime.now();
  final start = now.subtract(const Duration(days: 1));
  final end = now.add(const Duration(days: 30));
  return ref.watch(calendarProvider((start: start, end: end)).future);
});
