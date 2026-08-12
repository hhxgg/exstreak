import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/formatters.dart';
import '../../data/repositories/workout_repository.dart';
import '../../domain/exercise_icons.dart';
import '../../domain/stats/stats_engine.dart';
import '../../router.dart';
import '../../state/providers.dart';
import '../../theme/app_dimens.dart';
import '../../theme/app_theme.dart';
import '../../theme/app_typography.dart';
import '../../widgets/buttons.dart';
import '../../widgets/charts.dart';
import '../../widgets/indicators.dart';
import '../../widgets/surfaces.dart';

/// Statistics, personal records and session history.
class ProgressScreen extends ConsumerStatefulWidget {
  const ProgressScreen({super.key});

  @override
  ConsumerState<ProgressScreen> createState() => _ProgressScreenState();
}

class _ProgressScreenState extends ConsumerState<ProgressScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tabs = TabController(length: 3, vsync: this);

  @override
  void dispose() {
    _tabs.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final c = context.colors;

    return Scaffold(
      backgroundColor: c.background,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(
                Gap.screenH,
                Gap.md,
                Gap.screenH,
                Gap.md,
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      'Progress',
                      style: AppTypography.displayS.copyWith(
                        fontSize: 28,
                        color: c.textPrimary,
                      ),
                    ),
                  ),
                  IconPill(
                    icon: Icons.flag_outlined,
                    tooltip: 'Goals',
                    onPressed: () => context.push(Routes.goals),
                  ),
                ],
              ),
            ),
            TabBar(
              controller: _tabs,
              indicatorColor: c.accent,
              indicatorSize: TabBarIndicatorSize.label,
              labelColor: c.textPrimary,
              unselectedLabelColor: c.textTertiary,
              labelStyle: AppTypography.titleS,
              unselectedLabelStyle: AppTypography.titleS,
              dividerColor: c.border,
              tabs: const [
                Tab(text: 'Overview'),
                Tab(text: 'Exercises'),
                Tab(text: 'History'),
              ],
            ),
            Expanded(
              child: TabBarView(
                controller: _tabs,
                children: const [
                  _OverviewTab(),
                  _ExercisesTab(),
                  _HistoryTab(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------- overview

class _OverviewTab extends ConsumerWidget {
  const _OverviewTab();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final c = context.colors;
    final window = ref.watch(statsWindowProvider);
    final totals = ref.watch(lifetimeTotalsProvider).valueOrNull;
    final windowed = ref.watch(windowedActivityProvider).valueOrNull;
    final split = ref.watch(muscleSplitProvider).valueOrNull;
    final streak = ref.watch(streakProvider).valueOrNull;

    if (totals != null && totals.workoutCount == 0) {
      return EmptyState(
        icon: Icons.insights_rounded,
        title: 'No data yet',
        message:
            'Finish your first workout and your numbers will start filling in '
            'here.',
        actionLabel: 'Go to home',
        onAction: () => context.go(Routes.home),
      );
    }

    final dense = windowed ?? const <ActivityPoint>[];
    final momentum = StatsEngine.momentum(dense);

    return ListView(
      padding: const EdgeInsets.fromLTRB(
        Gap.screenH,
        Gap.lg,
        Gap.screenH,
        Sizes.scrollBottomInset,
      ),
      children: [
        AppCard(
          padding: const EdgeInsets.symmetric(
            horizontal: Gap.xl,
            vertical: Gap.xxl,
          ),
          child: Column(
            children: [
              Text(
                'TOTAL · ALL TIME',
                style: AppTypography.overline.copyWith(color: c.textTertiary),
              ),
              const SizedBox(height: Gap.md),
              GradientText(
                Fmt.count(totals?.totalReps ?? 0),
                style: AppTypography.displayL,
              ),
              const SizedBox(height: Gap.xs),
              Text(
                'reps logged',
                style: AppTypography.body.copyWith(color: c.textSecondary),
              ),
              if ((totals?.totalDurationSeconds ?? 0) > 0) ...[
                const SizedBox(height: Gap.sm),
                Text(
                  '+ ${Fmt.durationLong(totals!.totalDurationSeconds)} '
                  'under tension',
                  style: AppTypography.bodySmall.copyWith(
                    color: c.textTertiary,
                  ),
                ),
              ],
            ],
          ),
        ),
        const SizedBox(height: Gap.md),

        Row(
          children: [
            Expanded(
              child: AppCard(
                child: StatTile(
                  value: '${totals?.workoutCount ?? 0}',
                  label: 'Workouts',
                  icon: Icons.checklist_rounded,
                  iconColor: c.accent,
                  compact: true,
                ),
              ),
            ),
            const SizedBox(width: Gap.md),
            Expanded(
              child: AppCard(
                child: StatTile(
                  value: '${totals?.activeDays ?? 0}',
                  label: 'Active days',
                  icon: Icons.calendar_today_rounded,
                  iconColor: c.info,
                  compact: true,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: Gap.md),
        Row(
          children: [
            Expanded(
              child: AppCard(
                child: StatTile(
                  value: Fmt.count(totals?.averageRepsPerActiveDay ?? 0),
                  label: 'Avg reps / active day',
                  icon: Icons.trending_up_rounded,
                  iconColor: c.success,
                  compact: true,
                ),
              ),
            ),
            const SizedBox(width: Gap.md),
            Expanded(
              child: AppCard(
                child: StatTile(
                  value: '${streak?.longest ?? 0}',
                  label: 'Longest streak',
                  icon: Icons.local_fire_department_rounded,
                  iconColor: c.streakFlame,
                  compact: true,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: Gap.xxl),

        SectionHeader(
          title: 'Trend',
          padding: const EdgeInsets.only(bottom: Gap.md),
        ),
        SegmentedToggle<StatsWindow>(
          options: StatsWindow.values,
          selected: window,
          dense: true,
          labelOf: (w) => w.label,
          onChanged: (w) => ref.read(statsWindowProvider.notifier).state = w,
        ),
        const SizedBox(height: Gap.lg),
        AppCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      'Reps per ${window.bucketDays == 1 ? 'day' : '${window.bucketDays} days'}',
                      style: AppTypography.titleS.copyWith(
                        color: c.textPrimary,
                      ),
                    ),
                  ),
                  if (momentum != null)
                    TagChip(
                      label: Fmt.signedPercent(momentum),
                      icon: momentum >= 0
                          ? Icons.arrow_upward_rounded
                          : Icons.arrow_downward_rounded,
                      color: momentum >= 0 ? c.success : c.danger,
                      dense: true,
                    ),
                ],
              ),
              const SizedBox(height: Gap.lg),
              TrendBarChart(
                points: StatsEngine.trend(
                  dense,
                  window,
                  (p) => p.reps.toDouble(),
                ),
                valueFormatter: Fmt.compact,
              ),
            ],
          ),
        ),
        const SizedBox(height: Gap.xxl),

        const SectionHeader(title: 'Muscle split'),
        AppCard(
          child: BreakdownBars(
            entries: [
              for (final entry
                  in (split?.entries.toList()
                        ?..sort((a, b) => b.value.compareTo(a.value))) ??
                      [])
                (
                  label: entry.key.label,
                  value: entry.value,
                  icon: entry.key.icon,
                ),
            ],
            emptyMessage: 'Train a few sessions to see your balance.',
          ),
        ),
        const SizedBox(height: Gap.xxl),

        const _WeekdaySection(),
        const SizedBox(height: Gap.xxl),

        const _RecordsSection(),
      ],
    );
  }
}

/// Which days of the week the user actually trains on.
///
/// Useful precisely because it is often not the days people think.
class _WeekdaySection extends ConsumerWidget {
  const _WeekdaySection();

  static const List<String> _labels = [
    'Mon',
    'Tue',
    'Wed',
    'Thu',
    'Fri',
    'Sat',
    'Sun',
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final c = context.colors;
    final dist = ref.watch(weekdayDistributionProvider).valueOrNull;
    if (dist == null) return const SizedBox.shrink();

    final max = dist.values.fold<int>(0, (a, b) => b > a ? b : a);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionHeader(title: 'Training days'),
        AppCard(
          child: max == 0
              ? EmptyState(
                  icon: Icons.calendar_view_week_rounded,
                  title: 'No pattern yet',
                  message: 'A few sessions and your rhythm shows up here.',
                  compact: true,
                )
              : Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    for (var day = 1; day <= 7; day++)
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: Gap.xs,
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                '${dist[day] ?? 0}',
                                style: AppTypography.caption.copyWith(
                                  color: c.textSecondary,
                                  fontFeatures: AppTypography.tabular,
                                ),
                              ),
                              const SizedBox(height: Gap.xs),
                              TweenAnimationBuilder<double>(
                                tween: Tween(
                                  begin: 0,
                                  end: (dist[day] ?? 0) / max,
                                ),
                                duration: Motion.normal,
                                curve: Motion.emphasized,
                                builder: (context, v, _) => Container(
                                  height: 8 + v * 62,
                                  decoration: BoxDecoration(
                                    gradient: v > 0
                                        ? c.brandGradientVertical
                                        : null,
                                    color: v > 0 ? null : c.surfaceSunken,
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                ),
                              ),
                              const SizedBox(height: Gap.sm),
                              Text(
                                _labels[day - 1],
                                style: AppTypography.caption.copyWith(
                                  color: c.textTertiary,
                                  fontSize: 10.5,
                                ),
                              ),
                            ],
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

class _RecordsSection extends ConsumerWidget {
  const _RecordsSection();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final c = context.colors;
    final records = ref.watch(personalRecordsProvider).valueOrNull ?? const [];

    if (records.isEmpty) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionHeader(title: 'Personal records'),
          AppCard(
            child: EmptyState(
              icon: Icons.emoji_events_outlined,
              title: 'No records yet',
              message: 'Complete a set and your first record appears here.',
              compact: true,
            ),
          ),
        ],
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionHeader(title: 'Personal records'),
        for (final (exercise, record) in records.take(8))
          Padding(
            padding: const EdgeInsets.only(bottom: Gap.sm),
            child: AppCard(
              padding: const EdgeInsets.symmetric(
                horizontal: Gap.lg,
                vertical: Gap.md,
              ),
              onTap: () => context.push(Routes.exerciseProgress(exercise.id)),
              child: Row(
                children: [
                  Icon(
                    ExerciseIcons.resolve(exercise.iconName),
                    size: 20,
                    color: c.warning,
                  ),
                  const SizedBox(width: Gap.md),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          exercise.name,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppTypography.titleS.copyWith(
                            color: c.textPrimary,
                          ),
                        ),
                        Text(
                          _metricLabel(record.metric),
                          style: AppTypography.caption.copyWith(
                            color: c.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Text(
                    _formatRecord(record.metric, record.value),
                    style: AppTypography.titleM.copyWith(
                      color: c.warning,
                      fontFeatures: AppTypography.tabular,
                    ),
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }

  static String _metricLabel(String metric) => switch (metric) {
    PrMetric.bestSetReps => 'Best single set',
    PrMetric.bestSetDuration => 'Longest hold',
    PrMetric.bestSetWeight => 'Heaviest set',
    _ => 'Record',
  };

  static String _formatRecord(String metric, double value) => switch (metric) {
    PrMetric.bestSetDuration => Fmt.duration(value.round()),
    PrMetric.bestSetWeight => '${value.toStringAsFixed(1)} kg',
    _ => Fmt.count(value),
  };
}

// --------------------------------------------------------------- exercises

class _ExercisesTab extends ConsumerWidget {
  const _ExercisesTab();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final c = context.colors;
    final exercises =
        ref.watch(exercisesWithHistoryProvider).valueOrNull ?? const [];

    if (exercises.isEmpty) {
      return EmptyState(
        icon: Icons.show_chart_rounded,
        title: 'No exercise history',
        message:
            'Once you have logged an exercise a few times, its progression '
            'chart shows up here.',
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(
        Gap.screenH,
        Gap.lg,
        Gap.screenH,
        Sizes.scrollBottomInset,
      ),
      itemCount: exercises.length,
      separatorBuilder: (_, _) => const SizedBox(height: Gap.sm),
      itemBuilder: (context, i) {
        final exercise = exercises[i];
        return AppCard(
          padding: const EdgeInsets.symmetric(
            horizontal: Gap.lg,
            vertical: Gap.md,
          ),
          onTap: () => context.push(Routes.exerciseProgress(exercise.id)),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: c.accentSoft,
                  borderRadius: BorderRadius.circular(Radii.xs),
                ),
                child: Icon(
                  ExerciseIcons.resolve(exercise.iconName),
                  size: 20,
                  color: c.accent,
                ),
              ),
              const SizedBox(width: Gap.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      exercise.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTypography.titleS.copyWith(
                        color: c.textPrimary,
                      ),
                    ),
                    Text(
                      exercise.muscleGroup.label,
                      style: AppTypography.caption.copyWith(
                        color: c.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.chevron_right_rounded,
                size: 20,
                color: c.textTertiary,
              ),
            ],
          ),
        );
      },
    );
  }
}

// ----------------------------------------------------------------- history

class _HistoryTab extends ConsumerWidget {
  const _HistoryTab();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final c = context.colors;
    final historyAsync = ref.watch(historyProvider);

    return historyAsync.when(
      loading: () => Center(child: CircularProgressIndicator(color: c.accent)),
      error: (e, _) => EmptyState(
        icon: Icons.error_outline_rounded,
        title: 'Could not load history',
        message: '$e',
      ),
      data: (history) {
        if (history.isEmpty) {
          return EmptyState(
            icon: Icons.history_rounded,
            title: 'No sessions yet',
            message: 'Finished workouts are listed here with all their sets.',
            actionLabel: 'Start a workout',
            onAction: () => context.go(Routes.home),
          );
        }

        return ListView.separated(
          padding: const EdgeInsets.fromLTRB(
            Gap.screenH,
            Gap.lg,
            Gap.screenH,
            Sizes.scrollBottomInset,
          ),
          itemCount: history.length,
          separatorBuilder: (_, _) => const SizedBox(height: Gap.sm),
          itemBuilder: (context, i) {
            final item = history[i];
            final showDateHeader = i == 0 || history[i - 1].day != item.day;

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (showDateHeader)
                  Padding(
                    padding: EdgeInsets.only(
                      top: i == 0 ? 0 : Gap.lg,
                      bottom: Gap.sm,
                    ),
                    child: Text(
                      Fmt.relativeDay(item.day),
                      style: AppTypography.overline.copyWith(
                        color: c.textTertiary,
                      ),
                    ),
                  ),
                AppCard(
                  padding: const EdgeInsets.all(Gap.lg),
                  onTap: () =>
                      context.push(Routes.workoutDetail(item.workout.id)),
                  child: Row(
                    children: [
                      Container(
                        width: 42,
                        height: 42,
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
                            const SizedBox(height: 2),
                            Text(
                              '${Fmt.time(item.workout.startedAt)} · '
                              '${item.setCount} sets'
                              '${item.workout.durationSeconds > 0 ? ' · ${Fmt.durationLong(item.workout.durationSeconds)}' : ''}',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: AppTypography.caption.copyWith(
                                color: c.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          if (item.workout.totalReps > 0)
                            Text(
                              Fmt.count(item.workout.totalReps),
                              style: AppTypography.titleM.copyWith(
                                color: c.warning,
                                fontFeatures: AppTypography.tabular,
                              ),
                            )
                          else if (item.workout.totalDurationSeconds > 0)
                            Text(
                              Fmt.duration(item.workout.totalDurationSeconds),
                              style: AppTypography.titleM.copyWith(
                                color: c.warning,
                                fontFeatures: AppTypography.tabular,
                              ),
                            ),
                          Text(
                            item.workout.totalReps > 0 ? 'reps' : 'held',
                            style: AppTypography.caption.copyWith(
                              color: c.textTertiary,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }
}
