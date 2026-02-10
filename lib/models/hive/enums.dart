// ========================================
// Hive Enums
// Enums for Hive storage with TypeAdapters
// ========================================

import 'package:hive/hive.dart';

part 'enums.g.dart';

/// Service type enum
@HiveType(typeId: 100)
enum ServiceType {
  @HiveField(0)
  radarr,
  @HiveField(1)
  sonarr,
  @HiveField(2)
  overseerr,
  @HiveField(3)
  downloadClient,
}

/// Media type enum (series or movie)
@HiveType(typeId: 101)
enum MediaType {
  @HiveField(0)
  series,
  @HiveField(1)
  movie,
}

/// Media status enum
@HiveType(typeId: 102)
enum MediaStatus {
  @HiveField(0)
  downloading,
  @HiveField(1)
  completed,
  @HiveField(2)
  missing,
  @HiveField(3)
  monitored,
  @HiveField(4)
  continuing,
  @HiveField(5)
  ended,
  @HiveField(6)
  upcoming,
}

/// Series status enum (Sonarr-specific)
@HiveType(typeId: 103)
enum SeriesStatus {
  @HiveField(0)
  continuing,
  @HiveField(1)
  ended,
  @HiveField(2)
  upcoming,
  @HiveField(3)
  deleted,
}

/// Download client type enum
@HiveType(typeId: 104)
enum DownloadClientType {
  @HiveField(0)
  transmission,
  @HiveField(1)
  deluge,
  @HiveField(2)
  qbittorrent,
  @HiveField(3)
  utorrent,
  @HiveField(4)
  sabnzbd,
  @HiveField(5)
  nzbget,
  @HiveField(6)
  other,
}
