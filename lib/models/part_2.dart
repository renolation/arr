// ========================================
// Common Models Part 2 - Shared between Sonarr & Radarr
// CustomFormat, DownloadClient, Health, History, ImportList
// ========================================

import 'package:arr/models/part_1.dart';
import 'package:equatable/equatable.dart';

// ========================================
// Custom Format
// ========================================

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

// ========================================
// Download Client
// ========================================

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

// ========================================
// Health
// ========================================

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

// ========================================
// History
// ========================================

class HistoryResource extends Equatable {
  final int? id;
  final int? episodeId;
  final int? seriesId;
  final int? movieId;
  final String? sourceTitle;
  final QualityModel? quality;
  final bool? qualityCutoffNotMet;
  final DateTime? date;
  final String? downloadId;
  final String? eventType;
  final Map<String, dynamic>? data;
  final List<LanguageResource>? languages;

  const HistoryResource({
    this.id,
    this.episodeId,
    this.seriesId,
    this.movieId,
    this.sourceTitle,
    this.quality,
    this.qualityCutoffNotMet,
    this.date,
    this.downloadId,
    this.eventType,
    this.data,
    this.languages,
  });

  @override
  List<Object?> get props => [id, episodeId, seriesId, movieId, sourceTitle, quality, qualityCutoffNotMet, date, downloadId, eventType, data, languages];

  factory HistoryResource.fromJson(Map<String, dynamic> json) {
    return HistoryResource(
      id: json['id'] as int?,
      episodeId: json['episodeId'] as int?,
      seriesId: json['seriesId'] as int?,
      movieId: json['movieId'] as int?,
      sourceTitle: json['sourceTitle'] as String?,
      quality: json['quality'] != null ? QualityModel.fromJson(json['quality'] as Map<String, dynamic>) : null,
      qualityCutoffNotMet: json['qualityCutoffNotMet'] as bool?,
      date: json['date'] != null ? DateTime.parse(json['date'] as String) : null,
      downloadId: json['downloadId'] as String?,
      eventType: json['eventType'] as String?,
      data: json['data'] as Map<String, dynamic>?,
      languages: (json['languages'] as List<dynamic>?)
          ?.map((e) => LanguageResource.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'episodeId': episodeId,
      'seriesId': seriesId,
      'movieId': movieId,
      'sourceTitle': sourceTitle,
      'quality': quality?.toJson(),
      'qualityCutoffNotMet': qualityCutoffNotMet,
      'date': date?.toIso8601String(),
      'downloadId': downloadId,
      'eventType': eventType,
      'data': data,
      'languages': languages?.map((e) => e.toJson()).toList(),
    };
  }

  HistoryResource copyWith({
    int? id,
    int? episodeId,
    int? seriesId,
    int? movieId,
    String? sourceTitle,
    QualityModel? quality,
    bool? qualityCutoffNotMet,
    DateTime? date,
    String? downloadId,
    String? eventType,
    Map<String, dynamic>? data,
    List<LanguageResource>? languages,
  }) {
    return HistoryResource(
      id: id ?? this.id,
      episodeId: episodeId ?? this.episodeId,
      seriesId: seriesId ?? this.seriesId,
      movieId: movieId ?? this.movieId,
      sourceTitle: sourceTitle ?? this.sourceTitle,
      quality: quality ?? this.quality,
      qualityCutoffNotMet: qualityCutoffNotMet ?? this.qualityCutoffNotMet,
      date: date ?? this.date,
      downloadId: downloadId ?? this.downloadId,
      eventType: eventType ?? this.eventType,
      data: data ?? this.data,
      languages: languages ?? this.languages,
    );
  }
}

// ========================================
// Import List
// ========================================

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

// ========================================
// Supporting Classes
// ========================================

class Field extends Equatable {
  final int? order;
  final String? name;
  final String? label;
  final dynamic value;
  final String? type;
  final bool? advanced;
  final bool? required;
  final bool? hidden;
  final String? helpText;
  final String? helpLink;
  final List<SelectOption>? selectOptions;

  const Field({
    this.order,
    this.name,
    this.label,
    this.value,
    this.type,
    this.advanced,
    this.required,
    this.hidden,
    this.helpText,
    this.helpLink,
    this.selectOptions,
  });

  @override
  List<Object?> get props => [order, name, label, value, type, advanced, required, hidden, helpText, helpLink, selectOptions];

  factory Field.fromJson(Map<String, dynamic> json) {
    return Field(
      order: json['order'] as int?,
      name: json['name'] as String?,
      label: json['label'] as String?,
      value: json['value'],
      type: json['type'] as String?,
      advanced: json['advanced'] as bool?,
      required: json['required'] as bool?,
      hidden: json['hidden'] as bool?,
      helpText: json['helpText'] as String?,
      helpLink: json['helpLink'] as String?,
      selectOptions: (json['selectOptions'] as List<dynamic>?)
          ?.map((e) => SelectOption.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'order': order,
      'name': name,
      'label': label,
      'value': value,
      'type': type,
      'advanced': advanced,
      'required': required,
      'hidden': hidden,
      'helpText': helpText,
      'helpLink': helpLink,
      'selectOptions': selectOptions?.map((e) => e.toJson()).toList(),
    };
  }

  Field copyWith({
    int? order,
    String? name,
    String? label,
    dynamic value,
    String? type,
    bool? advanced,
    bool? required,
    bool? hidden,
    String? helpText,
    String? helpLink,
    List<SelectOption>? selectOptions,
  }) {
    return Field(
      order: order ?? this.order,
      name: name ?? this.name,
      label: label ?? this.label,
      value: value ?? this.value,
      type: type ?? this.type,
      advanced: advanced ?? this.advanced,
      required: required ?? this.required,
      hidden: hidden ?? this.hidden,
      helpText: helpText ?? this.helpText,
      helpLink: helpLink ?? this.helpLink,
      selectOptions: selectOptions ?? this.selectOptions,
    );
  }
}

class SelectOption extends Equatable {
  final dynamic value;
  final String? name;
  final int? order;
  final String? hint;

  const SelectOption({
    this.value,
    this.name,
    this.order,
    this.hint,
  });

  @override
  List<Object?> get props => [value, name, order, hint];

  factory SelectOption.fromJson(Map<String, dynamic> json) {
    return SelectOption(
      value: json['value'],
      name: json['name'] as String?,
      order: json['order'] as int?,
      hint: json['hint'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'value': value,
      'name': name,
      'order': order,
      'hint': hint,
    };
  }

  SelectOption copyWith({
    dynamic value,
    String? name,
    int? order,
    String? hint,
  }) {
    return SelectOption(
      value: value ?? this.value,
      name: name ?? this.name,
      order: order ?? this.order,
      hint: hint ?? this.hint,
    );
  }
}

// You'll need to import these from Part 1

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

class QualityRevision extends Equatable {
  final int? version;
  final int? real;
  final bool? isRepack;

  const QualityRevision({
    this.version,
    this.real,
    this.isRepack,
  });

  @override
  List<Object?> get props => [version, real, isRepack];

  factory QualityRevision.fromJson(Map<String, dynamic> json) {
    return QualityRevision(
      version: json['version'] as int?,
      real: json['real'] as int?,
      isRepack: json['isRepack'] as bool?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'version': version,
      'real': real,
      'isRepack': isRepack,
    };
  }

  QualityRevision copyWith({
    int? version,
    int? real,
    bool? isRepack,
  }) {
    return QualityRevision(
      version: version ?? this.version,
      real: real ?? this.real,
      isRepack: isRepack ?? this.isRepack,
    );
  }
}

