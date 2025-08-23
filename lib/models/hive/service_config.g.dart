// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'service_config.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ServiceConfigAdapter extends TypeAdapter<ServiceConfig> {
  @override
  final int typeId = 0;

  @override
  ServiceConfig read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ServiceConfig(
      id: fields[0] as String,
      name: fields[1] as String,
      url: fields[2] as String,
      apiKey: fields[3] as String,
      serviceType: fields[4] as ServiceType,
      isEnabled: fields[5] as bool,
      lastSync: fields[6] as DateTime?,
      isDefault: fields[7] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, ServiceConfig obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.url)
      ..writeByte(3)
      ..write(obj.apiKey)
      ..writeByte(4)
      ..write(obj.serviceType)
      ..writeByte(5)
      ..write(obj.isEnabled)
      ..writeByte(6)
      ..write(obj.lastSync)
      ..writeByte(7)
      ..write(obj.isDefault);
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

class ServiceTypeAdapter extends TypeAdapter<ServiceType> {
  @override
  final int typeId = 1;

  @override
  ServiceType read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return ServiceType.sonarr;
      case 1:
        return ServiceType.radarr;
      case 2:
        return ServiceType.lidarr;
      case 3:
        return ServiceType.readarr;
      default:
        return ServiceType.sonarr;
    }
  }

  @override
  void write(BinaryWriter writer, ServiceType obj) {
    switch (obj) {
      case ServiceType.sonarr:
        writer.writeByte(0);
        break;
      case ServiceType.radarr:
        writer.writeByte(1);
        break;
      case ServiceType.lidarr:
        writer.writeByte(2);
        break;
      case ServiceType.readarr:
        writer.writeByte(3);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ServiceTypeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
