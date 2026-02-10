// ========================================
// Extra File Resource
// Radarr-specific
// ========================================

import 'package:equatable/equatable.dart';

class ExtraFileResource extends Equatable {
  final int? id;
  final int? movieId;
  final int? movieFileId;
  final String? relativePath;
  final String? extension;
  final String? type;

  const ExtraFileResource({
    this.id,
    this.movieId,
    this.movieFileId,
    this.relativePath,
    this.extension,
    this.type,
  });

  @override
  List<Object?> get props => [id, movieId, movieFileId, relativePath, extension, type];

  factory ExtraFileResource.fromJson(Map<String, dynamic> json) {
    return ExtraFileResource(
      id: json['id'] as int?,
      movieId: json['movieId'] as int?,
      movieFileId: json['movieFileId'] as int?,
      relativePath: json['relativePath'] as String?,
      extension: json['extension'] as String?,
      type: json['type'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'movieId': movieId,
      'movieFileId': movieFileId,
      'relativePath': relativePath,
      'extension': extension,
      'type': type,
    };
  }

  ExtraFileResource copyWith({
    int? id,
    int? movieId,
    int? movieFileId,
    String? relativePath,
    String? extension,
    String? type,
  }) {
    return ExtraFileResource(
      id: id ?? this.id,
      movieId: movieId ?? this.movieId,
      movieFileId: movieFileId ?? this.movieFileId,
      relativePath: relativePath ?? this.relativePath,
      extension: extension ?? this.extension,
      type: type ?? this.type,
    );
  }
}
