import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/network/sonarr_api.dart';
import '../../../../core/network/radarr_api.dart';
import '../../../../core/network/overseerr_api.dart';
import '../../domain/entities/service_config.dart';
import '../providers/service_provider.dart';

/// Supported service type metadata for the "Add" dropdown
class _ServiceTypeInfo {
  final ServiceType type;
  final String label;
  final IconData icon;
  final String defaultPort;

  const _ServiceTypeInfo({
    required this.type,
    required this.label,
    required this.icon,
    required this.defaultPort,
  });
}

const _supportedServices = [
  _ServiceTypeInfo(
    type: ServiceType.radarr,
    label: 'Radarr',
    icon: Icons.movie_outlined,
    defaultPort: '7878',
  ),
  _ServiceTypeInfo(
    type: ServiceType.sonarr,
    label: 'Sonarr',
    icon: Icons.tv_outlined,
    defaultPort: '8989',
  ),
  _ServiceTypeInfo(
    type: ServiceType.overseerr,
    label: 'Overseerr',
    icon: Icons.download_done_outlined,
    defaultPort: '5055',
  ),
  _ServiceTypeInfo(
    type: ServiceType.downloadClient,
    label: 'Download Client',
    icon: Icons.cloud_download_outlined,
    defaultPort: '8080',
  ),
];

/// Test connection using the appropriate API's health endpoint
Future<bool> _testServiceConnection(ServiceConfig config) async {
  switch (config.type) {
    case ServiceType.sonarr:
      final api = SonarrApi(config: config);
      return api.testConnection();
    case ServiceType.radarr:
      final api = RadarrApi(config: config);
      return api.testConnection();
    case ServiceType.overseerr:
      final api = OverseerrApi(config: config);
      return api.testConnection();
    case ServiceType.downloadClient:
      // Download client doesn't have a unified test yet
      return false;
  }
}

/// Get icon for a service type
IconData _iconForType(ServiceType type) {
  switch (type) {
    case ServiceType.radarr:
      return Icons.movie_outlined;
    case ServiceType.sonarr:
      return Icons.tv_outlined;
    case ServiceType.overseerr:
      return Icons.download_done_outlined;
    case ServiceType.downloadClient:
      return Icons.cloud_download_outlined;
  }
}

/// Get display label for a service type
String _labelForType(ServiceType type) {
  switch (type) {
    case ServiceType.radarr:
      return 'Radarr';
    case ServiceType.sonarr:
      return 'Sonarr';
    case ServiceType.overseerr:
      return 'Overseerr';
    case ServiceType.downloadClient:
      return 'Download Client';
  }
}

/// Settings page for configuring services
class SettingsPage extends ConsumerStatefulWidget {
  const SettingsPage({super.key});

  @override
  ConsumerState<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends ConsumerState<SettingsPage> {
  int? _expandedIndex;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final servicesAsync = ref.watch(allServicesProvider);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Settings'),
        actions: [
          PopupMenuButton<_ServiceTypeInfo>(
            icon: Icon(
              Icons.add,
              color: theme.colorScheme.primary,
              size: 28,
            ),
            tooltip: 'Add service',
            onSelected: (info) => _showAddServiceDialog(info),
            itemBuilder: (context) => _supportedServices.map((info) {
              return PopupMenuItem<_ServiceTypeInfo>(
                value: info,
                child: Row(
                  children: [
                    Icon(info.icon, size: 20),
                    const SizedBox(width: 12),
                    Text(info.label),
                  ],
                ),
              );
            }).toList(),
          ),
        ],
      ),
      body: Column(
        children: [
          // Content
          Expanded(
              child: servicesAsync.when(
                data: (services) {
                  if (services.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.dns_outlined,
                            size: 64,
                            color: isDark ? Colors.grey.shade600 : Colors.grey.shade400,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'No services configured',
                            style: theme.textTheme.titleMedium?.copyWith(
                              color: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Tap + to add a service',
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: isDark ? Colors.grey.shade500 : Colors.grey.shade500,
                            ),
                          ),
                        ],
                      ),
                    );
                  }

                  return SingleChildScrollView(
                    child: Column(
                      children: [
                        // Service Cards
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 24),
                          child: Column(
                            children: List.generate(services.length, (index) {
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 16),
                                child: _ServiceCard(
                                  config: services[index],
                                  isExpanded: _expandedIndex == index,
                                  onToggle: () {
                                    setState(() {
                                      _expandedIndex =
                                          _expandedIndex == index ? null : index;
                                    });
                                  },
                                  onDelete: () => _deleteService(services[index]),
                                ),
                              );
                            }),
                          ),
                        ),

