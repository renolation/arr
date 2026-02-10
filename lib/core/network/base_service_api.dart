import 'dart:convert';
import 'dart:developer' as developer;

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import '../errors/exceptions.dart';
import '../../features/settings/domain/entities/service_config.dart';

/// Abstract base class for all *arr service APIs
///
/// Each service (Sonarr, Radarr, Overseerr, etc.) extends this class
/// and gets its own Dio instance configured with the service's URL and API key.
abstract class BaseServiceApi {
  final Dio _dio;
  final ServiceConfig config;
  final String apiBasePath;

  BaseServiceApi({
    required this.config,
    required this.apiBasePath,
    Duration connectTimeout = const Duration(seconds: 30),
    Duration receiveTimeout = const Duration(seconds: 30),
    Duration sendTimeout = const Duration(seconds: 30),
    bool enableLogging = true,
  }) : _dio = Dio() {
    // Configure Dio with service-specific settings
    _dio.options.baseUrl = '${config.baseUrl}$apiBasePath';
    _dio.options.headers = {
      'X-Api-Key': config.apiKey ?? '',
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };
    _dio.options.connectTimeout = connectTimeout;
    _dio.options.receiveTimeout = receiveTimeout;
    _dio.options.sendTimeout = sendTimeout;

    // Add logging interceptor in debug mode
    if (kDebugMode && enableLogging) {
      _dio.interceptors.add(_LoggingInterceptor(serviceName: runtimeType.toString()));
    }
  }

  /// Get the Dio instance (for advanced usage)
  Dio get dio => _dio;

  /// GET request
  Future<Response<T>> get<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    try {
      return await _dio.get<T>(
        path,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  /// POST request
  Future<Response<T>> post<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    try {
      return await _dio.post<T>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  /// PUT request
  Future<Response<T>> put<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    try {
      return await _dio.put<T>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );
    } on DioException catch (e) {
      throw _handleError(e);
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
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  /// Test connection to the service
  Future<bool> testConnection() async {
    try {
      final response = await get('/system/status');
      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }

  /// Get system status
  Future<Map<String, dynamic>> getSystemStatus() async {
    final response = await get('/system/status');
    return response.data as Map<String, dynamic>;
  }

  /// Parse list response
  List<T> parseList<T>(
    Response response,
    T Function(Map<String, dynamic>) fromJson,
  ) {
    if (response.data is List) {
      return (response.data as List)
          .map((json) => fromJson(json as Map<String, dynamic>))
          .toList();
    }
    return [];
  }

  /// Parse single item response
  T parseItem<T>(
    Response response,
    T Function(Map<String, dynamic>) fromJson,
  ) {
    return fromJson(response.data as Map<String, dynamic>);
  }

  /// Handle Dio errors and convert to app exceptions
  AppException _handleError(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return const TimeoutException(
          'Connection timeout. Please check your network connection.',
        );

      case DioExceptionType.connectionError:
        return const NetworkException(
          'Unable to connect to server. Please check the URL and your network.',
        );

      case DioExceptionType.badResponse:
        final statusCode = error.response?.statusCode;
        final data = error.response?.data;
        String message = 'An error occurred';

        if (data is Map) {
          message = data['message'] ?? data['error'] ?? message;
        } else if (error.response?.statusMessage != null) {
          message = error.response!.statusMessage!;
        }

        switch (statusCode) {
          case 401:
            return const AuthException(
              'Unauthorized. Please check your API key.',
            );
          case 403:
            return const AuthException(
              'Access forbidden. Please check your permissions.',
            );
          case 404:
            return NotFoundException(
              'Resource not found: ${error.requestOptions.path}',
              code: statusCode,
            );
          case 400:
            return ValidationException(message);
          case 500:
          case 502:
          case 503:
            return ServerException(
              'Server error: $message',
              code: statusCode,
            );
          default:
            return ServerException(message, code: statusCode);
        }

      case DioExceptionType.cancel:
        return const ServerException('Request was cancelled');

      case DioExceptionType.unknown:
      default:
        return ServerException(
          'An unexpected error occurred: ${error.message}',
        );
    }
  }
}

/// Simple logging interceptor for API requests
class _LoggingInterceptor extends Interceptor {
  final String serviceName;

  _LoggingInterceptor({required this.serviceName});

  void _log(String message) {
    developer.log(message, name: serviceName);
  }

  String _maskApiKey(String? value) {
    if (value == null || value.isEmpty) return '';
    if (value.length > 8) {
      return '${value.substring(0, 4)}****${value.substring(value.length - 4)}';
    }
    return '****';
  }

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    final buffer = StringBuffer();
    buffer.writeln('');
    buffer.writeln('┌─────────────────────────────────────────────');
    buffer.writeln('│ REQUEST: ${options.method} ${options.uri}');
    buffer.writeln('│ Headers:');
    for (final entry in options.headers.entries) {
      final value = entry.key.toLowerCase().contains('api')
          ? _maskApiKey(entry.value?.toString())
          : entry.value;
      buffer.writeln('│   ${entry.key}: $value');
    }
    if (options.data != null) {
      buffer.writeln('│ Body: ${_truncate(options.data.toString(), 200)}');
    }
    buffer.writeln('└─────────────────────────────────────────────');
    _log(buffer.toString());

    options.extra['startTime'] = DateTime.now().millisecondsSinceEpoch;
    handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    final startTime = response.requestOptions.extra['startTime'] as int?;
    final duration = startTime != null
        ? DateTime.now().millisecondsSinceEpoch - startTime
        : null;

    final buffer = StringBuffer();
    buffer.writeln('');
    buffer.writeln('┌─────────────────────────────────────────────');
    buffer.writeln('│ RESPONSE: ${response.statusCode} ${response.requestOptions.uri}');
    if (duration != null) {
      buffer.writeln('│ Duration: ${duration}ms');
    }
    buffer.writeln('│ Body: ${_truncate(_prettyJson(response.data), 500)}');
    buffer.writeln('└─────────────────────────────────────────────');
    _log(buffer.toString());

    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    final buffer = StringBuffer();
    buffer.writeln('');
    buffer.writeln('┌─────────────────────────────────────────────');
    buffer.writeln('│ ERROR: ${err.type} ${err.requestOptions.uri}');
    buffer.writeln('│ Status: ${err.response?.statusCode}');
    buffer.writeln('│ Message: ${err.message}');
    if (err.response?.data != null) {
      buffer.writeln('│ Body: ${_truncate(err.response?.data.toString() ?? '', 200)}');
    }
    buffer.writeln('└─────────────────────────────────────────────');
    _log(buffer.toString());

    handler.next(err);
  }

  String _truncate(String text, int maxLength) {
    if (text.length <= maxLength) return text;
    return '${text.substring(0, maxLength)}...';
  }

  String _prettyJson(dynamic json) {
    try {
      if (json is String) {
        return json;
      }
      const encoder = JsonEncoder.withIndent('  ');
      return encoder.convert(json);
    } catch (_) {
      return json.toString();
    }
  }
}
