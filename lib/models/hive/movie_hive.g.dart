// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'movie_hive.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class MovieHiveAdapter extends TypeAdapter<MovieHive> {
  @override
  final int typeId = 2;

  @override
  MovieHive read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return MovieHive(
      id: fields[0] as int?,
      title: fields[1] as String?,
      sortTitle: fields[2] as String?,
      sizeOnDisk: fields[3] as int?,
      status: fields[4] as String?,
      overview: fields[5] as String?,
      inCinemas: fields[6] as DateTime?,
      physicalRelease: fields[7] as DateTime?,
      digitalRelease: fields[8] as DateTime?,
      images: (fields[9] as List?)?.cast<ImageHive>(),
      website: fields[10] as String?,
      downloaded: fields[11] as bool?,
      year: fields[12] as int?,
      youTubeTrailerId: fields[13] as String?,
      studio: fields[14] as String?,
      path: fields[15] as String?,
      qualityProfileId: fields[16] as int?,
      hasFile: fields[17] as bool?,
      monitored: fields[18] as bool?,
      minimumAvailability: fields[19] as String?,
      isAvailable: fields[20] as bool?,
      folderName: fields[21] as String?,
      runtime: fields[22] as int?,
      cleanTitle: fields[23] as String?,
      imdbId: fields[24] as String?,
      tmdbId: fields[25] as int?,
      titleSlug: fields[26] as String?,
      certification: fields[27] as String?,
      genres: (fields[28] as List?)?.cast<String>(),
      tags: (fields[29] as List?)?.cast<String>(),
      added: fields[30] as DateTime?,
      ratings: fields[31] as RatingsHive?,
      lastCached: fields[32] as DateTime?,
      serviceId: fields[33] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, MovieHive obj) {
    writer
      ..writeByte(34)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.sortTitle)
      ..writeByte(3)
      ..write(obj.sizeOnDisk)
      ..writeByte(4)
      ..write(obj.status)
      ..writeByte(5)
      ..write(obj.overview)
      ..writeByte(6)
      ..write(obj.inCinemas)
      ..writeByte(7)
      ..write(obj.physicalRelease)
      ..writeByte(8)
      ..write(obj.digitalRelease)
      ..writeByte(9)
      ..write(obj.images)
      ..writeByte(10)
      ..write(obj.website)
      ..writeByte(11)
      ..write(obj.downloaded)
      ..writeByte(12)
      ..write(obj.year)
      ..writeByte(13)
      ..write(obj.youTubeTrailerId)
      ..writeByte(14)
      ..write(obj.studio)
      ..writeByte(15)
      ..write(obj.path)
      ..writeByte(16)
      ..write(obj.qualityProfileId)
      ..writeByte(17)
      ..write(obj.hasFile)
      ..writeByte(18)
      ..write(obj.monitored)
      ..writeByte(19)
      ..write(obj.minimumAvailability)
      ..writeByte(20)
      ..write(obj.isAvailable)
      ..writeByte(21)
      ..write(obj.folderName)
      ..writeByte(22)
      ..write(obj.runtime)
      ..writeByte(23)
      ..write(obj.cleanTitle)
      ..writeByte(24)
      ..write(obj.imdbId)
      ..writeByte(25)
      ..write(obj.tmdbId)
      ..writeByte(26)
      ..write(obj.titleSlug)
      ..writeByte(27)
      ..write(obj.certification)
      ..writeByte(28)
      ..write(obj.genres)
      ..writeByte(29)
      ..write(obj.tags)
      ..writeByte(30)
      ..write(obj.added)
      ..writeByte(31)
      ..write(obj.ratings)
      ..writeByte(32)
      ..write(obj.lastCached)
      ..writeByte(33)
      ..write(obj.serviceId);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MovieHiveAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class ImageHiveAdapter extends TypeAdapter<ImageHive> {
  @override
  final int typeId = 3;

  @override
  ImageHive read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ImageHive(
      coverType: fields[0] as String?,
      url: fields[1] as String?,
      remoteUrl: fields[2] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, ImageHive obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.coverType)
      ..writeByte(1)
      ..write(obj.url)
      ..writeByte(2)
      ..write(obj.remoteUrl);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ImageHiveAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class RatingsHiveAdapter extends TypeAdapter<RatingsHive> {
  @override
  final int typeId = 4;

  @override
  RatingsHive read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return RatingsHive(
      imdb: fields[0] as double?,
      imdbVotes: fields[1] as int?,
      tmdb: fields[2] as double?,
      tmdbVotes: fields[3] as int?,
      metacritic: fields[4] as double?,
      metacriticVotes: fields[5] as int?,
      rottenTomatoes: fields[6] as double?,
      rottenTomatoesVotes: fields[7] as int?,
    );
  }

  @override
  void write(BinaryWriter writer, RatingsHive obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.imdb)
      ..writeByte(1)
      ..write(obj.imdbVotes)
      ..writeByte(2)
      ..write(obj.tmdb)
      ..writeByte(3)
      ..write(obj.tmdbVotes)
      ..writeByte(4)
      ..write(obj.metacritic)
      ..writeByte(5)
      ..write(obj.metacriticVotes)
      ..writeByte(6)
      ..write(obj.rottenTomatoes)
      ..writeByte(7)
      ..write(obj.rottenTomatoesVotes);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RatingsHiveAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class MediaTypeAdapter extends TypeAdapter<MediaType> {
  @override
  final int typeId = 5;

  @override
  MediaType read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return MediaType.movie;
      case 1:
        return MediaType.series;
      default:
        return MediaType.movie;
    }
  }

  @override
  void write(BinaryWriter writer, MediaType obj) {
    switch (obj) {
      case MediaType.movie:
        writer.writeByte(0);
        break;
      case MediaType.series:
        writer.writeByte(1);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MediaTypeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
