// ========================================
// Season
// Sonarr-specific
// ========================================

import 'package:arr/models/tv/season_statistics.dart';
import 'package:equatable/equatable.dart';

class Season extends Equatable {
  final int? seasonNumber;
  final bool? monitored;
  final SeasonStatistics? statistics;

  const Season({
    this.seasonNumber,
    this.monitored,
    this.statistics,
  });

  @override
  List<Object?> get props => [seasonNumber, monitored, statistics];

  factory Season.fromJson(Map<String, dynamic> json) {
    return Season(
      seasonNumber: json['seasonNumber'] as int?,
      monitored: json['monitored'] as bool?,
      statistics: json['statistics'] != null ? SeasonStatistics.fromJson(json['statistics'] as Map<String, dynamic>) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'seasonNumber': seasonNumber,
      'monitored': monitored,
      'statistics': statistics?.toJson(),
    };
  }

  Season copyWith({
    int? seasonNumber,
    bool? monitored,
    SeasonStatistics? statistics,
  }) {
    return Season(
      seasonNumber: seasonNumber ?? this.seasonNumber,
      monitored: monitored ?? this.monitored,
      statistics: statistics ?? this.statistics,
    );
  }
}
