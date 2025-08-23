// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'series_hive.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class SeriesHiveAdapter extends TypeAdapter<SeriesHive> {
  @override
  final int typeId = 6;

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
      status: fields[3] as String?,
      overview: fields[4] as String?,
      network: fields[5] as String?,
      airTime: fields[6] as String?,
      images: (fields[7] as List?)?.cast<ImageHive>(),
      qualityProfileId: fields[8] as int?,
      monitored: fields[9] as bool?,
      useSceneNumbering: fields[10] as bool?,
      runtime: fields[11] as int?,
      tvdbId: fields[12] as int?,
      tvRageId: fields[13] as int?,
      tvMazeId: fields[14] as int?,
      firstAired: fields[15] as DateTime?,
      seriesType: fields[16] as String?,
      cleanTitle: fields[17] as String?,
      imdbId: fields[18] as String?,
      titleSlug: fields[19] as String?,
      rootFolderPath: fields[20] as String?,
      certification: fields[21] as String?,
      genres: (fields[22] as List?)?.cast<String>(),
      tags: (fields[23] as List?)?.cast<String>(),
      added: fields[24] as DateTime?,
      seasonCount: fields[25] as int?,
      totalEpisodeCount: fields[26] as int?,
      episodeCount: fields[27] as int?,
      episodeFileCount: fields[28] as int?,
      sizeOnDisk: fields[29] as int?,
      lastCached: fields[30] as DateTime?,
      serviceId: fields[31] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, SeriesHive obj) {
    writer
      ..writeByte(32)
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
      ..write(obj.qualityProfileId)
      ..writeByte(9)
      ..write(obj.monitored)
      ..writeByte(10)
      ..write(obj.useSceneNumbering)
      ..writeByte(11)
      ..write(obj.runtime)
      ..writeByte(12)
      ..write(obj.tvdbId)
      ..writeByte(13)
      ..write(obj.tvRageId)
      ..writeByte(14)
      ..write(obj.tvMazeId)
      ..writeByte(15)
      ..write(obj.firstAired)
      ..writeByte(16)
      ..write(obj.seriesType)
      ..writeByte(17)
      ..write(obj.cleanTitle)
      ..writeByte(18)
      ..write(obj.imdbId)
      ..writeByte(19)
      ..write(obj.titleSlug)
      ..writeByte(20)
      ..write(obj.rootFolderPath)
      ..writeByte(21)
      ..write(obj.certification)
      ..writeByte(22)
      ..write(obj.genres)
      ..writeByte(23)
      ..write(obj.tags)
      ..writeByte(24)
      ..write(obj.added)
      ..writeByte(25)
      ..write(obj.seasonCount)
      ..writeByte(26)
      ..write(obj.totalEpisodeCount)
      ..writeByte(27)
      ..write(obj.episodeCount)
      ..writeByte(28)
      ..write(obj.episodeFileCount)
      ..writeByte(29)
      ..write(obj.sizeOnDisk)
      ..writeByte(30)
      ..write(obj.lastCached)
      ..writeByte(31)
      ..write(obj.serviceId);
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
