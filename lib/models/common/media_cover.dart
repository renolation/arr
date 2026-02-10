// ========================================
// Media Cover
// Shared between Sonarr & Radarr
// ========================================

import 'package:equatable/equatable.dart';

class MediaCover extends Equatable {
  final String? coverType;
  final String? url;
  final String? remoteUrl;

  const MediaCover({
    this.coverType,
    this.url,
    this.remoteUrl,
  });

  @override
  List<Object?> get props => [coverType, url, remoteUrl];

  factory MediaCover.fromJson(Map<String, dynamic> json) {
    return MediaCover(
      coverType: json['coverType'] as String?,
      url: json['url'] as String?,
      remoteUrl: json['remoteUrl'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'coverType': coverType,
      'url': url,
      'remoteUrl': remoteUrl,
    };
  }

  MediaCover copyWith({
    String? coverType,
    String? url,
    String? remoteUrl,
  }) {
    return MediaCover(
      coverType: coverType ?? this.coverType,
      url: url ?? this.url,
      remoteUrl: remoteUrl ?? this.remoteUrl,
    );
  }
}
