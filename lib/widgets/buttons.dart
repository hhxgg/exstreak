import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../theme/app_dimens.dart';
import '../theme/app_theme.dart';
import '../theme/app_typography.dart';

/// The single most important action on a screen.
class PrimaryButton extends StatelessWidget {
  const PrimaryButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
    this.expanded = true,
    this.loading = false,
    this.gradient = false,
    this.height = Sizes.buttonHeight,
  });

  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;
  final bool expanded;
  final bool loading;

  /// Uses the brand gradient instead of a flat accent fill.
  final bool gradient;

  final double height;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final enabled = onPressed != null && !loading;

    final child = loading
        ? SizedBox(
            height: 22,
            width: 22,
            child: CircularProgressIndicator(
              strokeWidth: 2.4,
              valueColor: AlwaysStoppedAnimation(c.accentContrast),
            ),
          )
        : Row(
            mainAxisSize: expanded ? MainAxisSize.max : MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (icon != null) ...[
                Icon(icon, size: 20, color: c.accentContrast),
                const SizedBox(width: Gap.sm),
              ],
              Flexible(
                child: Text(
                  label,
                  overflow: TextOverflow.ellipsis,
                  style: AppTypography.button.copyWith(color: c.accentContrast),
                ),
              ),
            ],
          );

    return Semantics(
      button: true,
      enabled: enabled,
      label: label,
      child: Opacity(
        opacity: enabled ? 1 : 0.45,
        child: SizedBox(
          height: height,
          width: expanded ? double.infinity : null,
          child: DecoratedBox(
            decoration: BoxDecoration(
              gradient: gradient ? c.brandGradient : null,
              color: gradient ? null : c.accent,
              borderRadius: Radii.pillRadius,
              boxShadow: enabled
                  ? [
                      BoxShadow(
                        color: c.accent.withValues(alpha: 0.32),
                        blurRadius: 20,
                        offset: const Offset(0, 6),
                        spreadRadius: -6,
                      ),
                    ]
                  : null,
            ),
            child: Material(
              color: Colors.transparent,
              borderRadius: Radii.pillRadius,
              child: InkWell(
                onTap: enabled
                    ? () {
                        HapticFeedback.lightImpact();
                        onPressed!();
                      }
                    : null,
                borderRadius: Radii.pillRadius,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: Gap.xl),
                  child: Center(child: child),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Neutral action that sits beside a [PrimaryButton].
class SecondaryButton extends StatelessWidget {
  const SecondaryButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
    this.expanded = true,
    this.tone,
    this.height = Sizes.buttonHeight,
  });

  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;
  final bool expanded;

  /// Overrides the label/icon colour, e.g. danger red for destructive actions.
  final Color? tone;

  final double height;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final fg = tone ?? c.textPrimary;
    final enabled = onPressed != null;

    return Semantics(
      button: true,
      enabled: enabled,
      label: label,
      child: Opacity(
        opacity: enabled ? 1 : 0.45,
        child: SizedBox(
          height: height,
          width: expanded ? double.infinity : null,
          child: Material(
            color: c.surfaceElevated,
            borderRadius: Radii.pillRadius,
            child: InkWell(
              onTap: enabled
                  ? () {
                      HapticFeedback.selectionClick();
                      onPressed!();
                    }
                  : null,
              borderRadius: Radii.pillRadius,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: Gap.xl),
                child: Row(
                  mainAxisSize: expanded ? MainAxisSize.max : MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (icon != null) ...[
                      Icon(icon, size: 20, color: fg),
                      const SizedBox(width: Gap.sm),
                    ],
                    Flexible(
                      child: Text(
                        label,
                        overflow: TextOverflow.ellipsis,
                        style: AppTypography.button.copyWith(color: fg),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Circular icon button used in app bars and card corners.
class IconPill extends StatelessWidget {
  const IconPill({
    super.key,
    required this.icon,
    required this.onPressed,
    this.tooltip,
    this.size = Sizes.iconChip,
    this.background,
    this.foreground,
  });

  final IconData icon;
  final VoidCallback? onPressed;
  final String? tooltip;
  final double size;
  final Color? background;
  final Color? foreground;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final button = SizedBox(
      // Keeps the tap target accessible even when the visual is small.
      width: size < Sizes.minTapTarget ? Sizes.minTapTarget : size,
      height: size < Sizes.minTapTarget ? Sizes.minTapTarget : size,
      child: Center(
        child: Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            color: background ?? c.surfaceElevated,
            shape: BoxShape.circle,
            border: Border.all(color: c.border),
          ),
          child: Material(
            color: Colors.transparent,
            shape: const CircleBorder(),
            child: InkWell(
              customBorder: const CircleBorder(),
              onTap: onPressed,
              child: Icon(
                icon,
                size: size * 0.48,
                color: foreground ?? c.textPrimary,
              ),
            ),
          ),
        ),
      ),
    );

    return tooltip == null ? button : Tooltip(message: tooltip!, child: button);
  }
}

/// Two-or-more option pill selector, as used for Pushups / Planks.
class SegmentedToggle<T> extends StatelessWidget {
  const SegmentedToggle({
    super.key,
    required this.options,
    required this.selected,
    required this.onChanged,
    this.labelOf,
    this.dense = false,
  });

  final List<T> options;
  final T selected;
  final ValueChanged<T> onChanged;
  final String Function(T)? labelOf;
  final bool dense;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: c.surfaceSunken,
        borderRadius: Radii.pillRadius,
        border: Border.all(color: c.border),
      ),
      child: Row(
        children: [
          for (final option in options)
            Expanded(
              child: _Segment(
                label: labelOf?.call(option) ?? option.toString(),
                isSelected: option == selected,
                dense: dense,
                onTap: () {
                  if (option == selected) return;
                  HapticFeedback.selectionClick();
                  onChanged(option);
                },
              ),
            ),
        ],
      ),
    );
  }
}

class _Segment extends StatelessWidget {
  const _Segment({
    required this.label,
    required this.isSelected,
    required this.onTap,
    required this.dense,
  });

  final String label;
  final bool isSelected;
  final VoidCallback onTap;
  final bool dense;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Semantics(
      selected: isSelected,
      button: true,
      child: AnimatedContainer(
        duration: Motion.fast,
        curve: Motion.emphasized,
        height: dense ? 36 : 44,
        decoration: BoxDecoration(
          color: isSelected ? c.accent : Colors.transparent,
          borderRadius: Radii.pillRadius,
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: c.accent.withValues(alpha: 0.35),
                    blurRadius: 16,
                    spreadRadius: -4,
                  ),
                ]
              : null,
        ),
        child: Material(
          color: Colors.transparent,
          borderRadius: Radii.pillRadius,
          child: InkWell(
            onTap: onTap,
            borderRadius: Radii.pillRadius,
            child: Center(
              child: Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTypography.titleS.copyWith(
                  fontSize: dense ? 14 : 16,
                  color: isSelected ? c.accentContrast : c.textSecondary,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// A tappable settings/navigation row.
class AppListTile extends StatelessWidget {
  const AppListTile({
    super.key,
    required this.title,
    this.subtitle,
    this.leadingIcon,
    this.leadingColor,
    this.trailing,
    this.onTap,
    this.showChevron = true,
    this.titleColor,
  });

  final String title;
  final String? subtitle;
  final IconData? leadingIcon;
  final Color? leadingColor;
  final Widget? trailing;
  final VoidCallback? onTap;
  final bool showChevron;
  final Color? titleColor;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final tint = leadingColor ?? c.accent;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(Radii.sm),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: Gap.lg,
            vertical: Gap.md,
          ),
          child: Row(
            children: [
              if (leadingIcon != null) ...[
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: tint.withValues(alpha: 0.14),
                    borderRadius: BorderRadius.circular(Radii.xs),
                  ),
                  child: Icon(leadingIcon, size: 19, color: tint),
                ),
                const SizedBox(width: Gap.md),
              ],
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      title,
                      style: AppTypography.titleS.copyWith(
                        color: titleColor ?? c.textPrimary,
                      ),
                    ),
                    if (subtitle != null) ...[
                      const SizedBox(height: 2),
                      Text(
                        subtitle!,
                        style: AppTypography.bodySmall.copyWith(
                          color: c.textSecondary,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              ?trailing,
              if (trailing == null && showChevron && onTap != null)
                Icon(
                  Icons.chevron_right_rounded,
                  size: 22,
                  color: c.textTertiary,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
