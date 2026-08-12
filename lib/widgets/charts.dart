import 'dart:math' as math;

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../domain/stats/stats_engine.dart';
import '../theme/app_dimens.dart';
import '../theme/app_theme.dart';
import '../theme/app_typography.dart';
import 'surfaces.dart';

/// Bar chart for per-day / per-bucket totals.
///
/// Bars use the brand gradient so the chart reads as part of the app rather
/// than a library default.
class TrendBarChart extends StatelessWidget {
  const TrendBarChart({
    super.key,
    required this.points,
    this.height = 200,
    this.valueFormatter,
    this.maxBars = 24,
    this.emptyMessage = 'No data in this period yet',
  });

  final List<SeriesPoint> points;
  final double height;

  /// Formats the axis labels and tooltip values.
  final String Function(double)? valueFormatter;

  /// Older buckets are dropped so bars never become hairlines.
  final int maxBars;

  final String emptyMessage;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final visible = points.length > maxBars
        ? points.sublist(points.length - maxBars)
        : points;

    final hasData = visible.any((p) => p.value > 0);
    if (!hasData) {
      return SizedBox(
        height: height,
        child: Center(
          child: Text(
            emptyMessage,
            style: AppTypography.bodySmall.copyWith(color: c.textTertiary),
          ),
        ),
      );
    }

    final maxValue = visible.fold<double>(0, (a, p) => math.max(a, p.value));
    final top = _niceCeiling(maxValue);
    final fmt = valueFormatter ?? _defaultFormat;
    final labelEvery = math.max(1, visible.length ~/ 5);

