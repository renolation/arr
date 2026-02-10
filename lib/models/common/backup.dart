// ========================================
// Backup
// Shared between Sonarr & Radarr
// ========================================

import 'package:equatable/equatable.dart';

class BackupResource extends Equatable {
  final int? id;
  final String? name;
  final String? path;
  final String? type;
  final int? size;
  final DateTime? time;

  const BackupResource({
    this.id,
    this.name,
    this.path,
    this.type,
    this.size,
    this.time,
  });

  @override
  List<Object?> get props => [id, name, path, type, size, time];

  factory BackupResource.fromJson(Map<String, dynamic> json) {
    return BackupResource(
      id: json['id'] as int?,
      name: json['name'] as String?,
      path: json['path'] as String?,
      type: json['type'] as String?,
      size: json['size'] as int?,
      time: json['time'] != null ? DateTime.parse(json['time'] as String) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'path': path,
      'type': type,
      'size': size,
      'time': time?.toIso8601String(),
    };
  }

  BackupResource copyWith({
    int? id,
    String? name,
    String? path,
    String? type,
    int? size,
    DateTime? time,
  }) {
    return BackupResource(
      id: id ?? this.id,
      name: name ?? this.name,
      path: path ?? this.path,
      type: type ?? this.type,
      size: size ?? this.size,
      time: time ?? this.time,
    );
  }
}
