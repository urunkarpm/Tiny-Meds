import 'package:flutter/material.dart';

/// Utility functions for date formatting and manipulation
class DateUtils {
  DateUtils._();

  /// Format a DateTime to a readable string format
  static String formatDate(DateTime date) {
    return '${_getMonthName(date.month)} ${date.day}, ${date.year}';
  }

  /// Format a DateTime with time
  static String formatDateTime(DateTime dateTime) {
    final hour = dateTime.hour > 12 ? dateTime.hour - 12 : dateTime.hour;
    final period = dateTime.hour >= 12 ? 'PM' : 'AM';
    final minute = dateTime.minute.toString().padLeft(2, '0');
    return '${formatDate(dateTime)} at $hour:$minute $period';
  }

  /// Calculate days until expiry from a given date
  static int daysUntilExpiry(DateTime expiryDate) {
    final now = DateTime.now();
    final difference = expiryDate.difference(now);
    return difference.inDays;
  }

  /// Check if a date is in the past
  static bool isPastDate(DateTime date) {
    return date.isBefore(DateTime.now());
  }

  /// Get month name from month number
  static String _getMonthName(int month) {
    const months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December',
    ];
    return months[month - 1];
  }

  /// Parse expiry date from various string formats
  static DateTime? parseExpiryDate(String input) {
    // Try common expiry date formats
    final patterns = [
      RegExp(r'(\d{1,2})\/(\d{1,2})\/(\d{2,4})'), // MM/DD/YY or MM/DD/YYYY
      RegExp(r'(\d{1,2})-(\d{1,2})-(\d{2,4})'), // MM-DD-YY or MM-DD-YYYY
      RegExp(r'(\d{1,2})\.(\d{1,2})\.(\d{2,4})'), // MM.DD.YY
      RegExp(r'EXP[:\s]*(\w+)\s+(\d{1,2}),?\s+(\d{4})'), // EXP Month DD, YYYY
      RegExp(r'Expiry[:\s]*(\w+)\s+(\d{1,2}),?\s+(\d{4})'), // Expiry Month DD, YYYY
      RegExp(r'Use by[:\s]*(\w+)\s+(\d{1,2}),?\s+(\d{4})'), // Use by Month DD, YYYY
    ];

    for (final pattern in patterns) {
      final match = pattern.firstMatch(input);
      if (match != null) {
        try {
          if (pattern == patterns[0] || pattern == patterns[1] || pattern == patterns[2]) {
            // Numeric formats: MM/DD/YY or MM/DD/YYYY
            final month = int.parse(match.group(1)!);
            final day = int.parse(match.group(2)!);
            var year = int.parse(match.group(3)!);
            if (year < 100) {
              year += year < 50 ? 2000 : 1900;
            }
            return DateTime(year, month, day);
          } else {
            // Text formats: Month DD, YYYY
            final monthName = match.group(1)!;
            final day = int.parse(match.group(2)!);
            final year = int.parse(match.group(3)!);
            final month = _parseMonthName(monthName);
            if (month != null) {
              return DateTime(year, month, day);
            }
          }
        } catch (e) {
          continue;
        }
      }
    }
    return null;
  }

  /// Parse month name to month number
  static int? _parseMonthName(String name) {
    final monthNames = {
      'january': 1,
      'february': 2,
      'march': 3,
      'april': 4,
      'may': 5,
      'june': 6,
      'july': 7,
      'august': 8,
      'september': 9,
      'october': 10,
      'november': 11,
      'december': 12,
      'jan': 1,
      'feb': 2,
      'mar': 3,
      'apr': 4,
      'jun': 6,
      'jul': 7,
      'aug': 8,
      'sep': 9,
      'oct': 10,
      'nov': 11,
      'dec': 12,
    };
    return monthNames[name.toLowerCase()];
  }

  /// Validate that expiry date is not too far in the past
  static bool isValidExpiryDate(DateTime date) {
    // Allow dates up to 1 year in the past (for recently expired items)
    final oneYearAgo = DateTime.now().subtract(const Duration(days: 365));
    return !date.isBefore(oneYearAgo);
  }
}
