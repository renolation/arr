// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_settings.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class AppSettingsAdapter extends TypeAdapter<AppSettings> {
  @override
  final int typeId = 170;

  @override
  AppSettings read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return AppSettings(
      themeMode: fields[0] as String,
      useDynamicTheme: fields[1] as bool,
      accentColor: fields[2] as String?,
      enableNotifications: fields[3] as bool,
      backgroundSync: fields[4] as bool,
      syncInterval: fields[5] as int,
      cacheImages: fields[6] as bool,
      maxCacheSize: fields[7] as int,
      defaultServiceType: fields[8] as String,
      defaultSonarrService: fields[9] as String?,
      defaultRadarrService: fields[10] as String?,
      showDownloadProgress: fields[11] as bool,
      autoRefresh: fields[12] as bool,
      autoRefreshInterval: fields[13] as int,
      gridLayout: fields[14] as String,
      gridColumns: fields[15] as int,
      showYear: fields[16] as bool,
      showRatings: fields[17] as bool,
      sortBy: fields[18] as String,
      sortOrder: fields[19] as String,
      enableHapticFeedback: fields[20] as bool,
      enableDebugMode: fields[21] as bool,
      lastUpdated: fields[22] as DateTime?,
    );
  }

  @override
  void write(BinaryWriter writer, AppSettings obj) {
    writer
      ..writeByte(23)
      ..writeByte(0)
      ..write(obj.themeMode)
      ..writeByte(1)
      ..write(obj.useDynamicTheme)
      ..writeByte(2)
      ..write(obj.accentColor)
      ..writeByte(3)
      ..write(obj.enableNotifications)
      ..writeByte(4)
      ..write(obj.backgroundSync)
      ..writeByte(5)
      ..write(obj.syncInterval)
      ..writeByte(6)
      ..write(obj.cacheImages)
      ..writeByte(7)
      ..write(obj.maxCacheSize)
      ..writeByte(8)
      ..write(obj.defaultServiceType)
      ..writeByte(9)
      ..write(obj.defaultSonarrService)
      ..writeByte(10)
      ..write(obj.defaultRadarrService)
      ..writeByte(11)
      ..write(obj.showDownloadProgress)
      ..writeByte(12)
      ..write(obj.autoRefresh)
      ..writeByte(13)
      ..write(obj.autoRefreshInterval)
      ..writeByte(14)
      ..write(obj.gridLayout)
      ..writeByte(15)
      ..write(obj.gridColumns)
      ..writeByte(16)
      ..write(obj.showYear)
      ..writeByte(17)
      ..write(obj.showRatings)
      ..writeByte(18)
      ..write(obj.sortBy)
      ..writeByte(19)
      ..write(obj.sortOrder)
      ..writeByte(20)
      ..write(obj.enableHapticFeedback)
      ..writeByte(21)
      ..write(obj.enableDebugMode)
      ..writeByte(22)
      ..write(obj.lastUpdated);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AppSettingsAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
