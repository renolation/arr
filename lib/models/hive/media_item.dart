// ========================================
// Media Item Hive Model
// Unified cache for both movies and TV series
// ========================================

import 'package:hive/hive.dart';
import 'enums.dart';
import 'image_hive.dart';
import 'ratings_hive.dart';

part 'media_item.g.dart';

@HiveType(typeId: 130)
class MediaItem extends HiveObject {
  @HiveField(0)
  final String id; // Composite key: "series_{id}" or "movie_{id}"

  @HiveField(1)
  final MediaType type;

  @HiveField(2)
  final int? seriesId;

  @HiveField(3)
  final int? movieId;

  @HiveField(4)
  final String title;

  @HiveField(5)
  final String? sortTitle;

  @HiveField(6)
  final String? posterUrl;

  @HiveField(7)
  final String? backdropUrl;

  @HiveField(8)
  final int? year;

  @HiveField(9)
  final MediaStatus? status;

  @HiveField(10)
  final String? overview;

  @HiveField(11)
  final DateTime? added;

  @HiveField(12)
  final DateTime? lastUpdated;

  @HiveField(13)
  final bool? monitored;

  @HiveField(14)
  final int? sizeOnDisk;

  @HiveField(15)
  final RatingsHive? ratings;

  @HiveField(16)
  final List<String>? genres;

  @HiveField(17)
  final String? certification;

  @HiveField(18)
  final int? runtime;

  @HiveField(19)
  final String? serviceId; // Which service this data came from

  @HiveField(20)
  final Map<String, dynamic>? metadata; // Store extra data as JSON

  MediaItem({
    required this.id,
    required this.type,
    this.seriesId,
    this.movieId,
    required this.title,
    this.sortTitle,
    this.posterUrl,
    this.backdropUrl,
    this.year,
    this.status,
    this.overview,
    this.added,
    this.lastUpdated,
    this.monitored,
    this.sizeOnDisk,
    this.ratings,
    this.genres,
    this.certification,
    this.runtime,
    this.serviceId,
    this.metadata,
  });

  /// Get the primary media ID
  int? get mediaId => type == MediaType.series ? seriesId : movieId;

  /// Check if item has poster
  bool get hasPoster => posterUrl != null && posterUrl!.isNotEmpty;

  /// Check if item has backdrop
  bool get hasBackdrop => backdropUrl != null && backdropUrl!.isNotEmpty;

  /// Format size in bytes to human readable
  String? get formattedSize {
    if (sizeOnDisk == null) return null;
    const gb = 1024 * 1024 * 1024;
    const mb = 1024 * 1024;
    if (sizeOnDisk! >= gb) {
      return '${(sizeOnDisk! / gb).toStringAsFixed(2)} GB';
    }
    return '${(sizeOnDisk! / mb).toStringAsFixed(2)} MB';
  }

  /// Create from SeriesResource
  factory MediaItem.fromSeries({
    required Map<String, dynamic> series,
    String? serviceId,
  }) {
    // Extract poster URL from images
    String? posterUrl;
    String? backdropUrl;
    if (series['images'] != null && series['images'] is List) {
      for (var img in series['images']) {
        if (img is Map) {
          final coverType = img['coverType'] as String?;
          final url = img['remoteUrl'] as String? ?? img['url'] as String?;
          if (coverType == 'poster' && url != null) {
            posterUrl = url;
          } else if (coverType == 'fanart' && url != null) {
            backdropUrl = url;
          }
        }
      }
    }

    // Extract ratings
    RatingsHive? ratings;
    if (series['ratings'] != null) {
      ratings = RatingsHive.fromDynamic(series['ratings']);
    }

    return MediaItem(
      id: 'series_${series['id']}',
      type: MediaType.series,
      seriesId: series['id'] as int?,
      title: series['title'] as String? ?? '',
      sortTitle: series['sortTitle'] as String?,
      posterUrl: posterUrl,
      backdropUrl: backdropUrl,
      year: series['year'] as int?,
      status: _parseMediaStatus(series['status'] as String?),
      overview: series['overview'] as String?,
      added: series['added'] != null
          ? DateTime.parse(series['added'] as String)
          : null,
      lastUpdated: series['lastInfoSync'] != null
          ? DateTime.parse(series['lastInfoSync'] as String)
          : null,
      monitored: series['monitored'] as bool?,
      sizeOnDisk: series['sizeOnDisk'] as int?,
      ratings: ratings,
      genres: (series['genres'] as List<dynamic>?)?.cast<String>(),
      certification: series['certification'] as String?,
      runtime: series['runtime'] as int?,
      serviceId: serviceId,
      metadata: series,
    );
  }

