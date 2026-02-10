// ========================================
// Health
// Shared between Sonarr & Radarr
// ========================================

import 'package:equatable/equatable.dart';

class HealthResource extends Equatable {
  final int? id;
  final String? source;
  final String? type;
  final String? message;
  final String? wikiUrl;

  const HealthResource({
    this.id,
    this.source,
    this.type,
    this.message,
    this.wikiUrl,
  });

  @override
  List<Object?> get props => [id, source, type, message, wikiUrl];

  factory HealthResource.fromJson(Map<String, dynamic> json) {
    return HealthResource(
      id: json['id'] as int?,
      source: json['source'] as String?,
      type: json['type'] as String?,
      message: json['message'] as String?,
      wikiUrl: json['wikiUrl'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'source': source,
      'type': type,
      'message': message,
      'wikiUrl': wikiUrl,
    };
  }

  HealthResource copyWith({
    int? id,
    String? source,
    String? type,
    String? message,
    String? wikiUrl,
  }) {
    return HealthResource(
      id: id ?? this.id,
      source: source ?? this.source,
      type: type ?? this.type,
      message: message ?? this.message,
      wikiUrl: wikiUrl ?? this.wikiUrl,
    );
  }
}
