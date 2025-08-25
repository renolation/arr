import 'package:hive_flutter/hive_flutter.dart';
import 'package:arr/models/hive/service_config.dart';
import 'package:arr/models/hive/movie_hive.dart';
import 'package:arr/models/hive/series_hive.dart';
import 'package:arr/models/hive/episode_hive.dart';

class HiveDatabase {
  static const String servicesBox = 'servicesBox';
  static const String sonarrCacheBox = 'sonarrCacheBox';
  static const String radarrCacheBox = 'radarrCacheBox';
  static const String episodeCacheBox = 'episodeCacheBox';
  static const String settingsBox = 'settingsBox';

  static Future<void> init() async {
    await Hive.initFlutter();
    
    // Register adapters
    Hive.registerAdapter(ServiceConfigAdapter());
    Hive.registerAdapter(MovieHiveAdapter());
    Hive.registerAdapter(SeriesHiveAdapter());
    Hive.registerAdapter(EpisodeHiveAdapter());
    Hive.registerAdapter(ImageHiveAdapter());
    Hive.registerAdapter(RatingsHiveAdapter());
    Hive.registerAdapter(MediaTypeAdapter());
    Hive.registerAdapter(ServiceTypeAdapter());

    // Open boxes
    await Hive.openBox<ServiceConfig>(servicesBox);
    await Hive.openBox<MovieHive>(radarrCacheBox);
    await Hive.openBox<SeriesHive>(sonarrCacheBox);
    await Hive.openBox<EpisodeHive>(episodeCacheBox);
    await Hive.openBox(settingsBox);
  }
  
  static Future<void> clearCache() async {
    final sonarrBox = Hive.box<SeriesHive>(sonarrCacheBox);
    final radarrBox = Hive.box<MovieHive>(radarrCacheBox);
    final episodeBox = Hive.box<EpisodeHive>(episodeCacheBox);
    await sonarrBox.clear();
    await radarrBox.clear();
    await episodeBox.clear();
  }
}