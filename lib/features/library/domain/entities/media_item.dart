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
    Map<String, dynamic>? metadata,
  }) = _MediaItem;

  factory MediaItem.fromJson(Map<String, dynamic> json) {
    final typeStr = json['type'] as String? ?? 'movie';
    final type = typeStr == 'series' ? MediaType.series : MediaType.movie;

    final statusStr = json['status'] as String? ?? 'continuing';
    final status = MediaStatus.values.firstWhere(
      (e) => e.name.toLowerCase() == statusStr.toLowerCase(),
      orElse: () => MediaStatus.continuing,
    );

    return MediaItem(
      id: json['id'] as int? ?? json['idTvdb'] as int? ?? 0,
      title: json['title'] as String? ?? json['seriesName'] as String? ?? '',
      type: type,
      status: status,
      overview: json['overview'] as String?,
      posterUrl: json['posterUrl'] as String?,
      backdropUrl: json['backdropUrl'] as String?,
      year: json['year'] as int? ?? (json['firstAired'] != null
          ? DateTime.tryParse(json['firstAired'] as String)?.year
          : null),
      rating: json['ratings'] != null && json['ratings'] is Map
          ? ((json['ratings'] as Map<String, dynamic>)['value'] as num?)?.toDouble()
          : (json['ratings'] as num?)?.toDouble(),
      quality: json['qualityProfileId']?.toString(),
      seasonCount: json['seasonCount'] as int?,
      episodeCount: json['episodeCount'] as int?,
      airDate: json['airDate'] != null
          ? DateTime.tryParse(json['airDate'] as String)
          : json['firstAired'] != null
              ? DateTime.tryParse(json['firstAired'] as String)
              : null,
      monitored: json['monitored'] as bool?,
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
