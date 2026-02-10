// ========================================
// Download Client
// Shared between Sonarr & Radarr
// ========================================

import 'package:arr/models/common/field.dart';
import 'package:equatable/equatable.dart';

class DownloadClientResource extends Equatable {
  final int? id;
  final String? name;
  final List<Field>? fields;
  final String? implementationName;
  final String? implementation;
  final String? configContract;
  final String? infoLink;
  final List<String>? message;
  final List<String>? tags;
  final bool? enable;
  final String? protocol;
  final int? priority;
  final bool? removeCompletedDownloads;
  final bool? removeFailedDownloads;

  const DownloadClientResource({
    this.id,
    this.name,
    this.fields,
    this.implementationName,
    this.implementation,
    this.configContract,
    this.infoLink,
    this.message,
    this.tags,
    this.enable,
    this.protocol,
    this.priority,
    this.removeCompletedDownloads,
    this.removeFailedDownloads,
  });

  @override
  List<Object?> get props => [id, name, fields, implementationName, implementation, configContract, infoLink, message, tags, enable, protocol, priority, removeCompletedDownloads, removeFailedDownloads];

  factory DownloadClientResource.fromJson(Map<String, dynamic> json) {
    return DownloadClientResource(
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
      enable: json['enable'] as bool?,
      protocol: json['protocol'] as String?,
      priority: json['priority'] as int?,
      removeCompletedDownloads: json['removeCompletedDownloads'] as bool?,
      removeFailedDownloads: json['removeFailedDownloads'] as bool?,
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
      'enable': enable,
      'protocol': protocol,
      'priority': priority,
      'removeCompletedDownloads': removeCompletedDownloads,
      'removeFailedDownloads': removeFailedDownloads,
    };
  }

  DownloadClientResource copyWith({
    int? id,
    String? name,
    List<Field>? fields,
    String? implementationName,
    String? implementation,
    String? configContract,
    String? infoLink,
    List<String>? message,
    List<String>? tags,
    bool? enable,
    String? protocol,
    int? priority,
    bool? removeCompletedDownloads,
    bool? removeFailedDownloads,
  }) {
    return DownloadClientResource(
      id: id ?? this.id,
      name: name ?? this.name,
      fields: fields ?? this.fields,
      implementationName: implementationName ?? this.implementationName,
      implementation: implementation ?? this.implementation,
      configContract: configContract ?? this.configContract,
      infoLink: infoLink ?? this.infoLink,
      message: message ?? this.message,
      tags: tags ?? this.tags,
      enable: enable ?? this.enable,
      protocol: protocol ?? this.protocol,
      priority: priority ?? this.priority,
      removeCompletedDownloads: removeCompletedDownloads ?? this.removeCompletedDownloads,
      removeFailedDownloads: removeFailedDownloads ?? this.removeFailedDownloads,
    );
  }
}
