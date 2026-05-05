import 'package:flutter_test/flutter_test.dart';
import 'package:tiny_meds/core/utils/date_utils.dart';

void main() {
  group('AppDateUtils', () {
    test('formatShortDate should format correctly', () {
      final date = DateTime(2024, 1, 12);
      expect(AppDateUtils.formatShortDate(date), 'Jan 12, 2024');
    });

    test('formatLongDate should format correctly', () {
      final date = DateTime(2024, 1, 12);
      expect(AppDateUtils.formatLongDate(date), 'Friday, January 12, 2024');
    });

    test('isSameDay should correctly identify same days', () {
      final date1 = DateTime(2024, 1, 12, 10, 30);
      final date2 = DateTime(2024, 1, 12, 14, 45);
      final date3 = DateTime(2024, 1, 13, 10, 30);

      expect(AppDateUtils.isSameDay(date1, date2), true);
      expect(AppDateUtils.isSameDay(date1, date3), false);
    });

    test('isToday should correctly identify today', () {
      expect(AppDateUtils.isToday(DateTime.now()), true);
      expect(AppDateUtils.isToday(DateTime.now().add(const Duration(days: 1))), false);
    });

    group('getRelativeTimeString', () {
      test('should return "Expires today" for today', () {
        expect(AppDateUtils.getRelativeTimeString(DateTime.now()), 'Expires today');
      });

      test('should return "Expires in X days" for future', () {
        final future = DateTime.now().add(const Duration(days: 5, hours: 1));
        expect(AppDateUtils.getRelativeTimeString(future), 'Expires in 5 days');
      });

      test('should return "Expired X days ago" for past', () {
        final past = DateTime.now().subtract(const Duration(days: 3, hours: 1));
        expect(AppDateUtils.getRelativeTimeString(past), 'Expired 3 days ago');
      });
    });
  });
}
