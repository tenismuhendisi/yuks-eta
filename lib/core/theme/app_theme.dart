import 'package:flutter/material.dart';

/// ETA Tenis logo renkleri: tenis topu yeşili + lacivert.
abstract final class AppColors {
  static const lime = Color(0xFFB8D600);
  static const limeDark = Color(0xFF9BB800);
  static const navy = Color(0xFF0B1C2C);
  static const navyMuted = Color(0xFF1A2F42);
  static const surface = Color(0xFFF7F8F5);
  static const onLime = Color(0xFF0B1C2C);
}

class AppTheme {
  static ThemeData get light {
    final scheme = ColorScheme.fromSeed(
      seedColor: AppColors.lime,
      primary: AppColors.lime,
      onPrimary: AppColors.onLime,
      secondary: AppColors.navy,
      onSecondary: Colors.white,
      surface: AppColors.surface,
      onSurface: AppColors.navy,
      brightness: Brightness.light,
    ).copyWith(
      primaryContainer: const Color(0xFFE8F5A0),
      onPrimaryContainer: AppColors.navy,
      secondaryContainer: const Color(0xFFD6DEE6),
      onSecondaryContainer: AppColors.navy,
      outline: const Color(0xFFB0B8C0),
    );

    return ThemeData(
      colorScheme: scheme,
      useMaterial3: true,
      scaffoldBackgroundColor: AppColors.surface,
      appBarTheme: const AppBarTheme(
        centerTitle: false,
        elevation: 0,
        backgroundColor: AppColors.navy,
        foregroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.white),
        actionsIconTheme: IconThemeData(color: Colors.white),
        titleTextStyle: TextStyle(
          color: Colors.white,
          fontSize: 18,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.3,
        ),
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: Colors.white,
        indicatorColor: AppColors.lime.withValues(alpha: 0.35),
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          final selected = states.contains(WidgetState.selected);
          return TextStyle(
            fontSize: 12,
            fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
            color: selected ? AppColors.navy : AppColors.navyMuted,
          );
        }),
        iconTheme: WidgetStateProperty.resolveWith((states) {
          final selected = states.contains(WidgetState.selected);
          return IconThemeData(
            color: selected ? AppColors.navy : AppColors.navyMuted,
          );
        }),
      ),
      chipTheme: ChipThemeData(
        selectedColor: AppColors.lime.withValues(alpha: 0.45),
        checkmarkColor: AppColors.navy,
        labelStyle: const TextStyle(color: AppColors.navy),
        side: BorderSide(color: AppColors.navy.withValues(alpha: 0.15)),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: AppColors.lime,
          foregroundColor: AppColors.onLime,
          textStyle: const TextStyle(fontWeight: FontWeight.w700),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.lime,
          foregroundColor: AppColors.onLime,
        ),
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: AppColors.lime,
        foregroundColor: AppColors.onLime,
      ),
      cardTheme: CardThemeData(
        elevation: 0,
        color: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(color: AppColors.navy.withValues(alpha: 0.08)),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        filled: true,
        fillColor: Colors.white,
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: AppColors.limeDark, width: 2),
        ),
      ),
      progressIndicatorTheme: const ProgressIndicatorThemeData(
        color: AppColors.limeDark,
      ),
      dividerTheme: DividerThemeData(
        color: AppColors.navy.withValues(alpha: 0.1),
      ),
    );
  }
}
