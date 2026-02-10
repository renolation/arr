// ========================================
// Movie Resource
// Radarr-specific
// ========================================

import 'package:arr/models/common/media_cover.dart';
import 'package:arr/models/movie/alternative_title.dart';
import 'package:arr/models/movie/collection/collection_resource.dart';
import 'package:arr/models/movie/movie/movie_file_resource.dart';
import 'package:arr/models/movie/movie/movie_statistics.dart';
import 'package:arr/models/movie/ratings.dart';
import 'package:equatable/equatable.dart';

class MovieResource extends Equatable {
  final int? id;
  final String? title;
  final List<AlternativeTitleResource>? alternateTitles;
  final int? secondaryYearSourceId;
  final String? sortTitle;
  final int? sizeOnDisk;
  final String? status;
  final String? overview;
  final DateTime? inCinemas;
  final DateTime? physicalRelease;
  final DateTime? digitalRelease;
  final List<MediaCover>? images;
  final String? website;
  final bool? downloaded;
  final int? year;
  final bool? hasFile;
  final String? youTubeTrailerId;
  final String? studio;
  final String? path;
  final int? qualityProfileId;
  final bool? monitored;
  final String? minimumAvailability;
  final bool? isAvailable;
  final String? folderName;
  final int? runtime;
  final String? cleanTitle;
  final String? imdbId;
  final int? tmdbId;
  final String? titleSlug;
  final String? certification;
  final List<String>? genres;
  final List<String>? tags;
  final DateTime? added;
  final MovieRatings? ratings;
  final MovieFileResource? movieFile;
  final CollectionResource? collection;
  final MovieStatisticsResource? statistics;

  const MovieResource({
    this.id,
    this.title,
    this.alternateTitles,
    this.secondaryYearSourceId,
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
    this.movieFile,
    this.collection,
    this.statistics,
  });

  @override
  List<Object?> get props => [
    id, title, alternateTitles, secondaryYearSourceId, sortTitle, sizeOnDisk,
    status, overview, inCinemas, physicalRelease, digitalRelease, images,
    website, downloaded, year, hasFile, youTubeTrailerId, studio, path,
    qualityProfileId, monitored, minimumAvailability, isAvailable, folderName,
    runtime, cleanTitle, imdbId, tmdbId, titleSlug, certification, genres,
    tags, added, ratings, movieFile, collection, statistics
  ];

  factory MovieResource.fromJson(Map<String, dynamic> json) {
    int? parseIntSafe(dynamic value) {
      if (value == null) return null;
      if (value is int) return value;
      if (value is String) return int.tryParse(value);
      return null;
    }

    return MovieResource(
      id: parseIntSafe(json['id']),
      title: json['title'] as String?,
      alternateTitles: (json['alternateTitles'] as List<dynamic>?)
          ?.map((e) => AlternativeTitleResource.fromJson(e as Map<String, dynamic>))
          .toList(),
      secondaryYearSourceId: parseIntSafe(json['secondaryYearSourceId']),
      sortTitle: json['sortTitle'] as String?,
      sizeOnDisk: parseIntSafe(json['sizeOnDisk']),
      status: json['status'] as String?,
      overview: json['overview'] as String?,
      inCinemas: json['inCinemas'] != null ? DateTime.parse(json['inCinemas'] as String) : null,
      physicalRelease: json['physicalRelease'] != null ? DateTime.parse(json['physicalRelease'] as String) : null,
      digitalRelease: json['digitalRelease'] != null ? DateTime.parse(json['digitalRelease'] as String) : null,
      images: (json['images'] as List<dynamic>?)
          ?.map((e) => MediaCover.fromJson(e as Map<String, dynamic>))
          .toList(),
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
      added: json['added'] != null ? DateTime.parse(json['added'] as String) : null,
      ratings: json['ratings'] != null ? MovieRatings.fromJson(json['ratings'] as Map<String, dynamic>) : null,
      movieFile: json['movieFile'] != null ? MovieFileResource.fromJson(json['movieFile'] as Map<String, dynamic>) : null,
      collection: json['collection'] != null ? CollectionResource.fromJson(json['collection'] as Map<String, dynamic>) : null,
      statistics: json['statistics'] != null ? MovieStatisticsResource.fromJson(json['statistics'] as Map<String, dynamic>) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'alternateTitles': alternateTitles?.map((e) => e.toJson()).toList(),
      'secondaryYearSourceId': secondaryYearSourceId,
      'sortTitle': sortTitle,
      'sizeOnDisk': sizeOnDisk,
      'status': status,
      'overview': overview,
      'inCinemas': inCinemas?.toIso8601String(),
      'physicalRelease': physicalRelease?.toIso8601String(),
      'digitalRelease': digitalRelease?.toIso8601String(),
      'images': images?.map((e) => e.toJson()).toList(),
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
      'movieFile': movieFile?.toJson(),
      'collection': collection?.toJson(),
      'statistics': statistics?.toJson(),
    };
  }

  MovieResource copyWith({
    int? id,
    String? title,
    List<AlternativeTitleResource>? alternateTitles,
    int? secondaryYearSourceId,
    String? sortTitle,
    int? sizeOnDisk,
    String? status,
    String? overview,
    DateTime? inCinemas,
    DateTime? physicalRelease,
    DateTime? digitalRelease,
    List<MediaCover>? images,
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
    MovieRatings? ratings,
    MovieFileResource? movieFile,
    CollectionResource? collection,
    MovieStatisticsResource? statistics,
  }) {
    return MovieResource(
      id: id ?? this.id,
      title: title ?? this.title,
      alternateTitles: alternateTitles ?? this.alternateTitles,
      secondaryYearSourceId: secondaryYearSourceId ?? this.secondaryYearSourceId,
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
      movieFile: movieFile ?? this.movieFile,
      collection: collection ?? this.collection,
      statistics: statistics ?? this.statistics,
    );
  }
}
