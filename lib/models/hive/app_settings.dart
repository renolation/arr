// ========================================
// App Settings Hive Model
// Store application preferences and settings
// ========================================

import 'package:hive/hive.dart';

part 'app_settings.g.dart';

@HiveType(typeId: 170)
class AppSettings extends HiveObject {
  @HiveField(0)
  final String themeMode;

  @HiveField(1)
  final bool useDynamicTheme;

  @HiveField(2)
  final String? accentColor;

  @HiveField(3)
  final bool enableNotifications;

  @HiveField(4)
  final bool backgroundSync;

  @HiveField(5)
  final int syncInterval; // in minutes

  @HiveField(6)
  final bool cacheImages;

  @HiveField(7)
  final int maxCacheSize; // in MB

  @HiveField(8)
  final String defaultServiceType;

  @HiveField(9)
  final String? defaultSonarrService;

  @HiveField(10)
  final String? defaultRadarrService;

  @HiveField(11)
  final bool showDownloadProgress;

  @HiveField(12)
  final bool autoRefresh;

  @HiveField(13)
  final int autoRefreshInterval; // in seconds

  @HiveField(14)
  final String gridLayout; // 'compact', 'comfortable', 'spacious'

  @HiveField(15)
  final int gridColumns;

  @HiveField(16)
  final bool showYear;

  @HiveField(17)
  final bool showRatings;

  @HiveField(18)
  final String sortBy; // 'title', 'added', 'year'

  @HiveField(19)
  final String sortOrder; // 'asc', 'desc'

  @HiveField(20)
  final bool enableHapticFeedback;

  @HiveField(21)
  final bool enableDebugMode;

  @HiveField(22)
  final DateTime? lastUpdated;

  @HiveField(23)
  final List<String> filterMediaTypes; // ['movie', 'series']

  @HiveField(24)
  final List<String> filterStatuses; // ['continuing', 'downloaded', 'downloading', 'missing']

  @HiveField(25)
  final List<String> filterServiceTypes; // ['sonarr', 'radarr']

  AppSettings({
    this.themeMode = 'dark',
    this.useDynamicTheme = true,
    this.accentColor,
    this.enableNotifications = true,
    this.backgroundSync = true,
    this.syncInterval = 30,
    this.cacheImages = true,
    this.maxCacheSize = 500,
    this.defaultServiceType = 'sonarr',
    this.defaultSonarrService,
    this.defaultRadarrService,
    this.showDownloadProgress = true,
    this.autoRefresh = true,
    this.autoRefreshInterval = 300,
    this.gridLayout = 'comfortable',
    this.gridColumns = 2,
    this.showYear = true,
    this.showRatings = true,
    this.sortBy = 'title',
    this.sortOrder = 'asc',
    this.enableHapticFeedback = true,
    this.enableDebugMode = false,
    DateTime? lastUpdated,
    this.filterMediaTypes = const [],
    this.filterStatuses = const [],
    this.filterServiceTypes = const [],
  }) : lastUpdated = lastUpdated ?? DateTime.now();

  /// Get default settings
  static AppSettings get defaultSettings => AppSettings();

