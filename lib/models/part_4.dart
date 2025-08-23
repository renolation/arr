// ========================================
// Radarr-Specific Models (Movie Management)
// Movie, AlternativeTitle, Collection, Credit, ExtraFile
// ========================================

import 'package:arr/models/part_1.dart';
import 'package:arr/models/part_3.dart';
import 'package:arr/models/part_5.dart';
import 'package:equatable/equatable.dart';

// ========================================
// Movie Resource
// ========================================

class MovieResource extends Equatable {
  final int? id;
  final String? title;
  final List<AlternativeTitleResource>? alternateTitles;
  final int? secondaryYearSourceId;
  final String? sortTitle;
  final int? sizeOnDisk;
  final String? status;
  final String? overview;
  final DateTime? inCinemas;
  final DateTime? physicalRelease;
  final DateTime? digitalRelease;
  final List<MediaCover>? images;
  final String? website;
  final bool? downloaded;
  final int? year;
  final bool? hasFile;
  final String? youTubeTrailerId;
  final String? studio;
  final String? path;
  final int? qualityProfileId;
  final bool? monitored;
  final String? minimumAvailability;
  final bool? isAvailable;
  final String? folderName;
  final int? runtime;
  final String? cleanTitle;
  final String? imdbId;
  final int? tmdbId;
  final String? titleSlug;
  final String? certification;
  final List<String>? genres;
  final List<String>? tags;
  final DateTime? added;
  final Ratings? ratings;
  final MovieFileResource? movieFile;
  final CollectionResource? collection;
  final MovieStatisticsResource? statistics;

  const MovieResource({
    this.id,
    this.title,
    this.alternateTitles,
    this.secondaryYearSourceId,
    this.sortTitle,
    this.sizeOnDisk,
    this.status,
    this.overview,
    this.inCinemas,
    this.physicalRelease,
    this.digitalRelease,
    this.images,
    this.website,
    this.downloaded,
    this.year,
    this.hasFile,
    this.youTubeTrailerId,
    this.studio,
    this.path,
    this.qualityProfileId,
    this.monitored,
    this.minimumAvailability,
    this.isAvailable,
    this.folderName,
    this.runtime,
    this.cleanTitle,
    this.imdbId,
    this.tmdbId,
    this.titleSlug,
    this.certification,
    this.genres,
    this.tags,
    this.added,
    this.ratings,
    this.movieFile,
    this.collection,
    this.statistics,
  });

  @override
  List<Object?> get props => [id, title, alternateTitles, secondaryYearSourceId, sortTitle, sizeOnDisk, status, overview, inCinemas, physicalRelease, digitalRelease, images, website, downloaded, year, hasFile, youTubeTrailerId, studio, path, qualityProfileId, monitored, minimumAvailability, isAvailable, folderName, runtime, cleanTitle, imdbId, tmdbId, titleSlug, certification, genres, tags, added, ratings, movieFile, collection, statistics];

