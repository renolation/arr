// ========================================
// Episode Resource
// Sonarr-specific
// ========================================

import 'package:arr/models/common/media_cover.dart';
import 'package:arr/models/tv/episode/episode_file_resource.dart';
import 'package:arr/models/tv/series/series_resource.dart';
import 'package:equatable/equatable.dart';

class EpisodeResource extends Equatable {
  final int? id;
  final int? seriesId;
  final int? tvdbId;
  final int? episodeFileId;
  final int? seasonNumber;
  final int? episodeNumber;
  final String? title;
  final DateTime? airDate;
  final DateTime? airDateUtc;
  final String? overview;
  final EpisodeFileResource? episodeFile;
  final bool? hasFile;
  final bool? monitored;
  final int? absoluteEpisodeNumber;
  final int? sceneAbsoluteEpisodeNumber;
  final int? sceneEpisodeNumber;
  final int? sceneSeasonNumber;
  final bool? unverifiedSceneNumbering;
  final DateTime? lastSearchTime;
  final SeriesResource? series;
  final List<MediaCover>? images;

  const EpisodeResource({
    this.id,
    this.seriesId,
    this.tvdbId,
    this.episodeFileId,
    this.seasonNumber,
    this.episodeNumber,
    this.title,
    this.airDate,
    this.airDateUtc,
    this.overview,
    this.episodeFile,
    this.hasFile,
    this.monitored,
    this.absoluteEpisodeNumber,
    this.sceneAbsoluteEpisodeNumber,
    this.sceneEpisodeNumber,
    this.sceneSeasonNumber,
    this.unverifiedSceneNumbering,
    this.lastSearchTime,
    this.series,
    this.images,
  });

  @override
  List<Object?> get props => [
    id, seriesId, tvdbId, episodeFileId, seasonNumber, episodeNumber, title,
    airDate, airDateUtc, overview, episodeFile, hasFile, monitored,
    absoluteEpisodeNumber, sceneAbsoluteEpisodeNumber, sceneEpisodeNumber,
    sceneSeasonNumber, unverifiedSceneNumbering, lastSearchTime, series, images
  ];

  factory EpisodeResource.fromJson(Map<String, dynamic> json) {
    return EpisodeResource(
      id: json['id'] as int?,
      seriesId: json['seriesId'] as int?,
      tvdbId: json['tvdbId'] as int?,
      episodeFileId: json['episodeFileId'] as int?,
      seasonNumber: json['seasonNumber'] as int?,
      episodeNumber: json['episodeNumber'] as int?,
      title: json['title'] as String?,
      airDate: json['airDate'] != null ? DateTime.parse(json['airDate'] as String) : null,
      airDateUtc: json['airDateUtc'] != null ? DateTime.parse(json['airDateUtc'] as String) : null,
      overview: json['overview'] as String?,
      episodeFile: json['episodeFile'] != null ? EpisodeFileResource.fromJson(json['episodeFile'] as Map<String, dynamic>) : null,
      hasFile: json['hasFile'] as bool?,
      monitored: json['monitored'] as bool?,
      absoluteEpisodeNumber: json['absoluteEpisodeNumber'] as int?,
      sceneAbsoluteEpisodeNumber: json['sceneAbsoluteEpisodeNumber'] as int?,
      sceneEpisodeNumber: json['sceneEpisodeNumber'] as int?,
      sceneSeasonNumber: json['sceneSeasonNumber'] as int?,
      unverifiedSceneNumbering: json['unverifiedSceneNumbering'] as bool?,
      lastSearchTime: json['lastSearchTime'] != null ? DateTime.parse(json['lastSearchTime'] as String) : null,
      series: json['series'] != null ? SeriesResource.fromJson(json['series'] as Map<String, dynamic>) : null,
      images: (json['images'] as List<dynamic>?)
          ?.map((e) => MediaCover.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'seriesId': seriesId,
      'tvdbId': tvdbId,
      'episodeFileId': episodeFileId,
      'seasonNumber': seasonNumber,
      'episodeNumber': episodeNumber,
      'title': title,
      'airDate': airDate?.toIso8601String(),
      'airDateUtc': airDateUtc?.toIso8601String(),
      'overview': overview,
      'episodeFile': episodeFile?.toJson(),
      'hasFile': hasFile,
      'monitored': monitored,
      'absoluteEpisodeNumber': absoluteEpisodeNumber,
      'sceneAbsoluteEpisodeNumber': sceneAbsoluteEpisodeNumber,
      'sceneEpisodeNumber': sceneEpisodeNumber,
      'sceneSeasonNumber': sceneSeasonNumber,
      'unverifiedSceneNumbering': unverifiedSceneNumbering,
      'lastSearchTime': lastSearchTime?.toIso8601String(),
      'series': series?.toJson(),
      'images': images?.map((e) => e.toJson()).toList(),
    };
  }

  EpisodeResource copyWith({
    int? id,
    int? seriesId,
    int? tvdbId,
    int? episodeFileId,
    int? seasonNumber,
    int? episodeNumber,
    String? title,
    DateTime? airDate,
    DateTime? airDateUtc,
    String? overview,
    EpisodeFileResource? episodeFile,
    bool? hasFile,
    bool? monitored,
    int? absoluteEpisodeNumber,
    int? sceneAbsoluteEpisodeNumber,
    int? sceneEpisodeNumber,
    int? sceneSeasonNumber,
    bool? unverifiedSceneNumbering,
    DateTime? lastSearchTime,
    SeriesResource? series,
    List<MediaCover>? images,
  }) {
    return EpisodeResource(
      id: id ?? this.id,
      seriesId: seriesId ?? this.seriesId,
      tvdbId: tvdbId ?? this.tvdbId,
      episodeFileId: episodeFileId ?? this.episodeFileId,
      seasonNumber: seasonNumber ?? this.seasonNumber,
      episodeNumber: episodeNumber ?? this.episodeNumber,
      title: title ?? this.title,
      airDate: airDate ?? this.airDate,
      airDateUtc: airDateUtc ?? this.airDateUtc,
      overview: overview ?? this.overview,
      episodeFile: episodeFile ?? this.episodeFile,
      hasFile: hasFile ?? this.hasFile,
      monitored: monitored ?? this.monitored,
      absoluteEpisodeNumber: absoluteEpisodeNumber ?? this.absoluteEpisodeNumber,
      sceneAbsoluteEpisodeNumber: sceneAbsoluteEpisodeNumber ?? this.sceneAbsoluteEpisodeNumber,
      sceneEpisodeNumber: sceneEpisodeNumber ?? this.sceneEpisodeNumber,
      sceneSeasonNumber: sceneSeasonNumber ?? this.sceneSeasonNumber,
      unverifiedSceneNumbering: unverifiedSceneNumbering ?? this.unverifiedSceneNumbering,
      lastSearchTime: lastSearchTime ?? this.lastSearchTime,
      series: series ?? this.series,
      images: images ?? this.images,
    );
  }
}
