// ========================================
// Command
// Shared between Sonarr & Radarr
// ========================================

import 'package:equatable/equatable.dart';

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
