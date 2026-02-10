// ========================================
// Custom Format
// Shared between Sonarr & Radarr
// ========================================

import 'package:equatable/equatable.dart';

class CustomFormatResource extends Equatable {
  final int? id;
  final String? name;
  final bool? includeCustomFormatWhenRenaming;
  final List<CustomFormatSpecification>? specifications;

  const CustomFormatResource({
    this.id,
    this.name,
    this.includeCustomFormatWhenRenaming,
    this.specifications,
  });

  @override
  List<Object?> get props => [id, name, includeCustomFormatWhenRenaming, specifications];

  factory CustomFormatResource.fromJson(Map<String, dynamic> json) {
    return CustomFormatResource(
      id: json['id'] as int?,
      name: json['name'] as String?,
      includeCustomFormatWhenRenaming: json['includeCustomFormatWhenRenaming'] as bool?,
      specifications: (json['specifications'] as List<dynamic>?)
          ?.map((e) => CustomFormatSpecification.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'includeCustomFormatWhenRenaming': includeCustomFormatWhenRenaming,
      'specifications': specifications?.map((e) => e.toJson()).toList(),
    };
  }

  CustomFormatResource copyWith({
    int? id,
    String? name,
    bool? includeCustomFormatWhenRenaming,
    List<CustomFormatSpecification>? specifications,
  }) {
    return CustomFormatResource(
      id: id ?? this.id,
      name: name ?? this.name,
      includeCustomFormatWhenRenaming: includeCustomFormatWhenRenaming ?? this.includeCustomFormatWhenRenaming,
      specifications: specifications ?? this.specifications,
    );
  }
}

class CustomFormatSpecification extends Equatable {
  final String? name;
  final String? implementation;
  final String? implementationName;
  final String? infoLink;
  final bool? negate;
  final bool? required;
  final Map<String, dynamic>? fields;

  const CustomFormatSpecification({
    this.name,
    this.implementation,
    this.implementationName,
    this.infoLink,
    this.negate,
    this.required,
    this.fields,
  });

  @override
  List<Object?> get props => [name, implementation, implementationName, infoLink, negate, required, fields];

  factory CustomFormatSpecification.fromJson(Map<String, dynamic> json) {
    return CustomFormatSpecification(
      name: json['name'] as String?,
      implementation: json['implementation'] as String?,
      implementationName: json['implementationName'] as String?,
      infoLink: json['infoLink'] as String?,
      negate: json['negate'] as bool?,
      required: json['required'] as bool?,
      fields: json['fields'] as Map<String, dynamic>?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'implementation': implementation,
      'implementationName': implementationName,
      'infoLink': infoLink,
      'negate': negate,
      'required': required,
      'fields': fields,
    };
  }

  CustomFormatSpecification copyWith({
    String? name,
    String? implementation,
    String? implementationName,
    String? infoLink,
    bool? negate,
    bool? required,
    Map<String, dynamic>? fields,
  }) {
    return CustomFormatSpecification(
      name: name ?? this.name,
      implementation: implementation ?? this.implementation,
      implementationName: implementationName ?? this.implementationName,
      infoLink: infoLink ?? this.infoLink,
      negate: negate ?? this.negate,
      required: required ?? this.required,
      fields: fields ?? this.fields,
    );
  }
}
