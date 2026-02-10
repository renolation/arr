// ========================================
// Sync State Hive Model
// Track data freshness and synchronization status
// ========================================

import 'package:hive/hive.dart';

part 'sync_state.g.dart';

@HiveType(typeId: 180)
class SyncState extends HiveObject {
  @HiveField(0)
  final String serviceId;

  @HiveField(1)
  final ServiceSyncType syncType;

  @HiveField(2)
  final DateTime? lastSyncTime;

  @HiveField(3)
  final SyncStatus status;

  @HiveField(4)
  final String? errorMessage;

  @HiveField(5)
  final int? itemsSynced;

  @HiveField(6)
  final int? totalItems;

  @HiveField(7)
  final DateTime? lastSuccessfulSync;

  @HiveField(8)
  final int failedAttempts;

  @HiveField(9)
  final bool isSyncing;

  @HiveField(10)
  final DateTime? nextScheduledSync;

  SyncState({
    required this.serviceId,
    required this.syncType,
    this.lastSyncTime,
    this.status = SyncStatus.idle,
    this.errorMessage,
    this.itemsSynced,
    this.totalItems,
    this.lastSuccessfulSync,
    this.failedAttempts = 0,
    this.isSyncing = false,
    this.nextScheduledSync,
  });

  /// Get sync progress percentage
  double? get syncProgress {
    if (totalItems == null || totalItems == 0 || itemsSynced == null) {
      return null;
    }
    return (itemsSynced! / totalItems!) * 100;
  }

  /// Check if sync is needed (based on age)
  bool get needsSync {
    if (lastSuccessfulSync == null) return true;

    // Different sync intervals based on sync type
    final interval = switch (syncType) {
      ServiceSyncType.series => const Duration(hours: 6),
      ServiceSyncType.movies => const Duration(hours: 6),
      ServiceSyncType.episodes => const Duration(hours: 1),
      ServiceSyncType.requests => const Duration(minutes: 15),
      ServiceSyncType.queue => const Duration(minutes: 5),
      ServiceSyncType.system => const Duration(minutes: 30),
    };

    return DateTime.now().difference(lastSuccessfulSync!) > interval;
  }

  /// Check if sync is stale (data too old)
  bool get isStale {
    if (lastSuccessfulSync == null) return true;

    // Consider stale after 2x the normal sync interval
    final staleThreshold = switch (syncType) {
      ServiceSyncType.series => const Duration(hours: 12),
      ServiceSyncType.movies => const Duration(hours: 12),
      ServiceSyncType.episodes => const Duration(hours: 2),
      ServiceSyncType.requests => const Duration(hours: 1),
      ServiceSyncType.queue => const Duration(minutes: 15),
      ServiceSyncType.system => const Duration(hours: 1),
    };

    return DateTime.now().difference(lastSuccessfulSync!) > staleThreshold;
  }

  /// Get time since last sync
  Duration? get timeSinceLastSync {
    if (lastSyncTime == null) return null;
    return DateTime.now().difference(lastSyncTime!);
  }

  /// Get time since last successful sync
  Duration? get timeSinceLastSuccess {
    if (lastSuccessfulSync == null) return null;
    return DateTime.now().difference(lastSuccessfulSync!);
  }

  /// Check if can retry sync (after failures)
  bool get canRetry {
    if (failedAttempts == 0) return true;

    // Exponential backoff: 2^n minutes
    final waitTime = Duration(minutes: 1 << (failedAttempts - 1));
    final timeSinceLastSync = lastSyncTime != null
        ? DateTime.now().difference(lastSyncTime!)
        : Duration.zero;

    return timeSinceLastSync > waitTime;
  }

  /// Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'serviceId': serviceId,
      'syncType': syncType.name,
      'lastSyncTime': lastSyncTime?.toIso8601String(),
      'status': status.name,
      'errorMessage': errorMessage,
      'itemsSynced': itemsSynced,
      'totalItems': totalItems,
      'lastSuccessfulSync': lastSuccessfulSync?.toIso8601String(),
      'failedAttempts': failedAttempts,
      'isSyncing': isSyncing,
      'nextScheduledSync': nextScheduledSync?.toIso8601String(),
    };
  }

  /// Create from JSON
  factory SyncState.fromJson(Map<String, dynamic> json) {
    return SyncState(
      serviceId: json['serviceId'] as String,
      syncType: ServiceSyncType.values.firstWhere(
        (e) => e.name == json['syncType'],
        orElse: () => ServiceSyncType.series,
      ),
      lastSyncTime: json['lastSyncTime'] != null
          ? DateTime.parse(json['lastSyncTime'] as String)
          : null,
      status: SyncStatus.values.firstWhere(
        (e) => e.name == json['status'],
        orElse: () => SyncStatus.idle,
      ),
      errorMessage: json['errorMessage'] as String?,
      itemsSynced: json['itemsSynced'] as int?,
      totalItems: json['totalItems'] as int?,
      lastSuccessfulSync: json['lastSuccessfulSync'] != null
          ? DateTime.parse(json['lastSuccessfulSync'] as String)
          : null,
      failedAttempts: json['failedAttempts'] as int? ?? 0,
      isSyncing: json['isSyncing'] as bool? ?? false,
      nextScheduledSync: json['nextScheduledSync'] != null
          ? DateTime.parse(json['nextScheduledSync'] as String)
          : null,
    );
  }

  /// Create a copy with modified fields
  SyncState copyWith({
    String? serviceId,
    ServiceSyncType? syncType,
    DateTime? lastSyncTime,
    SyncStatus? status,
    String? errorMessage,
    int? itemsSynced,
    int? totalItems,
    DateTime? lastSuccessfulSync,
    int? failedAttempts,
    bool? isSyncing,
    DateTime? nextScheduledSync,
  }) {
    return SyncState(
      serviceId: serviceId ?? this.serviceId,
      syncType: syncType ?? this.syncType,
      lastSyncTime: lastSyncTime ?? this.lastSyncTime,
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
      itemsSynced: itemsSynced ?? this.itemsSynced,
      totalItems: totalItems ?? this.totalItems,
      lastSuccessfulSync: lastSuccessfulSync ?? this.lastSuccessfulSync,
      failedAttempts: failedAttempts ?? this.failedAttempts,
      isSyncing: isSyncing ?? this.isSyncing,
      nextScheduledSync: nextScheduledSync ?? this.nextScheduledSync,
    );
  }
}

/// Service sync type enum
@HiveType(typeId: 181)
enum ServiceSyncType {
  @HiveField(0)
  series,
  @HiveField(1)
  movies,
  @HiveField(2)
  episodes,
  @HiveField(3)
  requests,
  @HiveField(4)
  queue,
  @HiveField(5)
  system,
}

/// Sync status enum
@HiveType(typeId: 182)
enum SyncStatus {
  @HiveField(0)
  idle,
  @HiveField(1)
  syncing,
  @HiveField(2)
  success,
  @HiveField(3)
  error,
  @HiveField(4)
  cancelled,
  @HiveField(5)
  partial,
}
