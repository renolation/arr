import 'package:freezed_annotation/freezed_annotation.dart';

part 'failures.freezed.dart';

/// Base failure class for all domain-level failures
@immutable
sealed class Failure {
  const Failure();

  String get message;
}

/// Server-side failures
@freezed
class ServerFailure extends Failure with _$ServerFailure {
  const factory ServerFailure({
    required String message,
    int? code,
  }) = _ServerFailure;

  const ServerFailure._();
}

/// Network connectivity failures
@freezed
class NetworkFailure extends Failure with _$NetworkFailure {
  const factory NetworkFailure({
    required String message,
  }) = _NetworkFailure;

  const NetworkFailure._();
}

/// Cache operation failures
@freezed
class CacheFailure extends Failure with _$CacheFailure {
  const factory CacheFailure({
    required String message,
  }) = _CacheFailure;

  const CacheFailure._();
}

/// Authentication failures
@freezed
class AuthFailure extends Failure with _$AuthFailure {
  const factory AuthFailure({
    required String message,
  }) = _AuthFailure;

  const AuthFailure._();
}

/// Validation failures
@freezed
class ValidationFailure extends Failure with _$ValidationFailure {
  const factory ValidationFailure({
    required String message,
    Map<String, String>? fieldErrors,
  }) = _ValidationFailure;

  const ValidationFailure._();
}

/// Not found failures
@freezed
class NotFoundFailure extends Failure with _$NotFoundFailure {
  const factory NotFoundFailure({
    required String message,
  }) = _NotFoundFailure;

  const NotFoundFailure._();
}

/// Timeout failures
@freezed
class TimeoutFailure extends Failure with _$TimeoutFailure {
  const factory TimeoutFailure({
    required String message,
  }) = _TimeoutFailure;

  const TimeoutFailure._();
}

/// Unexpected/Unknown failures
@freezed
class UnknownFailure extends Failure with _$UnknownFailure {
  const factory UnknownFailure({
    required String message,
    Object? exception,
  }) = _UnknownFailure;

  const UnknownFailure._();
}
