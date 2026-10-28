import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:careerai_mobile/core/constants/api_endpoints.dart';
import 'package:careerai_mobile/core/constants/app_colors.dart';
import 'package:careerai_mobile/core/constants/app_text_styles.dart';

void main() {
  group('Core Constants & Design Tokens Tests', () {
    test('ApiEndpoints routes are non-empty and formatted with leading slashes', () {
      expect(ApiEndpoints.baseUrl, isNotEmpty);
      expect(ApiEndpoints.login.startsWith('/'), isTrue);
      expect(ApiEndpoints.register.startsWith('/'), isTrue);
      expect(ApiEndpoints.userMe.startsWith('/'), isTrue);
      expect(ApiEndpoints.jobs.startsWith('/'), isTrue);
      expect(ApiEndpoints.applications.startsWith('/'), isTrue);
      expect(ApiEndpoints.skills.startsWith('/'), isTrue);
      expect(ApiEndpoints.uploadResume.startsWith('/'), isTrue);
      expect(ApiEndpoints.chat.startsWith('/'), isTrue);
      expect(ApiEndpoints.startInterview.startsWith('/'), isTrue);
      expect(ApiEndpoints.goals.startsWith('/'), isTrue);
      expect(ApiEndpoints.analytics.startsWith('/'), isTrue);
      expect(ApiEndpoints.notifications.startsWith('/'), isTrue);
    });

    test('AppColors palette definitions verify contrast and themes', () {
      expect(AppColors.primary, const Color(0xFF0F172A));
      expect(AppColors.background, const Color(0xFF0B0F19));
      expect(AppColors.surface, const Color(0xFF161E2E));
      expect(AppColors.surfaceLight, const Color(0xFF222F43));
      expect(AppColors.accent, const Color(0xFF06B6D4));
      expect(AppColors.accentLight, const Color(0xFF67E8F9));
      expect(AppColors.indigo, const Color(0xFF6366F1));
      expect(AppColors.textPrimary, const Color(0xFFF8FAFC));
      expect(AppColors.textSecondary, const Color(0xFF94A3B8));
      expect(AppColors.border, const Color(0xFF334155));
      expect(AppColors.success, const Color(0xFF10B981));
      expect(AppColors.warning, const Color(0xFFF59E0B));
      expect(AppColors.error, const Color(0xFFEF4444));
    });

    test('AppTextStyles typographic tokens maintain readability and weights', () {
      expect(AppTextStyles.h1.fontSize, 28);
      expect(AppTextStyles.h1.fontWeight, FontWeight.bold);

      expect(AppTextStyles.h2.fontSize, 20);
      expect(AppTextStyles.h2.fontWeight, FontWeight.w600);

      expect(AppTextStyles.h3.fontSize, 16);
      expect(AppTextStyles.h3.fontWeight, FontWeight.w600);

      expect(AppTextStyles.bodyLarge.fontSize, 16);
      expect(AppTextStyles.bodyMedium.fontSize, 14);
      expect(AppTextStyles.bodySmall.fontSize, 12);
    });
  });
}
