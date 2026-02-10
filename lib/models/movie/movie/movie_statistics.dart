// ========================================
// Movie Statistics
// Radarr-specific
// ========================================

import 'package:equatable/equatable.dart';

class MovieStatisticsResource extends Equatable {
  final int? movieFileCount;
  final int? sizeOnDisk;
  final List<String>? releaseGroups;

  const MovieStatisticsResource({
    this.movieFileCount,
    this.sizeOnDisk,
    this.releaseGroups,
  });

  @override
  List<Object?> get props => [movieFileCount, sizeOnDisk, releaseGroups];

  factory MovieStatisticsResource.fromJson(Map<String, dynamic> json) {
    int? parseIntSafe(dynamic value) {
      if (value == null) return null;
      if (value is int) return value;
      if (value is String) return int.tryParse(value);
      return null;
    }

    return MovieStatisticsResource(
      movieFileCount: parseIntSafe(json['movieFileCount']),
      sizeOnDisk: parseIntSafe(json['sizeOnDisk']),
      releaseGroups: (json['releaseGroups'] as List<dynamic>?)?.cast<String>(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'movieFileCount': movieFileCount,
      'sizeOnDisk': sizeOnDisk,
      'releaseGroups': releaseGroups,
    };
  }

  MovieStatisticsResource copyWith({
    int? movieFileCount,
    int? sizeOnDisk,
    List<String>? releaseGroups,
  }) {
    return MovieStatisticsResource(
      movieFileCount: movieFileCount ?? this.movieFileCount,
      sizeOnDisk: sizeOnDisk ?? this.sizeOnDisk,
      releaseGroups: releaseGroups ?? this.releaseGroups,
    );
  }
}
