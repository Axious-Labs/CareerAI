/// Utility functions for sanitizing, formatting, and masking user input strings across CareerAI.
class InputSanitizer {
  InputSanitizer._();

  static final RegExp _htmlTagPattern = RegExp(r'<[^>]*>');
  static final RegExp _multiWhitespacePattern = RegExp(r'\s+');
  static final RegExp _slugSpecialCharsPattern = RegExp(r'[^a-zA-Z0-9\s-]');

  /// Strips HTML tags from input string while preserving internal text.
  static String stripHtmlTags(String? input) {
    if (input == null || input.isEmpty) return '';
    return input.replaceAll(_htmlTagPattern, '').trim();
  }

  /// Collapses multiple consecutive whitespaces and trims leading/trailing spaces.
  static String normalizeWhitespace(String? input) {
    if (input == null || input.isEmpty) return '';
    return input.replaceAll(_multiWhitespacePattern, ' ').trim();
  }

  /// Masks email addresses for privacy (e.g., "alex.chen@axiouslabs.ai" -> "a***n@axiouslabs.ai").
  static String maskEmail(String? email) {
    if (email == null || email.trim().isEmpty) return '';
    final trimmed = email.trim();
    final atIndex = trimmed.indexOf('@');
    if (atIndex <= 1) return trimmed;

    final userPart = trimmed.substring(0, atIndex);
    final domainPart = trimmed.substring(atIndex);

    if (userPart.length <= 2) {
      return '${userPart[0]}*${userPart.length == 2 ? userPart[1] : ''}$domainPart';
    }

    final firstChar = userPart[0];
    final lastChar = userPart[userPart.length - 1];
    final maskedLength = userPart.length - 2;
    final stars = '*' * (maskedLength > 3 ? 3 : maskedLength);

    return '$firstChar$stars$lastChar$domainPart';
  }

  /// Masks phone numbers displaying only last 4 digits (e.g. "+1 (555) 123-4567" -> "***-***-4567").
  static String maskPhone(String? phone) {
    if (phone == null || phone.trim().isEmpty) return '';
    final digits = phone.replaceAll(RegExp(r'\D'), '');
    if (digits.length <= 4) return phone;

    final lastFour = digits.substring(digits.length - 4);
    return '***-***-$lastFour';
  }

  /// Converts a title or role into a URL-friendly slug (e.g. "Senior Flutter & AI Engineer!" -> "senior-flutter-ai-engineer").
  static String slugify(String? input) {
    if (input == null || input.trim().isEmpty) return '';
    final cleaned = input.replaceAll(_slugSpecialCharsPattern, '');
    final normalized = cleaned.replaceAll(_multiWhitespacePattern, '-').toLowerCase();
    return normalized.replaceAll(RegExp(r'^-+|-+$'), '');
  }

  /// Normalizes and deduplicates technical skill strings, trimming and preserving casing standard.
  static List<String> normalizeSkills(List<String>? skills) {
    if (skills == null || skills.isEmpty) return const [];
    final seen = <String>{};
    final result = <String>[];

    for (final raw in skills) {
      final trimmed = raw.trim();
      if (trimmed.isEmpty) continue;
      final key = trimmed.toLowerCase();
      if (!seen.contains(key)) {
        seen.add(key);
        result.add(trimmed);
      }
    }

    return result;
  }

  /// Extracts hashtags or keywords with '#' prefix.
  static List<String> extractHashtags(String? text) {
    if (text == null || text.isEmpty) return const [];
    final regex = RegExp(r'#([a-zA-Z0-9_-]+)');
    final matches = regex.allMatches(text);
    return matches.map((m) => m.group(1)!).toList();
  }
}

