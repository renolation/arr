// ========================================
// Movie Hive Model
// Optimized for caching movie data from Radarr
// ========================================

import 'package:hive/hive.dart';
import 'image_hive.dart';
import 'ratings_hive.dart';

part 'movie_hive.g.dart';

@HiveType(typeId: 150)
class MovieHive extends HiveObject {
  @HiveField(0)
  final int? id;

  @HiveField(1)
  final String? title;

  @HiveField(2)
  final String? sortTitle;

  @HiveField(3)
  final int? sizeOnDisk;

  @HiveField(4)
  final String? status;

  @HiveField(5)
  final String? overview;

  @HiveField(6)
  final DateTime? inCinemas;

  @HiveField(7)
  final DateTime? physicalRelease;

  @HiveField(8)
  final DateTime? digitalRelease;

  @HiveField(9)
  final List<ImageHive>? images;

  @HiveField(10)
  final String? website;

  @HiveField(11)
  final bool? downloaded;

  @HiveField(12)
  final int? year;

  @HiveField(13)
  final bool? hasFile;

  @HiveField(14)
  final String? youTubeTrailerId;

  @HiveField(15)
  final String? studio;

  @HiveField(16)
  final String? path;

  @HiveField(17)
  final int? qualityProfileId;

  @HiveField(18)
  final bool? monitored;

  @HiveField(19)
  final String? minimumAvailability;

  @HiveField(20)
  final bool? isAvailable;

  @HiveField(21)
  final String? folderName;

  @HiveField(22)
  final int? runtime;

  @HiveField(23)
  final String? cleanTitle;

  @HiveField(24)
  final String? imdbId;

  @HiveField(25)
  final int? tmdbId;

  @HiveField(26)
  final String? titleSlug;

  @HiveField(27)
  final String? certification;

  @HiveField(28)
  final List<String>? genres;

  @HiveField(29)
  final List<String>? tags;

  @HiveField(30)
  final DateTime? added;

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

  @HiveField(36)
  final Map<String, dynamic>? movieFile;

  @HiveField(37)
  final Map<String, dynamic>? collection;

