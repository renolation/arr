// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'service_config.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ServiceConfigAdapter extends TypeAdapter<ServiceConfig> {
  @override
  final int typeId = 120;

  @override
  ServiceConfig read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ServiceConfig(
      id: fields[0] as String,
      name: fields[1] as String,
      type: fields[2] as ServiceType,
      baseUrl: fields[3] as String,
      applicationUrl: fields[4] as String?,
      port: fields[5] as int?,
      isEnabled: fields[6] as bool,
      lastSync: fields[7] as DateTime?,
      priority: fields[8] as int?,
      settings: (fields[9] as Map?)?.cast<String, dynamic>(),
    );
  }

  @override
  void write(BinaryWriter writer, ServiceConfig obj) {
    writer
      ..writeByte(10)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.type)
      ..writeByte(3)
      ..write(obj.baseUrl)
      ..writeByte(4)
      ..write(obj.applicationUrl)
      ..writeByte(5)
      ..write(obj.port)
      ..writeByte(6)
      ..write(obj.isEnabled)
      ..writeByte(7)
      ..write(obj.lastSync)
      ..writeByte(8)
      ..write(obj.priority)
      ..writeByte(9)
      ..write(obj.settings);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ServiceConfigAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
