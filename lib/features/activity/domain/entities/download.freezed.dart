// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'download.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$Download {
  int get id => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  DownloadStatus get status => throw _privateConstructorUsedError;
  DownloadSource get source => throw _privateConstructorUsedError;
  String? get quality => throw _privateConstructorUsedError;
  double? get size => throw _privateConstructorUsedError;
  double? get sizeLeft => throw _privateConstructorUsedError;
  double? get progress => throw _privateConstructorUsedError;
  DateTime? get date => throw _privateConstructorUsedError;
  String? get errorMessage => throw _privateConstructorUsedError;
  String? get protocol =>
      throw _privateConstructorUsedError; // torrent or usenet
  Map<String, dynamic>? get metadata => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $DownloadCopyWith<Download> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DownloadCopyWith<$Res> {
  factory $DownloadCopyWith(Download value, $Res Function(Download) then) =
      _$DownloadCopyWithImpl<$Res, Download>;
  @useResult
  $Res call(
      {int id,
      String title,
      DownloadStatus status,
      DownloadSource source,
      String? quality,
      double? size,
      double? sizeLeft,
      double? progress,
      DateTime? date,
      String? errorMessage,
      String? protocol,
      Map<String, dynamic>? metadata});
}

/// @nodoc
class _$DownloadCopyWithImpl<$Res, $Val extends Download>
    implements $DownloadCopyWith<$Res> {
  _$DownloadCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? status = null,
    Object? source = null,
    Object? quality = freezed,
    Object? size = freezed,
    Object? sizeLeft = freezed,
    Object? progress = freezed,
    Object? date = freezed,
    Object? errorMessage = freezed,
    Object? protocol = freezed,
    Object? metadata = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as DownloadStatus,
      source: null == source
          ? _value.source
          : source // ignore: cast_nullable_to_non_nullable
              as DownloadSource,
      quality: freezed == quality
          ? _value.quality
          : quality // ignore: cast_nullable_to_non_nullable
              as String?,
      size: freezed == size
          ? _value.size
          : size // ignore: cast_nullable_to_non_nullable
              as double?,
      sizeLeft: freezed == sizeLeft
          ? _value.sizeLeft
          : sizeLeft // ignore: cast_nullable_to_non_nullable
              as double?,
      progress: freezed == progress
          ? _value.progress
          : progress // ignore: cast_nullable_to_non_nullable
              as double?,
      date: freezed == date
          ? _value.date
          : date // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      errorMessage: freezed == errorMessage
          ? _value.errorMessage
          : errorMessage // ignore: cast_nullable_to_non_nullable
              as String?,
      protocol: freezed == protocol
          ? _value.protocol
          : protocol // ignore: cast_nullable_to_non_nullable
              as String?,
      metadata: freezed == metadata
          ? _value.metadata
          : metadata // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$DownloadImplCopyWith<$Res>
    implements $DownloadCopyWith<$Res> {
  factory _$$DownloadImplCopyWith(
          _$DownloadImpl value, $Res Function(_$DownloadImpl) then) =
      __$$DownloadImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int id,
      String title,
      DownloadStatus status,
      DownloadSource source,
      String? quality,
      double? size,
      double? sizeLeft,
      double? progress,
      DateTime? date,
      String? errorMessage,
      String? protocol,
      Map<String, dynamic>? metadata});
}

