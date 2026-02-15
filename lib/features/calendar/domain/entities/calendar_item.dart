/// Shared model for calendar items from both Sonarr and Radarr
class CalendarItem {
  final int id;
  final String title;
  final String subtitle;
  final String? posterUrl;
  final DateTime date;
  final bool hasFile;
  final bool isMovie;
  final String? serviceKey;

  const CalendarItem({
    required this.id,
    required this.title,
    required this.subtitle,
    this.posterUrl,
    required this.date,
    this.hasFile = false,
    this.isMovie = false,
    this.serviceKey,
  });

  factory CalendarItem.fromSonarr(Map<String, dynamic> ep) {
    final series = ep['series'] as Map<String, dynamic>?;
    final seriesTitle = series?['title'] as String? ?? ep['title'] as String? ?? '';
    final seasonNum = ep['seasonNumber'] as int? ?? 0;
    final episodeNum = ep['episodeNumber'] as int? ?? 0;
    final episodeTitle = ep['title'] as String? ?? '';

    String? posterUrl;
    final images = series?['images'] as List?;
    if (images != null) {
      for (final img in images) {
        if (img is Map && img['coverType'] == 'poster') {
          posterUrl = img['remoteUrl'] as String? ?? img['url'] as String?;
          break;
        }
      }
    }

    final airDateStr = ep['airDateUtc'] as String? ?? ep['airDate'] as String? ?? '';
    final airDate = DateTime.tryParse(airDateStr) ?? DateTime.now();

    return CalendarItem(
      id: series?['id'] as int? ?? ep['seriesId'] as int? ?? 0,
      title: seriesTitle,
      subtitle: 'S${seasonNum.toString().padLeft(2, '0')}E${episodeNum.toString().padLeft(2, '0')} $episodeTitle',
      posterUrl: posterUrl,
      date: airDate,
      hasFile: ep['hasFile'] as bool? ?? false,
      isMovie: false,
    );
  }

  factory CalendarItem.fromRadarr(Map<String, dynamic> movie) {
    final title = movie['title'] as String? ?? '';
    final year = movie['year'] as int?;

    String? posterUrl;
    final images = movie['images'] as List?;
    if (images != null) {
      for (final img in images) {
        if (img is Map && img['coverType'] == 'poster') {
          posterUrl = img['remoteUrl'] as String? ?? img['url'] as String?;
          break;
        }
      }
    }

    final dateStr = movie['physicalRelease'] as String? ??
        movie['digitalRelease'] as String? ??
        movie['inCinemas'] as String? ??
        '';
    final date = DateTime.tryParse(dateStr) ?? DateTime.now();

    return CalendarItem(
      id: movie['id'] as int? ?? 0,
      title: title,
      subtitle: 'Movie${year != null ? ' \u2022 $year' : ''}',
      posterUrl: posterUrl,
      date: date,
      hasFile: movie['hasFile'] as bool? ?? false,
      isMovie: true,
    );
  }
}
