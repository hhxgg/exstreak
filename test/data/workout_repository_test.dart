import 'dart:io';

// `show Value` only — drift also exports `isNull`/`isNotNull` as SQL helpers,
// which would collide with the matchers of the same name.
import 'package:drift/drift.dart' show Value;
import 'package:drift/native.dart';
import 'package:exstreak/core/day.dart';
import 'package:exstreak/data/database.dart';
import 'package:exstreak/data/repositories/workout_repository.dart';
import 'package:exstreak/domain/enums.dart';
import 'package:exstreak/domain/workout/workout_models.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late AppDatabase db;
  late WorkoutRepository repo;

  setUp(() async {
    db = AppDatabase.forTesting(NativeDatabase.memory());
    repo = WorkoutRepository(db);
    // The in-memory database starts empty; `onCreate` runs lazily on first use.
    await db.syncSeedExercises();
  });

  tearDown(() async {
    await db.close();
  });

  Future<ExerciseRow> exercise(String slug) async {
    final row = await db.exerciseBySlug(slug);
    expect(row, isNotNull, reason: 'seed is missing "$slug"');
    return row!;
  }

  Future<WorkoutDraft> repsDraft({
    required ExerciseRow ex,
    List<int> targets = const [10, 8, 6],
  }) async {
    return WorkoutDraft(
      source: WorkoutSource.custom,
      title: 'Test session',
      exercises: [
        PlannedExercise(
          exerciseId: ex.id,
          name: ex.name,
          trackingType: ex.trackingType,
          sets: [for (final t in targets) PlannedSet(target: t)],
        ),
      ],
    );
  }

  /// Runs a full session, completing every set with [reps].
  Future<WorkoutResult> runSession({
    required ExerciseRow ex,
    List<int> targets = const [10, 8, 6],
    int reps = 10,
    SessionFeedback? feedback,
  }) async {
    final id = await repo.createWorkout(await repsDraft(ex: ex, targets: targets));
    final active = await repo.loadActive(id);
    for (final set in active!.exercises.single.sets) {
      await repo.completeSet(setId: set.id, reps: reps);
    }
    return repo.finishWorkout(workoutId: id, feedback: feedback);
  }

  group('seeding', () {
    test('ships a catalogue covering every muscle group', () async {
      final all = await db.getExercises();
      expect(all.length, greaterThanOrEqualTo(30));

      final groups = all.map((e) => e.muscleGroup).toSet();
      for (final group in MuscleGroup.values) {
        expect(groups, contains(group), reason: '$group has no exercise');
      }
    });

    test('covers every tracking type', () async {
      final all = await db.getExercises();
      final types = all.map((e) => e.trackingType).toSet();
      for (final type in TrackingType.values) {
        expect(types, contains(type), reason: '$type has no exercise');
      }
    });

    test('re-seeding does not duplicate rows', () async {
      final before = (await db.getExercises()).length;
      await db.syncSeedExercises();
      await db.syncSeedExercises();
      expect((await db.getExercises()).length, before);
    });

    test('re-seeding preserves user favourites', () async {
      final pushup = await exercise('pushup');
      await db.setExerciseFavourite(pushup.id, false);
      await db.syncSeedExercises();
      final after = await exercise('pushup');
      expect(after.isFavourite, isFalse);
    });
  });

  group('creating a workout', () {
    test('persists exercises and sets with their targets', () async {
      final pushup = await exercise('pushup');
      final id = await repo.createWorkout(
        await repsDraft(ex: pushup, targets: [12, 10, 8]),
      );

      final active = await repo.loadActive(id);
      expect(active, isNotNull);
      expect(active!.exercises, hasLength(1));
      expect(active.totalSets, 3);
      expect(active.completedSets, 0);
      expect(
        active.exercises.single.sets.map((s) => s.target).toList(),
        [12, 10, 8],
      );
    });

    test('a fresh session is not yet in history', () async {
      final pushup = await exercise('pushup');
      await repo.createWorkout(await repsDraft(ex: pushup));
      expect(await db.completedWorkouts(), isEmpty);
    });

    test('completing a set is written through immediately', () async {
      final pushup = await exercise('pushup');
      final id = await repo.createWorkout(await repsDraft(ex: pushup));
      final active = await repo.loadActive(id);
      await repo.completeSet(setId: active!.exercises.single.sets.first.id, reps: 11);

      // Re-reading from the database, as a cold start would.
      final reloaded = await repo.loadActive(id);
      expect(reloaded!.completedSets, 1);
      expect(reloaded.exercises.single.sets.first.reps, 11);
      expect(reloaded.totalReps, 11);
    });

    test('uncompleteSet reverses a mis-tap', () async {
      final pushup = await exercise('pushup');
      final id = await repo.createWorkout(await repsDraft(ex: pushup));
      final active = await repo.loadActive(id);
      final setId = active!.exercises.single.sets.first.id;

      await repo.completeSet(setId: setId, reps: 11);
      await repo.uncompleteSet(setId);

      final reloaded = await repo.loadActive(id);
      expect(reloaded!.completedSets, 0);
      expect(reloaded.exercises.single.sets.first.reps, 0);
    });

    test('addSet appends to the end', () async {
      final pushup = await exercise('pushup');
      final id = await repo.createWorkout(
        await repsDraft(ex: pushup, targets: [10]),
      );
      final active = await repo.loadActive(id);
      await repo.addSet(active!.exercises.single.id, target: 5);

      final reloaded = await repo.loadActive(id);
      expect(reloaded!.totalSets, 2);
      expect(reloaded.exercises.single.sets.last.target, 5);
    });
  });

  group('finishing a workout', () {
    test('rolls up totals and records daily activity', () async {
      final pushup = await exercise('pushup');
      final result = await runSession(
        ex: pushup,
        targets: [10, 10, 10],
        reps: 12,
      );

      expect(result.totalReps, 36);

      final today = Day.today();
      final activity = await db.activityForDay(today);
      expect(activity, isNotNull);
      expect(activity!.workoutCount, 1);
      expect(activity.totalReps, 36);

      final history = await db.completedWorkouts();
      expect(history, hasLength(1));
      expect(history.single.totalReps, 36);
      expect(history.single.isCompleted, isTrue);
    });

    test('starts the streak at one', () async {
      final pushup = await exercise('pushup');
      final result = await runSession(ex: pushup);
      expect(result.streakBefore, 0);
      expect(result.streakAfter, 1);
      expect(result.streakIncreased, isTrue);
      expect(result.isFirstWorkoutOfDay, isTrue);
    });

    test('a second session the same day does not advance the streak', () async {
      final pushup = await exercise('pushup');
      await runSession(ex: pushup);
      final second = await runSession(ex: pushup);

      expect(second.streakBefore, 1);
      expect(second.streakAfter, 1);
      expect(second.streakIncreased, isFalse);
      expect(second.isFirstWorkoutOfDay, isFalse);

      final activity = await db.activityForDay(Day.today());
      expect(activity!.workoutCount, 2);
    });

    test('records a personal record on the first session', () async {
      final pushup = await exercise('pushup');
      final result = await runSession(ex: pushup, reps: 14);

      expect(result.newRecords, isNotEmpty);
      final pr = await db.record(pushup.id, PrMetric.bestSetReps);
      expect(pr!.value, 14);
    });

    test('only reports a record when it is actually beaten', () async {
      final pushup = await exercise('pushup');
      await runSession(ex: pushup, reps: 20);
      final worse = await runSession(ex: pushup, reps: 10);

      expect(worse.newRecords, isEmpty);
      final pr = await db.record(pushup.id, PrMetric.bestSetReps);
      expect(pr!.value, 20);
    });

    test('tracks duration records separately for holds', () async {
      final plank = await exercise('plank');
      final id = await repo.createWorkout(
        WorkoutDraft(
          source: WorkoutSource.custom,
          title: 'Plank test',
          exercises: [
            PlannedExercise(
              exerciseId: plank.id,
              name: plank.name,
              trackingType: plank.trackingType,
              sets: const [PlannedSet(target: 60)],
            ),
          ],
        ),
      );
      final active = await repo.loadActive(id);
      await repo.completeSet(
        setId: active!.exercises.single.sets.single.id,
        durationSeconds: 75,
      );
      final result = await repo.finishWorkout(workoutId: id);

      expect(result.totalDurationSeconds, 75);
      expect(result.totalReps, 0);
      final pr = await db.record(plank.id, PrMetric.bestSetDuration);
      expect(pr!.value, 75);
    });

    test('a session with no completed sets records nothing', () async {
      final pushup = await exercise('pushup');
      final id = await repo.createWorkout(await repsDraft(ex: pushup));
      final result = await repo.finishWorkout(workoutId: id);

      expect(result.totalReps, 0);
      // No activity row means the day does not count toward the streak.
      expect(await db.activityForDay(Day.today()), isNull);
      expect((await repo.computeStreak()).current, 0);
    });

    test('throws a clear error when the workout has vanished', () async {
      expect(
        () => repo.finishWorkout(workoutId: 99999),
        throwsA(isA<StateError>()),
      );
    });
  });

  group('badges', () {
    test('awards the first-step badge on the first session', () async {
      final pushup = await exercise('pushup');
      final result = await runSession(ex: pushup, reps: 5);
      expect(result.newBadges, contains('streak_1'));
    });

    test('awards a max-rep badge when the threshold is crossed', () async {
      final pushup = await exercise('pushup');
      final result = await runSession(ex: pushup, reps: 26);
      expect(result.newBadges, contains('maxrep_25'));
    });

    test('does not award the same badge twice', () async {
      final pushup = await exercise('pushup');
      await runSession(ex: pushup, reps: 30);
      final second = await runSession(ex: pushup, reps: 30);
      expect(second.newBadges, isNot(contains('maxrep_25')));
    });
  });

  group('goals', () {
    test('single-set record goals track the personal record', () async {
      final pushup = await exercise('pushup');
      final goalId = await db.insertGoal(
        GoalsCompanion.insert(
          title: '25 push-ups',
          type: GoalType.singleSetRecord,
          exerciseId: Value(pushup.id),
          targetValue: 25,
          startDayKey: Day.today().key,
        ),
      );

      await runSession(ex: pushup, reps: 12);
      var goal = await db.goalById(goalId);
      expect(goal!.achievedValue, 12);
      expect(goal.isCompleted, isFalse);

      await runSession(ex: pushup, reps: 27);
      goal = await db.goalById(goalId);
      expect(goal!.achievedValue, 27);
      expect(goal.isCompleted, isTrue);
    });

    test('workout-count goals accumulate sessions', () async {
      final pushup = await exercise('pushup');
      final goalId = await db.insertGoal(
        GoalsCompanion.insert(
          title: 'Three sessions',
          type: GoalType.workoutCount,
          targetValue: 3,
          startDayKey: Day.today().key,
        ),
      );

      await runSession(ex: pushup);
      await runSession(ex: pushup);
      expect((await db.goalById(goalId))!.isCompleted, isFalse);

      final third = await runSession(ex: pushup);
      expect((await db.goalById(goalId))!.isCompleted, isTrue);
      expect(third.completedGoalIds, contains(goalId));
    });

    test('streak goals read the live streak', () async {
      final pushup = await exercise('pushup');
      final goalId = await db.insertGoal(
        GoalsCompanion.insert(
          title: '1-day streak',
          type: GoalType.streakDays,
          targetValue: 1,
          startDayKey: Day.today().key,
        ),
      );

      await runSession(ex: pushup);
      expect((await db.goalById(goalId))!.isCompleted, isTrue);
    });
  });

  group('plan progression', () {
    test('"just right" advances one day', () async {
      await repo.advancePlan(
        planId: 'pushup-100',
        currentLevel: 1,
        currentDay: 3,
        feedback: SessionFeedback.justRight,
        day: Day.today(),
      );
      final progress = await db.planProgress('pushup-100');
      expect(progress!.level, 1);
      expect(progress.currentDay, 4);
    });

    test('"too hard" repeats the same day', () async {
      await repo.advancePlan(
        planId: 'pushup-100',
        currentLevel: 2,
        currentDay: 5,
        feedback: SessionFeedback.tooHard,
        day: Day.today(),
      );
      final progress = await db.planProgress('pushup-100');
      expect(progress!.level, 2);
      expect(progress.currentDay, 5);
    });

    test('"too easy" jumps a level', () async {
      await repo.advancePlan(
        planId: 'pushup-100',
        currentLevel: 1,
        currentDay: 4,
        feedback: SessionFeedback.tooEasy,
        day: Day.today(),
      );
      final progress = await db.planProgress('pushup-100');
      expect(progress!.level, 2);
    });

    test('finishing the last day of a level rolls into the next', () async {
      await repo.advancePlan(
        planId: 'pushup-100',
        currentLevel: 1,
        currentDay: 16,
        feedback: SessionFeedback.justRight,
        day: Day.today(),
      );
      final progress = await db.planProgress('pushup-100');
      expect(progress!.level, 2);
      expect(progress.currentDay, 1);
    });

    test('the top of the final level holds rather than wrapping', () async {
      await repo.advancePlan(
        planId: 'pushup-100',
        currentLevel: 3,
        currentDay: 16,
        feedback: SessionFeedback.justRight,
        day: Day.today(),
      );
      final progress = await db.planProgress('pushup-100');
      expect(progress!.level, 3);
      expect(progress.currentDay, 16);
    });
  });

  group('streak freezes', () {
    test('bridge a single missed day', () async {
      final pushup = await exercise('pushup');
      await runSession(ex: pushup);

      // Backdate the session to two days ago, leaving yesterday empty.
      final twoDaysAgo = Day.today().addDays(-2);
      final workout = (await db.completedWorkouts()).single;
      await db.updateWorkout(
        workout.id,
        WorkoutsCompanion(dayKey: Value(twoDaysAgo.key)),
      );
      await db.recomputeDailyActivity(Day.today());
      await db.recomputeDailyActivity(twoDaysAgo);

      expect((await repo.computeStreak()).current, 0);

      final spent = await repo.applyFreezes(available: 1);
      expect(spent, 1);
      expect((await repo.computeStreak()).current, 2);
    });

    test('are not spent on a gap they cannot fully cover', () async {
      final pushup = await exercise('pushup');
      await runSession(ex: pushup);

      final fiveDaysAgo = Day.today().addDays(-5);
      final workout = (await db.completedWorkouts()).single;
      await db.updateWorkout(
        workout.id,
        WorkoutsCompanion(dayKey: Value(fiveDaysAgo.key)),
      );
      await db.recomputeDailyActivity(Day.today());
      await db.recomputeDailyActivity(fiveDaysAgo);

      // Four missing days, only one token: spending it would waste it.
      expect(await repo.applyFreezes(available: 1), 0);
      expect((await repo.computeStreak()).current, 0);
    });

    test('are a no-op with no tokens', () async {
      expect(await repo.applyFreezes(available: 0), 0);
    });
  });

  group('deleting history', () {
    test('recomputing after a delete clears the day', () async {
      final pushup = await exercise('pushup');
      await runSession(ex: pushup);
      expect((await repo.computeStreak()).current, 1);

      final workout = (await db.completedWorkouts()).single;
      await db.deleteWorkout(workout.id);
      await db.recomputeDailyActivity(Day.today());

      expect(await db.activityForDay(Day.today()), isNull);
      expect((await repo.computeStreak()).current, 0);
    });

    test('deleting a workout removes its sets', () async {
      final pushup = await exercise('pushup');
      await runSession(ex: pushup);
      final workout = (await db.completedWorkouts()).single;

      await db.deleteWorkout(workout.id);
      expect(await db.setsForWorkout(workout.id), isEmpty);
      expect(await db.exercisesForWorkout(workout.id), isEmpty);
    });
  });

  group('exercise removal', () {
    test('a seeded exercise is archived, not deleted', () async {
      final pushup = await exercise('pushup');
      await db.removeExercise(pushup.id);

      final visible = await db.getExercises();
      expect(visible.any((e) => e.id == pushup.id), isFalse);

      final all = await db.getExercises(includeArchived: true);
      expect(all.firstWhere((e) => e.id == pushup.id).isArchived, isTrue);
    });

    test('a custom exercise used by history is archived, not deleted', () async {
      final id = await db.insertExercise(
        ExercisesCompanion.insert(
          name: 'Archer push-ups',
          muscleGroup: MuscleGroup.chest,
          equipment: Equipment.none,
          difficulty: Difficulty.advanced,
          trackingType: TrackingType.reps,
          isCustom: const Value(true),
        ),
      );
      final custom = (await db.exerciseById(id))!;
      await runSession(ex: custom, targets: [5], reps: 5);

      await db.removeExercise(id);
      final all = await db.getExercises(includeArchived: true);
      expect(all.firstWhere((e) => e.id == id).isArchived, isTrue);
      // History survives.
      expect(await db.completedWorkouts(), hasLength(1));
    });

    test('an unused custom exercise is deleted outright', () async {
      final id = await db.insertExercise(
        ExercisesCompanion.insert(
          name: 'Never used',
          muscleGroup: MuscleGroup.core,
          equipment: Equipment.none,
          difficulty: Difficulty.beginner,
          trackingType: TrackingType.reps,
          isCustom: const Value(true),
        ),
      );

      await db.removeExercise(id);
      expect(await db.exerciseById(id), isNull);
    });
  });

  group('abandoned sessions', () {
    test('an empty unfinished session is purged', () async {
      final pushup = await exercise('pushup');
      await repo.createWorkout(await repsDraft(ex: pushup));

      final removed = await db.purgeEmptyUnfinishedWorkouts();
      expect(removed, 1);
      expect(await db.latestUnfinishedWorkout(), isNull);
    });

    test('a partially completed session is kept and resumable', () async {
      final pushup = await exercise('pushup');
      final id = await repo.createWorkout(await repsDraft(ex: pushup));
      final active = await repo.loadActive(id);
      await repo.completeSet(
        setId: active!.exercises.single.sets.first.id,
        reps: 9,
      );

      expect(await db.purgeEmptyUnfinishedWorkouts(), 0);

      final resumable = await repo.resumableWorkout();
      expect(resumable, isNotNull);
      expect(resumable!.id, id);
      expect(resumable.completedSets, 1);
    });

    test('a session resumed on a later day is credited to today', () async {
      final pushup = await exercise('pushup');
      final id = await repo.createWorkout(await repsDraft(ex: pushup));
      final active = await repo.loadActive(id);
      await repo.completeSet(
        setId: active!.exercises.single.sets.first.id,
        reps: 9,
      );

      // Pretend the session was started three days ago and left open.
      final threeDaysAgo = Day.today().addDays(-3);
      await db.updateWorkout(
        id,
        WorkoutsCompanion(dayKey: Value(threeDaysAgo.key)),
      );

      final resumed = await repo.resumableWorkout();
      expect(resumed!.day, Day.today());
    });
  });

  group('wipe', () {
    test('clears user data but keeps the catalogue', () async {
      final pushup = await exercise('pushup');
      await runSession(ex: pushup);

      await db.wipeUserData();

      expect(await db.completedWorkouts(), isEmpty);
      expect(await db.allActivity(), isEmpty);
      expect(await db.allRecords(), isEmpty);
      expect(await db.allBadges(), isEmpty);
      expect((await repo.computeStreak()).current, 0);
      expect((await db.getExercises()).length, greaterThanOrEqualTo(30));
    });
  });

  group('persistence across restarts', () {
    test('a file-backed database keeps its data when reopened', () async {
      final dir = await Directory.systemTemp.createTemp('exstreak_test');
      final file = File('${dir.path}/exstreak.sqlite');

      try {
        final first = AppDatabase.forTesting(NativeDatabase(file));
        final firstRepo = WorkoutRepository(first);
        await first.syncSeedExercises();

        final pushup = (await first.exerciseBySlug('pushup'))!;
        final id = await firstRepo.createWorkout(
          WorkoutDraft(
            source: WorkoutSource.custom,
            title: 'Persisted session',
            exercises: [
              PlannedExercise(
                exerciseId: pushup.id,
                name: pushup.name,
                trackingType: pushup.trackingType,
                sets: const [PlannedSet(target: 10)],
              ),
            ],
          ),
        );
        final active = await firstRepo.loadActive(id);
        await firstRepo.completeSet(
          setId: active!.exercises.single.sets.single.id,
          reps: 17,
        );
        await firstRepo.finishWorkout(workoutId: id);
        await first.close();

        // Cold start against the same file, as a real relaunch would.
        final second = AppDatabase.forTesting(NativeDatabase(file));
        final secondRepo = WorkoutRepository(second);

        final history = await second.completedWorkouts();
        expect(history, hasLength(1));
        expect(history.single.totalReps, 17);
        expect((await secondRepo.computeStreak()).current, 1);
        expect(
          (await second.record(pushup.id, PrMetric.bestSetReps))!.value,
          17,
        );
        await second.close();
      } finally {
        await dir.delete(recursive: true);
      }
    });
  });
}