/// @nodoc
class __$$DownloadImplCopyWithImpl<$Res>
    extends _$DownloadCopyWithImpl<$Res, _$DownloadImpl>
    implements _$$DownloadImplCopyWith<$Res> {
  __$$DownloadImplCopyWithImpl(
      _$DownloadImpl _value, $Res Function(_$DownloadImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? status = null,
    Object? source = null,
    Object? quality = freezed,
    Object? size = freezed,
    Object? sizeLeft = freezed,
    Object? progress = freezed,
    Object? date = freezed,
    Object? errorMessage = freezed,
    Object? protocol = freezed,
    Object? metadata = freezed,
  }) {
    return _then(_$DownloadImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as DownloadStatus,
      source: null == source
          ? _value.source
          : source // ignore: cast_nullable_to_non_nullable
              as DownloadSource,
      quality: freezed == quality
          ? _value.quality
          : quality // ignore: cast_nullable_to_non_nullable
              as String?,
      size: freezed == size
          ? _value.size
          : size // ignore: cast_nullable_to_non_nullable
              as double?,
      sizeLeft: freezed == sizeLeft
          ? _value.sizeLeft
          : sizeLeft // ignore: cast_nullable_to_non_nullable
              as double?,
      progress: freezed == progress
          ? _value.progress
          : progress // ignore: cast_nullable_to_non_nullable
              as double?,
      date: freezed == date
          ? _value.date
          : date // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      errorMessage: freezed == errorMessage
          ? _value.errorMessage
          : errorMessage // ignore: cast_nullable_to_non_nullable
              as String?,
      protocol: freezed == protocol
          ? _value.protocol
          : protocol // ignore: cast_nullable_to_non_nullable
              as String?,
      metadata: freezed == metadata
          ? _value._metadata
          : metadata // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
    ));
  }
}

/// @nodoc

class _$DownloadImpl extends _Download {
  const _$DownloadImpl(
      {required this.id,
      required this.title,
      required this.status,
      required this.source,
      this.quality,
      this.size,
      this.sizeLeft,
      this.progress,
      this.date,
      this.errorMessage,
      this.protocol,
      final Map<String, dynamic>? metadata})
      : _metadata = metadata,
        super._();

  @override
  final int id;
  @override
  final String title;
  @override
  final DownloadStatus status;
  @override
  final DownloadSource source;
  @override
  final String? quality;
  @override
  final double? size;
  @override
  final double? sizeLeft;
  @override
  final double? progress;
  @override
  final DateTime? date;
  @override
  final String? errorMessage;
  @override
  final String? protocol;
// torrent or usenet
  final Map<String, dynamic>? _metadata;
// torrent or usenet
  @override
  Map<String, dynamic>? get metadata {
    final value = _metadata;
    if (value == null) return null;
    if (_metadata is EqualUnmodifiableMapView) return _metadata;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  @override
  String toString() {
    return 'Download(id: $id, title: $title, status: $status, source: $source, quality: $quality, size: $size, sizeLeft: $sizeLeft, progress: $progress, date: $date, errorMessage: $errorMessage, protocol: $protocol, metadata: $metadata)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DownloadImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.source, source) || other.source == source) &&
            (identical(other.quality, quality) || other.quality == quality) &&
            (identical(other.size, size) || other.size == size) &&
            (identical(other.sizeLeft, sizeLeft) ||
                other.sizeLeft == sizeLeft) &&
            (identical(other.progress, progress) ||
                other.progress == progress) &&
            (identical(other.date, date) || other.date == date) &&
            (identical(other.errorMessage, errorMessage) ||
                other.errorMessage == errorMessage) &&
            (identical(other.protocol, protocol) ||
                other.protocol == protocol) &&
            const DeepCollectionEquality().equals(other._metadata, _metadata));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      title,
      status,
      source,
      quality,
      size,
      sizeLeft,
      progress,
      date,
      errorMessage,
      protocol,
      const DeepCollectionEquality().hash(_metadata));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$DownloadImplCopyWith<_$DownloadImpl> get copyWith =>
      __$$DownloadImplCopyWithImpl<_$DownloadImpl>(this, _$identity);
}

abstract class _Download extends Download {
  const factory _Download(
      {required final int id,
      required final String title,
      required final DownloadStatus status,
      required final DownloadSource source,
      final String? quality,
      final double? size,
      final double? sizeLeft,
      final double? progress,
      final DateTime? date,
      final String? errorMessage,
      final String? protocol,
      final Map<String, dynamic>? metadata}) = _$DownloadImpl;
  const _Download._() : super._();

  @override
  int get id;
  @override
  String get title;
  @override
  DownloadStatus get status;
  @override
  DownloadSource get source;
  @override
  String? get quality;
  @override
  double? get size;
  @override
  double? get sizeLeft;
  @override
  double? get progress;
  @override
  DateTime? get date;
  @override
  String? get errorMessage;
  @override
  String? get protocol;
  @override // torrent or usenet
  Map<String, dynamic>? get metadata;
  @override
  @JsonKey(ignore: true)
  _$$DownloadImplCopyWith<_$DownloadImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
