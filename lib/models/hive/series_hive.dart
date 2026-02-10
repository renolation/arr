// ========================================
// Series Hive Model
// Optimized for caching TV series data from Sonarr
// ========================================

import 'package:hive/hive.dart';
import 'enums.dart';
import 'image_hive.dart';
import 'ratings_hive.dart';

part 'series_hive.g.dart';

@HiveType(typeId: 140)
class SeriesHive extends HiveObject {
  @HiveField(0)
  final int? id;

  @HiveField(1)
  final String? title;

  @HiveField(2)
  final String? sortTitle;

  @HiveField(3)
  final SeriesStatus? status;

  @HiveField(4)
  final String? overview;

  @HiveField(5)
  final String? network;

  @HiveField(6)
  final String? airTime;

  @HiveField(7)
  final List<ImageHive>? images;

  @HiveField(8)
  final int? seasonCount;

  @HiveField(9)
  final int? totalEpisodeCount;

  @HiveField(10)
  final int? episodeCount;

  @HiveField(11)
  final int? episodeFileCount;

  @HiveField(12)
  final int? sizeOnDisk;

  @HiveField(13)
  final String? seriesType;

  @HiveField(14)
  final DateTime? added;

  @HiveField(15)
  final int? qualityProfileId;

  @HiveField(16)
  final int? languageProfileId;

  @HiveField(17)
  final int? runtime;

  @HiveField(18)
  final int? tvdbId;

  @HiveField(19)
  final int? tvMazeId;

  @HiveField(20)
  final DateTime? firstAired;

  @HiveField(21)
  final DateTime? lastInfoSync;

  @HiveField(22)
  final String? cleanTitle;

  @HiveField(23)
  final String? imdbId;

  @HiveField(24)
  final String? titleSlug;

  @HiveField(25)
  final String? rootFolderPath;

  @HiveField(26)
  final String? certification;

  @HiveField(27)
  final List<String>? genres;

  @HiveField(28)
  final List<String>? tags;

  @HiveField(29)
  final bool? monitored;

  @HiveField(30)
  final int? year;

  @HiveField(31)
  final RatingsHive? ratings;

  @HiveField(32)
  final String? posterUrl;

  @HiveField(33)
  final String? backdropUrl;

  @HiveField(34)
  final String? serviceId;

  @HiveField(35)
  final DateTime? cachedAt;

  SeriesHive({
    this.id,
    this.title,
    this.sortTitle,
    this.status,
    this.overview,
    this.network,
    this.airTime,
    this.images,
    this.seasonCount,
    this.totalEpisodeCount,
    this.episodeCount,
    this.episodeFileCount,
    this.sizeOnDisk,
    this.seriesType,
    this.added,
    this.qualityProfileId,
    this.languageProfileId,
    this.runtime,
    this.tvdbId,
    this.tvMazeId,
    this.firstAired,
    this.lastInfoSync,
    this.cleanTitle,
    this.imdbId,
    this.titleSlug,
    this.rootFolderPath,
    this.certification,
    this.genres,
    this.tags,
    this.monitored,
    this.year,
    this.ratings,
    this.posterUrl,
    this.backdropUrl,
    this.serviceId,
    DateTime? cachedAt,
  }) : cachedAt = cachedAt ?? DateTime.now();

  /// Get poster image
  ImageHive? get posterImage {
    return images?.firstWhere(
      (img) => img.isPoster,
      orElse: () => ImageHive(coverType: 'poster', url: posterUrl),
    );
  }

  /// Get backdrop/fanart image
  ImageHive? get backdropImage {
    return images?.firstWhere(
      (img) => img.isFanart,
      orElse: () => ImageHive(coverType: 'fanart', url: backdropUrl),
    );
  }

  /// Check if series has all episodes
  bool get hasAllEpisodes =>
      episodeFileCount != null &&
      totalEpisodeCount != null &&
      episodeFileCount! >= totalEpisodeCount!;