                        const SizedBox(height: 16),

                        // Bottom Actions
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 24),
                          child: Column(
                            children: [
                              SizedBox(
                                width: double.infinity,
                                child: ElevatedButton(
                                  onPressed: _syncAllServices,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: isDark
                                        ? Colors.grey.shade100
                                        : Colors.grey.shade900,
                                    foregroundColor: isDark
                                        ? Colors.grey.shade900
                                        : Colors.white,
                                    elevation: 0,
                                    padding:
                                        const EdgeInsets.symmetric(vertical: 16),
                                    shape: const RoundedRectangleBorder(
                                      borderRadius: BorderRadius.zero,
                                    ),
                                  ),
                                  child: const Text(
                                    'SYNC ALL SERVICES',
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                      letterSpacing: 1.5,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 16),
                              TextButton(
                                onPressed: _showResetConfirmation,
                                child: Text(
                                  'RESET CONFIGURATION',
                                  style: TextStyle(
                                    color: Colors.red.shade500,
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 1.5,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 32),
                      ],
                    ),
                  );
                },
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (e, _) => Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.error_outline, size: 48, color: Colors.red.shade400),
                      const SizedBox(height: 16),
                      Text('Failed to load services',
                          style: theme.textTheme.titleMedium),
                      const SizedBox(height: 8),
                      TextButton(
                        onPressed: () => ref.invalidate(allServicesProvider),
                        child: const Text('RETRY'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
    );
  }

  void _showAddServiceDialog(_ServiceTypeInfo info) {
    showDialog(
      context: context,
      builder: (context) => _AddServiceDialog(
        serviceInfo: info,
        onSave: (config) async {
          await ref.read(serviceNotifierProvider.notifier).addService(config);
          ref.invalidate(allServicesProvider);
        },
      ),
    );
  }

  Future<void> _deleteService(ServiceConfig config) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Service'),
        content: Text(
          'Are you sure you want to delete "${config.name}"? This cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('CANCEL'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('DELETE'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      await ref.read(serviceNotifierProvider.notifier).deleteService(config.key);
      ref.invalidate(allServicesProvider);
      setState(() => _expandedIndex = null);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Service deleted')),
        );
      }
    }
  }

  void _syncAllServices() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Syncing all services...')),
    );
  }

  void _showResetConfirmation() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Reset Configuration'),
        content: const Text(
          'Are you sure you want to reset all service configurations? This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('CANCEL'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _resetConfiguration();
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('RESET'),
          ),
        ],
      ),
    );
  }

  void _resetConfiguration() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Configuration reset')),
    );
  }
}

/// Dialog for adding a new service
class _AddServiceDialog extends StatefulWidget {
  final _ServiceTypeInfo serviceInfo;
  final Future<void> Function(ServiceConfig config) onSave;

  const _AddServiceDialog({
    required this.serviceInfo,
    required this.onSave,
  });

  @override
  State<_AddServiceDialog> createState() => _AddServiceDialogState();
}

class _AddServiceDialogState extends State<_AddServiceDialog> {
  final _urlController = TextEditingController(text: 'https://seerr.phuoc.io.vn:8443');
  final _apiKeyController = TextEditingController(text: 'MTc3MDQ0MDAwODQ1NDZkZTdhNTJlLTMwYzEtNDg4MC1hNTQ1LTE0Y2E2Mzg3YTU3OA==');
  final _portController = TextEditingController();
  bool _isTesting = false;
  bool _isSaving = false;
  bool? _testResult;

  @override
  void initState() {
    super.initState();
    _portController.text = widget.serviceInfo.defaultPort;
  }

  @override
  void dispose() {
    _urlController.dispose();
    _apiKeyController.dispose();
    _portController.dispose();
    super.dispose();
  }

