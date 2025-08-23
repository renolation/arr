// ========================================
// Sonarr-Specific Models (TV Series Management)
// Series, Episode, EpisodeFile, NamingConfig, LanguageProfile
// ========================================

import 'package:arr/models/part_1.dart';
import 'package:equatable/equatable.dart';

// ========================================
// Series Resource
// ========================================

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
  });

  @override
  List<Object?> get props => [id, title, alternateTitles, sortTitle, status, overview, network, airTime, images, seasonCount, totalEpisodeCount, episodeCount, episodeFileCount, sizeOnDisk, seriesType, seasons, added, qualityProfileId, languageProfileId, runtime, tvdbId, tvRageId, tvMazeId, firstAired, lastInfoSync, cleanTitle, imdbId, titleSlug, rootFolderPath, certification, genres, tags, monitored, useSceneNumbering, statistics];

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
    );
  }
}

// ========================================
// Episode Resource
// ========================================

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
  List<Object?> get props => [id, seriesId, tvdbId, episodeFileId, seasonNumber, episodeNumber, title, airDate, airDateUtc, overview, episodeFile, hasFile, monitored, absoluteEpisodeNumber, sceneAbsoluteEpisodeNumber, sceneEpisodeNumber, sceneSeasonNumber, unverifiedSceneNumbering, lastSearchTime, series, images];

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

// ========================================
// Episode File Resource
// ========================================

class EpisodeFileResource extends Equatable {
  final int? id;
  final int? seriesId;
  final int? seasonNumber;
  final String? relativePath;
  final String? path;
  final int? size;
  final DateTime? dateAdded;
  final String? sceneName;
  final String? releaseGroup;
  final QualityModel? quality;
  final List<LanguageResource>? languages;
  final MediaInfoResource? mediaInfo;
  final bool? qualityCutoffNotMet;
  final List<int>? episodeIds;

  const EpisodeFileResource({
    this.id,
    this.seriesId,
    this.seasonNumber,
    this.relativePath,
    this.path,
    this.size,
    this.dateAdded,
    this.sceneName,
    this.releaseGroup,
    this.quality,
    this.languages,
    this.mediaInfo,
    this.qualityCutoffNotMet,
    this.episodeIds,
  });

  @override
  List<Object?> get props => [id, seriesId, seasonNumber, relativePath, path, size, dateAdded, sceneName, releaseGroup, quality, languages, mediaInfo, qualityCutoffNotMet, episodeIds];

  factory EpisodeFileResource.fromJson(Map<String, dynamic> json) {
    return EpisodeFileResource(
      id: json['id'] as int?,
      seriesId: json['seriesId'] as int?,
      seasonNumber: json['seasonNumber'] as int?,
      relativePath: json['relativePath'] as String?,
      path: json['path'] as String?,
      size: json['size'] as int?,
      dateAdded: json['dateAdded'] != null ? DateTime.parse(json['dateAdded'] as String) : null,
      sceneName: json['sceneName'] as String?,
      releaseGroup: json['releaseGroup'] as String?,
      quality: json['quality'] != null ? QualityModel.fromJson(json['quality'] as Map<String, dynamic>) : null,
      languages: (json['languages'] as List<dynamic>?)
          ?.map((e) => LanguageResource.fromJson(e as Map<String, dynamic>))
          .toList(),
      mediaInfo: json['mediaInfo'] != null ? MediaInfoResource.fromJson(json['mediaInfo'] as Map<String, dynamic>) : null,
      qualityCutoffNotMet: json['qualityCutoffNotMet'] as bool?,
      episodeIds: (json['episodeIds'] as List<dynamic>?)?.cast<int>(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'seriesId': seriesId,
      'seasonNumber': seasonNumber,
      'relativePath': relativePath,
      'path': path,
      'size': size,
      'dateAdded': dateAdded?.toIso8601String(),
      'sceneName': sceneName,
      'releaseGroup': releaseGroup,
      'quality': quality?.toJson(),
      'languages': languages?.map((e) => e.toJson()).toList(),
      'mediaInfo': mediaInfo?.toJson(),
      'qualityCutoffNotMet': qualityCutoffNotMet,
      'episodeIds': episodeIds,
    };
  }

  EpisodeFileResource copyWith({
    int? id,
    int? seriesId,
    int? seasonNumber,
    String? relativePath,
    String? path,
    int? size,
    DateTime? dateAdded,
    String? sceneName,
    String? releaseGroup,
    QualityModel? quality,
    List<LanguageResource>? languages,
    MediaInfoResource? mediaInfo,
    bool? qualityCutoffNotMet,
    List<int>? episodeIds,
  }) {
    return EpisodeFileResource(
      id: id ?? this.id,
      seriesId: seriesId ?? this.seriesId,
      seasonNumber: seasonNumber ?? this.seasonNumber,
      relativePath: relativePath ?? this.relativePath,
      path: path ?? this.path,
      size: size ?? this.size,
      dateAdded: dateAdded ?? this.dateAdded,
      sceneName: sceneName ?? this.sceneName,
      releaseGroup: releaseGroup ?? this.releaseGroup,
      quality: quality ?? this.quality,
      languages: languages ?? this.languages,
      mediaInfo: mediaInfo ?? this.mediaInfo,
      qualityCutoffNotMet: qualityCutoffNotMet ?? this.qualityCutoffNotMet,
      episodeIds: episodeIds ?? this.episodeIds,
    );
  }
}

// ========================================
// Naming Config Resource
// ========================================

class NamingConfigResource extends Equatable {
  final int? id;
  final bool? renameEpisodes;
  final bool? replaceIllegalCharacters;
  final String? standardEpisodeFormat;
  final String? dailyEpisodeFormat;
  final String? animeEpisodeFormat;
  final String? seriesFolderFormat;
  final String? seasonFolderFormat;
  final String? specialsFolderFormat;
  final int? multiEpisodeStyle;
  final int? colonReplacementFormat;
  final String? customColonReplacementFormat;

