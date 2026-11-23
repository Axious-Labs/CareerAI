import 'package:flutter/material.dart';

/// Generates deterministic colors and gradients based on string seeds (tags, names, roles).
class ColorPaletteGenerator {
  ColorPaletteGenerator._();

  static const List<Color> _tagColors = [
    Color(0xFF38BDF8), // Sky Blue
    Color(0xFF818CF8), // Indigo
    Color(0xFFA78BFA), // Violet
    Color(0xFFF472B6), // Pink
    Color(0xFF34D399), // Emerald
    Color(0xFFFBBF24), // Amber
    Color(0xFFFB923C), // Orange
    Color(0xFF2DD4BF), // Teal
    Color(0xFF4ADE80), // Green
    Color(0xFFE879F9), // Fuchsia
  ];

  /// Generates a deterministic primary color for any tag, skill, or badge label.
  static Color generateTagColor(String seed) {
    if (seed.isEmpty) return _tagColors.first;
    final hash = seed.runes.fold<int>(0, (prev, curr) => (prev * 31 + curr) & 0x7FFFFFFF);
    return _tagColors[hash % _tagColors.length];
  }

  /// Generates a 2-stop linear gradient for user avatar cards and milestones.
  static LinearGradient generateAvatarGradient(String seed) {
    final primary = generateTagColor(seed);
    final secondary = generateTagColor('$seed-secondary');

    return LinearGradient(
      colors: [primary, secondary],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    );
  }

  /// Determines whether white or dark text is optimal for readability on a background color.
  static Color getContrastTextColor(Color backgroundColor) {
    final luminance = backgroundColor.computeLuminance();
    return luminance > 0.45 ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC);
  }

  /// Generates subtle semi-transparent background color for chips and pills.
  static Color generatePillBackgroundColor(String seed, {double opacity = 0.15}) {
    final color = generateTagColor(seed);
    return color.withValues(alpha: opacity);
  }
}

