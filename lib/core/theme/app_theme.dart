import 'package:flutter/material.dart';

/// Material 3 theme configuration for MedInvent
/// Follows guidelines from m3.material.io
class AppTheme {
  AppTheme._();

  // Seed color for dynamic color scheme generation
  static const Color seedColor = Color(0xFF1976D2);

  /// Light theme with Material 3 tonal surface colors
  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(
      seedColor: seedColor,
      brightness: Brightness.light,
    ),
    appBarTheme: const AppBarTheme(
      centerTitle: false,
      elevation: 0,
      scrolledUnderElevation: 0,
    ),
    cardTheme: CardTheme(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 16,
      ),
    ),
    bottomSheetTheme: const BottomSheetThemeData(
      showDragHandle: true,
      modalBackgroundColor: Color(0xFFF5F5F5),
    ),
    chipTheme: ChipThemeData(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      elevation: 2,
    ),
  );

  /// Dark theme with Material 3 tonal surface colors
  static ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(
      seedColor: seedColor,
      brightness: Brightness.dark,
    ),
    appBarTheme: const AppBarTheme(
      centerTitle: false,
      elevation: 0,
      scrolledUnderElevation: 0,
    ),
    cardTheme: CardTheme(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 16,
      ),
    ),
    bottomSheetTheme: const BottomSheetThemeData(
      showDragHandle: true,
    ),
    chipTheme: ChipThemeData(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      elevation: 2,
    ),
  );

  /// Get expiry status color based on days until expiry
  static Color getExpiryStatusColor(ColorScheme colorScheme, int daysUntilExpiry) {
    if (daysUntilExpiry < 0) {
      return colorScheme.error;
    } else if (daysUntilExpiry <= AppConstants.expiringVerySoonThresholdDays) {
      return Colors.amber;
    } else if (daysUntilExpiry <= AppConstants.expiringSoonThresholdDays) {
      return Colors.orange;
    } else {
      return colorScheme.primary;
    }
  }

  /// Get expiry status icon based on days until expiry
  static IconData getExpiryStatusIcon(int daysUntilExpiry) {
    if (daysUntilExpiry < 0) {
      return Icons.warning_rounded;
    } else if (daysUntilExpiry <= AppConstants.expiringVerySoonThresholdDays) {
      return Icons.access_time_rounded;
    } else if (daysUntilExpiry <= AppConstants.expiringSoonThresholdDays) {
      return Icons.schedule_rounded;
    } else {
      return Icons.check_circle_outline_rounded;
    }
  }

  /// Get expiry status label based on days until expiry
  static String getExpiryStatusLabel(int daysUntilExpiry) {
    if (daysUntilExpiry < 0) {
      return 'Expired';
    } else if (daysUntilExpiry == 0) {
      return 'Expires Today';
    } else if (daysUntilExpiry <= AppConstants.expiringVerySoonThresholdDays) {
      return 'Expiring Soon';
    } else if (daysUntilExpiry <= AppConstants.expiringSoonThresholdDays) {
      return 'Expiring Within 30 Days';
    } else {
      return 'Active';
    }
  }
}
