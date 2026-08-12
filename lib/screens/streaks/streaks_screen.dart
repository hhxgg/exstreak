import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/formatters.dart';
import '../../domain/streak/streak_engine.dart';
import '../../state/providers.dart';
import '../../theme/app_dimens.dart';
import '../../theme/app_theme.dart';
import '../../theme/app_typography.dart';
import '../../widgets/indicators.dart';
import '../../widgets/streak_calendar.dart';
import '../../widgets/surfaces.dart';

/// The streak hub: current run, record, freezes, calendar and consistency.
class StreaksScreen extends ConsumerWidget {
  const StreaksScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final c = context.colors;
    final streak = ref.watch(streakProvider).valueOrNull;
    final activity = ref.watch(activityProvider).valueOrNull ?? const [];
    final freezes = ref.watch(freezeStatusProvider);

    return Scaffold(
      backgroundColor: c.background,
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(
            Gap.screenH,
            Gap.md,
            Gap.screenH,
            Sizes.scrollBottomInset,
          ),
          children: [
            Text(
              'Streaks',
              style: AppTypography.displayS.copyWith(
                fontSize: 28,
                color: c.textPrimary,
              ),
            ),
            const SizedBox(height: Gap.xl),

            _HeroCard(streak: streak),
            const SizedBox(height: Gap.lg),

            _FreezeCard(
              available: freezes.available,
              daysUntilNext: freezes.daysUntilNext,
              hasStreak: (streak?.current ?? 0) > 0,
            ),
            const SizedBox(height: Gap.xxl),

            const SectionHeader(title: 'Consistency'),
            AppCard(
              child: Column(
                children: [
                  LinearMeter(
                    progress: streak?.weeklyConsistency ?? 0,
                    leadingLabel: 'Last 7 days',
                    trailingLabel:
                        '${streak?.activeDaysThisWeek ?? 0} / 7 days',
                  ),
                  const SizedBox(height: Gap.lg),
                  LinearMeter(
                    progress: streak?.monthlyConsistency ?? 0,
                    leadingLabel: 'This month',
                    trailingLabel:
                        '${streak?.activeDaysThisMonth ?? 0} / '
                        '${streak?.daysInMonthSoFar ?? 0} days',
                    color: c.info,
                  ),
                  if (streak != null && streak.missedDaysLast30 > 0) ...[
                    const SizedBox(height: Gap.lg),
                    Row(
                      children: [
                        Icon(
                          Icons.event_busy_outlined,
                          size: 16,
                          color: c.textTertiary,
                        ),
                        const SizedBox(width: Gap.sm),
                        Text(
                          '${streak.missedDaysLast30} rest '
                          '${streak.missedDaysLast30 == 1 ? 'day' : 'days'} '
                          'in the last 30',
                          style: AppTypography.bodySmall.copyWith(
                            color: c.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(height: Gap.xxl),

            const SectionHeader(title: 'Calendar'),
            AppCard(
              child: StreakCalendar(
                activity: activity,
                onDayTap: (day, point) {
                  final message = point == null || !point.hasWorkout
                      ? point?.isFreeze ?? false
                            ? 'Streak freeze used on ${Fmt.relativeDay(day)}'
                            : 'No session on ${Fmt.relativeDay(day)}'
                      : '${Fmt.relativeDay(day)}: '
                            '${point.workoutCount} '
                            '${point.workoutCount == 1 ? 'session' : 'sessions'}'
                            '${point.reps > 0 ? ' · ${Fmt.count(point.reps)} reps' : ''}'
                            '${point.durationSeconds > 0 ? ' · ${Fmt.durationLong(point.durationSeconds)}' : ''}';

                  ScaffoldMessenger.of(context)
                    ..hideCurrentSnackBar()
                    ..showSnackBar(SnackBar(content: Text(message)));
                },
              ),
            ),
            const SizedBox(height: Gap.xxl),

            const SectionHeader(title: 'How streaks work'),
            AppCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  _RuleRow(
                    icon: Icons.check_circle_outline_rounded,
                    text:
                        'Any completed session counts. One set is enough to '
                        'keep the day.',
                  ),
                  _RuleRow(
                    icon: Icons.schedule_rounded,
                    text:
                        'A day is a calendar day on your device. Finish before '
                        'midnight and it counts for that day.',
                  ),
                  _RuleRow(
                    icon: Icons.ac_unit_rounded,
                    text:
                        'Earn one freeze every 14 days, up to two. A freeze is '
                        'spent automatically to bridge a missed day.',
                  ),
                  _RuleRow(
                    icon: Icons.wifi_off_rounded,
                    text:
                        'Everything works offline. Nothing is lost if you train '
                        'without a connection.',
                    isLast: true,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _HeroCard extends StatelessWidget {
  const _HeroCard({required this.streak});

  final StreakSummary? streak;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final current = streak?.current ?? 0;
    final longest = streak?.longest ?? 0;
    final trainedToday = streak?.trainedToday ?? false;

    return AppCard(
      accented: current > 0,
      padding: const EdgeInsets.symmetric(
        horizontal: Gap.xl,
        vertical: Gap.xxl,
      ),
      child: Column(
        children: [
          StreakFlame(days: current, size: 64),
          const SizedBox(height: Gap.sm),
          Text(
            current == 1 ? 'DAY STREAK' : 'DAYS STREAK',
            style: AppTypography.overline.copyWith(color: c.textTertiary),
          ),
          const SizedBox(height: Gap.lg),
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: Gap.lg,
              vertical: Gap.sm,
            ),
            decoration: BoxDecoration(
              color: trainedToday ? c.successSoft : c.surfaceSunken,
              borderRadius: Radii.pillRadius,
              border: Border.all(color: trainedToday ? c.success : c.border),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  trainedToday
                      ? Icons.check_circle_rounded
                      : Icons.circle_outlined,
                  size: 14,
                  color: trainedToday ? c.success : c.accent,
                ),
                const SizedBox(width: Gap.sm),
                Text(
                  trainedToday
                      ? 'Today is secured'
                      : current > 0
                      ? 'Train today to keep it'
                      : 'Start your streak today',
                  style: AppTypography.caption.copyWith(
                    color: trainedToday ? c.success : c.textPrimary,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: Gap.lg),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('👑', style: const TextStyle(fontSize: 18)),
              const SizedBox(width: Gap.sm),
              Text(
                'Record $longest ${longest == 1 ? 'day' : 'days'}',
                style: AppTypography.bodyStrong.copyWith(
                  color: c.textSecondary,
                ),
              ),
            ],
          ),
          if (streak != null && streak!.isRecord && current > 1) ...[
            const SizedBox(height: Gap.sm),
            Text(
              'You are at your all-time best right now.',
              style: AppTypography.caption.copyWith(color: c.warning),
            ),
          ],
        ],
      ),
    );
  }
}

class _FreezeCard extends StatelessWidget {
  const _FreezeCard({
    required this.available,
    required this.daysUntilNext,
    required this.hasStreak,
  });

  final int available;
  final int daysUntilNext;
  final bool hasStreak;

  static const int _maxFreezes = 2;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return AppCard(
      borderColor: c.info.withValues(alpha: 0.4),
      child: Row(
        children: [
          Icon(
            Icons.ac_unit_rounded,
            size: 32,
            color: available > 0 ? c.info : c.textTertiary,
          ),
          const SizedBox(width: Gap.lg),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Streak protection',
                  style: AppTypography.titleS.copyWith(color: c.textPrimary),
                ),
                const SizedBox(height: Gap.sm),
                Row(
                  children: [
                    for (var i = 0; i < _maxFreezes; i++)
                      Container(
                        margin: const EdgeInsets.only(right: Gap.xs),
                        width: 22,
                        height: 10,
                        decoration: BoxDecoration(
                          color: i < available ? c.info : c.surfaceSunken,
                          borderRadius: Radii.pillRadius,
                          border: Border.all(
                            color: i < available ? c.info : c.border,
                          ),
                        ),
                      ),
                    const SizedBox(width: Gap.sm),
                    Flexible(
                      child: Text(
                        available > 0
                            ? '$available available'
                            : hasStreak
                            ? 'Next in $daysUntilNext ${daysUntilNext == 1 ? 'day' : 'days'}'
                            : 'Build a streak to earn one',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppTypography.caption.copyWith(
                          color: available > 0 ? c.info : c.textTertiary,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _RuleRow extends StatelessWidget {
  const _RuleRow({required this.icon, required this.text, this.isLast = false});

  final IconData icon;
  final String text;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Padding(
      padding: EdgeInsets.only(bottom: isLast ? 0 : Gap.lg),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 18, color: c.accent),
          const SizedBox(width: Gap.md),
          Expanded(
            child: Text(
              text,
              style: AppTypography.bodySmall.copyWith(color: c.textSecondary),
            ),
          ),
        ],
      ),
    );
  }
}
