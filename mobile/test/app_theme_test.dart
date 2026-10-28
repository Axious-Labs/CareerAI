import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:careerai_mobile/core/theme/app_theme.dart';
import 'package:careerai_mobile/core/constants/app_colors.dart';

void main() {
  group('AppTheme Configuration Unit Tests', () {
    test('darkTheme configures dark brightness and palette properly', () {
      final theme = AppTheme.darkTheme;
      expect(theme.brightness, Brightness.dark);
      expect(theme.scaffoldBackgroundColor, AppColors.background);
      expect(theme.primaryColor, AppColors.accent);
      expect(theme.colorScheme.primary, AppColors.accent);
      expect(theme.colorScheme.surface, AppColors.surface);
      expect(theme.colorScheme.error, AppColors.error);
    });

    test('darkTheme card and appBar styles comply with design guidelines', () {
      final theme = AppTheme.darkTheme;
      expect(theme.cardTheme.color, AppColors.surface);
      expect(theme.cardTheme.elevation, 0);
      expect(theme.appBarTheme.backgroundColor, AppColors.background);
      expect(theme.appBarTheme.elevation, 0);
      expect(theme.appBarTheme.centerTitle, false);
    });

    test('darkTheme inputDecoration and button styles are configured', () {
      final theme = AppTheme.darkTheme;
      expect(theme.inputDecorationTheme.filled, true);
      expect(theme.inputDecorationTheme.fillColor, AppColors.surface);
      expect(theme.elevatedButtonTheme.style, isNotNull);
    });
  });
}