  factory MovieResource.fromJson(Map<String, dynamic> json) {
    return MovieResource(
      id: json['id'] as int?,
      title: json['title'] as String?,
      alternateTitles: (json['alternateTitles'] as List<dynamic>?)
          ?.map((e) => AlternativeTitleResource.fromJson(e as Map<String, dynamic>))
          .toList(),
      secondaryYearSourceId: json['secondaryYearSourceId'] as int?,
      sortTitle: json['sortTitle'] as String?,
      sizeOnDisk: json['sizeOnDisk'] as int?,
      status: json['status'] as String?,
      overview: json['overview'] as String?,
      inCinemas: json['inCinemas'] != null ? DateTime.parse(json['inCinemas'] as String) : null,
      physicalRelease: json['physicalRelease'] != null ? DateTime.parse(json['physicalRelease'] as String) : null,
      digitalRelease: json['digitalRelease'] != null ? DateTime.parse(json['digitalRelease'] as String) : null,
      images: (json['images'] as List<dynamic>?)
          ?.map((e) => MediaCover.fromJson(e as Map<String, dynamic>))
          .toList(),
      website: json['website'] as String?,
      downloaded: json['downloaded'] as bool?,
      year: json['year'] as int?,
      hasFile: json['hasFile'] as bool?,
      youTubeTrailerId: json['youTubeTrailerId'] as String?,
      studio: json['studio'] as String?,
      path: json['path'] as String?,
      qualityProfileId: json['qualityProfileId'] as int?,
      monitored: json['monitored'] as bool?,
      minimumAvailability: json['minimumAvailability'] as String?,
      isAvailable: json['isAvailable'] as bool?,
      folderName: json['folderName'] as String?,
      runtime: json['runtime'] as int?,
      cleanTitle: json['cleanTitle'] as String?,
      imdbId: json['imdbId'] as String?,
      tmdbId: json['tmdbId'] as int?,
      titleSlug: json['titleSlug'] as String?,
      certification: json['certification'] as String?,
      genres: (json['genres'] as List<dynamic>?)?.cast<String>(),
      tags: (json['tags'] as List<dynamic>?)?.cast<String>(),
      added: json['added'] != null ? DateTime.parse(json['added'] as String) : null,
      ratings: json['ratings'] != null ? Ratings.fromJson(json['ratings'] as Map<String, dynamic>) : null,
      movieFile: json['movieFile'] != null ? MovieFileResource.fromJson(json['movieFile'] as Map<String, dynamic>) : null,
      collection: json['collection'] != null ? CollectionResource.fromJson(json['collection'] as Map<String, dynamic>) : null,
      statistics: json['statistics'] != null ? MovieStatisticsResource.fromJson(json['statistics'] as Map<String, dynamic>) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'alternateTitles': alternateTitles?.map((e) => e.toJson()).toList(),
      'secondaryYearSourceId': secondaryYearSourceId,
      'sortTitle': sortTitle,
      'sizeOnDisk': sizeOnDisk,
      'status': status,
      'overview': overview,
      'inCinemas': inCinemas?.toIso8601String(),
      'physicalRelease': physicalRelease?.toIso8601String(),
      'digitalRelease': digitalRelease?.toIso8601String(),
      'images': images?.map((e) => e.toJson()).toList(),
      'website': website,
      'downloaded': downloaded,
      'year': year,
      'hasFile': hasFile,
      'youTubeTrailerId': youTubeTrailerId,
      'studio': studio,
      'path': path,
      'qualityProfileId': qualityProfileId,
      'monitored': monitored,
      'minimumAvailability': minimumAvailability,
      'isAvailable': isAvailable,
      'folderName': folderName,
      'runtime': runtime,
      'cleanTitle': cleanTitle,
      'imdbId': imdbId,
      'tmdbId': tmdbId,
      'titleSlug': titleSlug,
      'certification': certification,
      'genres': genres,
      'tags': tags,
      'added': added?.toIso8601String(),
      'ratings': ratings?.toJson(),
      'movieFile': movieFile?.toJson(),
      'collection': collection?.toJson(),
      'statistics': statistics?.toJson(),
    };
  }

