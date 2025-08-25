import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:arr/core/database/hive_database.dart';
import 'package:arr/core/router/app_router.dart';
import 'package:arr/providers/theme_provider.dart';

// App Color Palette
class AppColors {
  // Light theme - Green palette
  static const Color lightestGreen = Color(0xFFECFAE5);   // #ECFAE5 - Lightest green
  static const Color lightGreen = Color(0xFFDDF6D2);      // #DDF6D2 - Light green
  static const Color mediumLightGreen = Color(0xFFCAE8BD); // #CAE8BD - Medium light green
  static const Color mediumGreen = Color(0xFFB0DB9C);     // #B0DB9C - Medium green
  
  // Dark theme - Deep forest/emerald green tones
  static const Color deepForestGreen = Color(0xFF0A2A1A); // Deep forest background
  static const Color forestGreen = Color(0xFF1A4A2E);     // Forest green surface
  static const Color emeraldGreen = Color(0xFF2E7D47);    // Emerald green primary
  static const Color darkEmerald = Color(0xFF1F5F35);     // Dark emerald variant
  static const Color mintGreen = Color(0xFF7FD99F);       // Mint green accent
  
  // Neutral colors for text and surfaces
  static const Color nearBlack = Color(0xFF0D1F14);       // Very dark green-tinted black
  static const Color nearWhite = Color(0xFFFAFDFA);       // Very light green-tinted white
  static const Color mediumGray = Color(0xFF6B8471);      // Green-tinted gray
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Hive database
  await HiveDatabase.init();
  
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

  // Light Theme Configuration
  static final ThemeData _lightTheme = ThemeData(
    colorScheme:  ColorScheme.light(
      // Primary colors - medium green as primary
      primary: AppColors.mediumGreen,
      onPrimary: AppColors.nearBlack,
      primaryContainer: AppColors.lightGreen,
      onPrimaryContainer: AppColors.nearBlack,
      
      // Secondary colors - medium light green for accents
      secondary: AppColors.mediumLightGreen,
      onSecondary: AppColors.nearBlack,
      secondaryContainer: AppColors.lightestGreen,
      onSecondaryContainer: AppColors.nearBlack,
      
      // Tertiary colors - deeper green variations
      tertiary: AppColors.mediumLightGreen,
      onTertiary: AppColors.nearBlack,
      tertiaryContainer: AppColors.lightGreen,
      onTertiaryContainer: AppColors.nearBlack,
      
      // Error colors
      error: Colors.red.shade600,
      onError: Colors.white,
      errorContainer: Colors.red.shade100,
      onErrorContainer: Colors.red.shade800,
      
      // Surface colors - lightest green as main background
      surface: AppColors.lightestGreen,
      onSurface: AppColors.nearBlack,
      surfaceVariant: AppColors.lightGreen,
      onSurfaceVariant: AppColors.nearBlack,
      
      // Background
      background: AppColors.lightestGreen,
      onBackground: AppColors.nearBlack,
      
      // Outline and shadow
      outline: AppColors.mediumGreen,
      shadow: AppColors.nearBlack.withOpacity(0.1),
    ),
    useMaterial3: true,
    navigationBarTheme: NavigationBarThemeData(
      backgroundColor: AppColors.mediumGreen.withOpacity(0.95),
      indicatorColor: AppColors.lightGreen,
      surfaceTintColor: Colors.transparent,
    ),
  );

  // Dark Theme Configuration
  static final ThemeData _darkTheme = ThemeData(
    colorScheme:  ColorScheme.dark(
      // Primary colors - emerald green as primary
      primary: AppColors.emeraldGreen,
      onPrimary: AppColors.nearWhite,
      primaryContainer: AppColors.darkEmerald,
      onPrimaryContainer: AppColors.mintGreen,
      
      // Secondary colors - mint green for accents
      secondary: AppColors.mintGreen,
      onSecondary: AppColors.nearBlack,
      secondaryContainer: AppColors.forestGreen,
      onSecondaryContainer: AppColors.mintGreen,
      
      // Tertiary colors - forest green variations
      tertiary: AppColors.forestGreen,
      onTertiary: AppColors.nearWhite,
      tertiaryContainer: AppColors.darkEmerald,
      onTertiaryContainer: AppColors.mintGreen,
      
      // Error colors
      error: Colors.red.shade300,
      onError: Colors.red.shade900,
      errorContainer: Colors.red.shade900,
      onErrorContainer: Colors.red.shade100,
      
      // Surface colors - deep forest green background
      surface: AppColors.deepForestGreen,
      onSurface: AppColors.nearWhite,
      surfaceVariant: AppColors.forestGreen,
      onSurfaceVariant: AppColors.nearWhite,
      
      // Background
      background: AppColors.deepForestGreen,
      onBackground: AppColors.nearWhite,
      
      // Outline and shadow
      outline: AppColors.emeraldGreen,
      shadow: Colors.black.withOpacity(0.4),
    ),
    useMaterial3: true,
    navigationBarTheme: NavigationBarThemeData(
      backgroundColor: AppColors.forestGreen.withOpacity(0.95),
      indicatorColor: AppColors.emeraldGreen,
      surfaceTintColor: Colors.transparent,
    ),
  );
}