import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../data/database.dart';
import '../../domain/enums.dart';
import '../../domain/plan/plan_templates.dart';
import '../../domain/workout/workout_models.dart';
import '../../router.dart';
import '../../state/providers.dart';

/// Shared entry points for starting a session.
///
/// Every screen that can begin a workout funnels through here, so plan
/// resolution, draft construction and navigation stay in one place.

/// Starts the user's current plan day.
Future<void> startPlanWorkout(BuildContext context, WidgetRef ref) async {
  final plan = ref.read(planProgressProvider).valueOrNull;
  if (plan == null) return;
  await startPlanDay(
    context,
    ref,
    template: plan.template,
    level: plan.level,
    day: plan.day,
  );
}

/// Starts a specific level/day of a specific plan.
Future<void> startPlanDay(
  BuildContext context,
  WidgetRef ref, {
  required PlanTemplate template,
  required int level,
  required int day,
}) async {
  final exercises = ref.read(exerciseRepositoryProvider);
  final exercise = await exercises.bySlug(template.exerciseSlug);
  if (!context.mounted) return;

  if (exercise == null) {
    _showError(
      context,
      'The ${template.name} needs the "${template.exerciseSlug}" exercise, '
      'which is missing from your library.',
    );
    return;
  }

  final planDay = template.dayFor(level, day);
  final draft = WorkoutDraft(
    source: WorkoutSource.plan,
    title: '${template.name} · Level $level · Day $day',
    planId: template.id,
    planLevel: level,
    planDay: day,
    exercises: [
      PlannedExercise(
        exerciseId: exercise.id,
        name: exercise.name,
        trackingType: exercise.trackingType,
        restSeconds: exercise.defaultRestSeconds,
        sets: [
          for (final target in planDay.targets) PlannedSet(target: target),
        ],
      ),
    ],
  );

  await _launch(context, ref, draft);
}

/// Starts an unlimited single-exercise effort with no targets.
Future<void> startFreePractice(
  BuildContext context,
  WidgetRef ref, {
  required ExerciseRow exercise,
  int setCount = 1,
}) async {
  final draft = WorkoutDraft(
    source: WorkoutSource.freePractice,
    title: 'Free practice · ${exercise.name}',
    exercises: [
      PlannedExercise(
        exerciseId: exercise.id,
        name: exercise.name,
        trackingType: exercise.trackingType,
        restSeconds: exercise.defaultRestSeconds,
        // No target: the counter runs open-ended until the user stops.
        sets: [for (var i = 0; i < setCount; i++) const PlannedSet()],
      ),
    ],
  );

  await _launch(context, ref, draft);
}

/// Starts a user-assembled session.
Future<void> startCustomWorkout(
  BuildContext context,
  WidgetRef ref, {
  required List<PlannedExercise> exercises,
  String title = 'Custom workout',
}) async {
  if (exercises.isEmpty) return;
  final draft = WorkoutDraft(
    source: WorkoutSource.custom,
    title: title,
    exercises: exercises,
  );
  await _launch(context, ref, draft);
}

Future<void> _launch(
  BuildContext context,
  WidgetRef ref,
  WorkoutDraft draft,
) async {
  final repo = ref.read(workoutRepositoryProvider);

  try {
    // An abandoned empty session would otherwise sit in the resume slot and
    // shadow the one the user just asked for.
    final existing = await repo.resumableWorkout();
    if (existing != null && existing.completedSets == 0) {
      await repo.cancelWorkout(existing.id);
    }

    final id = await repo.createWorkout(draft);
    if (!context.mounted) return;

    ref.invalidate(resumableWorkoutProvider);
    await context.push(Routes.activeWorkout, extra: id);
  } on Object catch (e) {
    if (!context.mounted) return;
    _showError(context, 'Could not start the workout: $e');
  }
}

void _showError(BuildContext context, String message) {
  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(SnackBar(content: Text(message)));
}
