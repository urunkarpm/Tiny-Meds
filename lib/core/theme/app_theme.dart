import 'package:flutter/material.dart';
import '../constants/app_constants.dart';

/// Material 3 theme configuration for Tiny-Meds
/// Follows guidelines from m3.material.io with enhanced UX
class AppTheme {
  AppTheme._();

  // Seed color for dynamic color scheme generation - Calming healthcare blue
  static const Color seedColor = Color(0xFF0A84FF);

  /// Light theme with Material 3 tonal surface colors and enhanced UX
  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(
      seedColor: seedColor,
      brightness: Brightness.light,
      surface: const Color(0xFFF8F9FA),
      surfaceContainerHighest: const Color(0xFFF1F3F5),
    ),
    appBarTheme: AppBarTheme(
      centerTitle: false,
      elevation: 0,
      scrolledUnderElevation: 2,
      surfaceTintColor: Colors.transparent,
      titleTextStyle: const TextStyle(
        fontSize: 22,
        fontWeight: FontWeight.w600,
        height: 1.3,
      ),
    ),
    cardTheme: CardThemeData(
      elevation: 0,
      shadowColor: Colors.black.withValues(alpha: 0.08),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.grey.shade300),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.grey.shade300),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: seedColor, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.red, width: 1),
      ),
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 16,
      ),
      filled: true,
      fillColor: Colors.white,
    ),
    bottomSheetTheme: const BottomSheetThemeData(
      showDragHandle: true,
      modalBackgroundColor: Color(0xFFF8F9FA),
      dragHandleColor: Color(0xFFD1D5DB),
      dragHandleSize: Size(40, 4),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
    ),
    chipTheme: ChipThemeData(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      labelStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      elevation: 4,
      hoverElevation: 6,
      pressElevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(16)),
      ),
    ),
    dialogTheme: DialogThemeData(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      elevation: 0,
    ),
    snackBarTheme: SnackBarThemeData(
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
    ),
  );

  /// Dark theme with Material 3 tonal surface colors and enhanced UX
  static ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(
      seedColor: seedColor,
      brightness: Brightness.dark,
      surface: const Color(0xFF121212),
      surfaceContainerHighest: const Color(0xFF2C2C2C),
    ),
    appBarTheme: AppBarTheme(
      centerTitle: false,
      elevation: 0,
      scrolledUnderElevation: 2,
      surfaceTintColor: Colors.transparent,
      titleTextStyle: const TextStyle(
        fontSize: 22,
        fontWeight: FontWeight.w600,
        height: 1.3,
      ),
    ),
    cardTheme: CardThemeData(
      elevation: 0,
      shadowColor: Colors.black.withValues(alpha: 0.3),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.grey.shade700),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.grey.shade700),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: seedColor, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.red, width: 1),
      ),
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 16,
      ),
      filled: true,
      fillColor: Colors.white.withValues(alpha: 0.05),
    ),
    bottomSheetTheme: const BottomSheetThemeData(
      showDragHandle: true,
      dragHandleColor: Color(0xFF4B5563),
      dragHandleSize: Size(40, 4),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
    ),
    chipTheme: ChipThemeData(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      labelStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      elevation: 4,
      hoverElevation: 6,
      pressElevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(16)),
      ),
    ),
    dialogTheme: DialogThemeData(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      elevation: 0,
    ),
    snackBarTheme: SnackBarThemeData(
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
    ),
  );

  /// Get expiry status color based on days until expiry
  static Color getExpiryStatusColor(ColorScheme colorScheme, int daysUntilExpiry) {
    if (daysUntilExpiry < 0) {
      return colorScheme.error;
    } else if (daysUntilExpiry == 0) {
      return Colors.red;
    } else if (daysUntilExpiry <= AppConstants.expiringVerySoonThresholdDays) {
      return const Color(0xFFFF9800); // Amber
    } else if (daysUntilExpiry <= AppConstants.expiringSoonThresholdDays) {
      return const Color(0xFFFFA726); // Light amber
    } else {
      return colorScheme.primary;
    }
  }

  /// Get expiry status icon based on days until expiry
  static IconData getExpiryStatusIcon(int daysUntilExpiry) {
    if (daysUntilExpiry < 0) {
      return Icons.warning_rounded;
    } else if (daysUntilExpiry == 0) {
      return Icons.error_outline_rounded;
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
