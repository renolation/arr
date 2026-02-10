// ========================================
// Series Ratings (TV Series)
// Sonarr-specific simplified ratings
// ========================================

import 'package:equatable/equatable.dart';

class SeriesRatings extends Equatable {
  final SeriesRating? tmdb;

  const SeriesRatings({
    this.tmdb,
  });

  @override
  List<Object?> get props => [tmdb];

  factory SeriesRatings.fromJson(Map<String, dynamic> json) {
    return SeriesRatings(
      tmdb: json['votes'] != null || json['value'] != null
          ? SeriesRating(
              votes: (json['votes'] as num?)?.toDouble(),
              value: (json['value'] as num?)?.toDouble(),
            )
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'votes': tmdb?.votes,
      'value': tmdb?.value,
    };
  }

  SeriesRatings copyWith({
    SeriesRating? tmdb,
  }) {
    return SeriesRatings(
      tmdb: tmdb ?? this.tmdb,
    );
  }
}

class SeriesRating extends Equatable {
  final double? votes;
  final double? value;

  const SeriesRating({
    this.votes,
    this.value,
  });

  @override
  List<Object?> get props => [votes, value];

  SeriesRating copyWith({
    double? votes,
    double? value,
  }) {
    return SeriesRating(
      votes: votes ?? this.votes,
      value: value ?? this.value,
    );
  }
}
