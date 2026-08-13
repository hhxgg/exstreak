import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/branding.dart';
import '../../core/formatters.dart';
import '../../domain/stats/stats_engine.dart';
import '../../domain/workout/workout_models.dart';
import '../../router.dart';
import '../../state/providers.dart';
import '../../theme/app_dimens.dart';
import '../../theme/app_theme.dart';
import '../../theme/app_typography.dart';
import '../../widgets/buttons.dart';
import '../../widgets/indicators.dart';
import '../../widgets/surfaces.dart';
import '../workout/workout_launcher.dart';

/// The dashboard: today's status, the next session, and a way into everything.
class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final c = context.colors;
    final settings = ref.watch(settingsProvider);
    final streak = ref.watch(streakProvider).valueOrNull;
    final resumable = ref.watch(resumableWorkoutProvider).valueOrNull;

    return Scaffold(
      backgroundColor: c.background,
      body: SafeArea(
        child: RefreshIndicator(
          color: c.accent,
          backgroundColor: c.surface,
          onRefresh: () async => refreshAll(ref),
          child: ListView(
            padding: const EdgeInsets.fromLTRB(
              Gap.screenH,
              Gap.md,
              Gap.screenH,
              Sizes.scrollBottomInset,
            ),
            children: [
              _Header(name: settings.greetingName),
              const SizedBox(height: Gap.xl),

              if (resumable != null) ...[
                _ResumeCard(workout: resumable),
                const SizedBox(height: Gap.lg),
              ],

              const _StreakRow(),
              const SizedBox(height: Gap.lg),

              const _NextWorkoutCard(),
              const SizedBox(height: Gap.lg),

              const _QuickActions(),
              const SizedBox(height: Gap.xxl),

              const _TodayCard(),
              const SizedBox(height: Gap.xxl),

              const _GoalsPreview(),
              const SizedBox(height: Gap.xxl),

              const _RecentActivity(),

              if (streak != null && streak.current == 0) ...[
                const SizedBox(height: Gap.xxl),
                InfoBanner(
                  message:
                      'Your streak starts with a single session. '
                      'Even a short one counts.',
                  icon: Icons.tips_and_updates_outlined,
                  tone: BannerTone.info,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _Header extends ConsumerWidget {
  const _Header({required this.name});

  final String name;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final c = context.colors;
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GradientText(
                Branding.appName,
                style: AppTypography.displayS.copyWith(fontSize: 30),
              ),
              const SizedBox(height: 2),
              Text(
                '${Fmt.greeting()}, $name',
                style: AppTypography.body.copyWith(color: c.textSecondary),
              ),
            ],
          ),
        ),
        IconPill(
          icon: Icons.flag_outlined,
          tooltip: 'Goals',
          onPressed: () => context.push(Routes.goals),
        ),
        const SizedBox(width: Gap.sm),
        IconPill(
          icon: Icons.settings_outlined,
          tooltip: 'Settings',
          onPressed: () => context.push(Routes.settings),
        ),
      ],
    );
  }
}

class _ResumeCard extends ConsumerWidget {
  const _ResumeCard({required this.workout});

  final ActiveWorkout workout;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final c = context.colors;
    return AppCard(
      accented: true,
      background: c.accentSoft,
      onTap: () => context.push(Routes.activeWorkout, extra: workout.id),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: c.accent,
              borderRadius: BorderRadius.circular(Radii.xs),
            ),
            child: Icon(
              Icons.play_arrow_rounded,
              color: c.accentContrast,
              size: 26,
            ),
          ),
          const SizedBox(width: Gap.lg),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Session in progress',
                  style: AppTypography.titleS.copyWith(color: c.textPrimary),
                ),
                const SizedBox(height: 2),
                Text(
                  '${workout.completedSets} of ${workout.totalSets} sets done',
                  style: AppTypography.bodySmall.copyWith(
                    color: c.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          Icon(Icons.chevron_right_rounded, color: c.accent),
        ],
      ),
    );
  }
}

class _StreakRow extends ConsumerWidget {
  const _StreakRow();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final c = context.colors;
    final streak = ref.watch(streakProvider).valueOrNull;
    final freezes = ref.watch(freezeStatusProvider);
    final current = streak?.current ?? 0;

