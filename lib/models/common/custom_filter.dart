// ========================================
// Custom Filter
// Shared between Sonarr & Radarr
// ========================================

import 'package:equatable/equatable.dart';

class CustomFilterResource extends Equatable {
  final int? id;
  final String? type;
  final String? label;
  final List<Map<String, dynamic>>? filters;

  const CustomFilterResource({
    this.id,
    this.type,
    this.label,
    this.filters,
  });

  @override
  List<Object?> get props => [id, type, label, filters];

  factory CustomFilterResource.fromJson(Map<String, dynamic> json) {
    return CustomFilterResource(
      id: json['id'] as int?,
      type: json['type'] as String?,
      label: json['label'] as String?,
      filters: (json['filters'] as List<dynamic>?)?.cast<Map<String, dynamic>>(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type,
      'label': label,
      'filters': filters,
    };
  }

  CustomFilterResource copyWith({
    int? id,
    String? type,
    String? label,
    List<Map<String, dynamic>>? filters,
  }) {
    return CustomFilterResource(
      id: id ?? this.id,
      type: type ?? this.type,
      label: label ?? this.label,
      filters: filters ?? this.filters,
    );
  }
}
