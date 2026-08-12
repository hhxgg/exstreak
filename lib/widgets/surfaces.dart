import 'package:flutter/material.dart';

import '../theme/app_dimens.dart';
import '../theme/app_theme.dart';
import '../theme/app_typography.dart';

/// The standard content container. Everything that groups information sits in
/// one of these, so surfaces read consistently across the app.
class AppCard extends StatelessWidget {
  const AppCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(Gap.lg),
    this.onTap,
    this.accented = false,
    this.borderColor,
    this.background,
    this.margin,
    this.semanticLabel,
  });

  final Widget child;
  final EdgeInsetsGeometry padding;
  final VoidCallback? onTap;

  /// Draws the accent border + glow used for "this is the next thing to do".
  final bool accented;

  final Color? borderColor;
  final Color? background;
  final EdgeInsetsGeometry? margin;
  final String? semanticLabel;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final border = borderColor ?? (accented ? c.accent : c.border);

    final content = DecoratedBox(
      decoration: BoxDecoration(
        color: background ?? c.surface,
        borderRadius: Radii.cardRadius,
        border: Border.all(color: border, width: accented ? 1.4 : 1),
        boxShadow: accented
            ? [
                BoxShadow(
                  color: c.accent.withValues(alpha: 0.18),
                  blurRadius: 24,
                  spreadRadius: -6,
                ),
              ]
            : null,
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: Radii.cardRadius,
        child: InkWell(
          onTap: onTap,
          borderRadius: Radii.cardRadius,
          child: Padding(padding: padding, child: child),
        ),
      ),
    );

    final padded = margin == null
        ? content
        : Padding(padding: margin!, child: content);

    return semanticLabel == null
        ? padded
        : Semantics(label: semanticLabel, button: onTap != null, child: padded);
  }
}

/// All-caps section label with an optional trailing action.
class SectionHeader extends StatelessWidget {
  const SectionHeader({
    super.key,
    required this.title,
    this.action,
    this.onActionTap,
    this.padding = const EdgeInsets.only(bottom: Gap.md),
  });

  final String title;
  final String? action;
  final VoidCallback? onActionTap;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Padding(
      padding: padding,
      child: Row(
        children: [
          Expanded(
            child: Text(
              title.toUpperCase(),
              style: AppTypography.overline.copyWith(color: c.textTertiary),
            ),
          ),
          if (action != null)
            TextButton(
              onPressed: onActionTap,
              style: TextButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: Gap.sm),
                minimumSize: const Size(0, 32),
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              child: Text(
                action!,
                style: AppTypography.caption.copyWith(color: c.accent),
              ),
            ),
        ],
      ),
    );
  }
}

/// Shown when a list has nothing in it yet. Deliberately encouraging rather
/// than error-shaped — an empty history is a starting point, not a failure.
class EmptyState extends StatelessWidget {
  const EmptyState({
    super.key,
    required this.icon,
    required this.title,
    required this.message,
    this.actionLabel,
    this.onAction,
    this.compact = false,
  });

  final IconData icon;
  final String title;
  final String message;
  final String? actionLabel;
  final VoidCallback? onAction;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: Gap.xl,
        vertical: compact ? Gap.xl : Gap.giant,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: compact ? 52 : 72,
            height: compact ? 52 : 72,
            decoration: BoxDecoration(
              color: c.surfaceSunken,
              shape: BoxShape.circle,
              border: Border.all(color: c.border),
            ),
            child: Icon(icon, size: compact ? 24 : 32, color: c.textTertiary),
          ),
          const SizedBox(height: Gap.lg),
          Text(
            title,
            textAlign: TextAlign.center,
            style: AppTypography.titleS.copyWith(color: c.textPrimary),
          ),
          const SizedBox(height: Gap.sm),
          Text(
            message,
            textAlign: TextAlign.center,
            style: AppTypography.bodySmall.copyWith(color: c.textSecondary),
          ),
          if (actionLabel != null && onAction != null) ...[
            const SizedBox(height: Gap.xl),
            FilledButton(
              onPressed: onAction,
              style: FilledButton.styleFrom(
                backgroundColor: c.accent,
                foregroundColor: c.accentContrast,
                padding: const EdgeInsets.symmetric(
                  horizontal: Gap.xxl,
                  vertical: Gap.md,
                ),
                shape: const RoundedRectangleBorder(
                  borderRadius: Radii.pillRadius,
                ),
              ),
              child: Text(actionLabel!, style: AppTypography.button),
            ),
          ],
        ],
      ),
    );
  }
}

