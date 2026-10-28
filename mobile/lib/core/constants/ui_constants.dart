import 'package:flutter/material.dart';

/// Centralized UI design tokens and layout constants for CareerAI mobile.
class UIConstants {
  UIConstants._();

  // Spacing Units
  static const double spacing2 = 2.0;
  static const double spacing4 = 4.0;
  static const double spacing8 = 8.0;
  static const double spacing12 = 12.0;
  static const double spacing16 = 16.0;
  static const double spacing20 = 20.0;
  static const double spacing24 = 24.0;
  static const double spacing32 = 32.0;
  static const double spacing40 = 40.0;
  static const double spacing48 = 48.0;

  // Insets
  static const EdgeInsets screenPadding = EdgeInsets.all(spacing16);
  static const EdgeInsets screenPaddingLarge = EdgeInsets.all(spacing20);
  static const EdgeInsets cardPadding = EdgeInsets.all(spacing16);
  static const EdgeInsets dialogPadding = EdgeInsets.all(spacing24);
  static const EdgeInsets horizontalPadding = EdgeInsets.symmetric(horizontal: spacing16);
  static const EdgeInsets verticalPadding = EdgeInsets.symmetric(vertical: spacing16);

  // Border Radii
  static const double radiusSmall = 8.0;
  static const double radiusMedium = 12.0;
  static const double radiusLarge = 16.0;
  static const double radiusXLarge = 24.0;
  static const double radiusCircular = 999.0;

  static final BorderRadius borderRadiusSmall = BorderRadius.circular(radiusSmall);
  static final BorderRadius borderRadiusMedium = BorderRadius.circular(radiusMedium);
  static final BorderRadius borderRadiusLarge = BorderRadius.circular(radiusLarge);
  static final BorderRadius borderRadiusXLarge = BorderRadius.circular(radiusXLarge);
  static final BorderRadius borderRadiusCircular = BorderRadius.circular(radiusCircular);

  // Animation Durations
  static const Duration durationFast = Duration(milliseconds: 150);
  static const Duration durationNormal = Duration(milliseconds: 250);
  static const Duration durationSlow = Duration(milliseconds: 400);
  static const Duration durationPageTransition = Duration(milliseconds: 300);

  // Responsive Breakpoints
  static const double breakpointMobile = 480.0;
  static const double breakpointTablet = 768.0;
  static const double breakpointDesktop = 1024.0;

  // Elevation Values
  static const double elevationNone = 0.0;
  static const double elevationLow = 2.0;
  static const double elevationMedium = 4.0;
  static const double elevationHigh = 8.0;

  // Icon Sizes
  static const double iconSizeSmall = 16.0;
  static const double iconSizeMedium = 24.0;
  static const double iconSizeLarge = 32.0;
  static const double iconSizeXLarge = 48.0;
}

