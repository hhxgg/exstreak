import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../theme/app_dimens.dart';
import '../theme/app_theme.dart';
import '../theme/app_typography.dart';

/// Text painted with the brand gradient. Used for hero numerals.
class GradientText extends StatelessWidget {
  const GradientText(
    this.text, {
    super.key,
    required this.style,
    this.gradient,
    this.textAlign,
  });

  final String text;
  final TextStyle style;
  final Gradient? gradient;
  final TextAlign? textAlign;

  @override
  Widget build(BuildContext context) {
    final g = gradient ?? context.colors.brandGradientVertical;
    return ShaderMask(
      shaderCallback: (bounds) =>
          g.createShader(Rect.fromLTWH(0, 0, bounds.width, bounds.height)),
      blendMode: BlendMode.srcIn,
      child: Text(
        text,
        textAlign: textAlign,
        style: style.copyWith(color: Colors.white),
      ),
    );
  }
}

/// The big circular progress ring behind the rep counter and timers.
///
/// Draws an inset track plus a gradient arc with rounded caps and a soft outer
/// glow, matching the "energy ring" look of the workout screen.
class ProgressRing extends StatelessWidget {
  const ProgressRing({
    super.key,
    required this.progress,
    required this.child,
    this.size = 260,
    this.strokeWidth = 16,
    this.color,
    this.trackColor,
    this.useGradient = true,
    this.glow = true,
    this.semanticsLabel,
  });

  /// 0…1. Values above 1 are clamped, so an over-target set still reads full.
  final double progress;

  final Widget child;
  final double size;
  final double strokeWidth;

  /// Flat colour; ignored when [useGradient] is true.
  final Color? color;

  final Color? trackColor;
  final bool useGradient;
  final bool glow;
  final String? semanticsLabel;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final value = progress.isNaN ? 0.0 : progress.clamp(0.0, 1.0);
    final arcColor = color ?? c.accent;

    return Semantics(
      label: semanticsLabel,
      value: '${(value * 100).round()}%',
      child: SizedBox(
        width: size,
        height: size,
        child: Stack(
          alignment: Alignment.center,
          children: [
            TweenAnimationBuilder<double>(
              tween: Tween(begin: 0, end: value),
              duration: Motion.normal,
              curve: Motion.emphasized,
              builder: (context, animated, _) => CustomPaint(
                size: Size.square(size),
                painter: _RingPainter(
                  progress: animated,
                  strokeWidth: strokeWidth,
                  trackColor: trackColor ?? c.surfaceSunken,
                  gradient: useGradient ? c.brandGradient : null,
                  color: arcColor,
                  glow: glow,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(strokeWidth + Gap.lg),
              child: child,
            ),
          ],
        ),
      ),
    );
  }
}

class _RingPainter extends CustomPainter {
  const _RingPainter({
    required this.progress,
    required this.strokeWidth,
    required this.trackColor,
    required this.color,
    required this.gradient,
    required this.glow,
  });

  final double progress;
  final double strokeWidth;
  final Color trackColor;
  final Color color;
  final Gradient? gradient;
  final bool glow;

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    final center = rect.center;
    final radius = (size.shortestSide - strokeWidth) / 2;
    final arcRect = Rect.fromCircle(center: center, radius: radius);

    // Start at 12 o'clock and sweep clockwise.
    const startAngle = -math.pi / 2;
    final sweep = 2 * math.pi * progress;

    final track = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round
      ..color = trackColor;
    canvas.drawCircle(center, radius, track);

    if (progress <= 0) return;

    if (glow) {
      final glowPaint = Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth
        ..strokeCap = StrokeCap.round
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 12)
        ..color = color.withValues(alpha: 0.45);
      canvas.drawArc(arcRect, startAngle, sweep, false, glowPaint);
    }

    final arc = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;
    if (gradient != null) {
      arc.shader = SweepGradient(
        startAngle: 0,
        endAngle: 2 * math.pi,
        colors: [
          gradient!.colors.first,
          gradient!.colors.last,
          gradient!.colors.first,
        ],
        transform: const GradientRotation(-math.pi / 2),
      ).createShader(arcRect);
    } else {
      arc.color = color;
    }
    canvas.drawArc(arcRect, startAngle, sweep, false, arc);
  }

  @override
  bool shouldRepaint(_RingPainter old) =>
      old.progress != progress ||
      old.color != color ||
      old.trackColor != trackColor ||
      old.strokeWidth != strokeWidth;
}

/// Number-over-label tile used across stats and summary rows.
class StatTile extends StatelessWidget {
  const StatTile({
    super.key,
    required this.value,
    required this.label,
    this.icon,
    this.iconColor,
    this.unit,
    this.compact = false,
  });

  final String value;
  final String label;
  final IconData? icon;
  final Color? iconColor;
  final String? unit;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (icon != null) ...[
          Container(
            width: 30,
            height: 30,
            decoration: BoxDecoration(
              color: (iconColor ?? c.textSecondary).withValues(alpha: 0.14),
              borderRadius: BorderRadius.circular(Radii.xs),
            ),
            child: Icon(icon, size: 16, color: iconColor ?? c.textSecondary),
          ),
          const SizedBox(height: Gap.md),
        ],
        Row(
          crossAxisAlignment: CrossAxisAlignment.baseline,
          textBaseline: TextBaseline.alphabetic,
          children: [
            Flexible(
              child: Text(
                value,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: (compact ? AppTypography.titleL : AppTypography.displayS)
                    .copyWith(
                      color: c.textPrimary,
                      fontFeatures: AppTypography.tabular,
                    ),
              ),
            ),
            if (unit != null) ...[
              const SizedBox(width: Gap.xs),
              Text(
                unit!,
                style: AppTypography.bodySmall.copyWith(color: c.textSecondary),
              ),
            ],
          ],
        ),
        const SizedBox(height: 2),
        Text(
          label,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: AppTypography.caption.copyWith(color: c.textSecondary),
        ),
      ],
    );
  }
}

