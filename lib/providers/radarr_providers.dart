import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:arr/models/hive/movie_hive.dart';
import 'package:arr/models/part_4.dart';
import 'package:arr/core/database/hive_database.dart';
import 'package:arr/providers/service_providers.dart';
import 'package:arr/data/api/radarr_api.dart';

final radarrCacheBoxProvider = Provider<Box<MovieHive>>((ref) {
  return Hive.box<MovieHive>(HiveDatabase.radarrCacheBox);
});

final moviesListProvider = FutureProvider<List<MovieHive>>((ref) async {
  final api = ref.watch(radarrApiProvider);
  final service = ref.watch(currentRadarrServiceProvider);
  final cacheBox = ref.watch(radarrCacheBoxProvider);
  
  if (api == null || service == null) {
    // Return cached data if no API is available
    return cacheBox.values.where((movie) => movie.serviceId == service?.id).toList()
      ..sort((a, b) => (a.sortTitle ?? a.title ?? '').compareTo(b.sortTitle ?? b.title ?? ''));
  }
  
  try {
    // Try to fetch from API
    final moviesList = await api.getMovies();
    
    // Update cache
    final cachedMovies = <MovieHive>[];
    for (final movie in moviesList) {
      final hiveModel = MovieHive.fromMovieResource(movie, service.id);
      await cacheBox.put('${service.id}_${movie.id}', hiveModel);
      cachedMovies.add(hiveModel);
    }
    
    // Update last sync time
    service.lastSync = DateTime.now();
    await service.save();
    
    return cachedMovies..sort((a, b) => (a.sortTitle ?? a.title ?? '').compareTo(b.sortTitle ?? b.title ?? ''));
  } catch (e) {
    // If API call fails, return cached data
    final cachedData = cacheBox.values.where((movie) => movie.serviceId == service.id).toList()
      ..sort((a, b) => (a.sortTitle ?? a.title ?? '').compareTo(b.sortTitle ?? b.title ?? ''));
    
    if (cachedData.isEmpty) {
      throw Exception('No cached data available. Error: $e');
    }
    
    return cachedData;
  }
});

final movieDetailProvider = FutureProvider.family<MovieHive?, int>((ref, movieId) async {
  final api = ref.watch(radarrApiProvider);
  final service = ref.watch(currentRadarrServiceProvider);
  final cacheBox = ref.watch(radarrCacheBoxProvider);
  
  if (service == null) return null;
  
  final cacheKey = '${service.id}_$movieId';
  
  if (api == null) {
    // Return cached data if no API is available
    return cacheBox.get(cacheKey);
  }
  
  try {
    // Try to fetch from API
    final movie = await api.getMovieById(movieId);
    final hiveModel = MovieHive.fromMovieResource(movie, service.id);
    
    // Update cache
    await cacheBox.put(cacheKey, hiveModel);
    
    return hiveModel;
  } catch (e) {
    // If API call fails, return cached data
    final cachedData = cacheBox.get(cacheKey);
    if (cachedData == null) {
      throw Exception('No cached data available for movie $movieId. Error: $e');
    }
    return cachedData;
  }
});

final movieSearchProvider = StateProvider<String>((ref) => '');

final filteredMoviesProvider = Provider<List<MovieHive>>((ref) {
  final moviesList = ref.watch(moviesListProvider).valueOrNull ?? [];
  final searchQuery = ref.watch(movieSearchProvider).toLowerCase();
  
  if (searchQuery.isEmpty) {
    return moviesList;
  }
  
  return moviesList.where((movie) {
    final title = movie.title?.toLowerCase() ?? '';
    final overview = movie.overview?.toLowerCase() ?? '';
    final studio = movie.studio?.toLowerCase() ?? '';
    return title.contains(searchQuery) || 
           overview.contains(searchQuery) || 
           studio.contains(searchQuery);
  }).toList();
});

final movieStatsProvider = Provider<MovieStats>((ref) {
  final moviesList = ref.watch(moviesListProvider).valueOrNull ?? [];
  
  return MovieStats(
    total: moviesList.length,
    monitored: moviesList.where((m) => m.monitored == true).length,
    unmonitored: moviesList.where((m) => m.monitored == false).length,
    available: moviesList.where((m) => m.isAvailable == true).length,
    missing: moviesList.where((m) => m.hasFile == false && m.monitored == true).length,
    totalSize: moviesList.fold(0, (sum, m) => sum + (m.sizeOnDisk ?? 0)),
  );
});

class MovieStats {
  final int total;
  final int monitored;
  final int unmonitored;
  final int available;
  final int missing;
  final int totalSize;
  
  MovieStats({
    required this.total,
    required this.monitored,
    required this.unmonitored,
    required this.available,
    required this.missing,
    required this.totalSize,
  });
  
  String get formattedSize {
    if (totalSize < 1024) return '$totalSize B';
    if (totalSize < 1024 * 1024) return '${(totalSize / 1024).toStringAsFixed(2)} KB';
    if (totalSize < 1024 * 1024 * 1024) return '${(totalSize / (1024 * 1024)).toStringAsFixed(2)} MB';
    return '${(totalSize / (1024 * 1024 * 1024)).toStringAsFixed(2)} GB';
  }
}