    return Row(
      children: [
        Expanded(
          flex: 3,
          child: AppCard(
            onTap: () => context.go(Routes.streaks),
            accented: current > 0,
            padding: const EdgeInsets.symmetric(
              horizontal: Gap.lg,
              vertical: Gap.lg,
            ),
            // Stacked rather than side-by-side so the status line gets the
            // full card width. Beside the flame it had barely 100dp and
            // "Start your streak" was truncated on a 360dp-wide phone.
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    StreakFlame(days: current, size: 30),
                    const SizedBox(width: Gap.sm),
                    Flexible(
                      child: Text(
                        current == 1 ? 'day' : 'days',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppTypography.bodySmall.copyWith(
                          color: c.textSecondary,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 2),
                Text(
                  streak == null
                      ? '—'
                      : streak.trainedToday
                      ? 'Done today'
                      : current > 0
                      ? 'Keep it alive'
                      : 'Start your streak',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTypography.caption.copyWith(
                    color: streak?.trainedToday ?? false
                        ? c.success
                        : c.textTertiary,
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: Gap.md),
        Expanded(
          flex: 2,
          child: AppCard(
            onTap: () => context.go(Routes.streaks),
            padding: const EdgeInsets.symmetric(
              horizontal: Gap.lg,
              vertical: Gap.lg,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.ac_unit_rounded,
                      size: 20,
                      color: freezes.available > 0 ? c.info : c.textTertiary,
                    ),
                    const SizedBox(width: Gap.sm),
                    Text(
                      '${freezes.available}',
                      style: AppTypography.titleL.copyWith(
                        color: c.textPrimary,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 2),
                Text(
                  freezes.available > 0
                      ? 'freezes ready'
                      : 'in ${freezes.daysUntilNext}d',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTypography.caption.copyWith(color: c.textTertiary),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _NextWorkoutCard extends ConsumerWidget {
  const _NextWorkoutCard();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final c = context.colors;
    final planAsync = ref.watch(planProgressProvider);

    return planAsync.when(
      loading: () => const _CardSkeleton(height: 220),
      error: (e, _) => AppCard(
        child: InfoBanner(
          message: 'Could not load your plan. Pull down to retry.',
          tone: BannerTone.danger,
          icon: Icons.error_outline_rounded,
        ),
      ),
      data: (plan) {
        final day = plan.template.dayFor(plan.level, plan.day);
        final unit = plan.template.trackingType.targetUnit;

        return AppCard(
          accented: true,
          padding: const EdgeInsets.all(Gap.xl),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'NEXT WORKOUT',
                          style: AppTypography.overline.copyWith(
                            color: c.accent,
                          ),
                        ),
                        const SizedBox(height: Gap.xs),
                        Text(
                          '${plan.template.name} · Level ${plan.level}',
                          style: AppTypography.titleM.copyWith(
                            color: c.textPrimary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconPill(
                    icon: Icons.swap_horiz_rounded,
                    size: 34,
                    tooltip: 'Choose a different day or plan',
                    onPressed: () => context.push(Routes.planPicker),
                  ),
                ],
              ),
              const SizedBox(height: Gap.md),
              LinearMeter(
                progress: plan.day / plan.template.daysPerLevel,
                leadingLabel:
                    'Day ${plan.day} of ${plan.template.daysPerLevel}',
                trailingLabel: '${day.total} $unit total',
                height: 6,
              ),
              const SizedBox(height: Gap.xl),
              Row(
                children: [
                  for (final target in day.targets)
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(right: Gap.sm),
                        child: _TargetBox(
                          label: plan.template.trackingType.tracksDuration
                              ? Fmt.duration(target)
                              : '$target',
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: Gap.xl),
              PrimaryButton(
                label: 'Start workout',
                icon: Icons.play_arrow_rounded,
                gradient: true,
                onPressed: () => startPlanWorkout(context, ref),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _TargetBox extends StatelessWidget {
  const _TargetBox({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Container(
      height: 56,
      decoration: BoxDecoration(
        color: c.surfaceSunken,
        borderRadius: BorderRadius.circular(Radii.sm),
        border: Border.all(color: c.border),
      ),
      child: Center(
        child: FittedBox(
          fit: BoxFit.scaleDown,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: Gap.xs),
            child: Text(
              label,
              style: AppTypography.titleM.copyWith(
                color: c.textPrimary,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _QuickActions extends StatelessWidget {
  const _QuickActions();

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Row(
      children: [
        Expanded(
          child: AppCard(
            onTap: () => context.push(Routes.freePractice),
            padding: const EdgeInsets.all(Gap.lg),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 34,
                  height: 34,
                  decoration: BoxDecoration(
                    color: c.accent,
                    borderRadius: BorderRadius.circular(Radii.xs),
                  ),
                  child: Icon(
                    Icons.bolt_rounded,
                    size: 19,
                    color: c.accentContrast,
                  ),
                ),
                const SizedBox(height: Gap.md),
                Text(
                  'Free practice',
                  style: AppTypography.titleS.copyWith(color: c.textPrimary),
                ),
                Text(
                  'No targets. Go all out.',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTypography.caption.copyWith(color: c.textSecondary),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: Gap.md),
        Expanded(
          child: AppCard(
            onTap: () => context.push(Routes.builder),
            padding: const EdgeInsets.all(Gap.lg),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 34,
                  height: 34,
                  decoration: BoxDecoration(
                    color: c.surfaceSunken,
                    borderRadius: BorderRadius.circular(Radii.xs),
                    border: Border.all(color: c.border),
                  ),
                  child: Icon(
                    Icons.tune_rounded,
                    size: 19,
                    color: c.textSecondary,
                  ),
                ),
                const SizedBox(height: Gap.md),
                Text(
                  'Build a session',
                  style: AppTypography.titleS.copyWith(color: c.textPrimary),
                ),
                Text(
                  'Pick your own exercises.',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTypography.caption.copyWith(color: c.textSecondary),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _TodayCard extends ConsumerWidget {
  const _TodayCard();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final c = context.colors;
    final activity = ref.watch(activityProvider).valueOrNull ?? const [];
    final today = ref.watch(todayProvider);
    final settings = ref.watch(settingsProvider);
    final streak = ref.watch(streakProvider).valueOrNull;

    ActivityPoint? point;
    for (final p in activity) {
      if (p.day == today) point = p;
    }

    final weekDone = streak?.activeDaysThisWeek ?? 0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionHeader(title: 'Today'),
        AppCard(
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: StatTile(
                      value: Fmt.count(point?.reps ?? 0),
                      label: 'Reps today',
                      icon: Icons.repeat_rounded,
                      iconColor: c.accent,
                      compact: true,
                    ),
                  ),
                  Container(width: 1, height: 44, color: c.border),
                  const SizedBox(width: Gap.lg),
                  Expanded(
                    child: StatTile(
                      value: Fmt.durationLong(point?.durationSeconds ?? 0),
                      label: 'Time held',
                      icon: Icons.timer_outlined,
                      iconColor: c.info,
                      compact: true,
                    ),
                  ),
                  Container(width: 1, height: 44, color: c.border),
                  const SizedBox(width: Gap.lg),
                  Expanded(
                    child: StatTile(
                      value: '${point?.workoutCount ?? 0}',
                      label: 'Sessions',
                      icon: Icons.check_circle_outline_rounded,
                      iconColor: c.success,
                      compact: true,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: Gap.xl),
              LinearMeter(
                progress: weekDone / settings.weeklyTarget,
                leadingLabel: 'This week',
                trailingLabel: '$weekDone / ${settings.weeklyTarget} days',
                color: weekDone >= settings.weeklyTarget ? c.success : c.accent,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _GoalsPreview extends ConsumerWidget {
  const _GoalsPreview();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final c = context.colors;
    final goals = ref.watch(goalsProvider).valueOrNull ?? const [];
    final open = goals.where((g) => !g.goal.isCompleted).take(2).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionHeader(
          title: 'Goals',
          action: goals.isEmpty ? 'Add' : 'See all',
          onActionTap: () => context.push(Routes.goals),
        ),
        if (open.isEmpty)
          AppCard(
            onTap: () => context.push(Routes.newGoal),
            child: Row(
              children: [
                Icon(Icons.flag_outlined, color: c.textTertiary, size: 20),
                const SizedBox(width: Gap.md),
                Expanded(
                  child: Text(
                    goals.isEmpty
                        ? 'Set a goal to aim at — 25 push-ups, a 30-day streak…'
                        : 'All goals complete. Time for a new one.',
                    style: AppTypography.bodySmall.copyWith(
                      color: c.textSecondary,
                    ),
                  ),
                ),
                Icon(Icons.add_rounded, color: c.accent, size: 20),
              ],
            ),
          )
        else
          for (final g in open)
            Padding(
              padding: const EdgeInsets.only(bottom: Gap.md),
              child: AppCard(
                onTap: () => context.push(Routes.editGoal(g.goal.id)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(g.goal.type.icon, size: 18, color: c.accent),
                        const SizedBox(width: Gap.sm),
                        Expanded(
                          child: Text(
                            g.goal.title,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: AppTypography.titleS.copyWith(
                              color: c.textPrimary,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: Gap.md),
                    LinearMeter(
                      progress: g.progress,
                      trailingLabel:
                          '${Fmt.count(g.goal.achievedValue)} / '
                          '${Fmt.count(g.goal.targetValue)} ${g.unit}',
                    ),
                  ],
                ),
              ),
            ),
      ],
    );
  }
}

class _RecentActivity extends ConsumerWidget {
  const _RecentActivity();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final c = context.colors;
    final history = ref.watch(historyProvider).valueOrNull ?? const [];
    final recent = history.take(3).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionHeader(
          title: 'Recent activity',
          action: history.isEmpty ? null : 'History',
          onActionTap: () => context.go(Routes.progress),
        ),
        if (recent.isEmpty)
          AppCard(
            child: EmptyState(
              icon: Icons.history_rounded,
              title: 'No sessions yet',
              message: 'Your finished workouts will appear here.',
              compact: true,
            ),
          )
        else
          for (final item in recent)
            Padding(
              padding: const EdgeInsets.only(bottom: Gap.md),
              child: AppCard(
                onTap: () =>
                    context.push(Routes.workoutDetail(item.workout.id)),
                padding: const EdgeInsets.all(Gap.lg),
                child: Row(
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: c.successSoft,
                        borderRadius: BorderRadius.circular(Radii.xs),
                      ),
                      child: Icon(
                        Icons.check_rounded,
                        size: 20,
                        color: c.success,
                      ),
                    ),
                    const SizedBox(width: Gap.md),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item.workout.title.isEmpty
                                ? item.workout.source.label
                                : item.workout.title,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: AppTypography.titleS.copyWith(
                              color: c.textPrimary,
                            ),
                          ),
                          Text(
                            '${Fmt.relativeDay(item.day)} · '
                            '${item.setCount} sets',
                            style: AppTypography.caption.copyWith(
                              color: c.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (item.workout.totalReps > 0)
                      Text(
                        '${Fmt.count(item.workout.totalReps)} reps',
                        style: AppTypography.bodySmall.copyWith(
                          color: c.textSecondary,
                        ),
                      )
                    else if (item.workout.totalDurationSeconds > 0)
                      Text(
                        Fmt.durationLong(item.workout.totalDurationSeconds),
                        style: AppTypography.bodySmall.copyWith(
                          color: c.textSecondary,
                        ),
                      ),
                  ],
                ),
              ),
            ),
      ],
    );
  }
}

class _CardSkeleton extends StatelessWidget {
  const _CardSkeleton({required this.height});

  final double height;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Container(
      height: height,
      decoration: BoxDecoration(
        color: c.surface,
        borderRadius: Radii.cardRadius,
        border: Border.all(color: c.border),
      ),
      child: Center(
        child: SizedBox(
          width: 24,
          height: 24,
          child: CircularProgressIndicator(strokeWidth: 2.4, color: c.accent),
        ),
      ),
    );
  }
}
