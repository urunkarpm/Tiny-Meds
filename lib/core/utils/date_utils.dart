import 'package:intl/intl.dart';

/// Utilities for common date formatting and calculations
class AppDateUtils {
  AppDateUtils._();

  /// Format a DateTime into a readable string (e.g., "Jan 12, 2024")
  static String formatShortDate(DateTime date) {
    return DateFormat.yMMMd().format(date);
  }

  /// Format a DateTime into a longer string (e.g., "Monday, Jan 12")
  static String formatLongDate(DateTime date) {
    return DateFormat.yMMMMEEEEd().format(date);
  }

  /// Get relative time string (e.g., "Expires in 3 days", "Expired 2 days ago")
  static String getRelativeTimeString(DateTime date) {
    final now = DateTime.now();
    final difference = date.difference(now).inDays;

    if (difference < 0) {
      final absDiff = difference.abs();
      if (absDiff == 0) return 'Expired today';
      return 'Expired $absDiff ${absDiff == 1 ? 'day' : 'days'} ago';
    } else if (difference == 0) {
      return 'Expires today';
    } else {
      return 'Expires in $difference ${difference == 1 ? 'day' : 'days'}';
    }
  }

  /// Check if two dates are on the same day
  static bool isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
  }

  /// Check if a date is today
  static bool isToday(DateTime date) {
    return isSameDay(date, DateTime.now());
  }

  /// Get the start of the day for a DateTime
  static DateTime startOfDay(DateTime date) {
    return DateTime(date.year, date.month, date.day);
  }

  /// Calculate age from birth date (useful if adding patient profiles later)
  static int calculateAge(DateTime birthDate) {
    final now = DateTime.now();
    int age = now.year - birthDate.year;
    if (now.month < birthDate.month ||
        (now.month == birthDate.month && now.day < birthDate.day)) {
      age--;
    }
    return age;
  }
}
