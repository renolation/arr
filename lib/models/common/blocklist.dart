// ========================================
// Blocklist
// Shared between Sonarr & Radarr (works for both seriesId and movieId)
// ========================================

import 'package:arr/models/common/quality/quality_model.dart';
import 'package:arr/models/common/language.dart';
import 'package:equatable/equatable.dart';

class BlocklistResource extends Equatable {
  final int? id;
  final int? seriesId;
  final int? movieId;
  final List<int>? episodeIds;
  final String? sourceTitle;
  final QualityModel? quality;
  final DateTime? date;
  final String? protocol;
  final String? indexer;
  final String? message;
  final List<LanguageResource>? languages;

  const BlocklistResource({
    this.id,
    this.seriesId,
    this.movieId,
    this.episodeIds,
    this.sourceTitle,
    this.quality,
    this.date,
    this.protocol,
    this.indexer,
    this.message,
    this.languages,
  });

  @override
  List<Object?> get props => [id, seriesId, movieId, episodeIds, sourceTitle, quality, date, protocol, indexer, message, languages];

  factory BlocklistResource.fromJson(Map<String, dynamic> json) {
    return BlocklistResource(
      id: json['id'] as int?,
      seriesId: json['seriesId'] as int?,
      movieId: json['movieId'] as int?,
      episodeIds: (json['episodeIds'] as List<dynamic>?)?.cast<int>(),
      sourceTitle: json['sourceTitle'] as String?,
      quality: json['quality'] != null ? QualityModel.fromJson(json['quality'] as Map<String, dynamic>) : null,
      date: json['date'] != null ? DateTime.parse(json['date'] as String) : null,
      protocol: json['protocol'] as String?,
      indexer: json['indexer'] as String?,
      message: json['message'] as String?,
      languages: (json['languages'] as List<dynamic>?)
          ?.map((e) => LanguageResource.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'seriesId': seriesId,
      'movieId': movieId,
      'episodeIds': episodeIds,
      'sourceTitle': sourceTitle,
      'quality': quality?.toJson(),
      'date': date?.toIso8601String(),
      'protocol': protocol,
      'indexer': indexer,
      'message': message,
      'languages': languages?.map((e) => e.toJson()).toList(),
    };
  }

  BlocklistResource copyWith({
    int? id,
    int? seriesId,
    int? movieId,
    List<int>? episodeIds,
    String? sourceTitle,
    QualityModel? quality,
    DateTime? date,
    String? protocol,
    String? indexer,
    String? message,
    List<LanguageResource>? languages,
  }) {
    return BlocklistResource(
      id: id ?? this.id,
      seriesId: seriesId ?? this.seriesId,
      movieId: movieId ?? this.movieId,
      episodeIds: episodeIds ?? this.episodeIds,
      sourceTitle: sourceTitle ?? this.sourceTitle,
      quality: quality ?? this.quality,
      date: date ?? this.date,
      protocol: protocol ?? this.protocol,
      indexer: indexer ?? this.indexer,
      message: message ?? this.message,
      languages: languages ?? this.languages,
    );
  }
}
