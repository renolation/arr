// ========================================
// Image Hive Model
// Optimized for caching media images
// ========================================

import 'package:hive/hive.dart';

part 'image_hive.g.dart';

@HiveType(typeId: 110)
class ImageHive extends HiveObject {
  @HiveField(0)
  final String coverType;

  @HiveField(1)
  final String? url;

  @HiveField(2)
  final String? remoteUrl;

  ImageHive({
    required this.coverType,
    this.url,
    this.remoteUrl,
  });

  /// Convert from API MediaCover model
  factory ImageHive.fromMediaCover(dynamic mediaCover) {
    if (mediaCover == null) {
      return ImageHive(coverType: 'poster');
    }

    // Handle Map (from JSON)
    if (mediaCover is Map) {
      return ImageHive(
        coverType: mediaCover['coverType'] as String? ?? 'poster',
        url: mediaCover['url'] as String?,
        remoteUrl: mediaCover['remoteUrl'] as String?,
      );
    }

    // Handle already converted object
    return ImageHive(
      coverType: 'poster',
      url: mediaCover.toString(),
    );
  }

  /// Get the best available URL
  String? get bestUrl => remoteUrl ?? url;

  /// Check if this is a poster image
  bool get isPoster => coverType == 'poster';

  /// Check if this is a fanart/backdrop image
  bool get isFanart => coverType == 'fanart';

  /// Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'coverType': coverType,
      'url': url,
      'remoteUrl': remoteUrl,
    };
  }

  /// Create a copy with modified fields
  ImageHive copyWith({
    String? coverType,
    String? url,
    String? remoteUrl,
  }) {
    return ImageHive(
      coverType: coverType ?? this.coverType,
      url: url ?? this.url,
      remoteUrl: remoteUrl ?? this.remoteUrl,
    );
  }
}
