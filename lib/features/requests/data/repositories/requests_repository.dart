import 'package:hive_flutter/hive_flutter.dart';
import '../../../../core/constants/storage_constants.dart';
import '../../../../core/errors/exceptions.dart';
import '../datasources/overseerr_remote_datasource.dart';
import '../../domain/entities/request.dart';
import '../../domain/repositories/requests_repository.dart';

/// Repository implementation for media requests
class RequestsRepositoryImpl implements RequestsRepository {
  final OverseerrRemoteDataSource remoteDataSource;
  final Box<dynamic> cacheBox;

  RequestsRepositoryImpl({
    required this.remoteDataSource,
    required this.cacheBox,
  });

  @override
  Future<List<Request>> getAllRequests() async {
    try {
      final requestsData = await remoteDataSource.getAllRequests();
      final requests = requestsData.map((data) => Request.fromJson(data)).toList();

      // Cache the results
      await cacheBox.put(StorageConstants.requestListKey, requestsData);

      return requests;
    } on ServerException {
      rethrow;
    } on NetworkException {
      rethrow;
    } catch (e) {
      throw ServerException('Failed to get all requests: ${e.toString()}');
    }
  }

  @override
  Future<List<Request>> getPendingRequests() async {
    try {
      final requestsData = await remoteDataSource.getPendingRequests();
      final requests = requestsData.map((data) => Request.fromJson(data)).toList();
      return requests;
    } on ServerException {
      rethrow;
    } on NetworkException {
      rethrow;
    } catch (e) {
      throw ServerException('Failed to get pending requests: ${e.toString()}');
    }
  }

  @override
  Future<Request> getRequestById(int id) async {
    try {
      final requestData = await remoteDataSource.getRequestById(id);
      final request = Request.fromJson(requestData);
      return request;
    } on ServerException {
      rethrow;
    } on NetworkException {
      rethrow;
    } catch (e) {
      throw ServerException('Failed to get request by id: ${e.toString()}');
    }
  }

  @override
  Future<Request> approveRequest(int id) async {
    try {
      final requestData = await remoteDataSource.approveRequest(id);
      final request = Request.fromJson(requestData);
      return request;
    } on ServerException {
      rethrow;
    } on NetworkException {
      rethrow;
    } catch (e) {
      throw ServerException('Failed to approve request: ${e.toString()}');
    }
  }

  @override
  Future<Request> declineRequest(int id) async {
    try {
      final requestData = await remoteDataSource.declineRequest(id);
      final request = Request.fromJson(requestData);
      return request;
    } on ServerException {
      rethrow;
    } on NetworkException {
      rethrow;
    } catch (e) {
      throw ServerException('Failed to decline request: ${e.toString()}');
    }
  }

  @override
  Future<List<Request>> getCachedRequests() async {
    try {
      final cachedData = cacheBox.get(StorageConstants.requestListKey);
      if (cachedData == null) {
        throw CacheException('No cached requests found');
      }

      final requestList = List<Map<String, dynamic>>.from(
        (cachedData as List).map((item) => Map<String, dynamic>.from(item)),
      );

      final requests = requestList.map((data) => Request.fromJson(data)).toList();
      return requests;
    } catch (e) {
      throw CacheException('Failed to load cached requests: $e');
    }
  }
}
