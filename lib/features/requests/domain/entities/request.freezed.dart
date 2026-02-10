// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'request.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$Request {
  int get id => throw _privateConstructorUsedError;
  String get mediaTitle => throw _privateConstructorUsedError;
  String get mediaType => throw _privateConstructorUsedError; // 'movie' or 'tv'
  RequestStatus get status => throw _privateConstructorUsedError;
  String? get posterUrl => throw _privateConstructorUsedError;
  String? get overview => throw _privateConstructorUsedError;
  int? get requestUserId => throw _privateConstructorUsedError;
  String? get requestUserName => throw _privateConstructorUsedError;
  DateTime? get createdAt => throw _privateConstructorUsedError;
  DateTime? get modifiedAt => throw _privateConstructorUsedError;
  Map<String, dynamic>? get mediaData => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $RequestCopyWith<Request> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $RequestCopyWith<$Res> {
  factory $RequestCopyWith(Request value, $Res Function(Request) then) =
      _$RequestCopyWithImpl<$Res, Request>;
  @useResult
  $Res call(
      {int id,
      String mediaTitle,
      String mediaType,
      RequestStatus status,
      String? posterUrl,
      String? overview,
      int? requestUserId,
      String? requestUserName,
      DateTime? createdAt,
      DateTime? modifiedAt,
      Map<String, dynamic>? mediaData});
}

/// @nodoc
class _$RequestCopyWithImpl<$Res, $Val extends Request>
    implements $RequestCopyWith<$Res> {
  _$RequestCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? mediaTitle = null,
    Object? mediaType = null,
    Object? status = null,
    Object? posterUrl = freezed,
    Object? overview = freezed,
    Object? requestUserId = freezed,
    Object? requestUserName = freezed,
    Object? createdAt = freezed,
    Object? modifiedAt = freezed,
    Object? mediaData = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      mediaTitle: null == mediaTitle
          ? _value.mediaTitle
          : mediaTitle // ignore: cast_nullable_to_non_nullable
              as String,
      mediaType: null == mediaType
          ? _value.mediaType
          : mediaType // ignore: cast_nullable_to_non_nullable
              as String,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as RequestStatus,
      posterUrl: freezed == posterUrl
          ? _value.posterUrl
          : posterUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      overview: freezed == overview
          ? _value.overview
          : overview // ignore: cast_nullable_to_non_nullable
              as String?,
      requestUserId: freezed == requestUserId
          ? _value.requestUserId
          : requestUserId // ignore: cast_nullable_to_non_nullable
              as int?,
      requestUserName: freezed == requestUserName
          ? _value.requestUserName
          : requestUserName // ignore: cast_nullable_to_non_nullable
              as String?,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      modifiedAt: freezed == modifiedAt
          ? _value.modifiedAt
          : modifiedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      mediaData: freezed == mediaData
          ? _value.mediaData
          : mediaData // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$RequestImplCopyWith<$Res> implements $RequestCopyWith<$Res> {
  factory _$$RequestImplCopyWith(
          _$RequestImpl value, $Res Function(_$RequestImpl) then) =
      __$$RequestImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int id,
      String mediaTitle,
      String mediaType,
      RequestStatus status,
      String? posterUrl,
      String? overview,
      int? requestUserId,
      String? requestUserName,
      DateTime? createdAt,
      DateTime? modifiedAt,
      Map<String, dynamic>? mediaData});
}

/// @nodoc
class __$$RequestImplCopyWithImpl<$Res>
    extends _$RequestCopyWithImpl<$Res, _$RequestImpl>
    implements _$$RequestImplCopyWith<$Res> {
  __$$RequestImplCopyWithImpl(
      _$RequestImpl _value, $Res Function(_$RequestImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? mediaTitle = null,
    Object? mediaType = null,
    Object? status = null,
    Object? posterUrl = freezed,
    Object? overview = freezed,
    Object? requestUserId = freezed,
    Object? requestUserName = freezed,
    Object? createdAt = freezed,
    Object? modifiedAt = freezed,
    Object? mediaData = freezed,
  }) {
    return _then(_$RequestImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      mediaTitle: null == mediaTitle
          ? _value.mediaTitle
          : mediaTitle // ignore: cast_nullable_to_non_nullable
              as String,
      mediaType: null == mediaType
          ? _value.mediaType
          : mediaType // ignore: cast_nullable_to_non_nullable
              as String,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as RequestStatus,
      posterUrl: freezed == posterUrl
          ? _value.posterUrl
          : posterUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      overview: freezed == overview
          ? _value.overview
          : overview // ignore: cast_nullable_to_non_nullable
              as String?,
      requestUserId: freezed == requestUserId
          ? _value.requestUserId
          : requestUserId // ignore: cast_nullable_to_non_nullable
              as int?,
      requestUserName: freezed == requestUserName
          ? _value.requestUserName
          : requestUserName // ignore: cast_nullable_to_non_nullable
              as String?,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      modifiedAt: freezed == modifiedAt
          ? _value.modifiedAt
          : modifiedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      mediaData: freezed == mediaData
          ? _value._mediaData
          : mediaData // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
    ));
  }
}