  ServiceConfig _buildConfig(String key) {
    return ServiceConfig(
      key: key,
      type: widget.serviceInfo.type,
      name: widget.serviceInfo.label,
      url: _urlController.text.trim(),
      apiKey: _apiKeyController.text.trim(),
      port: int.tryParse(_portController.text.trim()),
      isActive: true,
    );
  }

  Future<void> _testConnection() async {
    if (_urlController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a URL')),
      );
      return;
    }

    setState(() {
      _isTesting = true;
      _testResult = null;
    });

    try {
      final config = _buildConfig('test');
      final success = await _testServiceConnection(config);
      if (mounted) {
        setState(() {
          _testResult = success;
          _isTesting = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(success ? 'Connection successful!' : 'Connection failed'),
            backgroundColor: success ? Colors.green : Colors.red,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _testResult = false;
          _isTesting = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Connection failed: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _save() async {
    if (_urlController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a URL')),
      );
      return;
    }

    setState(() => _isSaving = true);

    try {
      final key =
          '${widget.serviceInfo.type.name}_${DateTime.now().millisecondsSinceEpoch}';
      final config = _buildConfig(key);
      await widget.onSave(config);
      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Service saved!'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isSaving = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to save: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final borderColor = isDark ? Colors.grey.shade700 : Colors.grey.shade300;
    final inputBgColor = isDark ? const Color(0xFF1A2632) : Colors.grey.shade50;

    return AlertDialog(
      title: Row(
        children: [
          Icon(widget.serviceInfo.icon, size: 24),
          const SizedBox(width: 12),
          Text('Add ${widget.serviceInfo.label}'),
        ],
      ),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildLabel('URL', isDark),
            const SizedBox(height: 8),
            _buildTextField(
              controller: _urlController,
              hint: 'http://192.168.1.100',
              bgColor: inputBgColor,
              borderColor: borderColor,
            ),
            const SizedBox(height: 16),
            _buildLabel('API KEY', isDark),
            const SizedBox(height: 8),
            _buildTextField(
              controller: _apiKeyController,
              hint: 'Enter your API key',
              bgColor: inputBgColor,
              borderColor: borderColor,
              obscure: true,
            ),
            const SizedBox(height: 16),
            _buildLabel('PORT (OPTIONAL)', isDark),
            const SizedBox(height: 8),
            _buildTextField(
              controller: _portController,
              hint: widget.serviceInfo.defaultPort,
              bgColor: inputBgColor,
              borderColor: borderColor,
              keyboardType: TextInputType.number,
            ),
            if (_testResult != null) ...[
              const SizedBox(height: 16),
              Row(
                children: [
                  Icon(
                    _testResult! ? Icons.check_circle : Icons.cancel,
                    color: _testResult! ? Colors.green : Colors.red,
                    size: 18,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    _testResult! ? 'Connected' : 'Connection failed',
                    style: TextStyle(
                      color: _testResult! ? Colors.green : Colors.red,
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('CANCEL'),
        ),
        OutlinedButton(
          onPressed: _isTesting ? null : _testConnection,
          child: _isTesting
              ? const SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Text('TEST'),
        ),
        ElevatedButton(
          onPressed: _isSaving ? null : _save,
          style: ElevatedButton.styleFrom(
            backgroundColor: theme.colorScheme.primary,
            foregroundColor: Colors.white,
          ),
          child: _isSaving
              ? const SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(
                      strokeWidth: 2, color: Colors.white),
                )
              : const Text('SAVE'),
        ),
      ],
    );
  }

  Widget _buildLabel(String text, bool isDark) {
    return Text(
      text,
      style: TextStyle(
        fontSize: 10,
        fontWeight: FontWeight.bold,
        letterSpacing: 1.5,
        color: isDark ? Colors.grey.shade400 : Colors.grey.shade500,
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    required Color bgColor,
    required Color borderColor,
    bool obscure = false,
    TextInputType? keyboardType,
  }) {
    final theme = Theme.of(context);
    return TextField(
      controller: controller,
      obscureText: obscure,
      keyboardType: keyboardType,
      style: TextStyle(fontSize: 14, color: theme.colorScheme.onSurface),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 14),
        filled: true,
        fillColor: bgColor,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.zero,
          borderSide: BorderSide(color: borderColor),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.zero,
          borderSide: BorderSide(color: borderColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.zero,
          borderSide: BorderSide(color: theme.colorScheme.primary),
        ),
      ),
    );
  }
}

/// Card displaying a saved service with expand/edit capabilities
class _ServiceCard extends ConsumerStatefulWidget {
  final ServiceConfig config;
  final bool isExpanded;
  final VoidCallback onToggle;
  final VoidCallback onDelete;

  const _ServiceCard({
    required this.config,
    required this.isExpanded,
    required this.onToggle,
    required this.onDelete,
  });

  @override
  ConsumerState<_ServiceCard> createState() => _ServiceCardState();
}

class _ServiceCardState extends ConsumerState<_ServiceCard> {
  late final TextEditingController _hostController;
  late final TextEditingController _apiKeyController;
  late final TextEditingController _portController;
  bool _isObscured = true;
  bool _isTesting = false;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _hostController = TextEditingController(text: widget.config.url);
    _apiKeyController = TextEditingController(text: widget.config.apiKey ?? '');
    _portController = TextEditingController(
      text: widget.config.port?.toString() ?? '',
    );
  }

  @override
  void dispose() {
    _hostController.dispose();
    _apiKeyController.dispose();
    _portController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final borderColor = isDark ? Colors.grey.shade700 : Colors.grey.shade300;
    final cardColor = isDark ? const Color(0xFF151F28) : Colors.white;
    final inputBgColor = isDark ? const Color(0xFF1A2632) : Colors.grey.shade50;

    return Container(
      decoration: BoxDecoration(
        color: cardColor,
        border: Border.all(color: borderColor),
      ),
      child: Column(
        children: [
          // Header
          InkWell(
            onTap: widget.onToggle,
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: widget.isExpanded
                  ? BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          color:
                              isDark ? Colors.grey.shade800 : Colors.grey.shade200,
                        ),
                      ),
                    )
                  : null,
              child: Row(
                children: [
                  Icon(
                    _iconForType(widget.config.type),
                    color: widget.isExpanded
                        ? theme.colorScheme.primary
                        : (isDark ? Colors.grey.shade500 : Colors.grey.shade400),
                    size: 24,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _labelForType(widget.config.type).toUpperCase(),
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 0.5,
                            color: widget.isExpanded
                                ? theme.colorScheme.onSurface
                                : (isDark
                                    ? Colors.grey.shade300
                                    : Colors.grey.shade600),
                          ),
                        ),
                        if (widget.config.url.isNotEmpty)
                          Text(
                            widget.config.baseUrl,
                            style: TextStyle(
                              fontSize: 11,
                              color: isDark
                                  ? Colors.grey.shade500
                                  : Colors.grey.shade500,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                      ],
                    ),
                  ),
                  if (widget.config.isConfigured)
                    Container(
                      width: 8,
                      height: 8,
                      margin: const EdgeInsets.only(right: 8),
                      decoration: const BoxDecoration(
                        color: Colors.green,
                        shape: BoxShape.circle,
                      ),
                    ),
                  AnimatedRotation(
                    turns: widget.isExpanded ? 0.5 : 0,
                    duration: const Duration(milliseconds: 200),
                    child: Icon(
                      Icons.expand_more,
                      color: Colors.grey.shade400,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Expanded Content
          if (widget.isExpanded)
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildInputField(
                    label: 'HOST URL',
                    controller: _hostController,
                    hint: 'http://192.168.1.100',
                    backgroundColor: inputBgColor,
                    borderColor: borderColor,
                  ),
                  const SizedBox(height: 16),
                  _buildInputField(
                    label: 'API KEY',
                    controller: _apiKeyController,
                    hint: 'Enter your API key',
                    isPassword: true,
                    isObscured: _isObscured,
                    onToggleObscure: () {
                      setState(() => _isObscured = !_isObscured);
                    },
                    backgroundColor: inputBgColor,
                    borderColor: borderColor,
                  ),
                  const SizedBox(height: 16),
                  _buildInputField(
                    label: 'PORT NUMBER',
                    controller: _portController,
                    hint: '',
                    keyboardType: TextInputType.number,
                    backgroundColor: inputBgColor,
                    borderColor: borderColor,
                  ),
                  const SizedBox(height: 24),
                  Row(
                    children: [
                      // Test Connection
                      Expanded(
                        child: OutlinedButton(
                          onPressed: _isTesting ? null : _testConnection,
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            side: BorderSide(color: borderColor),
                            shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.zero,
                            ),
                          ),
                          child: _isTesting
                              ? const SizedBox(
                                  width: 16,
                                  height: 16,
                                  child: CircularProgressIndicator(
                                      strokeWidth: 2),
                                )
                              : Text(
                                  'TEST',
                                  style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 0.5,
                                    color: isDark
                                        ? Colors.grey.shade300
                                        : Colors.grey.shade700,
                                  ),
                                ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      // Save
                      Expanded(
                        child: ElevatedButton(
                          onPressed: _isSaving ? null : _saveConfiguration,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: theme.colorScheme.primary,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            elevation: 0,
                            shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.zero,
                            ),
                          ),
                          child: _isSaving
                              ? const SizedBox(
                                  width: 16,
                                  height: 16,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: Colors.white,
                                  ),
                                )
                              : const Text(
                                  'SAVE',
                                  style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 0.5,
                                  ),
                                ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      // Delete
                      IconButton(
                        onPressed: widget.onDelete,
                        icon: Icon(Icons.delete_outline,
                            color: Colors.red.shade400, size: 22),
                        tooltip: 'Delete service',
                      ),
                    ],
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildInputField({
    required String label,
    required TextEditingController controller,
    required String hint,
    bool isPassword = false,
    bool isObscured = false,
    VoidCallback? onToggleObscure,
    TextInputType? keyboardType,
    required Color backgroundColor,
    required Color borderColor,
  }) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.5,
            color: isDark ? Colors.grey.shade400 : Colors.grey.shade500,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          obscureText: isPassword && isObscured,
          keyboardType: keyboardType,
          style: TextStyle(
            fontSize: 14,
            color: theme.colorScheme.onSurface,
          ),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(
              color: Colors.grey.shade400,
              fontSize: 14,
            ),
            filled: true,
            fillColor: backgroundColor,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 14,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.zero,
              borderSide: BorderSide(color: borderColor),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.zero,
              borderSide: BorderSide(color: borderColor),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.zero,
              borderSide: BorderSide(color: theme.colorScheme.primary),
            ),
            suffixIcon: isPassword
                ? IconButton(
                    icon: Icon(
                      isObscured ? Icons.visibility_off : Icons.visibility,
                      size: 20,
                      color: Colors.grey.shade400,
                    ),
                    onPressed: onToggleObscure,
                  )
                : null,
          ),
        ),
      ],
    );
  }

  Future<void> _testConnection() async {
    if (_hostController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a Host URL')),
      );
      return;
    }

    setState(() => _isTesting = true);

    try {
      final config = ServiceConfig(
        key: widget.config.key,
        type: widget.config.type,
        name: widget.config.name,
        url: _hostController.text.trim(),
        apiKey: _apiKeyController.text.trim(),
        port: int.tryParse(_portController.text.trim()),
        isActive: true,
      );

      final success = await _testServiceConnection(config);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(success ? 'Connection successful!' : 'Connection failed'),
            backgroundColor: success ? Colors.green : Colors.red,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Connection failed: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isTesting = false);
    }
  }

  Future<void> _saveConfiguration() async {
    if (_hostController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a Host URL')),
      );
      return;
    }

    setState(() => _isSaving = true);

    try {
      final config = ServiceConfig(
        key: widget.config.key,
        type: widget.config.type,
        name: widget.config.name,
        url: _hostController.text.trim(),
        apiKey: _apiKeyController.text.trim(),
        port: int.tryParse(_portController.text.trim()),
        isActive: true,
      );

      await ref.read(serviceNotifierProvider.notifier).addService(config);
      ref.invalidate(allServicesProvider);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Configuration saved!'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to save: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }
}
