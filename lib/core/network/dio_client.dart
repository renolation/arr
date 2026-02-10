import 'package:dio/dio.dart';
import '../constants/api_constants.dart';
import '../errors/exceptions.dart';

/// Configured Dio client for making HTTP requests to *arr services
class DioClient {
  final Dio _dio;

  DioClient({
    Duration? connectTimeout,
    Duration? receiveTimeout,
    Duration? sendTimeout,
    List<Interceptor>? interceptors,
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
    if (interceptors != null) {
      _dio.interceptors.addAll(interceptors);
    }
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
