import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/service_config.dart';
import '../providers/service_provider.dart';

/// Card widget for displaying and managing service configuration
class ServiceCard extends ConsumerWidget {
  final ServiceConfig service;

  const ServiceCard({
    super.key,
    required this.service,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Card(
      child: InkWell(
        onTap: () => _showDetails(context, ref),
        onLongPress: () => _showEditMenu(context, ref),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              // Icon
              _buildServiceIcon(context),

              const SizedBox(width: 16),

              // Info Section
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Name and Type
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            service.name,
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                        ),
                        _buildStatusBadge(context),
                      ],
                    ),

                    const SizedBox(height: 4),

                    // URL
                    Text(
                      service.baseUrl,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Theme.of(context)
                                .colorScheme
                                .onSurface
                                .withOpacity(0.6),
                          ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),

                    // Last Sync
                    if (service.lastSync != null) ...[
                      const SizedBox(height: 4),
                      Text(
                        'Last synced: ${service.lastSync}',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: Theme.of(context)
                                  .colorScheme
                                  .onSurface
                                  .withOpacity(0.5),
                            ),
                      ),
                    ],
                  ],
                ),
              ),

              const SizedBox(width: 8),

              // Menu Button
              IconButton(
                icon: const Icon(Icons.more_vert),
                onPressed: () => _showEditMenu(context, ref),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildServiceIcon(BuildContext context) {
    IconData icon;
    Color color;

    switch (service.type) {
      case ServiceType.sonarr:
        icon = Icons.tv;
        color = Theme.of(context).colorScheme.secondary;
        break;
      case ServiceType.radarr:
        icon = Icons.movie;
        color = Theme.of(context).colorScheme.primary;
        break;
      case ServiceType.overseerr:
        icon = Icons.request_page;
        color = Colors.purple;
        break;
      case ServiceType.downloadClient:
        icon = Icons.download;
        color = Colors.green;
        break;
    }

    return Container(
      width: 56,
      height: 56,
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Icon(icon, size: 28, color: color),
    );
  }

  Widget _buildStatusBadge(BuildContext context) {
    final isConfigured = service.isConfigured;
    final isActive = service.isActive ?? true;

    if (!isConfigured) {
      return _buildBadge(
        context,
        'Incomplete',
        Colors.orange,
        Icons.warning,
      );
    }

    if (!isActive) {
      return _buildBadge(
        context,
        'Inactive',
        Colors.grey,
        Icons.block,
      );
    }

    return _buildBadge(
      context,
      'Active',
      Colors.green,
      Icons.check_circle,
    );
  }

  Widget _buildBadge(
    BuildContext context,
    String label,
    Color color,
    IconData icon,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: color),
          const SizedBox(width: 4),
          Text(
            label,
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: color,
                  fontWeight: FontWeight.w600,
                ),
          ),
        ],
      ),
    );
  }

  void _showDetails(BuildContext context, WidgetRef ref) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => _ServiceDetailSheet(service: service),
    );
  }

  void _showEditMenu(BuildContext context, WidgetRef ref) {
    showModalBottomSheet(
      context: context,
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.edit),
              title: const Text('Edit'),
              onTap: () {
                Navigator.pop(context);
                // TODO: Show edit dialog
              },
            ),
            ListTile(
              leading: const Icon(Icons.sync),
              title: const Text('Test Connection'),
              onTap: () {
                Navigator.pop(context);
                ref.read(serviceNotifierProvider.notifier).testConnection(service);
              },
            ),
            ListTile(
              leading: const Icon(Icons.delete, color: Colors.red),
              title: const Text('Delete', style: TextStyle(color: Colors.red)),
              onTap: () {
                Navigator.pop(context);
                _showDeleteConfirmation(context, ref);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showDeleteConfirmation(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Service'),
        content: Text('Are you sure you want to delete ${service.name}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              ref.read(serviceNotifierProvider.notifier).deleteService(service.key);
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}

/// Service detail sheet
class _ServiceDetailSheet extends StatelessWidget {
  final ServiceConfig service;

  const _ServiceDetailSheet({required this.service});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                service.name,
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const Spacer(),
              IconButton(
                icon: const Icon(Icons.close),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildDetailRow(context, 'Type', service.type.name.toUpperCase()),
          _buildDetailRow(context, 'URL', service.baseUrl),
          if (service.port != null)
            _buildDetailRow(context, 'Port', service.port.toString()),
          if (service.lastSync != null)
            _buildDetailRow(context, 'Last Sync', service.lastSync.toString()),
          _buildDetailRow(
            context,
            'Status',
            service.isConfigured ? 'Configured' : 'Incomplete',
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(BuildContext context, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context)
                        .colorScheme
                        .onSurface
                        .withOpacity(0.6),
                  ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
        ],
      ),
    );
  }
}
