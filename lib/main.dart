import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:arr/core/database/hive_database.dart';
import 'package:arr/core/router/app_router.dart';
import 'package:arr/core/theme/app_theme.dart';
import 'package:arr/core/theme/theme_provider.dart';

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
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: themeMode,
      routerConfig: AppRouter.router,
    );
  }

}