import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:arr/core/database/hive_database.dart';

enum AppThemeMode {
  system,
  light,
  dark,
}

class ThemeNotifier extends StateNotifier<AppThemeMode> {
  final Box settingsBox;
  static const String _themeKey = 'app_theme_mode';

  ThemeNotifier(this.settingsBox) : super(AppThemeMode.system) {
    _loadTheme();
  }

  void _loadTheme() {
    final savedTheme = settingsBox.get(_themeKey, defaultValue: 'system');
    state = AppThemeMode.values.firstWhere(
      (mode) => mode.name == savedTheme,
      orElse: () => AppThemeMode.system,
    );
  }

  Future<void> setTheme(AppThemeMode mode) async {
    state = mode;
    await settingsBox.put(_themeKey, mode.name);
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

final settingsBoxProvider = Provider<Box>((ref) {
  return Hive.box(HiveDatabase.settingsBox);
});

final themeProvider = StateNotifierProvider<ThemeNotifier, AppThemeMode>((ref) {
  final settingsBox = ref.watch(settingsBoxProvider);
  return ThemeNotifier(settingsBox);
});

final themeModeProvider = Provider<ThemeMode>((ref) {
  final themeNotifier = ref.watch(themeProvider.notifier);
  return themeNotifier.themeMode;
});