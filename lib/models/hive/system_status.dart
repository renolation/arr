// ========================================
// System Status Hive Model
// Store system metrics and health information
// ========================================

import 'package:hive/hive.dart';

part 'system_status.g.dart';

@HiveType(typeId: 190)
class SystemStatus extends HiveObject {
  @HiveField(0)
  final String serviceId;

  @HiveField(1)
  final DateTime? timestamp;

  @HiveField(2)
  final String? version;

  @HiveField(3)
  final String? buildTime;

  @HiveField(4)
  final bool? isMigration;

  @HiveField(5)
  final String? appName;

  @HiveField(6)
  final String? instanceName;

  @HiveField(7)
  final DiskSpaceInfo? diskSpace;

  @HiveField(8)
  final List<HealthIssue>? healthIssues;

  @HiveField(9)
  final int? queueSize;

  @HiveField(10)
  final int? missingMovies;

  @HiveField(11)
  final int? missingEpisodes;

  @HiveField(12)
  final double? downloadSpeed;

  @HiveField(13)
  final double? uploadSpeed;

  @HiveField(14)
  final String? status;

  @HiveField(15)
  final Map<String, dynamic>? metadata;

  SystemStatus({
    required this.serviceId,
    DateTime? timestamp,
    this.version,
    this.buildTime,
    this.isMigration,
    this.appName,
    this.instanceName,
    this.diskSpace,
    this.healthIssues,
    this.queueSize,
    this.missingMovies,
    this.missingEpisodes,
    this.downloadSpeed,
    this.uploadSpeed,
    this.status,
    this.metadata,
  }) : timestamp = timestamp ?? DateTime.now();

  /// Check if system is healthy
  bool get isHealthy {
    if (status == 'error' || status == 'warning') return false;
    if (healthIssues != null && healthIssues!.isNotEmpty) {
      // Check for critical issues
      if (healthIssues!.any((issue) => issue.type == HealthIssueType.error)) {
        return false;
      }
    }
    return true;
  }

  /// Get critical health issues
  List<HealthIssue> get criticalIssues {
    return healthIssues
            ?.where((issue) => issue.type == HealthIssueType.error)
            .toList() ??
        [];
  }

  /// Get warning health issues
  List<HealthIssue> get warningIssues {
    return healthIssues
            ?.where((issue) => issue.type == HealthIssueType.warning)
            .toList() ??
        [];
  }

  /// Format disk space usage
  String? get formattedDiskSpace {
    if (diskSpace == null) return null;
    return '${diskSpace!.used} GB / ${diskSpace!.total} GB (${diskSpace!.free} GB free)';
  }

  /// Format download speed
  String? get formattedDownloadSpeed {
    if (downloadSpeed == null) return null;
    return '${downloadSpeed!.toStringAsFixed(2)} MB/s';
  }

  /// Format upload speed
  String? get formattedUploadSpeed {
    if (uploadSpeed == null) return null;
    return '${uploadSpeed!.toStringAsFixed(2)} MB/s';
  }

  /// Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'serviceId': serviceId,
      'timestamp': timestamp?.toIso8601String(),
      'version': version,
      'buildTime': buildTime,
      'isMigration': isMigration,
      'appName': appName,
      'instanceName': instanceName,
      'diskSpace': diskSpace?.toJson(),
      'healthIssues': healthIssues?.map((e) => e.toJson()).toList(),
      'queueSize': queueSize,
      'missingMovies': missingMovies,
      'missingEpisodes': missingEpisodes,
      'downloadSpeed': downloadSpeed,
      'uploadSpeed': uploadSpeed,
      'status': status,
      'metadata': metadata,
    };
  }

  /// Create from JSON
  factory SystemStatus.fromJson(Map<String, dynamic> json) {
    return SystemStatus(
      serviceId: json['serviceId'] as String,
      timestamp: json['timestamp'] != null
          ? DateTime.parse(json['timestamp'] as String)
          : null,
      version: json['version'] as String?,
      buildTime: json['buildTime'] as String?,
      isMigration: json['isMigration'] as bool?,
      appName: json['appName'] as String?,
      instanceName: json['instanceName'] as String?,
      diskSpace: json['diskSpace'] != null
          ? DiskSpaceInfo.fromJson(json['diskSpace'] as Map<String, dynamic>)
          : null,
      healthIssues: (json['healthIssues'] as List<dynamic>?)
          ?.map((e) => HealthIssue.fromJson(e as Map<String, dynamic>))
          .toList(),
      queueSize: json['queueSize'] as int?,
      missingMovies: json['missingMovies'] as int?,
      missingEpisodes: json['missingEpisodes'] as int?,
      downloadSpeed: (json['downloadSpeed'] as num?)?.toDouble(),
      uploadSpeed: (json['uploadSpeed'] as num?)?.toDouble(),
      status: json['status'] as String?,
      metadata: json['metadata'] as Map<String, dynamic>?,
    );
  }

  /// Create a copy with modified fields
  SystemStatus copyWith({
    String? serviceId,
    DateTime? timestamp,
    String? version,
    String? buildTime,
    bool? isMigration,
    String? appName,
    String? instanceName,
    DiskSpaceInfo? diskSpace,
    List<HealthIssue>? healthIssues,
    int? queueSize,
    int? missingMovies,
    int? missingEpisodes,
    double? downloadSpeed,
    double? uploadSpeed,
    String? status,
    Map<String, dynamic>? metadata,
  }) {
    return SystemStatus(
      serviceId: serviceId ?? this.serviceId,
      timestamp: timestamp ?? this.timestamp,
      version: version ?? this.version,
      buildTime: buildTime ?? this.buildTime,
      isMigration: isMigration ?? this.isMigration,
      appName: appName ?? this.appName,
      instanceName: instanceName ?? this.instanceName,
      diskSpace: diskSpace ?? this.diskSpace,
      healthIssues: healthIssues ?? this.healthIssues,
      queueSize: queueSize ?? this.queueSize,
      missingMovies: missingMovies ?? this.missingMovies,
      missingEpisodes: missingEpisodes ?? this.missingEpisodes,
      downloadSpeed: downloadSpeed ?? this.downloadSpeed,
      uploadSpeed: uploadSpeed ?? this.uploadSpeed,
      status: status ?? this.status,
      metadata: metadata ?? this.metadata,
    );
  }
}

