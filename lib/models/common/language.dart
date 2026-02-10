// ========================================
// Language
// Shared between Sonarr & Radarr
// ========================================

import 'package:equatable/equatable.dart';

class LanguageResource extends Equatable {
  final int? id;
  final String? name;
  final String? nameLower;

  const LanguageResource({
    this.id,
    this.name,
    this.nameLower,
  });

  @override
  List<Object?> get props => [id, name, nameLower];

  factory LanguageResource.fromJson(Map<String, dynamic> json) {
    return LanguageResource(
      id: json['id'] as int?,
      name: json['name'] as String?,
      nameLower: json['nameLower'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'nameLower': nameLower,
    };
  }

  LanguageResource copyWith({
    int? id,
    String? name,
    String? nameLower,
  }) {
    return LanguageResource(
      id: id ?? this.id,
      name: name ?? this.name,
      nameLower: nameLower ?? this.nameLower,
    );
  }
}
