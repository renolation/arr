// ========================================
// Quality Model
// Shared between Sonarr & Radarr
// ========================================

import 'package:arr/models/common/quality/quality.dart';
import 'package:arr/models/common/quality/quality_revision.dart';
import 'package:equatable/equatable.dart';

class QualityModel extends Equatable {
  final Quality? quality;
  final QualityRevision? revision;

  const QualityModel({
    this.quality,
    this.revision,
  });

  @override
  List<Object?> get props => [quality, revision];

  factory QualityModel.fromJson(Map<String, dynamic> json) {
    return QualityModel(
      quality: json['quality'] != null ? Quality.fromJson(json['quality'] as Map<String, dynamic>) : null,
      revision: json['revision'] != null ? QualityRevision.fromJson(json['revision'] as Map<String, dynamic>) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'quality': quality?.toJson(),
      'revision': revision?.toJson(),
    };
  }

  QualityModel copyWith({
    Quality? quality,
    QualityRevision? revision,
  }) {
    return QualityModel(
      quality: quality ?? this.quality,
      revision: revision ?? this.revision,
    );
  }
}
