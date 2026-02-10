import 'package:dio/dio.dart';
import '../../core/network/dio_client.dart';
import '../../core/errors/exceptions.dart';

/// Abstract base class for all *arr API services
///
/// Provides common functionality for API authentication, request handling,
/// error handling, and response parsing.
abstract class BaseApiService {
  final DioClient _dioClient;
  final String baseUrl;
  final String apiKey;
  final String apiBasePath;

  BaseApiService({
    required this.baseUrl,
    required this.apiKey,
    required this.apiBasePath,
    Duration? connectTimeout,
    Duration? receiveTimeout,
    Duration? sendTimeout,
  }) : _dioClient = DioClient(
          connectTimeout: connectTimeout,
          receiveTimeout: receiveTimeout,
          sendTimeout: sendTimeout,
        ) {
    _configureClient();
  }

  /// Configure the Dio client with base URL and API key
  void _configureClient() {
    _dioClient.setBaseUrl('$baseUrl$apiBasePath');
    _dioClient.setApiKey(apiKey);
  }

  /// Update API configuration
  void updateConfiguration({
    required String baseUrl,
    required String apiKey,
  }) {
    _dioClient.setBaseUrl('$baseUrl$apiBasePath');
    _dioClient.setApiKey(apiKey);
  }

  /// GET request
  Future<Response> get(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onReceiveProgress,
  }) async {
    try {
      return await _dioClient.get(
        path,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        onReceiveProgress: onReceiveProgress,
      );
    } on DioException catch (e) {
      throw _handleException(e);
    }
  }

  /// POST request
  Future<Response> post(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    try {
      return await _dioClient.post(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
      );
    } on DioException catch (e) {
      throw _handleException(e);
    }
  }

  /// PUT request
  Future<Response> put(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    try {
      return await _dioClient.put(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
      );
    } on DioException catch (e) {
      throw _handleException(e);
    }
  }

  /// DELETE request
  Future<Response> delete(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    try {
      return await _dioClient.delete(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );
    } on DioException catch (e) {
      throw _handleException(e);
    }
  }

  /// Parse response data from Dio Response
  T parseResponse<T>(Response response) {
    if (response.data == null) {
      throw const ParseException('Response data is null');
    }

    // Return data directly if already the correct type
    final data = response.data;
    if (data is T) {
      return data;
    }

    throw ParseException(
      'Unable to parse response to type $T',
      code: response.statusCode,
    );
  }

  /// Parse list of items from response
  List<T> parseList<T>(
    Response response,
    T Function(Map<String, dynamic>) fromJson,
  ) {
    if (response.data == null) {
      throw const ParseException('Response data is null');
    }

    if (response.data is! List) {
      throw const ParseException('Response data is not a list');
    }

    try {
      return (response.data as List)
          .cast<Map<String, dynamic>>()
          .map((item) => fromJson(item))
          .toList();
    } catch (e) {
      throw ParseException(
        'Failed to parse list: $e',
        code: response.statusCode,
      );
    }
  }

  /// Parse single item from response
  T parseItem<T>(
    Response response,
    T Function(Map<String, dynamic>) fromJson,
  ) {
    if (response.data == null) {
      throw const ParseException('Response data is null');
    }

    if (response.data is! Map) {
      throw const ParseException('Response data is not an object');
    }

    try {
      return fromJson(response.data as Map<String, dynamic>);
    } catch (e) {
      throw ParseException(
        'Failed to parse item: $e',
        code: response.statusCode,
      );
    }
  }

  /// Test connection to the service
  Future<bool> testConnection() async {
    try {
      await get('/api');
      return true;
    } catch (e) {
      return false;
    }
  }

  /// Handle Dio exceptions and convert to app exceptions
  AppException _handleException(DioException error) {
    // DioClient already converts errors to AppException
    // Just return the error if it's already an AppException
    if (error.error is AppException) {
      return error.error as AppException;
    }

    // Fallback error handling
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return const TimeoutException('Request timeout. Please try again.');

      case DioExceptionType.connectionError:
        return const NetworkException('No internet connection.');

      case DioExceptionType.badResponse:
        final statusCode = error.response?.statusCode;
        final message = error.response?.data is Map
            ? (error.response!.data as Map)['message'] ??
                (error.response!.data as Map)['error'] ??
                'An error occurred'
            : error.response?.statusMessage ?? 'An error occurred';

        switch (statusCode) {
          case 401:
            return const AuthException('Invalid API key or unauthorized access');
          case 404:
            return NotFoundException('Resource not found: ${error.requestOptions.path}', code: statusCode);
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
        return const NetworkFailure('Request was cancelled');

      case DioExceptionType.unknown:
        return const NetworkException('An unexpected error occurred');

      default:
        return const UnknownFailure('Unknown error occurred') as AppException;
    }
  }
}

/// Unknown failure exception (fallback)
class UnknownFailure extends AppException {
  const UnknownFailure(super.message, {super.code});
}

/// Network failure exception
class NetworkFailure extends AppException {
  const NetworkFailure(super.message, {super.code});
}
