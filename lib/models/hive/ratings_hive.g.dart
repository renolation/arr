// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ratings_hive.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class RatingsHiveAdapter extends TypeAdapter<RatingsHive> {
  @override
  final int typeId = 111;

  @override
  RatingsHive read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return RatingsHive(
      votes: fields[0] as double?,
      value: fields[1] as double?,
      tmdbId: fields[2] as int?,
      imdbId: fields[3] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, RatingsHive obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.votes)
      ..writeByte(1)
      ..write(obj.value)
      ..writeByte(2)
      ..write(obj.tmdbId)
      ..writeByte(3)
      ..write(obj.imdbId);
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
