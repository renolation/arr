// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'system_status.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$SystemStatus {
  String get version => throw _privateConstructorUsedError;
  String get buildTime => throw _privateConstructorUsedError;
  bool get isDebug => throw _privateConstructorUsedError;
  DateTime get startTime => throw _privateConstructorUsedError;
  String get operatingSystem => throw _privateConstructorUsedError;
  String get runtimeVersion => throw _privateConstructorUsedError;
  String? get appData => throw _privateConstructorUsedError;
  String? get instanceName => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $SystemStatusCopyWith<SystemStatus> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SystemStatusCopyWith<$Res> {
  factory $SystemStatusCopyWith(
          SystemStatus value, $Res Function(SystemStatus) then) =
      _$SystemStatusCopyWithImpl<$Res, SystemStatus>;
  @useResult
  $Res call(
      {String version,
      String buildTime,
      bool isDebug,
      DateTime startTime,
      String operatingSystem,
      String runtimeVersion,
      String? appData,
      String? instanceName});
}

/// @nodoc
class _$SystemStatusCopyWithImpl<$Res, $Val extends SystemStatus>
    implements $SystemStatusCopyWith<$Res> {
  _$SystemStatusCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? version = null,
    Object? buildTime = null,
    Object? isDebug = null,
    Object? startTime = null,
    Object? operatingSystem = null,
    Object? runtimeVersion = null,
    Object? appData = freezed,
    Object? instanceName = freezed,
  }) {
    return _then(_value.copyWith(
      version: null == version
          ? _value.version
          : version // ignore: cast_nullable_to_non_nullable
              as String,
      buildTime: null == buildTime
          ? _value.buildTime
          : buildTime // ignore: cast_nullable_to_non_nullable
              as String,
      isDebug: null == isDebug
          ? _value.isDebug
          : isDebug // ignore: cast_nullable_to_non_nullable
              as bool,
      startTime: null == startTime
          ? _value.startTime
          : startTime // ignore: cast_nullable_to_non_nullable
              as DateTime,
      operatingSystem: null == operatingSystem
          ? _value.operatingSystem
          : operatingSystem // ignore: cast_nullable_to_non_nullable
              as String,
      runtimeVersion: null == runtimeVersion
          ? _value.runtimeVersion
          : runtimeVersion // ignore: cast_nullable_to_non_nullable
              as String,
      appData: freezed == appData
          ? _value.appData
          : appData // ignore: cast_nullable_to_non_nullable
              as String?,
      instanceName: freezed == instanceName
          ? _value.instanceName
          : instanceName // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$SystemStatusImplCopyWith<$Res>
    implements $SystemStatusCopyWith<$Res> {
  factory _$$SystemStatusImplCopyWith(
          _$SystemStatusImpl value, $Res Function(_$SystemStatusImpl) then) =
      __$$SystemStatusImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String version,
      String buildTime,
      bool isDebug,
      DateTime startTime,
      String operatingSystem,
      String runtimeVersion,
      String? appData,
      String? instanceName});
}

/// @nodoc
class __$$SystemStatusImplCopyWithImpl<$Res>
    extends _$SystemStatusCopyWithImpl<$Res, _$SystemStatusImpl>
    implements _$$SystemStatusImplCopyWith<$Res> {
  __$$SystemStatusImplCopyWithImpl(
      _$SystemStatusImpl _value, $Res Function(_$SystemStatusImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? version = null,
    Object? buildTime = null,
    Object? isDebug = null,
    Object? startTime = null,
    Object? operatingSystem = null,
    Object? runtimeVersion = null,
    Object? appData = freezed,
    Object? instanceName = freezed,
  }) {
    return _then(_$SystemStatusImpl(
      version: null == version
          ? _value.version
          : version // ignore: cast_nullable_to_non_nullable
              as String,
      buildTime: null == buildTime
          ? _value.buildTime
          : buildTime // ignore: cast_nullable_to_non_nullable
              as String,
      isDebug: null == isDebug
          ? _value.isDebug
          : isDebug // ignore: cast_nullable_to_non_nullable
              as bool,
      startTime: null == startTime
          ? _value.startTime
          : startTime // ignore: cast_nullable_to_non_nullable
              as DateTime,
      operatingSystem: null == operatingSystem
          ? _value.operatingSystem
          : operatingSystem // ignore: cast_nullable_to_non_nullable
              as String,
      runtimeVersion: null == runtimeVersion
          ? _value.runtimeVersion
          : runtimeVersion // ignore: cast_nullable_to_non_nullable
              as String,
      appData: freezed == appData
          ? _value.appData
          : appData // ignore: cast_nullable_to_non_nullable
              as String?,
      instanceName: freezed == instanceName
          ? _value.instanceName
          : instanceName // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc

class _$SystemStatusImpl extends _SystemStatus {
  const _$SystemStatusImpl(
      {required this.version,
      required this.buildTime,
      required this.isDebug,
      required this.startTime,
      required this.operatingSystem,
      required this.runtimeVersion,
      this.appData,
      this.instanceName})
      : super._();

  @override
  final String version;
  @override
  final String buildTime;
  @override
  final bool isDebug;
  @override
  final DateTime startTime;
  @override
  final String operatingSystem;
  @override
  final String runtimeVersion;
  @override
  final String? appData;
  @override
  final String? instanceName;

  @override
  String toString() {
    return 'SystemStatus(version: $version, buildTime: $buildTime, isDebug: $isDebug, startTime: $startTime, operatingSystem: $operatingSystem, runtimeVersion: $runtimeVersion, appData: $appData, instanceName: $instanceName)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SystemStatusImpl &&
            (identical(other.version, version) || other.version == version) &&
            (identical(other.buildTime, buildTime) ||
                other.buildTime == buildTime) &&
            (identical(other.isDebug, isDebug) || other.isDebug == isDebug) &&
            (identical(other.startTime, startTime) ||
                other.startTime == startTime) &&
            (identical(other.operatingSystem, operatingSystem) ||
                other.operatingSystem == operatingSystem) &&
            (identical(other.runtimeVersion, runtimeVersion) ||
                other.runtimeVersion == runtimeVersion) &&
            (identical(other.appData, appData) || other.appData == appData) &&
            (identical(other.instanceName, instanceName) ||
                other.instanceName == instanceName));
  }

  @override
  int get hashCode => Object.hash(runtimeType, version, buildTime, isDebug,
      startTime, operatingSystem, runtimeVersion, appData, instanceName);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$SystemStatusImplCopyWith<_$SystemStatusImpl> get copyWith =>
      __$$SystemStatusImplCopyWithImpl<_$SystemStatusImpl>(this, _$identity);
}

abstract class _SystemStatus extends SystemStatus {
  const factory _SystemStatus(
      {required final String version,
      required final String buildTime,
      required final bool isDebug,
      required final DateTime startTime,
      required final String operatingSystem,
      required final String runtimeVersion,
      final String? appData,
      final String? instanceName}) = _$SystemStatusImpl;
  const _SystemStatus._() : super._();

  @override
  String get version;
  @override
  String get buildTime;
  @override
  bool get isDebug;
  @override
  DateTime get startTime;
  @override
  String get operatingSystem;
  @override
  String get runtimeVersion;
  @override
  String? get appData;
  @override
  String? get instanceName;
  @override
  @JsonKey(ignore: true)
  _$$SystemStatusImplCopyWith<_$SystemStatusImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
