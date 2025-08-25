import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:arr/models/hive/service_config.dart';
import 'package:arr/providers/service_providers.dart';
import 'package:arr/features/settings/widgets/service_config_dialog.dart';
import 'package:arr/providers/theme_provider.dart';

import '../../../providers/radarr_providers.dart';
import '../../../providers/sonarr_providers.dart';

class SettingsPage extends ConsumerWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final services = ref.watch(serviceConfigsProvider);
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: ListView(
        children: [
          _buildSectionHeader(context, 'Service Configurations'),
          ...services.map((service) => _buildServiceTile(context, ref, service)),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton.icon(
              onPressed: () => _showAddServiceDialog(context, ref),
              icon: const Icon(Icons.add),
              label: const Text('Add Service'),
            ),
          ),
          const Divider(),
          _buildSectionHeader(context, 'Appearance'),
          _buildThemeSelector(context, ref),
          const Divider(),
          _buildSectionHeader(context, 'Cache Management'),
          ListTile(
            leading: const Icon(Icons.delete_sweep),
            title: const Text('Clear Cache'),
            subtitle: const Text('Remove all cached data'),
            onTap: () => _clearCache(context, ref),
          ),
          const Divider(),
          _buildSectionHeader(context, 'About'),
          ListTile(
            leading: const Icon(Icons.info),
            title: const Text('Version'),
            subtitle: const Text('1.0.0'),
          ),
        ],
      ),
    );
  }
  
  Widget _buildSectionHeader(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleMedium?.copyWith(
          color: Theme.of(context).colorScheme.primary,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
  
  Widget _buildServiceTile(BuildContext context, WidgetRef ref, ServiceConfig service) {
    final icon = _getServiceIcon(service.serviceType);
    final isConnected = service.lastSync != null;
    
    return ListTile(
      leading: Icon(icon, color: service.isEnabled ? null : Colors.grey),
      title: Text(service.name),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            service.url,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          if (service.lastSync != null)
            Text(
              'Last sync: ${_formatDate(service.lastSync!)}',
              style: Theme.of(context).textTheme.bodySmall,
            ),
        ],
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (service.isDefault)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primaryContainer,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                'Default',
                style: TextStyle(
                  fontSize: 12,
                  color: Theme.of(context).colorScheme.onPrimaryContainer,
                ),
              ),
            ),
          IconButton(
            icon: Icon(
              isConnected ? Icons.check_circle : Icons.error,
              color: isConnected ? Colors.green : Colors.orange,
            ),
            onPressed: () => _testConnection(context, ref, service),
          ),
          Switch(
            value: service.isEnabled,
            onChanged: (value) => _toggleService(ref, service, value),
          ),
        ],
      ),
      onTap: () => _showEditServiceDialog(context, ref, service),
      onLongPress: () => _showDeleteConfirmation(context, ref, service),
    );
  }
  
  IconData _getServiceIcon(ServiceType type) {
    switch (type) {
      case ServiceType.sonarr:
        return Icons.tv;
      case ServiceType.radarr:
        return Icons.movie;
      case ServiceType.lidarr:
        return Icons.music_note;
      case ServiceType.readarr:
        return Icons.book;
    }
  }
  
  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);
    
    if (difference.inMinutes < 1) {
      return 'Just now';
    } else if (difference.inHours < 1) {
      return '${difference.inMinutes} min ago';
    } else if (difference.inDays < 1) {
      return '${difference.inHours} hours ago';
    } else {
      return '${difference.inDays} days ago';
    }
  }
  
  void _showAddServiceDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => const ServiceConfigDialog(),
    );
  }
  
  void _showEditServiceDialog(BuildContext context, WidgetRef ref, ServiceConfig service) {
    showDialog(
      context: context,
      builder: (context) => ServiceConfigDialog(service: service),
    );
  }
  
  void _toggleService(WidgetRef ref, ServiceConfig service, bool enabled) {
    service.isEnabled = enabled;
    ref.read(serviceConfigsProvider.notifier).updateService(service);
  }
  
  Future<void> _testConnection(BuildContext context, WidgetRef ref, ServiceConfig service) async {
    final scaffoldMessenger = ScaffoldMessenger.of(context);
    
    final result = await ref.read(serviceConfigsProvider.notifier).testConnection(service);
    
    scaffoldMessenger.showSnackBar(
      SnackBar(
        content: Text(result ? 'Connection successful!' : 'Connection failed!'),
        backgroundColor: result ? Colors.green : Colors.red,
      ),
    );
  }
  
  void _showDeleteConfirmation(BuildContext context, WidgetRef ref, ServiceConfig service) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Service'),
        content: Text('Are you sure you want to delete "${service.name}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              ref.read(serviceConfigsProvider.notifier).deleteService(service.id);
              Navigator.of(context).pop();
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
  
  Widget _buildThemeSelector(BuildContext context, WidgetRef ref) {
    final currentTheme = ref.watch(themeProvider);
    
    return ListTile(
      leading: const Icon(Icons.dark_mode),
      title: const Text('Theme'),
      subtitle: Text(_getThemeDisplayName(currentTheme)),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      onTap: () async {
        final selected = await showDialog<AppThemeMode>(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Choose Theme'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: AppThemeMode.values.map((mode) {
                return RadioListTile<AppThemeMode>(
                  title: Text(_getThemeDisplayName(mode)),
                  value: mode,
                  groupValue: currentTheme,
                  onChanged: (value) {
                    Navigator.of(context).pop(value);
                  },
                );
              }).toList(),
            ),
          ),
        );
        
        if (selected != null) {
          await ref.read(themeProvider.notifier).setTheme(selected);
        }
      },
    );
  }
  
  String _getThemeDisplayName(AppThemeMode mode) {
    switch (mode) {
      case AppThemeMode.system:
        return 'System (Auto)';
      case AppThemeMode.light:
        return 'Light';
      case AppThemeMode.dark:
        return 'Dark';
    }
  }
  
  Future<void> _clearCache(BuildContext context, WidgetRef ref) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Clear Cache'),
        content: const Text('This will remove all cached data. You will need to sync again to see your media.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Clear', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
    
    if (result == true && context.mounted) {
      await ref.read(sonarrCacheBoxProvider).clear();
      await ref.read(radarrCacheBoxProvider).clear();
      
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Cache cleared successfully')),
      );
    }
  }
}