import 'package:hive/hive.dart';
import 'package:arr/models/part_3.dart';
import 'package:arr/models/hive/movie_hive.dart';

part 'episode_hive.g.dart';

@HiveType(typeId: 7)
class EpisodeHive extends HiveObject {
  @HiveField(0)
  int? id;
  
  @HiveField(1)
  int? seriesId;
  
  @HiveField(2)
  int? tvdbId;
  
  @HiveField(3)
  int? episodeFileId;
  
  @HiveField(4)
  int? seasonNumber;
  
  @HiveField(5)
  int? episodeNumber;
  
  @HiveField(6)
  String? title;
  
  @HiveField(7)
  String? airDate;
  
  @HiveField(8)
  DateTime? airDateUtc;
  
  @HiveField(9)
  String? overview;
  
  @HiveField(10)
  bool? hasFile;
  
  @HiveField(11)
  bool? monitored;
  
  @HiveField(12)
  int? absoluteEpisodeNumber;
  
  @HiveField(13)
  int? sceneAbsoluteEpisodeNumber;
  
  @HiveField(14)
  int? sceneEpisodeNumber;
  
  @HiveField(15)
  int? sceneSeasonNumber;
  
  @HiveField(16)
  bool? unverifiedSceneNumbering;
  
  @HiveField(17)
  DateTime? lastSearchTime;
  
  @HiveField(18)
  String? seriesTitle;
  
  @HiveField(19)
  List<ImageHive>? images;
  
  @HiveField(20)
  DateTime? lastCached;
  
  @HiveField(21)
  String? serviceId;

  EpisodeHive({
    this.id,
    this.seriesId,
    this.tvdbId,
    this.episodeFileId,
    this.seasonNumber,
    this.episodeNumber,
    this.title,
    this.airDate,
    this.airDateUtc,
    this.overview,
    this.hasFile,
    this.monitored,
    this.absoluteEpisodeNumber,
    this.sceneAbsoluteEpisodeNumber,
    this.sceneEpisodeNumber,
    this.sceneSeasonNumber,
    this.unverifiedSceneNumbering,
    this.lastSearchTime,
    this.seriesTitle,
    this.images,
    this.lastCached,
    this.serviceId,
  });
  
  factory EpisodeHive.fromEpisodeResource(EpisodeResource episode, String serviceId) {
    return EpisodeHive(
      id: episode.id,
      seriesId: episode.seriesId,
      tvdbId: episode.tvdbId,
      episodeFileId: episode.episodeFileId,
      seasonNumber: episode.seasonNumber,
      episodeNumber: episode.episodeNumber,
      title: episode.title,
      airDate: episode.airDate?.toIso8601String(),
      airDateUtc: episode.airDateUtc,
      overview: episode.overview,
      hasFile: episode.hasFile,
      monitored: episode.monitored,
      absoluteEpisodeNumber: episode.absoluteEpisodeNumber,
      sceneAbsoluteEpisodeNumber: episode.sceneAbsoluteEpisodeNumber,
      sceneEpisodeNumber: episode.sceneEpisodeNumber,
      sceneSeasonNumber: episode.sceneSeasonNumber,
      unverifiedSceneNumbering: episode.unverifiedSceneNumbering,
      lastSearchTime: episode.lastSearchTime,
      seriesTitle: episode.series?.title,
      images: episode.images?.map((img) => ImageHive.fromMediaCover(img)).toList(),
      lastCached: DateTime.now(),
      serviceId: serviceId,
    );
  }
}