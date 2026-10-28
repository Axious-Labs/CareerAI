import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:careerai_mobile/core/constants/ui_constants.dart';

void main() {
  group('UIConstants Values & Tokens Unit Tests', () {
    test('spacing increments follow systematic scale', () {
      expect(UIConstants.spacing2, 2.0);
      expect(UIConstants.spacing4, 4.0);
      expect(UIConstants.spacing8, 8.0);
      expect(UIConstants.spacing12, 12.0);
      expect(UIConstants.spacing16, 16.0);
      expect(UIConstants.spacing20, 20.0);
      expect(UIConstants.spacing24, 24.0);
      expect(UIConstants.spacing32, 32.0);
      expect(UIConstants.spacing40, 40.0);
      expect(UIConstants.spacing48, 48.0);
    });

    test('border radii dimensions match token definitions', () {
      expect(UIConstants.borderRadiusSmall, BorderRadius.circular(8.0));
      expect(UIConstants.borderRadiusMedium, BorderRadius.circular(12.0));
      expect(UIConstants.borderRadiusLarge, BorderRadius.circular(16.0));
      expect(UIConstants.borderRadiusXLarge, BorderRadius.circular(24.0));
      expect(UIConstants.borderRadiusCircular, BorderRadius.circular(999.0));
    });

    test('animation durations are in logical ascending order', () {
      expect(UIConstants.durationFast < UIConstants.durationNormal, isTrue);
      expect(UIConstants.durationNormal < UIConstants.durationSlow, isTrue);
      expect(UIConstants.durationFast.inMilliseconds, 150);
      expect(UIConstants.durationNormal.inMilliseconds, 250);
      expect(UIConstants.durationSlow.inMilliseconds, 400);
      expect(UIConstants.durationPageTransition.inMilliseconds, 300);
    });

    test('responsive breakpoints thresholds are appropriately ordered', () {
      expect(UIConstants.breakpointMobile < UIConstants.breakpointTablet, isTrue);
      expect(UIConstants.breakpointTablet < UIConstants.breakpointDesktop, isTrue);
      expect(UIConstants.breakpointMobile, 480.0);
      expect(UIConstants.breakpointTablet, 768.0);
      expect(UIConstants.breakpointDesktop, 1024.0);
    });

    test('elevation levels maintain upward progression', () {
      expect(UIConstants.elevationNone, 0.0);
      expect(UIConstants.elevationLow, 2.0);
      expect(UIConstants.elevationMedium, 4.0);
      expect(UIConstants.elevationHigh, 8.0);
      expect(UIConstants.elevationLow < UIConstants.elevationMedium, isTrue);
      expect(UIConstants.elevationMedium < UIConstants.elevationHigh, isTrue);
    });

    test('icon sizes increase monotonically', () {
      expect(UIConstants.iconSizeSmall, 16.0);
      expect(UIConstants.iconSizeMedium, 24.0);
      expect(UIConstants.iconSizeLarge, 32.0);
      expect(UIConstants.iconSizeXLarge, 48.0);
    });
  });
}

