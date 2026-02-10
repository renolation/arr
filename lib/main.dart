import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:arr/core/database/hive_database.dart';
import 'package:arr/core/router/app_router.dart';
import 'package:arr/providers/theme_provider.dart';

// App Color Palette - Matching HTML Design Specifications
class AppColors {
  // Primary color from HTML (#1392ec)
  static const Color primary = Color(0xFF1392EC);

  // Light theme colors
  static const Color backgroundLight = Color(0xFFF6F7F8); // #f6f7f8
  static const Color surfaceLight = Color(0xFFFFFFFF); // #ffffff
  static const Color borderLight = Color(0xFFE2E8F0);

  // Dark theme colors
  static const Color backgroundDark = Color(0xFF101A22); // #101a22
  static const Color surfaceDark = Color(0xFF18242E); // #18242e
  static const Color cardDark = Color(0xFF16202A); // #16202a
  static const Color borderDark = Color(0xFF2A3B4D); // #2a3b4d

  // Status colors
  static const Color accentGreen = Color(0xFF22C55E); // #22c55e
  static const Color accentYellow = Color(0xFFEAB308); // #eab308
  static const Color accentRed = Color(0xFFEF4444); // #ef4444

  // Text colors
  static const Color textPrimaryLight = Color(0xFF0F172A);
  static const Color textSecondaryLight = Color(0xFF64748B);
  static const Color textPrimaryDark = Color(0xFFF1F5F9);
  static const Color textSecondaryDark = Color(0xFF94A3B8);
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Hive database
  // Note: Set clearOldData to true only during development when schema changes
  await HiveDatabase.init(clearOldData: false);

  runApp(
    const ProviderScope(
      child: ArrApp(),
    ),
  );
}

class ArrApp extends ConsumerWidget {
  const ArrApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeProvider);
    return MaterialApp.router(
      title: '*arr Stack Manager',
      debugShowCheckedModeBanner: false,
      theme: _lightTheme,
      darkTheme: _darkTheme,
      themeMode: themeMode,
      routerConfig: AppRouter.router,
    );
  }

  // Light Theme Configuration - Matching HTML Design
  static final ThemeData _lightTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    colorScheme: ColorScheme.light(
      primary: AppColors.primary,
      onPrimary: Colors.white,
      primaryContainer: AppColors.primary.withOpacity(0.1),
      onPrimaryContainer: AppColors.primary,
      secondary: AppColors.primary,
      onSecondary: Colors.white,
      error: AppColors.accentRed,
      onError: Colors.white,
      background: AppColors.backgroundLight,
      onBackground: AppColors.textPrimaryLight,
      surface: AppColors.surfaceLight,
      onSurface: AppColors.textPrimaryLight,
      surfaceVariant: AppColors.backgroundLight,
      onSurfaceVariant: AppColors.textSecondaryLight,
      outline: AppColors.borderLight,
    ),
    scaffoldBackgroundColor: AppColors.backgroundLight,
    appBarTheme: AppBarTheme(
      backgroundColor: AppColors.backgroundLight.withOpacity(0.95),
      foregroundColor: AppColors.textPrimaryLight,
      elevation: 0,
      centerTitle: false,
      titleTextStyle: const TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.bold,
        letterSpacing: -0.5,
        color: AppColors.textPrimaryLight,
      ),
    ),
    cardTheme: CardThemeData(
      color: AppColors.surfaceLight,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(4), // 0.25rem
        side: const BorderSide(color: AppColors.borderLight, width: 1),
      ),
    ),
    navigationBarTheme: NavigationBarThemeData(
      backgroundColor: AppColors.surfaceLight,
      elevation: 0,
      indicatorColor: AppColors.primary.withOpacity(0.1),
      labelTextStyle: WidgetStateProperty.all(
        const TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
      ),
    ),
    chipTheme: ChipThemeData(
      backgroundColor: AppColors.backgroundLight,
      selectedColor: AppColors.backgroundDark,
      labelStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(9999), // full
      ),
    ),
  );

  // Dark Theme Configuration - Matching HTML Design
  static final ThemeData _darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    colorScheme: ColorScheme.dark(
      primary: AppColors.primary,
      onPrimary: Colors.white,
      primaryContainer: AppColors.primary.withOpacity(0.1),
      onPrimaryContainer: AppColors.primary,
      secondary: AppColors.primary,
      onSecondary: Colors.white,
      error: AppColors.accentRed,
      onError: Colors.white,
      background: AppColors.backgroundDark,
      onBackground: AppColors.textPrimaryDark,
      surface: AppColors.surfaceDark,
      onSurface: AppColors.textPrimaryDark,
      surfaceVariant: AppColors.cardDark,
      onSurfaceVariant: AppColors.textSecondaryDark,
      outline: AppColors.borderDark,
    ),
    scaffoldBackgroundColor: AppColors.backgroundDark,
    appBarTheme: AppBarTheme(
      backgroundColor: AppColors.backgroundDark.withOpacity(0.95),
      foregroundColor: AppColors.textPrimaryDark,
      elevation: 0,
      centerTitle: false,
      titleTextStyle: const TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.bold,
        letterSpacing: -0.5,
        color: AppColors.textPrimaryDark,
      ),
    ),
    cardTheme: CardThemeData(
      color: AppColors.cardDark,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(4), // 0.25rem
        side: const BorderSide(color: AppColors.borderDark, width: 1),
      ),
    ),
    navigationBarTheme: NavigationBarThemeData(
      backgroundColor: AppColors.surfaceDark,
      elevation: 0,
      indicatorColor: AppColors.primary.withOpacity(0.1),
      labelTextStyle: WidgetStateProperty.all(
        const TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
      ),
    ),
    chipTheme: ChipThemeData(
      backgroundColor: AppColors.surfaceDark,
      selectedColor: AppColors.backgroundDark,
      labelStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(9999), // full
      ),
    ),
  );
}