/// @nodoc

class _$RequestImpl extends _Request {
  const _$RequestImpl(
      {required this.id,
      required this.mediaTitle,
      required this.mediaType,
      required this.status,
      this.posterUrl,
      this.overview,
      this.requestUserId,
      this.requestUserName,
      this.createdAt,
      this.modifiedAt,
      final Map<String, dynamic>? mediaData})
      : _mediaData = mediaData,
        super._();

  @override
  final int id;
  @override
  final String mediaTitle;
  @override
  final String mediaType;
// 'movie' or 'tv'
  @override
  final RequestStatus status;
  @override
  final String? posterUrl;
  @override
  final String? overview;
  @override
  final int? requestUserId;
  @override
  final String? requestUserName;
  @override
  final DateTime? createdAt;
  @override
  final DateTime? modifiedAt;
  final Map<String, dynamic>? _mediaData;
  @override
  Map<String, dynamic>? get mediaData {
    final value = _mediaData;
    if (value == null) return null;
    if (_mediaData is EqualUnmodifiableMapView) return _mediaData;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  @override
  String toString() {
    return 'Request(id: $id, mediaTitle: $mediaTitle, mediaType: $mediaType, status: $status, posterUrl: $posterUrl, overview: $overview, requestUserId: $requestUserId, requestUserName: $requestUserName, createdAt: $createdAt, modifiedAt: $modifiedAt, mediaData: $mediaData)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$RequestImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.mediaTitle, mediaTitle) ||
                other.mediaTitle == mediaTitle) &&
            (identical(other.mediaType, mediaType) ||
                other.mediaType == mediaType) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.posterUrl, posterUrl) ||
                other.posterUrl == posterUrl) &&
            (identical(other.overview, overview) ||
                other.overview == overview) &&
            (identical(other.requestUserId, requestUserId) ||
                other.requestUserId == requestUserId) &&
            (identical(other.requestUserName, requestUserName) ||
                other.requestUserName == requestUserName) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.modifiedAt, modifiedAt) ||
                other.modifiedAt == modifiedAt) &&
            const DeepCollectionEquality()
                .equals(other._mediaData, _mediaData));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      mediaTitle,
      mediaType,
      status,
      posterUrl,
      overview,
      requestUserId,
      requestUserName,
      createdAt,
      modifiedAt,
      const DeepCollectionEquality().hash(_mediaData));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$RequestImplCopyWith<_$RequestImpl> get copyWith =>
      __$$RequestImplCopyWithImpl<_$RequestImpl>(this, _$identity);
}

abstract class _Request extends Request {
  const factory _Request(
      {required final int id,
      required final String mediaTitle,
      required final String mediaType,
      required final RequestStatus status,
      final String? posterUrl,
      final String? overview,
      final int? requestUserId,
      final String? requestUserName,
      final DateTime? createdAt,
      final DateTime? modifiedAt,
      final Map<String, dynamic>? mediaData}) = _$RequestImpl;
  const _Request._() : super._();

  @override
  int get id;
  @override
  String get mediaTitle;
  @override
  String get mediaType;
  @override // 'movie' or 'tv'
  RequestStatus get status;
  @override
  String? get posterUrl;
  @override
  String? get overview;
  @override
  int? get requestUserId;
  @override
  String? get requestUserName;
  @override
  DateTime? get createdAt;
  @override
  DateTime? get modifiedAt;
  @override
  Map<String, dynamic>? get mediaData;
  @override
  @JsonKey(ignore: true)
  _$$RequestImplCopyWith<_$RequestImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