/// Disk space information
@HiveType(typeId: 191)
class DiskSpaceInfo extends HiveObject {
  @HiveField(0)
  final String? label;

  @HiveField(1)
  final String? path;

  @HiveField(2)
  final double? free;

  @HiveField(3)
  final double? total;

  @HiveField(4)
  final String? freeSpace;

  @HiveField(5)
  final String? totalSpace;

  DiskSpaceInfo({
    this.label,
    this.path,
    this.free,
    this.total,
    this.freeSpace,
    this.totalSpace,
  });

  /// Get used space in GB
  double? get used => total != null && free != null ? total! - free! : null;

  /// Get usage percentage
  double? get usagePercentage {
    if (total == null || free == null) return null;
    return ((total! - free!) / total!) * 100;
  }

  /// Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'label': label,
      'path': path,
      'free': free,
      'total': total,
      'freeSpace': freeSpace,
      'totalSpace': totalSpace,
    };
  }

  /// Create from JSON
  factory DiskSpaceInfo.fromJson(Map<String, dynamic> json) {
    return DiskSpaceInfo(
      label: json['label'] as String?,
      path: json['path'] as String?,
      free: (json['free'] as num?)?.toDouble(),
      total: (json['total'] as num?)?.toDouble(),
      freeSpace: json['freeSpace'] as String?,
      totalSpace: json['totalSpace'] as String?,
    );
  }

  /// Create a copy
  DiskSpaceInfo copyWith({
    String? label,
    String? path,
    double? free,
    double? total,
    String? freeSpace,
    String? totalSpace,
  }) {
    return DiskSpaceInfo(
      label: label ?? this.label,
      path: path ?? this.path,
      free: free ?? this.free,
      total: total ?? this.total,
      freeSpace: freeSpace ?? this.freeSpace,
      totalSpace: totalSpace ?? this.totalSpace,
    );
  }
}

/// Health issue information
@HiveType(typeId: 192)
class HealthIssue extends HiveObject {
  @HiveField(0)
  final int? id;

  @HiveField(1)
  final String? source;

  @HiveField(2)
  final HealthIssueType type;

  @HiveField(3)
  final String? message;

  @HiveField(4)
  final WikiLink? wiki;

  @HiveField(5)
  final DateTime? timestamp;

  HealthIssue({
    this.id,
    this.source,
    required this.type,
    this.message,
    this.wiki,
    DateTime? timestamp,
  }) : timestamp = timestamp ?? DateTime.now();

  /// Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'source': source,
      'type': type.name,
      'message': message,
      'wiki': wiki?.toJson(),
      'timestamp': timestamp?.toIso8601String(),
    };
  }

  /// Create from JSON
  factory HealthIssue.fromJson(Map<String, dynamic> json) {
    return HealthIssue(
      id: json['id'] as int?,
      source: json['source'] as String?,
      type: HealthIssueType.values.firstWhere(
        (e) => e.name == json['type'],
        orElse: () => HealthIssueType.warning,
      ),
      message: json['message'] as String?,
      wiki: json['wiki'] != null
          ? WikiLink.fromJson(json['wiki'] as Map<String, dynamic>)
          : null,
      timestamp: json['timestamp'] != null
          ? DateTime.parse(json['timestamp'] as String)
          : null,
    );
  }

  /// Create a copy
  HealthIssue copyWith({
    int? id,
    String? source,
    HealthIssueType? type,
    String? message,
    WikiLink? wiki,
    DateTime? timestamp,
  }) {
    return HealthIssue(
      id: id ?? this.id,
      source: source ?? this.source,
      type: type ?? this.type,
      message: message ?? this.message,
      wiki: wiki ?? this.wiki,
      timestamp: timestamp ?? this.timestamp,
    );
  }
}

/// Health issue type enum
@HiveType(typeId: 193)
enum HealthIssueType {
  @HiveField(0)
  info,
  @HiveField(1)
  notice,
  @HiveField(2)
  warning,
  @HiveField(3)
  error,
}

/// Wiki link for health issues
@HiveType(typeId: 194)
class WikiLink extends HiveObject {
  @HiveField(0)
  final String? name;

  @HiveField(1)
  final String? url;

  WikiLink({
    this.name,
    this.url,
  });

  /// Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'url': url,
    };
  }

  /// Create from JSON
  factory WikiLink.fromJson(Map<String, dynamic> json) {
    return WikiLink(
      name: json['name'] as String?,
      url: json['url'] as String?,
    );
  }

  /// Create a copy
  WikiLink copyWith({
    String? name,
    String? url,
  }) {
    return WikiLink(
      name: name ?? this.name,
      url: url ?? this.url,
    );
  }
}
