import 'package:flutter/material.dart';

/// Central colour palette for ExStreak.
///
/// Every colour used anywhere in the app is defined here so the whole product
/// can be re-skinned by editing this one file. Screens must never hard-code a
/// [Color] literal — they read from [AppColors] via `context.colors`.
@immutable
class AppColors extends ThemeExtension<AppColors> {
  const AppColors({
    required this.brightness,
    required this.background,
    required this.surface,
    required this.surfaceElevated,
    required this.surfaceSunken,
    required this.border,
    required this.borderStrong,
    required this.textPrimary,
    required this.textSecondary,
    required this.textTertiary,
    required this.accent,
    required this.accentSoft,
    required this.accentContrast,
    required this.gradientStart,
    required this.gradientEnd,
    required this.success,
    required this.successSoft,
    required this.warning,
    required this.warningSoft,
    required this.danger,
    required this.dangerSoft,
    required this.info,
    required this.infoSoft,
    required this.streakFlame,
    required this.shadow,
  });

  final Brightness brightness;

  /// App scaffold background.
  final Color background;

  /// Default card background.
  final Color surface;

  /// Card sitting on top of another card.
  final Color surfaceElevated;

  /// Inset wells, chart backgrounds, progress tracks.
  final Color surfaceSunken;

  final Color border;
  final Color borderStrong;

  final Color textPrimary;
  final Color textSecondary;
  final Color textTertiary;

  /// Brand accent — the single colour that means "action" in this app.
  final Color accent;

  /// Tinted accent background for chips and soft fills.
  final Color accentSoft;

  /// Text/icon colour that sits legibly on top of [accent].
  final Color accentContrast;

  /// Brand gradient, used for hero numbers, rings and the primary CTA.
  final Color gradientStart;
  final Color gradientEnd;

  final Color success;
  final Color successSoft;
  final Color warning;
  final Color warningSoft;
  final Color danger;
  final Color dangerSoft;
  final Color info;
  final Color infoSoft;

  /// Streak flame highlight.
  final Color streakFlame;

  final Color shadow;

  bool get isDark => brightness == Brightness.dark;