  const NamingConfigResource({
    this.id,
    this.renameEpisodes,
    this.replaceIllegalCharacters,
    this.standardEpisodeFormat,
    this.dailyEpisodeFormat,
    this.animeEpisodeFormat,
    this.seriesFolderFormat,
    this.seasonFolderFormat,
    this.specialsFolderFormat,
    this.multiEpisodeStyle,
    this.colonReplacementFormat,
    this.customColonReplacementFormat,
  });

  @override
  List<Object?> get props => [id, renameEpisodes, replaceIllegalCharacters, standardEpisodeFormat, dailyEpisodeFormat, animeEpisodeFormat, seriesFolderFormat, seasonFolderFormat, specialsFolderFormat, multiEpisodeStyle, colonReplacementFormat, customColonReplacementFormat];

  factory NamingConfigResource.fromJson(Map<String, dynamic> json) {
    return NamingConfigResource(
      id: json['id'] as int?,
      renameEpisodes: json['renameEpisodes'] as bool?,
      replaceIllegalCharacters: json['replaceIllegalCharacters'] as bool?,
      standardEpisodeFormat: json['standardEpisodeFormat'] as String?,
      dailyEpisodeFormat: json['dailyEpisodeFormat'] as String?,
      animeEpisodeFormat: json['animeEpisodeFormat'] as String?,
      seriesFolderFormat: json['seriesFolderFormat'] as String?,
      seasonFolderFormat: json['seasonFolderFormat'] as String?,
      specialsFolderFormat: json['specialsFolderFormat'] as String?,
      multiEpisodeStyle: json['multiEpisodeStyle'] as int?,
      colonReplacementFormat: json['colonReplacementFormat'] as int?,
      customColonReplacementFormat: json['customColonReplacementFormat'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'renameEpisodes': renameEpisodes,
      'replaceIllegalCharacters': replaceIllegalCharacters,
      'standardEpisodeFormat': standardEpisodeFormat,
      'dailyEpisodeFormat': dailyEpisodeFormat,
      'animeEpisodeFormat': animeEpisodeFormat,
      'seriesFolderFormat': seriesFolderFormat,
      'seasonFolderFormat': seasonFolderFormat,
      'specialsFolderFormat': specialsFolderFormat,
      'multiEpisodeStyle': multiEpisodeStyle,
      'colonReplacementFormat': colonReplacementFormat,
      'customColonReplacementFormat': customColonReplacementFormat,
    };
  }

  NamingConfigResource copyWith({
    int? id,
    bool? renameEpisodes,
    bool? replaceIllegalCharacters,
    String? standardEpisodeFormat,
    String? dailyEpisodeFormat,
    String? animeEpisodeFormat,
    String? seriesFolderFormat,
    String? seasonFolderFormat,
    String? specialsFolderFormat,
    int? multiEpisodeStyle,
    int? colonReplacementFormat,
    String? customColonReplacementFormat,
  }) {
    return NamingConfigResource(
      id: id ?? this.id,
      renameEpisodes: renameEpisodes ?? this.renameEpisodes,
      replaceIllegalCharacters: replaceIllegalCharacters ?? this.replaceIllegalCharacters,
      standardEpisodeFormat: standardEpisodeFormat ?? this.standardEpisodeFormat,
      dailyEpisodeFormat: dailyEpisodeFormat ?? this.dailyEpisodeFormat,
      animeEpisodeFormat: animeEpisodeFormat ?? this.animeEpisodeFormat,
      seriesFolderFormat: seriesFolderFormat ?? this.seriesFolderFormat,
      seasonFolderFormat: seasonFolderFormat ?? this.seasonFolderFormat,
      specialsFolderFormat: specialsFolderFormat ?? this.specialsFolderFormat,
      multiEpisodeStyle: multiEpisodeStyle ?? this.multiEpisodeStyle,
      colonReplacementFormat: colonReplacementFormat ?? this.colonReplacementFormat,
      customColonReplacementFormat: customColonReplacementFormat ?? this.customColonReplacementFormat,
    );
  }
}

// ========================================
// Language Profile Resource (Deprecated)
// ========================================

class LanguageProfileResource extends Equatable {
  final int? id;
  final String? name;
  final bool? upgradeAllowed;
  final int? cutoff;
  final List<LanguageProfileItem>? languages;

