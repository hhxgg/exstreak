import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/formatters.dart';
import '../../data/database.dart';
import '../../domain/enums.dart';
import '../../domain/exercise_icons.dart';
import '../../domain/workout/workout_models.dart';
import '../../state/providers.dart';
import '../../theme/app_dimens.dart';
import '../../theme/app_theme.dart';
import '../../theme/app_typography.dart';
import '../../widgets/buttons.dart';
import '../../widgets/surfaces.dart';
import 'workout_launcher.dart';

/// Assemble a session by hand: pick exercises, set the sets and targets.
class WorkoutBuilderScreen extends ConsumerStatefulWidget {
  const WorkoutBuilderScreen({super.key});

  @override
  ConsumerState<WorkoutBuilderScreen> createState() =>
      _WorkoutBuilderScreenState();
}

class _WorkoutBuilderScreenState extends ConsumerState<WorkoutBuilderScreen> {
  final List<PlannedExercise> _exercises = [];

  /// Sensible starting prescription per tracking type.
  static const int _defaultSets = 3;

  int _defaultTargetFor(TrackingType type) => switch (type) {
    TrackingType.reps => 10,
    TrackingType.repsWeight => 8,
    TrackingType.duration => 45,
    TrackingType.distanceDuration => 1000,
  };

  Future<void> _addExercise() async {
    final picked = await showModalBottomSheet<ExerciseRow>(
      context: context,
      isScrollControlled: true,
      builder: (context) => const _ExercisePickerSheet(),
    );
    if (picked == null || !mounted) return;

    final target = _defaultTargetFor(picked.trackingType);
    setState(() {
      _exercises.add(
        PlannedExercise(
          exerciseId: picked.id,
          name: picked.name,
          trackingType: picked.trackingType,
          restSeconds: picked.defaultRestSeconds,
          sets: [
            for (var i = 0; i < _defaultSets; i++) PlannedSet(target: target),
          ],
        ),
      );
    });
  }

  void _changeSetCount(int index, int delta) {
    setState(() {
      final ex = _exercises[index];
      final sets = [...ex.sets];
      if (delta > 0) {
        sets.add(sets.isEmpty ? const PlannedSet(target: 10) : sets.last);
      } else if (sets.length > 1) {
        sets.removeLast();
      }
      _exercises[index] = ex.copyWith(sets: sets);
    });
  }

  void _changeTarget(int index, int delta) {
    setState(() {
      final ex = _exercises[index];
      final step = ex.trackingType.tracksDuration ? 5 : 1;
      final sets = [
        for (final s in ex.sets)
          PlannedSet(
            target: ((s.target ?? 0) + delta * step).clamp(1, 9999),
            weightKg: s.weightKg,
          ),
      ];
      _exercises[index] = ex.copyWith(sets: sets);
    });
  }

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final totalSets = _exercises.fold<int>(0, (a, e) => a + e.sets.length);

