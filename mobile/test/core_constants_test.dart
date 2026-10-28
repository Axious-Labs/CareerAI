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
      expect(ApiEndpoints.aiChat.startsWith('/'), isTrue);
      expect(ApiEndpoints.startInterview.startsWith('/'), isTrue);
      expect(ApiEndpoints.goals.startsWith('/'), isTrue);
      expect(ApiEndpoints.analytics.startsWith('/'), isTrue);
      expect(ApiEndpoints.notifications.startsWith('/'), isTrue);
    });

    test('AppColors palette definitions verify contrast and themes', () {
      expect(AppColors.primary, const Color(0xFF0F172A));
      expect(AppColors.background, const Color(0xFF020617));
      expect(AppColors.surface, const Color(0xFF1E293B));
      expect(AppColors.surfaceLight, const Color(0xFF334155));
      expect(AppColors.accent, const Color(0xFF38BDF8));
      expect(AppColors.accentLight, const Color(0xFF7DD3FC));
      expect(AppColors.accentDark, const Color(0xFF0284C7));
      expect(AppColors.textPrimary, const Color(0xFFF8FAFC));
      expect(AppColors.textSecondary, const Color(0xFF94A3B8));
      expect(AppColors.border, const Color(0xFF334155));
      expect(AppColors.success, const Color(0xFF22C55E));
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

