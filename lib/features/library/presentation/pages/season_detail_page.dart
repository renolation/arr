import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../main.dart';
import '../../../../core/network/api_providers.dart';

/// Detail page for a specific season showing all episodes.
/// Fetches episodes and episode files from the Sonarr API.
class SeasonDetailPage extends ConsumerStatefulWidget {
  final int seriesId;
  final int seasonNumber;
  final String seriesTitle;
  final String serviceKey;

  const SeasonDetailPage({
    super.key,
    required this.seriesId,
    required this.seasonNumber,
    required this.seriesTitle,
    required this.serviceKey,
  });

  @override
  ConsumerState<SeasonDetailPage> createState() => _SeasonDetailPageState();
}

class _SeasonDetailPageState extends ConsumerState<SeasonDetailPage> {
  List<Map<String, dynamic>> _episodes = [];
  Map<int, Map<String, dynamic>> _episodeFilesById = {};
  bool _isLoading = true;
  String? _error;

  String get _seasonLabel =>
      widget.seasonNumber == 0 ? 'Specials' : 'Season ${widget.seasonNumber}';

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final apis = await ref.read(allSonarrApisProvider.future);
      final match = apis.where((e) => e.$1 == widget.serviceKey).firstOrNull;
      if (match == null) {
        if (mounted) setState(() { _error = 'Service not found'; _isLoading = false; });
        return;
      }

      final api = match.$2;

      // Fetch episodes and episode files in parallel
      final results = await Future.wait([
        api.getEpisodes(widget.seriesId, seasonNumber: widget.seasonNumber),
        api.getEpisodeFiles(widget.seriesId),
      ]);

      final episodes = results[0];
      final episodeFiles = results[1];

      // Index episode files by ID for quick lookup
      final filesById = <int, Map<String, dynamic>>{};
      for (final file in episodeFiles) {
        final id = file['id'] as int?;
        if (id != null) filesById[id] = file;
      }

      // Sort episodes by episode number
      episodes.sort((a, b) =>
          (a['episodeNumber'] as int? ?? 0).compareTo(b['episodeNumber'] as int? ?? 0));

