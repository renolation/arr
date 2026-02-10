import 'package:freezed_annotation/freezed_annotation.dart';

part 'service_config.freezed.dart';

enum ServiceType { sonarr, radarr, overseerr, downloadClient }

@freezed
class ServiceConfig with _$ServiceConfig {
  const factory ServiceConfig({
    required String key,
    required ServiceType type,
    required String name,
    required String url,
    String? apiKey, // This should not be stored in toJson
    int? port,
    bool? isActive,
    DateTime? lastSync,
    Map<String, dynamic>? settings,
  }) = _ServiceConfig;

  factory ServiceConfig.fromJson(Map<String, dynamic> json) {
    final typeStr = json['type'] as String? ?? 'sonarr';
    final type = ServiceType.values.firstWhere(
      (e) => e.name.toLowerCase() == typeStr.toLowerCase(),
      orElse: () => ServiceType.sonarr,
    );

    return ServiceConfig(
      key: json['key'] as String? ?? json['name'] as String? ?? '',
      type: type,
      name: json['name'] as String? ?? '',
      url: json['url'] as String? ?? '',
      apiKey: json['apiKey'] as String?, // Only present when loaded with API key
      port: json['port'] as int?,
      isActive: json['isActive'] as bool? ?? true,
      lastSync: json['lastSync'] != null
          ? DateTime.tryParse(json['lastSync'] as String)
          : null,
      settings: json['settings'] as Map<String, dynamic>?,
    );
  }

  const ServiceConfig._();

  /// Get full base URL
  String get baseUrl {
    if (port != null && port! > 0) {
      return '$url:$port';
    }
    return url;
  }

  /// Check if service is properly configured
  bool get isConfigured => url.isNotEmpty && (apiKey?.isNotEmpty ?? false);

  /// Convert to JSON (excluding API key)
  Map<String, dynamic> toJson() {
    final json = {
      'key': key,
      'type': type.name,
      'name': name,
      'url': url,
      'port': port,
      'isActive': isActive,
      'settings': settings,
    };

    if (lastSync != null) {
      json['lastSync'] = lastSync!.toIso8601String();
    }

    return json;
  }
}
