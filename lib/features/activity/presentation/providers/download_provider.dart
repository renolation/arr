import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../../../../core/constants/storage_constants.dart';
import '../../../../core/database/hive_database.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/network/dio_client.dart';
import '../../data/datasources/download_remote_datasource.dart';
import '../../data/repositories/download_repository.dart';
import '../../domain/entities/download.dart';

/// Provider for cache box
final downloadCacheBoxProvider = Provider<Box<dynamic>>((ref) {
  return HiveDatabase.getBox<dynamic>(StorageConstants.downloadQueueBox);
});

/// Provider for remote data source
final downloadRemoteDataSourceProvider = Provider<DownloadRemoteDataSource>((ref) {
  return DownloadRemoteDataSource(
    dioClient: DioClient(),
  );
});

/// Provider for repository
final downloadRepositoryProvider = Provider<DownloadRepositoryImpl>((ref) {
  return DownloadRepositoryImpl(
    remoteDataSource: ref.watch(downloadRemoteDataSourceProvider),
    cacheBox: ref.watch(downloadCacheBoxProvider),
  );
});

/// Provider for download queue
final downloadQueueProvider = FutureProvider<List<Download>>((ref) async {
  try {
    return await ref.watch(downloadRepositoryProvider).getQueue();
  } on ServerException catch (e) {
    throw Exception('Failed to load queue: ${e.message}');
  } on NetworkException catch (e) {
    throw Exception('Network error: ${e.message}');
  } on CacheException catch (e) {
    throw Exception('Cache error: ${e.message}');
  } catch (e) {
    throw Exception('Unexpected error: ${e.toString()}');
  }
});

/// Provider for download history
final downloadHistoryProvider = FutureProvider<List<Download>>((ref) async {
  try {
    return await ref.watch(downloadRepositoryProvider).getHistory();
  } on ServerException catch (e) {
    throw Exception('Failed to load history: ${e.message}');
  } on NetworkException catch (e) {
    throw Exception('Network error: ${e.message}');
  } on CacheException catch (e) {
    throw Exception('Cache error: ${e.message}');
  } catch (e) {
    throw Exception('Unexpected error: ${e.toString()}');
  }
});

/// Provider for cached queue
final cachedDownloadQueueProvider = FutureProvider<List<Download>>((ref) async {
  try {
    return await ref.watch(downloadRepositoryProvider).getCachedQueue();
  } on CacheException catch (e) {
    throw Exception('Cache error: ${e.message}');
  } catch (e) {
    throw Exception('Unexpected error: ${e.toString()}');
  }
});

/// Provider for activity tab filter
final activityFilterProvider = StateProvider<ActivityFilter>((ref) {
  return ActivityFilter.queue;
});

/// Provider for filtered activity
final filteredActivityProvider = Provider<List<Download>>((ref) {
  final queueAsync = ref.watch(downloadQueueProvider);
  final historyAsync = ref.watch(downloadHistoryProvider);
  final filter = ref.watch(activityFilterProvider);

  if (filter == ActivityFilter.queue) {
    return queueAsync.when(
      data: (downloads) => downloads,
      loading: () => [],
      error: (_, __) => [],
    );
  } else {
    return historyAsync.when(
      data: (downloads) => downloads,
      loading: () => [],
      error: (_, __) => [],
    );
  }
});

/// Provider for active downloads count
final activeDownloadsCountProvider = Provider<int>((ref) {
  final queueAsync = ref.watch(downloadQueueProvider);

  return queueAsync.when(
    data: (downloads) => downloads.where((d) => d.isActive).length,
    loading: () => 0,
    error: (_, __) => 0,
  );
});

enum ActivityFilter { queue, history }
