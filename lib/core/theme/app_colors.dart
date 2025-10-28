import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // Primary Colors
  static const Color primary = Color.fromARGB(255, 70, 66, 66);
  static const Color primaryLight = Color(0xFF42A5F5);
  static const Color primaryDark = Color(0xFF0D47A1);

  // Secondary Colors
  static const Color secondary = Color(0xFF26A69A);
  static const Color secondaryLight = Color(0xFF80CBC4);
  static const Color secondaryDark = Color(0xFF00897B);

  // Background Colors
  static const Color background = Color(0xFFFFFFFF);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color surfaceDark = Color(0xFF424242);

  // Text Colors
  static const Color textPrimary = Color(0xFF212121);
  static const Color textSecondary = Color(0xFF757575);
  static const Color textHint = Color(0xFF9E9E9E);
  static const Color textWhite = Color(0xFFFFFFFF);

  // Product Card Colors
  static const Color cardBackground = Color(0xFFF5F5F5);
  static const Color cardShadow = Color(0x1A000000);
  static const Color discountBadge = Color(0xFFD32F2F);
  static const Color priceBadge = Color(0xFF388E3C);
  static const Color ratingStarColor = Color(0xFFFFC107);

  // Category Colors
  static const Color categoryBackground = Color(0xFF1976D2);
  static const Color categoryText = Color(0xFFFFFFFF);
  static const Color categoryBorder = Color(0xFF1565C0);

  // Loading & Error Colors
  static const Color loadingIndicator = Color(0xFF1976D2);
  static const Color errorIcon = Color(0xFFF44336);
  static const Color errorBackground = Color(0xFFFFEBEE);

  // Border & Divider Colors
  static const Color border = Color(0xFFE0E0E0);
  static const Color divider = Color(0xFFBDBDBD);

  // Shadow Colors
  static Color shadowLight = withOpacity(Color(0xFF7090B0), 0.1);
  static Color shadowMedium = withOpacity(Colors.black, 0.04);
  static Color shadowDark = withOpacity(Colors.black, 0.3);

  // Overlay Colors
  static Color overlayLight = withOpacity(Colors.black, 0.5);
  static Color overlayMedium = withOpacity(Colors.black, 0.12);
  static Color overlayDark = withOpacity(Colors.black, 0.25);

  static Color withOpacity(Color color, double opacity) {
    return color.withValues(alpha: opacity);
  }
}
