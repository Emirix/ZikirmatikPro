import 'package:flutter/material.dart';

enum AppThemeMode { green, light, darkBlue }

class AppTheme {
  final AppThemeMode mode;
  final Color primary;
  final Color background;
  final Color surface;
  final Color textPrimary;
  final Color textSecondary;

  AppTheme({
    required this.mode,
    required this.primary,
    required this.background,
    required this.surface,
    required this.textPrimary,
    required this.textSecondary,
  });

  static AppTheme getTheme(AppThemeMode mode) {
    switch (mode) {
      case AppThemeMode.light:
        return AppTheme(
          mode: AppThemeMode.light,
          primary: const Color(0xFF13EC5B),
          background: const Color(0xFFF8FAFC),
          surface: Colors.white,
          textPrimary: const Color(0xFF1E293B),
          textSecondary: const Color(0xFF64748B),
        );
      case AppThemeMode.darkBlue:
        return AppTheme(
          mode: AppThemeMode.darkBlue,
          primary: const Color(0xFF13EC5B),
          background: const Color(0xFF0F172A),
          surface: const Color(0xFF1E293B),
          textPrimary: Colors.white,
          textSecondary: const Color(0xFF94A3B8),
        );
      case AppThemeMode.green:
        return AppTheme(
          mode: AppThemeMode.green,
          primary: const Color(0xFF13EC5B),
          background: const Color(0xFF102216),
          surface: const Color(0xFF193322),
          textPrimary: Colors.white,
          textSecondary: const Color(0xFF94A3B8),
        );
    }
  }

  ThemeData toThemeData() {
    final isDark = mode != AppThemeMode.light;
    return ThemeData(
      useMaterial3: true,
      brightness: isDark ? Brightness.dark : Brightness.light,
      primaryColor: primary,
      scaffoldBackgroundColor: background,
      colorScheme: ColorScheme.fromSeed(
        seedColor: primary,
        primary: primary,
        surface: background,
        onSurface: textPrimary,
        brightness: isDark ? Brightness.dark : Brightness.light,
      ),
      cardTheme: const CardThemeData(elevation: 0),
      textTheme: TextTheme(
        displayLarge: TextStyle(
          color: textPrimary,
          fontWeight: FontWeight.bold,
        ),
        bodyLarge: TextStyle(color: textPrimary),
        bodyMedium: TextStyle(color: textSecondary),
      ),
    );
  }
}
