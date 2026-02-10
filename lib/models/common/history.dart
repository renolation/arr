// ========================================
// History
// Shared between Sonarr & Radarr (works for both episodeId and movieId)
// ========================================

import 'package:arr/models/common/quality/quality_model.dart';
import 'package:arr/models/common/language.dart';
import 'package:equatable/equatable.dart';

class HistoryResource extends Equatable {
  final int? id;
  final int? episodeId;
  final int? seriesId;
  final int? movieId;
  final String? sourceTitle;
  final QualityModel? quality;
  final bool? qualityCutoffNotMet;
  final DateTime? date;
  final String? downloadId;
  final String? eventType;
  final Map<String, dynamic>? data;
  final List<LanguageResource>? languages;

  const HistoryResource({
    this.id,
    this.episodeId,
    this.seriesId,
    this.movieId,
    this.sourceTitle,
    this.quality,
    this.qualityCutoffNotMet,
    this.date,
    this.downloadId,
    this.eventType,
    this.data,
    this.languages,
  });

  @override
  List<Object?> get props => [id, episodeId, seriesId, movieId, sourceTitle, quality, qualityCutoffNotMet, date, downloadId, eventType, data, languages];

  factory HistoryResource.fromJson(Map<String, dynamic> json) {
    return HistoryResource(
      id: json['id'] as int?,
      episodeId: json['episodeId'] as int?,
      seriesId: json['seriesId'] as int?,
      movieId: json['movieId'] as int?,
      sourceTitle: json['sourceTitle'] as String?,
      quality: json['quality'] != null ? QualityModel.fromJson(json['quality'] as Map<String, dynamic>) : null,
      qualityCutoffNotMet: json['qualityCutoffNotMet'] as bool?,
      date: json['date'] != null ? DateTime.parse(json['date'] as String) : null,
      downloadId: json['downloadId'] as String?,
      eventType: json['eventType'] as String?,
      data: json['data'] as Map<String, dynamic>?,
      languages: (json['languages'] as List<dynamic>?)
          ?.map((e) => LanguageResource.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'episodeId': episodeId,
      'seriesId': seriesId,
      'movieId': movieId,
      'sourceTitle': sourceTitle,
      'quality': quality?.toJson(),
      'qualityCutoffNotMet': qualityCutoffNotMet,
      'date': date?.toIso8601String(),
      'downloadId': downloadId,
      'eventType': eventType,
      'data': data,
      'languages': languages?.map((e) => e.toJson()).toList(),
    };
  }

  HistoryResource copyWith({
    int? id,
    int? episodeId,
    int? seriesId,
    int? movieId,
    String? sourceTitle,
    QualityModel? quality,
    bool? qualityCutoffNotMet,
    DateTime? date,
    String? downloadId,
    String? eventType,
    Map<String, dynamic>? data,
    List<LanguageResource>? languages,
  }) {
    return HistoryResource(
      id: id ?? this.id,
      episodeId: episodeId ?? this.episodeId,
      seriesId: seriesId ?? this.seriesId,
      movieId: movieId ?? this.movieId,
      sourceTitle: sourceTitle ?? this.sourceTitle,
      quality: quality ?? this.quality,
      qualityCutoffNotMet: qualityCutoffNotMet ?? this.qualityCutoffNotMet,
      date: date ?? this.date,
      downloadId: downloadId ?? this.downloadId,
      eventType: eventType ?? this.eventType,
      data: data ?? this.data,
      languages: languages ?? this.languages,
    );
  }
}
