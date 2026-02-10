// ========================================
// Credit Resource
// Radarr-specific
// ========================================

import 'package:arr/models/common/media_cover.dart';
import 'package:equatable/equatable.dart';

class CreditResource extends Equatable {
  final int? id;
  final String? personName;
  final String? creditTmdbId;
  final int? personTmdbId;
  final int? movieMetadataId;
  final List<MediaCover>? images;
  final String? department;
  final String? job;
  final String? character;
  final int? order;
  final String? type;

  const CreditResource({
    this.id,
    this.personName,
    this.creditTmdbId,
    this.personTmdbId,
    this.movieMetadataId,
    this.images,
    this.department,
    this.job,
    this.character,
    this.order,
    this.type,
  });

  @override
  List<Object?> get props => [id, personName, creditTmdbId, personTmdbId, movieMetadataId, images, department, job, character, order, type];

  factory CreditResource.fromJson(Map<String, dynamic> json) {
    return CreditResource(
      id: json['id'] as int?,
      personName: json['personName'] as String?,
      creditTmdbId: json['creditTmdbId'] as String?,
      personTmdbId: json['personTmdbId'] as int?,
      movieMetadataId: json['movieMetadataId'] as int?,
      images: (json['images'] as List<dynamic>?)
          ?.map((e) => MediaCover.fromJson(e as Map<String, dynamic>))
          .toList(),
      department: json['department'] as String?,
      job: json['job'] as String?,
      character: json['character'] as String?,
      order: json['order'] as int?,
      type: json['type'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'personName': personName,
      'creditTmdbId': creditTmdbId,
      'personTmdbId': personTmdbId,
      'movieMetadataId': movieMetadataId,
      'images': images?.map((e) => e.toJson()).toList(),
      'department': department,
      'job': job,
      'character': character,
      'order': order,
      'type': type,
    };
  }

  CreditResource copyWith({
    int? id,
    String? personName,
    String? creditTmdbId,
    int? personTmdbId,
    int? movieMetadataId,
    List<MediaCover>? images,
    String? department,
    String? job,
    String? character,
    int? order,
    String? type,
  }) {
    return CreditResource(
      id: id ?? this.id,
      personName: personName ?? this.personName,
      creditTmdbId: creditTmdbId ?? this.creditTmdbId,
      personTmdbId: personTmdbId ?? this.personTmdbId,
      movieMetadataId: movieMetadataId ?? this.movieMetadataId,
      images: images ?? this.images,
      department: department ?? this.department,
      job: job ?? this.job,
      character: character ?? this.character,
      order: order ?? this.order,
      type: type ?? this.type,
    );
  }
}