  /// Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'themeMode': themeMode,
      'useDynamicTheme': useDynamicTheme,
      'accentColor': accentColor,
      'enableNotifications': enableNotifications,
      'backgroundSync': backgroundSync,
      'syncInterval': syncInterval,
      'cacheImages': cacheImages,
      'maxCacheSize': maxCacheSize,
      'defaultServiceType': defaultServiceType,
      'defaultSonarrService': defaultSonarrService,
      'defaultRadarrService': defaultRadarrService,
      'showDownloadProgress': showDownloadProgress,
      'autoRefresh': autoRefresh,
      'autoRefreshInterval': autoRefreshInterval,
      'gridLayout': gridLayout,
      'gridColumns': gridColumns,
      'showYear': showYear,
      'showRatings': showRatings,
      'sortBy': sortBy,
      'sortOrder': sortOrder,
      'enableHapticFeedback': enableHapticFeedback,
      'enableDebugMode': enableDebugMode,
      'lastUpdated': lastUpdated?.toIso8601String(),
      'filterMediaTypes': filterMediaTypes,
      'filterStatuses': filterStatuses,
      'filterServiceTypes': filterServiceTypes,
    };
  }

  /// Create from JSON
  factory AppSettings.fromJson(Map<String, dynamic> json) {
    return AppSettings(
      themeMode: json['themeMode'] as String? ?? 'dark',
      useDynamicTheme: json['useDynamicTheme'] as bool? ?? true,
      accentColor: json['accentColor'] as String?,
      enableNotifications: json['enableNotifications'] as bool? ?? true,
      backgroundSync: json['backgroundSync'] as bool? ?? true,
      syncInterval: json['syncInterval'] as int? ?? 30,
      cacheImages: json['cacheImages'] as bool? ?? true,
      maxCacheSize: json['maxCacheSize'] as int? ?? 500,
      defaultServiceType:
          json['defaultServiceType'] as String? ?? 'sonarr',
      defaultSonarrService: json['defaultSonarrService'] as String?,
      defaultRadarrService: json['defaultRadarrService'] as String?,
      showDownloadProgress: json['showDownloadProgress'] as bool? ?? true,
      autoRefresh: json['autoRefresh'] as bool? ?? true,
      autoRefreshInterval: json['autoRefreshInterval'] as int? ?? 300,
      gridLayout: json['gridLayout'] as String? ?? 'comfortable',
      gridColumns: json['gridColumns'] as int? ?? 2,
      showYear: json['showYear'] as bool? ?? true,
      showRatings: json['showRatings'] as bool? ?? true,
      sortBy: json['sortBy'] as String? ?? 'title',
      sortOrder: json['sortOrder'] as String? ?? 'asc',
      enableHapticFeedback: json['enableHapticFeedback'] as bool? ?? true,
      enableDebugMode: json['enableDebugMode'] as bool? ?? false,
      lastUpdated: json['lastUpdated'] != null
          ? DateTime.parse(json['lastUpdated'] as String)
          : null,
      filterMediaTypes: (json['filterMediaTypes'] as List?)?.cast<String>() ?? const [],
      filterStatuses: (json['filterStatuses'] as List?)?.cast<String>() ?? const [],
      filterServiceTypes: (json['filterServiceTypes'] as List?)?.cast<String>() ?? const [],
    );
  }

  /// Create a copy with modified fields
  AppSettings copyWith({
    String? themeMode,
    bool? useDynamicTheme,
    String? accentColor,
    bool? enableNotifications,
    bool? backgroundSync,
    int? syncInterval,
    bool? cacheImages,
    int? maxCacheSize,
    String? defaultServiceType,
    String? defaultSonarrService,
    String? defaultRadarrService,
    bool? showDownloadProgress,
    bool? autoRefresh,
    int? autoRefreshInterval,
    String? gridLayout,
    int? gridColumns,
    bool? showYear,
    bool? showRatings,
    String? sortBy,
    String? sortOrder,
    bool? enableHapticFeedback,
    bool? enableDebugMode,
    DateTime? lastUpdated,
    List<String>? filterMediaTypes,
    List<String>? filterStatuses,
    List<String>? filterServiceTypes,
  }) {
    return AppSettings(
      themeMode: themeMode ?? this.themeMode,
      useDynamicTheme: useDynamicTheme ?? this.useDynamicTheme,
      accentColor: accentColor ?? this.accentColor,
      enableNotifications: enableNotifications ?? this.enableNotifications,
      backgroundSync: backgroundSync ?? this.backgroundSync,
      syncInterval: syncInterval ?? this.syncInterval,
      cacheImages: cacheImages ?? this.cacheImages,
      maxCacheSize: maxCacheSize ?? this.maxCacheSize,
      defaultServiceType: defaultServiceType ?? this.defaultServiceType,
      defaultSonarrService: defaultSonarrService ?? this.defaultSonarrService,
      defaultRadarrService: defaultRadarrService ?? this.defaultRadarrService,
      showDownloadProgress:
          showDownloadProgress ?? this.showDownloadProgress,
      autoRefresh: autoRefresh ?? this.autoRefresh,
      autoRefreshInterval:
          autoRefreshInterval ?? this.autoRefreshInterval,
      gridLayout: gridLayout ?? this.gridLayout,
      gridColumns: gridColumns ?? this.gridColumns,
      showYear: showYear ?? this.showYear,
      showRatings: showRatings ?? this.showRatings,
      sortBy: sortBy ?? this.sortBy,
      sortOrder: sortOrder ?? this.sortOrder,
      enableHapticFeedback:
          enableHapticFeedback ?? this.enableHapticFeedback,
      enableDebugMode: enableDebugMode ?? this.enableDebugMode,
      lastUpdated: lastUpdated ?? DateTime.now(),
      filterMediaTypes: filterMediaTypes ?? this.filterMediaTypes,
      filterStatuses: filterStatuses ?? this.filterStatuses,
      filterServiceTypes: filterServiceTypes ?? this.filterServiceTypes,
    );
  }
}
