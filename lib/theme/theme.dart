import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,

      colorScheme: const ColorScheme.light(
        primary: Color(0xFFD95D39), // Terracotta (Buttons, Primary Brand)
        onPrimary: Color(0xFFFFFFFF), // Text on top of Terracotta
        secondary: Color(0xFF6E8E75), // Sage Green (Promo badges, discounts)
        onSecondary: Color(0xFFFFFFFF), // Text on top of Sage
        // Material 3 Tone-Based Surface Overrides
        surface: Color(0xFFF9F6F0), // Main App Canvas Background
        onSurface: Color(0xFF2C2C2C), // Global Text & Icons

        surfaceContainer: Color(
          0xFFF1EAE0,
        ), // Product Cards, Bottom Sheets, Search Bars
        surfaceContainerLow: Color(
          0xFFEFEAE2,
        ), // Slightly deeper container padding
      ),

      appBarTheme: const AppBarTheme(
        backgroundColor: Color(0xFFF9F6F0),
        elevation: 0,
        scrolledUnderElevation: 0, // Prevents sudden color shifts on scroll
        iconTheme: IconThemeData(color: Color(0xFF2C2C2C)),
      ),

      cardTheme: const CardThemeData(
        color: Color(0xFFF1EAE0),
        elevation:
            0, // Material 3 uses color tones instead of shadows to show depth
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(16)),
        ),
      ),
    );
  }
}
