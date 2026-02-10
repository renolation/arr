import 'dart:convert';
import 'dart:developer' as developer;

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import '../constants/api_constants.dart';
import '../errors/exceptions.dart';

/// Logging interceptor that logs requests, responses, and generates curl commands
class LoggingInterceptor extends Interceptor {
  final bool logRequest;
  final bool logResponse;
  final bool logError;
  final bool logCurl;
  final bool prettyPrint;

  LoggingInterceptor({
    this.logRequest = true,
    this.logResponse = true,
    this.logError = true,
    this.logCurl = true,
    this.prettyPrint = true,
  });

  void _log(String message, {String? name}) {
    if (kDebugMode) {
      developer.log(message, name: name ?? 'DioClient');
    }
  }

  String _prettyJson(dynamic json) {
    if (!prettyPrint) return json.toString();
    try {
      const encoder = JsonEncoder.withIndent('  ');
      if (json is String) {
        return encoder.convert(jsonDecode(json));
      }
      return encoder.convert(json);
    } catch (_) {
      return json.toString();
    }
  }

  /// Generate curl command from request options
  String _generateCurl(RequestOptions options) {
    final buffer = StringBuffer('curl');

    // Add method
    buffer.write(" -X ${options.method}");

    // Add headers
    final headers = <String, dynamic>{
      ...options.headers,
    };

    // Add content-type if not present
    if (options.data != null && !headers.containsKey('Content-Type')) {
      headers['Content-Type'] = 'application/json';
    }

    for (final entry in headers.entries) {
      final value = entry.value?.toString() ?? '';
      // Mask sensitive headers
      final maskedValue = _maskSensitiveHeader(entry.key, value);
      buffer.write(" -H '${entry.key}: $maskedValue'");
    }

    // Add data
    if (options.data != null) {
      String dataStr;
      if (options.data is Map || options.data is List) {
        dataStr = jsonEncode(options.data);
      } else if (options.data is FormData) {
        dataStr = '<FormData>';
      } else {
        dataStr = options.data.toString();
      }
      // Escape single quotes in data
      dataStr = dataStr.replaceAll("'", "\\'");
      buffer.write(" -d '$dataStr'");
    }

    // Build full URL with query parameters
    final uri = options.uri;
    buffer.write(" '${uri.toString()}'");

    return buffer.toString();
  }

  /// Mask sensitive header values for logging
  String _maskSensitiveHeader(String key, String value) {
    final lowerKey = key.toLowerCase();
    if (lowerKey.contains('authorization') ||
        lowerKey.contains('x-api-key') ||
        lowerKey.contains('apikey') ||
        lowerKey.contains('token')) {
      if (value.length > 8) {
        return '${value.substring(0, 4)}****${value.substring(value.length - 4)}';
      }
      return '****';
    }
    return value;
  }

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    if (logRequest) {
      final buffer = StringBuffer();
      buffer.writeln('');
      buffer.writeln('╔══════════════════════════════════════════════════════════════');
      buffer.writeln('║ REQUEST');
      buffer.writeln('╠══════════════════════════════════════════════════════════════');
      buffer.writeln('║ ${options.method} ${options.uri}');
      buffer.writeln('║ Time: ${DateTime.now().toIso8601String()}');
      buffer.writeln('╠══════════════════════════════════════════════════════════════');

      // Headers
      buffer.writeln('║ HEADERS:');
      for (final entry in options.headers.entries) {
        final maskedValue = _maskSensitiveHeader(entry.key, entry.value?.toString() ?? '');
        buffer.writeln('║   ${entry.key}: $maskedValue');
      }

      // Query parameters
      if (options.queryParameters.isNotEmpty) {
        buffer.writeln('╠══════════════════════════════════════════════════════════════');
        buffer.writeln('║ QUERY PARAMS:');
        for (final entry in options.queryParameters.entries) {
          buffer.writeln('║   ${entry.key}: ${entry.value}');
        }
      }

      // Body
      if (options.data != null) {
        buffer.writeln('╠══════════════════════════════════════════════════════════════');
        buffer.writeln('║ BODY:');
        final bodyLines = _prettyJson(options.data).split('\n');
        for (final line in bodyLines) {
          buffer.writeln('║   $line');
        }
      }

      // Curl command
      if (logCurl) {
        buffer.writeln('╠══════════════════════════════════════════════════════════════');
        buffer.writeln('║ CURL:');
        buffer.writeln('║   ${_generateCurl(options)}');
      }

      buffer.writeln('╚══════════════════════════════════════════════════════════════');

      _log(buffer.toString(), name: 'HTTP:REQUEST');
    }

