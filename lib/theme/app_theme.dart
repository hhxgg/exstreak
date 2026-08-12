import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'app_colors.dart';
import 'app_dimens.dart';
import 'app_typography.dart';

/// Builds the two [ThemeData] variants from [AppColors].
abstract final class AppTheme {
  static ThemeData dark() => _build(AppColors.dark);

  static ThemeData light() => _build(AppColors.light);

  static ThemeData _build(AppColors c) {
    final scheme =
        ColorScheme.fromSeed(
          seedColor: c.accent,
          brightness: c.brightness,
        ).copyWith(
          surface: c.background,
          primary: c.accent,
          onPrimary: c.accentContrast,
          secondary: c.warning,
          error: c.danger,
          onSurface: c.textPrimary,
          outline: c.border,
        );

    return ThemeData(
      useMaterial3: true,
      brightness: c.brightness,
      colorScheme: scheme,
      scaffoldBackgroundColor: c.background,
      canvasColor: c.background,
      fontFamily: AppTypography.fontFamily,
      textTheme: AppTypography.textTheme(c.textPrimary, c.textSecondary),
      splashFactory: InkSparkle.splashFactory,
      extensions: <ThemeExtension<dynamic>>[c],
      appBarTheme: AppBarTheme(
        backgroundColor: c.background,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: true,
        titleTextStyle: AppTypography.titleL.copyWith(color: c.textPrimary),
        iconTheme: IconThemeData(color: c.textPrimary),
        systemOverlayStyle: c.isDark
            ? SystemUiOverlayStyle.light.copyWith(
                statusBarColor: Colors.transparent,
                systemNavigationBarColor: c.background,
                systemNavigationBarIconBrightness: Brightness.light,
              )
            : SystemUiOverlayStyle.dark.copyWith(
                statusBarColor: Colors.transparent,
                systemNavigationBarColor: c.background,
                systemNavigationBarIconBrightness: Brightness.dark,
              ),
      ),
      cardTheme: CardThemeData(
        color: c.surface,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(borderRadius: Radii.cardRadius),
      ),
      dividerTheme: DividerThemeData(color: c.border, thickness: 1, space: 1),
      iconTheme: IconThemeData(color: c.textSecondary, size: 22),
      listTileTheme: ListTileThemeData(
        iconColor: c.textSecondary,
        textColor: c.textPrimary,
        shape: RoundedRectangleBorder(borderRadius: Radii.cardRadius),
      ),
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: c.surface,
        surfaceTintColor: Colors.transparent,
        modalBackgroundColor: c.surface,
        shape: const RoundedRectangleBorder(borderRadius: Radii.sheetRadius),
        showDragHandle: true,
        dragHandleColor: c.borderStrong,
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: c.surfaceElevated,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(Radii.lg),
        ),
        titleTextStyle: AppTypography.titleM.copyWith(color: c.textPrimary),
        contentTextStyle: AppTypography.body.copyWith(color: c.textSecondary),
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: c.surfaceElevated,
        contentTextStyle: AppTypography.bodySmall.copyWith(
          color: c.textPrimary,
        ),
        actionTextColor: c.accent,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(Radii.sm),
        ),
        insetPadding: const EdgeInsets.all(Gap.lg),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: c.surfaceSunken,
        hintStyle: AppTypography.body.copyWith(color: c.textTertiary),
        labelStyle: AppTypography.bodySmall.copyWith(color: c.textSecondary),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: Gap.lg,
          vertical: Gap.lg,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(Radii.sm),
          borderSide: BorderSide(color: c.border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(Radii.sm),
          borderSide: BorderSide(color: c.border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(Radii.sm),
          borderSide: BorderSide(color: c.accent, width: 1.6),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(Radii.sm),
          borderSide: BorderSide(color: c.danger),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(Radii.sm),
          borderSide: BorderSide(color: c.danger, width: 1.6),
        ),
      ),
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith(
          (s) => s.contains(WidgetState.selected)
              ? c.accentContrast
              : c.textTertiary,
        ),
        trackColor: WidgetStateProperty.resolveWith(
          (s) => s.contains(WidgetState.selected) ? c.accent : c.surfaceSunken,
        ),
        trackOutlineColor: WidgetStateProperty.resolveWith(
          (s) => s.contains(WidgetState.selected) ? c.accent : c.borderStrong,
        ),
      ),
      sliderTheme: SliderThemeData(
        activeTrackColor: c.accent,
        inactiveTrackColor: c.surfaceSunken,
        thumbColor: c.accent,
        overlayColor: c.accentSoft,
        trackHeight: 6,
      ),
      progressIndicatorTheme: ProgressIndicatorThemeData(
        color: c.accent,
        linearTrackColor: c.surfaceSunken,
        circularTrackColor: c.surfaceSunken,
      ),
      chipTheme: ChipThemeData(
        backgroundColor: c.surfaceSunken,
        selectedColor: c.accentSoft,
        side: BorderSide(color: c.border),
        labelStyle: AppTypography.caption.copyWith(color: c.textSecondary),
        shape: RoundedRectangleBorder(borderRadius: Radii.pillRadius),
        padding: const EdgeInsets.symmetric(
          horizontal: Gap.md,
          vertical: Gap.sm,
        ),
      ),
      tooltipTheme: TooltipThemeData(
        decoration: BoxDecoration(
          color: c.surfaceElevated,
          borderRadius: BorderRadius.circular(Radii.xs),
          border: Border.all(color: c.border),
        ),
        textStyle: AppTypography.caption.copyWith(color: c.textPrimary),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: c.accent,
          textStyle: AppTypography.bodyStrong,
          minimumSize: const Size(0, Sizes.minTapTarget),
        ),
      ),
      pageTransitionsTheme: const PageTransitionsTheme(
        builders: {
          TargetPlatform.android: FadeForwardsPageTransitionsBuilder(),
        },
      ),
    );
  }
}

/// Sugar for reading the palette: `context.colors.accent`.
extension AppColorsX on BuildContext {
  AppColors get colors =>
      Theme.of(this).extension<AppColors>() ?? AppColors.dark;

  TextTheme get texts => Theme.of(this).textTheme;

  /// Clamped text scaler — keeps very large system font settings from
  /// destroying dense layouts while still honouring user preference.
  double get textScale =>
      MediaQuery.textScalerOf(this).scale(1).clamp(0.85, 1.35);
}
