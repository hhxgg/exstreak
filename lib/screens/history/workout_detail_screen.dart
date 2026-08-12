import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/day.dart';
import '../../core/formatters.dart';
import '../../domain/enums.dart';
import '../../router.dart';
import '../../state/providers.dart';
import '../../theme/app_dimens.dart';
import '../../theme/app_theme.dart';
import '../../theme/app_typography.dart';
import '../../widgets/indicators.dart';
import '../../widgets/surfaces.dart';

/// Full detail of one past session, set by set.
class WorkoutDetailScreen extends ConsumerWidget {
  const WorkoutDetailScreen({super.key, required this.workoutId});

  final int workoutId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final c = context.colors;
    final workoutAsync = ref.watch(workoutRowProvider(workoutId));
    final detailAsync = ref.watch(workoutDetailProvider(workoutId));
    final units = ref.watch(unitSystemProvider);

    return workoutAsync.when(
      loading: () => Scaffold(
        backgroundColor: c.background,
        appBar: AppBar(),
        body: Center(child: CircularProgressIndicator(color: c.accent)),
      ),
      error: (e, _) => AppScreen(
        title: 'Workout',
        child: EmptyState(
          icon: Icons.error_outline_rounded,
          title: 'Could not load',
          message: '$e',
        ),
      ),
      data: (workout) {
        if (workout == null) {
          return AppScreen(
            title: 'Workout',
            child: EmptyState(
              icon: Icons.help_outline_rounded,
              title: 'Session not found',
              message: 'It may have been deleted.',
              actionLabel: 'Back to progress',
              onAction: () => context.go(Routes.progress),
            ),
          );
        }

        final day = Day.fromEpochKey(workout.dayKey);
        final detail = detailAsync.valueOrNull ?? const [];

        return Scaffold(
          backgroundColor: c.background,
          appBar: AppBar(
            title: const Text('Session'),
            actions: [
              IconButton(
                tooltip: 'Delete session',
                icon: Icon(Icons.delete_outline_rounded, color: c.danger),
                onPressed: () => _confirmDelete(context, ref, workoutId),
              ),
            ],
          ),
          body: SafeArea(
            top: false,
            child: ListView(
              padding: const EdgeInsets.fromLTRB(
                Gap.screenH,
                Gap.lg,
                Gap.screenH,
                Gap.giant,
              ),
              children: [
                Text(
                  workout.title.isEmpty ? workout.source.label : workout.title,
                  style: AppTypography.titleL.copyWith(color: c.textPrimary),
                ),
                const SizedBox(height: Gap.xs),
                Text(
                  '${Fmt.dayLong(day)} · ${Fmt.time(workout.startedAt)}',
                  style: AppTypography.bodySmall.copyWith(
                    color: c.textSecondary,
                  ),
                ),
                const SizedBox(height: Gap.xl),

                AppCard(
                  child: Row(
                    children: [
                      Expanded(
                        child: StatTile(
                          value: workout.totalReps > 0
                              ? Fmt.count(workout.totalReps)
                              : Fmt.duration(workout.totalDurationSeconds),
                          label: workout.totalReps > 0 ? 'Reps' : 'Held',
                          icon: workout.totalReps > 0
                              ? Icons.repeat_rounded
                              : Icons.timer_outlined,
                          iconColor: c.accent,
                          compact: true,
                        ),
                      ),
                      Container(width: 1, height: 44, color: c.border),
                      const SizedBox(width: Gap.lg),
                      Expanded(
                        child: StatTile(
                          value:
                              '${detail.fold<int>(0, (a, d) => a + d.$2.length)}',
                          label: 'Sets',
                          icon: Icons.format_list_numbered_rounded,
                          iconColor: c.info,
                          compact: true,
                        ),
                      ),
                      Container(width: 1, height: 44, color: c.border),
                      const SizedBox(width: Gap.lg),
                      Expanded(
                        child: StatTile(
                          value: Fmt.durationLong(workout.durationSeconds),
                          label: 'Duration',
                          icon: Icons.schedule_rounded,
                          iconColor: c.success,
                          compact: true,
                        ),
                      ),
                    ],
                  ),
                ),

                if (workout.feedback != null) ...[
                  const SizedBox(height: Gap.md),
                  InfoBanner(
                    message:
                        'You rated this session "${workout.feedback!.label}".',
                    icon: workout.feedback!.icon,
                    tone: switch (workout.feedback!) {
                      SessionFeedback.tooEasy => BannerTone.info,
                      SessionFeedback.justRight => BannerTone.success,
                      SessionFeedback.tooHard => BannerTone.warning,
                    },
                  ),
                ],

                const SizedBox(height: Gap.xxl),
                const SectionHeader(title: 'Sets'),

                if (detail.isEmpty)
                  AppCard(
                    child: EmptyState(
                      icon: Icons.inbox_rounded,
                      title: 'No sets recorded',
                      message: 'This session was saved without completed sets.',
                      compact: true,
                    ),
                  )
                else
                  for (final (exercise, sets) in detail)
                    Padding(
                      padding: const EdgeInsets.only(bottom: Gap.md),
                      child: AppCard(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  exercise.trackingType.icon,
                                  size: 18,
                                  color: c.accent,
                                ),
                                const SizedBox(width: Gap.sm),
                                Expanded(
                                  child: Text(
                                    exercise.exerciseName,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: AppTypography.titleS.copyWith(
                                      color: c.textPrimary,
                                    ),
                                  ),
                                ),
                                if (exercise.isSkipped)
                                  TagChip(
                                    label: 'Skipped',
                                    color: c.textTertiary,
                                    dense: true,
                                  ),
                              ],
                            ),
                            if (sets.isNotEmpty) ...[
                              const SizedBox(height: Gap.md),
                              const Divider(),
                              const SizedBox(height: Gap.sm),
                              for (var i = 0; i < sets.length; i++)
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: Gap.xs,
                                  ),
                                  child: Row(
                                    children: [
                                      SizedBox(
                                        width: 52,
                                        child: Text(
                                          'Set ${i + 1}',
                                          style: AppTypography.bodySmall
                                              .copyWith(color: c.textTertiary),
                                        ),
                                      ),
                                      Expanded(
                                        child: Text(
                                          _setLabel(
                                            sets[i].reps,
                                            sets[i].durationSeconds,
                                            sets[i].weightKg,
                                            sets[i].distanceMeters,
                                            exercise.trackingType,
                                            units,
                                          ),
                                          style: AppTypography.bodyStrong
                                              .copyWith(
                                                color: c.textPrimary,
                                                fontFeatures:
                                                    AppTypography.tabular,
                                              ),
                                        ),
                                      ),
                                      if (sets[i].targetValue != null &&
                                          sets[i].targetValue! > 0)
                                        Text(
                                          'target ${Fmt.trackedValue(sets[i].targetValue!, exercise.trackingType)}',
                                          style: AppTypography.caption.copyWith(
                                            color: c.textTertiary,
                                          ),
                                        ),
                                    ],
                                  ),
                                ),
                            ],
                          ],
                        ),
                      ),
                    ),
              ],
            ),
          ),
        );
      },
    );
  }

  static String _setLabel(
    int reps,
    int seconds,
    double weightKg,
    double meters,
    TrackingType type,
    UnitSystem units,
  ) {
    return switch (type) {
      TrackingType.reps => '$reps reps',
      TrackingType.repsWeight =>
        weightKg > 0 ? '$reps × ${Fmt.weight(weightKg, units)}' : '$reps reps',
      TrackingType.duration => Fmt.duration(seconds),
      TrackingType.distanceDuration =>
        '${Fmt.distance(meters)} · ${Fmt.duration(seconds)}',
    };
  }

  Future<void> _confirmDelete(
    BuildContext context,
    WidgetRef ref,
    int id,
  ) async {
    final c = context.colors;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete this session?'),
        content: const Text(
          'It will be removed from your history and your streak and '
          'statistics will be recalculated.',
        ),
        actions: [
          TextButton(
            onPressed: () => context.pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => context.pop(true),
            child: Text('Delete', style: TextStyle(color: c.danger)),
          ),
        ],
      ),
    );
    if (confirmed != true || !context.mounted) return;

    final db = ref.read(databaseProvider);
    final workout = await db.workoutById(id);
    await db.deleteWorkout(id);
    if (workout != null) {
      // Recomputing rather than decrementing keeps totals honest.
      await db.recomputeDailyActivity(Day.fromEpochKey(workout.dayKey));
    }
    await ref.read(workoutRepositoryProvider).refreshGoals();

    if (!context.mounted) return;
    refreshAll(ref);
    context.pop();
  }
}
