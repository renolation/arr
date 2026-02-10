// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sync_state.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class SyncStateAdapter extends TypeAdapter<SyncState> {
  @override
  final int typeId = 180;

  @override
  SyncState read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return SyncState(
      serviceId: fields[0] as String,
      syncType: fields[1] as ServiceSyncType,
      lastSyncTime: fields[2] as DateTime?,
      status: fields[3] as SyncStatus,
      errorMessage: fields[4] as String?,
      itemsSynced: fields[5] as int?,
      totalItems: fields[6] as int?,
      lastSuccessfulSync: fields[7] as DateTime?,
      failedAttempts: fields[8] as int,
      isSyncing: fields[9] as bool,
      nextScheduledSync: fields[10] as DateTime?,
    );
  }

  @override
  void write(BinaryWriter writer, SyncState obj) {
    writer
      ..writeByte(11)
      ..writeByte(0)
      ..write(obj.serviceId)
      ..writeByte(1)
      ..write(obj.syncType)
      ..writeByte(2)
      ..write(obj.lastSyncTime)
      ..writeByte(3)
      ..write(obj.status)
      ..writeByte(4)
      ..write(obj.errorMessage)
      ..writeByte(5)
      ..write(obj.itemsSynced)
      ..writeByte(6)
      ..write(obj.totalItems)
      ..writeByte(7)
      ..write(obj.lastSuccessfulSync)
      ..writeByte(8)
      ..write(obj.failedAttempts)
      ..writeByte(9)
      ..write(obj.isSyncing)
      ..writeByte(10)
      ..write(obj.nextScheduledSync);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SyncStateAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class ServiceSyncTypeAdapter extends TypeAdapter<ServiceSyncType> {
  @override
  final int typeId = 181;

  @override
  ServiceSyncType read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return ServiceSyncType.series;
      case 1:
        return ServiceSyncType.movies;
      case 2:
        return ServiceSyncType.episodes;
      case 3:
        return ServiceSyncType.requests;
      case 4:
        return ServiceSyncType.queue;
      case 5:
        return ServiceSyncType.system;
      default:
        return ServiceSyncType.series;
    }
  }

  @override
  void write(BinaryWriter writer, ServiceSyncType obj) {
    switch (obj) {
      case ServiceSyncType.series:
        writer.writeByte(0);
        break;
      case ServiceSyncType.movies:
        writer.writeByte(1);
        break;
      case ServiceSyncType.episodes:
        writer.writeByte(2);
        break;
      case ServiceSyncType.requests:
        writer.writeByte(3);
        break;
      case ServiceSyncType.queue:
        writer.writeByte(4);
        break;
      case ServiceSyncType.system:
        writer.writeByte(5);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ServiceSyncTypeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class SyncStatusAdapter extends TypeAdapter<SyncStatus> {
  @override
  final int typeId = 182;

  @override
  SyncStatus read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return SyncStatus.idle;
      case 1:
        return SyncStatus.syncing;
      case 2:
        return SyncStatus.success;
      case 3:
        return SyncStatus.error;
      case 4:
        return SyncStatus.cancelled;
      case 5:
        return SyncStatus.partial;
      default:
        return SyncStatus.idle;
    }
  }

  @override
  void write(BinaryWriter writer, SyncStatus obj) {
    switch (obj) {
      case SyncStatus.idle:
        writer.writeByte(0);
        break;
      case SyncStatus.syncing:
        writer.writeByte(1);
        break;
      case SyncStatus.success:
        writer.writeByte(2);
        break;
      case SyncStatus.error:
        writer.writeByte(3);
        break;
      case SyncStatus.cancelled:
        writer.writeByte(4);
        break;
      case SyncStatus.partial:
        writer.writeByte(5);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SyncStatusAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
