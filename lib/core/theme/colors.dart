import 'package:flutter/material.dart';

/// App color palette - Aligned with main.dart AppColors and HTML mockups
class AppColors {
  // ─── Primary ───
  static const Color primary = Color(0xFF1392EC);
  static const Color onPrimary = Color(0xFFFFFFFF);
  static const Color secondary = Color(0xFF1392EC);
  static const Color onSecondary = Color(0xFFFFFFFF);

  // ─── Light Theme ───
  static const Color background = Color(0xFFF6F7F8);
  static const Color onBackground = Color(0xFF0F172A);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color onSurface = Color(0xFF0F172A);
  static const Color error = Color(0xFFEF4444);
  static const Color onError = Color(0xFFFFFFFF);
  static const Color outline = Color(0xFFE2E8F0);
  static const Color outlineVariant = Color(0xFFF0F0F0);

  // ─── Dark Theme ───
  static const Color darkPrimary = Color(0xFF1392EC);
  static const Color onDarkPrimary = Color(0xFFFFFFFF);
  static const Color darkSecondary = Color(0xFF1392EC);
  static const Color onDarkSecondary = Color(0xFFFFFFFF);
  static const Color darkBackground = Color(0xFF101A22);
  static const Color onDarkBackground = Color(0xFFF1F5F9);
  static const Color darkSurface = Color(0xFF18242E);
  static const Color onDarkSurface = Color(0xFFF1F5F9);
  static const Color darkCard = Color(0xFF16202A);
  static const Color darkError = Color(0xFFEF4444);
  static const Color onDarkError = Color(0xFFFFFFFF);
  static const Color darkOutline = Color(0xFF2A3B4D);
  static const Color darkOutlineVariant = Color(0xFF1E2A36);

  // ─── Status Colors ───
  static const Color success = Color(0xFF22C55E);
  static const Color warning = Color(0xFFEAB308);
  static const Color info = Color(0xFF1392EC);

  // ─── Media Status ───
  static const Color downloading = Color(0xFF1392EC);
  static const Color downloaded = Color(0xFF22C55E);
  static const Color missing = Color(0xFFEF4444);
  static const Color monitored = Color(0xFF22C55E);
  static const Color unmonitored = Color(0xFF94A3B8);

  // ─── Shimmer Loading ───
  static const Color shimmerBase = Color(0xFFE2E8F0);
  static const Color shimmerHighlight = Color(0xFFF1F5F9);
  static const Color darkShimmerBase = Color(0xFF1E2A36);
  static const Color darkShimmerHighlight = Color(0xFF2A3B4D);
}