    return AppScreen(
      title: 'Build a session',
      padded: false,
      child: Column(
        children: [
          Expanded(
            child: _exercises.isEmpty
                ? EmptyState(
                    icon: Icons.tune_rounded,
                    title: 'Nothing added yet',
                    message:
                        'Add the exercises you want to train and set your '
                        'targets. Your session, your rules.',
                    actionLabel: 'Add an exercise',
                    onAction: _addExercise,
                  )
                : ReorderableListView.builder(
                    padding: const EdgeInsets.fromLTRB(
                      Gap.screenH,
                      Gap.lg,
                      Gap.screenH,
                      Gap.xl,
                    ),
                    itemCount: _exercises.length,
                    onReorderItem: (oldIndex, newIndex) => setState(() {
                      final item = _exercises.removeAt(oldIndex);
                      _exercises.insert(newIndex, item);
                    }),
                    itemBuilder: (context, i) => Padding(
                      key: ValueKey('${_exercises[i].exerciseId}-$i'),
                      padding: const EdgeInsets.only(bottom: Gap.md),
                      child: _BuilderRow(
                        exercise: _exercises[i],
                        onRemove: () => setState(() => _exercises.removeAt(i)),
                        onSetsChanged: (d) => _changeSetCount(i, d),
                        onTargetChanged: (d) => _changeTarget(i, d),
                      ),
                    ),
                  ),
          ),
          Container(
            padding: const EdgeInsets.fromLTRB(
              Gap.screenH,
              Gap.lg,
              Gap.screenH,
              Gap.xl,
            ),
            decoration: BoxDecoration(
              color: c.surface,
              border: Border(top: BorderSide(color: c.border)),
            ),
            child: SafeArea(
              top: false,
              child: Column(
                children: [
                  if (_exercises.isNotEmpty) ...[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          '${_exercises.length} '
                          '${_exercises.length == 1 ? 'exercise' : 'exercises'}'
                          ' · $totalSets sets',
                          style: AppTypography.bodySmall.copyWith(
                            color: c.textSecondary,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: Gap.md),
                  ],
                  Row(
                    children: [
                      Expanded(
                        child: SecondaryButton(
                          label: 'Add exercise',
                          icon: Icons.add_rounded,
                          onPressed: _addExercise,
                        ),
                      ),
                      const SizedBox(width: Gap.md),
                      Expanded(
                        flex: 2,
                        child: PrimaryButton(
                          label: 'Start workout',
                          icon: Icons.play_arrow_rounded,
                          gradient: true,
                          onPressed: _exercises.isEmpty
                              ? null
                              : () => startCustomWorkout(
                                  context,
                                  ref,
                                  exercises: _exercises,
                                ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _BuilderRow extends StatelessWidget {
  const _BuilderRow({
    required this.exercise,
    required this.onRemove,
    required this.onSetsChanged,
    required this.onTargetChanged,
  });

  final PlannedExercise exercise;
  final VoidCallback onRemove;
  final ValueChanged<int> onSetsChanged;
  final ValueChanged<int> onTargetChanged;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final target = exercise.sets.isEmpty
        ? 0
        : (exercise.sets.first.target ?? 0);
    final targetLabel = exercise.trackingType.tracksDuration
        ? Fmt.duration(target)
        : '$target';

    return AppCard(
      padding: const EdgeInsets.all(Gap.lg),
      child: Column(
        children: [
          Row(
            children: [
              Icon(exercise.trackingType.icon, size: 18, color: c.accent),
              const SizedBox(width: Gap.sm),
              Expanded(
                child: Text(
                  exercise.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTypography.titleS.copyWith(color: c.textPrimary),
                ),
              ),
              IconPill(
                icon: Icons.close_rounded,
                size: 30,
                tooltip: 'Remove',
                onPressed: onRemove,
              ),
            ],
          ),
          const SizedBox(height: Gap.lg),
          Row(
            children: [
              Expanded(
                child: _Stepper(
                  label: 'Sets',
                  value: '${exercise.sets.length}',
                  onDecrement: exercise.sets.length > 1
                      ? () => onSetsChanged(-1)
                      : null,
                  onIncrement: () => onSetsChanged(1),
                ),
              ),
              const SizedBox(width: Gap.md),
              Expanded(
                child: _Stepper(
                  label: exercise.trackingType.tracksDuration ? 'Hold' : 'Reps',
                  value: targetLabel,
                  onDecrement: target > 1 ? () => onTargetChanged(-1) : null,
                  onIncrement: () => onTargetChanged(1),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _Stepper extends StatelessWidget {
  const _Stepper({
    required this.label,
    required this.value,
    required this.onDecrement,
    required this.onIncrement,
  });

  final String label;
  final String value;
  final VoidCallback? onDecrement;
  final VoidCallback? onIncrement;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Container(
      padding: const EdgeInsets.all(Gap.xs),
      decoration: BoxDecoration(
        color: c.surfaceSunken,
        borderRadius: Radii.pillRadius,
        border: Border.all(color: c.border),
      ),
      child: Row(
        children: [
          IconPill(
            icon: Icons.remove_rounded,
            size: 30,
            onPressed: onDecrement,
            tooltip: 'Fewer $label',
          ),
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  value,
                  maxLines: 1,
                  style: AppTypography.titleS.copyWith(color: c.textPrimary),
                ),
                Text(
                  label,
                  style: AppTypography.caption.copyWith(
                    color: c.textTertiary,
                    fontSize: 10.5,
                  ),
                ),
              ],
            ),
          ),
          IconPill(
            icon: Icons.add_rounded,
            size: 30,
            onPressed: onIncrement,
            tooltip: 'More $label',
          ),
        ],
      ),
    );
  }
}

/// Bottom sheet exercise picker shared by the builder.
class _ExercisePickerSheet extends ConsumerStatefulWidget {
  const _ExercisePickerSheet();

  @override
  ConsumerState<_ExercisePickerSheet> createState() =>
      _ExercisePickerSheetState();
}

class _ExercisePickerSheetState extends ConsumerState<_ExercisePickerSheet> {
  String _query = '';

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final all = ref.watch(exercisesProvider).valueOrNull ?? const [];
    final q = _query.trim().toLowerCase();
    final list = q.isEmpty
        ? all
        : all
              .where(
                (e) =>
                    e.name.toLowerCase().contains(q) ||
                    e.muscleGroup.label.toLowerCase().contains(q),
              )
              .toList();

    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.75,
      maxChildSize: 0.92,
      builder: (context, controller) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.viewInsetsOf(context).bottom,
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(
                Gap.screenH,
                Gap.sm,
                Gap.screenH,
                Gap.md,
              ),
              child: TextField(
                autofocus: false,
                onChanged: (v) => setState(() => _query = v),
                decoration: const InputDecoration(
                  hintText: 'Search exercises',
                  prefixIcon: Icon(Icons.search_rounded),
                ),
              ),
            ),
            Expanded(
              child: list.isEmpty
                  ? EmptyState(
                      icon: Icons.search_off_rounded,
                      title: 'Nothing matched',
                      message: 'Try another term.',
                      compact: true,
                    )
                  : ListView.separated(
                      controller: controller,
                      padding: const EdgeInsets.fromLTRB(
                        Gap.screenH,
                        0,
                        Gap.screenH,
                        Gap.xl,
                      ),
                      itemCount: list.length,
                      separatorBuilder: (_, _) =>
                          const SizedBox(height: Gap.sm),
                      itemBuilder: (context, i) {
                        final e = list[i];
                        return AppCard(
                          padding: const EdgeInsets.symmetric(
                            horizontal: Gap.lg,
                            vertical: Gap.md,
                          ),
                          onTap: () => Navigator.of(context).pop(e),
                          child: Row(
                            children: [
                              Icon(
                                ExerciseIcons.resolve(e.iconName),
                                size: 20,
                                color: c.accent,
                              ),
                              const SizedBox(width: Gap.md),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      e.name,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: AppTypography.titleS.copyWith(
                                        color: c.textPrimary,
                                      ),
                                    ),
                                    Text(
                                      '${e.muscleGroup.label} · '
                                      '${e.trackingType.label}',
                                      style: AppTypography.caption.copyWith(
                                        color: c.textSecondary,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Icon(
                                Icons.add_circle_outline_rounded,
                                size: 20,
                                color: c.textTertiary,
                              ),
                            ],
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
