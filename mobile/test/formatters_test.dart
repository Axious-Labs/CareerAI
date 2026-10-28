import 'package:flutter_test/flutter_test.dart';
import 'package:careerai_mobile/core/utils/formatters.dart';

void main() {
  group('AppFormatters - Currency & Numbers Unit Tests', () {
    test('currency formats standard amounts with defaults', () {
      expect(AppFormatters.currency(150000), '\$150,000');
      expect(AppFormatters.currency(0), '\$0');
      expect(AppFormatters.currency(42.5, decimalDigits: 2), '\$42.50');
      expect(AppFormatters.currency(1234.56, symbol: '€', decimalDigits: 2), '€1,234.56');
    });

    test('compactCurrency handles thousands and millions correctly', () {
      expect(AppFormatters.compactCurrency(500), '\$500');
      expect(AppFormatters.compactCurrency(1000), '\$1k');
      expect(AppFormatters.compactCurrency(1500), '\$1.5k');
      expect(AppFormatters.compactCurrency(125000), '\$125k');
      expect(AppFormatters.compactCurrency(1000000), '\$1M');
      expect(AppFormatters.compactCurrency(2500000), '\$2.5M');
      expect(AppFormatters.compactCurrency(10000000), '\$10M');
      expect(AppFormatters.compactCurrency(75000, symbol: '£'), '£75k');
    });

    test('salaryRange formats lower and upper bounds with currency string', () {
      expect(
        AppFormatters.salaryRange(120000, 160000),
        '\$120k - \$160k USD',
      );
      expect(
        AppFormatters.salaryRange(80000, 105000, currency: 'EUR'),
        '\$80k - \$105k EUR',
      );
    });

    test('percentage formats both raw ratio and normalized values', () {
      expect(AppFormatters.percentage(85.45, decimalDigits: 1), '85.5%');
      expect(AppFormatters.percentage(100, decimalDigits: 0), '100%');
      expect(AppFormatters.percentage(0.742, isNormalized: true, decimalDigits: 1), '74.2%');
      expect(AppFormatters.percentage(0, decimalDigits: 0), '0%');
    });

    test('compactNumber formats integers and counts appropriately', () {
      expect(AppFormatters.compactNumber(42), '42');
      expect(AppFormatters.compactNumber(999), '999');
      expect(AppFormatters.compactNumber(1000), '1k');
      expect(AppFormatters.compactNumber(1420), '1.4k');
      expect(AppFormatters.compactNumber(15000), '15k');
      expect(AppFormatters.compactNumber(2300000), '2.3M');
    });
  });

  group('AppFormatters - Date & Relative Time Unit Tests', () {
    final baseTime = DateTime(2026, 10, 28, 12, 0, 0);

    test('relativeDate evaluates increments accurately', () {
      final justNow = baseTime.subtract(const Duration(seconds: 20));
      expect(AppFormatters.relativeDate(justNow, now: baseTime), 'Just now');

      final minutesAgo = baseTime.subtract(const Duration(minutes: 15));
      expect(AppFormatters.relativeDate(minutesAgo, now: baseTime), '15 minutes ago');

      final oneMinuteAgo = baseTime.subtract(const Duration(minutes: 1));
      expect(AppFormatters.relativeDate(oneMinuteAgo, now: baseTime), '1 minute ago');

      final hoursAgo = baseTime.subtract(const Duration(hours: 4));
      expect(AppFormatters.relativeDate(hoursAgo, now: baseTime), '4 hours ago');

      final daysAgo = baseTime.subtract(const Duration(days: 3));
      expect(AppFormatters.relativeDate(daysAgo, now: baseTime), '3 days ago');

      final weeksAgo = baseTime.subtract(const Duration(days: 14));
      expect(AppFormatters.relativeDate(weeksAgo, now: baseTime), '2 weeks ago');

      final monthsAgo = baseTime.subtract(const Duration(days: 65));
      expect(AppFormatters.relativeDate(monthsAgo, now: baseTime), '2 months ago');

      final yearsAgo = baseTime.subtract(const Duration(days: 750));
      expect(AppFormatters.relativeDate(yearsAgo, now: baseTime), '2 years ago');
    });

    test('formattedDate and monthYear format standard dates', () {
      final date = DateTime(2026, 10, 15);
      expect(AppFormatters.formattedDate(date), 'Oct 15, 2026');
      expect(AppFormatters.monthYear(date), 'October 2026');
    });

    test('daysRemaining handles future and past deadlines', () {
      final now = DateTime(2026, 10, 28);
      final future = DateTime(2026, 11, 7);
      final past = DateTime(2026, 10, 20);

      expect(AppFormatters.daysRemaining(future, fromDate: now), 10);
      expect(AppFormatters.daysRemaining(past, fromDate: now), 0);
    });
  });

  group('AppFormatters - String Manipulation & Files Unit Tests', () {
    test('truncate restricts strings to length with suffix', () {
      expect(AppFormatters.truncate('Flutter Development', 10), 'Fluv...');
      expect(AppFormatters.truncate('Short', 10), 'Short');
      expect(AppFormatters.truncate('Exact10Len', 10), 'Exact10Len');
    });

    test('capitalize and capitalizeWords formats text casing', () {
      expect(AppFormatters.capitalize(''), '');
      expect(AppFormatters.capitalize('flutter'), 'Flutter');
      expect(AppFormatters.capitalizeWords('senior flutter engineer'), 'Senior Flutter Engineer');
      expect(AppFormatters.capitalizeWords('ai/ml specialist'), 'Ai/ml Specialist');
    });

    test('initials extracts uppercase letters from person names', () {
      expect(AppFormatters.initials('Alex Chen'), 'AC');
      expect(AppFormatters.initials('Sandeep Sisodiya'), 'SS');
      expect(AppFormatters.initials('Single'), 'SI');
      expect(AppFormatters.initials('X'), 'X');
      expect(AppFormatters.initials(''), 'U');
    });

    test('fileSize parses bytes into appropriate units', () {
      expect(AppFormatters.fileSize(0), '0 B');
      expect(AppFormatters.fileSize(500), '500 B');
      expect(AppFormatters.fileSize(2048), '2.0 KB');
      expect(AppFormatters.fileSize(5 * 1024 * 1024), '5.0 MB');
      expect(AppFormatters.fileSize(2 * 1024 * 1024 * 1024), '2.00 GB');
    });
  });
}

