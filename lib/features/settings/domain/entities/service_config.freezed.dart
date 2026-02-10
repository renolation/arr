// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'service_config.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$ServiceConfig {
  String get key => throw _privateConstructorUsedError;
  ServiceType get type => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String get url => throw _privateConstructorUsedError;
  String? get apiKey =>
      throw _privateConstructorUsedError; // This should not be stored in toJson
  int? get port => throw _privateConstructorUsedError;
  bool? get isActive => throw _privateConstructorUsedError;
  DateTime? get lastSync => throw _privateConstructorUsedError;
  Map<String, dynamic>? get settings => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $ServiceConfigCopyWith<ServiceConfig> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ServiceConfigCopyWith<$Res> {
  factory $ServiceConfigCopyWith(
          ServiceConfig value, $Res Function(ServiceConfig) then) =
      _$ServiceConfigCopyWithImpl<$Res, ServiceConfig>;
  @useResult
  $Res call(
      {String key,
      ServiceType type,
      String name,
      String url,
      String? apiKey,
      int? port,
      bool? isActive,
      DateTime? lastSync,
      Map<String, dynamic>? settings});
}

/// @nodoc
class _$ServiceConfigCopyWithImpl<$Res, $Val extends ServiceConfig>
    implements $ServiceConfigCopyWith<$Res> {
  _$ServiceConfigCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? key = null,
    Object? type = null,
    Object? name = null,
    Object? url = null,
    Object? apiKey = freezed,
    Object? port = freezed,
    Object? isActive = freezed,
    Object? lastSync = freezed,
    Object? settings = freezed,
  }) {
    return _then(_value.copyWith(
      key: null == key
          ? _value.key
          : key // ignore: cast_nullable_to_non_nullable
              as String,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as ServiceType,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      url: null == url
          ? _value.url
          : url // ignore: cast_nullable_to_non_nullable
              as String,
      apiKey: freezed == apiKey
          ? _value.apiKey
          : apiKey // ignore: cast_nullable_to_non_nullable
              as String?,
      port: freezed == port
          ? _value.port
          : port // ignore: cast_nullable_to_non_nullable
              as int?,
      isActive: freezed == isActive
          ? _value.isActive
          : isActive // ignore: cast_nullable_to_non_nullable
              as bool?,
      lastSync: freezed == lastSync
          ? _value.lastSync
          : lastSync // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      settings: freezed == settings
          ? _value.settings
          : settings // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ServiceConfigImplCopyWith<$Res>
    implements $ServiceConfigCopyWith<$Res> {
  factory _$$ServiceConfigImplCopyWith(
          _$ServiceConfigImpl value, $Res Function(_$ServiceConfigImpl) then) =
      __$$ServiceConfigImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String key,
      ServiceType type,
      String name,
      String url,
      String? apiKey,
      int? port,
      bool? isActive,
      DateTime? lastSync,
      Map<String, dynamic>? settings});
}

/// @nodoc
class __$$ServiceConfigImplCopyWithImpl<$Res>
    extends _$ServiceConfigCopyWithImpl<$Res, _$ServiceConfigImpl>
    implements _$$ServiceConfigImplCopyWith<$Res> {
  __$$ServiceConfigImplCopyWithImpl(
      _$ServiceConfigImpl _value, $Res Function(_$ServiceConfigImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? key = null,
    Object? type = null,
    Object? name = null,
    Object? url = null,
    Object? apiKey = freezed,
    Object? port = freezed,
    Object? isActive = freezed,
    Object? lastSync = freezed,
    Object? settings = freezed,
  }) {
    return _then(_$ServiceConfigImpl(
      key: null == key
          ? _value.key
          : key // ignore: cast_nullable_to_non_nullable
              as String,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as ServiceType,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      url: null == url
          ? _value.url
          : url // ignore: cast_nullable_to_non_nullable
              as String,
      apiKey: freezed == apiKey
          ? _value.apiKey
          : apiKey // ignore: cast_nullable_to_non_nullable
              as String?,
      port: freezed == port
          ? _value.port
          : port // ignore: cast_nullable_to_non_nullable
              as int?,
      isActive: freezed == isActive
          ? _value.isActive
          : isActive // ignore: cast_nullable_to_non_nullable
              as bool?,
      lastSync: freezed == lastSync
          ? _value.lastSync
          : lastSync // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      settings: freezed == settings
          ? _value._settings
          : settings // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
    ));
  }
}

/// @nodoc

class _$ServiceConfigImpl extends _ServiceConfig {
  const _$ServiceConfigImpl(
      {required this.key,
      required this.type,
      required this.name,
      required this.url,
      this.apiKey,
      this.port,
      this.isActive,
      this.lastSync,
      final Map<String, dynamic>? settings})
      : _settings = settings,
        super._();

  @override
  final String key;
  @override
  final ServiceType type;
  @override
  final String name;
  @override
  final String url;
  @override
  final String? apiKey;
// This should not be stored in toJson
  @override
  final int? port;
  @override
  final bool? isActive;
  @override
  final DateTime? lastSync;
  final Map<String, dynamic>? _settings;
  @override
  Map<String, dynamic>? get settings {
    final value = _settings;
    if (value == null) return null;
    if (_settings is EqualUnmodifiableMapView) return _settings;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  @override
  String toString() {
    return 'ServiceConfig(key: $key, type: $type, name: $name, url: $url, apiKey: $apiKey, port: $port, isActive: $isActive, lastSync: $lastSync, settings: $settings)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ServiceConfigImpl &&
            (identical(other.key, key) || other.key == key) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.url, url) || other.url == url) &&
            (identical(other.apiKey, apiKey) || other.apiKey == apiKey) &&
            (identical(other.port, port) || other.port == port) &&
            (identical(other.isActive, isActive) ||
                other.isActive == isActive) &&
            (identical(other.lastSync, lastSync) ||
                other.lastSync == lastSync) &&
            const DeepCollectionEquality().equals(other._settings, _settings));
  }

  @override
  int get hashCode => Object.hash(runtimeType, key, type, name, url, apiKey,
      port, isActive, lastSync, const DeepCollectionEquality().hash(_settings));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ServiceConfigImplCopyWith<_$ServiceConfigImpl> get copyWith =>
      __$$ServiceConfigImplCopyWithImpl<_$ServiceConfigImpl>(this, _$identity);
}

abstract class _ServiceConfig extends ServiceConfig {
  const factory _ServiceConfig(
      {required final String key,
      required final ServiceType type,
      required final String name,
      required final String url,
      final String? apiKey,
      final int? port,
      final bool? isActive,
      final DateTime? lastSync,
      final Map<String, dynamic>? settings}) = _$ServiceConfigImpl;
  const _ServiceConfig._() : super._();

  @override
  String get key;
  @override
  ServiceType get type;
  @override
  String get name;
  @override
  String get url;
  @override
  String? get apiKey;
  @override // This should not be stored in toJson
  int? get port;
  @override
  bool? get isActive;
  @override
  DateTime? get lastSync;
  @override
  Map<String, dynamic>? get settings;
  @override
  @JsonKey(ignore: true)
  _$$ServiceConfigImplCopyWith<_$ServiceConfigImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