    return SizedBox(
      height: height,
      child: BarChart(
        BarChartData(
          alignment: BarChartAlignment.spaceBetween,
          maxY: top,
          minY: 0,
          barTouchData: BarTouchData(
            enabled: true,
            touchTooltipData: BarTouchTooltipData(
              getTooltipColor: (_) => c.surfaceElevated,
              tooltipBorderRadius: BorderRadius.circular(Radii.xs),
              getTooltipItem: (group, _, rod, _) {
                final p = visible[group.x.toInt()];
                return BarTooltipItem(
                  '${fmt(rod.toY)}\n',
                  AppTypography.bodyStrong.copyWith(color: c.textPrimary),
                  children: [
                    TextSpan(
                      text: DateFormat.MMMd().format(p.day.startOfDay),
                      style: AppTypography.caption.copyWith(
                        color: c.textSecondary,
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
          gridData: FlGridData(
            show: true,
            drawVerticalLine: false,
            horizontalInterval: top / 2,
            getDrawingHorizontalLine: (_) =>
                FlLine(color: c.border, strokeWidth: 1),
          ),
          borderData: FlBorderData(show: false),
          titlesData: FlTitlesData(
            topTitles: const AxisTitles(),
            rightTitles: const AxisTitles(),
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 40,
                interval: top / 2,
                getTitlesWidget: (value, _) => Padding(
                  padding: const EdgeInsets.only(right: Gap.sm),
                  child: Text(
                    fmt(value),
                    style: AppTypography.caption.copyWith(
                      color: c.textTertiary,
                      fontSize: 10.5,
                    ),
                  ),
                ),
              ),
            ),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 26,
                getTitlesWidget: (value, _) {
                  final i = value.toInt();
                  if (i < 0 || i >= visible.length) {
                    return const SizedBox.shrink();
                  }
                  if (i % labelEvery != 0 && i != visible.length - 1) {
                    return const SizedBox.shrink();
                  }
                  return Padding(
                    padding: const EdgeInsets.only(top: Gap.sm),
                    child: Text(
                      DateFormat.Md().format(visible[i].day.startOfDay),
                      style: AppTypography.caption.copyWith(
                        color: c.textTertiary,
                        fontSize: 10.5,
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          barGroups: [
            for (var i = 0; i < visible.length; i++)
              BarChartGroupData(
                x: i,
                barRods: [
                  BarChartRodData(
                    toY: visible[i].value,
                    width: math.max(4, 160 / visible.length),
                    borderRadius: BorderRadius.circular(4),
                    gradient: visible[i].value > 0
                        ? LinearGradient(
                            colors: [c.gradientStart, c.gradientEnd],
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                          )
                        : null,
                    color: visible[i].value > 0 ? null : c.surfaceSunken,
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }

  static String _defaultFormat(double v) =>
      v >= 1000 ? '${(v / 1000).toStringAsFixed(1)}k' : v.round().toString();

  /// Rounds the axis maximum up to a readable number.
  static double _niceCeiling(double max) {
    if (max <= 0) return 10;
    final magnitude = math
        .pow(10, (math.log(max) / math.ln10).floor())
        .toDouble();
    final normalised = max / magnitude;
    final step = normalised <= 1
        ? 1.0
        : normalised <= 2
        ? 2.0
        : normalised <= 5
        ? 5.0
        : 10.0;
    return step * magnitude;
  }
}

/// Line chart for progression series such as best set or estimated 1RM.
class ProgressLineChart extends StatelessWidget {
  const ProgressLineChart({
    super.key,
    required this.points,
    this.height = 200,
    this.valueFormatter,
    this.emptyMessage = 'Log a few sessions to see your trend',
  });

  final List<SeriesPoint> points;
  final double height;
  final String Function(double)? valueFormatter;
  final String emptyMessage;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    if (points.length < 2) {
      return SizedBox(
        height: height,
        child: Center(
          child: Text(
            emptyMessage,
            textAlign: TextAlign.center,
            style: AppTypography.bodySmall.copyWith(color: c.textTertiary),
          ),
        ),
      );
    }

    final fmt = valueFormatter ?? TrendBarChart._defaultFormat;
    final values = points.map((p) => p.value).toList();
    final maxValue = values.reduce(math.max);
    final minValue = values.reduce(math.min);
    final pad = math.max(1.0, (maxValue - minValue) * 0.15);
    final top = maxValue + pad;
    final bottom = math.max(0.0, minValue - pad);
    final labelEvery = math.max(1, points.length ~/ 4);

    return SizedBox(
      height: height,
      child: LineChart(
        LineChartData(
          minY: bottom,
          maxY: top,
          lineTouchData: LineTouchData(
            touchTooltipData: LineTouchTooltipData(
              getTooltipColor: (_) => c.surfaceElevated,
              tooltipBorderRadius: BorderRadius.circular(Radii.xs),
              getTooltipItems: (spots) => [
                for (final s in spots)
                  LineTooltipItem(
                    '${fmt(s.y)}\n',
                    AppTypography.bodyStrong.copyWith(color: c.textPrimary),
                    children: [
                      TextSpan(
                        text: DateFormat.MMMd().format(
                          points[s.x.toInt()].day.startOfDay,
                        ),
                        style: AppTypography.caption.copyWith(
                          color: c.textSecondary,
                        ),
                      ),
                    ],
                  ),
              ],
            ),
          ),
          gridData: FlGridData(
            show: true,
            drawVerticalLine: false,
            horizontalInterval: math.max(1, (top - bottom) / 3),
            getDrawingHorizontalLine: (_) =>
                FlLine(color: c.border, strokeWidth: 1),
          ),
          borderData: FlBorderData(show: false),
          titlesData: FlTitlesData(
            topTitles: const AxisTitles(),
            rightTitles: const AxisTitles(),
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 40,
                interval: math.max(1, (top - bottom) / 3),
                getTitlesWidget: (value, _) => Padding(
                  padding: const EdgeInsets.only(right: Gap.sm),
                  child: Text(
                    fmt(value),
                    style: AppTypography.caption.copyWith(
                      color: c.textTertiary,
                      fontSize: 10.5,
                    ),
                  ),
                ),
              ),
            ),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 26,
                getTitlesWidget: (value, _) {
                  final i = value.toInt();
                  if (i < 0 || i >= points.length) {
                    return const SizedBox.shrink();
                  }
                  if (i % labelEvery != 0 && i != points.length - 1) {
                    return const SizedBox.shrink();
                  }
                  return Padding(
                    padding: const EdgeInsets.only(top: Gap.sm),
                    child: Text(
                      DateFormat.Md().format(points[i].day.startOfDay),
                      style: AppTypography.caption.copyWith(
                        color: c.textTertiary,
                        fontSize: 10.5,
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          lineBarsData: [
            LineChartBarData(
              spots: [
                for (var i = 0; i < points.length; i++)
                  FlSpot(i.toDouble(), points[i].value),
              ],
              isCurved: true,
              curveSmoothness: 0.25,
              barWidth: 3,
              gradient: LinearGradient(
                colors: [c.gradientStart, c.gradientEnd],
              ),
              dotData: FlDotData(
                show: points.length <= 20,
                getDotPainter: (_, _, _, _) => FlDotCirclePainter(
                  radius: 3.5,
                  color: c.gradientEnd,
                  strokeWidth: 2,
                  strokeColor: c.background,
                ),
              ),
              belowBarData: BarAreaData(
                show: true,
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    c.gradientEnd.withValues(alpha: 0.28),
                    c.gradientEnd.withValues(alpha: 0.0),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Horizontal breakdown bars — used for the muscle-group split.
class BreakdownBars extends StatelessWidget {
  const BreakdownBars({
    super.key,
    required this.entries,
    this.emptyMessage = 'Nothing logged yet',
  });

  /// Label + value pairs, largest first.
  final List<({String label, int value, IconData icon})> entries;

  final String emptyMessage;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    if (entries.isEmpty) {
      return EmptyState(
        icon: Icons.donut_small_rounded,
        title: 'No split yet',
        message: emptyMessage,
        compact: true,
      );
    }

    final total = entries.fold<int>(0, (a, e) => a + e.value);
    if (total == 0) {
      return EmptyState(
        icon: Icons.donut_small_rounded,
        title: 'No split yet',
        message: emptyMessage,
        compact: true,
      );
    }

    return Column(
      children: [
        for (final e in entries)
          Padding(
            padding: const EdgeInsets.only(bottom: Gap.md),
            child: Row(
              children: [
                Icon(e.icon, size: 16, color: c.textTertiary),
                const SizedBox(width: Gap.sm),
                SizedBox(
                  width: 82,
                  child: Text(
                    e.label,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTypography.bodySmall.copyWith(
                      color: c.textSecondary,
                    ),
                  ),
                ),
                Expanded(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: TweenAnimationBuilder<double>(
                      tween: Tween(begin: 0, end: e.value / total),
                      duration: Motion.normal,
                      curve: Motion.emphasized,
                      builder: (context, v, _) => LinearProgressIndicator(
                        value: v,
                        minHeight: 8,
                        backgroundColor: c.surfaceSunken,
                        valueColor: AlwaysStoppedAnimation(c.accent),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: Gap.md),
                SizedBox(
                  width: 34,
                  child: Text(
                    '${((e.value / total) * 100).round()}%',
                    textAlign: TextAlign.end,
                    style: AppTypography.caption.copyWith(
                      color: c.textPrimary,
                      fontFeatures: AppTypography.tabular,
                    ),
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}
