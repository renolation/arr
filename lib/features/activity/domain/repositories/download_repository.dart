import '../../../../core/errors/exceptions.dart';
import '../entities/download.dart';

/// Repository interface for download operations
abstract class DownloadRepository {
  /// Get current download queue
  Future<List<Download>> getQueue();

  /// Get download history
  Future<List<Download>> getHistory();

  /// Get cached queue
  Future<List<Download>> getCachedQueue();

  /// Pause a download
  Future<void> pauseDownload(String id, String service);

  /// Resume a download
  Future<void> resumeDownload(String id, String service);

  /// Remove a download
  Future<void> removeDownload(String id, String service, {bool blacklist});

  /// Get failed downloads
  Future<List<Download>> getFailedDownloads();

  /// Get completed downloads
  Future<List<Download>> getCompletedDownloads();
}
