// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'movie_hive.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class MovieHiveAdapter extends TypeAdapter<MovieHive> {
  @override
  final int typeId = 150;

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
      hasFile: fields[13] as bool?,
      youTubeTrailerId: fields[14] as String?,
      studio: fields[15] as String?,
      path: fields[16] as String?,
      qualityProfileId: fields[17] as int?,
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
      posterUrl: fields[32] as String?,
      backdropUrl: fields[33] as String?,
      serviceId: fields[34] as String?,
      cachedAt: fields[35] as DateTime?,
      movieFile: (fields[36] as Map?)?.cast<String, dynamic>(),
      collection: (fields[37] as Map?)?.cast<String, dynamic>(),
    );
  }

  @override
  void write(BinaryWriter writer, MovieHive obj) {
    writer
      ..writeByte(38)
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
      ..write(obj.hasFile)
      ..writeByte(14)
      ..write(obj.youTubeTrailerId)
      ..writeByte(15)
      ..write(obj.studio)
      ..writeByte(16)
      ..write(obj.path)
      ..writeByte(17)
      ..write(obj.qualityProfileId)
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
      ..write(obj.posterUrl)
      ..writeByte(33)
      ..write(obj.backdropUrl)
      ..writeByte(34)
      ..write(obj.serviceId)
      ..writeByte(35)
      ..write(obj.cachedAt)
      ..writeByte(36)
      ..write(obj.movieFile)
      ..writeByte(37)
      ..write(obj.collection);
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
