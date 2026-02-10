import 'package:dio/dio.dart';

import '../../../models/tv/episode/episode_resource.dart';
import '../../../models/tv/series/series_resource.dart';
import '../../constants/api_constants.dart';
import 'base_api_service.dart';

/// API service for Sonarr (TV series management)
///
/// Provides methods for interacting with Sonarr's REST API including:
/// - Series management (CRUD operations)
/// - Episode retrieval and monitoring
/// - Queue and command operations
/// - System status and lookups
class SonarrApiService extends BaseApiService {
  SonarrApiService({
    required super.baseUrl,
    required super.apiKey,
    super.apiBasePath = ApiConstants.sonarrBasePath,
    Duration? connectTimeout,
    Duration? receiveTimeout,
    Duration? sendTimeout,
  }) : super(
          connectTimeout: connectTimeout,
          receiveTimeout: receiveTimeout,
          sendTimeout: sendTimeout,
        );

  /// Get all series from Sonarr
  ///
  /// Returns a list of all series in the Sonarr library.
  /// The response includes series details, seasons, statistics, and images.
  Future<List<SeriesResource>> getSeries() async {
    final response = await get(ApiConstants.sonarrEndpoint);
    return parseList(response, SeriesResource.fromJson);
  }

  /// Get series by ID
  ///
  /// Returns detailed information about a specific series including:
  /// - Series metadata and overview
  /// - Season information
  /// - Statistics (file counts, size on disk)
  /// - Images and posters
  Future<SeriesResource> getSeriesById(int id) async {
    final response = await get('$ApiConstants.sonarrEndpoint/$id');
    return parseItem(response, SeriesResource.fromJson);
  }

  /// Get episodes for a series
  ///
  /// Parameters:
  /// - [seriesId]: The ID of the series to get episodes for
  /// - [seasonNumber]: Optional season number to filter episodes
  ///
  /// Returns a list of episodes for the specified series.
  /// If [seasonNumber] is provided, only episodes from that season are returned.
  Future<List<EpisodeResource>> getEpisodes(
    int seriesId, {
    int? seasonNumber,
  }) async {
    final queryParams = <String, dynamic>{
      'seriesId': seriesId,
    };

    if (seasonNumber != null) {
      queryParams['seasonNumber'] = seasonNumber;
    }

    final response = await get(
      ApiConstants.sonarrEpisodeEndpoint,
      queryParameters: queryParams,
    );

    return parseList(response, EpisodeResource.fromJson);
  }

  /// Get episode by ID
  ///
  /// Returns detailed information about a specific episode including:
  /// - Episode metadata (title, overview, air date)
  /// - File information if available
  /// - Monitoring status
  Future<EpisodeResource> getEpisodeById(int id) async {
    final response = await get('$ApiConstants.sonarrEpisodeEndpoint/$id');
    return parseItem(response, EpisodeResource.fromJson);
  }

  /// Get current download queue
  ///
  /// Returns information about items currently in the queue including:
  /// - Download progress
  /// - Estimated completion time
  /// - Quality information
  /// - Status messages
  Future<Response> getQueue() async {
    return await get(ApiConstants.sonarrQueueEndpoint);
  }

  /// Get system status
  ///
  /// Returns system information including:
  /// - App version
  /// - Database status
  /// - Migration status
  /// - Runtime information
  Future<Response> getSystemStatus() async {
    return await get('/system/status');
  }

  /// Search for series to add
  ///
  /// Parameters:
  /// - [term]: The search term (can be series name or TVDb ID)
  ///
  /// Returns a list of series that match the search term.
  /// This searches external databases (TVDb) for series information.
  Future<List<SeriesResource>> searchSeries(String term) async {
    final response = await get(
      '$ApiConstants.sonarrEndpoint/lookup',
      queryParameters: {'term': term},
    );

    return parseList(response, SeriesResource.fromJson);
  }

