import 'package:flutter/material.dart';

/// App color palette - Minimalist/Swiss design inspired
class AppColors {
  // Light Theme Colors
  static const Color primary = Color(0xFF0066CC);
  static const Color onPrimary = Color(0xFFFFFFFF);
  static const Color secondary = Color(0xFF5C6BC0);
  static const Color onSecondary = Color(0xFFFFFFFF);

  static const Color background = Color(0xFFFAFAFA);
  static const Color onBackground = Color(0xFF121212);

  static const Color surface = Color(0xFFFFFFFF);
  static const Color onSurface = Color(0xFF121212);

  static const Color error = Color(0xFFB00020);
  static const Color onError = Color(0xFFFFFFFF);

  static const Color outline = Color(0xFFE0E0E0);
  static const Color outlineVariant = Color(0xFFF0F0F0);

  // Status Colors
  static const Color success = Color(0xFF4CAF50);
  static const Color warning = Color(0xFFFF9800);
  static const Color info = Color(0xFF2196F3);

  // Media Status Colors
  static const Color downloading = Color(0xFF2196F3);
  static const Color downloaded = Color(0xFF4CAF50);
  static const Color missing = Color(0xFFF44336);
  static const Color monitored = Color(0xFF4CAF50);
  static const Color unmonitored = Color(0xFF9E9E9E);

  // Dark Theme Colors
  static const Color darkPrimary = Color(0xFF4DABF5);
  static const Color onDarkPrimary = Color(0xFF003258);
  static const Color darkSecondary = Color(0xFF7986CB);
  static const Color onDarkSecondary = Color(0xFF1A237E);

  static const Color darkBackground = Color(0xFF121212);
  static const Color onDarkBackground = Color(0xFFE0E0E0);

  static const Color darkSurface = Color(0xFF1E1E1E);
  static const Color onDarkSurface = Color(0xFFE0E0E0);

  static const Color darkError = Color(0xFFCF6679);
  static const Color onDarkError = Color(0xFF000000);

  static const Color darkOutline = Color(0xFF424242);
  static const Color darkOutlineVariant = Color(0xFF2C2C2C);

  // Gradients
  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF0066CC), Color(0xFF5C6BC0)],
  );

  static const LinearGradient darkPrimaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF4DABF5), Color(0xFF7986CB)],
  );

  // Shimmer Loading Colors
  static const Color shimmerBase = Color(0xFFE0E0E0);
  static const Color shimmerHighlight = Color(0xFFF5F5F5);
  static const Color darkShimmerBase = Color(0xFF2C2C2C);
  static const Color darkShimmerHighlight = Color(0xFF3A3A3A);
}
