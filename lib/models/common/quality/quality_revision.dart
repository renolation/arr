// ========================================
// Quality Revision
// Shared between Sonarr & Radarr
// ========================================

import 'package:equatable/equatable.dart';

class QualityRevision extends Equatable {
  final int? version;
  final int? real;
  final bool? isRepack;

  const QualityRevision({
    this.version,
    this.real,
    this.isRepack,
  });

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

  QualityRevision copyWith({
    int? version,
    int? real,
    bool? isRepack,
  }) {
    return QualityRevision(
      version: version ?? this.version,
      real: real ?? this.real,
      isRepack: isRepack ?? this.isRepack,
    );
  }
}