  const LanguageProfileResource({
    this.id,
    this.name,
    this.upgradeAllowed,
    this.cutoff,
    this.languages,
  });

  @override
  List<Object?> get props => [id, name, upgradeAllowed, cutoff, languages];

  factory LanguageProfileResource.fromJson(Map<String, dynamic> json) {
    return LanguageProfileResource(
      id: json['id'] as int?,
      name: json['name'] as String?,
      upgradeAllowed: json['upgradeAllowed'] as bool?,
      cutoff: json['cutoff'] as int?,
      languages: (json['languages'] as List<dynamic>?)
          ?.map((e) => LanguageProfileItem.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'upgradeAllowed': upgradeAllowed,
      'cutoff': cutoff,
      'languages': languages?.map((e) => e.toJson()).toList(),
    };
  }

  LanguageProfileResource copyWith({
    int? id,
    String? name,
    bool? upgradeAllowed,
    int? cutoff,
    List<LanguageProfileItem>? languages,
  }) {
    return LanguageProfileResource(
      id: id ?? this.id,
      name: name ?? this.name,
      upgradeAllowed: upgradeAllowed ?? this.upgradeAllowed,
      cutoff: cutoff ?? this.cutoff,
      languages: languages ?? this.languages,
    );
  }
}

// ========================================
// Supporting Classes
// ========================================

class AlternateTitleResource extends Equatable {
  final String? title;
  final int? seasonNumber;
  final int? sceneSeasonNumber;
  final String? sceneOrigin;
  final String? comment;

  const AlternateTitleResource({
    this.title,
    this.seasonNumber,
    this.sceneSeasonNumber,
    this.sceneOrigin,
    this.comment,
  });

  @override
  List<Object?> get props => [title, seasonNumber, sceneSeasonNumber, sceneOrigin, comment];

