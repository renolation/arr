// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'episode_hive.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class EpisodeHiveAdapter extends TypeAdapter<EpisodeHive> {
  @override
  final int typeId = 7;

  @override
  EpisodeHive read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return EpisodeHive(
      id: fields[0] as int?,
      seriesId: fields[1] as int?,
      tvdbId: fields[2] as int?,
      episodeFileId: fields[3] as int?,
      seasonNumber: fields[4] as int?,
      episodeNumber: fields[5] as int?,
      title: fields[6] as String?,
      airDate: fields[7] as String?,
      airDateUtc: fields[8] as DateTime?,
      overview: fields[9] as String?,
      hasFile: fields[10] as bool?,
      monitored: fields[11] as bool?,
      absoluteEpisodeNumber: fields[12] as int?,
      sceneAbsoluteEpisodeNumber: fields[13] as int?,
      sceneEpisodeNumber: fields[14] as int?,
      sceneSeasonNumber: fields[15] as int?,
      unverifiedSceneNumbering: fields[16] as bool?,
      lastSearchTime: fields[17] as DateTime?,
      seriesTitle: fields[18] as String?,
      images: (fields[19] as List?)?.cast<ImageHive>(),
      lastCached: fields[20] as DateTime?,
      serviceId: fields[21] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, EpisodeHive obj) {
    writer
      ..writeByte(22)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.seriesId)
      ..writeByte(2)
      ..write(obj.tvdbId)
      ..writeByte(3)
      ..write(obj.episodeFileId)
      ..writeByte(4)
      ..write(obj.seasonNumber)
      ..writeByte(5)
      ..write(obj.episodeNumber)
      ..writeByte(6)
      ..write(obj.title)
      ..writeByte(7)
      ..write(obj.airDate)
      ..writeByte(8)
      ..write(obj.airDateUtc)
      ..writeByte(9)
      ..write(obj.overview)
      ..writeByte(10)
      ..write(obj.hasFile)
      ..writeByte(11)
      ..write(obj.monitored)
      ..writeByte(12)
      ..write(obj.absoluteEpisodeNumber)
      ..writeByte(13)
      ..write(obj.sceneAbsoluteEpisodeNumber)
      ..writeByte(14)
      ..write(obj.sceneEpisodeNumber)
      ..writeByte(15)
      ..write(obj.sceneSeasonNumber)
      ..writeByte(16)
      ..write(obj.unverifiedSceneNumbering)
      ..writeByte(17)
      ..write(obj.lastSearchTime)
      ..writeByte(18)
      ..write(obj.seriesTitle)
      ..writeByte(19)
      ..write(obj.images)
      ..writeByte(20)
      ..write(obj.lastCached)
      ..writeByte(21)
      ..write(obj.serviceId);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is EpisodeHiveAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
