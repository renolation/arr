import '../../../../core/errors/exceptions.dart';
import '../entities/media_item.dart';

/// Repository interface for media operations
abstract class MediaRepository {
  /// Series Operations
  Future<List<MediaItem>> getAllSeries();
  Future<MediaItem> getSeriesById(int id);

  /// Movie Operations
  Future<List<MediaItem>> getAllMovies();
  Future<MediaItem> getMovieById(int id);

  /// Cache Operations
  Future<List<MediaItem>> getCachedSeries();
  Future<List<MediaItem>> getCachedMovies();

  /// Search Operations
  Future<List<MediaItem>> searchMedia(String query);
}
