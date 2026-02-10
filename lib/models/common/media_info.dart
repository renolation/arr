// ========================================
// Media Info
// Shared between Sonarr & Radarr
// ========================================

import 'package:equatable/equatable.dart';

class MediaInfoResource extends Equatable {
  final String? audioChannels;
  final String? audioCodec;
  final String? audioLanguages;
  final int? height;
  final String? runTime;
  final String? scanType;
  final String? subtitles;
  final String? videoCodec;
  final String? videoFps;
  final String? videoDynamicRange;
  final String? videoDynamicRangeType;
  final int? width;

  const MediaInfoResource({
    this.audioChannels,
    this.audioCodec,
    this.audioLanguages,
    this.height,
    this.runTime,
    this.scanType,
    this.subtitles,
    this.videoCodec,
    this.videoFps,
    this.videoDynamicRange,
    this.videoDynamicRangeType,
    this.width,
  });

  @override
  List<Object?> get props => [audioChannels, audioCodec, audioLanguages, height, runTime, scanType, subtitles, videoCodec, videoFps, videoDynamicRange, videoDynamicRangeType, width];

  factory MediaInfoResource.fromJson(Map<String, dynamic> json) {
    return MediaInfoResource(
      audioChannels: json['audioChannels'].toString(),
      audioCodec: json['audioCodec'] as String?,
      audioLanguages: json['audioLanguages'] as String?,
      height: json['height'] as int?,
      runTime: json['runTime'] as String?,
      scanType: json['scanType'] as String?,
      subtitles: json['subtitles'] as String?,
      videoCodec: json['videoCodec'] as String?,
      videoFps: json['videoFps'].toString(),
      videoDynamicRange: json['videoDynamicRange'] as String?,
      videoDynamicRangeType: json['videoDynamicRangeType'] as String?,
      width: json['width'] as int?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'audioChannels': audioChannels,
      'audioCodec': audioCodec,
      'audioLanguages': audioLanguages,
      'height': height,
      'runTime': runTime,
      'scanType': scanType,
      'subtitles': subtitles,
      'videoCodec': videoCodec,
      'videoFps': videoFps,
      'videoDynamicRange': videoDynamicRange,
      'videoDynamicRangeType': videoDynamicRangeType,
      'width': width,
    };
  }

  MediaInfoResource copyWith({
    String? audioChannels,
    String? audioCodec,
    String? audioLanguages,
    int? height,
    String? runTime,
    String? scanType,
    String? subtitles,
    String? videoCodec,
    String? videoFps,
    String? videoDynamicRange,
    String? videoDynamicRangeType,
    int? width,
  }) {
    return MediaInfoResource(
      audioChannels: audioChannels ?? this.audioChannels,
      audioCodec: audioCodec ?? this.audioCodec,
      audioLanguages: audioLanguages ?? this.audioLanguages,
      height: height ?? this.height,
      runTime: runTime ?? this.runTime,
      scanType: scanType ?? this.scanType,
      subtitles: subtitles ?? this.subtitles,
      videoCodec: videoCodec ?? this.videoCodec,
      videoFps: videoFps ?? this.videoFps,
      videoDynamicRange: videoDynamicRange ?? this.videoDynamicRange,
      videoDynamicRangeType: videoDynamicRangeType ?? this.videoDynamicRangeType,
      width: width ?? this.width,
    );
  }
}
