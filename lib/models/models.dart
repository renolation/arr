// ========================================
// Models Barrel File
// Exports all models for convenient importing
// ========================================

// Common models (shared between Sonarr & Radarr)
export 'common/auto_tagging.dart';
export 'common/backup.dart';
export 'common/blocklist.dart';
export 'common/command.dart';
export 'common/custom_filter.dart';
export 'common/custom_format.dart';
export 'common/download_client.dart';
export 'common/field.dart';
export 'common/health.dart';
export 'common/history.dart';
export 'common/import_list.dart';
export 'common/language.dart';
export 'common/media_cover.dart';
export 'common/media_info.dart';

// Common quality models
export 'common/quality/quality.dart';
export 'common/quality/quality_model.dart';
export 'common/quality/quality_revision.dart';

// TV/Sonarr-specific models
export 'tv/ratings.dart';
export 'tv/season.dart';
export 'tv/season_statistics.dart';
export 'tv/naming_config.dart';
export 'tv/language_profile.dart';

// TV Series models
export 'tv/series/series_resource.dart';
export 'tv/series/alternate_title.dart';
export 'tv/series/series_statistics.dart';

// TV Episode models
export 'tv/episode/episode_resource.dart';
export 'tv/episode/episode_file_resource.dart';

// Movie/Radarr-specific models
export 'movie/ratings.dart';
export 'movie/alternative_title.dart';
export 'movie/credit.dart';
export 'movie/extra_file.dart';

// Movie models
export 'movie/movie/movie_resource.dart';
export 'movie/movie/movie_file_resource.dart';
export 'movie/movie/movie_statistics.dart';

// Collection models
export 'movie/collection/collection_resource.dart';
export 'movie/collection/collection_movie_resource.dart';
