import 'package:freezed_annotation/freezed_annotation.dart';

part 'download.freezed.dart';

enum DownloadStatus { queued, downloading, paused, completed, failed, warning }

enum DownloadSource { sonarr, radarr }

@freezed
class Download with _$Download {
  const factory Download({
    required int id,
    required String title,
    required DownloadStatus status,
    required DownloadSource source,
    String? quality,
    double? size,
    double? sizeLeft,
    double? progress,
    DateTime? date,
    String? errorMessage,
    String? protocol, // torrent or usenet
    String? eventType, // history: grabbed, downloadFolderImported, etc.
    Map<String, dynamic>? metadata,
  }) = _Download;

  /// Parse from Sonarr/Radarr queue or history JSON.
  /// [sourceOverride] sets the source since API responses don't include it.
  factory Download.fromJson(
    Map<String, dynamic> json, {
    DownloadSource sourceOverride = DownloadSource.sonarr,
  }) {
    final statusStr = json['status'] as String? ?? 'queued';
    final statusStrLower = statusStr.toLowerCase();
    final status = DownloadStatus.values.firstWhere(
      (e) => e.name.toLowerCase() == statusStrLower || statusStrLower.contains(e.name),
      orElse: () => DownloadStatus.queued,
    );

    final size = json['size'] as num?;
    final sizeLeft = json['sizeleft'] as num?;

    double? progress;
    if (size != null && sizeLeft != null && size > 0) {
      progress = ((size - sizeLeft) / size) * 100;
    } else if (json['progress'] != null) {
      progress = (json['progress'] as num).toDouble();
    }

    // For history, map eventType to a meaningful status
    final eventType = json['eventType'] as String?;
    DownloadStatus resolvedStatus = status;
    if (eventType != null) {
      switch (eventType) {
        case 'grabbed':
          resolvedStatus = DownloadStatus.downloading;
          break;
        case 'downloadFolderImported':
        case 'downloadImported':
          resolvedStatus = DownloadStatus.completed;
          break;
        case 'downloadFailed':
          resolvedStatus = DownloadStatus.failed;
          break;
      }
    }

    return Download(
      id: json['id'] as int? ?? json['downloadId'] as int? ?? 0,
      title: json['sourceTitle'] as String? ?? json['title'] as String? ?? '',
      status: resolvedStatus,
      source: sourceOverride,
      quality: json['quality']?['quality']?['name'] as String?,
      size: size?.toDouble(),
      sizeLeft: sizeLeft?.toDouble(),
      progress: progress,
      date: json['date'] != null
          ? DateTime.tryParse(json['date'] as String)
          : json['added'] != null
              ? DateTime.tryParse(json['added'] as String)
              : null,
      errorMessage: json['errorMessage'] as String?,
      protocol: json['protocol'] as String?,
      eventType: eventType,
      metadata: json,
    );
  }

  const Download._();

  /// Check if download is active
  bool get isActive => status == DownloadStatus.downloading || status == DownloadStatus.queued;

  /// Check if download is paused
  bool get isPaused => status == DownloadStatus.paused;

  /// Check if download is complete
  bool get isComplete => status == DownloadStatus.completed;

  /// Check if download has failed
  bool get hasFailed => status == DownloadStatus.failed || status == DownloadStatus.warning;

  /// Check if has progress
  bool get hasProgress => progress != null && progress! >= 0;

  /// Get progress percentage as string
  String get progressText => hasProgress ? '${progress!.toStringAsFixed(1)}%' : '0%';

  /// Get display status text
  String get statusText => status.name.toUpperCase();
}
