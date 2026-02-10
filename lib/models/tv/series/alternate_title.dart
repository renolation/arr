// ========================================
// Alternate Title (TV Series)
// Sonarr-specific TV alternate titles
// ========================================

import 'package:equatable/equatable.dart';

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
