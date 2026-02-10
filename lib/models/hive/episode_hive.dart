// ========================================
// Episode Hive Model
// Optimized for caching episode data from Sonarr
// ========================================

import 'package:hive/hive.dart';

part 'episode_hive.g.dart';

@HiveType(typeId: 160)
class EpisodeHive extends HiveObject {
  @HiveField(0)
  final int? seriesId;

  @HiveField(1)
  final int? episodeFileId;

  @HiveField(2)
  final int? seasonNumber;

  @HiveField(3)
  final int? episodeNumber;

  @HiveField(4)
  final String? title;

  @HiveField(5)
  final String? airDate;

  @HiveField(6)
  final String? airDateTime;

  @HiveField(7)
  final String? overview;

  @HiveField(8)
  final bool? hasFile;

  @HiveField(9)
  final bool? monitored;

  @HiveField(10)
  final int? absoluteEpisodeNumber;

  @HiveField(11)
  final int? tvdbId;

  @HiveField(12)
  final String? tvRageId;

  @HiveField(13)
  final String? sceneSeasonNumber;

  @HiveField(14)
  final String? sceneEpisodeNumber;

  @HiveField(15)
  final String? sceneAbsoluteEpisodeNumber;

  @HiveField(16)
  final int? unverifiedSceneNumbering;

  @HiveField(17)
  final DateTime? lastInfoSync;

  @HiveField(18)
  final String? series;

  @HiveField(19)
  final bool? endingAired;

  @HiveField(20)
  final String? endTime;

  @HiveField(21)
  final String? grabDate;

  @HiveField(22)
  final String? grabTitle;

  @HiveField(23)
  final String? indexer;

  @HiveField(24)
  final String? releaseGroup;

  @HiveField(25)
  final int? seasonCount;

  @HiveField(26)
  final String? seriesTitle;

  @HiveField(27)
  final int? sizeOnDisk;

  @HiveField(28)
  final String? mediaInfo;

  @HiveField(29)
  final String? quality;

  @HiveField(30)
  final String? serviceId;

  @HiveField(31)
  final DateTime? cachedAt;

  @HiveField(32)
  final String? language;

  @HiveField(33)
  final String? subtitles;

  @HiveField(34)
  final Map<String, dynamic>? episodeFile;

  EpisodeHive({
    this.seriesId,
    this.episodeFileId,
    this.seasonNumber,
    this.episodeNumber,
    this.title,
    this.airDate,
    this.airDateTime,
    this.overview,
    this.hasFile,
    this.monitored,
    this.absoluteEpisodeNumber,
    this.tvdbId,
    this.tvRageId,
    this.sceneSeasonNumber,
    this.sceneEpisodeNumber,
    this.sceneAbsoluteEpisodeNumber,
    this.unverifiedSceneNumbering,
    this.lastInfoSync,
    this.series,
    this.endingAired,
    this.endTime,
    this.grabDate,
    this.grabTitle,
    this.indexer,
    this.releaseGroup,
    this.seasonCount,
    this.seriesTitle,
    this.sizeOnDisk,
    this.mediaInfo,
    this.quality,
    this.serviceId,
    DateTime? cachedAt,
    this.language,
    this.subtitles,
    this.episodeFile,
  }) : cachedAt = cachedAt ?? DateTime.now();

  /// Get composite key for this episode
  String get episodeKey => '${seriesId}_${seasonNumber}_${episodeNumber}';

  /// Check if episode has aired
  bool get hasAired {
    if (airDate == null) return false;
    try {
      final airDate = DateTime.parse(this.airDate!);
      return airDate.isBefore(DateTime.now());
    } catch (_) {
      return false;
    }
  }

  /// Check if episode is downloaded
  bool get isDownloaded => hasFile == true && episodeFileId != null;

  /// Check if episode is upcoming
  bool get isUpcoming {
    if (airDate == null) return false;
    try {
      final airDate = DateTime.parse(this.airDate!);
      return airDate.isAfter(DateTime.now());
    } catch (_) {
      return false;
    }
  }

  /// Get formatted episode number (S01E05)
  String get formattedEpisodeNumber {
    final season = seasonNumber?.toString().padLeft(2, '0') ?? '00';
    final episode = episodeNumber?.toString().padLeft(2, '0') ?? '00';
    return 'S$season' + 'E$episode';
  }

