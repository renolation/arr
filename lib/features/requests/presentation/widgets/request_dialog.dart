import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/network/models/jellyseerr_models.dart';
import '../../../../core/network/api_providers.dart';
import '../../../../main.dart';
import '../providers/requests_provider.dart';

/// Dialog for selecting a server and quality profile before creating a request.
/// Two dropdowns: 1) Select service/server, 2) Select quality profile.
class RequestDialog extends ConsumerStatefulWidget {
  final JellyseerrMediaResult media;

  const RequestDialog({super.key, required this.media});

  /// Show the dialog and return true if request was successful
  static Future<bool?> show(BuildContext context, JellyseerrMediaResult media) {
    return showDialog<bool>(
      context: context,
      builder: (_) => RequestDialog(media: media),
    );
  }

  @override
  ConsumerState<RequestDialog> createState() => _RequestDialogState();
}

class _RequestDialogState extends ConsumerState<RequestDialog> {
  JellyseerrServiceServer? _selectedServer;
  JellyseerrServiceProfile? _selectedProfile;
  List<JellyseerrServiceProfile> _profiles = [];
  bool _isLoadingProfiles = false;
  bool _isRequesting = false;

  bool get _isMovie => widget.media.mediaType == 'movie';

  @override
  Widget build(BuildContext context) {
    final serversAsync = _isMovie
        ? ref.watch(radarrServersProvider)
        : ref.watch(sonarrServersProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return AlertDialog(
      backgroundColor: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      title: Text(
        'Request ${widget.media.title}',
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
      ),
      content: serversAsync.when(
        loading: () => const SizedBox(
          height: 100,
          child: Center(child: CircularProgressIndicator(strokeWidth: 2)),
        ),
        error: (e, _) => SizedBox(
          height: 80,
          child: Center(
            child: Text(
              'Failed to load servers',
              style: TextStyle(color: Theme.of(context).colorScheme.error),
            ),
          ),
        ),
        data: (servers) {
          if (servers.isEmpty) {
            return const SizedBox(
              height: 60,
              child: Center(child: Text('No servers configured')),
            );
          }

          // Auto-select default server on first build
          if (_selectedServer == null) {
            final defaultServer =
                servers.where((s) => s.isDefault).firstOrNull;
            final server = defaultServer ?? servers.first;
            // Schedule after build to avoid setState during build
            WidgetsBinding.instance.addPostFrameCallback((_) {
              _onServerChanged(server);
            });
          }

          return SizedBox(
            width: double.maxFinite,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Server dropdown
                _buildLabel(context, 'Server'),
                const SizedBox(height: 6),
                _buildServerDropdown(context, servers),
                const SizedBox(height: 16),
                // Profile dropdown
                _buildLabel(context, 'Quality Profile'),
                const SizedBox(height: 6),
                _buildProfileDropdown(context),
              ],
            ),
          );
        },
      ),
      actions: [
        TextButton(
          onPressed: _isRequesting ? null : () => Navigator.pop(context, false),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed:
              _isRequesting || _selectedServer == null || _selectedProfile == null
                  ? null
                  : () => _onConfirm(),
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            foregroundColor: Colors.white,
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(6),
            ),
          ),
          child: _isRequesting
              ? const SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Colors.white,
                  ),
                )
              : const Text('Request'),
        ),
      ],
    );
  }

  Widget _buildLabel(BuildContext context, String text) {
    return Text(
      text.toUpperCase(),
      style: TextStyle(
        fontSize: 11,
        fontWeight: FontWeight.w600,
        color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.5),
        letterSpacing: 0.8,
      ),
    );
  }

  Widget _buildServerDropdown(
      BuildContext context, List<JellyseerrServiceServer> servers) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(6),
        border: Border.all(
          color: isDark ? AppColors.borderDark : AppColors.borderLight,
        ),
      ),
      child: DropdownButton<int>(
        value: _selectedServer?.id,
        isExpanded: true,
        underline: const SizedBox.shrink(),
        dropdownColor: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
        icon: const Icon(Icons.keyboard_arrow_down, size: 20),
        items: servers.map((server) {
          return DropdownMenuItem<int>(
            value: server.id,
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    server.displayName,
                    style: const TextStyle(fontSize: 14),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                if (server.isDefault)
                  Container(
                    margin: const EdgeInsets.only(left: 6),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(3),
                    ),
                    child: const Text(
                      'DEFAULT',
                      style: TextStyle(
                        fontSize: 8,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primary,
                      ),
                    ),
                  ),
              ],
            ),
          );
        }).toList(),
        onChanged: _isRequesting
            ? null
            : (id) {
                final server = servers.firstWhere((s) => s.id == id);
                _onServerChanged(server);
              },
      ),
    );
  }

  Widget _buildProfileDropdown(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    if (_isLoadingProfiles) {
      return Container(
        height: 48,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(6),
          border: Border.all(
            color: isDark ? AppColors.borderDark : AppColors.borderLight,
          ),
        ),
        child: const Center(
          child: SizedBox(
            width: 16,
            height: 16,
            child: CircularProgressIndicator(strokeWidth: 2),
          ),
        ),
      );
    }

    if (_profiles.isEmpty) {
      return Container(
        height: 48,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(6),
          border: Border.all(
            color: isDark ? AppColors.borderDark : AppColors.borderLight,
          ),
        ),
        alignment: Alignment.centerLeft,
        child: Text(
          _selectedServer == null ? 'Select a server first' : 'No profiles',
          style: TextStyle(
            fontSize: 14,
            color:
                Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.4),
          ),
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(6),
        border: Border.all(
          color: isDark ? AppColors.borderDark : AppColors.borderLight,
        ),
      ),
      child: DropdownButton<int>(
        value: _selectedProfile?.id,
        isExpanded: true,
        underline: const SizedBox.shrink(),
        dropdownColor: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
        icon: const Icon(Icons.keyboard_arrow_down, size: 20),
        items: _profiles.map((profile) {
          return DropdownMenuItem<int>(
            value: profile.id,
            child: Text(
              profile.name,
              style: const TextStyle(fontSize: 14),
              overflow: TextOverflow.ellipsis,
            ),
          );
        }).toList(),
        onChanged: _isRequesting
            ? null
            : (id) {
                setState(() {
                  _selectedProfile =
                      _profiles.firstWhere((p) => p.id == id);
                });
              },
      ),
    );
  }

  Future<void> _onServerChanged(JellyseerrServiceServer server) async {
    setState(() {
      _selectedServer = server;
      _selectedProfile = null;
      _profiles = [];
      _isLoadingProfiles = true;
    });

    try {
      final api = await ref.read(overseerrApiProvider.future);
      if (api == null) return;

      final profiles = _isMovie
          ? await api.getRadarrProfiles(server.id)
          : await api.getSonarrProfiles(server.id);

      if (!mounted) return;
      setState(() {
        _profiles = profiles;
        _isLoadingProfiles = false;
        // Pre-select the server's active profile if it exists
        _selectedProfile = profiles
            .where((p) => p.id == server.activeProfileId)
            .firstOrNull;
        // Fallback to first profile
        _selectedProfile ??= profiles.firstOrNull;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _isLoadingProfiles = false;
      });
    }
  }

  Future<void> _onConfirm() async {
    if (_selectedServer == null || _selectedProfile == null) return;
    setState(() => _isRequesting = true);

    final server = _selectedServer!;
    final profile = _selectedProfile!;
    final success =
        await ref.read(requestActionsProvider.notifier).createRequest(
              mediaType: widget.media.mediaType,
              mediaId: widget.media.id,
              is4k: server.is4k,
              serverId: server.id,
              profileId: profile.id,
              rootFolder: server.activeDirectory,
            );

    if (mounted) {
      Navigator.pop(context, success);
    }
  }
}
