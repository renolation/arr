import 'package:dio/dio.dart';
import 'package:arr/models/part_4.dart';
import 'package:arr/models/hive/service_config.dart';

class RadarrApi {
  final Dio _dio;
  final ServiceConfig config;
  
  RadarrApi(this.config) : _dio = Dio() {
    _dio.options.baseUrl = config.url;
    _dio.options.headers = {
      'X-Api-Key': config.apiKey,
      'Content-Type': 'application/json',
    };
    _dio.options.connectTimeout = const Duration(seconds: 10);
    _dio.options.receiveTimeout = const Duration(seconds: 10);
  }
  
  Future<List<MovieResource>> getMovies() async {
    try {
      final response = await _dio.get('/api/v3/movie');
      if (response.data is List) {
        return (response.data as List)
            .map((json) => MovieResource.fromJson(json))
            .toList();
      }
      return [];
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }
  
  Future<MovieResource> getMovieById(int id) async {
    try {
      final response = await _dio.get('/api/v3/movie/$id');
      return MovieResource.fromJson(response.data);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }
  
  Future<bool> testConnection() async {
    try {
      final response = await _dio.get('/api/v3/system/status');
      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }
  
  Future<Map<String, dynamic>> getSystemStatus() async {
    try {
      final response = await _dio.get('/api/v3/system/status');
      return response.data;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }
  
  Future<List<Map<String, dynamic>>> getCalendar({
    DateTime? start,
    DateTime? end,
  }) async {
    try {
      final queryParams = <String, dynamic>{};
      if (start != null) {
        queryParams['start'] = start.toIso8601String();
      }
      if (end != null) {
        queryParams['end'] = end.toIso8601String();
      }
      
      final response = await _dio.get('/api/v3/calendar', queryParameters: queryParams);
      if (response.data is List) {
        return List<Map<String, dynamic>>.from(response.data);
      }
      return [];
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }
  
  Future<List<Map<String, dynamic>>> getQueue() async {
    try {
      final response = await _dio.get('/api/v3/queue');
      if (response.data is Map && response.data['records'] is List) {
        return List<Map<String, dynamic>>.from(response.data['records']);
      }
      return [];
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }
  
  Future<List<Map<String, dynamic>>> getHistory({
    int page = 1,
    int pageSize = 10,
  }) async {
    try {
      final response = await _dio.get('/api/v3/history', queryParameters: {
        'page': page,
        'pageSize': pageSize,
      });
      if (response.data is Map && response.data['records'] is List) {
        return List<Map<String, dynamic>>.from(response.data['records']);
      }
      return [];
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }
  
  Exception _handleError(DioException error) {
    if (error.type == DioExceptionType.connectionTimeout ||
        error.type == DioExceptionType.receiveTimeout) {
      return Exception('Connection timeout. Please check your network connection.');
    } else if (error.type == DioExceptionType.connectionError) {
      return Exception('Unable to connect to server. Please check the URL and your network.');
    } else if (error.response?.statusCode == 401) {
      return Exception('Unauthorized. Please check your API key.');
    } else if (error.response?.statusCode == 404) {
      return Exception('Resource not found.');
    } else {
      return Exception('An error occurred: ${error.message}');
    }
  }
}