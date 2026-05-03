import 'package:flutter_test/flutter_test.dart';
import 'package:tiny_meds/core/utils/date_utils.dart';

void main() {
  group('DateUtils', () {
    group('daysUntilExpiry', () {
      test('returns positive number for future date', () {
        final futureDate = DateTime.now().add(const Duration(days: 30));
        final result = DateUtils.daysUntilExpiry(futureDate);
        expect(result, equals(30));
      });

      test('returns negative number for past date', () {
        final pastDate = DateTime.now().subtract(const Duration(days: 5));
        final result = DateUtils.daysUntilExpiry(pastDate);
        expect(result, equals(-5));
      });

      test('returns 0 for today', () {
        final today = DateTime.now();
        final result = DateUtils.daysUntilExpiry(today);
        expect(result, equals(0));
      });
    });

    group('isPastDate', () {
      test('returns true for past date', () {
        final pastDate = DateTime.now().subtract(const Duration(days: 1));
        expect(DateUtils.isPastDate(pastDate), isTrue);
      });

      test('returns false for future date', () {
        final futureDate = DateTime.now().add(const Duration(days: 1));
        expect(DateUtils.isPastDate(futureDate), isFalse);
      });

      test('returns false for current date', () {
        final now = DateTime.now();
        expect(DateUtils.isPastDate(now), isFalse);
      });
    });

    group('formatDate', () {
      test('formats date correctly', () {
        final date = DateTime(2024, 3, 15);
        final result = DateUtils.formatDate(date);
        expect(result, equals('March 15, 2024'));
      });
    });

    group('parseExpiryDate', () {
      test('parses MM/DD/YYYY format', () {
        final result = DateUtils.parseExpiryDate('12/25/2025');
        expect(result, equals(DateTime(2025, 12, 25)));
      });

      test('parses MM-DD-YY format', () {
        final result = DateUtils.parseExpiryDate('06-15-26');
        expect(result, equals(DateTime(2026, 6, 15)));
      });

      test('parses EXP Month DD, YYYY format', () {
        final result = DateUtils.parseExpiryDate('EXP March 15, 2027');
        expect(result, equals(DateTime(2027, 3, 15)));
      });

      test('returns null for invalid format', () {
        final result = DateUtils.parseExpiryDate('invalid date');
        expect(result, isNull);
      });
    });

    group('isValidExpiryDate', () {
      test('returns true for recent past date', () {
        final recentPast = DateTime.now().subtract(const Duration(days: 100));
        expect(DateUtils.isValidExpiryDate(recentPast), isTrue);
      });

      test('returns false for very old date', () {
        final oldDate = DateTime.now().subtract(const Duration(days: 400));
        expect(DateUtils.isValidExpiryDate(oldDate), isFalse);
      });

      test('returns true for future date', () {
        final futureDate = DateTime.now().add(const Duration(days: 365));
        expect(DateUtils.isValidExpiryDate(futureDate), isTrue);
      });
    });
  });
}
