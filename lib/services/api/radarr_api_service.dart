import 'package:dio/dio.dart';
import '../../models/movie/movie/movie_resource.dart';
import '../../core/constants/api_constants.dart';
import 'base_api_service.dart';

/// API service for Radarr (movie management)
///
/// Provides methods for interacting with Radarr's REST API including:
/// - Movie management (CRUD operations)
/// - Queue and command operations
/// - System status and lookups
/// - Release searching and history
class RadarrApiService extends BaseApiService {
  RadarrApiService({
    required super.baseUrl,
    required super.apiKey,
    super.apiBasePath = ApiConstants.radarrBasePath,
    Duration? connectTimeout,
    Duration? receiveTimeout,
    Duration? sendTimeout,
  }) : super(
          connectTimeout: connectTimeout,
          receiveTimeout: receiveTimeout,
          sendTimeout: sendTimeout,
        );

  /// Get all movies from Radarr
  ///
  /// Returns a list of all movies in the Radarr library.
  /// The response includes movie details, statistics, and images.
  Future<List<MovieResource>> getMovies() async {
    final response = await get(ApiConstants.radarrEndpoint);
    return parseList(response, MovieResource.fromJson);
  }

  /// Get movie by ID
  ///
  /// Returns detailed information about a specific movie including:
  /// - Movie metadata and overview
  /// - Statistics (file counts, size on disk)
  /// - Images and posters
  /// - Collection information
  Future<MovieResource> getMovieById(int id) async {
    final response = await get('$ApiConstants.radarrEndpoint/$id');
    return parseItem(response, MovieResource.fromJson);
  }

  /// Get current download queue
  ///
  /// Returns information about items currently in the queue including:
  /// - Download progress
  /// - Estimated completion time
  /// - Quality information
  /// - Status messages
  Future<Response> getQueue() async {
    return await get(ApiConstants.radarrQueueEndpoint);
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

  /// Search for movies to add
  ///
  /// Parameters:
  /// - [term]: The search term (can be movie name or IMDb/TMDb ID)
  ///
  /// Returns a list of movies that match the search term.
  /// This searches external databases (TMDb) for movie information.
  Future<List<MovieResource>> searchMovies(String term) async {
    final response = await get(
      '$ApiConstants.radarrEndpoint/lookup',
      queryParameters: {'term': term},
    );

    return parseList(response, MovieResource.fromJson);
  }

  /// Add a new movie to Radarr
  ///
  /// Parameters:
  /// - [movie]: The movie resource to add (typically from search results)
  /// - [qualityProfileId]: The quality profile ID to use
  /// - [rootFolderPath]: The root folder path where the movie should be stored
  /// - [monitored]: Whether to monitor the movie (default: true)
  /// - [minimumAvailability]: When the movie should be available (announced, released, etc.)
  ///
  /// Returns the created movie with assigned ID.
  Future<MovieResource> addMovie({
    required MovieResource movie,
    required int qualityProfileId,
    required String rootFolderPath,
    bool monitored = true,
    String minimumAvailability = 'released',
  }) async {
    final data = movie.toJson();
    data['qualityProfileId'] = qualityProfileId;
    data['rootFolderPath'] = rootFolderPath;
    data['monitored'] = monitored;
    data['minimumAvailability'] = minimumAvailability;
    data['addOptions'] = {
      'searchForMovie': monitored,
    };

    final response = await post(
      ApiConstants.radarrEndpoint,
      data: data,
    );

    return parseItem(response, MovieResource.fromJson);
  }

  /// Update an existing movie
  ///
  /// Parameters:
  /// - [id]: The ID of the movie to update
  /// - [data]: The movie data to update (partial update supported)
  ///
  /// Returns the updated movie.
  Future<MovieResource> updateMovie(
    int id,
    Map<String, dynamic> data,
  ) async {
    final response = await put(
      '$ApiConstants.radarrEndpoint/$id',
      data: data,
    );

    return parseItem(response, MovieResource.fromJson);
  }

  /// Delete a movie from Radarr
  ///
  /// Parameters:
  /// - [id]: The ID of the movie to delete
  /// - [deleteFiles]: Whether to delete the movie files from disk (default: false)
  ///
  /// Returns the response from the delete operation.
  Future<Response> deleteMovie(
    int id, {
    bool deleteFiles = false,
  }) async {
    return await delete(
      '$ApiConstants.radarrEndpoint/$id',
      queryParameters: {'deleteFiles': deleteFiles},
    );
  }

  /// Trigger a search for a movie
  ///
  /// Parameters:
  /// - [movieId]: The ID of the movie to search for
  ///
  /// Returns the command response with tracking information.
  Future<Response> searchMovie(int movieId) async {
    return await post(
      ApiConstants.radarrCommandEndpoint,
      data: {
        'name': 'MoviesSearch',
        'movieIds': [movieId],
      },
    );
  }

  /// Search for releases for a movie
  ///
  /// Parameters:
  /// - [movieId]: The ID of the movie to search releases for
  ///
  /// Returns available releases from configured indexers.
  Future<Response> searchReleases(int movieId) async {
    return await post(
      ApiConstants.radarrReleaseEndpoint,
      queryParameters: {'movieId': movieId},
    );
  }

  /// Get movie history
  ///
  /// Parameters:
  /// - [movieId]: Optional movie ID to filter history
  /// - [page]: Page number for pagination (default: 1)
  /// - [pageSize]: Number of items per page (default: 20)
  ///
  /// Returns historical operations (grabs, imports, etc.).
  Future<Response> getHistory({
    int? movieId,
    int page = 1,
    int pageSize = 20,
  }) async {
    final queryParams = <String, dynamic>{
      'page': page,
      'pageSize': pageSize,
    };

    if (movieId != null) {
      queryParams['movieId'] = movieId;
    }

    return await get(
      '/history',
      queryParameters: queryParams,
    );
  }

  /// Get exclusions
  ///
  /// Returns list of excluded movies.
  Future<Response> getExclusions() async {
    return await get('/exclusion');
  }

  /// Add an exclusion
  ///
  /// Parameters:
  /// - [tmdbId]: The TMDb ID to exclude
  /// - [title]: The title of the movie to exclude
  ///
  /// Returns the created exclusion.
  Future<Response> addExclusion({
    required int tmdbId,
    required String title,
  }) async {
    return await post(
      '/exclusion',
      data: {
        'tmdbId': tmdbId,
        'title': title,
      },
    );
  }

  /// Delete an exclusion
  ///
  /// Parameters:
  /// - [id]: The ID of the exclusion to delete
  ///
  /// Returns the response from the delete operation.
  Future<Response> deleteExclusion(int id) async {
    return await delete('/exclusion/$id');
  }

  /// Get quality profiles
  ///
  /// Returns available quality profiles configured in Radarr.
  Future<Response> getQualityProfiles() async {
    return await get('/qualityprofile');
  }

  /// Get root folders
  ///
  /// Returns available root folders where movies can be stored.
  Future<Response> getRootFolders() async {
    return await get('/rootfolder');
  }

  /// Get tags
  ///
  /// Returns all tags configured in Radarr.
  Future<Response> getTags() async {
    return await get('/tag');
  }

  /// Get import lists
  ///
  /// Returns configured import lists for automatic movie discovery.
  Future<Response> getImportLists() async {
    return await get('/importlist');
  }

  /// Get download client status
  ///
  /// Returns status of configured download clients.
  Future<Response> getDownloadClientStatus() async {
    return await get('/downloadclient/status');
  }
}
