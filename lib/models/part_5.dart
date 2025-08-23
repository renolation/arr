import 'package:arr/models/part_3.dart';
import 'package:equatable/equatable.dart';
import 'part_4.dart';

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
  final Ratings? ratings;
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
    tmdbId,
    imdbId,
    title,
    cleanTitle,
    sortTitle,
    status,
    overview,
    runtime,
    images,
    year,
    ratings,
    genres,
    folder,
    isExisting,
    isExcluded,
  ];

  factory CollectionMovieResource.fromJson(Map<String, dynamic> json) {
    return CollectionMovieResource(
      tmdbId: json['tmdbId'] as int?,
      imdbId: json['imdbId'] as String?,
      title: json['title'] as String?,
      cleanTitle: json['cleanTitle'] as String?,
      sortTitle: json['sortTitle'] as String?,
      status: json['status'] as String?,
      overview: json['overview'] as String?,
      runtime: json['runtime'] as int?,
      images: (json['images'] as List<dynamic>?)?.map((e) => MediaCover.fromJson(e as Map<String, dynamic>)).toList(),
      year: json['year'] as int?,
      ratings: json['ratings'] != null ? Ratings.fromJson(json['ratings'] as Map<String, dynamic>) : null,
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
    Ratings? ratings,
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
    return MovieStatisticsResource(
      movieFileCount: json['movieFileCount'] as int?,
      sizeOnDisk: json['sizeOnDisk'] as int?,
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
