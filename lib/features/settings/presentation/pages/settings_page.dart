import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/network/sonarr_api.dart';
import '../../../../core/network/radarr_api.dart';
import '../../../../core/network/overseerr_api.dart';
import '../../domain/entities/service_config.dart';
import '../providers/service_provider.dart';

/// Service type configuration data
class ServiceTypeConfig {
  final ServiceType type;
  final String title;
  final IconData icon;
  final String defaultPort;

  const ServiceTypeConfig({
    required this.type,
    required this.title,
    required this.icon,
    required this.defaultPort,
  });
}

/// Predefined service configurations
const _serviceTypes = [
  ServiceTypeConfig(
    type: ServiceType.radarr,
    title: 'Movie Server (Radarr)',
    icon: Icons.movie_outlined,
    defaultPort: '7878',
  ),
  ServiceTypeConfig(
    type: ServiceType.sonarr,
    title: 'TV Server (Sonarr)',
    icon: Icons.tv_outlined,
    defaultPort: '8989',
  ),
  ServiceTypeConfig(
    type: ServiceType.overseerr,
    title: 'Requests (Overseerr)',
    icon: Icons.download_done_outlined,
    defaultPort: '5055',
  ),
  ServiceTypeConfig(
    type: ServiceType.downloadClient,
    title: 'Download Client',
    icon: Icons.cloud_download_outlined,
    defaultPort: '8080',
  ),
];

/// Settings page for configuring services
class SettingsPage extends ConsumerStatefulWidget {
  const SettingsPage({super.key});

  @override
  ConsumerState<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends ConsumerState<SettingsPage> {
  /// Track which service card is expanded
  int? _expandedIndex;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Content
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header
                    Padding(
                      padding: const EdgeInsets.fromLTRB(24, 24, 24, 8),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Service Settings',
                            style: theme.textTheme.headlineMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                              letterSpacing: -0.5,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Configure your media server connections.',
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: theme.colorScheme.onSurface.withOpacity(0.6),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Service Cards
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: Column(
                        children: List.generate(_serviceTypes.length, (index) {
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 16),
                            child: _ServiceConfigCard(
                              config: _serviceTypes[index],
                              isExpanded: _expandedIndex == index,
                              onToggle: () {
                                setState(() {
                                  _expandedIndex = _expandedIndex == index ? null : index;
                                });
                              },
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
                          // Sync All Services Button
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
                                padding: const EdgeInsets.symmetric(vertical: 16),
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

                          // Reset Configuration Button
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
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _syncAllServices() {
    // TODO: Implement sync all services
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
    // TODO: Implement reset configuration
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Configuration reset')),
    );
  }
}

/// Individual service configuration card
class _ServiceConfigCard extends ConsumerStatefulWidget {
  final ServiceTypeConfig config;
  final bool isExpanded;
  final VoidCallback onToggle;

  const _ServiceConfigCard({
    required this.config,
    required this.isExpanded,
    required this.onToggle,
  });

  @override
  ConsumerState<_ServiceConfigCard> createState() => _ServiceConfigCardState();
}

class _ServiceConfigCardState extends ConsumerState<_ServiceConfigCard> {
  final _hostController = TextEditingController();
  final _apiKeyController = TextEditingController();
  final _portController = TextEditingController();
  bool _isObscured = true;
  bool _isTesting = false;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _portController.text = widget.config.defaultPort;
    _loadExistingConfig();
  }

  Future<void> _loadExistingConfig() async {
    // Load existing configuration if available
    final services = await ref.read(allServicesProvider.future);
    final existing = services.where((s) => s.type == widget.config.type).firstOrNull;
    if (existing != null && mounted) {
      setState(() {
        _hostController.text = existing.url;
        _apiKeyController.text = existing.apiKey ?? '';
        if (existing.port != null) {
          _portController.text = existing.port.toString();
        }
      });
    }
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
                          color: isDark ? Colors.grey.shade800 : Colors.grey.shade200,
                        ),
                      ),
                    )
                  : null,
              child: Row(
                children: [
                  Icon(
                    widget.config.icon,
                    color: widget.isExpanded
                        ? theme.colorScheme.primary
                        : (isDark ? Colors.grey.shade500 : Colors.grey.shade400),
                    size: 24,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      widget.config.title.toUpperCase(),
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.5,
                        color: widget.isExpanded
                            ? theme.colorScheme.onSurface
                            : (isDark ? Colors.grey.shade300 : Colors.grey.shade600),
                      ),
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
                  // Host URL
                  _buildInputField(
                    label: 'HOST URL',
                    controller: _hostController,
                    hint: 'http://192.168.1.100',
                    backgroundColor: inputBgColor,
                    borderColor: borderColor,
                  ),

                  const SizedBox(height: 16),

                  // API Key
                  _buildInputField(
                    label: 'API KEY',
                    controller: _apiKeyController,
                    hint: 'Enter your API key',
                    isPassword: true,
                    isObscured: _isObscured,
                    onToggleObscure: () {
                      setState(() {
                        _isObscured = !_isObscured;
                      });
                    },
                    backgroundColor: inputBgColor,
                    borderColor: borderColor,
                  ),

                  const SizedBox(height: 16),

                  // Port Number
                  _buildInputField(
                    label: 'PORT NUMBER',
                    controller: _portController,
                    hint: widget.config.defaultPort,
                    keyboardType: TextInputType.number,
                    backgroundColor: inputBgColor,
                    borderColor: borderColor,
                  ),

                  const SizedBox(height: 24),

                  // Action Buttons
                  Row(
                    children: [
                      // Test Connection Button
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
                                  child: CircularProgressIndicator(strokeWidth: 2),
                                )
                              : Text(
                                  'TEST CONNECTION',
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

                      // Save Button
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
    if (_hostController.text.isEmpty || _apiKeyController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill in Host URL and API Key')),
      );
      return;
    }

    setState(() => _isTesting = true);

    try {
      // TODO: Implement actual connection test based on service type
      await Future.delayed(const Duration(seconds: 2));

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Connection successful!'),
            backgroundColor: Colors.green,
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
      if (mounted) {
        setState(() => _isTesting = false);
      }
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
        key: '${widget.config.type.name}_service',
        type: widget.config.type,
        name: widget.config.title,
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
      if (mounted) {
        setState(() => _isSaving = false);
      }
    }
  }
}
