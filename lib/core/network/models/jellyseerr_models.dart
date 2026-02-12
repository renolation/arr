/// Jellyseerr/Overseerr API status codes for media availability
enum JellyseerrMediaStatus {
  unknown(1),
  pending(2),
  processing(3),
  partiallyAvailable(4),
  available(5);

  final int value;
  const JellyseerrMediaStatus(this.value);

  static JellyseerrMediaStatus fromValue(int? value) {
    return JellyseerrMediaStatus.values.firstWhere(
      (s) => s.value == value,
      orElse: () => JellyseerrMediaStatus.unknown,
    );
  }
}

/// Jellyseerr request status
enum JellyseerrRequestStatus {
  pendingApproval(1),
  approved(2),
  declined(3);

  final int value;
  const JellyseerrRequestStatus(this.value);

  static JellyseerrRequestStatus fromValue(int? value) {
    return JellyseerrRequestStatus.values.firstWhere(
      (s) => s.value == value,
      orElse: () => JellyseerrRequestStatus.pendingApproval,
    );
  }
}

/// Media availability info attached to search/discover results
class JellyseerrMediaInfo {
  final int? id;
  final int? tmdbId;
  final int? tvdbId;
  final JellyseerrMediaStatus status;
  final JellyseerrMediaStatus status4k;
  final String? mediaType;

  const JellyseerrMediaInfo({
    this.id,
    this.tmdbId,
    this.tvdbId,
    this.status = JellyseerrMediaStatus.unknown,
    this.status4k = JellyseerrMediaStatus.unknown,
    this.mediaType,
  });

  factory JellyseerrMediaInfo.fromJson(Map<String, dynamic> json) {
    return JellyseerrMediaInfo(
      id: json['id'] as int?,
      tmdbId: json['tmdbId'] as int?,
      tvdbId: json['tvdbId'] as int?,
      status: JellyseerrMediaStatus.fromValue(json['status'] as int?),
      status4k: JellyseerrMediaStatus.fromValue(json['status4k'] as int?),
      mediaType: json['mediaType'] as String?,
    );
  }
}

/// A media result from discovery or search endpoints
class JellyseerrMediaResult {
  final int id;
  final String mediaType; // 'movie' or 'tv'
  final String title;
  final String? overview;
  final String? posterPath;
  final String? backdropPath;
  final String? releaseDate; // movie
  final String? firstAirDate; // tv
  final double? voteAverage;
  final int? voteCount;
  final String? originalLanguage;
  final List<int>? genreIds;
  final double? popularity;
  final JellyseerrMediaInfo? mediaInfo;

  const JellyseerrMediaResult({
    required this.id,
    required this.mediaType,
    required this.title,
    this.overview,
    this.posterPath,
    this.backdropPath,
    this.releaseDate,
    this.firstAirDate,
    this.voteAverage,
    this.voteCount,
    this.originalLanguage,
    this.genreIds,
    this.popularity,
    this.mediaInfo,
  });

  factory JellyseerrMediaResult.fromJson(Map<String, dynamic> json) {
    // mediaType comes from the result itself or parent context
    final mediaType = json['mediaType'] as String? ?? 'movie';

    // Title field differs: 'title' for movies, 'name' for TV
    final title = json['title'] as String? ??
        json['name'] as String? ??
        '';

    return JellyseerrMediaResult(
      id: json['id'] as int? ?? 0,
      mediaType: mediaType,
      title: title,
      overview: json['overview'] as String?,
      posterPath: json['posterPath'] as String?,
      backdropPath: json['backdropPath'] as String?,
      releaseDate: json['releaseDate'] as String?,
      firstAirDate: json['firstAirDate'] as String?,
      voteAverage: (json['voteAverage'] as num?)?.toDouble(),
      voteCount: json['voteCount'] as int?,
      originalLanguage: json['originalLanguage'] as String?,
      genreIds: (json['genreIds'] as List?)?.cast<int>(),
      popularity: (json['popularity'] as num?)?.toDouble(),
      mediaInfo: json['mediaInfo'] != null
          ? JellyseerrMediaInfo.fromJson(json['mediaInfo'] as Map<String, dynamic>)
          : null,
    );
  }

  /// Get the display date (releaseDate for movies, firstAirDate for TV)
  String? get displayDate => mediaType == 'movie' ? releaseDate : firstAirDate;

  /// Get year from the display date
  int? get year {
    final date = displayDate;
    if (date == null || date.isEmpty) return null;
    return DateTime.tryParse(date)?.year;
  }

  /// Full poster URL via TMDB image CDN
  String? get fullPosterUrl =>
      posterPath != null ? 'https://image.tmdb.org/t/p/w500$posterPath' : null;

