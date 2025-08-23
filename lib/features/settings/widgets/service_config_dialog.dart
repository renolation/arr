import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:arr/models/hive/service_config.dart';
import 'package:arr/providers/service_providers.dart';

class ServiceConfigDialog extends ConsumerStatefulWidget {
  final ServiceConfig? service;
  
  const ServiceConfigDialog({super.key, this.service});
  
  @override
  ConsumerState<ServiceConfigDialog> createState() => _ServiceConfigDialogState();
}

class _ServiceConfigDialogState extends ConsumerState<ServiceConfigDialog> {
  late TextEditingController _nameController;
  late TextEditingController _urlController;
  late TextEditingController _apiKeyController;
  ServiceType _selectedType = ServiceType.sonarr;
  bool _isDefault = false;
  bool _isEnabled = true;
  bool _isTesting = false;
  
  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.service?.name ?? '');
    _urlController = TextEditingController(text: widget.service?.url ?? '');
    _apiKeyController = TextEditingController(text: widget.service?.apiKey ?? '');
    _selectedType = widget.service?.serviceType ?? ServiceType.sonarr;
    _isDefault = widget.service?.isDefault ?? false;
    _isEnabled = widget.service?.isEnabled ?? true;
  }
  
  @override
  void dispose() {
    _nameController.dispose();
    _urlController.dispose();
    _apiKeyController.dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.service == null ? 'Add Service' : 'Edit Service'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Name',
                hintText: 'My Sonarr Server',
                prefixIcon: Icon(Icons.label),
              ),
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<ServiceType>(
              value: _selectedType,
              decoration: const InputDecoration(
                labelText: 'Service Type',
                prefixIcon: Icon(Icons.category),
              ),
              items: ServiceType.values.map((type) {
                return DropdownMenuItem(
                  value: type,
                  child: Text(_getServiceTypeName(type)),
                );
              }).toList(),
              onChanged: widget.service == null ? (value) {
                if (value != null) {
                  setState(() {
                    _selectedType = value;
                  });
                }
              } : null,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _urlController,
              decoration: const InputDecoration(
                labelText: 'URL',
                hintText: 'http://192.168.1.100:8989',
                prefixIcon: Icon(Icons.link),
              ),
              keyboardType: TextInputType.url,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _apiKeyController,
              decoration: const InputDecoration(
                labelText: 'API Key',
                hintText: 'Your API key',
                prefixIcon: Icon(Icons.key),
              ),
              obscureText: true,
            ),
            const SizedBox(height: 16),
            SwitchListTile(
              title: const Text('Enabled'),
              value: _isEnabled,
              onChanged: (value) {
                setState(() {
                  _isEnabled = value;
                });
              },
            ),
            SwitchListTile(
              title: const Text('Set as Default'),
              subtitle: const Text('Use this service by default'),
              value: _isDefault,
              onChanged: (value) {
                setState(() {
                  _isDefault = value;
                });
              },
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: _isTesting ? null : () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: _isTesting ? null : _testConnection,
          child: _isTesting 
            ? const SizedBox(
                width: 16,
                height: 16,
                child: CircularProgressIndicator(strokeWidth: 2),
              )
            : const Text('Test'),
        ),
        ElevatedButton(
          onPressed: _isTesting ? null : _save,
          child: const Text('Save'),
        ),
      ],
    );
  }
  
  String _getServiceTypeName(ServiceType type) {
    switch (type) {
      case ServiceType.sonarr:
        return 'Sonarr';
      case ServiceType.radarr:
        return 'Radarr';
      case ServiceType.lidarr:
        return 'Lidarr';
      case ServiceType.readarr:
        return 'Readarr';
    }
  }
  
  Future<void> _testConnection() async {
    if (!_validateInput()) return;
    
    setState(() {
      _isTesting = true;
    });
    
    final service = ServiceConfig(
      id: widget.service?.id ?? DateTime.now().millisecondsSinceEpoch.toString(),
      name: _nameController.text,
      url: _normalizeUrl(_urlController.text),
      apiKey: _apiKeyController.text,
      serviceType: _selectedType,
      isEnabled: _isEnabled,
      isDefault: _isDefault,
    );
    
    final result = await ref.read(serviceConfigsProvider.notifier).testConnection(service);
    
    setState(() {
      _isTesting = false;
    });
    
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(result ? 'Connection successful!' : 'Connection failed!'),
          backgroundColor: result ? Colors.green : Colors.red,
        ),
      );
    }
  }
  
  Future<void> _save() async {
    if (!_validateInput()) return;
    
    // If setting as default, unset other defaults of the same type
    if (_isDefault) {
      final services = ref.read(serviceConfigsProvider);
      for (final service in services) {
        if (service.serviceType == _selectedType && service.isDefault && service.id != widget.service?.id) {
          service.isDefault = false;
          await ref.read(serviceConfigsProvider.notifier).updateService(service);
        }
      }
    }
    
    final service = ServiceConfig(
      id: widget.service?.id ?? DateTime.now().millisecondsSinceEpoch.toString(),
      name: _nameController.text,
      url: _normalizeUrl(_urlController.text),
      apiKey: _apiKeyController.text,
      serviceType: _selectedType,
      isEnabled: _isEnabled,
      isDefault: _isDefault,
      lastSync: widget.service?.lastSync,
    );
    
    if (widget.service == null) {
      await ref.read(serviceConfigsProvider.notifier).addService(service);
    } else {
      await ref.read(serviceConfigsProvider.notifier).updateService(service);
    }
    
    if (mounted) {
      Navigator.of(context).pop();
    }
  }
  
  bool _validateInput() {
    if (_nameController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a name')),
      );
      return false;
    }
    
    if (_urlController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a URL')),
      );
      return false;
    }
    
    if (_apiKeyController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter an API key')),
      );
      return false;
    }
    
    return true;
  }
  
  String _normalizeUrl(String url) {
    // Remove trailing slash
    if (url.endsWith('/')) {
      url = url.substring(0, url.length - 1);
    }
    
    // Add protocol if missing
    if (!url.startsWith('http://') && !url.startsWith('https://')) {
      url = 'http://$url';
    }
    
    return url;
  }
}