  MovieHive({
    this.id,
    this.title,
    this.sortTitle,
    this.sizeOnDisk,
    this.status,
    this.overview,
    this.inCinemas,
    this.physicalRelease,
    this.digitalRelease,
    this.images,
    this.website,
    this.downloaded,
    this.year,
    this.hasFile,
    this.youTubeTrailerId,
    this.studio,
    this.path,
    this.qualityProfileId,
    this.monitored,
    this.minimumAvailability,
    this.isAvailable,
    this.folderName,
    this.runtime,
    this.cleanTitle,
    this.imdbId,
    this.tmdbId,
    this.titleSlug,
    this.certification,
    this.genres,
    this.tags,
    this.added,
    this.ratings,
    this.posterUrl,
    this.backdropUrl,
    this.serviceId,
    DateTime? cachedAt,
    this.movieFile,
    this.collection,
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

  /// Check if movie is downloaded
  bool get isDownloaded => hasFile == true && downloaded == true;

  /// Check if movie is released and available
  bool get isReleased =>
      isAvailable == true &&
      (physicalRelease != null
          ? physicalRelease!.isBefore(DateTime.now())
          : true);

  /// Create from MovieResource (API model)
  factory MovieHive.fromJson({
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

    // Extract ratings
    RatingsHive? ratings;
    if (json['ratings'] != null) {
      ratings = RatingsHive.fromDynamic(json['ratings']);
    }

    // Parse int safely
    int? parseIntSafe(dynamic value) {
      if (value == null) return null;
      if (value is int) return value;
      if (value is String) return int.tryParse(value);
      return null;
    }

    return MovieHive(
      id: parseIntSafe(json['id']),
      title: json['title'] as String?,
      sortTitle: json['sortTitle'] as String?,
      sizeOnDisk: parseIntSafe(json['sizeOnDisk']),
      status: json['status'] as String?,
      overview: json['overview'] as String?,
      inCinemas: json['inCinemas'] != null
          ? DateTime.parse(json['inCinemas'] as String)
          : null,
      physicalRelease: json['physicalRelease'] != null
          ? DateTime.parse(json['physicalRelease'] as String)
          : null,
      digitalRelease: json['digitalRelease'] != null
          ? DateTime.parse(json['digitalRelease'] as String)
          : null,
      images: images,
      website: json['website'] as String?,
      downloaded: json['downloaded'] as bool?,
      year: parseIntSafe(json['year']),
      hasFile: json['hasFile'] as bool?,
      youTubeTrailerId: json['youTubeTrailerId'] as String?,
      studio: json['studio'] as String?,
      path: json['path'] as String?,
      qualityProfileId: parseIntSafe(json['qualityProfileId']),
      monitored: json['monitored'] as bool?,
      minimumAvailability: json['minimumAvailability'] as String?,
      isAvailable: json['isAvailable'] as bool?,
      folderName: json['folderName'] as String?,
      runtime: parseIntSafe(json['runtime']),
      cleanTitle: json['cleanTitle'] as String?,
      imdbId: json['imdbId'] as String?,
      tmdbId: parseIntSafe(json['tmdbId']),
      titleSlug: json['titleSlug'] as String?,
      certification: json['certification'] as String?,
      genres: (json['genres'] as List<dynamic>?)?.cast<String>(),
      tags: (json['tags'] as List<dynamic>?)?.cast<String>(),
      added: json['added'] != null
          ? DateTime.parse(json['added'] as String)
          : null,
      ratings: ratings,
      posterUrl: posterUrl,
      backdropUrl: backdropUrl,
      serviceId: serviceId,
      movieFile: json['movieFile'] as Map<String, dynamic>?,
      collection: json['collection'] as Map<String, dynamic>?,
    );
  }

  /// Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'sortTitle': sortTitle,
      'sizeOnDisk': sizeOnDisk,
      'status': status,
      'overview': overview,
      'inCinemas': inCinemas?.toIso8601String(),
      'physicalRelease': physicalRelease?.toIso8601String(),
      'digitalRelease': digitalRelease?.toIso8601String(),
      'images': images?.map((img) => img.toJson()).toList(),
      'website': website,
      'downloaded': downloaded,
      'year': year,
      'hasFile': hasFile,
      'youTubeTrailerId': youTubeTrailerId,
      'studio': studio,
      'path': path,
      'qualityProfileId': qualityProfileId,
      'monitored': monitored,
      'minimumAvailability': minimumAvailability,
      'isAvailable': isAvailable,
      'folderName': folderName,
      'runtime': runtime,
      'cleanTitle': cleanTitle,
      'imdbId': imdbId,
      'tmdbId': tmdbId,
      'titleSlug': titleSlug,
      'certification': certification,
      'genres': genres,
      'tags': tags,
      'added': added?.toIso8601String(),
      'ratings': ratings?.toJson(),
      'posterUrl': posterUrl,
      'backdropUrl': backdropUrl,
      'serviceId': serviceId,
      'cachedAt': cachedAt?.toIso8601String(),
      'movieFile': movieFile,
      'collection': collection,
    };
  }

  /// Create a copy with modified fields
  MovieHive copyWith({
    int? id,
    String? title,
    String? sortTitle,
    int? sizeOnDisk,
    String? status,
    String? overview,
    DateTime? inCinemas,
    DateTime? physicalRelease,
    DateTime? digitalRelease,
    List<ImageHive>? images,
    String? website,
    bool? downloaded,
    int? year,
    bool? hasFile,
    String? youTubeTrailerId,
    String? studio,
    String? path,
    int? qualityProfileId,
    bool? monitored,
    String? minimumAvailability,
    bool? isAvailable,
    String? folderName,
    int? runtime,
    String? cleanTitle,
    String? imdbId,
    int? tmdbId,
    String? titleSlug,
    String? certification,
    List<String>? genres,
    List<String>? tags,
    DateTime? added,
    RatingsHive? ratings,
    String? posterUrl,
    String? backdropUrl,
    String? serviceId,
    DateTime? cachedAt,
    Map<String, dynamic>? movieFile,
    Map<String, dynamic>? collection,
  }) {
    return MovieHive(
      id: id ?? this.id,
      title: title ?? this.title,
      sortTitle: sortTitle ?? this.sortTitle,
      sizeOnDisk: sizeOnDisk ?? this.sizeOnDisk,
      status: status ?? this.status,
      overview: overview ?? this.overview,
      inCinemas: inCinemas ?? this.inCinemas,
      physicalRelease: physicalRelease ?? this.physicalRelease,
      digitalRelease: digitalRelease ?? this.digitalRelease,
      images: images ?? this.images,
      website: website ?? this.website,
      downloaded: downloaded ?? this.downloaded,
      year: year ?? this.year,
      hasFile: hasFile ?? this.hasFile,
      youTubeTrailerId: youTubeTrailerId ?? this.youTubeTrailerId,
      studio: studio ?? this.studio,
      path: path ?? this.path,
      qualityProfileId: qualityProfileId ?? this.qualityProfileId,
      monitored: monitored ?? this.monitored,
      minimumAvailability: minimumAvailability ?? this.minimumAvailability,
      isAvailable: isAvailable ?? this.isAvailable,
      folderName: folderName ?? this.folderName,
      runtime: runtime ?? this.runtime,
      cleanTitle: cleanTitle ?? this.cleanTitle,
      imdbId: imdbId ?? this.imdbId,
      tmdbId: tmdbId ?? this.tmdbId,
      titleSlug: titleSlug ?? this.titleSlug,
      certification: certification ?? this.certification,
      genres: genres ?? this.genres,
      tags: tags ?? this.tags,
      added: added ?? this.added,
      ratings: ratings ?? this.ratings,
      posterUrl: posterUrl ?? this.posterUrl,
      backdropUrl: backdropUrl ?? this.backdropUrl,
      serviceId: serviceId ?? this.serviceId,
      cachedAt: cachedAt ?? this.cachedAt,
      movieFile: movieFile ?? this.movieFile,
      collection: collection ?? this.collection,
    );
  }

  /// Check if cache is stale (older than specified duration)
  bool isCacheStale({Duration maxAge = const Duration(hours: 24)}) {
    if (cachedAt == null) return true;
    return DateTime.now().difference(cachedAt!) > maxAge;
  }
}
