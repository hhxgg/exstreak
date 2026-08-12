import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/formatters.dart';
import '../../domain/stats/stats_engine.dart';
import '../../router.dart';
import '../../state/providers.dart';
import '../../theme/app_dimens.dart';
import '../../theme/app_theme.dart';
import '../../theme/app_typography.dart';
import '../../widgets/charts.dart';
import '../../widgets/indicators.dart';
import '../../widgets/surfaces.dart';

/// Deep-dive progression for a single exercise.
class ExerciseProgressScreen extends ConsumerWidget {
  const ExerciseProgressScreen({super.key, required this.exerciseId});

  final int exerciseId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final c = context.colors;
    final progressAsync = ref.watch(exerciseProgressProvider(exerciseId));
    final units = ref.watch(unitSystemProvider);

    return progressAsync.when(
      loading: () => Scaffold(
        backgroundColor: c.background,
        appBar: AppBar(),
        body: Center(child: CircularProgressIndicator(color: c.accent)),
      ),
      error: (e, _) => AppScreen(
        title: 'Progress',
        child: EmptyState(
          icon: Icons.error_outline_rounded,
          title: 'Could not load progress',
          message: '$e',
        ),
      ),
      data: (progress) {
        if (progress == null) {
          return AppScreen(
            title: 'Progress',
            child: EmptyState(
              icon: Icons.help_outline_rounded,
              title: 'Exercise not found',
              message: 'It may have been removed from your library.',
              actionLabel: 'Back to progress',
              onAction: () => context.go(Routes.progress),
            ),
          );
        }

        final exercise = progress.exercise;
        final isDuration = exercise.trackingType.tracksDuration;
        final isWeighted = exercise.trackingType.tracksWeight;

        if (!progress.hasHistory) {
          return AppScreen(
            title: exercise.name,
            child: EmptyState(
              icon: Icons.show_chart_rounded,
              title: 'No history yet',
              message:
                  'Log a few sets of ${exercise.name} and your progression '
                  'appears here.',
              actionLabel: 'View exercise',
              onAction: () => context.push(Routes.exercise(exercise.id)),
            ),
          );
        }

        return AppScreen(
          title: exercise.name,
          padded: false,
          child: ListView(
            padding: const EdgeInsets.fromLTRB(
              Gap.screenH,
              Gap.lg,
              Gap.screenH,
              Gap.giant,
            ),
            children: [
              AppCard(
                padding: const EdgeInsets.symmetric(
                  horizontal: Gap.xl,
                  vertical: Gap.xl,
                ),
                child: Column(
                  children: [
                    Text(
                      'BEST SINGLE SET',
                      style: AppTypography.overline.copyWith(
                        color: c.textTertiary,
                      ),
                    ),
                    const SizedBox(height: Gap.md),
                    GradientText(
                      isDuration
                          ? Fmt.duration(progress.recordDuration.round())
                          : Fmt.count(progress.recordReps),
                      style: AppTypography.displayM,
                    ),
                    if (isWeighted && progress.recordWeight > 0) ...[
                      const SizedBox(height: Gap.sm),
                      Text(
                        'Heaviest set '
                        '${Fmt.weight(progress.recordWeight, units)}',
                        style: AppTypography.bodySmall.copyWith(
                          color: c.textSecondary,
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
                        value: isDuration
                            ? Fmt.durationLong(
                                progress.totals.totalDurationSeconds,
                              )
                            : Fmt.count(progress.totals.totalReps),
                        label: 'All time',
                        icon: Icons.stacked_bar_chart_rounded,
                        iconColor: c.accent,
                        compact: true,
                      ),
                    ),
                  ),
                  const SizedBox(width: Gap.md),
                  Expanded(
                    child: AppCard(
                      child: StatTile(
                        value: '${progress.totals.activeDays}',
                        label: 'Days trained',
                        icon: Icons.calendar_today_rounded,
                        iconColor: c.info,
                        compact: true,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: Gap.xxl),

              const SectionHeader(title: 'Best set over time'),
              AppCard(
                child: ProgressLineChart(
                  points: progress.bestSetSeries,
                  valueFormatter: isDuration
                      ? (v) => Fmt.duration(v.round())
                      : Fmt.compact,
                  emptyMessage:
                      'Two or more sessions are needed to draw a trend.',
                ),
              ),
              const SizedBox(height: Gap.xxl),

              const SectionHeader(title: 'Volume per day'),
              AppCard(
                child: TrendBarChart(
                  points: [
                    for (final p in progress.dailyActivity)
                      SeriesPoint(
                        day: p.day,
                        value: isDuration
                            ? p.durationSeconds.toDouble()
                            : p.reps.toDouble(),
                      ),
                  ],
                  valueFormatter: isDuration
                      ? (v) => Fmt.duration(v.round())
                      : Fmt.compact,
                ),
              ),

              if (isWeighted && progress.topWeightSeries.isNotEmpty) ...[
                const SizedBox(height: Gap.xxl),
                const SectionHeader(title: 'Top weight per session'),
                AppCard(
                  child: ProgressLineChart(
                    points: progress.topWeightSeries,
                    valueFormatter: (v) => '${v.round()} kg',
                  ),
                ),
                if (progress.estimatedOneRepMax.length >= 2) ...[
                  const SizedBox(height: Gap.xxl),
                  const SectionHeader(title: 'Estimated one-rep max'),
                  AppCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Epley estimate from your heaviest working set. '
                          'A guide, not a test result.',
                          style: AppTypography.bodySmall.copyWith(
                            color: c.textTertiary,
                          ),
                        ),
                        const SizedBox(height: Gap.lg),
                        ProgressLineChart(
                          points: progress.estimatedOneRepMax,
                          valueFormatter: (v) => '${v.round()} kg',
                        ),
                      ],
                    ),
                  ),
                ],
              ],

              const SizedBox(height: Gap.xxl),
              AppCard(
                onTap: () => context.push(Routes.exercise(exercise.id)),
                child: Row(
                  children: [
                    Icon(exercise.trackingType.icon, color: c.accent, size: 20),
                    const SizedBox(width: Gap.md),
                    Expanded(
                      child: Text(
                        'How to do ${exercise.name}',
                        style: AppTypography.titleS.copyWith(
                          color: c.textPrimary,
                        ),
                      ),
                    ),
                    Icon(
                      Icons.chevron_right_rounded,
                      color: c.textTertiary,
                      size: 20,
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