  /// Get formatted size
  String? get formattedSize {
    if (sizeOnDisk == null) return null;
    const mb = 1024 * 1024;
    final sizeInMb = sizeOnDisk! / mb;
    if (sizeInMb >= 1024) {
      return '${(sizeInMb / 1024).toStringAsFixed(2)} GB';
    }
    return '${sizeInMb.toStringAsFixed(2)} MB';
  }

  /// Create from EpisodeResource (API model)
  factory EpisodeHive.fromJson({
    required Map<String, dynamic> json,
    String? serviceId,
  }) {
    // Parse int safely
    int? parseIntSafe(dynamic value) {
      if (value == null) return null;
      if (value is int) return value;
      if (value is String) return int.tryParse(value);
      return null;
    }

    // Extract episode file info
    Map<String, dynamic>? episodeFile;
    if (json['episodeFile'] != null && json['episodeFile'] is Map) {
      episodeFile = json['episodeFile'] as Map<String, dynamic>;
    }

    return EpisodeHive(
      seriesId: json['seriesId'] as int?,
      episodeFileId: json['episodeFileId'] as int?,
      seasonNumber: json['seasonNumber'] as int?,
      episodeNumber: json['episodeNumber'] as int?,
      title: json['title'] as String?,
      airDate: json['airDate'] as String?,
      airDateTime: json['airDateTime'] as String?,
      overview: json['overview'] as String?,
      hasFile: json['hasFile'] as bool?,
      monitored: json['monitored'] as bool?,
      absoluteEpisodeNumber: json['absoluteEpisodeNumber'] as int?,
      tvdbId: json['tvdbId'] as int?,
      tvRageId: json['tvRageId'] as String?,
      sceneSeasonNumber: json['sceneSeasonNumber'] as String?,
      sceneEpisodeNumber: json['sceneEpisodeNumber'] as String?,
      sceneAbsoluteEpisodeNumber: json['sceneAbsoluteEpisodeNumber'] as String?,
      unverifiedSceneNumbering: json['unverifiedSceneNumbering'] as int?,
      lastInfoSync: json['lastInfoSync'] != null
          ? DateTime.parse(json['lastInfoSync'] as String)
          : null,
      series: json['series'] as String?,
      endingAired: json['endingAired'] as bool?,
      endTime: json['endTime'] as String?,
      grabDate: json['grabDate'] as String?,
      grabTitle: json['grabTitle'] as String?,
      indexer: json['indexer'] as String?,
      releaseGroup: json['releaseGroup'] as String?,
      seasonCount: json['seasonCount'] as int?,
      seriesTitle: json['seriesTitle'] as String?,
      sizeOnDisk: episodeFile != null ? episodeFile['size'] as int? : null,
      mediaInfo: episodeFile != null ? episodeFile['mediaInfo']?.toString() : null,
      quality: episodeFile != null && episodeFile['quality'] != null
          ? (episodeFile['quality'] as Map<String, dynamic>)['quality'] != null
              ? ((episodeFile['quality'] as Map<String, dynamic>)['quality'] as Map<String, dynamic>)['name'] as String?
              : null
          : null,
      serviceId: serviceId,
      language: json['language'] != null ? (json['language'] as Map<String, dynamic>)['name'] as String? : null,
      subtitles: json['subtitles'] as String?,
      episodeFile: episodeFile,
    );
  }

