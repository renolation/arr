import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:arr/core/database/hive_database.dart';
import 'package:arr/models/hive/models.dart';

enum AppThemeMode {
  system,
  light,
  dark,
}

class ThemeNotifier extends StateNotifier<AppThemeMode> {
  static const String _settingsKey = 'app_settings';
  final Box<AppSettings> _settingsBox;

  ThemeNotifier(this._settingsBox) : super(AppThemeMode.system) {
    _loadTheme();
  }

  void _loadTheme() {
    final settings = _settingsBox.get(_settingsKey);
    final savedTheme = settings?.themeMode ?? 'system';
    state = AppThemeMode.values.firstWhere(
      (mode) => mode.name == savedTheme,
      orElse: () => AppThemeMode.system,
    );
  }

  Future<void> setTheme(AppThemeMode mode) async {
    state = mode;
    final current = _settingsBox.get(_settingsKey) ?? AppSettings.defaultSettings;
    await _settingsBox.put(_settingsKey, current.copyWith(themeMode: mode.name));
  }

  ThemeMode get themeMode {
    switch (state) {
      case AppThemeMode.light:
        return ThemeMode.light;
      case AppThemeMode.dark:
        return ThemeMode.dark;
      case AppThemeMode.system:
        return ThemeMode.system;
    }
  }
}

final settingsBoxProvider = Provider<Box<AppSettings>>((ref) {
  return HiveDatabase.settings;
});

final themeProvider = StateNotifierProvider<ThemeNotifier, AppThemeMode>((ref) {
  final settingsBox = ref.watch(settingsBoxProvider);
  return ThemeNotifier(settingsBox);
});

final themeModeProvider = Provider<ThemeMode>((ref) {
  final themeNotifier = ref.watch(themeProvider.notifier);
  return themeNotifier.themeMode;
});