  factory AlternateTitleResource.fromJson(Map<String, dynamic> json) {
    return AlternateTitleResource(
      title: json['title'] as String?,
      seasonNumber: json['seasonNumber'] as int?,
      sceneSeasonNumber: json['sceneSeasonNumber'] as int?,
      sceneOrigin: json['sceneOrigin'] as String?,
      comment: json['comment'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'seasonNumber': seasonNumber,
      'sceneSeasonNumber': sceneSeasonNumber,
      'sceneOrigin': sceneOrigin,
      'comment': comment,
    };
  }

  AlternateTitleResource copyWith({
    String? title,
    int? seasonNumber,
    int? sceneSeasonNumber,
    String? sceneOrigin,
    String? comment,
  }) {
    return AlternateTitleResource(
      title: title ?? this.title,
      seasonNumber: seasonNumber ?? this.seasonNumber,
      sceneSeasonNumber: sceneSeasonNumber ?? this.sceneSeasonNumber,
      sceneOrigin: sceneOrigin ?? this.sceneOrigin,
      comment: comment ?? this.comment,
    );
  }
}

class Season extends Equatable {
  final int? seasonNumber;
  final bool? monitored;
  final SeasonStatistics? statistics;

  const Season({
    this.seasonNumber,
    this.monitored,
    this.statistics,
  });

  @override
  List<Object?> get props => [seasonNumber, monitored, statistics];

  factory Season.fromJson(Map<String, dynamic> json) {
    return Season(
      seasonNumber: json['seasonNumber'] as int?,
      monitored: json['monitored'] as bool?,
      statistics: json['statistics'] != null ? SeasonStatistics.fromJson(json['statistics'] as Map<String, dynamic>) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'seasonNumber': seasonNumber,
      'monitored': monitored,
      'statistics': statistics?.toJson(),
    };
  }

  Season copyWith({
    int? seasonNumber,
    bool? monitored,
    SeasonStatistics? statistics,
  }) {
    return Season(
      seasonNumber: seasonNumber ?? this.seasonNumber,
      monitored: monitored ?? this.monitored,
      statistics: statistics ?? this.statistics,
    );
  }
}

class MediaCover extends Equatable {
  final String? coverType;
  final String? url;
  final String? remoteUrl;

  const MediaCover({
    this.coverType,
    this.url,
    this.remoteUrl,
  });

  @override
  List<Object?> get props => [coverType, url, remoteUrl];

  factory MediaCover.fromJson(Map<String, dynamic> json) {
    return MediaCover(
      coverType: json['coverType'] as String?,
      url: json['url'] as String?,
      remoteUrl: json['remoteUrl'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'coverType': coverType,
      'url': url,
      'remoteUrl': remoteUrl,
    };
  }

  MediaCover copyWith({
    String? coverType,
    String? url,
    String? remoteUrl,
  }) {
    return MediaCover(
      coverType: coverType ?? this.coverType,
      url: url ?? this.url,
      remoteUrl: remoteUrl ?? this.remoteUrl,
    );
  }
}

class SeriesStatistics extends Equatable {
  final int? seasonCount;
  final int? episodeFileCount;
  final int? episodeCount;
  final int? totalEpisodeCount;
  final int? sizeOnDisk;
  final double? releaseGroups;
  final double? percentOfEpisodes;

  const SeriesStatistics({
    this.seasonCount,
    this.episodeFileCount,
    this.episodeCount,
    this.totalEpisodeCount,
    this.sizeOnDisk,
    this.releaseGroups,
    this.percentOfEpisodes,
  });

  @override
  List<Object?> get props => [seasonCount, episodeFileCount, episodeCount, totalEpisodeCount, sizeOnDisk, releaseGroups, percentOfEpisodes];

  factory SeriesStatistics.fromJson(Map<String, dynamic> json) {
    return SeriesStatistics(
      seasonCount: json['seasonCount'] as int?,
      episodeFileCount: json['episodeFileCount'] as int?,
      episodeCount: json['episodeCount'] as int?,
      totalEpisodeCount: json['totalEpisodeCount'] as int?,
      sizeOnDisk: json['sizeOnDisk'] as int?,
      releaseGroups: (json['releaseGroups'] as num?)?.toDouble(),
      percentOfEpisodes: (json['percentOfEpisodes'] as num?)?.toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'seasonCount': seasonCount,
      'episodeFileCount': episodeFileCount,
      'episodeCount': episodeCount,
      'totalEpisodeCount': totalEpisodeCount,
      'sizeOnDisk': sizeOnDisk,
      'releaseGroups': releaseGroups,
      'percentOfEpisodes': percentOfEpisodes,
    };
  }

