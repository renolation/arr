// ========================================
// Naming Config
// Sonarr-specific
// ========================================

import 'package:equatable/equatable.dart';

class NamingConfigResource extends Equatable {
  final int? id;
  final bool? renameEpisodes;
  final bool? replaceIllegalCharacters;
  final String? standardEpisodeFormat;
  final String? dailyEpisodeFormat;
  final String? animeEpisodeFormat;
  final String? seriesFolderFormat;
  final String? seasonFolderFormat;
  final String? specialsFolderFormat;
  final int? multiEpisodeStyle;
  final int? colonReplacementFormat;
  final String? customColonReplacementFormat;

  const NamingConfigResource({
    this.id,
    this.renameEpisodes,
    this.replaceIllegalCharacters,
    this.standardEpisodeFormat,
    this.dailyEpisodeFormat,
    this.animeEpisodeFormat,
    this.seriesFolderFormat,
    this.seasonFolderFormat,
    this.specialsFolderFormat,
    this.multiEpisodeStyle,
    this.colonReplacementFormat,
    this.customColonReplacementFormat,
  });

  @override
  List<Object?> get props => [id, renameEpisodes, replaceIllegalCharacters, standardEpisodeFormat, dailyEpisodeFormat, animeEpisodeFormat, seriesFolderFormat, seasonFolderFormat, specialsFolderFormat, multiEpisodeStyle, colonReplacementFormat, customColonReplacementFormat];

  factory NamingConfigResource.fromJson(Map<String, dynamic> json) {
    return NamingConfigResource(
      id: json['id'] as int?,
      renameEpisodes: json['renameEpisodes'] as bool?,
      replaceIllegalCharacters: json['replaceIllegalCharacters'] as bool?,
      standardEpisodeFormat: json['standardEpisodeFormat'] as String?,
      dailyEpisodeFormat: json['dailyEpisodeFormat'] as String?,
      animeEpisodeFormat: json['animeEpisodeFormat'] as String?,
      seriesFolderFormat: json['seriesFolderFormat'] as String?,
      seasonFolderFormat: json['seasonFolderFormat'] as String?,
      specialsFolderFormat: json['specialsFolderFormat'] as String?,
      multiEpisodeStyle: json['multiEpisodeStyle'] as int?,
      colonReplacementFormat: json['colonReplacementFormat'] as int?,
      customColonReplacementFormat: json['customColonReplacementFormat'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'renameEpisodes': renameEpisodes,
      'replaceIllegalCharacters': replaceIllegalCharacters,
      'standardEpisodeFormat': standardEpisodeFormat,
      'dailyEpisodeFormat': dailyEpisodeFormat,
      'animeEpisodeFormat': animeEpisodeFormat,
      'seriesFolderFormat': seriesFolderFormat,
      'seasonFolderFormat': seasonFolderFormat,
      'specialsFolderFormat': specialsFolderFormat,
      'multiEpisodeStyle': multiEpisodeStyle,
      'colonReplacementFormat': colonReplacementFormat,
      'customColonReplacementFormat': customColonReplacementFormat,
    };
  }

  NamingConfigResource copyWith({
    int? id,
    bool? renameEpisodes,
    bool? replaceIllegalCharacters,
    String? standardEpisodeFormat,
    String? dailyEpisodeFormat,
    String? animeEpisodeFormat,
    String? seriesFolderFormat,
    String? seasonFolderFormat,
    String? specialsFolderFormat,
    int? multiEpisodeStyle,
    int? colonReplacementFormat,
    String? customColonReplacementFormat,
  }) {
    return NamingConfigResource(
      id: id ?? this.id,
      renameEpisodes: renameEpisodes ?? this.renameEpisodes,
      replaceIllegalCharacters: replaceIllegalCharacters ?? this.replaceIllegalCharacters,
      standardEpisodeFormat: standardEpisodeFormat ?? this.standardEpisodeFormat,
      dailyEpisodeFormat: dailyEpisodeFormat ?? this.dailyEpisodeFormat,
      animeEpisodeFormat: animeEpisodeFormat ?? this.animeEpisodeFormat,
      seriesFolderFormat: seriesFolderFormat ?? this.seriesFolderFormat,
      seasonFolderFormat: seasonFolderFormat ?? this.seasonFolderFormat,
      specialsFolderFormat: specialsFolderFormat ?? this.specialsFolderFormat,
      multiEpisodeStyle: multiEpisodeStyle ?? this.multiEpisodeStyle,
      colonReplacementFormat: colonReplacementFormat ?? this.colonReplacementFormat,
      customColonReplacementFormat: customColonReplacementFormat ?? this.customColonReplacementFormat,
    );
  }
}
