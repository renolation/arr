// ========================================
// Language Profile
// Sonarr-specific (Deprecated)
// ========================================

import 'package:arr/models/common/language.dart';
import 'package:equatable/equatable.dart';

class LanguageProfileResource extends Equatable {
  final int? id;
  final String? name;
  final bool? upgradeAllowed;
  final int? cutoff;
  final List<LanguageProfileItem>? languages;

  const LanguageProfileResource({
    this.id,
    this.name,
    this.upgradeAllowed,
    this.cutoff,
    this.languages,
  });

  @override
  List<Object?> get props => [id, name, upgradeAllowed, cutoff, languages];

  factory LanguageProfileResource.fromJson(Map<String, dynamic> json) {
    return LanguageProfileResource(
      id: json['id'] as int?,
      name: json['name'] as String?,
      upgradeAllowed: json['upgradeAllowed'] as bool?,
      cutoff: json['cutoff'] as int?,
      languages: (json['languages'] as List<dynamic>?)
          ?.map((e) => LanguageProfileItem.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'upgradeAllowed': upgradeAllowed,
      'cutoff': cutoff,
      'languages': languages?.map((e) => e.toJson()).toList(),
    };
  }

  LanguageProfileResource copyWith({
    int? id,
    String? name,
    bool? upgradeAllowed,
    int? cutoff,
    List<LanguageProfileItem>? languages,
  }) {
    return LanguageProfileResource(
      id: id ?? this.id,
      name: name ?? this.name,
      upgradeAllowed: upgradeAllowed ?? this.upgradeAllowed,
      cutoff: cutoff ?? this.cutoff,
      languages: languages ?? this.languages,
    );
  }
}

class LanguageProfileItem extends Equatable {
  final LanguageResource? language;
  final bool? allowed;

  const LanguageProfileItem({
    this.language,
    this.allowed,
  });

  @override
  List<Object?> get props => [language, allowed];

  factory LanguageProfileItem.fromJson(Map<String, dynamic> json) {
    return LanguageProfileItem(
      language: json['language'] != null ? LanguageResource.fromJson(json['language'] as Map<String, dynamic>) : null,
      allowed: json['allowed'] as bool?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'language': language?.toJson(),
      'allowed': allowed,
    };
  }

  LanguageProfileItem copyWith({
    LanguageResource? language,
    bool? allowed,
  }) {
    return LanguageProfileItem(
      language: language ?? this.language,
      allowed: allowed ?? this.allowed,
    );
  }
}