/// Inline note — used for tips, warnings and permission prompts.
class InfoBanner extends StatelessWidget {
  const InfoBanner({
    super.key,
    required this.message,
    this.icon = Icons.info_outline_rounded,
    this.tone = BannerTone.info,
    this.actionLabel,
    this.onAction,
  });

  final String message;
  final IconData icon;
  final BannerTone tone;
  final String? actionLabel;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final (fg, bg) = switch (tone) {
      BannerTone.info => (c.info, c.infoSoft),
      BannerTone.warning => (c.warning, c.warningSoft),
      BannerTone.danger => (c.danger, c.dangerSoft),
      BannerTone.success => (c.success, c.successSoft),
    };

    return Container(
      padding: const EdgeInsets.all(Gap.md),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(Radii.sm),
        border: Border.all(color: fg.withValues(alpha: 0.35)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 18, color: fg),
          const SizedBox(width: Gap.md),
          Expanded(
            child: Text(
              message,
              style: AppTypography.bodySmall.copyWith(color: c.textPrimary),
            ),
          ),
          if (actionLabel != null && onAction != null)
            TextButton(
              onPressed: onAction,
              style: TextButton.styleFrom(
                foregroundColor: fg,
                padding: const EdgeInsets.symmetric(horizontal: Gap.sm),
                minimumSize: const Size(0, 32),
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              child: Text(actionLabel!, style: AppTypography.caption),
            ),
        ],
      ),
    );
  }
}

enum BannerTone { info, warning, danger, success }

/// Small rounded label used for muscle groups, equipment and difficulty.
class TagChip extends StatelessWidget {
  const TagChip({
    super.key,
    required this.label,
    this.icon,
    this.color,
    this.dense = false,
  });

  final String label;
  final IconData? icon;
  final Color? color;
  final bool dense;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final tint = color ?? c.textSecondary;
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: dense ? Gap.sm : Gap.md,
        vertical: dense ? Gap.xs : Gap.sm - 2,
      ),
      decoration: BoxDecoration(
        color: tint.withValues(alpha: 0.12),
        borderRadius: Radii.pillRadius,
        border: Border.all(color: tint.withValues(alpha: 0.25)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: dense ? 12 : 14, color: tint),
            const SizedBox(width: Gap.xs),
          ],
          Text(
            label,
            style: AppTypography.caption.copyWith(
              color: tint,
              fontSize: dense ? 11 : 12,
            ),
          ),
        ],
      ),
    );
  }
}

/// Standard screen scaffold: consistent title, back button and padding.
class AppScreen extends StatelessWidget {
  const AppScreen({
    super.key,
    required this.child,
    this.title,
    this.actions,
    this.showBack = true,
    this.padded = true,
    this.floatingActionButton,
    this.bottomBar,
  });

  final Widget child;
  final String? title;
  final List<Widget>? actions;
  final bool showBack;
  final bool padded;
  final Widget? floatingActionButton;
  final Widget? bottomBar;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Scaffold(
      backgroundColor: c.background,
      appBar: title == null
          ? null
          : AppBar(
              automaticallyImplyLeading: showBack,
              title: Text(title!),
              actions: actions,
            ),
      floatingActionButton: floatingActionButton,
      bottomNavigationBar: bottomBar,
      body: SafeArea(
        top: title == null,
        child: padded
            ? Padding(
                padding: const EdgeInsets.symmetric(horizontal: Gap.screenH),
                child: child,
              )
            : child,
      ),
    );
  }
}