    // Store request start time
    options.extra['requestStartTime'] = DateTime.now().millisecondsSinceEpoch;

    handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    if (logResponse) {
      final startTime = response.requestOptions.extra['requestStartTime'] as int?;
      final duration = startTime != null
          ? DateTime.now().millisecondsSinceEpoch - startTime
          : null;

      final buffer = StringBuffer();
      buffer.writeln('');
      buffer.writeln('╔══════════════════════════════════════════════════════════════');
      buffer.writeln('║ RESPONSE');
      buffer.writeln('╠══════════════════════════════════════════════════════════════');
      buffer.writeln('║ ${response.requestOptions.method} ${response.requestOptions.uri}');
      buffer.writeln('║ Status: ${response.statusCode} ${response.statusMessage ?? ''}');
      if (duration != null) {
        buffer.writeln('║ Duration: ${duration}ms');
      }
      buffer.writeln('╠══════════════════════════════════════════════════════════════');

      // Response headers
      buffer.writeln('║ HEADERS:');
      for (final entry in response.headers.map.entries) {
        buffer.writeln('║   ${entry.key}: ${entry.value.join(', ')}');
      }

      // Response body
      if (response.data != null) {
        buffer.writeln('╠══════════════════════════════════════════════════════════════');
        buffer.writeln('║ BODY:');
        final bodyStr = _prettyJson(response.data);
        // Limit response body logging to prevent huge logs
        final lines = bodyStr.split('\n');
        const maxLines = 50;
        for (var i = 0; i < lines.length && i < maxLines; i++) {
          buffer.writeln('║   ${lines[i]}');
        }
        if (lines.length > maxLines) {
          buffer.writeln('║   ... (${lines.length - maxLines} more lines)');
        }
      }

      buffer.writeln('╚══════════════════════════════════════════════════════════════');

      _log(buffer.toString(), name: 'HTTP:RESPONSE');
    }

    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    if (logError) {
      final startTime = err.requestOptions.extra['requestStartTime'] as int?;
      final duration = startTime != null
          ? DateTime.now().millisecondsSinceEpoch - startTime
          : null;

      final buffer = StringBuffer();
      buffer.writeln('');
      buffer.writeln('╔══════════════════════════════════════════════════════════════');
      buffer.writeln('║ ERROR');
      buffer.writeln('╠══════════════════════════════════════════════════════════════');
      buffer.writeln('║ ${err.requestOptions.method} ${err.requestOptions.uri}');
      buffer.writeln('║ Type: ${err.type}');
      if (err.response != null) {
        buffer.writeln('║ Status: ${err.response?.statusCode} ${err.response?.statusMessage ?? ''}');
      }
      if (duration != null) {
        buffer.writeln('║ Duration: ${duration}ms');
      }
      buffer.writeln('║ Message: ${err.message ?? 'Unknown error'}');
      buffer.writeln('╠══════════════════════════════════════════════════════════════');

      // Error response body
      if (err.response?.data != null) {
        buffer.writeln('║ RESPONSE BODY:');
        final bodyLines = _prettyJson(err.response?.data).split('\n');
        for (final line in bodyLines) {
          buffer.writeln('║   $line');
        }
      }

      // Curl for retry
      if (logCurl) {
        buffer.writeln('╠══════════════════════════════════════════════════════════════');
        buffer.writeln('║ CURL (for retry):');
        buffer.writeln('║   ${_generateCurl(err.requestOptions)}');
      }

      buffer.writeln('╚══════════════════════════════════════════════════════════════');

      _log(buffer.toString(), name: 'HTTP:ERROR');
    }

    handler.next(err);
  }
}

