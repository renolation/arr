// ========================================
// Movie File Resource
// Radarr-specific
// ========================================

import 'package:arr/models/common/language.dart';
import 'package:arr/models/common/media_info.dart';
import 'package:arr/models/common/quality/quality_model.dart';
import 'package:equatable/equatable.dart';

class MovieFileResource extends Equatable {
  final int? id;
  final int? movieId;
  final String? relativePath;
  final String? path;
  final int? size;
  final DateTime? dateAdded;
  final String? sceneName;
  final int? indexerFlags;
  final QualityModel? quality;
  final MediaInfoResource? mediaInfo;
  final String? originalFilePath;
  final bool? qualityCutoffNotMet;
  final List<LanguageResource>? languages;
  final String? releaseGroup;
  final String? edition;

  const MovieFileResource({
    this.id,
    this.movieId,
    this.relativePath,
    this.path,
    this.size,
    this.dateAdded,
    this.sceneName,
    this.indexerFlags,
    this.quality,
    this.mediaInfo,
    this.originalFilePath,
    this.qualityCutoffNotMet,
    this.languages,
    this.releaseGroup,
    this.edition,
  });

  @override
  List<Object?> get props => [id, movieId, relativePath, path, size, dateAdded, sceneName, indexerFlags, quality, mediaInfo, originalFilePath, qualityCutoffNotMet, languages, releaseGroup, edition];

  factory MovieFileResource.fromJson(Map<String, dynamic> json) {
    int? parseIntSafe(dynamic value) {
      if (value == null) return null;
      if (value is int) return value;
      if (value is String) return int.tryParse(value);
      return null;
    }

    return MovieFileResource(
      id: parseIntSafe(json['id']),
      movieId: parseIntSafe(json['movieId']),
      relativePath: json['relativePath'] as String?,
      path: json['path'] as String?,
      size: parseIntSafe(json['size']),
      dateAdded: json['dateAdded'] != null ? DateTime.parse(json['dateAdded'] as String) : null,
      sceneName: json['sceneName'] as String?,
      indexerFlags: parseIntSafe(json['indexerFlags']),
      quality: json['quality'] != null ? QualityModel.fromJson(json['quality'] as Map<String, dynamic>) : null,
      mediaInfo: json['mediaInfo'] != null ? MediaInfoResource.fromJson(json['mediaInfo'] as Map<String, dynamic>) : null,
      originalFilePath: json['originalFilePath'] as String?,
      qualityCutoffNotMet: json['qualityCutoffNotMet'] as bool?,
      languages: (json['languages'] as List<dynamic>?)?.map((e) => LanguageResource.fromJson(e as Map<String, dynamic>)).toList(),
      releaseGroup: json['releaseGroup'] as String?,
      edition: json['edition'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'movieId': movieId,
      'relativePath': relativePath,
      'path': path,
      'size': size,
      'dateAdded': dateAdded?.toIso8601String(),
      'sceneName': sceneName,
      'indexerFlags': indexerFlags,
      'quality': quality?.toJson(),
      'mediaInfo': mediaInfo?.toJson(),
      'originalFilePath': originalFilePath,
      'qualityCutoffNotMet': qualityCutoffNotMet,
      'languages': languages?.map((e) => e.toJson()).toList(),
      'releaseGroup': releaseGroup,
      'edition': edition,
    };
  }

  MovieFileResource copyWith({
    int? id,
    int? movieId,
    String? relativePath,
    String? path,
    int? size,
    DateTime? dateAdded,
    String? sceneName,
    int? indexerFlags,
    QualityModel? quality,
    MediaInfoResource? mediaInfo,
    String? originalFilePath,
    bool? qualityCutoffNotMet,
    List<LanguageResource>? languages,
    String? releaseGroup,
    String? edition,
  }) {
    return MovieFileResource(
      id: id ?? this.id,
      movieId: movieId ?? this.movieId,
      relativePath: relativePath ?? this.relativePath,
      path: path ?? this.path,
      size: size ?? this.size,
      dateAdded: dateAdded ?? this.dateAdded,
      sceneName: sceneName ?? this.sceneName,
      indexerFlags: indexerFlags ?? this.indexerFlags,
      quality: quality ?? this.quality,
      mediaInfo: mediaInfo ?? this.mediaInfo,
      originalFilePath: originalFilePath ?? this.originalFilePath,
      qualityCutoffNotMet: qualityCutoffNotMet ?? this.qualityCutoffNotMet,
      languages: languages ?? this.languages,
      releaseGroup: releaseGroup ?? this.releaseGroup,
      edition: edition ?? this.edition,
    );
  }
}