      if (mounted) {
        setState(() {
          _episodes = episodes;
          _episodeFilesById = filesById;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _error = e.toString();
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.seriesTitle,
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
            ),
            Text(
              _seasonLabel,
              style: TextStyle(
                fontSize: 12,
                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5),
              ),
            ),
          ],
        ),
      ),
      body: _buildBody(context),
    );
  }

  Widget _buildBody(BuildContext context) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_error != null) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.error_outline, size: 48,
                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.3)),
            const SizedBox(height: 12),
            Text('Failed to load episodes',
                style: TextStyle(color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5))),
            const SizedBox(height: 12),
            TextButton(onPressed: _fetchData, child: const Text('Retry')),
          ],
        ),
      );
    }

    if (_episodes.isEmpty) {
      return Center(
        child: Text(
          'No episodes found',
          style: TextStyle(color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5)),
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _fetchData,
      child: ListView.separated(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
        itemCount: _episodes.length,
        separatorBuilder: (_, __) => const SizedBox(height: 8),
        itemBuilder: (context, index) => _buildEpisodeCard(context, _episodes[index]),
      ),
    );
  }

  Widget _buildEpisodeCard(BuildContext context, Map<String, dynamic> episode) {
    final episodeNum = episode['episodeNumber'] as int? ?? 0;
    final title = episode['title'] as String? ?? 'Episode $episodeNum';
    final overview = episode['overview'] as String?;
    final airDate = episode['airDate'] as String?;
    final runtime = episode['runtime'] as int? ?? 0;
    final hasFile = episode['hasFile'] as bool? ?? false;
    final monitored = episode['monitored'] as bool? ?? false;
    final episodeFileId = episode['episodeFileId'] as int? ?? 0;

    // Get episode file details if available
    final episodeFile = episodeFileId > 0 ? _episodeFilesById[episodeFileId] : null;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: Theme.of(context).colorScheme.outline.withOpacity(0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Episode number + title row
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Episode number badge
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: hasFile
                      ? AppColors.accentGreen.withOpacity(0.15)
                      : monitored
                          ? AppColors.primary.withOpacity(0.1)
                          : Theme.of(context).colorScheme.onSurface.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Center(
                  child: Text(
                    '$episodeNum',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: hasFile
                          ? AppColors.accentGreen
                          : monitored
                              ? AppColors.primary
                              : Theme.of(context).colorScheme.onSurface.withOpacity(0.4),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              // Title + meta
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: hasFile
                            ? null
                            : Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                      ),
                    ),
                    const SizedBox(height: 4),
                    _buildEpisodeMeta(context, airDate, runtime, hasFile, monitored),
                  ],
                ),
              ),
              // Status icon
              _buildStatusIcon(context, hasFile, monitored, airDate),
            ],
          ),

          // Overview
          if (overview != null && overview.isNotEmpty) ...[
            const SizedBox(height: 12),
            Text(
              overview,
              style: TextStyle(
                fontSize: 13,
                height: 1.5,
                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
              ),
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
          ],

          // File details (if has file)
          if (hasFile && episodeFile != null) ...[
            const SizedBox(height: 12),
            _buildFileDetails(context, episodeFile),
          ],
        ],
      ),
    );
  }

  Widget _buildFileDetails(BuildContext context, Map<String, dynamic> episodeFile) {
    final mediaInfo = episodeFile['mediaInfo'] as Map<String, dynamic>?;
    final quality = _extractQuality(episodeFile);
    final fileSize = episodeFile['size'] as num?;
    final releaseGroup = episodeFile['releaseGroup'] as String?;
    final filePath = episodeFile['relativePath'] as String? ?? episodeFile['path'] as String?;

    // MediaInfo fields
    final videoCodec = mediaInfo?['videoCodec'] as String?;
    final resolution = mediaInfo?['resolution'] as String?;
    final audioCodec = mediaInfo?['audioCodec'] as String?;
    final audioChannels = mediaInfo?['audioChannels'] as num?;
    final audioLanguages = mediaInfo?['audioLanguages'] as String?;
    final subtitles = mediaInfo?['subtitles'] as String?;

    final rows = <(IconData, String, String)>[];

    if (quality != null) {
      rows.add((Icons.high_quality_outlined, 'Quality', quality));
    }
    if (fileSize != null && fileSize > 0) {
      rows.add((Icons.storage_outlined, 'Size', _formatBytes(fileSize)));
    }
    if (resolution != null && resolution.isNotEmpty) {
      rows.add((Icons.aspect_ratio_outlined, 'Resolution', resolution));
    }
    if (videoCodec != null && videoCodec.isNotEmpty) {
      rows.add((Icons.videocam_outlined, 'Video Codec', videoCodec));
    }
    if (audioCodec != null && audioCodec.isNotEmpty) {
      final channelStr = audioChannels != null ? ' $audioChannels' : '';
      rows.add((Icons.audiotrack_outlined, 'Audio Codec', '$audioCodec$channelStr'));
    }
    if (audioLanguages != null && audioLanguages.isNotEmpty) {
      rows.add((Icons.language_outlined, 'Audio', audioLanguages.replaceAll('/', ', ')));
    }
    if (subtitles != null && subtitles.isNotEmpty) {
      rows.add((Icons.subtitles_outlined, 'Subtitles', subtitles.replaceAll('/', ', ')));
    }
    if (releaseGroup != null && releaseGroup.isNotEmpty) {
      rows.add((Icons.group_outlined, 'Release', releaseGroup));
    }
    if (filePath != null && filePath.isNotEmpty) {
      rows.add((Icons.folder_open_outlined, 'Path', filePath));
    }

    if (rows.isEmpty) return const SizedBox.shrink();

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: rows.map((row) {
          final (icon, label, value) = row;
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(icon, size: 16,
                    color: Theme.of(context).colorScheme.onSurface.withOpacity(0.35)),
                const SizedBox(width: 8),
                SizedBox(
                  width: 80,
                  child: Text(
                    label,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5),
                    ),
                  ),
                ),
                Expanded(
                  child: Text(
                    value,
                    style: TextStyle(
                      fontSize: 12,
                      color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildEpisodeMeta(
      BuildContext context, String? airDate, int runtime, bool hasFile, bool monitored) {
    final parts = <String>[];
    if (airDate != null) {
      final date = DateTime.tryParse(airDate);
      if (date != null) {
        final months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
            'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
        parts.add('${date.day} ${months[date.month - 1]} ${date.year}');
      }
    }
    if (runtime > 0) {
      parts.add('${runtime}m');
    }

    return Text(
      parts.join('  \u2022  '),
      style: TextStyle(
        fontSize: 12,
        color: Theme.of(context).colorScheme.onSurface.withOpacity(0.4),
      ),
    );
  }

  Widget _buildStatusIcon(BuildContext context, bool hasFile, bool monitored, String? airDate) {
    if (hasFile) {
      return const Icon(Icons.check_circle, size: 20, color: AppColors.accentGreen);
    }

    // Check if episode has aired
    final isUpcoming = airDate != null &&
        DateTime.tryParse(airDate)?.isAfter(DateTime.now()) == true;

    if (isUpcoming) {
      return Icon(Icons.schedule, size: 20,
          color: Theme.of(context).colorScheme.onSurface.withOpacity(0.3));
    }

    if (monitored) {
      return const Icon(Icons.warning_amber_rounded, size: 20, color: AppColors.accentRed);
    }

    return Icon(Icons.remove_circle_outline, size: 20,
        color: Theme.of(context).colorScheme.onSurface.withOpacity(0.3));
  }

  String? _extractQuality(Map<String, dynamic>? episodeFile) {
    if (episodeFile == null) return null;
    final quality = episodeFile['quality'] as Map<String, dynamic>?;
    final qualityDetail = quality?['quality'] as Map<String, dynamic>?;
    return qualityDetail?['name'] as String?;
  }

  String _formatBytes(num bytes) {
    if (bytes <= 0) return '0 B';
    final gb = bytes / (1024 * 1024 * 1024);
    if (gb >= 1) return '${gb.toStringAsFixed(1)} GB';
    final mb = bytes / (1024 * 1024);
    return '${mb.toStringAsFixed(0)} MB';
  }
}

