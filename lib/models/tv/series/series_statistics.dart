// ========================================
// Series Statistics
// Sonarr-specific
// ========================================

import 'package:equatable/equatable.dart';

class SeriesStatistics extends Equatable {
  final int? seasonCount;
  final int? episodeFileCount;
  final int? episodeCount;
  final int? totalEpisodeCount;
  final int? sizeOnDisk;
  final List<String>? releaseGroups;
  final double? percentOfEpisodes;

  const SeriesStatistics({
    this.seasonCount,
    this.episodeFileCount,
    this.episodeCount,
    this.totalEpisodeCount,
    this.sizeOnDisk,
    this.releaseGroups,
    this.percentOfEpisodes,
  });

  @override
  List<Object?> get props => [seasonCount, episodeFileCount, episodeCount, totalEpisodeCount, sizeOnDisk, releaseGroups, percentOfEpisodes];

  factory SeriesStatistics.fromJson(Map<String, dynamic> json) {
    return SeriesStatistics(
      seasonCount: json['seasonCount'] as int?,
      episodeFileCount: json['episodeFileCount'] as int?,
      episodeCount: json['episodeCount'] as int?,
      totalEpisodeCount: json['totalEpisodeCount'] as int?,
      sizeOnDisk: json['sizeOnDisk'] as int?,
      releaseGroups: (json['releaseGroups'] as List<dynamic>?)?.cast<String>(),
      percentOfEpisodes: (json['percentOfEpisodes'] as num?)?.toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'seasonCount': seasonCount,
      'episodeFileCount': episodeFileCount,
      'episodeCount': episodeCount,
      'totalEpisodeCount': totalEpisodeCount,
      'sizeOnDisk': sizeOnDisk,
      'releaseGroups': releaseGroups,
      'percentOfEpisodes': percentOfEpisodes,
    };
  }

  SeriesStatistics copyWith({
    int? seasonCount,
    int? episodeFileCount,
    int? episodeCount,
    int? totalEpisodeCount,
    int? sizeOnDisk,
    List<String>? releaseGroups,
    double? percentOfEpisodes,
  }) {
    return SeriesStatistics(
      seasonCount: seasonCount ?? this.seasonCount,
      episodeFileCount: episodeFileCount ?? this.episodeFileCount,
      episodeCount: episodeCount ?? this.episodeCount,
      totalEpisodeCount: totalEpisodeCount ?? this.totalEpisodeCount,
      sizeOnDisk: sizeOnDisk ?? this.sizeOnDisk,
      releaseGroups: releaseGroups ?? this.releaseGroups,
      percentOfEpisodes: percentOfEpisodes ?? this.percentOfEpisodes,
    );
  }
}
