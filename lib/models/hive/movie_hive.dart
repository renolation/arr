import 'package:hive/hive.dart';
import 'package:arr/models/part_4.dart';

import '../part_3.dart';

part 'movie_hive.g.dart';

@HiveType(typeId: 2)
class MovieHive extends HiveObject {
  @HiveField(0)
  int? id;
  
  @HiveField(1)
  String? title;
  
  @HiveField(2)
  String? sortTitle;
  
  @HiveField(3)
  int? sizeOnDisk;
  
  @HiveField(4)
  String? status;
  
  @HiveField(5)
  String? overview;
  
  @HiveField(6)
  DateTime? inCinemas;
  
  @HiveField(7)
  DateTime? physicalRelease;
  
  @HiveField(8)
  DateTime? digitalRelease;
  
  @HiveField(9)
  List<ImageHive>? images;
  
  @HiveField(10)
  String? website;
  
  @HiveField(11)
  bool? downloaded;
  
  @HiveField(12)
  int? year;
  
  @HiveField(13)
  String? youTubeTrailerId;
  
  @HiveField(14)
  String? studio;
  
  @HiveField(15)
  String? path;
  
  @HiveField(16)
  int? qualityProfileId;
  
  @HiveField(17)
  bool? hasFile;
  
  @HiveField(18)
  bool? monitored;
  
  @HiveField(19)
  String? minimumAvailability;
  
  @HiveField(20)
  bool? isAvailable;
  
  @HiveField(21)
  String? folderName;
  
  @HiveField(22)
  int? runtime;
  
  @HiveField(23)
  String? cleanTitle;
  
  @HiveField(24)
  String? imdbId;
  
  @HiveField(25)
  int? tmdbId;
  
  @HiveField(26)
  String? titleSlug;
  
  @HiveField(27)
  String? certification;
  
  @HiveField(28)
  List<String>? genres;
  
  @HiveField(29)
  List<String>? tags;
  
  @HiveField(30)
  DateTime? added;
  
  @HiveField(31)
  RatingsHive? ratings;
  
  @HiveField(32)
  DateTime? lastCached;
  
  @HiveField(33)
  String? serviceId;

  MovieHive({
    this.id,
    this.title,
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
    this.youTubeTrailerId,
    this.studio,
    this.path,
    this.qualityProfileId,
    this.hasFile,
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
    this.lastCached,
    this.serviceId,
  });
  
  factory MovieHive.fromMovieResource(MovieResource movie, String serviceId) {
    return MovieHive(
      id: movie.id,
      title: movie.title,
      sortTitle: movie.sortTitle,
      sizeOnDisk: movie.sizeOnDisk,
      status: movie.status,
      overview: movie.overview,
      inCinemas: movie.inCinemas,
      physicalRelease: movie.physicalRelease,
      digitalRelease: movie.digitalRelease,
      images: movie.images?.map((img) => ImageHive.fromMediaCover(img)).toList(),
      website: movie.website,
      downloaded: movie.downloaded,
      year: movie.year,
      youTubeTrailerId: movie.youTubeTrailerId,
      studio: movie.studio,
      path: movie.path,
      qualityProfileId: movie.qualityProfileId,
      hasFile: movie.hasFile,
      monitored: movie.monitored,
      minimumAvailability: movie.minimumAvailability,
      isAvailable: movie.isAvailable,
      folderName: movie.folderName,
      runtime: movie.runtime,
      cleanTitle: movie.cleanTitle,
      imdbId: movie.imdbId,
      tmdbId: movie.tmdbId,
      titleSlug: movie.titleSlug,
      certification: movie.certification,
      genres: movie.genres,
      tags: movie.tags,
      added: movie.added,
      ratings: movie.ratings != null ? RatingsHive.fromRatings(movie.ratings!) : null,
      lastCached: DateTime.now(),
      serviceId: serviceId,
    );
  }
  
  String get posterUrl {
    if (images != null && images!.isNotEmpty) {
      final poster = images!.firstWhere(
        (img) => img.coverType == 'poster',
        orElse: () => images!.first,
      );
      return poster.remoteUrl ?? poster.url ?? '';
    }
    return '';
  }
}

@HiveType(typeId: 3)
class ImageHive extends HiveObject {
  @HiveField(0)
  String? coverType;
  
  @HiveField(1)
  String? url;
  
  @HiveField(2)
  String? remoteUrl;

  ImageHive({
    this.coverType,
    this.url,
    this.remoteUrl,
  });
  
  factory ImageHive.fromMediaCover(MediaCover cover) {
    return ImageHive(
      coverType: cover.coverType,
      url: cover.url,
      remoteUrl: cover.remoteUrl,
    );
  }
}

@HiveType(typeId: 4)
class RatingsHive extends HiveObject {
  @HiveField(0)
  double? imdb;
  
  @HiveField(1)
  int? imdbVotes;
  
  @HiveField(2)
  double? tmdb;
  
  @HiveField(3)
  int? tmdbVotes;
  
  @HiveField(4)
  double? metacritic;
  
  @HiveField(5)
  int? metacriticVotes;
  
  @HiveField(6)
  double? rottenTomatoes;
  
  @HiveField(7)
  int? rottenTomatoesVotes;

  RatingsHive({
    this.imdb,
    this.imdbVotes,
    this.tmdb,
    this.tmdbVotes,
    this.metacritic,
    this.metacriticVotes,
    this.rottenTomatoes,
    this.rottenTomatoesVotes,
  });
  
  factory RatingsHive.fromRatings(Ratings ratings) {
    return RatingsHive(
      imdb: ratings.imdb?.value,
      imdbVotes: ratings.imdb!.votes!.toInt(),
      tmdb: ratings.tmdb?.value,
      tmdbVotes: ratings.tmdb!.votes!.toInt(),
      metacritic: ratings.metacritic?.value,
      metacriticVotes: ratings.metacritic!.votes!.toInt(),
      rottenTomatoes: ratings.rottenTomatoes?.value,
      rottenTomatoesVotes: ratings.rottenTomatoes!.votes!.toInt(),
    );
  }
}

@HiveType(typeId: 5)
enum MediaType {
  @HiveField(0)
  movie,
  
  @HiveField(1)
  series,
}