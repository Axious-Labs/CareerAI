import 'package:flutter_test/flutter_test.dart';
import 'package:careerai_mobile/core/utils/currency_converter.dart';

void main() {
  group('CurrencyConverter Unit Tests', () {
    test('supportedCurrencies provides major international currencies', () {
      final currencies = CurrencyConverter.supportedCurrencies;
      expect(currencies.contains('USD'), isTrue);
      expect(currencies.contains('EUR'), isTrue);
      expect(currencies.contains('GBP'), isTrue);
      expect(currencies.contains('INR'), isTrue);
      expect(currencies.contains('CAD'), isTrue);
    });

    test('getSymbol returns correct symbol for standard and fallback currency codes', () {
      expect(CurrencyConverter.getSymbol('USD'), '\$');
      expect(CurrencyConverter.getSymbol('EUR'), '€');
      expect(CurrencyConverter.getSymbol('GBP'), '£');
      expect(CurrencyConverter.getSymbol('INR'), '₹');
      expect(CurrencyConverter.getSymbol('UNKNOWN'), '\$');
    });

    test('getExchangeRate handles same currency and cross conversions', () {
      expect(CurrencyConverter.getExchangeRate('USD', 'USD'), 1.0);
      expect(CurrencyConverter.getExchangeRate('USD', 'EUR'), 0.92);
      expect(CurrencyConverter.getExchangeRate('EUR', 'USD'), closeTo(1.086, 0.01));
    });

    test('convert transforms values accurately across currencies', () {
      expect(CurrencyConverter.convert(100, 'USD', 'USD'), 100.0);
      expect(CurrencyConverter.convert(100, 'USD', 'EUR'), 92.0);
      expect(CurrencyConverter.convert(1000, 'USD', 'INR'), 83250.0);
    });

    test('formatWithCurrency formats numbers with symbol and optional compact notation', () {
      final standard = CurrencyConverter.formatWithCurrency(150000, 'USD');
      expect(standard, '\$150,000 USD');

      final compactK = CurrencyConverter.formatWithCurrency(150000, 'USD', isCompact: true);
      expect(compactK, '\$150k USD');

      final compactM = CurrencyConverter.formatWithCurrency(2500000, 'EUR', isCompact: true);
      expect(compactM, '€2.5M EUR');
    });

    test('convertAndFormatSalaryRange formats min and max converted bounds', () {
      final formatted = CurrencyConverter.convertAndFormatSalaryRange(
        120000,
        160000,
        from: 'USD',
        to: 'USD',
      );
      expect(formatted, '\$120k - \$160k USD');
    });
  });
}