  /// Get episode progress percentage
  double? get downloadProgress {
    if (totalEpisodeCount == null || totalEpisodeCount == 0) return null;
    if (episodeFileCount == null) return 0.0;
    return (episodeFileCount! / totalEpisodeCount!) * 100;
  }

  /// Create from SeriesResource (API model)
  factory SeriesHive.fromJson({
    required Map<String, dynamic> json,
    String? serviceId,
  }) {
    // Extract images
    List<ImageHive>? images;
    if (json['images'] != null && json['images'] is List) {
      images = (json['images'] as List)
          .map((img) => ImageHive.fromMediaCover(img))
          .toList();
    }

    // Extract poster and backdrop URLs for quick access
    String? posterUrl;
    String? backdropUrl;
    if (images != null) {
      for (var img in images) {
        if (img.isPoster && img.bestUrl != null) {
          posterUrl = img.bestUrl;
        } else if (img.isFanart && img.bestUrl != null) {
          backdropUrl = img.bestUrl;
        }
      }
    }

    // Parse status
    SeriesStatus? parseStatus(String? statusStr) {
      if (statusStr == null) return null;
      try {
        return SeriesStatus.values.firstWhere(
          (e) => e.name.toLowerCase() == statusStr.toLowerCase(),
        );
      } catch (_) {
        return null;
      }
    }

    // Extract ratings
    RatingsHive? ratings;
    if (json['ratings'] != null) {
      ratings = RatingsHive.fromDynamic(json['ratings']);
    }

    return SeriesHive(
      id: json['id'] as int?,
      title: json['title'] as String?,
      sortTitle: json['sortTitle'] as String?,
      status: parseStatus(json['status'] as String?),
      overview: json['overview'] as String?,
      network: json['network'] as String?,
      airTime: json['airTime'] as String?,
      images: images,
      seasonCount: json['seasonCount'] as int?,
      totalEpisodeCount: json['totalEpisodeCount'] as int?,
      episodeCount: json['episodeCount'] as int?,
      episodeFileCount: json['episodeFileCount'] as int?,
      sizeOnDisk: json['sizeOnDisk'] as int?,
      seriesType: json['seriesType'] as String?,
      added: json['added'] != null
          ? DateTime.parse(json['added'] as String)
          : null,
      qualityProfileId: json['qualityProfileId'] as int?,
      languageProfileId: json['languageProfileId'] as int?,
      runtime: json['runtime'] as int?,
      tvdbId: json['tvdbId'] as int?,
      tvMazeId: json['tvMazeId'] as int?,
      firstAired: json['firstAired'] != null
          ? DateTime.parse(json['firstAired'] as String)
          : null,
      lastInfoSync: json['lastInfoSync'] != null
          ? DateTime.parse(json['lastInfoSync'] as String)
          : null,
      cleanTitle: json['cleanTitle'] as String?,
      imdbId: json['imdbId'] as String?,
      titleSlug: json['titleSlug'] as String?,
      rootFolderPath: json['rootFolderPath'] as String?,
      certification: json['certification'] as String?,
      genres: (json['genres'] as List<dynamic>?)?.cast<String>(),
      tags: (json['tags'] as List<dynamic>?)?.cast<String>(),
      monitored: json['monitored'] as bool?,
      year: json['year'] as int?,
      ratings: ratings,
      posterUrl: posterUrl,
      backdropUrl: backdropUrl,
      serviceId: serviceId,
    );
  }

