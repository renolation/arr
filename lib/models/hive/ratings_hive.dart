// ========================================
// Ratings Hive Model
// Store media ratings from various sources
// ========================================

import 'package:hive/hive.dart';

part 'ratings_hive.g.dart';

@HiveType(typeId: 111)
class RatingsHive extends HiveObject {
  @HiveField(0)
  final double? votes;

  @HiveField(1)
  final double? value;

  @HiveField(2)
  final int? tmdbId;

  @HiveField(3)
  final String? imdbId;

  RatingsHive({
    this.votes,
    this.value,
    this.tmdbId,
    this.imdbId,
  });

  /// Convert from API ratings model
  factory RatingsHive.fromJson(Map<String, dynamic> json) {
    return RatingsHive(
      votes: (json['votes'] as num?)?.toDouble(),
      value: (json['value'] as num?)?.toDouble(),
      tmdbId: json['tmdbId'] as int?,
      imdbId: json['imdbId'] as String?,
    );
  }

  /// Convert from API model object
  static RatingsHive? fromDynamic(dynamic ratings) {
    if (ratings == null) return null;

    if (ratings is Map) {
      return RatingsHive.fromJson(ratings as Map<String, dynamic>);
    }

    return null;
  }

  /// Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'votes': votes,
      'value': value,
      'tmdbId': tmdbId,
      'imdbId': imdbId,
    };
  }

  /// Create a copy with modified fields
  RatingsHive copyWith({
    double? votes,
    double? value,
    int? tmdbId,
    String? imdbId,
  }) {
    return RatingsHive(
      votes: votes ?? this.votes,
      value: value ?? this.value,
      tmdbId: tmdbId ?? this.tmdbId,
      imdbId: imdbId ?? this.imdbId,
    );
  }
}
