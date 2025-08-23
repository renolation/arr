// ========================================
// Common Models Part 1 - Shared between Sonarr & Radarr
// AutoTagging, Backup, Blocklist, Command, CustomFilter
// ========================================

import 'package:equatable/equatable.dart';

// ========================================
// Auto Tagging
// ========================================

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

// ========================================
// Backup
// ========================================

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

// ========================================
// Blocklist
// ========================================

class BlocklistResource extends Equatable {
  final int? id;
  final int? seriesId;
  final int? movieId;
  final List<int>? episodeIds;
  final String? sourceTitle;
  final QualityModel? quality;
  final DateTime? date;
  final String? protocol;
  final String? indexer;
  final String? message;
  final List<LanguageResource>? languages;

  const BlocklistResource({
    this.id,
    this.seriesId,
    this.movieId,
    this.episodeIds,
    this.sourceTitle,
    this.quality,
    this.date,
    this.protocol,
    this.indexer,
    this.message,
    this.languages,
  });

  @override
  List<Object?> get props => [id, seriesId, movieId, episodeIds, sourceTitle, quality, date, protocol, indexer, message, languages];

  factory BlocklistResource.fromJson(Map<String, dynamic> json) {
    return BlocklistResource(
      id: json['id'] as int?,
      seriesId: json['seriesId'] as int?,
      movieId: json['movieId'] as int?,
      episodeIds: (json['episodeIds'] as List<dynamic>?)?.cast<int>(),
      sourceTitle: json['sourceTitle'] as String?,
      quality: json['quality'] != null ? QualityModel.fromJson(json['quality'] as Map<String, dynamic>) : null,
      date: json['date'] != null ? DateTime.parse(json['date'] as String) : null,
      protocol: json['protocol'] as String?,
      indexer: json['indexer'] as String?,
      message: json['message'] as String?,
      languages: (json['languages'] as List<dynamic>?)
          ?.map((e) => LanguageResource.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'seriesId': seriesId,
      'movieId': movieId,
      'episodeIds': episodeIds,
      'sourceTitle': sourceTitle,
      'quality': quality?.toJson(),
      'date': date?.toIso8601String(),
      'protocol': protocol,
      'indexer': indexer,
      'message': message,
      'languages': languages?.map((e) => e.toJson()).toList(),
    };
  }

  BlocklistResource copyWith({
    int? id,
    int? seriesId,
    int? movieId,
    List<int>? episodeIds,
    String? sourceTitle,
    QualityModel? quality,
    DateTime? date,
    String? protocol,
    String? indexer,
    String? message,
    List<LanguageResource>? languages,
  }) {
    return BlocklistResource(
      id: id ?? this.id,
      seriesId: seriesId ?? this.seriesId,
      movieId: movieId ?? this.movieId,
      episodeIds: episodeIds ?? this.episodeIds,
      sourceTitle: sourceTitle ?? this.sourceTitle,
      quality: quality ?? this.quality,
      date: date ?? this.date,
      protocol: protocol ?? this.protocol,
      indexer: indexer ?? this.indexer,
      message: message ?? this.message,
      languages: languages ?? this.languages,
    );
  }
}

// ========================================
// Command
// ========================================

class CommandResource extends Equatable {
  final int? id;
  final String? name;
  final String? commandName;
  final String? message;
  final Map<String, dynamic>? body;
  final int? priority;
  final String? status;
  final String? result;
  final DateTime? queued;
  final DateTime? started;
  final DateTime? ended;
  final String? duration;
  final String? exception;
  final String? trigger;

  const CommandResource({
    this.id,
    this.name,
    this.commandName,
    this.message,
    this.body,
    this.priority,
    this.status,
    this.result,
    this.queued,
    this.started,
    this.ended,
    this.duration,
    this.exception,
    this.trigger,
  });

  @override
  List<Object?> get props => [id, name, commandName, message, body, priority, status, result, queued, started, ended, duration, exception, trigger];

  factory CommandResource.fromJson(Map<String, dynamic> json) {
    return CommandResource(
      id: json['id'] as int?,
      name: json['name'] as String?,
      commandName: json['commandName'] as String?,
      message: json['message'] as String?,
      body: json['body'] as Map<String, dynamic>?,
      priority: json['priority'] as int?,
      status: json['status'] as String?,
      result: json['result'] as String?,
      queued: json['queued'] != null ? DateTime.parse(json['queued'] as String) : null,
      started: json['started'] != null ? DateTime.parse(json['started'] as String) : null,
      ended: json['ended'] != null ? DateTime.parse(json['ended'] as String) : null,
      duration: json['duration'] as String?,
      exception: json['exception'] as String?,
      trigger: json['trigger'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'commandName': commandName,
      'message': message,
      'body': body,
      'priority': priority,
      'status': status,
      'result': result,
      'queued': queued?.toIso8601String(),
      'started': started?.toIso8601String(),
      'ended': ended?.toIso8601String(),
      'duration': duration,
      'exception': exception,
      'trigger': trigger,
    };
  }

  CommandResource copyWith({
    int? id,
    String? name,
    String? commandName,
    String? message,
    Map<String, dynamic>? body,
    int? priority,
    String? status,
    String? result,
    DateTime? queued,
    DateTime? started,
    DateTime? ended,
    String? duration,
    String? exception,
    String? trigger,
  }) {
    return CommandResource(
      id: id ?? this.id,
      name: name ?? this.name,
      commandName: commandName ?? this.commandName,
      message: message ?? this.message,
      body: body ?? this.body,
      priority: priority ?? this.priority,
      status: status ?? this.status,
      result: result ?? this.result,
      queued: queued ?? this.queued,
      started: started ?? this.started,
      ended: ended ?? this.ended,
      duration: duration ?? this.duration,
      exception: exception ?? this.exception,
      trigger: trigger ?? this.trigger,
    );
  }
}

// ========================================
// Custom Filter
// ========================================

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

// ========================================
// Supporting Classes for these models
// ========================================

class QualityModel extends Equatable {
  final Quality? quality;
  final QualityRevision? revision;

  const QualityModel({
    this.quality,
    this.revision,
  });

  @override
  List<Object?> get props => [quality, revision];

  factory QualityModel.fromJson(Map<String, dynamic> json) {
    return QualityModel(
      quality: json['quality'] != null ? Quality.fromJson(json['quality'] as Map<String, dynamic>) : null,
      revision: json['revision'] != null ? QualityRevision.fromJson(json['revision'] as Map<String, dynamic>) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'quality': quality?.toJson(),
      'revision': revision?.toJson(),
    };
  }

  QualityModel copyWith({
    Quality? quality,
    QualityRevision? revision,
  }) {
    return QualityModel(
      quality: quality ?? this.quality,
      revision: revision ?? this.revision,
    );
  }
}

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