  /// The brand gradient as a reusable [LinearGradient].
  LinearGradient get brandGradient => LinearGradient(
    colors: [gradientStart, gradientEnd],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  /// Vertical variant used for big display numerals.
  LinearGradient get brandGradientVertical => LinearGradient(
    colors: [gradientStart, gradientEnd],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  static const AppColors dark = AppColors(
    brightness: Brightness.dark,
    background: Color(0xFF0B0B0F),
    surface: Color(0xFF16161D),
    surfaceElevated: Color(0xFF1F1F29),
    surfaceSunken: Color(0xFF101016),
    border: Color(0xFF26262F),
    borderStrong: Color(0xFF383843),
    textPrimary: Color(0xFFF5F5F7),
    textSecondary: Color(0xFF9E9EAC),
    textTertiary: Color(0xFF6B6B78),
    accent: Color(0xFFFF4B2B),
    accentSoft: Color(0x1FFF4B2B),
    accentContrast: Color(0xFFFFFFFF),
    gradientStart: Color(0xFFFFC24B),
    gradientEnd: Color(0xFFFF3D1F),
    success: Color(0xFF35D07F),
    successSoft: Color(0x1F35D07F),
    warning: Color(0xFFFFB020),
    warningSoft: Color(0x1FFFB020),
    danger: Color(0xFFFF5A5A),
    dangerSoft: Color(0x1FFF5A5A),
    info: Color(0xFF4DA3FF),
    infoSoft: Color(0x1F4DA3FF),
    streakFlame: Color(0xFFFFA31A),
    shadow: Color(0x66000000),
  );

  static const AppColors light = AppColors(
    brightness: Brightness.light,
    background: Color(0xFFF6F6F9),
    surface: Color(0xFFFFFFFF),
    surfaceElevated: Color(0xFFFFFFFF),
    surfaceSunken: Color(0xFFEDEDF2),
    border: Color(0xFFE2E2EA),
    borderStrong: Color(0xFFCBCBD6),
    textPrimary: Color(0xFF15151C),
    textSecondary: Color(0xFF5A5A68),
    textTertiary: Color(0xFF8A8A98),
    accent: Color(0xFFE23A18),
    accentSoft: Color(0x14E23A18),
    accentContrast: Color(0xFFFFFFFF),
    gradientStart: Color(0xFFF5A623),
    gradientEnd: Color(0xFFE23A18),
    success: Color(0xFF119E5C),
    successSoft: Color(0x14119E5C),
    warning: Color(0xFFC97C00),
    warningSoft: Color(0x14C97C00),
    danger: Color(0xFFD93838),
    dangerSoft: Color(0x14D93838),
    info: Color(0xFF1B6FD1),
    infoSoft: Color(0x141B6FD1),
    streakFlame: Color(0xFFEF8A15),
    shadow: Color(0x14000000),
  );

  @override
  AppColors copyWith({
    Brightness? brightness,
    Color? background,
    Color? surface,
    Color? surfaceElevated,
    Color? surfaceSunken,
    Color? border,
    Color? borderStrong,
    Color? textPrimary,
    Color? textSecondary,
    Color? textTertiary,
    Color? accent,
    Color? accentSoft,
    Color? accentContrast,
    Color? gradientStart,
    Color? gradientEnd,
    Color? success,
    Color? successSoft,
    Color? warning,
    Color? warningSoft,
    Color? danger,
    Color? dangerSoft,
    Color? info,
    Color? infoSoft,
    Color? streakFlame,
    Color? shadow,
  }) {
    return AppColors(
      brightness: brightness ?? this.brightness,
      background: background ?? this.background,
      surface: surface ?? this.surface,
      surfaceElevated: surfaceElevated ?? this.surfaceElevated,
      surfaceSunken: surfaceSunken ?? this.surfaceSunken,
      border: border ?? this.border,
      borderStrong: borderStrong ?? this.borderStrong,
      textPrimary: textPrimary ?? this.textPrimary,
      textSecondary: textSecondary ?? this.textSecondary,
      textTertiary: textTertiary ?? this.textTertiary,
      accent: accent ?? this.accent,
      accentSoft: accentSoft ?? this.accentSoft,
      accentContrast: accentContrast ?? this.accentContrast,
      gradientStart: gradientStart ?? this.gradientStart,
      gradientEnd: gradientEnd ?? this.gradientEnd,
      success: success ?? this.success,
      successSoft: successSoft ?? this.successSoft,
      warning: warning ?? this.warning,
      warningSoft: warningSoft ?? this.warningSoft,
      danger: danger ?? this.danger,
      dangerSoft: dangerSoft ?? this.dangerSoft,
      info: info ?? this.info,
      infoSoft: infoSoft ?? this.infoSoft,
      streakFlame: streakFlame ?? this.streakFlame,
      shadow: shadow ?? this.shadow,
    );
  }

  @override
  AppColors lerp(ThemeExtension<AppColors>? other, double t) {
    if (other is! AppColors) return this;
    Color c(Color a, Color b) => Color.lerp(a, b, t)!;
    return AppColors(
      brightness: t < 0.5 ? brightness : other.brightness,
      background: c(background, other.background),
      surface: c(surface, other.surface),
      surfaceElevated: c(surfaceElevated, other.surfaceElevated),
      surfaceSunken: c(surfaceSunken, other.surfaceSunken),
      border: c(border, other.border),
      borderStrong: c(borderStrong, other.borderStrong),
      textPrimary: c(textPrimary, other.textPrimary),
      textSecondary: c(textSecondary, other.textSecondary),
      textTertiary: c(textTertiary, other.textTertiary),
      accent: c(accent, other.accent),
      accentSoft: c(accentSoft, other.accentSoft),
      accentContrast: c(accentContrast, other.accentContrast),
      gradientStart: c(gradientStart, other.gradientStart),
      gradientEnd: c(gradientEnd, other.gradientEnd),
      success: c(success, other.success),
      successSoft: c(successSoft, other.successSoft),
      warning: c(warning, other.warning),
      warningSoft: c(warningSoft, other.warningSoft),
      danger: c(danger, other.danger),
      dangerSoft: c(dangerSoft, other.dangerSoft),
      info: c(info, other.info),
      infoSoft: c(infoSoft, other.infoSoft),
      streakFlame: c(streakFlame, other.streakFlame),
      shadow: c(shadow, other.shadow),
    );
  }
}
