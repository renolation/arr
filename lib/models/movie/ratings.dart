// ========================================
// Movie Ratings
// Radarr-specific detailed ratings with multiple sources
// ========================================

import 'package:equatable/equatable.dart';

class MovieRatings extends Equatable {
  final MovieRating? imdb;
  final MovieRating? tmdb;
  final MovieRating? metacritic;
  final MovieRating? rottenTomatoes;

  const MovieRatings({
    this.imdb,
    this.tmdb,
    this.metacritic,
    this.rottenTomatoes,
  });

  @override
  List<Object?> get props => [imdb, tmdb, metacritic, rottenTomatoes];

  factory MovieRatings.fromJson(Map<String, dynamic> json) {
    return MovieRatings(
      imdb: json['imdb'] != null ? MovieRating.fromJson(json['imdb'] as Map<String, dynamic>) : null,
      tmdb: json['tmdb'] != null ? MovieRating.fromJson(json['tmdb'] as Map<String, dynamic>) : null,
      metacritic: json['metacritic'] != null ? MovieRating.fromJson(json['metacritic'] as Map<String, dynamic>) : null,
      rottenTomatoes: json['rottenTomatoes'] != null ? MovieRating.fromJson(json['rottenTomatoes'] as Map<String, dynamic>) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'imdb': imdb?.toJson(),
      'tmdb': tmdb?.toJson(),
      'metacritic': metacritic?.toJson(),
      'rottenTomatoes': rottenTomatoes?.toJson(),
    };
  }

  MovieRatings copyWith({
    MovieRating? imdb,
    MovieRating? tmdb,
    MovieRating? metacritic,
    MovieRating? rottenTomatoes,
  }) {
    return MovieRatings(
      imdb: imdb ?? this.imdb,
      tmdb: tmdb ?? this.tmdb,
      metacritic: metacritic ?? this.metacritic,
      rottenTomatoes: rottenTomatoes ?? this.rottenTomatoes,
    );
  }
}

class MovieRating extends Equatable {
  final double? votes;
  final double? value;
  final String? type;

  const MovieRating({
    this.votes,
    this.value,
    this.type,
  });

  @override
  List<Object?> get props => [votes, value, type];

  factory MovieRating.fromJson(Map<String, dynamic> json) {
    return MovieRating(
      votes: (json['votes'] as num?)?.toDouble(),
      value: (json['value'] as num?)?.toDouble(),
      type: json['type'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'votes': votes,
      'value': value,
      'type': type,
    };
  }

  MovieRating copyWith({
    double? votes,
    double? value,
    String? type,
  }) {
    return MovieRating(
      votes: votes ?? this.votes,
      value: value ?? this.value,
      type: type ?? this.type,
    );
  }
}
