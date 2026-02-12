import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:go_router/go_router.dart';
import 'package:arr/models/hive/movie_hive.dart';
import 'package:arr/core/database/hive_database.dart';
import 'package:hive_flutter/hive_flutter.dart';

class RadarrPage extends ConsumerWidget {
  const RadarrPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Movies'),
      ),
      body: ValueListenableBuilder(
        valueListenable: Hive.box<MovieHive>(HiveDatabase.radarrCacheBox).listenable(),
        builder: (context, Box<MovieHive> box, _) {
          final movies = box.values.toList();

          if (movies.isEmpty) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.movie_outlined, size: 64, color: Colors.grey),
                  SizedBox(height: 16),
                  Text('No movies found', style: TextStyle(fontSize: 18)),
                  SizedBox(height: 8),
                  Text('Add a Radarr service in Settings'),
                ],
              ),
            );
          }

          return GridView.builder(
            padding: const EdgeInsets.all(8),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.7,
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
            ),
            itemCount: movies.length,
            itemBuilder: (context, index) {
              final movie = movies[index];
              return GestureDetector(
                onTap: () => context.go('/radarr/movie/${movie.id}', extra: movie),
                child: Card(
                  clipBehavior: Clip.antiAlias,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: movie.posterUrl != null && movie.posterUrl!.isNotEmpty
                            ? CachedNetworkImage(
                                imageUrl: movie.posterUrl!,
                                width: double.infinity,
                                fit: BoxFit.cover,
                                fadeInDuration: Duration.zero,
                                fadeOutDuration: Duration.zero,
                                memCacheWidth: 300,
                                placeholder: (context, url) => Container(
                                  color: Colors.grey[300],
                                  child: const Center(child: CircularProgressIndicator()),
                                ),
                                errorWidget: (context, url, error) => Container(
                                  color: Colors.grey[300],
                                  child: const Icon(Icons.movie, size: 48),
                                ),
                              )
                            : Container(
                                color: Colors.grey[300],
                                child: const Icon(Icons.movie, size: 48),
                              ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          movie.title ?? 'Unknown',
                          style: const TextStyle(fontWeight: FontWeight.w600),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
