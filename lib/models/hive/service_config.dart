// ========================================
// Service Configuration Hive Model
// Store service endpoints and settings
// NOTE: API keys should be stored in flutter_secure_storage, NOT here
// ========================================

import 'package:hive/hive.dart';
import 'enums.dart';

part 'service_config.g.dart';

@HiveType(typeId: 120)
class ServiceConfig extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final ServiceType type;

  @HiveField(3)
  final String baseUrl;

  @HiveField(4)
  final String? applicationUrl;

  @HiveField(5)
  final int? port;

  @HiveField(6)
  final bool isEnabled;

  @HiveField(7)
  final DateTime? lastSync;

  @HiveField(8)
  final int? priority;

  @HiveField(9)
  final Map<String, dynamic>? settings;

  ServiceConfig({
    required this.id,
    required this.name,
    required this.type,
    required this.baseUrl,
    this.applicationUrl,
    this.port,
    this.isEnabled = true,
    this.lastSync,
    this.priority,
    this.settings,
  });

  /// Get the full URL for the service
  String get fullUrl {
    if (port != null && port! > 0) {
      return '$baseUrl:$port';
    }
    return baseUrl;
  }

  /// Check if service is ready to use
  bool get isReady => isEnabled && baseUrl.isNotEmpty;

  /// Get API key from secure storage reference
  /// This is just a reference - actual storage handled by flutter_secure_storage
  String get apiKeyRef => 'api_key_${id}_${type.name}';

  /// Create from JSON
  factory ServiceConfig.fromJson(Map<String, dynamic> json) {
    return ServiceConfig(
      id: json['id'] as String,
      name: json['name'] as String,
      type: ServiceType.values.firstWhere(
        (e) => e.name == json['type'],
        orElse: () => ServiceType.sonarr,
      ),
      baseUrl: json['baseUrl'] as String,
      applicationUrl: json['applicationUrl'] as String?,
      port: json['port'] as int?,
      isEnabled: json['isEnabled'] as bool? ?? true,
      lastSync: json['lastSync'] != null
          ? DateTime.parse(json['lastSync'] as String)
          : null,
      priority: json['priority'] as int?,
      settings: json['settings'] as Map<String, dynamic>?,
    );
  }

  /// Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'type': type.name,
      'baseUrl': baseUrl,
      'applicationUrl': applicationUrl,
      'port': port,
      'isEnabled': isEnabled,
      'lastSync': lastSync?.toIso8601String(),
      'priority': priority,
      'settings': settings,
    };
  }

  /// Create a copy with modified fields
  ServiceConfig copyWith({
    String? id,
    String? name,
    ServiceType? type,
    String? baseUrl,
    String? applicationUrl,
    int? port,
    bool? isEnabled,
    DateTime? lastSync,
    int? priority,
    Map<String, dynamic>? settings,
  }) {
    return ServiceConfig(
      id: id ?? this.id,
      name: name ?? this.name,
      type: type ?? this.type,
      baseUrl: baseUrl ?? this.baseUrl,
      applicationUrl: applicationUrl ?? this.applicationUrl,
      port: port ?? this.port,
      isEnabled: isEnabled ?? this.isEnabled,
      lastSync: lastSync ?? this.lastSync,
      priority: priority ?? this.priority,
      settings: settings ?? this.settings,
    );
  }

  /// Generate a unique ID for new service
  static String generateId() {
    return 'svc_${DateTime.now().millisecondsSinceEpoch}';
  }
}