  /// Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'seriesId': seriesId,
      'episodeFileId': episodeFileId,
      'seasonNumber': seasonNumber,
      'episodeNumber': episodeNumber,
      'title': title,
      'airDate': airDate,
      'airDateTime': airDateTime,
      'overview': overview,
      'hasFile': hasFile,
      'monitored': monitored,
      'absoluteEpisodeNumber': absoluteEpisodeNumber,
      'tvdbId': tvdbId,
      'tvRageId': tvRageId,
      'sceneSeasonNumber': sceneSeasonNumber,
      'sceneEpisodeNumber': sceneEpisodeNumber,
      'sceneAbsoluteEpisodeNumber': sceneAbsoluteEpisodeNumber,
      'unverifiedSceneNumbering': unverifiedSceneNumbering,
      'lastInfoSync': lastInfoSync?.toIso8601String(),
      'series': series,
      'endingAired': endingAired,
      'endTime': endTime,
      'grabDate': grabDate,
      'grabTitle': grabTitle,
      'indexer': indexer,
      'releaseGroup': releaseGroup,
      'seasonCount': seasonCount,
      'seriesTitle': seriesTitle,
      'sizeOnDisk': sizeOnDisk,
      'mediaInfo': mediaInfo,
      'quality': quality,
      'serviceId': serviceId,
      'cachedAt': cachedAt?.toIso8601String(),
      'language': language,
      'subtitles': subtitles,
      'episodeFile': episodeFile,
    };
  }

  /// Create a copy with modified fields
  EpisodeHive copyWith({
    int? seriesId,
    int? episodeFileId,
    int? seasonNumber,
    int? episodeNumber,
    String? title,
    String? airDate,
    String? airDateTime,
    String? overview,
    bool? hasFile,
    bool? monitored,
    int? absoluteEpisodeNumber,
    int? tvdbId,
    String? tvRageId,
    String? sceneSeasonNumber,
    String? sceneEpisodeNumber,
    String? sceneAbsoluteEpisodeNumber,
    int? unverifiedSceneNumbering,
    DateTime? lastInfoSync,
    String? series,
    bool? endingAired,
    String? endTime,
    String? grabDate,
    String? grabTitle,
    String? indexer,
    String? releaseGroup,
    int? seasonCount,
    String? seriesTitle,
    int? sizeOnDisk,
    String? mediaInfo,
    String? quality,
    String? serviceId,
    DateTime? cachedAt,
    String? language,
    String? subtitles,
    Map<String, dynamic>? episodeFile,
  }) {
    return EpisodeHive(
      seriesId: seriesId ?? this.seriesId,
      episodeFileId: episodeFileId ?? this.episodeFileId,
      seasonNumber: seasonNumber ?? this.seasonNumber,
      episodeNumber: episodeNumber ?? this.episodeNumber,
      title: title ?? this.title,
      airDate: airDate ?? this.airDate,
      airDateTime: airDateTime ?? this.airDateTime,
      overview: overview ?? this.overview,
      hasFile: hasFile ?? this.hasFile,
      monitored: monitored ?? this.monitored,
      absoluteEpisodeNumber:
          absoluteEpisodeNumber ?? this.absoluteEpisodeNumber,
      tvdbId: tvdbId ?? this.tvdbId,
      tvRageId: tvRageId ?? this.tvRageId,
      sceneSeasonNumber: sceneSeasonNumber ?? this.sceneSeasonNumber,
      sceneEpisodeNumber: sceneEpisodeNumber ?? this.sceneEpisodeNumber,
      sceneAbsoluteEpisodeNumber:
          sceneAbsoluteEpisodeNumber ?? this.sceneAbsoluteEpisodeNumber,
      unverifiedSceneNumbering:
          unverifiedSceneNumbering ?? this.unverifiedSceneNumbering,
      lastInfoSync: lastInfoSync ?? this.lastInfoSync,
      series: series ?? this.series,
      endingAired: endingAired ?? this.endingAired,
      endTime: endTime ?? this.endTime,
      grabDate: grabDate ?? this.grabDate,
      grabTitle: grabTitle ?? this.grabTitle,
      indexer: indexer ?? this.indexer,
      releaseGroup: releaseGroup ?? this.releaseGroup,
      seasonCount: seasonCount ?? this.seasonCount,
      seriesTitle: seriesTitle ?? this.seriesTitle,
      sizeOnDisk: sizeOnDisk ?? this.sizeOnDisk,
      mediaInfo: mediaInfo ?? this.mediaInfo,
      quality: quality ?? this.quality,
      serviceId: serviceId ?? this.serviceId,
      cachedAt: cachedAt ?? this.cachedAt,
      language: language ?? this.language,
      subtitles: subtitles ?? this.subtitles,
      episodeFile: episodeFile ?? this.episodeFile,
    );
  }

  /// Check if cache is stale (older than specified duration)
  bool isCacheStale({Duration maxAge = const Duration(hours: 24)}) {
    if (cachedAt == null) return true;
    return DateTime.now().difference(cachedAt!) > maxAge;
  }
}
