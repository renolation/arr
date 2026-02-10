// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'series_hive.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class SeriesHiveAdapter extends TypeAdapter<SeriesHive> {
  @override
  final int typeId = 140;

  @override
  SeriesHive read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return SeriesHive(
      id: fields[0] as int?,
      title: fields[1] as String?,
      sortTitle: fields[2] as String?,
      status: fields[3] as SeriesStatus?,
      overview: fields[4] as String?,
      network: fields[5] as String?,
      airTime: fields[6] as String?,
      images: (fields[7] as List?)?.cast<ImageHive>(),
      seasonCount: fields[8] as int?,
      totalEpisodeCount: fields[9] as int?,
      episodeCount: fields[10] as int?,
      episodeFileCount: fields[11] as int?,
      sizeOnDisk: fields[12] as int?,
      seriesType: fields[13] as String?,
      added: fields[14] as DateTime?,
      qualityProfileId: fields[15] as int?,
      languageProfileId: fields[16] as int?,
      runtime: fields[17] as int?,
      tvdbId: fields[18] as int?,
      tvMazeId: fields[19] as int?,
      firstAired: fields[20] as DateTime?,
      lastInfoSync: fields[21] as DateTime?,
      cleanTitle: fields[22] as String?,
      imdbId: fields[23] as String?,
      titleSlug: fields[24] as String?,
      rootFolderPath: fields[25] as String?,
      certification: fields[26] as String?,
      genres: (fields[27] as List?)?.cast<String>(),
      tags: (fields[28] as List?)?.cast<String>(),
      monitored: fields[29] as bool?,
      year: fields[30] as int?,
      ratings: fields[31] as RatingsHive?,
      posterUrl: fields[32] as String?,
      backdropUrl: fields[33] as String?,
      serviceId: fields[34] as String?,
      cachedAt: fields[35] as DateTime?,
    );
  }

  @override
  void write(BinaryWriter writer, SeriesHive obj) {
    writer
      ..writeByte(36)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.sortTitle)
      ..writeByte(3)
      ..write(obj.status)
      ..writeByte(4)
      ..write(obj.overview)
      ..writeByte(5)
      ..write(obj.network)
      ..writeByte(6)
      ..write(obj.airTime)
      ..writeByte(7)
      ..write(obj.images)
      ..writeByte(8)
      ..write(obj.seasonCount)
      ..writeByte(9)
      ..write(obj.totalEpisodeCount)
      ..writeByte(10)
      ..write(obj.episodeCount)
      ..writeByte(11)
      ..write(obj.episodeFileCount)
      ..writeByte(12)
      ..write(obj.sizeOnDisk)
      ..writeByte(13)
      ..write(obj.seriesType)
      ..writeByte(14)
      ..write(obj.added)
      ..writeByte(15)
      ..write(obj.qualityProfileId)
      ..writeByte(16)
      ..write(obj.languageProfileId)
      ..writeByte(17)
      ..write(obj.runtime)
      ..writeByte(18)
      ..write(obj.tvdbId)
      ..writeByte(19)
      ..write(obj.tvMazeId)
      ..writeByte(20)
      ..write(obj.firstAired)
      ..writeByte(21)
      ..write(obj.lastInfoSync)
      ..writeByte(22)
      ..write(obj.cleanTitle)
      ..writeByte(23)
      ..write(obj.imdbId)
      ..writeByte(24)
      ..write(obj.titleSlug)
      ..writeByte(25)
      ..write(obj.rootFolderPath)
      ..writeByte(26)
      ..write(obj.certification)
      ..writeByte(27)
      ..write(obj.genres)
      ..writeByte(28)
      ..write(obj.tags)
      ..writeByte(29)
      ..write(obj.monitored)
      ..writeByte(30)
      ..write(obj.year)
      ..writeByte(31)
      ..write(obj.ratings)
      ..writeByte(32)
      ..write(obj.posterUrl)
      ..writeByte(33)
      ..write(obj.backdropUrl)
      ..writeByte(34)
      ..write(obj.serviceId)
      ..writeByte(35)
      ..write(obj.cachedAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SeriesHiveAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
