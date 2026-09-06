import 'package:flutter/material.dart';

/// Design system color tokens for Penny - Modern Ultra-Sleek Financial Product
/// Inspired by Revolut, Wise, and Apple Wallet
class AppColors {
  AppColors._();

  static const Color primaryTeal = Color(0xFF059669);
  static const Color primaryEmerald = Color(0xFF10B981);
  static const Color primaryMint = Color(0xFF34D399);
  static const Color primary = primaryEmerald;
  static const Color onPrimary = Color(0xFFFFFFFF);
  static const Color primaryContainer = Color(0xFF065F46);
  static const Color onPrimaryContainer = Color(0xFFD1FAE5);
  static const Color inversePrimary = Color(0xFF6EE7B7);
  static const Color primaryFixed = Color(0xFFA7F3D0);
  static const Color primaryFixedDim = Color(0xFF6EE7B7);
  static const Color onPrimaryFixed = Color(0xFF022C22);
  static const Color onPrimaryFixedVariant = Color(0xFF064E3B);

  static const Color secondary = Color(0xFFF97316);
  static const Color onSecondary = Color(0xFFFFFFFF);
  static const Color secondaryContainer = Color(0xFFEA580C);
  static const Color onSecondaryContainer = Color(0xFFFFEDD5);
  static const Color secondaryFixed = Color(0xFFFED7AA);
  static const Color secondaryFixedDim = Color(0xFFFDBA74);
  static const Color onSecondaryFixed = Color(0xFF431407);
  static const Color onSecondaryFixedVariant = Color(0xFF7C2D12);

  static const Color tertiary = Color(0xFFF59E0B);
  static const Color onTertiary = Color(0xFFFFFFFF);
  static const Color tertiaryContainer = Color(0xFFD97706);
  static const Color onTertiaryContainer = Color(0xFFFEF3C7);
  static const Color tertiaryFixed = Color(0xFFFDE68A);
  static const Color tertiaryFixedDim = Color(0xFFFCD34D);
  static const Color onTertiaryFixed = Color(0xFF451A03);
  static const Color onTertiaryFixedVariant = Color(0xFF78350F);

  static const Color accentPurple = Color(0xFF8B5CF6);
  static const Color accentIndigo = Color(0xFF6366F1);
  static const Color accentCyan = Color(0xFF06B6D4);
  static const Color accentRose = Color(0xFFF43F5E);

  static const Color error = Color(0xFFEF4444);
  static const Color onError = Color(0xFFFFFFFF);
  static const Color errorContainer = Color(0xFFFEE2E2);
  static const Color onErrorContainer = Color(0xFF7F1D1D);
  static const Color success = primaryEmerald;
  static const Color warning = tertiary;
  static const Color info = accentCyan;

  static const Color lightBgStart = Color(0xFFF8FAFC); // Slate 50
  static const Color lightBgEnd = Color(0xFFF1F5F9); // Slate 100
  static const Color surface = Color(0xFFFFFFFF);
  static const Color surfaceDim = Color(0xFFE2E8F0);
  static const Color surfaceBright = Color(0xFFFFFFFF);
  static const Color surfaceContainerLowest = Color(0xFFFFFFFF);
  static const Color surfaceContainerLow = Color(0xFFF8FAFC);
  static const Color surfaceContainer = Color(0xFFF1F5F9);
  static const Color surfaceContainerHigh = Color(0xFFE2E8F0);
  static const Color surfaceContainerHighest = Color(0xFFCBD5E1);
  static const Color surfaceVariant = Color(0xFFE2E8F0);
  static const Color onSurface = Color(0xFF0F172A); // Slate 900
  static const Color onSurfaceVariant = Color(0xFF64748B); // Slate 500
  static const Color background = lightBgStart;
  static const Color onBackground = Color(0xFF0F172A);

  static const Color darkBgStart = Color(0xFF0F172A); // Slate 900
  static const Color darkBgEnd = Color(0xFF1E293B); // Slate 800
  static const Color darkSurface = Color(0xFF1E293B);
  static const Color darkSurfaceHigh = Color(0xFF334155);
  static const Color darkSurfaceGlass = Color(0x331E293B);
  static const Color darkOnSurface = Color(0xFFF8FAFC);
  static const Color darkOnSurfaceVariant = Color(0xFF94A3B8); // Slate 400
  static const Color darkBackground = darkBgStart;

  static const Color inverseSurface = Color(0xFF1E293B);
  static const Color inverseOnSurface = Color(0xFFF8FAFC);
  static const Color surfaceTint = primaryEmerald;

  static const Color glassBorderLight = Color(0x1F0F172A); // 12% Slate 900
  static const Color glassBorderDark = Color(0x26FFFFFF); // 15% White
  static const Color cardBorder = Color(0xFFE2E8F0);
  static const Color cardBorderDark = Color(0xFF334155);

  static const Color outline = Color(0xFF94A3B8);
  static const Color outlineVariant = Color(0xFFCBD5E1);
  static const Color darkOutlineVariant = Color(0xFF334155);

  static const LinearGradient primaryCardGradient = LinearGradient(
    colors: [primaryTeal, primaryEmerald],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient primaryButtonGradient = LinearGradient(
    colors: [Color(0xFF059669), Color(0xFF10B981)],
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
  );

  static const LinearGradient darkBackgroundGradient = LinearGradient(
    colors: [darkBgStart, darkBgEnd],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  static const LinearGradient lightBackgroundGradient = LinearGradient(
    colors: [lightBgStart, lightBgEnd],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  static const Color gray50 = Color(0xFFF8FAFC);
  static const Color gray100 = Color(0xFFF1F5F9);
  static const Color gray200 = Color(0xFFE2E8F0);
  static const Color gray300 = Color(0xFFCBD5E1);
  static const Color gray400 = Color(0xFF94A3B8);
  static const Color gray500 = Color(0xFF64748B);
  static const Color gray600 = Color(0xFF475569);
  static const Color gray700 = Color(0xFF334155);
  static const Color gray800 = Color(0xFF1E293B);
  static const Color gray900 = Color(0xFF0F172A);
}
