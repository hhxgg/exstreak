import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/formatters.dart';
import '../../domain/exercise_icons.dart';
import '../../router.dart';
import '../../state/providers.dart';
import '../../theme/app_dimens.dart';
import '../../theme/app_theme.dart';
import '../../theme/app_typography.dart';
import '../../widgets/buttons.dart';
import '../../widgets/indicators.dart';
import '../../widgets/surfaces.dart';
import '../workout/workout_launcher.dart';

/// Everything about one exercise: how to do it, your records, and a way to
/// start training it immediately.
class ExerciseDetailScreen extends ConsumerWidget {
  const ExerciseDetailScreen({super.key, required this.exerciseId});

  final int exerciseId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final c = context.colors;
    final exerciseAsync = ref.watch(exerciseByIdProvider(exerciseId));
    final progress = ref
        .watch(exerciseProgressProvider(exerciseId))
        .valueOrNull;

    return exerciseAsync.when(
      loading: () => Scaffold(
        backgroundColor: c.background,
        appBar: AppBar(),
        body: Center(child: CircularProgressIndicator(color: c.accent)),
      ),
      error: (e, _) => AppScreen(
        title: 'Exercise',
        child: EmptyState(
          icon: Icons.error_outline_rounded,
          title: 'Could not load',
          message: '$e',
        ),
      ),
      data: (exercise) {
        if (exercise == null) {
          return AppScreen(
            title: 'Exercise',
            child: EmptyState(
              icon: Icons.help_outline_rounded,
              title: 'Not found',
              message: 'This exercise is no longer in your library.',
              actionLabel: 'Back to library',
              onAction: () => context.go(Routes.library),
            ),
          );
        }

        final instructions = exercise.instructions
            .split('\n')
            .where((s) => s.trim().isNotEmpty)
            .toList();

        return Scaffold(
          backgroundColor: c.background,
          appBar: AppBar(
            title: Text(
              exercise.name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            actions: [
              IconButton(
                tooltip: exercise.isFavourite
                    ? 'Remove from favourites'
                    : 'Add to favourites',
                icon: Icon(
                  exercise.isFavourite
                      ? Icons.star_rounded
                      : Icons.star_outline_rounded,
                  color: exercise.isFavourite ? c.warning : null,
                ),
                onPressed: () async {
                  await ref
                      .read(exerciseRepositoryProvider)
                      .toggleFavourite(exercise);
                  ref.invalidate(exerciseByIdProvider(exerciseId));
                },
              ),
              PopupMenuButton<String>(
                itemBuilder: (context) => [
                  const PopupMenuItem(value: 'edit', child: Text('Edit')),
                  PopupMenuItem(
                    value: 'delete',
                    child: Text(
                      exercise.isCustom ? 'Delete' : 'Hide from library',
                      style: TextStyle(color: c.danger),
                    ),
                  ),
                ],
                onSelected: (value) async {
                  if (value == 'edit') {
                    context.push(Routes.editExercise(exercise.id));
                    return;
                  }
                  final confirmed = await showDialog<bool>(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: Text(
                        exercise.isCustom
                            ? 'Delete ${exercise.name}?'
                            : 'Hide ${exercise.name}?',
                      ),
                      content: Text(
                        exercise.isCustom
                            ? 'Sessions that already used it keep their history.'
                            : 'It will be hidden from the library. Your history '
                                  'is untouched and you can restore it later.',
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => context.pop(false),
                          child: const Text('Cancel'),
                        ),
                        TextButton(
                          onPressed: () => context.pop(true),
                          child: Text(
                            exercise.isCustom ? 'Delete' : 'Hide',
                            style: TextStyle(color: c.danger),
                          ),
                        ),
                      ],
                    ),
                  );
                  if (confirmed != true || !context.mounted) return;
                  await ref
                      .read(exerciseRepositoryProvider)
                      .remove(exercise.id);
                  if (context.mounted) context.pop();
                },
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
                Row(
                  children: [
                    Container(
                      width: 64,
                      height: 64,
                      decoration: BoxDecoration(
                        gradient: c.brandGradient,
                        borderRadius: BorderRadius.circular(Radii.md),
                      ),
                      child: Icon(
                        ExerciseIcons.resolve(exercise.iconName),
                        size: 30,
                        color: c.accentContrast,
                      ),
                    ),
                    const SizedBox(width: Gap.lg),
                    Expanded(
                      child: Wrap(
                        spacing: Gap.sm,
                        runSpacing: Gap.sm,
                        children: [
                          TagChip(
                            label: exercise.muscleGroup.label,
                            icon: exercise.muscleGroup.icon,
                          ),
                          TagChip(label: exercise.equipment.label),
                          TagChip(label: exercise.difficulty.label),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: Gap.xl),

                if (exercise.description.isNotEmpty) ...[
                  Text(
                    exercise.description,
                    style: AppTypography.body.copyWith(color: c.textSecondary),
                  ),
                  const SizedBox(height: Gap.xxl),
                ],

                if (progress != null && progress.hasHistory) ...[
                  const SectionHeader(title: 'Your records'),
                  AppCard(
                    child: Row(
                      children: [
                        Expanded(
                          child: StatTile(
                            value: exercise.trackingType.tracksDuration
                                ? Fmt.duration(progress.recordDuration.round())
                                : Fmt.count(progress.recordReps),
                            label: 'Best set',
                            icon: Icons.emoji_events_rounded,
                            iconColor: c.warning,
                            compact: true,
                          ),
                        ),
                        Container(width: 1, height: 44, color: c.border),
                        const SizedBox(width: Gap.lg),
                        Expanded(
                          child: StatTile(
                            value: exercise.trackingType.tracksDuration
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
                        Container(width: 1, height: 44, color: c.border),
                        const SizedBox(width: Gap.lg),
                        Expanded(
                          child: StatTile(
                            value: '${progress.totals.activeDays}',
                            label: 'Days trained',
                            icon: Icons.calendar_today_rounded,
                            iconColor: c.success,
                            compact: true,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: Gap.md),
                  SecondaryButton(
                    label: 'See full progress',
                    icon: Icons.show_chart_rounded,
                    onPressed: () =>
                        context.push(Routes.exerciseProgress(exercise.id)),
                  ),
                  const SizedBox(height: Gap.xxl),
                ],

                if (instructions.isNotEmpty) ...[
                  const SectionHeader(title: 'How to do it'),
                  AppCard(
                    child: Column(
                      children: [
                        for (var i = 0; i < instructions.length; i++)
                          Padding(
                            padding: EdgeInsets.only(
                              bottom: i == instructions.length - 1 ? 0 : Gap.lg,
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  width: 24,
                                  height: 24,
                                  decoration: BoxDecoration(
                                    color: c.accentSoft,
                                    shape: BoxShape.circle,
                                  ),
                                  child: Center(
                                    child: Text(
                                      '${i + 1}',
                                      style: AppTypography.caption.copyWith(
                                        color: c.accent,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: Gap.md),
                                Expanded(
                                  child: Text(
                                    instructions[i],
                                    style: AppTypography.body.copyWith(
                                      color: c.textSecondary,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                      ],
                    ),
                  ),
                  const SizedBox(height: Gap.xxl),
                ],

                const SectionHeader(title: 'Details'),
                AppCard(
                  padding: const EdgeInsets.symmetric(vertical: Gap.sm),
                  child: Column(
                    children: [
                      AppListTile(
                        title: 'Tracks',
                        subtitle: exercise.trackingType.label,
                        leadingIcon: exercise.trackingType.icon,
                        showChevron: false,
                      ),
                      AppListTile(
                        title: 'Default rest',
                        subtitle: Fmt.duration(exercise.defaultRestSeconds),
                        leadingIcon: Icons.timer_outlined,
                        leadingColor: c.info,
                        showChevron: false,
                      ),
                      AppListTile(
                        title: 'Load',
                        subtitle: exercise.isBodyweight
                            ? 'Bodyweight'
                            : 'External weight',
                        leadingIcon: Icons.fitness_center_rounded,
                        leadingColor: c.success,
                        showChevron: false,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: Gap.xxl),

                PrimaryButton(
                  label: 'Train this now',
                  icon: Icons.play_arrow_rounded,
                  gradient: true,
                  onPressed: () =>
                      startFreePractice(context, ref, exercise: exercise),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
