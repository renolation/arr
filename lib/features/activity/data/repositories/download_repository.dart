import 'package:hive_flutter/hive_flutter.dart';
import '../../../../core/constants/storage_constants.dart';
import '../../../../core/errors/exceptions.dart';
import '../datasources/download_remote_datasource.dart';
import '../../domain/entities/download.dart';
import '../../domain/repositories/download_repository.dart';

/// Repository implementation for downloads
class DownloadRepositoryImpl implements DownloadRepository {
  final DownloadRemoteDataSource remoteDataSource;
  final Box<dynamic> cacheBox;

  DownloadRepositoryImpl({
    required this.remoteDataSource,
    required this.cacheBox,
  });

  @override
  Future<List<Download>> getQueue() async {
    try {
      // Fetch queue from both services
      final results = await Future.wait([
        remoteDataSource.getSonarrQueue(),
        remoteDataSource.getRadarrQueue(),
      ]);

      final sonarrQueue = results[0];
      final radarrQueue = results[1];

      final downloads = <Download>[];

      // Process Sonarr queue
      if (sonarrQueue.containsKey('records')) {
        final records = sonarrQueue['records'] as List;
        downloads.addAll(
          records.map((item) => Download.fromJson(item as Map<String, dynamic>)).toList(),
        );
      }

      // Process Radarr queue
      if (radarrQueue.containsKey('records')) {
        final records = radarrQueue['records'] as List;
        downloads.addAll(
          records.map((item) => Download.fromJson(item as Map<String, dynamic>)).toList(),
        );
      }

      // Cache the results
      await cacheBox.put(StorageConstants.queueListKey, downloads);

      return downloads;
    } on ServerException {
      rethrow;
    } on NetworkException {
      rethrow;
    } catch (e) {
      throw ServerException('Failed to get queue: ${e.toString()}');
    }
  }

  @override
  Future<List<Download>> getHistory() async {
    try {
      // Fetch history from both services
      final results = await Future.wait([
        remoteDataSource.getSonarrHistory(),
        remoteDataSource.getRadarrHistory(),
      ]);

      final sonarrHistory = results[0] as Map<String, dynamic>;
      final radarrHistory = results[1] as Map<String, dynamic>;

      final history = <Download>[];

      // Process Sonarr history
      if (sonarrHistory.containsKey('records')) {
        final records = sonarrHistory['records'] as List;
        history.addAll(
          records.map((item) => Download.fromJson(item as Map<String, dynamic>)).toList(),
        );
      }

      // Process Radarr history
      if (radarrHistory.containsKey('records')) {
        final records = radarrHistory['records'] as List;
        history.addAll(
          records.map((item) => Download.fromJson(item as Map<String, dynamic>)).toList(),
        );
      }

      return history;
    } on ServerException {
      rethrow;
    } on NetworkException {
      rethrow;
    } catch (e) {
      throw ServerException('Failed to get history: ${e.toString()}');
    }
  }

  @override
  Future<void> pauseDownload(String id, String serviceType) async {
    try {
      await remoteDataSource.pauseDownload(id, serviceType);
    } on ServerException {
      rethrow;
    } on NetworkException {
      rethrow;
    } catch (e) {
      throw ServerException('Failed to pause download: ${e.toString()}');
    }
  }

  @override
  Future<void> resumeDownload(String id, String serviceType) async {
    try {
      await remoteDataSource.resumeDownload(id, serviceType);
    } on ServerException {
      rethrow;
    } on NetworkException {
      rethrow;
    } catch (e) {
      throw ServerException('Failed to resume download: ${e.toString()}');
    }
  }

  @override
  Future<void> removeDownload(String id, String serviceType, {bool blacklist = false}) async {
    try {
      await remoteDataSource.removeDownload(id, serviceType, blacklist: blacklist);
    } on ServerException {
      rethrow;
    } on NetworkException {
      rethrow;
    } catch (e) {
      throw ServerException('Failed to remove download: ${e.toString()}');
    }
  }

  @override
  Future<List<Download>> getFailedDownloads() async {
    try {
      final queue = await getQueue();
      return queue.where((d) => d.status == DownloadStatus.failed).toList();
    } catch (e) {
      throw ServerException('Failed to get failed downloads: ${e.toString()}');
    }
  }

  @override
  Future<List<Download>> getCompletedDownloads() async {
    try {
      final history = await getHistory();
      return history.where((d) => d.status == DownloadStatus.completed).toList();
    } catch (e) {
      throw ServerException('Failed to get completed downloads: ${e.toString()}');
    }
  }

  @override
  Future<List<Download>> getCachedQueue() async {
    try {
      final cached = cacheBox.get(StorageConstants.queueListKey);
      if (cached != null && cached is List) {
        return cached.map((item) => Download.fromJson(item as Map<String, dynamic>)).toList();
      }
      return [];
    } catch (e) {
      throw CacheException('Failed to get cached queue: ${e.toString()}');
    }
  }
}
