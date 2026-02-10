// ========================================
// Collection Movie Resource
// Radarr-specific
// ========================================

import 'package:arr/models/common/media_cover.dart';
import 'package:arr/models/movie/ratings.dart';
import 'package:equatable/equatable.dart';

class CollectionMovieResource extends Equatable {
  final int? tmdbId;
  final String? imdbId;
  final String? title;
  final String? cleanTitle;
  final String? sortTitle;
  final String? status;
  final String? overview;
  final int? runtime;
  final List<MediaCover>? images;
  final int? year;
  final MovieRatings? ratings;
  final List<String>? genres;
  final String? folder;
  final bool? isExisting;
  final bool? isExcluded;

  const CollectionMovieResource({
    this.tmdbId,
    this.imdbId,
    this.title,
    this.cleanTitle,
    this.sortTitle,
    this.status,
    this.overview,
    this.runtime,
    this.images,
    this.year,
    this.ratings,
    this.genres,
    this.folder,
    this.isExisting,
    this.isExcluded,
  });

  @override
  List<Object?> get props => [
    tmdbId, imdbId, title, cleanTitle, sortTitle, status, overview, runtime,
    images, year, ratings, genres, folder, isExisting, isExcluded
  ];

  factory CollectionMovieResource.fromJson(Map<String, dynamic> json) {
    int? parseIntSafe(dynamic value) {
      if (value == null) return null;
      if (value is int) return value;
      if (value is String) return int.tryParse(value);
      return null;
    }

    return CollectionMovieResource(
      tmdbId: parseIntSafe(json['tmdbId']),
      imdbId: json['imdbId'] as String?,
      title: json['title'] as String?,
      cleanTitle: json['cleanTitle'] as String?,
      sortTitle: json['sortTitle'] as String?,
      status: json['status'] as String?,
      overview: json['overview'] as String?,
      runtime: parseIntSafe(json['runtime']),
      images: (json['images'] as List<dynamic>?)?.map((e) => MediaCover.fromJson(e as Map<String, dynamic>)).toList(),
      year: parseIntSafe(json['year']),
      ratings: json['ratings'] != null ? MovieRatings.fromJson(json['ratings'] as Map<String, dynamic>) : null,
      genres: (json['genres'] as List<dynamic>?)?.cast<String>(),
      folder: json['folder'] as String?,
      isExisting: json['isExisting'] as bool?,
      isExcluded: json['isExcluded'] as bool?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'tmdbId': tmdbId,
      'imdbId': imdbId,
      'title': title,
      'cleanTitle': cleanTitle,
      'sortTitle': sortTitle,
      'status': status,
      'overview': overview,
      'runtime': runtime,
      'images': images?.map((e) => e.toJson()).toList(),
      'year': year,
      'ratings': ratings?.toJson(),
      'genres': genres,
      'folder': folder,
      'isExisting': isExisting,
      'isExcluded': isExcluded,
    };
  }

  CollectionMovieResource copyWith({
    int? tmdbId,
    String? imdbId,
    String? title,
    String? cleanTitle,
    String? sortTitle,
    String? status,
    String? overview,
    int? runtime,
    List<MediaCover>? images,
    int? year,
    MovieRatings? ratings,
    List<String>? genres,
    String? folder,
    bool? isExisting,
    bool? isExcluded,
  }) {
    return CollectionMovieResource(
      tmdbId: tmdbId ?? this.tmdbId,
      imdbId: imdbId ?? this.imdbId,
      title: title ?? this.title,
      cleanTitle: cleanTitle ?? this.cleanTitle,
      sortTitle: sortTitle ?? this.sortTitle,
      status: status ?? this.status,
      overview: overview ?? this.overview,
      runtime: runtime ?? this.runtime,
      images: images ?? this.images,
      year: year ?? this.year,
      ratings: ratings ?? this.ratings,
      genres: genres ?? this.genres,
      folder: folder ?? this.folder,
      isExisting: isExisting ?? this.isExisting,
      isExcluded: isExcluded ?? this.isExcluded,
    );
  }
}
