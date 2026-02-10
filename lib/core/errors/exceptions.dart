/// Base exception class for all app exceptions
abstract class AppException implements Exception {
  final String message;
  final int? code;

  const AppException(this.message, {this.code});

  @override
  String toString() => message;
}

/// Server-related exceptions
class ServerException extends AppException {
  const ServerException(super.message, {super.code});
}

/// Network-related exceptions
class NetworkException extends AppException {
  const NetworkException(super.message, {super.code});
}

/// Cache-related exceptions
class CacheException extends AppException {
  const CacheException(super.message, {super.code});
}

/// Authentication-related exceptions
class AuthException extends AppException {
  const AuthException(super.message, {super.code});
}

/// Validation exceptions
class ValidationException extends AppException {
  final Map<String, String>? fieldErrors;

  const ValidationException(
    super.message, {
    super.code,
    this.fieldErrors,
  });
}

/// Not found exceptions
class NotFoundException extends AppException {
  const NotFoundException(super.message, {super.code});
}

/// Timeout exceptions
class TimeoutException extends AppException {
  const TimeoutException(super.message, {super.code});
}

/// Parsing/Serialization exceptions
class ParseException extends AppException {
  const ParseException(super.message, {super.code});
}