  /// Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'sortTitle': sortTitle,
      'status': status?.name,
      'overview': overview,
      'network': network,
      'airTime': airTime,
      'images': images?.map((img) => img.toJson()).toList(),
      'seasonCount': seasonCount,
      'totalEpisodeCount': totalEpisodeCount,
      'episodeCount': episodeCount,
      'episodeFileCount': episodeFileCount,
      'sizeOnDisk': sizeOnDisk,
      'seriesType': seriesType,
      'added': added?.toIso8601String(),
      'qualityProfileId': qualityProfileId,
      'languageProfileId': languageProfileId,
      'runtime': runtime,
      'tvdbId': tvdbId,
      'tvMazeId': tvMazeId,
      'firstAired': firstAired?.toIso8601String(),
      'lastInfoSync': lastInfoSync?.toIso8601String(),
      'cleanTitle': cleanTitle,
      'imdbId': imdbId,
      'titleSlug': titleSlug,
      'rootFolderPath': rootFolderPath,
      'certification': certification,
      'genres': genres,
      'tags': tags,
      'monitored': monitored,
      'year': year,
      'ratings': ratings?.toJson(),
      'posterUrl': posterUrl,
      'backdropUrl': backdropUrl,
      'serviceId': serviceId,
      'cachedAt': cachedAt?.toIso8601String(),
    };
  }

  /// Create a copy with modified fields
  SeriesHive copyWith({
    int? id,
    String? title,
    String? sortTitle,
    SeriesStatus? status,
    String? overview,
    String? network,
    String? airTime,
    List<ImageHive>? images,
    int? seasonCount,
    int? totalEpisodeCount,
    int? episodeCount,
    int? episodeFileCount,
    int? sizeOnDisk,
    String? seriesType,
    DateTime? added,
    int? qualityProfileId,
    int? languageProfileId,
    int? runtime,
    int? tvdbId,
    int? tvMazeId,
    DateTime? firstAired,
    DateTime? lastInfoSync,
    String? cleanTitle,
    String? imdbId,
    String? titleSlug,
    String? rootFolderPath,
    String? certification,
    List<String>? genres,
    List<String>? tags,
    bool? monitored,
    int? year,
    RatingsHive? ratings,
    String? posterUrl,
    String? backdropUrl,
    String? serviceId,
    DateTime? cachedAt,
  }) {
    return SeriesHive(
      id: id ?? this.id,
      title: title ?? this.title,
      sortTitle: sortTitle ?? this.sortTitle,
      status: status ?? this.status,
      overview: overview ?? this.overview,
      network: network ?? this.network,
      airTime: airTime ?? this.airTime,
      images: images ?? this.images,
      seasonCount: seasonCount ?? this.seasonCount,
      totalEpisodeCount: totalEpisodeCount ?? this.totalEpisodeCount,
      episodeCount: episodeCount ?? this.episodeCount,
      episodeFileCount: episodeFileCount ?? this.episodeFileCount,
      sizeOnDisk: sizeOnDisk ?? this.sizeOnDisk,
      seriesType: seriesType ?? this.seriesType,
      added: added ?? this.added,
      qualityProfileId: qualityProfileId ?? this.qualityProfileId,
      languageProfileId: languageProfileId ?? this.languageProfileId,
      runtime: runtime ?? this.runtime,
      tvdbId: tvdbId ?? this.tvdbId,
      tvMazeId: tvMazeId ?? this.tvMazeId,
      firstAired: firstAired ?? this.firstAired,
      lastInfoSync: lastInfoSync ?? this.lastInfoSync,
      cleanTitle: cleanTitle ?? this.cleanTitle,
      imdbId: imdbId ?? this.imdbId,
      titleSlug: titleSlug ?? this.titleSlug,
      rootFolderPath: rootFolderPath ?? this.rootFolderPath,
      certification: certification ?? this.certification,
      genres: genres ?? this.genres,
      tags: tags ?? this.tags,
      monitored: monitored ?? this.monitored,
      year: year ?? this.year,
      ratings: ratings ?? this.ratings,
      posterUrl: posterUrl ?? this.posterUrl,
      backdropUrl: backdropUrl ?? this.backdropUrl,
      serviceId: serviceId ?? this.serviceId,
      cachedAt: cachedAt ?? this.cachedAt,
    );
  }

  /// Check if cache is stale (older than specified duration)
  bool isCacheStale({Duration maxAge = const Duration(hours: 24)}) {
    if (cachedAt == null) return true;
    return DateTime.now().difference(cachedAt!) > maxAge;
  }
}
