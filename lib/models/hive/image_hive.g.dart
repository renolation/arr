// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'image_hive.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ImageHiveAdapter extends TypeAdapter<ImageHive> {
  @override
  final int typeId = 110;

  @override
  ImageHive read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ImageHive(
      coverType: fields[0] as String,
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
