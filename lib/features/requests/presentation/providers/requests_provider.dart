import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../../../../core/database/hive_database.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/network/dio_client.dart';
import '../../data/datasources/overseerr_remote_datasource.dart';
import '../../data/repositories/requests_repository.dart';
import '../../domain/entities/request.dart';

/// Provider for cache box
final requestsCacheBoxProvider = Provider<Box<dynamic>>((ref) {
  return HiveDatabase.getBox<dynamic>(HiveDatabase.overseerrCacheBox);
});

/// Provider for remote data source
final requestsRemoteDataSourceProvider = Provider<OverseerrRemoteDataSource>((ref) {
  return OverseerrRemoteDataSource(
    dioClient: DioClient(),
  );
});

/// Provider for repository
final requestsRepositoryProvider = Provider<RequestsRepositoryImpl>((ref) {
  return RequestsRepositoryImpl(
    remoteDataSource: ref.watch(requestsRemoteDataSourceProvider),
    cacheBox: ref.watch(requestsCacheBoxProvider),
  );
});

/// Provider for all requests
final allRequestsProvider = FutureProvider<List<Request>>((ref) async {
  try {
    return await ref.watch(requestsRepositoryProvider).getAllRequests();
  } on ServerException catch (e) {
    throw Exception('Failed to load requests: ${e.message}');
  } on NetworkException catch (e) {
    throw Exception('Network error: ${e.message}');
  } on CacheException catch (e) {
    throw Exception('Cache error: ${e.message}');
  } catch (e) {
    throw Exception('Unexpected error: ${e.toString()}');
  }
});

/// Provider for pending requests
final pendingRequestsProvider = FutureProvider<List<Request>>((ref) async {
  try {
    return await ref.watch(requestsRepositoryProvider).getPendingRequests();
  } on ServerException catch (e) {
    throw Exception('Failed to load pending requests: ${e.message}');
  } on NetworkException catch (e) {
    throw Exception('Network error: ${e.message}');
  } catch (e) {
    throw Exception('Unexpected error: ${e.toString()}');
  }
});

/// Provider for cached requests
final cachedRequestsProvider = FutureProvider<List<Request>>((ref) async {
  try {
    return await ref.watch(requestsRepositoryProvider).getCachedRequests();
  } on CacheException catch (e) {
    throw Exception('Cache error: ${e.message}');
  } catch (e) {
    throw Exception('Unexpected error: ${e.toString()}');
  }
});

/// Provider for request by ID
final requestProvider = FutureProvider.family<Request, int>((ref, id) async {
  try {
    return await ref.watch(requestsRepositoryProvider).getRequestById(id);
  } on ServerException catch (e) {
    throw Exception('Failed to load request: ${e.message}');
  } on NetworkException catch (e) {
    throw Exception('Network error: ${e.message}');
  } on NotFoundException catch (e) {
    throw Exception('Request not found: ${e.message}');
  } catch (e) {
    throw Exception('Unexpected error: ${e.toString()}');
  }
});

/// Provider for request filter
final requestFilterProvider = StateProvider<RequestFilter>((ref) {
  return RequestFilter.all;
});

/// Provider for filtered requests
final filteredRequestsProvider = Provider<List<Request>>((ref) {
  final allRequests = ref.watch(allRequestsProvider);
  final filter = ref.watch(requestFilterProvider);

  return allRequests.when(
    data: (requests) {
      if (filter == RequestFilter.all) return requests;
      if (filter == RequestFilter.pending) {
        return requests.where((r) => r.isPending).toList();
      }
      if (filter == RequestFilter.approved) {
        return requests.where((r) => r.isApproved).toList();
      }
      return requests;
    },
    loading: () => [],
    error: (_, __) => [],
  );
});

enum RequestFilter { all, pending, approved }
