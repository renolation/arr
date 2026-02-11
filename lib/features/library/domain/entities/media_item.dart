import 'package:freezed_annotation/freezed_annotation.dart';

part 'media_item.freezed.dart';

enum MediaType { series, movie }

enum MediaStatus { continuing, ended, deleted, downloading, downloaded, missing }

@freezed
class MediaItem with _$MediaItem {
  const factory MediaItem({
    required int id,
    required String title,
    required MediaType type,
    required MediaStatus status,
    String? overview,
    String? posterUrl,
    String? backdropUrl,
    int? year,
    double? rating,
    String? quality,
    int? seasonCount,
    int? episodeCount,
    DateTime? airDate,
    bool? monitored,
    String? serviceKey,
    Map<String, dynamic>? metadata,
  }) = _MediaItem;

  factory MediaItem.fromJson(Map<String, dynamic> json, {String? serviceKey}) {
    // Determine type using definitive field presence:
    // Radarr (Movie): movieFile, studio, tmdbId (without tvdbId), inCinemas
    // Sonarr (TV Show): seasons, network, tvdbId, firstAired
    final isMovie = json.containsKey('movieFile') ||
        json.containsKey('studio') ||
        (json.containsKey('tmdbId') && !json.containsKey('tvdbId')) ||
        json.containsKey('inCinemas');
    final typeStr = json['type'] as String?;
    final type = typeStr == 'movie' || (typeStr == null && isMovie)
        ? MediaType.movie
        : typeStr == 'series' || (typeStr == null && !isMovie)
            ? MediaType.series
            : MediaType.movie;

    final statusStr = json['status'] as String? ?? 'continuing';
    final status = MediaStatus.values.firstWhere(
      (e) => e.name.toLowerCase() == statusStr.toLowerCase(),
      orElse: () => MediaStatus.continuing,
    );

    // Extract poster and fanart URLs from images array
    String? posterUrl;
    String? backdropUrl;
    if (json['images'] is List) {
      final images = json['images'] as List;
      for (final img in images) {
        if (img is Map) {
          final coverType = img['coverType'] as String?;
          if (coverType == 'poster') {
            posterUrl = (img['remoteUrl'] as String?) ?? (img['url'] as String?);
          } else if (coverType == 'fanart') {
            backdropUrl = (img['remoteUrl'] as String?) ?? (img['url'] as String?);
          }
        }
      }
    }
    posterUrl ??= json['posterUrl'] as String?;
    backdropUrl ??= json['backdropUrl'] as String?;

    // Extract rating safely
    double? rating;
    final ratings = json['ratings'];
    if (ratings is Map) {
      rating = (ratings['value'] as num?)?.toDouble();
    } else if (ratings is num) {
      rating = ratings.toDouble();
    }

    // Extract season/episode counts from statistics if not at top level
    int? seasonCount = json['seasonCount'] as int?;
    int? episodeCount = json['episodeCount'] as int?;
    final stats = json['statistics'];
    if (stats is Map) {
      seasonCount ??= stats['seasonCount'] as int?;
      episodeCount ??= stats['episodeFileCount'] as int?;
    }

    return MediaItem(
      id: json['id'] as int? ?? json['idTvdb'] as int? ?? 0,
      title: json['title'] as String? ?? json['seriesName'] as String? ?? '',
      type: type,
      status: status,
      overview: json['overview'] as String?,
      posterUrl: posterUrl,
      backdropUrl: backdropUrl,
      year: json['year'] as int? ?? (json['firstAired'] != null
          ? DateTime.tryParse(json['firstAired'] as String)?.year
          : null),
      rating: rating,
      quality: json['qualityProfileId']?.toString(),
      seasonCount: seasonCount,
      episodeCount: episodeCount,
      airDate: json['airDate'] != null
          ? DateTime.tryParse(json['airDate'] as String)
          : json['firstAired'] != null
              ? DateTime.tryParse(json['firstAired'] as String)
              : null,
      monitored: json['monitored'] as bool?,
      serviceKey: serviceKey,
      metadata: json,
    );
  }

  const MediaItem._();

  /// Check if media is currently downloading
  bool get isDownloading => status == MediaStatus.downloading;

  /// Check if media is downloaded
  bool get isDownloaded => status == MediaStatus.downloaded;

  /// Check if media is missing
  bool get isMissing => status == MediaStatus.missing;

  /// Check if media is being monitored
  bool get isActive => monitored ?? true;

  /// Get display title with year
  String get displayTitle => year != null ? '$title ($year)' : title;

  /// Check if has poster
  bool get hasPoster => posterUrl != null && posterUrl!.isNotEmpty;

  /// Check if has backdrop
  bool get hasBackdrop => backdropUrl != null && backdropUrl!.isNotEmpty;
}