  SeriesStatistics copyWith({
    int? seasonCount,
    int? episodeFileCount,
    int? episodeCount,
    int? totalEpisodeCount,
    int? sizeOnDisk,
    double? releaseGroups,
    double? percentOfEpisodes,
  }) {
    return SeriesStatistics(
      seasonCount: seasonCount ?? this.seasonCount,
      episodeFileCount: episodeFileCount ?? this.episodeFileCount,
      episodeCount: episodeCount ?? this.episodeCount,
      totalEpisodeCount: totalEpisodeCount ?? this.totalEpisodeCount,
      sizeOnDisk: sizeOnDisk ?? this.sizeOnDisk,
      releaseGroups: releaseGroups ?? this.releaseGroups,
      percentOfEpisodes: percentOfEpisodes ?? this.percentOfEpisodes,
    );
  }
}

class SeasonStatistics extends Equatable {
  final DateTime? previousAiring;
  final int? episodeFileCount;
  final int? episodeCount;
  final int? totalEpisodeCount;
  final int? sizeOnDisk;
  final double? percentOfEpisodes;

  const SeasonStatistics({
    this.previousAiring,
    this.episodeFileCount,
    this.episodeCount,
    this.totalEpisodeCount,
    this.sizeOnDisk,
    this.percentOfEpisodes,
  });

  @override
  List<Object?> get props => [previousAiring, episodeFileCount, episodeCount, totalEpisodeCount, sizeOnDisk, percentOfEpisodes];

  factory SeasonStatistics.fromJson(Map<String, dynamic> json) {
    return SeasonStatistics(
      previousAiring: json['previousAiring'] != null ? DateTime.parse(json['previousAiring'] as String) : null,
      episodeFileCount: json['episodeFileCount'] as int?,
      episodeCount: json['episodeCount'] as int?,
      totalEpisodeCount: json['totalEpisodeCount'] as int?,
      sizeOnDisk: json['sizeOnDisk'] as int?,
      percentOfEpisodes: (json['percentOfEpisodes'] as num?)?.toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'previousAiring': previousAiring?.toIso8601String(),
      'episodeFileCount': episodeFileCount,
      'episodeCount': episodeCount,
      'totalEpisodeCount': totalEpisodeCount,
      'sizeOnDisk': sizeOnDisk,
      'percentOfEpisodes': percentOfEpisodes,
    };
  }

  SeasonStatistics copyWith({
    DateTime? previousAiring,
    int? episodeFileCount,
    int? episodeCount,
    int? totalEpisodeCount,
    int? sizeOnDisk,
    double? percentOfEpisodes,
  }) {
    return SeasonStatistics(
      previousAiring: previousAiring ?? this.previousAiring,
      episodeFileCount: episodeFileCount ?? this.episodeFileCount,
      episodeCount: episodeCount ?? this.episodeCount,
      totalEpisodeCount: totalEpisodeCount ?? this.totalEpisodeCount,
      sizeOnDisk: sizeOnDisk ?? this.sizeOnDisk,
      percentOfEpisodes: percentOfEpisodes ?? this.percentOfEpisodes,
    );
  }
}

class LanguageProfileItem extends Equatable {
  final LanguageResource? language;
  final bool? allowed;

  const LanguageProfileItem({
    this.language,
    this.allowed,
  });

  @override
  List<Object?> get props => [language, allowed];

  factory LanguageProfileItem.fromJson(Map<String, dynamic> json) {
    return LanguageProfileItem(
      language: json['language'] != null ? LanguageResource.fromJson(json['language'] as Map<String, dynamic>) : null,
      allowed: json['allowed'] as bool?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'language': language?.toJson(),
      'allowed': allowed,
    };
  }

  LanguageProfileItem copyWith({
    LanguageResource? language,
    bool? allowed,
  }) {
    return LanguageProfileItem(
      language: language ?? this.language,
      allowed: allowed ?? this.allowed,
    );
  }
}

class MediaInfoResource extends Equatable {
  final String? audioChannels;
  final String? audioCodec;
  final String? audioLanguages;
  final int? height;
  final String? runTime;
  final String? scanType;
  final String? subtitles;
  final String? videoCodec;
  final String? videoFps;
  final String? videoDynamicRange;
  final String? videoDynamicRangeType;
  final int? width;

