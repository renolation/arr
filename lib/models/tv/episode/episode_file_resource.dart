// ========================================
// Episode File Resource
// Sonarr-specific
// ========================================

import 'package:arr/models/common/language.dart';
import 'package:arr/models/common/media_info.dart';
import 'package:arr/models/common/quality/quality_model.dart';
import 'package:equatable/equatable.dart';

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
