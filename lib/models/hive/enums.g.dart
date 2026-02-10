// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'enums.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ServiceTypeAdapter extends TypeAdapter<ServiceType> {
  @override
  final int typeId = 100;

  @override
  ServiceType read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return ServiceType.radarr;
      case 1:
        return ServiceType.sonarr;
      case 2:
        return ServiceType.overseerr;
      case 3:
        return ServiceType.downloadClient;
      default:
        return ServiceType.radarr;
    }
  }

  @override
  void write(BinaryWriter writer, ServiceType obj) {
    switch (obj) {
      case ServiceType.radarr:
        writer.writeByte(0);
        break;
      case ServiceType.sonarr:
        writer.writeByte(1);
        break;
      case ServiceType.overseerr:
        writer.writeByte(2);
        break;
      case ServiceType.downloadClient:
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

class MediaTypeAdapter extends TypeAdapter<MediaType> {
  @override
  final int typeId = 101;

  @override
  MediaType read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return MediaType.series;
      case 1:
        return MediaType.movie;
      default:
        return MediaType.series;
    }
  }

  @override
  void write(BinaryWriter writer, MediaType obj) {
    switch (obj) {
      case MediaType.series:
        writer.writeByte(0);
        break;
      case MediaType.movie:
        writer.writeByte(1);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MediaTypeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class MediaStatusAdapter extends TypeAdapter<MediaStatus> {
  @override
  final int typeId = 102;

  @override
  MediaStatus read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return MediaStatus.downloading;
      case 1:
        return MediaStatus.completed;
      case 2:
        return MediaStatus.missing;
      case 3:
        return MediaStatus.monitored;
      case 4:
        return MediaStatus.continuing;
      case 5:
        return MediaStatus.ended;
      case 6:
        return MediaStatus.upcoming;
      default:
        return MediaStatus.downloading;
    }
  }

  @override
  void write(BinaryWriter writer, MediaStatus obj) {
    switch (obj) {
      case MediaStatus.downloading:
        writer.writeByte(0);
        break;
      case MediaStatus.completed:
        writer.writeByte(1);
        break;
      case MediaStatus.missing:
        writer.writeByte(2);
        break;
      case MediaStatus.monitored:
        writer.writeByte(3);
        break;
      case MediaStatus.continuing:
        writer.writeByte(4);
        break;
      case MediaStatus.ended:
        writer.writeByte(5);
        break;
      case MediaStatus.upcoming:
        writer.writeByte(6);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MediaStatusAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class SeriesStatusAdapter extends TypeAdapter<SeriesStatus> {
  @override
  final int typeId = 103;

  @override
  SeriesStatus read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return SeriesStatus.continuing;
      case 1:
        return SeriesStatus.ended;
      case 2:
        return SeriesStatus.upcoming;
      case 3:
        return SeriesStatus.deleted;
      default:
        return SeriesStatus.continuing;
    }
  }

  @override
  void write(BinaryWriter writer, SeriesStatus obj) {
    switch (obj) {
      case SeriesStatus.continuing:
        writer.writeByte(0);
        break;
      case SeriesStatus.ended:
        writer.writeByte(1);
        break;
      case SeriesStatus.upcoming:
        writer.writeByte(2);
        break;
      case SeriesStatus.deleted:
        writer.writeByte(3);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SeriesStatusAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class DownloadClientTypeAdapter extends TypeAdapter<DownloadClientType> {
  @override
  final int typeId = 104;

  @override
  DownloadClientType read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return DownloadClientType.transmission;
      case 1:
        return DownloadClientType.deluge;
      case 2:
        return DownloadClientType.qbittorrent;
      case 3:
        return DownloadClientType.utorrent;
      case 4:
        return DownloadClientType.sabnzbd;
      case 5:
        return DownloadClientType.nzbget;
      case 6:
        return DownloadClientType.other;
      default:
        return DownloadClientType.transmission;
    }
  }

  @override
  void write(BinaryWriter writer, DownloadClientType obj) {
    switch (obj) {
      case DownloadClientType.transmission:
        writer.writeByte(0);
        break;
      case DownloadClientType.deluge:
        writer.writeByte(1);
        break;
      case DownloadClientType.qbittorrent:
        writer.writeByte(2);
        break;
      case DownloadClientType.utorrent:
        writer.writeByte(3);
        break;
      case DownloadClientType.sabnzbd:
        writer.writeByte(4);
        break;
      case DownloadClientType.nzbget:
        writer.writeByte(5);
        break;
      case DownloadClientType.other:
        writer.writeByte(6);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DownloadClientTypeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