  /// Add a new series to Sonarr
  ///
  /// Parameters:
  /// - [series]: The series resource to add (typically from search results)
  /// - [qualityProfileId]: The quality profile ID to use
  /// - [rootFolderPath]: The root folder path where the series should be stored
  /// - [monitored]: Whether to monitor the series (default: true)
  /// - [seasons]: Optional season folders to monitor
  ///
  /// Returns the created series with assigned ID.
  Future<SeriesResource> addSeries({
    required SeriesResource series,
    required int qualityProfileId,
    required String rootFolderPath,
    bool monitored = true,
    Map<String, bool>? seasons,
  }) async {
    final data = series.toJson();
    data['qualityProfileId'] = qualityProfileId;
    data['rootFolderPath'] = rootFolderPath;
    data['monitored'] = monitored;
    data['addOptions'] = {
      'monitor': monitored,
      if (seasons != null) 'seasons': seasons,
    };

    final response = await post(
      ApiConstants.sonarrEndpoint,
      data: data,
    );

    return parseItem(response, SeriesResource.fromJson);
  }

  /// Update an existing series
  ///
  /// Parameters:
  /// - [id]: The ID of the series to update
  /// - [data]: The series data to update (partial update supported)
  ///
  /// Returns the updated series.
  Future<SeriesResource> updateSeries(
    int id,
    Map<String, dynamic> data,
  ) async {
    final response = await put(
      '$ApiConstants.sonarrEndpoint/$id',
      data: data,
    );

    return parseItem(response, SeriesResource.fromJson);
  }

  /// Delete a series from Sonarr
  ///
  /// Parameters:
  /// - [id]: The ID of the series to delete
  /// - [deleteFiles]: Whether to delete the series files from disk (default: false)
  ///
  /// Returns the response from the delete operation.
  Future<Response> deleteSeries(
    int id, {
    bool deleteFiles = false,
  }) async {
    return await delete(
      '$ApiConstants.sonarrEndpoint/$id',
      queryParameters: {'deleteFiles': deleteFiles},
    );
  }

  /// Trigger a rescan of a series
  ///
  /// Parameters:
  /// - [id]: The ID of the series to rescan
  ///
  /// Returns the command response with tracking information.
  Future<Response> rescanSeries(int id) async {
    return await post(
      ApiConstants.sonarrCommandEndpoint,
      data: {
        'name': 'RescanSeries',
        'seriesId': id,
      },
    );
  }

  /// Trigger a search for a specific episode
  ///
  /// Parameters:
  /// - [episodeId]: The ID of the episode to search for
  ///
  /// Returns the command response with tracking information.
  Future<Response> searchEpisode(int episodeId) async {
    return await post(
      ApiConstants.sonarrCommandEndpoint,
      data: {
        'name': 'EpisodeSearch',
        'episodeIds': [episodeId],
      },
    );
  }

  /// Trigger a search for all episodes in a series
  ///
  /// Parameters:
  /// - [seriesId]: The ID of the series to search for
  ///
  /// Returns the command response with tracking information.
  Future<Response> searchSeriesEpisodes(int seriesId) async {
    return await post(
      ApiConstants.sonarrCommandEndpoint,
      data: {
        'name': 'SeriesSearch',
        'seriesId': seriesId,
      },
    );
  }

  /// Get history for operations
  ///
  /// Parameters:
  /// - [seriesId]: Optional series ID to filter history
  /// - [page]: Page number for pagination (default: 1)
  /// - [pageSize]: Number of items per page (default: 20)
  ///
  /// Returns historical operations (grabs, imports, etc.).
  Future<Response> getHistory({
    int? seriesId,
    int page = 1,
    int pageSize = 20,
  }) async {
    final queryParams = <String, dynamic>{
      'page': page,
      'pageSize': pageSize,
    };

    if (seriesId != null) {
      queryParams['seriesId'] = seriesId;
    }

    return await get(
      '/history',
      queryParameters: queryParams,
    );
  }

  /// Get quality profiles
  ///
  /// Returns available quality profiles configured in Sonarr.
  Future<Response> getQualityProfiles() async {
    return await get('/qualityprofile');
  }

  /// Get root folders
  ///
  /// Returns available root folders where series can be stored.
  Future<Response> getRootFolders() async {
    return await get('/rootfolder');
  }

  /// Get language profiles
  ///
  /// Returns available language profiles configured in Sonarr.
  Future<Response> getLanguageProfiles() async {
    return await get('/languageprofile');
  }

  /// Get tags
  ///
  /// Returns all tags configured in Sonarr.
  Future<Response> getTags() async {
    return await get('/tag');
  }
}