  const MediaInfoResource({
    this.audioChannels,
    this.audioCodec,
    this.audioLanguages,
    this.height,
    this.runTime,
    this.scanType,
    this.subtitles,
    this.videoCodec,
    this.videoFps,
    this.videoDynamicRange,
    this.videoDynamicRangeType,
    this.width,
  });

  @override
  List<Object?> get props => [audioChannels, audioCodec, audioLanguages, height, runTime, scanType, subtitles, videoCodec, videoFps, videoDynamicRange, videoDynamicRangeType, width];

  factory MediaInfoResource.fromJson(Map<String, dynamic> json) {
    return MediaInfoResource(
      audioChannels: json['audioChannels'] as String?,
      audioCodec: json['audioCodec'] as String?,
      audioLanguages: json['audioLanguages'] as String?,
      height: json['height'] as int?,
      runTime: json['runTime'] as String?,
      scanType: json['scanType'] as String?,
      subtitles: json['subtitles'] as String?,
      videoCodec: json['videoCodec'] as String?,
      videoFps: json['videoFps'] as String?,
      videoDynamicRange: json['videoDynamicRange'] as String?,
      videoDynamicRangeType: json['videoDynamicRangeType'] as String?,
      width: json['width'] as int?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'audioChannels': audioChannels,
      'audioCodec': audioCodec,
      'audioLanguages': audioLanguages,
      'height': height,
      'runTime': runTime,
      'scanType': scanType,
      'subtitles': subtitles,
      'videoCodec': videoCodec,
      'videoFps': videoFps,
      'videoDynamicRange': videoDynamicRange,
      'videoDynamicRangeType': videoDynamicRangeType,
      'width': width,
    };
  }

  MediaInfoResource copyWith({
    String? audioChannels,
    String? audioCodec,
    String? audioLanguages,
    int? height,
    String? runTime,
    String? scanType,
    String? subtitles,
    String? videoCodec,
    String? videoFps,
    String? videoDynamicRange,
    String? videoDynamicRangeType,
    int? width,
  }) {
    return MediaInfoResource(
      audioChannels: audioChannels ?? this.audioChannels,
      audioCodec: audioCodec ?? this.audioCodec,
      audioLanguages: audioLanguages ?? this.audioLanguages,
      height: height ?? this.height,
      runTime: runTime ?? this.runTime,
      scanType: scanType ?? this.scanType,
      subtitles: subtitles ?? this.subtitles,
      videoCodec: videoCodec ?? this.videoCodec,
      videoFps: videoFps ?? this.videoFps,
      videoDynamicRange: videoDynamicRange ?? this.videoDynamicRange,
      videoDynamicRangeType: videoDynamicRangeType ?? this.videoDynamicRangeType,
      width: width ?? this.width,
    );
  }
}

// Import these from previous parts

class Quality extends Equatable {
  final int? id;
  final String? name;
  final String? source;
  final int? resolution;

  const Quality({this.id, this.name, this.source, this.resolution});

  @override
  List<Object?> get props => [id, name, source, resolution];

  factory Quality.fromJson(Map<String, dynamic> json) {
    return Quality(
      id: json['id'] as int?,
      name: json['name'] as String?,
      source: json['source'] as String?,
      resolution: json['resolution'] as int?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'source': source,
      'resolution': resolution,
    };
  }

  Quality copyWith({int? id, String? name, String? source, int? resolution}) {
    return Quality(
      id: id ?? this.id,
      name: name ?? this.name,
      source: source ?? this.source,
      resolution: resolution ?? this.resolution,
    );
  }
}

class QualityRevision extends Equatable {
  final int? version;
  final int? real;
  final bool? isRepack;

  const QualityRevision({this.version, this.real, this.isRepack});

  @override
  List<Object?> get props => [version, real, isRepack];

  factory QualityRevision.fromJson(Map<String, dynamic> json) {
    return QualityRevision(
      version: json['version'] as int?,
      real: json['real'] as int?,
      isRepack: json['isRepack'] as bool?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'version': version,
      'real': real,
      'isRepack': isRepack,
    };
  }

  QualityRevision copyWith({int? version, int? real, bool? isRepack}) {
    return QualityRevision(
      version: version ?? this.version,
      real: real ?? this.real,
      isRepack: isRepack ?? this.isRepack,
    );
  }
}

