// ========================================
// Import List
// Shared between Sonarr & Radarr
// ========================================

import 'package:arr/models/common/field.dart';
import 'package:equatable/equatable.dart';

class ImportListResource extends Equatable {
  final int? id;
  final String? name;
  final List<Field>? fields;
  final String? implementationName;
  final String? implementation;
  final String? configContract;
  final String? infoLink;
  final List<String>? message;
  final List<String>? tags;
  final bool? enabled;
  final bool? enableAuto;
  final String? rootFolderPath;
  final int? qualityProfileId;
  final bool? searchOnAdd;
  final String? minimumAvailability;
  final String? listType;
  final int? listOrder;

  const ImportListResource({
    this.id,
    this.name,
    this.fields,
    this.implementationName,
    this.implementation,
    this.configContract,
    this.infoLink,
    this.message,
    this.tags,
    this.enabled,
    this.enableAuto,
    this.rootFolderPath,
    this.qualityProfileId,
    this.searchOnAdd,
    this.minimumAvailability,
    this.listType,
    this.listOrder,
  });

  @override
  List<Object?> get props => [id, name, fields, implementationName, implementation, configContract, infoLink, message, tags, enabled, enableAuto, rootFolderPath, qualityProfileId, searchOnAdd, minimumAvailability, listType, listOrder];

  factory ImportListResource.fromJson(Map<String, dynamic> json) {
    return ImportListResource(
      id: json['id'] as int?,
      name: json['name'] as String?,
      fields: (json['fields'] as List<dynamic>?)
          ?.map((e) => Field.fromJson(e as Map<String, dynamic>))
          .toList(),
      implementationName: json['implementationName'] as String?,
      implementation: json['implementation'] as String?,
      configContract: json['configContract'] as String?,
      infoLink: json['infoLink'] as String?,
      message: (json['message'] as List<dynamic>?)?.cast<String>(),
      tags: (json['tags'] as List<dynamic>?)?.cast<String>(),
      enabled: json['enabled'] as bool?,
      enableAuto: json['enableAuto'] as bool?,
      rootFolderPath: json['rootFolderPath'] as String?,
      qualityProfileId: json['qualityProfileId'] as int?,
      searchOnAdd: json['searchOnAdd'] as bool?,
      minimumAvailability: json['minimumAvailability'] as String?,
      listType: json['listType'] as String?,
      listOrder: json['listOrder'] as int?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'fields': fields?.map((e) => e.toJson()).toList(),
      'implementationName': implementationName,
      'implementation': implementation,
      'configContract': configContract,
      'infoLink': infoLink,
      'message': message,
      'tags': tags,
      'enabled': enabled,
      'enableAuto': enableAuto,
      'rootFolderPath': rootFolderPath,
      'qualityProfileId': qualityProfileId,
      'searchOnAdd': searchOnAdd,
      'minimumAvailability': minimumAvailability,
      'listType': listType,
      'listOrder': listOrder,
    };
  }

  ImportListResource copyWith({
    int? id,
    String? name,
    List<Field>? fields,
    String? implementationName,
    String? implementation,
    String? configContract,
    String? infoLink,
    List<String>? message,
    List<String>? tags,
    bool? enabled,
    bool? enableAuto,
    String? rootFolderPath,
    int? qualityProfileId,
    bool? searchOnAdd,
    String? minimumAvailability,
    String? listType,
    int? listOrder,
  }) {
    return ImportListResource(
      id: id ?? this.id,
      name: name ?? this.name,
      fields: fields ?? this.fields,
      implementationName: implementationName ?? this.implementationName,
      implementation: implementation ?? this.implementation,
      configContract: configContract ?? this.configContract,
      infoLink: infoLink ?? this.infoLink,
      message: message ?? this.message,
      tags: tags ?? this.tags,
      enabled: enabled ?? this.enabled,
      enableAuto: enableAuto ?? this.enableAuto,
      rootFolderPath: rootFolderPath ?? this.rootFolderPath,
      qualityProfileId: qualityProfileId ?? this.qualityProfileId,
      searchOnAdd: searchOnAdd ?? this.searchOnAdd,
      minimumAvailability: minimumAvailability ?? this.minimumAvailability,
      listType: listType ?? this.listType,
      listOrder: listOrder ?? this.listOrder,
    );
  }
}