  MovieResource copyWith({
    int? id,
    String? title,
    List<AlternativeTitleResource>? alternateTitles,
    int? secondaryYearSourceId,
    String? sortTitle,
    int? sizeOnDisk,
    String? status,
    String? overview,
    DateTime? inCinemas,
    DateTime? physicalRelease,
    DateTime? digitalRelease,
    List<MediaCover>? images,
    String? website,
    bool? downloaded,
    int? year,
    bool? hasFile,
    String? youTubeTrailerId,
    String? studio,
    String? path,
    int? qualityProfileId,
    bool? monitored,
    String? minimumAvailability,
    bool? isAvailable,
    String? folderName,
    int? runtime,
    String? cleanTitle,
    String? imdbId,
    int? tmdbId,
    String? titleSlug,
    String? certification,
    List<String>? genres,
    List<String>? tags,
    DateTime? added,
    Ratings? ratings,
    MovieFileResource? movieFile,
    CollectionResource? collection,
    MovieStatisticsResource? statistics,
  }) {
    return MovieResource(
      id: id ?? this.id,
      title: title ?? this.title,
      alternateTitles: alternateTitles ?? this.alternateTitles,
      secondaryYearSourceId: secondaryYearSourceId ?? this.secondaryYearSourceId,
      sortTitle: sortTitle ?? this.sortTitle,
      sizeOnDisk: sizeOnDisk ?? this.sizeOnDisk,
      status: status ?? this.status,
      overview: overview ?? this.overview,
      inCinemas: inCinemas ?? this.inCinemas,
      physicalRelease: physicalRelease ?? this.physicalRelease,
      digitalRelease: digitalRelease ?? this.digitalRelease,
      images: images ?? this.images,
      website: website ?? this.website,
      downloaded: downloaded ?? this.downloaded,
      year: year ?? this.year,
      hasFile: hasFile ?? this.hasFile,
      youTubeTrailerId: youTubeTrailerId ?? this.youTubeTrailerId,
      studio: studio ?? this.studio,
      path: path ?? this.path,
      qualityProfileId: qualityProfileId ?? this.qualityProfileId,
      monitored: monitored ?? this.monitored,
      minimumAvailability: minimumAvailability ?? this.minimumAvailability,
      isAvailable: isAvailable ?? this.isAvailable,
      folderName: folderName ?? this.folderName,
      runtime: runtime ?? this.runtime,
      cleanTitle: cleanTitle ?? this.cleanTitle,
      imdbId: imdbId ?? this.imdbId,
      tmdbId: tmdbId ?? this.tmdbId,
      titleSlug: titleSlug ?? this.titleSlug,
      certification: certification ?? this.certification,
      genres: genres ?? this.genres,
      tags: tags ?? this.tags,
      added: added ?? this.added,
      ratings: ratings ?? this.ratings,
      movieFile: movieFile ?? this.movieFile,
      collection: collection ?? this.collection,
      statistics: statistics ?? this.statistics,
    );
  }
}

// ========================================
// Alternative Title Resource
// ========================================

class AlternativeTitleResource extends Equatable {
  final int? id;
  final int? movieMetadataId;
  final String? title;
  final String? cleanTitle;
  final int? sourceType;
  final int? sourceId;
  final int? votes;
  final int? voteCount;
  final String? language;

  const AlternativeTitleResource({
    this.id,
    this.movieMetadataId,
    this.title,
    this.cleanTitle,
    this.sourceType,
    this.sourceId,
    this.votes,
    this.voteCount,
    this.language,
  });

  @override
  List<Object?> get props => [id, movieMetadataId, title, cleanTitle, sourceType, sourceId, votes, voteCount, language];

