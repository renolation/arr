import 'package:hive/hive.dart';
import 'package:arr/models/part_3.dart';
import 'package:arr/models/part_1.dart';
import 'package:arr/models/hive/movie_hive.dart';

part 'series_hive.g.dart';

@HiveType(typeId: 6)
class SeriesHive extends HiveObject {
  @HiveField(0)
  int? id;
  
  @HiveField(1)
  String? title;
  
  @HiveField(2)
  String? sortTitle;
  
  @HiveField(3)
  String? status;
  
  @HiveField(4)
  String? overview;
  
  @HiveField(5)
  String? network;
  
  @HiveField(6)
  String? airTime;
  
  @HiveField(7)
  List<ImageHive>? images;
  
  @HiveField(8)
  int? qualityProfileId;
  
  @HiveField(9)
  bool? monitored;
  
  @HiveField(10)
  bool? useSceneNumbering;
  
  @HiveField(11)
  int? runtime;
  
  @HiveField(12)
  int? tvdbId;
  
  @HiveField(13)
  int? tvRageId;
  
  @HiveField(14)
  int? tvMazeId;
  
  @HiveField(15)
  DateTime? firstAired;
  
  @HiveField(16)
  String? seriesType;
  
  @HiveField(17)
  String? cleanTitle;
  
  @HiveField(18)
  String? imdbId;
  
  @HiveField(19)
  String? titleSlug;
  
  @HiveField(20)
  String? rootFolderPath;
  
  @HiveField(21)
  String? certification;
  
  @HiveField(22)
  List<String>? genres;
  
  @HiveField(23)
  List<String>? tags;
  
  @HiveField(24)
  DateTime? added;
  
  @HiveField(25)
  int? seasonCount;
  
  @HiveField(26)
  int? totalEpisodeCount;
  
  @HiveField(27)
  int? episodeCount;
  
  @HiveField(28)
  int? episodeFileCount;
  
  @HiveField(29)
  int? sizeOnDisk;
  
  @HiveField(30)
  DateTime? lastCached;
  
  @HiveField(31)
  String? serviceId;

  @HiveField(32)
  int? year;

  SeriesHive({
    this.id,
    this.title,
    this.sortTitle,
    this.status,
    this.overview,
    this.network,
    this.airTime,
    this.images,
    this.qualityProfileId,
    this.monitored,
    this.useSceneNumbering,
    this.runtime,
    this.tvdbId,
    this.tvRageId,
    this.tvMazeId,
    this.firstAired,
    this.seriesType,
    this.cleanTitle,
    this.imdbId,
    this.titleSlug,
    this.rootFolderPath,
    this.certification,
    this.genres,
    this.tags,
    this.added,
    this.seasonCount,
    this.totalEpisodeCount,
    this.episodeCount,
    this.episodeFileCount,
    this.sizeOnDisk,
    this.lastCached,
    this.serviceId,
    this.year,
  });
  
  factory SeriesHive.fromSeriesResource(SeriesResource series, String serviceId) {
    return SeriesHive(
      id: series.id,
      title: series.title,
      sortTitle: series.sortTitle,
      status: series.status,
      overview: series.overview,
      network: series.network,
      airTime: series.airTime,
      images: series.images?.map((img) => ImageHive.fromMediaCover(img)).toList(),
      qualityProfileId: series.qualityProfileId,
      monitored: series.monitored,
      useSceneNumbering: series.useSceneNumbering,
      runtime: series.runtime,
      tvdbId: series.tvdbId,
      tvRageId: series.tvRageId,
      tvMazeId: series.tvMazeId,
      firstAired: series.firstAired,
      seriesType: series.seriesType,
      cleanTitle: series.cleanTitle,
      imdbId: series.imdbId,
      titleSlug: series.titleSlug,
      rootFolderPath: series.rootFolderPath,
      certification: series.certification,
      genres: series.genres,
      tags: series.tags,
      added: series.added,
      seasonCount: series.seasonCount ?? series.statistics?.seasonCount,
      totalEpisodeCount: series.totalEpisodeCount ?? series.statistics?.totalEpisodeCount,
      episodeCount: series.episodeCount ?? series.statistics?.episodeCount,
      episodeFileCount: series.episodeFileCount ?? series.statistics?.episodeFileCount,
      sizeOnDisk: series.sizeOnDisk ?? series.statistics?.sizeOnDisk,
      lastCached: DateTime.now(),
      serviceId: serviceId,
      year: series.year,
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