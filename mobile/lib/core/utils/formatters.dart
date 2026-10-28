import 'package:intl/intl.dart';

/// Centralized utility class for formatting values across the CareerAI mobile application.
/// Ensures consistent presentation of currencies, dates, numbers, and strings.
class AppFormatters {
  AppFormatters._();

  /// Formats a numeric currency value (e.g. 150000 -> "$150,000").
  static String currency(
    num amount, {
    String symbol = '\$',
    int decimalDigits = 0,
  }) {
    final formatter = NumberFormat.currency(
      symbol: symbol,
      decimalDigits: decimalDigits,
    );
    return formatter.format(amount);
  }

  /// Formats currency into compact representations (e.g. 150000 -> "$150k", 2500000 -> "$2.5M").
  static String compactCurrency(
    num amount, {
    String symbol = '\$',
  }) {
    if (amount >= 1000000) {
      final val = amount / 1000000;
      final formatted = val == val.roundToDouble() ? val.toStringAsFixed(0) : val.toStringAsFixed(1);
      return '$symbol${formatted}M';
    } else if (amount >= 1000) {
      final val = amount / 1000;
      final formatted = val == val.roundToDouble() ? val.toStringAsFixed(0) : val.toStringAsFixed(1);
      return '$symbol${formatted}k';
    }
    return '$symbol$amount';
  }

  /// Formats a salary range from min and max figures (e.g. "$130k - $160k USD").
  static String salaryRange(
    num min,
    num max, {
    String currency = 'USD',
  }) {
    final minStr = compactCurrency(min);
    final maxStr = compactCurrency(max);
    return '$minStr - $maxStr $currency';
  }

  /// Formats a ratio or percentage (e.g. 0.854 -> "85.4%").
  static String percentage(
    num value, {
    int decimalDigits = 1,
    bool isNormalized = false,
  }) {
    final adjusted = isNormalized ? value * 100 : value;
    return '${adjusted.toStringAsFixed(decimalDigits)}%';
  }

  /// Formats large numbers compactly (e.g. 1420 -> "1.4k").
  static String compactNumber(num number) {
    if (number >= 1000000) {
      final val = number / 1000000;
      return '${val.toStringAsFixed(1)}M';
    } else if (number >= 1000) {
      final val = number / 1000;
      final formatted = val == val.roundToDouble() ? val.toStringAsFixed(0) : val.toStringAsFixed(1);
      return '${formatted}k';
    }
    return number.toString();
  }

  /// Formats a human-readable relative date (e.g. "Just now", "5 minutes ago", "3 days ago").
  static String relativeDate(
    DateTime date, {
    DateTime? now,
  }) {
    final current = now ?? DateTime.now();
    final difference = current.difference(date);

    if (difference.inSeconds < 45) {
      return 'Just now';
    } else if (difference.inMinutes < 60) {
      final mins = difference.inMinutes;
      return '$mins ${mins == 1 ? "minute" : "minutes"} ago';
    } else if (difference.inHours < 24) {
      final hours = difference.inHours;
      return '$hours ${hours == 1 ? "hour" : "hours"} ago';
    } else if (difference.inDays < 7) {
      final days = difference.inDays;
      return '$days ${days == 1 ? "day" : "days"} ago';
    } else if (difference.inDays < 30) {
      final weeks = (difference.inDays / 7).floor();
      return '$weeks ${weeks == 1 ? "week" : "weeks"} ago';
    } else if (difference.inDays < 365) {
      final months = (difference.inDays / 30).floor();
      return '$months ${months == 1 ? "month" : "months"} ago';
    } else {
      final years = (difference.inDays / 365).floor();
      return '$years ${years == 1 ? "year" : "years"} ago';
    }
  }

  /// Formats date to standard format (e.g. "Oct 28, 2026").
  static String formattedDate(DateTime date, {String format = 'MMM d, yyyy'}) {
    return DateFormat(format).format(date);
  }

  /// Formats date to Month & Year (e.g. "October 2026").
  static String monthYear(DateTime date) {
    return DateFormat('MMMM yyyy').format(date);
  }

  /// Computes days remaining until target date (returns 0 if date is past).
  static int daysRemaining(DateTime targetDate, {DateTime? fromDate}) {
    final base = fromDate ?? DateTime.now();
    final diff = targetDate.difference(base).inDays;
    return diff > 0 ? diff : 0;
  }

  /// Truncates string to specified maximum length and appends ellipsis.
  static String truncate(
    String text,
    int maxLength, {
    String suffix = '...',
  }) {
    if (text.length <= maxLength) return text;
    final truncatedLength = maxLength - suffix.length;
    if (truncatedLength <= 0) return text.substring(0, maxLength);
    return '${text.substring(0, truncatedLength)}$suffix';
  }

  /// Capitalizes first character of a string.
  static String capitalize(String text) {
    if (text.isEmpty) return text;
    return '${text[0].toUpperCase()}${text.substring(1)}';
  }

  /// Capitalizes first letter of each word.
  static String capitalizeWords(String text) {
    if (text.isEmpty) return text;
    return text.split(' ').map((word) {
      if (word.isEmpty) return word;
      return '${word[0].toUpperCase()}${word.substring(1).toLowerCase()}';
    }).join(' ');
  }

  /// Generates 1-2 character initials from full user name.
  static String initials(String name) {
    final trimmed = name.trim();
    if (trimmed.isEmpty) return 'U';
    final parts = trimmed.split(RegExp(r'\s+'));
    if (parts.length >= 2) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    }
    return parts[0].substring(0, parts[0].length >= 2 ? 2 : 1).toUpperCase();
  }

  /// Formats file size in bytes to human-readable string (KB, MB, GB).
  static String fileSize(int bytes) {
    if (bytes <= 0) return '0 B';
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) {
      final kb = (bytes / 1024).toStringAsFixed(1);
      return '$kb KB';
    }
    if (bytes < 1024 * 1024 * 1024) {
      final mb = (bytes / (1024 * 1024)).toStringAsFixed(1);
      return '$mb MB';
    }
    final gb = (bytes / (1024 * 1024 * 1024)).toStringAsFixed(2);
    return '$gb GB';
  }
}

