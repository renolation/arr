// ========================================
// Quality
// Shared between Sonarr & Radarr
// ========================================

import 'package:equatable/equatable.dart';

class Quality extends Equatable {
  final int? id;
  final String? name;
  final String? source;
  final int? resolution;

  const Quality({
    this.id,
    this.name,
    this.source,
    this.resolution,
  });

  @override
  List<Object?> get props => [id, name, source, resolution];

  factory Quality.fromJson(Map<String, dynamic> json) {
    return Quality(
      id: json['id'] as int?,
      name: json['name'] as String?,
      source: json['source'] as String?,
      resolution: json['resolution'] as int?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'source': source,
      'resolution': resolution,
    };
  }

  Quality copyWith({
    int? id,
    String? name,
    String? source,
    int? resolution,
  }) {
    return Quality(
      id: id ?? this.id,
      name: name ?? this.name,
      source: source ?? this.source,
      resolution: resolution ?? this.resolution,
    );
  }
}
