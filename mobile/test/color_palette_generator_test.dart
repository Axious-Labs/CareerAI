import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:careerai_mobile/core/utils/color_palette_generator.dart';

void main() {
  group('ColorPaletteGenerator Unit Tests', () {
    test('generateTagColor produces deterministic colors for identical seeds', () {
      final color1 = ColorPaletteGenerator.generateTagColor('Flutter');
      final color2 = ColorPaletteGenerator.generateTagColor('Flutter');
      expect(color1, equals(color2));

      final emptyColor = ColorPaletteGenerator.generateTagColor('');
      expect(emptyColor, isA<Color>());
    });

    test('generateTagColor distributes across multiple palette colors', () {
      final flutterColor = ColorPaletteGenerator.generateTagColor('Flutter');
      final pythonColor = ColorPaletteGenerator.generateTagColor('Python');
      final dockerColor = ColorPaletteGenerator.generateTagColor('Docker');

      expect([flutterColor, pythonColor, dockerColor].toSet().length, greaterThan(1));
    });

    test('generateAvatarGradient produces valid LinearGradient with 2 colors', () {
      final gradient = ColorPaletteGenerator.generateAvatarGradient('Alex Chen');
      expect(gradient.colors.length, 2);
      expect(gradient.begin, Alignment.topLeft);
      expect(gradient.end, Alignment.bottomRight);
    });

    test('getContrastTextColor chooses appropriate text color based on background luminance', () {
      const darkBg = Color(0xFF0F172A);
      const lightBg = Color(0xFFF8FAFC);

      expect(ColorPaletteGenerator.getContrastTextColor(darkBg), const Color(0xFFF8FAFC));
      expect(ColorPaletteGenerator.getContrastTextColor(lightBg), const Color(0xFF0F172A));
    });

    test('generatePillBackgroundColor produces semi-transparent accent color', () {
      final pillColor = ColorPaletteGenerator.generatePillBackgroundColor('Dart', opacity: 0.2);
      expect(pillColor.a, closeTo(0.2, 0.05));
    });
  });
}

