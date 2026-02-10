// ========================================
// Field
// Shared between Sonarr & Radarr
// ========================================

import 'package:equatable/equatable.dart';

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
