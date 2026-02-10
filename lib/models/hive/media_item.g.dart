// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'media_item.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class MediaItemAdapter extends TypeAdapter<MediaItem> {
  @override
  final int typeId = 130;

  @override
  MediaItem read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return MediaItem(
      id: fields[0] as String,
      type: fields[1] as MediaType,
      seriesId: fields[2] as int?,
      movieId: fields[3] as int?,
      title: fields[4] as String,
      sortTitle: fields[5] as String?,
      posterUrl: fields[6] as String?,
      backdropUrl: fields[7] as String?,
      year: fields[8] as int?,
      status: fields[9] as MediaStatus?,
      overview: fields[10] as String?,
      added: fields[11] as DateTime?,
      lastUpdated: fields[12] as DateTime?,
      monitored: fields[13] as bool?,
      sizeOnDisk: fields[14] as int?,
      ratings: fields[15] as RatingsHive?,
      genres: (fields[16] as List?)?.cast<String>(),
      certification: fields[17] as String?,
      runtime: fields[18] as int?,
      serviceId: fields[19] as String?,
      metadata: (fields[20] as Map?)?.cast<String, dynamic>(),
    );
  }

  @override
  void write(BinaryWriter writer, MediaItem obj) {
    writer
      ..writeByte(21)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.type)
      ..writeByte(2)
      ..write(obj.seriesId)
      ..writeByte(3)
      ..write(obj.movieId)
      ..writeByte(4)
      ..write(obj.title)
      ..writeByte(5)
      ..write(obj.sortTitle)
      ..writeByte(6)
      ..write(obj.posterUrl)
      ..writeByte(7)
      ..write(obj.backdropUrl)
      ..writeByte(8)
      ..write(obj.year)
      ..writeByte(9)
      ..write(obj.status)
      ..writeByte(10)
      ..write(obj.overview)
      ..writeByte(11)
      ..write(obj.added)
      ..writeByte(12)
      ..write(obj.lastUpdated)
      ..writeByte(13)
      ..write(obj.monitored)
      ..writeByte(14)
      ..write(obj.sizeOnDisk)
      ..writeByte(15)
      ..write(obj.ratings)
      ..writeByte(16)
      ..write(obj.genres)
      ..writeByte(17)
      ..write(obj.certification)
      ..writeByte(18)
      ..write(obj.runtime)
      ..writeByte(19)
      ..write(obj.serviceId)
      ..writeByte(20)
      ..write(obj.metadata);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MediaItemAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