/// Configured Dio client for making HTTP requests to *arr services
class DioClient {
  final Dio _dio;
  final bool enableLogging;

  DioClient({
    Duration? connectTimeout,
    Duration? receiveTimeout,
    Duration? sendTimeout,
    List<Interceptor>? interceptors,
    this.enableLogging = kDebugMode,
  }) : _dio = Dio(
          BaseOptions(
            connectTimeout: connectTimeout ?? ApiConstants.connectTimeout,
            receiveTimeout: receiveTimeout ?? ApiConstants.receiveTimeout,
            sendTimeout: sendTimeout ?? ApiConstants.sendTimeout,
            headers: {
              ApiConstants.contentTypeHeader: ApiConstants.applicationJson,
              ApiConstants.acceptHeader: ApiConstants.applicationJson,
            },
          ),
        ) {
    // Add logging interceptor first (if enabled)
    if (enableLogging) {
      _dio.interceptors.add(LoggingInterceptor(
        logRequest: true,
        logResponse: true,
        logError: true,
        logCurl: true,
        prettyPrint: true,
      ));
    }

    // Add custom interceptors
    if (interceptors != null) {
      _dio.interceptors.addAll(interceptors);
    }

    // Add error handling interceptor last
    _dio.interceptors.add(
      InterceptorsWrapper(
        onError: (error, handler) {
          final exception = _handleDioError(error);
          handler.reject(DioException(
            requestOptions: error.requestOptions,
            error: exception,
            response: error.response,
            type: error.type,
          ));
        },
      ),
    );
  }

  Dio get dio => _dio;

  /// Set API key for authentication
  void setApiKey(String apiKey) {
    _dio.options.headers[ApiConstants.authorizationHeader] = apiKey;
  }

  /// Set HTTP Basic authentication header
  void setBasicAuth(String username, String password) {
    final credentials = base64Encode(utf8.encode('$username:$password'));
    _dio.options.headers['Authorization'] = 'Basic $credentials';
  }

  /// Set Bearer token authentication header
  void setBearerToken(String token) {
    _dio.options.headers['Authorization'] = 'Bearer $token';
  }

  /// Set base URL for the client
  void setBaseUrl(String baseUrl) {
    _dio.options.baseUrl = baseUrl;
  }

  /// Clear API key
  void clearApiKey() {
    _dio.options.headers.remove(ApiConstants.authorizationHeader);
  }

  /// Handle Dio errors and convert to app exceptions
  AppException _handleDioError(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return const TimeoutException('Request timeout. Please try again.');

      case DioExceptionType.connectionError:
        return const NetworkException('No internet connection.');

      case DioExceptionType.badResponse:
        final statusCode = error.response?.statusCode;
        final message = error.response?.data?['message'] ??
            error.response?.statusMessage ??
            'An error occurred';

        switch (statusCode) {
          case 401:
            return const AuthException('Invalid API key or unauthorized access');
          case 404:
            return const NotFoundException('Resource not found');
          case 400:
            return ValidationException(message);
          case 500:
          case 502:
          case 503:
            return ServerException(message, code: statusCode);
          default:
            return ServerException(message, code: statusCode);
        }

      case DioExceptionType.cancel:
        return const ServerException('Request was cancelled');

      case DioExceptionType.unknown:
        return const ServerException('An unexpected error occurred');

      default:
        return const ServerException('Unknown error occurred');
    }
  }

  /// GET request
  Future<Response<T>> get<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onReceiveProgress,
  }) async {
    try {
      return await _dio.get<T>(
        path,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        onReceiveProgress: onReceiveProgress,
      );
    } on DioException {
      rethrow;
    }
  }

  /// POST request
  Future<Response<T>> post<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    try {
      return await _dio.post<T>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
      );
    } on DioException {
      rethrow;
    }
  }

  /// PUT request
  Future<Response<T>> put<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    try {
      return await _dio.put<T>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
      );
    } on DioException {
      rethrow;
    }
  }

  /// DELETE request
  Future<Response<T>> delete<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    try {
      return await _dio.delete<T>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );
    } on DioException {
      rethrow;
    }
  }
}