/// Horizontal progress bar with a label row above it.
class LinearMeter extends StatelessWidget {
  const LinearMeter({
    super.key,
    required this.progress,
    this.leadingLabel,
    this.trailingLabel,
    this.color,
    this.height = 8,
  });

  final double progress;
  final String? leadingLabel;
  final String? trailingLabel;
  final Color? color;
  final double height;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final value = progress.isNaN ? 0.0 : progress.clamp(0.0, 1.0);
    final tint = color ?? c.accent;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (leadingLabel != null || trailingLabel != null) ...[
          Row(
            children: [
              if (leadingLabel != null)
                Expanded(
                  child: Text(
                    leadingLabel!,
                    style: AppTypography.caption.copyWith(
                      color: c.textSecondary,
                    ),
                  ),
                ),
              if (trailingLabel != null)
                Text(
                  trailingLabel!,
                  style: AppTypography.caption.copyWith(
                    color: c.textPrimary,
                    fontFeatures: AppTypography.tabular,
                  ),
                ),
            ],
          ),
          const SizedBox(height: Gap.sm),
        ],
        ClipRRect(
          borderRadius: BorderRadius.circular(height),
          child: TweenAnimationBuilder<double>(
            tween: Tween(begin: 0, end: value),
            duration: Motion.normal,
            curve: Motion.emphasized,
            builder: (context, animated, _) => LinearProgressIndicator(
              value: animated,
              minHeight: height,
              backgroundColor: c.surfaceSunken,
              valueColor: AlwaysStoppedAnimation(tint),
            ),
          ),
        ),
      ],
    );
  }
}

/// Flame + number, the streak signature element.
class StreakFlame extends StatelessWidget {
  const StreakFlame({
    super.key,
    required this.days,
    this.size = 48,
    this.dimmed = false,
  });

  final int days;
  final double size;

  /// Greys the flame out when the streak is zero.
  final bool dimmed;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final inactive = dimmed || days <= 0;

    return Semantics(
      label: '$days day streak',
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.local_fire_department_rounded,
            size: size,
            color: inactive ? c.textTertiary : c.streakFlame,
            shadows: inactive
                ? null
                : [
                    Shadow(
                      color: c.streakFlame.withValues(alpha: 0.55),
                      blurRadius: 18,
                    ),
                  ],
          ),
          const SizedBox(width: Gap.sm),
          if (inactive)
            Text(
              '$days',
              style: AppTypography.displayS.copyWith(
                fontSize: size * 0.78,
                color: c.textTertiary,
              ),
            )
          else
            GradientText(
              '$days',
              style: AppTypography.displayS.copyWith(fontSize: size * 0.78),
            ),
        ],
      ),
    );
  }
}

/// The row of per-set chips at the top of the workout screen.
class SetChipRow extends StatelessWidget {
  const SetChipRow({
    super.key,
    required this.targets,
    required this.completed,
    required this.activeIndex,
    this.onTapIndex,
  });

  /// Target value per set, in the exercise's unit.
  final List<int> targets;

  /// Whether each set has been logged.
  final List<bool> completed;

  final int activeIndex;
  final ValueChanged<int>? onTapIndex;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        for (var i = 0; i < targets.length; i++)
          Padding(
            padding: EdgeInsets.only(
              right: i == targets.length - 1 ? 0 : Gap.sm,
            ),
            child: _SetChip(
              label: '${targets[i]}',
              isDone: i < completed.length && completed[i],
              isActive: i == activeIndex,
              onTap: onTapIndex == null ? null : () => onTapIndex!(i),
            ),
          ),
      ],
    );
  }
}

class _SetChip extends StatelessWidget {
  const _SetChip({
    required this.label,
    required this.isDone,
    required this.isActive,
    this.onTap,
  });

  final String label;
  final bool isDone;
  final bool isActive;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;

    final border = isDone
        ? c.success
        : isActive
        ? c.accent
        : c.border;
    final fill = isDone
        ? c.successSoft
        : isActive
        ? c.accentSoft
        : c.surfaceSunken;

    return Semantics(
      label: isDone ? 'Set complete' : 'Set target $label',
      selected: isActive,
      child: AnimatedContainer(
        duration: Motion.fast,
        curve: Motion.emphasized,
        width: 54,
        height: 54,
        decoration: BoxDecoration(
          color: fill,
          borderRadius: BorderRadius.circular(Radii.sm),
          border: Border.all(
            color: border,
            width: isActive || isDone ? 1.6 : 1,
          ),
          boxShadow: isActive
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
          borderRadius: BorderRadius.circular(Radii.sm),
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(Radii.sm),
            child: Center(
              child: isDone
                  ? Icon(Icons.check_rounded, size: 24, color: c.success)
                  : Text(
                      label,
                      style: AppTypography.titleM.copyWith(
                        color: isActive ? c.accent : c.textTertiary,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
            ),
          ),
        ),
      ),
    );
  }
}
