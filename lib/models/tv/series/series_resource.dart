// ========================================
// Series Resource
// Sonarr-specific (TV Series)
// ========================================

import 'package:arr/models/common/language.dart';
import 'package:arr/models/common/media_cover.dart';
import 'package:arr/models/tv/series/alternate_title.dart';
import 'package:arr/models/tv/season.dart';
import 'package:arr/models/tv/series/series_statistics.dart';
import 'package:arr/models/tv/ratings.dart';
import 'package:equatable/equatable.dart';

class SeriesResource extends Equatable {
  final int? id;
  final String? title;
  final List<AlternateTitleResource>? alternateTitles;
  final String? sortTitle;
  final String? status;
  final String? overview;
  final String? network;
  final String? airTime;
  final List<MediaCover>? images;
  final int? seasonCount;
  final int? totalEpisodeCount;
  final int? episodeCount;
  final int? episodeFileCount;
  final int? sizeOnDisk;
  final String? seriesType;
  final List<Season>? seasons;
  final DateTime? added;
  final int? qualityProfileId;
  final int? languageProfileId;
  final int? runtime;
  final int? tvdbId;
  final int? tvRageId;
  final int? tvMazeId;
  final DateTime? firstAired;
  final DateTime? lastInfoSync;
  final String? cleanTitle;
  final String? imdbId;
  final String? titleSlug;
  final String? rootFolderPath;
  final String? certification;
  final List<String>? genres;
  final List<String>? tags;
  final bool? monitored;
  final bool? useSceneNumbering;
  final SeriesStatistics? statistics;
  final int? year;
  final SeriesRatings? ratings;

  const SeriesResource({
    this.id,
    this.title,
    this.alternateTitles,
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
    this.seasons,
    this.added,
    this.qualityProfileId,
    this.languageProfileId,
    this.runtime,
    this.tvdbId,
    this.tvRageId,
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
    this.useSceneNumbering,
    this.statistics,
    this.year,
    this.ratings,
  });

  @override
  List<Object?> get props => [
    id, title, alternateTitles, sortTitle, status, overview, network, airTime,
    images, seasonCount, totalEpisodeCount, episodeCount, episodeFileCount,
    sizeOnDisk, seriesType, seasons, added, qualityProfileId, languageProfileId,
    runtime, tvdbId, tvRageId, tvMazeId, firstAired, lastInfoSync, cleanTitle,
    imdbId, titleSlug, rootFolderPath, certification, genres, tags, monitored,
    useSceneNumbering, statistics, year, ratings
  ];

  factory SeriesResource.fromJson(Map<String, dynamic> json) {
    return SeriesResource(
      id: json['id'] as int?,
      title: json['title'] as String?,
      alternateTitles: (json['alternateTitles'] as List<dynamic>?)
          ?.map((e) => AlternateTitleResource.fromJson(e as Map<String, dynamic>))
          .toList(),
      sortTitle: json['sortTitle'] as String?,
      status: json['status'] as String?,
      overview: json['overview'] as String?,
      network: json['network'] as String?,
      airTime: json['airTime'] as String?,
      images: (json['images'] as List<dynamic>?)
          ?.map((e) => MediaCover.fromJson(e as Map<String, dynamic>))
          .toList(),
      seasonCount: json['seasonCount'] as int?,
      totalEpisodeCount: json['totalEpisodeCount'] as int?,
      episodeCount: json['episodeCount'] as int?,
      episodeFileCount: json['episodeFileCount'] as int?,
      sizeOnDisk: json['sizeOnDisk'] as int?,
      seriesType: json['seriesType'] as String?,
      seasons: (json['seasons'] as List<dynamic>?)
          ?.map((e) => Season.fromJson(e as Map<String, dynamic>))
          .toList(),
      added: json['added'] != null ? DateTime.parse(json['added'] as String) : null,
      qualityProfileId: json['qualityProfileId'] as int?,
      languageProfileId: json['languageProfileId'] as int?,
      runtime: json['runtime'] as int?,
      tvdbId: json['tvdbId'] as int?,
      tvRageId: json['tvRageId'] as int?,
      tvMazeId: json['tvMazeId'] as int?,
      firstAired: json['firstAired'] != null ? DateTime.parse(json['firstAired'] as String) : null,
      lastInfoSync: json['lastInfoSync'] != null ? DateTime.parse(json['lastInfoSync'] as String) : null,
      cleanTitle: json['cleanTitle'] as String?,
      imdbId: json['imdbId'] as String?,
      titleSlug: json['titleSlug'] as String?,
      rootFolderPath: json['rootFolderPath'] as String?,
      certification: json['certification'] as String?,
      genres: (json['genres'] as List<dynamic>?)?.cast<String>(),
      tags: (json['tags'] as List<dynamic>?)?.cast<String>(),
      monitored: json['monitored'] as bool?,
      useSceneNumbering: json['useSceneNumbering'] as bool?,
      statistics: json['statistics'] != null ? SeriesStatistics.fromJson(json['statistics'] as Map<String, dynamic>) : null,
      year: json['year'] as int?,
      ratings: json['ratings'] != null ? SeriesRatings.fromJson(json['ratings'] as Map<String, dynamic>) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'alternateTitles': alternateTitles?.map((e) => e.toJson()).toList(),
      'sortTitle': sortTitle,
      'status': status,
      'overview': overview,
      'network': network,
      'airTime': airTime,
      'images': images?.map((e) => e.toJson()).toList(),
      'seasonCount': seasonCount,
      'totalEpisodeCount': totalEpisodeCount,
      'episodeCount': episodeCount,
      'episodeFileCount': episodeFileCount,
      'sizeOnDisk': sizeOnDisk,
      'seriesType': seriesType,
      'seasons': seasons?.map((e) => e.toJson()).toList(),
      'added': added?.toIso8601String(),
      'qualityProfileId': qualityProfileId,
      'languageProfileId': languageProfileId,
      'runtime': runtime,
      'tvdbId': tvdbId,
      'tvRageId': tvRageId,
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
      'useSceneNumbering': useSceneNumbering,
      'statistics': statistics?.toJson(),
      'year': year,
      'ratings': ratings?.toJson(),
    };
  }

  SeriesResource copyWith({
    int? id,
    String? title,
    List<AlternateTitleResource>? alternateTitles,
    String? sortTitle,
    String? status,
    String? overview,
    String? network,
    String? airTime,
    List<MediaCover>? images,
    int? seasonCount,
    int? totalEpisodeCount,
    int? episodeCount,
    int? episodeFileCount,
    int? sizeOnDisk,
    String? seriesType,
    List<Season>? seasons,
    DateTime? added,
    int? qualityProfileId,
    int? languageProfileId,
    int? runtime,
    int? tvdbId,
    int? tvRageId,
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
    bool? useSceneNumbering,
    SeriesStatistics? statistics,
    int? year,
    SeriesRatings? ratings,
  }) {
    return SeriesResource(
      id: id ?? this.id,
      title: title ?? this.title,
      alternateTitles: alternateTitles ?? this.alternateTitles,
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
      seasons: seasons ?? this.seasons,
      added: added ?? this.added,
      qualityProfileId: qualityProfileId ?? this.qualityProfileId,
      languageProfileId: languageProfileId ?? this.languageProfileId,
      runtime: runtime ?? this.runtime,
      tvdbId: tvdbId ?? this.tvdbId,
      tvRageId: tvRageId ?? this.tvRageId,
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
      useSceneNumbering: useSceneNumbering ?? this.useSceneNumbering,
      statistics: statistics ?? this.statistics,
      year: year ?? this.year,
      ratings: ratings ?? this.ratings,
    );
  }
}
