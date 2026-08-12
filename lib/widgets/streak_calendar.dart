import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../core/day.dart';
import '../domain/stats/stats_engine.dart';
import '../theme/app_dimens.dart';
import '../theme/app_theme.dart';
import '../theme/app_typography.dart';
import 'buttons.dart';

/// Month grid showing which days were trained, frozen or missed.
class StreakCalendar extends StatefulWidget {
  const StreakCalendar({
    super.key,
    required this.activity,
    this.initialMonth,
    this.onDayTap,
  });

  final List<ActivityPoint> activity;
  final Day? initialMonth;
  final void Function(Day day, ActivityPoint? point)? onDayTap;

  @override
  State<StreakCalendar> createState() => _StreakCalendarState();
}

class _StreakCalendarState extends State<StreakCalendar> {
  late Day _month = (widget.initialMonth ?? Day.today()).startOfMonth;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final today = Day.today();
    final byDay = {for (final p in widget.activity) p.day: p};

    final firstOfMonth = _month;
    final daysInMonth = Day(
      firstOfMonth.year,
      firstOfMonth.month + 1,
      1,
    ).previous.dayOfMonth;

    // Monday-first grid.
    final leadingBlanks = firstOfMonth.weekday - 1;
    final cells = leadingBlanks + daysInMonth;
    final rows = (cells / 7).ceil();

    final canGoForward = firstOfMonth.isBefore(today.startOfMonth);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                DateFormat.yMMMM().format(firstOfMonth.startOfDay),
                style: AppTypography.titleM.copyWith(color: c.textPrimary),
              ),
            ),
            IconPill(
              icon: Icons.chevron_left_rounded,
              size: 34,
              tooltip: 'Previous month',
              onPressed: () => setState(() {
                _month = Day(firstOfMonth.year, firstOfMonth.month - 1, 1);
              }),
            ),
            const SizedBox(width: Gap.xs),
            IconPill(
              icon: Icons.chevron_right_rounded,
              size: 34,
              tooltip: 'Next month',
              foreground: canGoForward ? null : c.textTertiary,
              onPressed: canGoForward
                  ? () => setState(() {
                      _month = Day(
                        firstOfMonth.year,
                        firstOfMonth.month + 1,
                        1,
                      );
                    })
                  : null,
            ),
          ],
        ),
        const SizedBox(height: Gap.lg),
        Row(
          children: [
            for (final label in const [
              'MON',
              'TUE',
              'WED',
              'THU',
              'FRI',
              'SAT',
              'SUN',
            ])
              Expanded(
                child: Center(
                  child: Text(
                    label,
                    style: AppTypography.overline.copyWith(
                      color: c.textTertiary,
                      fontSize: 10,
                      letterSpacing: 0.6,
                    ),
                  ),
                ),
              ),
          ],
        ),
        const SizedBox(height: Gap.sm),
        for (var row = 0; row < rows; row++)
          Padding(
            padding: const EdgeInsets.only(bottom: Gap.xs),
            child: Row(
              children: [
                for (var col = 0; col < 7; col++)
                  Expanded(
                    child: _buildCell(
                      context,
                      index: row * 7 + col,
                      leadingBlanks: leadingBlanks,
                      daysInMonth: daysInMonth,
                      byDay: byDay,
                      today: today,
                    ),
                  ),
              ],
            ),
          ),
        const SizedBox(height: Gap.md),
        Wrap(
          spacing: Gap.lg,
          runSpacing: Gap.sm,
          children: [
            _Legend(color: c.accent, label: 'Trained'),
            _Legend(color: c.info, label: 'Freeze'),
            _Legend(color: c.surfaceSunken, label: 'Rest', outlined: true),
          ],
        ),
      ],
    );
  }

  Widget _buildCell(
    BuildContext context, {
    required int index,
    required int leadingBlanks,
    required int daysInMonth,
    required Map<Day, ActivityPoint> byDay,
    required Day today,
  }) {
    final c = context.colors;
    final dayNumber = index - leadingBlanks + 1;

    if (dayNumber < 1 || dayNumber > daysInMonth) {
      return const SizedBox(height: 40);
    }

    final day = Day(_month.year, _month.month, dayNumber);
    final point = byDay[day];
    final trained = point?.hasWorkout ?? false;
    final frozen = (point?.isFreeze ?? false) && !trained;
    final isToday = day == today;
    final isFuture = day.isAfter(today);

    final Color fill;
    final Color fg;
    if (trained) {
      fill = c.accent;
      fg = c.accentContrast;
    } else if (frozen) {
      fill = c.infoSoft;
      fg = c.info;
    } else {
      fill = Colors.transparent;
      fg = isFuture ? c.textTertiary : c.textSecondary;
    }

    return Semantics(
      label:
          '${DateFormat.MMMd().format(day.startOfDay)}: '
          '${trained
              ? 'trained'
              : frozen
              ? 'streak freeze'
              : 'rest day'}',
      child: SizedBox(
        height: 40,
        child: Center(
          child: Material(
            color: Colors.transparent,
            shape: const CircleBorder(),
            child: InkWell(
              customBorder: const CircleBorder(),
              onTap: widget.onDayTap == null || isFuture
                  ? null
                  : () => widget.onDayTap!(day, point),
              child: Container(
                width: 34,
                height: 34,
                decoration: BoxDecoration(
                  color: fill,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: isToday
                        ? c.accent
                        : (trained || frozen)
                        ? Colors.transparent
                        : c.border,
                    width: isToday ? 1.6 : 1,
                  ),
                ),
                child: Center(
                  child: Text(
                    '$dayNumber',
                    style: AppTypography.caption.copyWith(
                      color: fg,
                      fontWeight: trained || isToday
                          ? FontWeight.w700
                          : FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _Legend extends StatelessWidget {
  const _Legend({
    required this.color,
    required this.label,
    this.outlined = false,
  });

  final Color color;
  final String label;
  final bool outlined;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
            border: outlined ? Border.all(color: c.border) : null,
          ),
        ),
        const SizedBox(width: Gap.sm),
        Text(
          label,
          style: AppTypography.caption.copyWith(color: c.textSecondary),
        ),
      ],
    );
  }
}
