// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'episode_hive.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class EpisodeHiveAdapter extends TypeAdapter<EpisodeHive> {
  @override
  final int typeId = 160;

  @override
  EpisodeHive read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return EpisodeHive(
      seriesId: fields[0] as int?,
      episodeFileId: fields[1] as int?,
      seasonNumber: fields[2] as int?,
      episodeNumber: fields[3] as int?,
      title: fields[4] as String?,
      airDate: fields[5] as String?,
      airDateTime: fields[6] as String?,
      overview: fields[7] as String?,
      hasFile: fields[8] as bool?,
      monitored: fields[9] as bool?,
      absoluteEpisodeNumber: fields[10] as int?,
      tvdbId: fields[11] as int?,
      tvRageId: fields[12] as String?,
      sceneSeasonNumber: fields[13] as String?,
      sceneEpisodeNumber: fields[14] as String?,
      sceneAbsoluteEpisodeNumber: fields[15] as String?,
      unverifiedSceneNumbering: fields[16] as int?,
      lastInfoSync: fields[17] as DateTime?,
      series: fields[18] as String?,
      endingAired: fields[19] as bool?,
      endTime: fields[20] as String?,
      grabDate: fields[21] as String?,
      grabTitle: fields[22] as String?,
      indexer: fields[23] as String?,
      releaseGroup: fields[24] as String?,
      seasonCount: fields[25] as int?,
      seriesTitle: fields[26] as String?,
      sizeOnDisk: fields[27] as int?,
      mediaInfo: fields[28] as String?,
      quality: fields[29] as String?,
      serviceId: fields[30] as String?,
      cachedAt: fields[31] as DateTime?,
      language: fields[32] as String?,
      subtitles: fields[33] as String?,
      episodeFile: (fields[34] as Map?)?.cast<String, dynamic>(),
    );
  }

  @override
  void write(BinaryWriter writer, EpisodeHive obj) {
    writer
      ..writeByte(35)
      ..writeByte(0)
      ..write(obj.seriesId)
      ..writeByte(1)
      ..write(obj.episodeFileId)
      ..writeByte(2)
      ..write(obj.seasonNumber)
      ..writeByte(3)
      ..write(obj.episodeNumber)
      ..writeByte(4)
      ..write(obj.title)
      ..writeByte(5)
      ..write(obj.airDate)
      ..writeByte(6)
      ..write(obj.airDateTime)
      ..writeByte(7)
      ..write(obj.overview)
      ..writeByte(8)
      ..write(obj.hasFile)
      ..writeByte(9)
      ..write(obj.monitored)
      ..writeByte(10)
      ..write(obj.absoluteEpisodeNumber)
      ..writeByte(11)
      ..write(obj.tvdbId)
      ..writeByte(12)
      ..write(obj.tvRageId)
      ..writeByte(13)
      ..write(obj.sceneSeasonNumber)
      ..writeByte(14)
      ..write(obj.sceneEpisodeNumber)
      ..writeByte(15)
      ..write(obj.sceneAbsoluteEpisodeNumber)
      ..writeByte(16)
      ..write(obj.unverifiedSceneNumbering)
      ..writeByte(17)
      ..write(obj.lastInfoSync)
      ..writeByte(18)
      ..write(obj.series)
      ..writeByte(19)
      ..write(obj.endingAired)
      ..writeByte(20)
      ..write(obj.endTime)
      ..writeByte(21)
      ..write(obj.grabDate)
      ..writeByte(22)
      ..write(obj.grabTitle)
      ..writeByte(23)
      ..write(obj.indexer)
      ..writeByte(24)
      ..write(obj.releaseGroup)
      ..writeByte(25)
      ..write(obj.seasonCount)
      ..writeByte(26)
      ..write(obj.seriesTitle)
      ..writeByte(27)
      ..write(obj.sizeOnDisk)
      ..writeByte(28)
      ..write(obj.mediaInfo)
      ..writeByte(29)
      ..write(obj.quality)
      ..writeByte(30)
      ..write(obj.serviceId)
      ..writeByte(31)
      ..write(obj.cachedAt)
      ..writeByte(32)
      ..write(obj.language)
      ..writeByte(33)
      ..write(obj.subtitles)
      ..writeByte(34)
      ..write(obj.episodeFile);
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
