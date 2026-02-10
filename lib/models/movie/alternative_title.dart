// ========================================
// Alternative Title (Movie)
// Radarr-specific movie alternate titles
// ========================================

import 'package:equatable/equatable.dart';

class AlternativeTitleResource extends Equatable {
  final int? id;
  final int? movieMetadataId;
  final String? title;
  final String? cleanTitle;
  final String? sourceType;
  final int? sourceId;
  final int? votes;
  final int? voteCount;
  final String? language;

  const AlternativeTitleResource({
    this.id,
    this.movieMetadataId,
    this.title,
    this.cleanTitle,
    this.sourceType,
    this.sourceId,
    this.votes,
    this.voteCount,
    this.language,
  });

  @override
  List<Object?> get props => [id, movieMetadataId, title, cleanTitle, sourceType, sourceId, votes, voteCount, language];

  factory AlternativeTitleResource.fromJson(Map<String, dynamic> json) {
    return AlternativeTitleResource(
      id: json['id'] as int?,
      movieMetadataId: json['movieMetadataId'] as int?,
      title: json['title'] as String?,
      cleanTitle: json['cleanTitle'] as String?,
      sourceType: json['sourceType'] as String?,
      sourceId: json['sourceId'] as int?,
      votes: json['votes'] as int?,
      voteCount: json['voteCount'] as int?,
      language: json['language'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'movieMetadataId': movieMetadataId,
      'title': title,
      'cleanTitle': cleanTitle,
      'sourceType': sourceType,
      'sourceId': sourceId,
      'votes': votes,
      'voteCount': voteCount,
      'language': language,
    };
  }

  AlternativeTitleResource copyWith({
    int? id,
    int? movieMetadataId,
    String? title,
    String? cleanTitle,
    String? sourceType,
    int? sourceId,
    int? votes,
    int? voteCount,
    String? language,
  }) {
    return AlternativeTitleResource(
      id: id ?? this.id,
      movieMetadataId: movieMetadataId ?? this.movieMetadataId,
      title: title ?? this.title,
      cleanTitle: cleanTitle ?? this.cleanTitle,
      sourceType: sourceType ?? this.sourceType,
      sourceId: sourceId ?? this.sourceId,
      votes: votes ?? this.votes,
      voteCount: voteCount ?? this.voteCount,
      language: language ?? this.language,
    );
  }
}
