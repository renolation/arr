import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:go_router/go_router.dart';
import 'package:arr/models/hive/series_hive.dart';
import 'package:arr/core/database/hive_database.dart';
import 'package:hive_flutter/hive_flutter.dart';

class SonarrPage extends ConsumerWidget {
  const SonarrPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('TV Shows'),
      ),
      body: ValueListenableBuilder(
        valueListenable: Hive.box<SeriesHive>(HiveDatabase.sonarrCacheBox).listenable(),
        builder: (context, Box<SeriesHive> box, _) {
          final series = box.values.toList();

          if (series.isEmpty) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.tv_outlined, size: 64, color: Colors.grey),
                  SizedBox(height: 16),
                  Text('No TV shows found', style: TextStyle(fontSize: 18)),
                  SizedBox(height: 8),
                  Text('Add a Sonarr service in Settings'),
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
            itemCount: series.length,
            itemBuilder: (context, index) {
              final item = series[index];
              return GestureDetector(
                onTap: () => context.go('/sonarr/series/${item.id}', extra: item),
                child: Card(
                  clipBehavior: Clip.antiAlias,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: item.posterUrl != null && item.posterUrl!.isNotEmpty
                            ? CachedNetworkImage(
                                imageUrl: item.posterUrl!,
                                width: double.infinity,
                                fit: BoxFit.cover,
                                placeholder: (context, url) => Container(
                                  color: Colors.grey[300],
                                  child: const Center(child: CircularProgressIndicator()),
                                ),
                                errorWidget: (context, url, error) => Container(
                                  color: Colors.grey[300],
                                  child: const Icon(Icons.tv, size: 48),
                                ),
                              )
                            : Container(
                                color: Colors.grey[300],
                                child: const Icon(Icons.tv, size: 48),
                              ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          item.title ?? 'Unknown',
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
