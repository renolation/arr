// ========================================
// Season Statistics
// Sonarr-specific
// ========================================

import 'package:equatable/equatable.dart';

class SeasonStatistics extends Equatable {
  final DateTime? previousAiring;
  final int? episodeFileCount;
  final int? episodeCount;
  final int? totalEpisodeCount;
  final int? sizeOnDisk;
  final double? percentOfEpisodes;

  const SeasonStatistics({
    this.previousAiring,
    this.episodeFileCount,
    this.episodeCount,
    this.totalEpisodeCount,
    this.sizeOnDisk,
    this.percentOfEpisodes,
  });

  @override
  List<Object?> get props => [previousAiring, episodeFileCount, episodeCount, totalEpisodeCount, sizeOnDisk, percentOfEpisodes];

  factory SeasonStatistics.fromJson(Map<String, dynamic> json) {
    return SeasonStatistics(
      previousAiring: json['previousAiring'] != null ? DateTime.parse(json['previousAiring'] as String) : null,
      episodeFileCount: json['episodeFileCount'] as int?,
      episodeCount: json['episodeCount'] as int?,
      totalEpisodeCount: json['totalEpisodeCount'] as int?,
      sizeOnDisk: json['sizeOnDisk'] as int?,
      percentOfEpisodes: (json['percentOfEpisodes'] as num?)?.toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'previousAiring': previousAiring?.toIso8601String(),
      'episodeFileCount': episodeFileCount,
      'episodeCount': episodeCount,
      'totalEpisodeCount': totalEpisodeCount,
      'sizeOnDisk': sizeOnDisk,
      'percentOfEpisodes': percentOfEpisodes,
    };
  }

  SeasonStatistics copyWith({
    DateTime? previousAiring,
    int? episodeFileCount,
    int? episodeCount,
    int? totalEpisodeCount,
    int? sizeOnDisk,
    double? percentOfEpisodes,
  }) {
    return SeasonStatistics(
      previousAiring: previousAiring ?? this.previousAiring,
      episodeFileCount: episodeFileCount ?? this.episodeFileCount,
      episodeCount: episodeCount ?? this.episodeCount,
      totalEpisodeCount: totalEpisodeCount ?? this.totalEpisodeCount,
      sizeOnDisk: sizeOnDisk ?? this.sizeOnDisk,
      percentOfEpisodes: percentOfEpisodes ?? this.percentOfEpisodes,
    );
  }
}
