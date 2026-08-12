import 'package:flutter/material.dart';

/// Type scale for ExStreak, built on the bundled Outfit family.
///
/// Screens use these named styles rather than constructing [TextStyle]s
/// inline, which keeps weights and tracking consistent everywhere.
abstract final class AppTypography {
  static const String fontFamily = 'Outfit';

  /// Hero numerals — the rep counter, the streak count.
  static const TextStyle displayXL = TextStyle(
    fontFamily: fontFamily,
    fontSize: 96,
    height: 1.0,
    fontWeight: FontWeight.w800,
    letterSpacing: -3,
  );

  static const TextStyle displayL = TextStyle(
    fontFamily: fontFamily,
    fontSize: 64,
    height: 1.0,
    fontWeight: FontWeight.w800,
    letterSpacing: -2,
  );

  static const TextStyle displayM = TextStyle(
    fontFamily: fontFamily,
    fontSize: 44,
    height: 1.05,
    fontWeight: FontWeight.w700,
    letterSpacing: -1.2,
  );

  static const TextStyle displayS = TextStyle(
    fontFamily: fontFamily,
    fontSize: 32,
    height: 1.1,
    fontWeight: FontWeight.w700,
    letterSpacing: -0.8,
  );

  static const TextStyle titleL = TextStyle(
    fontFamily: fontFamily,
    fontSize: 24,
    height: 1.2,
    fontWeight: FontWeight.w700,
    letterSpacing: -0.4,
  );

  static const TextStyle titleM = TextStyle(
    fontFamily: fontFamily,
    fontSize: 19,
    height: 1.25,
    fontWeight: FontWeight.w600,
    letterSpacing: -0.2,
  );

  static const TextStyle titleS = TextStyle(
    fontFamily: fontFamily,
    fontSize: 16,
    height: 1.3,
    fontWeight: FontWeight.w600,
  );

  static const TextStyle body = TextStyle(
    fontFamily: fontFamily,
    fontSize: 15,
    height: 1.45,
    fontWeight: FontWeight.w400,
  );

  static const TextStyle bodyStrong = TextStyle(
    fontFamily: fontFamily,
    fontSize: 15,
    height: 1.45,
    fontWeight: FontWeight.w600,
  );

  static const TextStyle bodySmall = TextStyle(
    fontFamily: fontFamily,
    fontSize: 13.5,
    height: 1.4,
    fontWeight: FontWeight.w400,
  );

  static const TextStyle caption = TextStyle(
    fontFamily: fontFamily,
    fontSize: 12,
    height: 1.35,
    fontWeight: FontWeight.w500,
  );

  /// Small all-caps section headers ("CURRENT WORKOUT DAY").
  static const TextStyle overline = TextStyle(
    fontFamily: fontFamily,
    fontSize: 11.5,
    height: 1.2,
    fontWeight: FontWeight.w700,
    letterSpacing: 1.4,
  );

  static const TextStyle button = TextStyle(
    fontFamily: fontFamily,
    fontSize: 16,
    height: 1.1,
    fontWeight: FontWeight.w700,
    letterSpacing: 0.1,
  );

  /// Tabular figures for stats rows so digits stay aligned while animating.
  static const List<FontFeature> tabular = [FontFeature.tabularFigures()];

  static TextTheme textTheme(Color primary, Color secondary) {
    return TextTheme(
      displayLarge: displayXL.copyWith(color: primary),
      displayMedium: displayL.copyWith(color: primary),
      displaySmall: displayM.copyWith(color: primary),
      headlineLarge: displayS.copyWith(color: primary),
      headlineMedium: titleL.copyWith(color: primary),
      headlineSmall: titleM.copyWith(color: primary),
      titleLarge: titleM.copyWith(color: primary),
      titleMedium: titleS.copyWith(color: primary),
      titleSmall: caption.copyWith(color: secondary),
      bodyLarge: body.copyWith(color: primary),
      bodyMedium: body.copyWith(color: secondary),
      bodySmall: bodySmall.copyWith(color: secondary),
      labelLarge: button.copyWith(color: primary),
      labelMedium: caption.copyWith(color: secondary),
      labelSmall: overline.copyWith(color: secondary),
    );
  }
}
