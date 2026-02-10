// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'system_status.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class SystemStatusAdapter extends TypeAdapter<SystemStatus> {
  @override
  final int typeId = 190;

  @override
  SystemStatus read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return SystemStatus(
      serviceId: fields[0] as String,
      timestamp: fields[1] as DateTime?,
      version: fields[2] as String?,
      buildTime: fields[3] as String?,
      isMigration: fields[4] as bool?,
      appName: fields[5] as String?,
      instanceName: fields[6] as String?,
      diskSpace: fields[7] as DiskSpaceInfo?,
      healthIssues: (fields[8] as List?)?.cast<HealthIssue>(),
      queueSize: fields[9] as int?,
      missingMovies: fields[10] as int?,
      missingEpisodes: fields[11] as int?,
      downloadSpeed: fields[12] as double?,
      uploadSpeed: fields[13] as double?,
      status: fields[14] as String?,
      metadata: (fields[15] as Map?)?.cast<String, dynamic>(),
    );
  }

  @override
  void write(BinaryWriter writer, SystemStatus obj) {
    writer
      ..writeByte(16)
      ..writeByte(0)
      ..write(obj.serviceId)
      ..writeByte(1)
      ..write(obj.timestamp)
      ..writeByte(2)
      ..write(obj.version)
      ..writeByte(3)
      ..write(obj.buildTime)
      ..writeByte(4)
      ..write(obj.isMigration)
      ..writeByte(5)
      ..write(obj.appName)
      ..writeByte(6)
      ..write(obj.instanceName)
      ..writeByte(7)
      ..write(obj.diskSpace)
      ..writeByte(8)
      ..write(obj.healthIssues)
      ..writeByte(9)
      ..write(obj.queueSize)
      ..writeByte(10)
      ..write(obj.missingMovies)
      ..writeByte(11)
      ..write(obj.missingEpisodes)
      ..writeByte(12)
      ..write(obj.downloadSpeed)
      ..writeByte(13)
      ..write(obj.uploadSpeed)
      ..writeByte(14)
      ..write(obj.status)
      ..writeByte(15)
      ..write(obj.metadata);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SystemStatusAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class DiskSpaceInfoAdapter extends TypeAdapter<DiskSpaceInfo> {
  @override
  final int typeId = 191;

  @override
  DiskSpaceInfo read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return DiskSpaceInfo(
      label: fields[0] as String?,
      path: fields[1] as String?,
      free: fields[2] as double?,
      total: fields[3] as double?,
      freeSpace: fields[4] as String?,
      totalSpace: fields[5] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, DiskSpaceInfo obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.label)
      ..writeByte(1)
      ..write(obj.path)
      ..writeByte(2)
      ..write(obj.free)
      ..writeByte(3)
      ..write(obj.total)
      ..writeByte(4)
      ..write(obj.freeSpace)
      ..writeByte(5)
      ..write(obj.totalSpace);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DiskSpaceInfoAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class HealthIssueAdapter extends TypeAdapter<HealthIssue> {
  @override
  final int typeId = 192;

  @override
  HealthIssue read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return HealthIssue(
      id: fields[0] as int?,
      source: fields[1] as String?,
      type: fields[2] as HealthIssueType,
      message: fields[3] as String?,
      wiki: fields[4] as WikiLink?,
      timestamp: fields[5] as DateTime?,
    );
  }

  @override
  void write(BinaryWriter writer, HealthIssue obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.source)
      ..writeByte(2)
      ..write(obj.type)
      ..writeByte(3)
      ..write(obj.message)
      ..writeByte(4)
      ..write(obj.wiki)
      ..writeByte(5)
      ..write(obj.timestamp);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is HealthIssueAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class WikiLinkAdapter extends TypeAdapter<WikiLink> {
  @override
  final int typeId = 194;

  @override
  WikiLink read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return WikiLink(
      name: fields[0] as String?,
      url: fields[1] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, WikiLink obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.url);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is WikiLinkAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class HealthIssueTypeAdapter extends TypeAdapter<HealthIssueType> {
  @override
  final int typeId = 193;

  @override
  HealthIssueType read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return HealthIssueType.info;
      case 1:
        return HealthIssueType.notice;
      case 2:
        return HealthIssueType.warning;
      case 3:
        return HealthIssueType.error;
      default:
        return HealthIssueType.info;
    }
  }

  @override
  void write(BinaryWriter writer, HealthIssueType obj) {
    switch (obj) {
      case HealthIssueType.info:
        writer.writeByte(0);
        break;
      case HealthIssueType.notice:
        writer.writeByte(1);
        break;
      case HealthIssueType.warning:
        writer.writeByte(2);
        break;
      case HealthIssueType.error:
        writer.writeByte(3);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is HealthIssueTypeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