  factory AlternativeTitleResource.fromJson(Map<String, dynamic> json) {
    return AlternativeTitleResource(
      id: json['id'] as int?,
      movieMetadataId: json['movieMetadataId'] as int?,
      title: json['title'] as String?,
      cleanTitle: json['cleanTitle'] as String?,
      sourceType: json['sourceType'] as int?,
      sourceId: json['sourceId'] as int?,
      votes: json['votes'] as int?,
      voteCount: json['voteCount'] as int?,
      language: json['language'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'movieMetadataId': movieMetadataId,
      'title': title,
      'cleanTitle': cleanTitle,
      'sourceType': sourceType,
      'sourceId': sourceId,
      'votes': votes,
      'voteCount': voteCount,
      'language': language,
    };
  }

  AlternativeTitleResource copyWith({
    int? id,
    int? movieMetadataId,
    String? title,
    String? cleanTitle,
    int? sourceType,
    int? sourceId,
    int? votes,
    int? voteCount,
    String? language,
  }) {
    return AlternativeTitleResource(
      id: id ?? this.id,
      movieMetadataId: movieMetadataId ?? this.movieMetadataId,
      title: title ?? this.title,
      cleanTitle: cleanTitle ?? this.cleanTitle,
      sourceType: sourceType ?? this.sourceType,
      sourceId: sourceId ?? this.sourceId,
      votes: votes ?? this.votes,
      voteCount: voteCount ?? this.voteCount,
      language: language ?? this.language,
    );
  }
}

// ========================================
// Collection Resource
// ========================================

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
    return CollectionResource(
      id: json['id'] as int?,
      title: json['title'] as String?,
      sortTitle: json['sortTitle'] as String?,
      tmdbId: json['tmdbId'] as int?,
      images: (json['images'] as List<dynamic>?)
          ?.map((e) => MediaCover.fromJson(e as Map<String, dynamic>))
          .toList(),
      overview: json['overview'] as String?,
      monitored: json['monitored'] as bool?,
      rootFolderPath: json['rootFolderPath'] as String?,
      qualityProfileId: json['qualityProfileId'] as int?,
      searchOnAdd: json['searchOnAdd'] as bool?,
      minimumAvailability: json['minimumAvailability'] as String?,
      tags: (json['tags'] as List<dynamic>?)?.cast<String>(),
      movies: (json['movies'] as List<dynamic>?)
          ?.map((e) => CollectionMovieResource.fromJson(e as Map<String, dynamic>))
          .toList(),
      missingMovies: json['missingMovies'] as int?,
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

// ========================================
// Credit Resource
// ========================================

class CreditResource extends Equatable {
  final int? id;
  final String? personName;
  final String? creditTmdbId;
  final int? personTmdbId;
  final int? movieMetadataId;
  final List<MediaCover>? images;
  final String? department;
  final String? job;
  final String? character;
  final int? order;
  final String? type;

  const CreditResource({
    this.id,
    this.personName,
    this.creditTmdbId,
    this.personTmdbId,
    this.movieMetadataId,
    this.images,
    this.department,
    this.job,
    this.character,
    this.order,
    this.type,
  });

  @override
  List<Object?> get props => [id, personName, creditTmdbId, personTmdbId, movieMetadataId, images, department, job, character, order, type];

  factory CreditResource.fromJson(Map<String, dynamic> json) {
    return CreditResource(
      id: json['id'] as int?,
      personName: json['personName'] as String?,
      creditTmdbId: json['creditTmdbId'] as String?,
      personTmdbId: json['personTmdbId'] as int?,
      movieMetadataId: json['movieMetadataId'] as int?,
      images: (json['images'] as List<dynamic>?)
          ?.map((e) => MediaCover.fromJson(e as Map<String, dynamic>))
          .toList(),
      department: json['department'] as String?,
      job: json['job'] as String?,
      character: json['character'] as String?,
      order: json['order'] as int?,
      type: json['type'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'personName': personName,
      'creditTmdbId': creditTmdbId,
      'personTmdbId': personTmdbId,
      'movieMetadataId': movieMetadataId,
      'images': images?.map((e) => e.toJson()).toList(),
      'department': department,
      'job': job,
      'character': character,
      'order': order,
      'type': type,
    };
  }

  CreditResource copyWith({
    int? id,
    String? personName,
    String? creditTmdbId,
    int? personTmdbId,
    int? movieMetadataId,
    List<MediaCover>? images,
    String? department,
    String? job,
    String? character,
    int? order,
    String? type,
  }) {
    return CreditResource(
      id: id ?? this.id,
      personName: personName ?? this.personName,
      creditTmdbId: creditTmdbId ?? this.creditTmdbId,
      personTmdbId: personTmdbId ?? this.personTmdbId,
      movieMetadataId: movieMetadataId ?? this.movieMetadataId,
      images: images ?? this.images,
      department: department ?? this.department,
      job: job ?? this.job,
      character: character ?? this.character,
      order: order ?? this.order,
      type: type ?? this.type,
    );
  }
}

// ========================================
// Extra File Resource
// ========================================

class ExtraFileResource extends Equatable {
  final int? id;
  final int? movieId;
  final int? movieFileId;
  final String? relativePath;
  final String? extension;
  final String? type;

  const ExtraFileResource({
    this.id,
    this.movieId,
    this.movieFileId,
    this.relativePath,
    this.extension,
    this.type,
  });

  @override
  List<Object?> get props => [id, movieId, movieFileId, relativePath, extension, type];

  factory ExtraFileResource.fromJson(Map<String, dynamic> json) {
    return ExtraFileResource(
      id: json['id'] as int?,
      movieId: json['movieId'] as int?,
      movieFileId: json['movieFileId'] as int?,
      relativePath: json['relativePath'] as String?,
      extension: json['extension'] as String?,
      type: json['type'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'movieId': movieId,
      'movieFileId': movieFileId,
      'relativePath': relativePath,
      'extension': extension,
      'type': type,
    };
  }

  ExtraFileResource copyWith({
    int? id,
    int? movieId,
    int? movieFileId,
    String? relativePath,
    String? extension,
    String? type,
  }) {
    return ExtraFileResource(
      id: id ?? this.id,
      movieId: movieId ?? this.movieId,
      movieFileId: movieFileId ?? this.movieFileId,
      relativePath: relativePath ?? this.relativePath,
      extension: extension ?? this.extension,
      type: type ?? this.type,
    );
  }
}

// ========================================
// Supporting Classes
// ========================================

class MediaCover extends Equatable {
  final String? coverType;
  final String? url;
  final String? remoteUrl;

  const MediaCover({
    this.coverType,
    this.url,
    this.remoteUrl,
  });

  @override
  List<Object?> get props => [coverType, url, remoteUrl];

  factory MediaCover.fromJson(Map<String, dynamic> json) {
    return MediaCover(
      coverType: json['coverType'] as String?,
      url: json['url'] as String?,
      remoteUrl: json['remoteUrl'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'coverType': coverType,
      'url': url,
      'remoteUrl': remoteUrl,
    };
  }

  MediaCover copyWith({
    String? coverType,
    String? url,
    String? remoteUrl,
  }) {
    return MediaCover(
      coverType: coverType ?? this.coverType,
      url: url ?? this.url,
      remoteUrl: remoteUrl ?? this.remoteUrl,
    );
  }
}

class Ratings extends Equatable {
  final Rating? imdb;
  final Rating? tmdb;
  final Rating? metacritic;
  final Rating? rottenTomatoes;

  const Ratings({
    this.imdb,
    this.tmdb,
    this.metacritic,
    this.rottenTomatoes,
  });

  @override
  List<Object?> get props => [imdb, tmdb, metacritic, rottenTomatoes];

  factory Ratings.fromJson(Map<String, dynamic> json) {
    return Ratings(
      imdb: json['imdb'] != null ? Rating.fromJson(json['imdb'] as Map<String, dynamic>) : null,
      tmdb: json['tmdb'] != null ? Rating.fromJson(json['tmdb'] as Map<String, dynamic>) : null,
      metacritic: json['metacritic'] != null ? Rating.fromJson(json['metacritic'] as Map<String, dynamic>) : null,
      rottenTomatoes: json['rottenTomatoes'] != null ? Rating.fromJson(json['rottenTomatoes'] as Map<String, dynamic>) : null,
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

  Ratings copyWith({
    Rating? imdb,
    Rating? tmdb,
    Rating? metacritic,
    Rating? rottenTomatoes,
  }) {
    return Ratings(
      imdb: imdb ?? this.imdb,
      tmdb: tmdb ?? this.tmdb,
      metacritic: metacritic ?? this.metacritic,
      rottenTomatoes: rottenTomatoes ?? this.rottenTomatoes,
    );
  }
}

class Rating extends Equatable {
  final double? votes;
  final double? value;
  final String? type;

  const Rating({
    this.votes,
    this.value,
    this.type,
  });

  @override
  List<Object?> get props => [votes, value, type];

  factory Rating.fromJson(Map<String, dynamic> json) {
    return Rating(
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

  Rating copyWith({
    double? votes,
    double? value,
    String? type,
  }) {
    return Rating(
      votes: votes ?? this.votes,
      value: value ?? this.value,
      type: type ?? this.type,
    );
  }
}

class MovieFileResource extends Equatable {
  final int? id;
  final int? movieId;
  final String? relativePath;
  final String? path;
  final int? size;
  final DateTime? dateAdded;
  final String? sceneName;
  final int? indexerFlags;
  final QualityModel? quality;
  final MediaInfoResource? mediaInfo;
  final String? originalFilePath;
  final bool? qualityCutoffNotMet;
  final List<LanguageResource>? languages;
  final String? releaseGroup;
  final String? edition;

  const MovieFileResource({
  this.id,
  this.movieId,
  this.relativePath,
  this.path,
  this.size,
  this.dateAdded,
  this.sceneName,
  this.indexerFlags,
  this.quality,
  this.mediaInfo,
  this.originalFilePath,
  this.qualityCutoffNotMet,
  this.languages,
  this.releaseGroup,
  this.edition,
  });

  @override
  List<Object?> get props => [id, movieId, relativePath, path, size, dateAdded, sceneName, indexerFlags, quality, mediaInfo, originalFilePath, qualityCutoffNotMet, languages, releaseGroup, edition];

  factory MovieFileResource.fromJson(Map<String, dynamic> json) {
    return MovieFileResource(
      id: json['id'] as int?,
      movieId: json['movieId'] as int?,
      relativePath: json['relativePath'] as String?,
      path: json['path'] as String?,
      size: json['size'] as int?,
      dateAdded: json['dateAdded'] != null ? DateTime.parse(json['dateAdded'] as String) : null,
      sceneName: json['sceneName'] as String?,
      indexerFlags: json['indexerFlags'] as int?,
      quality: json['quality'] != null ? QualityModel.fromJson(json['quality'] as Map<String, dynamic>) : null,
      mediaInfo: json['mediaInfo'] != null ? MediaInfoResource.fromJson(json['mediaInfo'] as Map<String, dynamic>) : null,
      originalFilePath: json['originalFilePath'] as String?,
      qualityCutoffNotMet: json['qualityCutoffNotMet'] as bool?,
      languages: (json['languages'] as List<dynamic>?)?.map((e) => LanguageResource.fromJson(e as Map<String, dynamic>)).toList(),
      releaseGroup: json['releaseGroup'] as String?,
      edition: json['edition'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'movieId': movieId,
      'relativePath': relativePath,
      'path': path,
      'size': size,
      'dateAdded': dateAdded?.toIso8601String(),
      'sceneName': sceneName,
      'indexerFlags': indexerFlags,
      'quality': quality?.toJson(),
      'mediaInfo': mediaInfo?.toJson(),
      'originalFilePath': originalFilePath,
      'qualityCutoffNotMet': qualityCutoffNotMet,
      'languages': languages?.map((e) => e.toJson()).toList(),
      'releaseGroup': releaseGroup,
      'edition': edition,
    };
  }

  MovieFileResource copyWith({
    int? id,
    int? movieId,
    String? relativePath,
    String? path,
    int? size,
    DateTime? dateAdded,
    String? sceneName,
    int? indexerFlags,
    QualityModel? quality,
    MediaInfoResource? mediaInfo,
    String? originalFilePath,
    bool? qualityCutoffNotMet,
    List<LanguageResource>? languages,
    String? releaseGroup,
    String? edition,
  }) {
    return MovieFileResource(
      id: id ?? this.id,
      movieId: movieId ?? this.movieId,
      relativePath: relativePath ?? this.relativePath,
      path: path ?? this.path,
      size: size ?? this.size,
      dateAdded: dateAdded ?? this.dateAdded,
      sceneName: sceneName ?? this.sceneName,
      indexerFlags: indexerFlags ?? this.indexerFlags,
      quality: quality ?? this.quality,
      mediaInfo: mediaInfo ?? this.mediaInfo,
      originalFilePath: originalFilePath ?? this.originalFilePath,
      qualityCutoffNotMet: qualityCutoffNotMet ?? this.qualityCutoffNotMet,
      languages: languages ?? this.languages,
      releaseGroup: releaseGroup ?? this.releaseGroup,
      edition: edition ?? this.edition,
    );
  }
}