  /// Create from MovieResource
  factory MediaItem.fromMovie({
    required Map<String, dynamic> movie,
    String? serviceId,
  }) {
    // Extract poster URL from images
    String? posterUrl;
    String? backdropUrl;
    if (movie['images'] != null && movie['images'] is List) {
      for (var img in movie['images']) {
        if (img is Map) {
          final coverType = img['coverType'] as String?;
          final url = img['remoteUrl'] as String? ?? img['url'] as String?;
          if (coverType == 'poster' && url != null) {
            posterUrl = url;
          } else if (coverType == 'fanart' && url != null) {
            backdropUrl = url;
          }
        }
      }
    }

    // Extract ratings
    RatingsHive? ratings;
    if (movie['ratings'] != null) {
      ratings = RatingsHive.fromDynamic(movie['ratings']);
    }

    return MediaItem(
      id: 'movie_${movie['id']}',
      type: MediaType.movie,
      movieId: movie['id'] as int?,
      title: movie['title'] as String? ?? '',
      sortTitle: movie['sortTitle'] as String?,
      posterUrl: posterUrl,
      backdropUrl: backdropUrl,
      year: movie['year'] as int?,
      status: _parseMediaStatus(movie['status'] as String?),
      overview: movie['overview'] as String?,
      added: movie['added'] != null
          ? DateTime.parse(movie['added'] as String)
          : null,
      lastUpdated: null, // Movies don't have lastInfoSync
      monitored: movie['monitored'] as bool?,
      sizeOnDisk: movie['sizeOnDisk'] as int?,
      ratings: ratings,
      genres: (movie['genres'] as List<dynamic>?)?.cast<String>(),
      certification: movie['certification'] as String?,
      runtime: movie['runtime'] as int?,
      serviceId: serviceId,
      metadata: movie,
    );
  }

  static MediaStatus? _parseMediaStatus(String? status) {
    if (status == null) return null;
    switch (status.toLowerCase()) {
      case 'continuing':
        return MediaStatus.continuing;
      case 'ended':
        return MediaStatus.ended;
      case 'downloading':
        return MediaStatus.downloading;
      case 'completed':
        return MediaStatus.completed;
      case 'upcoming':
        return MediaStatus.upcoming;
      default:
        return MediaStatus.monitored;
    }
  }

  /// Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type.name,
      'seriesId': seriesId,
      'movieId': movieId,
      'title': title,
      'sortTitle': sortTitle,
      'posterUrl': posterUrl,
      'backdropUrl': backdropUrl,
      'year': year,
      'status': status?.name,
      'overview': overview,
      'added': added?.toIso8601String(),
      'lastUpdated': lastUpdated?.toIso8601String(),
      'monitored': monitored,
      'sizeOnDisk': sizeOnDisk,
      'ratings': ratings?.toJson(),
      'genres': genres,
      'certification': certification,
      'runtime': runtime,
      'serviceId': serviceId,
      'metadata': metadata,
    };
  }

  /// Create a copy with modified fields
  MediaItem copyWith({
    String? id,
    MediaType? type,
    int? seriesId,
    int? movieId,
    String? title,
    String? sortTitle,
    String? posterUrl,
    String? backdropUrl,
    int? year,
    MediaStatus? status,
    String? overview,
    DateTime? added,
    DateTime? lastUpdated,
    bool? monitored,
    int? sizeOnDisk,
    RatingsHive? ratings,
    List<String>? genres,
    String? certification,
    int? runtime,
    String? serviceId,
    Map<String, dynamic>? metadata,
  }) {
    return MediaItem(
      id: id ?? this.id,
      type: type ?? this.type,
      seriesId: seriesId ?? this.seriesId,
      movieId: movieId ?? this.movieId,
      title: title ?? this.title,
      sortTitle: sortTitle ?? this.sortTitle,
      posterUrl: posterUrl ?? this.posterUrl,
      backdropUrl: backdropUrl ?? this.backdropUrl,
      year: year ?? this.year,
      status: status ?? this.status,
      overview: overview ?? this.overview,
      added: added ?? this.added,
      lastUpdated: lastUpdated ?? this.lastUpdated,
      monitored: monitored ?? this.monitored,
      sizeOnDisk: sizeOnDisk ?? this.sizeOnDisk,
      ratings: ratings ?? this.ratings,
      genres: genres ?? this.genres,
      certification: certification ?? this.certification,
      runtime: runtime ?? this.runtime,
      serviceId: serviceId ?? this.serviceId,
      metadata: metadata ?? this.metadata,
    );
  }
}
