// ========================================
// Auto Tagging
// Shared between Sonarr & Radarr
// ========================================

import 'package:equatable/equatable.dart';

class AutoTaggingResource extends Equatable {
  final int? id;
  final String? name;
  final bool? removeTagsAutomatically;
  final List<String>? tags;
  final List<AutoTaggingSpecification>? specifications;

  const AutoTaggingResource({
    this.id,
    this.name,
    this.removeTagsAutomatically,
    this.tags,
    this.specifications,
  });

  @override
  List<Object?> get props => [id, name, removeTagsAutomatically, tags, specifications];

  factory AutoTaggingResource.fromJson(Map<String, dynamic> json) {
    return AutoTaggingResource(
      id: json['id'] as int?,
      name: json['name'] as String?,
      removeTagsAutomatically: json['removeTagsAutomatically'] as bool?,
      tags: (json['tags'] as List<dynamic>?)?.cast<String>(),
      specifications: (json['specifications'] as List<dynamic>?)
          ?.map((e) => AutoTaggingSpecification.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'removeTagsAutomatically': removeTagsAutomatically,
      'tags': tags,
      'specifications': specifications?.map((e) => e.toJson()).toList(),
    };
  }

  AutoTaggingResource copyWith({
    int? id,
    String? name,
    bool? removeTagsAutomatically,
    List<String>? tags,
    List<AutoTaggingSpecification>? specifications,
  }) {
    return AutoTaggingResource(
      id: id ?? this.id,
      name: name ?? this.name,
      removeTagsAutomatically: removeTagsAutomatically ?? this.removeTagsAutomatically,
      tags: tags ?? this.tags,
      specifications: specifications ?? this.specifications,
    );
  }
}

class AutoTaggingSpecification extends Equatable {
  final String? name;
  final String? implementation;
  final String? implementationName;
  final String? negate;
  final bool? required;
  final Map<String, dynamic>? fields;

  const AutoTaggingSpecification({
    this.name,
    this.implementation,
    this.implementationName,
    this.negate,
    this.required,
    this.fields,
  });

  @override
  List<Object?> get props => [name, implementation, implementationName, negate, required, fields];

  factory AutoTaggingSpecification.fromJson(Map<String, dynamic> json) {
    return AutoTaggingSpecification(
      name: json['name'] as String?,
      implementation: json['implementation'] as String?,
      implementationName: json['implementationName'] as String?,
      negate: json['negate'] as String?,
      required: json['required'] as bool?,
      fields: json['fields'] as Map<String, dynamic>?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'implementation': implementation,
      'implementationName': implementationName,
      'negate': negate,
      'required': required,
      'fields': fields,
    };
  }

  AutoTaggingSpecification copyWith({
    String? name,
    String? implementation,
    String? implementationName,
    String? negate,
    bool? required,
    Map<String, dynamic>? fields,
  }) {
    return AutoTaggingSpecification(
      name: name ?? this.name,
      implementation: implementation ?? this.implementation,
      implementationName: implementationName ?? this.implementationName,
      negate: negate ?? this.negate,
      required: required ?? this.required,
      fields: fields ?? this.fields,
    );
  }
}
