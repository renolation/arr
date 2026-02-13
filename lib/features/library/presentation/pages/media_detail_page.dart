import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../../main.dart';
import '../../domain/entities/media_item.dart';
import 'season_detail_page.dart';

/// Detail page for a media item (movie or series)
/// Uses data already available from MediaItem.metadata (no extra API calls).
class MediaDetailPage extends StatelessWidget {
  final MediaItem mediaItem;

  const MediaDetailPage({super.key, required this.mediaItem});

  Map<String, dynamic> get _meta => mediaItem.metadata ?? {};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(context),
            _buildActionButtons(context),
            _buildStatusCard(context),
            _buildOverview(context),
            _buildDetailsCard(context),
            if (mediaItem.type == MediaType.series) _buildSeasons(context),
            _buildFileInformation(context),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  // ── Header: Poster + Metadata ──

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 0, 24, 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          // Poster
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.35,
            child: AspectRatio(
              aspectRatio: 2 / 3,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: Theme.of(context).colorScheme.outline.withOpacity(0.3),
                  ),
                ),
                clipBehavior: Clip.antiAlias,
                child: mediaItem.hasPoster
                    ? CachedNetworkImage(
                        imageUrl: mediaItem.posterUrl!,
                        fit: BoxFit.cover,
                        fadeInDuration: Duration.zero,
                        fadeOutDuration: Duration.zero,
                        memCacheWidth: 400,
                        placeholder: (_, __) => Container(
                          color: Theme.of(context).colorScheme.surface,
                        ),
                        errorWidget: (_, __, ___) => _posterPlaceholder(context),
                      )
                    : _posterPlaceholder(context),
              ),
            ),
          ),
          const SizedBox(width: 20),
          // Metadata
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 4),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    mediaItem.title,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      letterSpacing: -0.5,
                      height: 1.1,
                    ),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  _buildMetaRow(context),
                  const SizedBox(height: 8),
                  // Quality badge
                  if (_qualityLabel != null)
                    Row(
                      children: [
                        const Icon(Icons.hd, size: 16, color: AppColors.primary),
                        const SizedBox(width: 6),
                        Text(
                          _qualityLabel!,
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: AppColors.primary,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ],
                    ),
                  if (_qualityLabel != null) const SizedBox(height: 4),
                  // Rating
                  if (mediaItem.rating != null)
                    Row(
                      children: [
                        const Icon(Icons.star, size: 16, color: Color(0xFFF59E0B)),
                        const SizedBox(width: 6),
                        Text(
                          '${mediaItem.rating!.toStringAsFixed(1)}/10',
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  // Network (series) or Studio (movie)
                  if (_networkOrStudio != null) ...[
                    const SizedBox(height: 6),
                    Text(
                      _networkOrStudio!,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMetaRow(BuildContext context) {
    final parts = <String>[];
    if (mediaItem.year != null) parts.add('${mediaItem.year}');
    if (_runtimeFormatted != null) parts.add(_runtimeFormatted!);
    final cert = _meta['certification'] as String?;
    if (cert != null && cert.isNotEmpty) parts.add(cert);

    if (parts.isEmpty) return const SizedBox.shrink();

    return Text(
      parts.join('  \u2022  '),
      style: TextStyle(
        fontSize: 13,
        fontWeight: FontWeight.w500,
        color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5),
      ),
    );
  }

  Widget _posterPlaceholder(BuildContext context) {
    return Container(
      color: Theme.of(context).colorScheme.surface,
      child: Center(
        child: Icon(
          mediaItem.type == MediaType.series ? Icons.tv : Icons.movie,
          size: 40,
          color: Theme.of(context).colorScheme.onSurface.withOpacity(0.2),
        ),
      ),
    );
  }

  // ── Action Buttons ──

  Widget _buildActionButtons(BuildContext context) {
    final isMonitored = _meta['monitored'] as bool? ?? mediaItem.monitored ?? false;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      child: Row(
        children: [
          Expanded(
            child: _ActionButton(
              icon: Icons.bookmark,
              label: isMonitored ? 'Monitored' : 'Unmonitored',
              filled: isMonitored,
              onTap: () {},
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _ActionButton(
              icon: Icons.search,
              label: 'Search',
              filled: false,
              onTap: () {},
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _ActionButton(
              icon: Icons.edit,
              label: 'Edit',
              filled: false,
              onTap: () {},
            ),
          ),
        ],
      ),
    );
  }

  // ── Status Card ──

  Widget _buildStatusCard(BuildContext context) {
    final hasFile = _meta['hasFile'] as bool? ?? false;
    final sizeOnDisk = _meta['sizeOnDisk'] as num? ?? 0;

    final stats = _meta['statistics'] as Map<String, dynamic>?;
    final seriesSize = stats?['sizeOnDisk'] as num? ?? 0;
    final displaySize = mediaItem.type == MediaType.series ? seriesSize : sizeOnDisk;
    final showSize = (mediaItem.type == MediaType.movie && hasFile && sizeOnDisk > 0) ||
        (mediaItem.type == MediaType.series && seriesSize > 0);

    final (statusText, statusColor) = switch (mediaItem.status) {
      MediaStatus.downloaded => ('Downloaded', AppColors.accentGreen),
      MediaStatus.downloading => ('Downloading', AppColors.primary),
      MediaStatus.missing => ('Missing', AppColors.accentRed),
      MediaStatus.continuing => ('Continuing', AppColors.accentGreen),
      MediaStatus.ended => ('Ended', AppColors.accentGreen),
      MediaStatus.deleted => ('Deleted', AppColors.accentRed),
    };

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: Theme.of(context).colorScheme.outline.withOpacity(0.3),
          ),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'CURRENT STATUS',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 1.5,
                      color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Container(
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: statusColor,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        statusText,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: statusColor,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            if (showSize) ...[
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    'SIZE',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 1.5,
                      color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _formatBytes(displaySize),
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 16),
              Container(
                padding: const EdgeInsets.only(left: 16),
                decoration: BoxDecoration(
                  border: Border(
                    left: BorderSide(
                      color: Theme.of(context).colorScheme.outline.withOpacity(0.3),
                    ),
                  ),
                ),
                child: Icon(
                  Icons.folder_open,
                  color: Theme.of(context).colorScheme.onSurface.withOpacity(0.3),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  // ── Overview + Genres ──

  Widget _buildOverview(BuildContext context) {
    final overview = _meta['overview'] as String? ?? mediaItem.overview;
    final rawGenres = _meta['genres'] as List?;
    final genres = rawGenres?.map((e) => e.toString()).toList() ?? [];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'OVERVIEW',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.5,
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5),
            ),
          ),
          const SizedBox(height: 12),
          if (overview != null && overview.isNotEmpty)
            Text(
              overview,
              style: TextStyle(
                fontSize: 15,
                height: 1.6,
                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.75),
              ),
            )
          else
            Text(
              'No overview available.',
              style: TextStyle(
                fontSize: 15,
                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.4),
              ),
            ),
          if (genres.isNotEmpty) ...[
            const SizedBox(height: 16),
            Text(
              genres.join(', '),
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5),
              ),
            ),
          ],
        ],
      ),
    );
  }

  // ── Details Card (2-column grid) ──

  Widget _buildDetailsCard(BuildContext context) {
    final isSeries = mediaItem.type == MediaType.series;
    final stats = _meta['statistics'] as Map<String, dynamic>?;
    final isMonitored = _meta['monitored'] as bool? ?? mediaItem.monitored ?? false;

    final rows = <(IconData, String, String)>[];

    if (isSeries) {
      // Seasons count
      final seasonCount = stats?['seasonCount'] as int? ??
          mediaItem.seasonCount ??
          (_meta['seasons'] as List?)?.where((s) => (s as Map)['seasonNumber'] != 0).length;
      if (seasonCount != null) {
        rows.add((Icons.video_library_outlined, 'Seasons', '$seasonCount'));
      }

      // Episodes: downloaded / total
      final totalEps = stats?['totalEpisodeCount'] as int?;
      final fileEps = stats?['episodeFileCount'] as int?;
      if (totalEps != null && fileEps != null) {
        rows.add((Icons.tv_outlined, 'Episodes', '$fileEps/$totalEps'));
      }

      // Status
      rows.add((Icons.flag_outlined, 'Status', _capitalize(_meta['status'] as String? ?? mediaItem.status.name)));

      // Series type
      final seriesType = _meta['seriesType'] as String?;
      if (seriesType != null) {
        rows.add((Icons.crop_landscape_outlined, 'Series', seriesType));
      }

      // Season Folders
      final seasonFolder = _meta['seasonFolder'] as bool?;
      if (seasonFolder != null) {
        rows.add((Icons.create_new_folder_outlined, 'Season Folders', seasonFolder ? 'Yes' : 'No'));
      }

      // Monitor
      rows.add((Icons.visibility_outlined, 'Monitor', isMonitored ? 'Yes' : 'No'));

      // Root Folder
      final rootFolderPath = _meta['rootFolderPath'] as String?;
      if (rootFolderPath != null) {
        rows.add((Icons.folder_outlined, 'Root Folder', rootFolderPath));
      }

      // Size on Disk
      final sizeOnDisk = stats?['sizeOnDisk'] as num? ?? 0;
      if (sizeOnDisk > 0) {
        rows.add((Icons.storage_outlined, 'Size on Disk', _formatBytes(sizeOnDisk)));
      }

      // Next Episode / Next Airing
      final nextAiring = _meta['nextAiring'] as String?;
      if (nextAiring != null) {
        final date = DateTime.tryParse(nextAiring);
        if (date != null) {
          rows.add((Icons.access_time_outlined, 'Next Episode', _formatDate(date)));
        }
      }

      // Storage Path
      final path = _meta['path'] as String?;
      if (path != null) {
        rows.add((Icons.folder_open_outlined, 'Storage Path', path));
      }

      // Network
      final network = _meta['network'] as String?;
      if (network != null && network.isNotEmpty) {
        rows.add((Icons.live_tv_outlined, 'Network', network));
      }
    } else {
      // Movie details

      // Status
      rows.add((Icons.flag_outlined, 'Status', _capitalize(_meta['status'] as String? ?? mediaItem.status.name)));

      // Monitor
      rows.add((Icons.visibility_outlined, 'Monitor', isMonitored ? 'Yes' : 'No'));

      // Studio
      final studio = _meta['studio'] as String?;
      if (studio != null && studio.isNotEmpty) {
        rows.add((Icons.movie_outlined, 'Studio', studio));
      }

      // Quality
      if (_qualityLabel != null) {
        rows.add((Icons.hd_outlined, 'Quality', _qualityLabel!));
      }

      // Root Folder
      final rootFolderPath = _meta['rootFolderPath'] as String?;
      if (rootFolderPath != null) {
        rows.add((Icons.folder_outlined, 'Root Folder', rootFolderPath));
      }

      // Size on Disk
      final sizeOnDisk = _meta['sizeOnDisk'] as num? ?? 0;
      if (sizeOnDisk > 0) {
        rows.add((Icons.storage_outlined, 'Size on Disk', _formatBytes(sizeOnDisk)));
      }

      // Physical Release
      final physicalRelease = _meta['physicalRelease'] as String?;
      if (physicalRelease != null) {
        final date = DateTime.tryParse(physicalRelease);
        if (date != null) {
          rows.add((Icons.calendar_today_outlined, 'Physical Release', _formatDate(date)));
        }
      }

      // Digital Release
      final digitalRelease = _meta['digitalRelease'] as String?;
      if (digitalRelease != null) {
        final date = DateTime.tryParse(digitalRelease);
        if (date != null) {
          rows.add((Icons.cloud_outlined, 'Digital Release', _formatDate(date)));
        }
      }

      // Storage Path
      final path = _meta['path'] as String?;
      if (path != null) {
        rows.add((Icons.folder_open_outlined, 'Storage Path', path));
      }
    }

    if (rows.isEmpty) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 0),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: Theme.of(context).colorScheme.outline.withOpacity(0.2),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Details',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 20),
            // 2-column grid
            ...List.generate((rows.length / 2).ceil(), (i) {
              final leftIdx = i * 2;
              final rightIdx = i * 2 + 1;
              return Padding(
                padding: EdgeInsets.only(bottom: i < (rows.length / 2).ceil() - 1 ? 20 : 0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(child: _detailItem(context, rows[leftIdx])),
                    if (rightIdx < rows.length)
                      Expanded(child: _detailItem(context, rows[rightIdx]))
                    else
                      const Expanded(child: SizedBox.shrink()),
                  ],
                ),
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget _detailItem(BuildContext context, (IconData, String, String) item) {
    final (icon, label, value) = item;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          icon,
          size: 20,
          color: Theme.of(context).colorScheme.onSurface.withOpacity(0.4),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: TextStyle(
                  fontSize: 13,
                  color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5),
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ],
    );
  }

  // ── Seasons (series only) ──

  Widget _buildSeasons(BuildContext context) {
    final seasons = _meta['seasons'] as List?;
    if (seasons == null || seasons.isEmpty) return const SizedBox.shrink();

    // Filter out specials (season 0) by default, sort ascending
    final sortedSeasons = List<Map<String, dynamic>>.from(
      seasons.map((s) => s as Map<String, dynamic>),
    )..sort((a, b) => (a['seasonNumber'] as int? ?? 0).compareTo(b['seasonNumber'] as int? ?? 0));

    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Seasons',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 12),
          ...sortedSeasons.map((s) {
            final seasonNum = s['seasonNumber'] as int? ?? 0;
            final stats = s['statistics'] as Map<String, dynamic>?;
            final totalEps = stats?['totalEpisodeCount'] as int? ?? 0;
            final fileEps = stats?['episodeFileCount'] as int? ?? 0;
            final seasonLabel = seasonNum == 0 ? 'Specials' : 'Season $seasonNum';

            return GestureDetector(
              onTap: () {
                if (mediaItem.serviceKey != null) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => SeasonDetailPage(
                        seriesId: mediaItem.id,
                        seasonNumber: seasonNum,
                        seriesTitle: mediaItem.title,
                        serviceKey: mediaItem.serviceKey!,
                      ),
                    ),
                  );
                }
              },
              child: Container(
                margin: const EdgeInsets.only(bottom: 8),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: Theme.of(context).colorScheme.outline.withOpacity(0.2),
                  ),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        seasonLabel,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    if (totalEps > 0) ...[
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(
                            color: fileEps == totalEps
                                ? AppColors.accentGreen
                                : AppColors.primary,
                            width: 1.5,
                          ),
                        ),
                        child: Text(
                          '$fileEps/$totalEps',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: fileEps == totalEps
                                ? AppColors.accentGreen
                                : AppColors.primary,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                    ],
                    Icon(
                      Icons.chevron_right,
                      size: 20,
                      color: Theme.of(context).colorScheme.onSurface.withOpacity(0.3),
                    ),
                  ],
                ),
              ),
            );
          }),
        ],
      ),
    );
  }

  // ── File Information (movies only) ──

  Widget _buildFileInformation(BuildContext context) {
    if (mediaItem.type != MediaType.movie) return const SizedBox.shrink();
    final movieFile = _meta['movieFile'] as Map<String, dynamic>?;
    if (movieFile == null) return const SizedBox.shrink();
    final mediaInfo = movieFile['mediaInfo'] as Map<String, dynamic>?;
    if (mediaInfo == null) return const SizedBox.shrink();

    final audioCodec = mediaInfo['audioCodec'] as String?;
    final audioChannels = mediaInfo['audioChannels'] as num?;
    final videoCodec = mediaInfo['videoCodec'] as String?;
    final width = mediaInfo['width'] as int?;
    final height = mediaInfo['height'] as int?;
    final videoBitrate = mediaInfo['videoBitrate'] as int?;

    final rows = <(String, String)>[];
    if (audioCodec != null) {
      final channelStr = audioChannels != null ? ' $audioChannels' : '';
      rows.add(('Audio Codec', '$audioCodec$channelStr'));
    }
    if (videoCodec != null) rows.add(('Video Codec', videoCodec));
    if (width != null && height != null) rows.add(('Resolution', '${width}x$height'));
    if (videoBitrate != null && videoBitrate > 0) {
      rows.add(('Bitrate', '${(videoBitrate / 1000000).toStringAsFixed(1)} Mbps'));
    }

    if (rows.isEmpty) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Divider(color: Theme.of(context).colorScheme.outline.withOpacity(0.2)),
          const SizedBox(height: 16),
          Text(
            'FILE INFORMATION',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.5,
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5),
            ),
          ),
          const SizedBox(height: 16),
          ...rows.map((row) => Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      row.$1,
                      style: TextStyle(
                        fontSize: 14,
                        color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5),
                      ),
                    ),
                    Text(
                      row.$2,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              )),
        ],
      ),
    );
  }

  // ── Helpers ──

  String? get _runtimeFormatted {
    final runtime = _meta['runtime'] as int?;
    if (runtime == null || runtime <= 0) return null;
    final h = runtime ~/ 60;
    final m = runtime % 60;
    if (h > 0 && m > 0) return '${h}h ${m}m';
    if (h > 0) return '${h}h';
    return '${m}m';
  }

  String? get _qualityLabel {
    final movieFile = _meta['movieFile'] as Map<String, dynamic>?;
    if (movieFile != null) {
      final quality = movieFile['quality'] as Map<String, dynamic>?;
      final qualityDetail = quality?['quality'] as Map<String, dynamic>?;
      final name = qualityDetail?['name'] as String?;
      if (name != null) return name.toUpperCase();
    }
    return null;
  }

  String? get _networkOrStudio {
    if (mediaItem.type == MediaType.series) {
      return _meta['network'] as String?;
    }
    return _meta['studio'] as String?;
  }

  String _capitalize(String s) {
    if (s.isEmpty) return s;
    return s[0].toUpperCase() + s.substring(1);
  }

  String _formatDate(DateTime date) {
    final months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    return '${date.day} ${months[date.month - 1]} ${date.year}';
  }

  String _formatBytes(num bytes) {
    if (bytes <= 0) return '0 B';
    final gb = bytes / (1024 * 1024 * 1024);
    if (gb >= 1) return '${gb.toStringAsFixed(1)} GB';
    final mb = bytes / (1024 * 1024);
    return '${mb.toStringAsFixed(0)} MB';
  }
}

/// Action button for Monitored/Search/Edit
class _ActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool filled;
  final VoidCallback onTap;

  const _ActionButton({
    required this.icon,
    required this.label,
    required this.filled,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: filled ? AppColors.primary : Colors.transparent,
      borderRadius: BorderRadius.circular(8),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: filled
                  ? AppColors.primary
                  : Theme.of(context).colorScheme.outline.withOpacity(0.3),
            ),
          ),
          child: Column(
            children: [
              Icon(
                icon,
                size: 24,
                color: filled
                    ? Colors.white
                    : Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
              ),
              const SizedBox(height: 4),
              Text(
                label.toUpperCase(),
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.5,
                  color: filled
                      ? Colors.white
                      : Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
