/// Multi-currency utility offering exchange calculations and formatted salary ranges.
class CurrencyConverter {
  CurrencyConverter._();

  /// Reference conversion rates relative to USD (1.0).
  static const Map<String, double> _usdExchangeRates = {
    'USD': 1.0,
    'EUR': 0.92,
    'GBP': 0.79,
    'CAD': 1.36,
    'INR': 83.25,
    'SGD': 1.35,
    'AUD': 1.52,
    'JPY': 155.0,
  };

  /// Currency symbol mapping.
  static const Map<String, String> _currencySymbols = {
    'USD': '\$',
    'EUR': '€',
    'GBP': '£',
    'CAD': 'CA\$',
    'INR': '₹',
    'SGD': 'S\$',
    'AUD': 'A\$',
    'JPY': '¥',
  };

  /// Returns list of supported currency codes.
  static List<String> get supportedCurrencies => _usdExchangeRates.keys.toList();

  /// Returns symbol for given currency code.
  static String getSymbol(String currencyCode) {
    return _currencySymbols[currencyCode.toUpperCase()] ?? '\$';
  }

  /// Gets exchange rate between two currency codes.
  static double getExchangeRate(String from, String to) {
    final fromRate = _usdExchangeRates[from.toUpperCase()] ?? 1.0;
    final toRate = _usdExchangeRates[to.toUpperCase()] ?? 1.0;
    if (fromRate == 0) return 1.0;
    return toRate / fromRate;
  }

  /// Converts amount from one currency to another.
  static double convert(num amount, String from, String to) {
    if (from.toUpperCase() == to.toUpperCase()) return amount.toDouble();
    final rate = getExchangeRate(from, to);
    return amount * rate;
  }

  /// Formats salary with localized symbol and standard formatting.
  static String formatWithCurrency(
    num amount,
    String currencyCode, {
    bool isCompact = false,
  }) {
    final code = currencyCode.toUpperCase();
    final symbol = getSymbol(code);

    if (isCompact) {
      if (amount >= 1000000) {
        final val = (amount / 1000000).toStringAsFixed(1);
        return '$symbol${val}M $code';
      } else if (amount >= 1000) {
        final val = (amount / 1000).round();
        return '$symbol${val}k $code';
      }
    }

    final formattedAmount = amount.toStringAsFixed(0).replaceAllMapped(
          RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
          (Match m) => '${m[1]},',
        );

    return '$symbol$formattedAmount $code';
  }

  /// Converts a salary range between currencies and formats it cleanly.
  static String convertAndFormatSalaryRange(
    num min,
    num max, {
    String from = 'USD',
    String to = 'USD',
  }) {
    final convertedMin = convert(min, from, to);
    final convertedMax = convert(max, from, to);
    final symbol = getSymbol(to);
    final minK = (convertedMin / 1000).round();
    final maxK = (convertedMax / 1000).round();

    return '$symbol${minK}k - $symbol${maxK}k ${to.toUpperCase()}';
  }
}

