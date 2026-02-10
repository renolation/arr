import 'package:freezed_annotation/freezed_annotation.dart';

part 'system_status.freezed.dart';

/// System status entity for *arr services
@freezed
class SystemStatus with _$SystemStatus {
  const factory SystemStatus({
    required String version,
    required String buildTime,
    required bool isDebug,
    required DateTime startTime,
    required String operatingSystem,
    required String runtimeVersion,
    String? appData,
    String? instanceName,
  }) = _SystemStatus;

  factory SystemStatus.fromJson(Map<String, dynamic> json) {
    return SystemStatus(
      version: json['version'] as String? ?? 'Unknown',
      buildTime: json['buildTime'] as String? ?? '',
      isDebug: json['isDebug'] as bool? ?? false,
      startTime: DateTime.tryParse(json['startTime'] as String? ?? '') ?? DateTime.now(),
      operatingSystem: json['operatingSystem'] as String? ?? 'Unknown',
      runtimeVersion: json['runtimeVersion'] as String? ?? 'Unknown',
      appData: json['appData'] as String?,
      instanceName: json['instanceName'] as String?,
    );
  }

  const SystemStatus._();

  /// Get uptime duration
  Duration get uptime => DateTime.now().difference(startTime);
}