  /// Full backdrop URL via TMDB image CDN
  String? get fullBackdropUrl =>
      backdropPath != null ? 'https://image.tmdb.org/t/p/w780$backdropPath' : null;

  /// Whether media is available in the library
  bool get isAvailable => mediaInfo?.status == JellyseerrMediaStatus.available;

  /// Whether media has a pending request
  bool get isPending => mediaInfo?.status == JellyseerrMediaStatus.pending;

  /// Whether media is being processed/downloaded
  bool get isProcessing => mediaInfo?.status == JellyseerrMediaStatus.processing;
}

/// Basic user info from Jellyseerr
class JellyseerrUser {
  final int id;
  final String? displayName;
  final String? avatar;
  final String? email;

  const JellyseerrUser({
    required this.id,
    this.displayName,
    this.avatar,
    this.email,
  });

  factory JellyseerrUser.fromJson(Map<String, dynamic> json) {
    return JellyseerrUser(
      id: json['id'] as int? ?? 0,
      displayName: json['displayName'] as String? ?? json['username'] as String?,
      avatar: json['avatar'] as String?,
      email: json['email'] as String?,
    );
  }
}

/// A media request from Jellyseerr
class JellyseerrRequest {
  final int id;
  final JellyseerrRequestStatus status;
  final String mediaType; // 'movie' or 'tv'
  final JellyseerrMediaInfo? media;
  final JellyseerrUser? requestedBy;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final List<JellyseerrRequestSeason>? seasons;
  final bool is4k;

  const JellyseerrRequest({
    required this.id,
    required this.status,
    required this.mediaType,
    this.media,
    this.requestedBy,
    this.createdAt,
    this.updatedAt,
    this.seasons,
    this.is4k = false,
  });

  factory JellyseerrRequest.fromJson(Map<String, dynamic> json) {
    return JellyseerrRequest(
      id: json['id'] as int? ?? 0,
      status: JellyseerrRequestStatus.fromValue(json['status'] as int?),
      mediaType: json['type'] as String? ?? json['mediaType'] as String? ?? 'movie',
      media: json['media'] != null
          ? JellyseerrMediaInfo.fromJson(json['media'] as Map<String, dynamic>)
          : null,
      requestedBy: json['requestedBy'] != null
          ? JellyseerrUser.fromJson(json['requestedBy'] as Map<String, dynamic>)
          : null,
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'] as String)
          : null,
      updatedAt: json['updatedAt'] != null
          ? DateTime.tryParse(json['updatedAt'] as String)
          : null,
      seasons: (json['seasons'] as List?)
          ?.map((s) => JellyseerrRequestSeason.fromJson(s as Map<String, dynamic>))
          .toList(),
      is4k: json['is4k'] as bool? ?? false,
    );
  }

  bool get isPending => status == JellyseerrRequestStatus.pendingApproval;
  bool get isApproved => status == JellyseerrRequestStatus.approved;
  bool get isDeclined => status == JellyseerrRequestStatus.declined;
}

/// Season info within a request
class JellyseerrRequestSeason {
  final int id;
  final int seasonNumber;
  final JellyseerrMediaStatus status;

  const JellyseerrRequestSeason({
    required this.id,
    required this.seasonNumber,
    this.status = JellyseerrMediaStatus.unknown,
  });

  factory JellyseerrRequestSeason.fromJson(Map<String, dynamic> json) {
    return JellyseerrRequestSeason(
      id: json['id'] as int? ?? 0,
      seasonNumber: json['seasonNumber'] as int? ?? 0,
      status: JellyseerrMediaStatus.fromValue(json['status'] as int?),
    );
  }
}

/// Generic paginated response wrapper for Jellyseerr list endpoints
class PagedResponse<T> {
  final int page;
  final int totalPages;
  final int totalResults;
  final List<T> results;

  const PagedResponse({
    required this.page,
    required this.totalPages,
    required this.totalResults,
    required this.results,
  });

  factory PagedResponse.fromJson(
    Map<String, dynamic> json,
    T Function(Map<String, dynamic>) fromJsonT,
  ) {
    return PagedResponse<T>(
      page: json['page'] as int? ?? json['pageInfo']?['page'] as int? ?? 1,
      totalPages: json['totalPages'] as int? ?? json['pageInfo']?['pages'] as int? ?? 1,
      totalResults: json['totalResults'] as int? ?? json['pageInfo']?['results'] as int? ?? 0,
      results: (json['results'] as List?)
              ?.map((item) => fromJsonT(item as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }

  bool get hasNextPage => page < totalPages;
  bool get isEmpty => results.isEmpty;
}
