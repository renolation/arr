// ========================================
// Collection Resource
// Radarr-specific
// ========================================

import 'package:arr/models/common/media_cover.dart';
import 'package:arr/models/movie/collection/collection_movie_resource.dart';
import 'package:equatable/equatable.dart';

class CollectionResource extends Equatable {
  final int? id;
  final String? title;
  final String? sortTitle;
  final int? tmdbId;
  final List<MediaCover>? images;
  final String? overview;
  final bool? monitored;
  final String? rootFolderPath;
  final int? qualityProfileId;
  final bool? searchOnAdd;
  final String? minimumAvailability;
  final List<String>? tags;
  final List<CollectionMovieResource>? movies;
  final int? missingMovies;

  const CollectionResource({
    this.id,
    this.title,
    this.sortTitle,
    this.tmdbId,
    this.images,
    this.overview,
    this.monitored,
    this.rootFolderPath,
    this.qualityProfileId,
    this.searchOnAdd,
    this.minimumAvailability,
    this.tags,
    this.movies,
    this.missingMovies,
  });

  @override
  List<Object?> get props => [id, title, sortTitle, tmdbId, images, overview, monitored, rootFolderPath, qualityProfileId, searchOnAdd, minimumAvailability, tags, movies, missingMovies];

  factory CollectionResource.fromJson(Map<String, dynamic> json) {
    int? parseIntSafe(dynamic value) {
      if (value == null) return null;
      if (value is int) return value;
      if (value is String) return int.tryParse(value);
      return null;
    }

    return CollectionResource(
      id: parseIntSafe(json['id']),
      title: json['title'] as String?,
      sortTitle: json['sortTitle'] as String?,
      tmdbId: parseIntSafe(json['tmdbId']),
      images: (json['images'] as List<dynamic>?)
          ?.map((e) => MediaCover.fromJson(e as Map<String, dynamic>))
          .toList(),
      overview: json['overview'] as String?,
      monitored: json['monitored'] as bool?,
      rootFolderPath: json['rootFolderPath'] as String?,
      qualityProfileId: parseIntSafe(json['qualityProfileId']),
      searchOnAdd: json['searchOnAdd'] as bool?,
      minimumAvailability: json['minimumAvailability'] as String?,
      tags: (json['tags'] as List<dynamic>?)?.cast<String>(),
      movies: (json['movies'] as List<dynamic>?)
          ?.map((e) => CollectionMovieResource.fromJson(e as Map<String, dynamic>))
          .toList(),
      missingMovies: parseIntSafe(json['missingMovies']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'sortTitle': sortTitle,
      'tmdbId': tmdbId,
      'images': images?.map((e) => e.toJson()).toList(),
      'overview': overview,
      'monitored': monitored,
      'rootFolderPath': rootFolderPath,
      'qualityProfileId': qualityProfileId,
      'searchOnAdd': searchOnAdd,
      'minimumAvailability': minimumAvailability,
      'tags': tags,
      'movies': movies?.map((e) => e.toJson()).toList(),
      'missingMovies': missingMovies,
    };
  }

  CollectionResource copyWith({
    int? id,
    String? title,
    String? sortTitle,
    int? tmdbId,
    List<MediaCover>? images,
    String? overview,
    bool? monitored,
    String? rootFolderPath,
    int? qualityProfileId,
    bool? searchOnAdd,
    String? minimumAvailability,
    List<String>? tags,
    List<CollectionMovieResource>? movies,
    int? missingMovies,
  }) {
    return CollectionResource(
      id: id ?? this.id,
      title: title ?? this.title,
      sortTitle: sortTitle ?? this.sortTitle,
      tmdbId: tmdbId ?? this.tmdbId,
      images: images ?? this.images,
      overview: overview ?? this.overview,
      monitored: monitored ?? this.monitored,
      rootFolderPath: rootFolderPath ?? this.rootFolderPath,
      qualityProfileId: qualityProfileId ?? this.qualityProfileId,
      searchOnAdd: searchOnAdd ?? this.searchOnAdd,
      minimumAvailability: minimumAvailability ?? this.minimumAvailability,
      tags: tags ?? this.tags,
      movies: movies ?? this.movies,
      missingMovies: missingMovies ?? this.missingMovies,
    );
  }
}
