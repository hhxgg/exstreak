import 'dart:math' as math;

import 'package:drift/drift.dart';

import '../../core/day.dart';
import '../../domain/badges/badge_catalog.dart';
import '../../domain/enums.dart';
import '../../domain/streak/streak_engine.dart';
import '../../domain/workout/workout_models.dart';
import '../database.dart';

/// Metric keys used in the [PersonalRecords] table.
abstract final class PrMetric {
  static const String bestSetReps = 'bestSetReps';
  static const String bestSetWeight = 'bestSetWeight';
  static const String bestSetDuration = 'bestSetDuration';
  static const String bestDayVolume = 'bestDayVolume';
}

/// Creates, mutates and finalises workouts.
///
/// Every mutation writes straight through to SQLite rather than being buffered
/// in memory, so a session survives the app being killed mid-set.
class WorkoutRepository {
  WorkoutRepository(this._db);

  final AppDatabase _db;

  // ------------------------------------------------------------ create

  /// Persists a [WorkoutDraft] and returns the new workout id.
  Future<int> createWorkout(WorkoutDraft draft) async {
    final now = DateTime.now();
    final day = Day.fromDateTime(now);

    return _db.transaction(() async {
      final workoutId = await _db.insertWorkout(
        WorkoutsCompanion.insert(
          dayKey: day.key,
          startedAt: now,
          source: draft.source,
          title: Value(draft.title),
          planId: Value(draft.planId),
          planLevel: Value(draft.planLevel),
          planDay: Value(draft.planDay),
        ),
      );

      for (var i = 0; i < draft.exercises.length; i++) {
        final ex = draft.exercises[i];
        final weId = await _db.insertWorkoutExercise(
          WorkoutExercisesCompanion.insert(
            workoutId: workoutId,
            exerciseId: ex.exerciseId,
            position: i,
            exerciseName: ex.name,
            trackingType: ex.trackingType,
          ),
        );

        for (var s = 0; s < ex.sets.length; s++) {
          await _db.insertSet(
            WorkoutSetsCompanion.insert(
              workoutExerciseId: weId,
              position: s,
              targetValue: Value(ex.sets[s].target),
              weightKg: Value(ex.sets[s].weightKg),
              restSeconds: Value(ex.restSeconds),
            ),
          );
        }
      }
      return workoutId;
    });
  }

  // ------------------------------------------------------------ read

  /// Hydrates a workout into the shape the session UI consumes.
  Future<ActiveWorkout?> loadActive(int workoutId) async {
    final workout = await _db.workoutById(workoutId);
    if (workout == null) return null;

    final weRows = await _db.exercisesForWorkout(workoutId);
    final catalogue = {
      for (final e in await _db.getExercises(includeArchived: true)) e.id: e,
    };

    final live = <LiveExercise>[];
    for (final we in weRows) {
      final sets = await _db.setsForWorkoutExercise(we.id);
      final catalogueEntry = catalogue[we.exerciseId];
      live.add(
        LiveExercise(
          id: we.id,
          exerciseId: we.exerciseId,
          name: we.exerciseName,
          trackingType: we.trackingType,
          position: we.position,
          sets: [for (final s in sets) LiveSet.fromRow(s)],
          isSkipped: we.isSkipped,
          restSeconds: catalogueEntry?.defaultRestSeconds ?? 90,
          iconName: catalogueEntry?.iconName ?? 'dumbbell',
        ),
      );
    }

    return ActiveWorkout(
      id: workout.id,
      source: workout.source,
      title: workout.title,
      startedAt: workout.startedAt,
      day: Day.fromEpochKey(workout.dayKey),
      exercises: live,
      planId: workout.planId,
      planLevel: workout.planLevel,
      planDay: workout.planDay,
    );
  }

  /// Returns an unfinished session worth resuming, re-dating it to today if it
  /// was started on a previous day.
  Future<ActiveWorkout?> resumableWorkout() async {
    await _db.purgeEmptyUnfinishedWorkouts();
    final row = await _db.latestUnfinishedWorkout();
    if (row == null) return null;

    final today = Day.today();
    if (row.dayKey != today.key) {
      // Credit a resumed session to the day it is actually finished on,
      // otherwise a session abandoned last night would award a past day.
      await _db.updateWorkout(
        row.id,
        WorkoutsCompanion(
          dayKey: Value(today.key),
          startedAt: Value(DateTime.now()),
        ),
      );
    }
    return loadActive(row.id);
  }

  // ------------------------------------------------------------ mutate

  /// Records a completed set. Values not relevant to the tracking type are
  /// ignored by the callers, but stored as zero rather than null for simpler
  /// aggregation in SQL.
  Future<void> completeSet({
    required int setId,
    int reps = 0,
    double weightKg = 0,
    int durationSeconds = 0,
    double distanceMeters = 0,
  }) {
    return _db.updateSet(
      setId,
      WorkoutSetsCompanion(
        reps: Value(math.max(0, reps)),
        weightKg: Value(math.max(0, weightKg)),
        durationSeconds: Value(math.max(0, durationSeconds)),
        distanceMeters: Value(math.max(0, distanceMeters)),
        isCompleted: const Value(true),
        completedAt: Value(DateTime.now()),
      ),
    );
  }

  /// Reverts a set to "not done" so a mis-tap can be corrected.
  Future<void> uncompleteSet(int setId) {
    return _db.updateSet(
      setId,
      const WorkoutSetsCompanion(
        isCompleted: Value(false),
        completedAt: Value(null),
        reps: Value(0),
        durationSeconds: Value(0),
        distanceMeters: Value(0),
      ),
    );
  }

  /// Appends an extra set to an exercise mid-session.
  Future<void> addSet(
    int workoutExerciseId, {
    int? target,
    double weightKg = 0,
  }) async {
    final existing = await _db.setsForWorkoutExercise(workoutExerciseId);
    await _db.insertSet(
      WorkoutSetsCompanion.insert(
        workoutExerciseId: workoutExerciseId,
        position: existing.length,
        targetValue: Value(target),
        weightKg: Value(weightKg),
        restSeconds: Value(existing.isEmpty ? 90 : existing.last.restSeconds),
      ),
    );
  }

  Future<void> skipExercise(int workoutExerciseId, {bool skipped = true}) =>
      _db.updateWorkoutExercise(
        workoutExerciseId,
        WorkoutExercisesCompanion(isSkipped: Value(skipped)),
      );

  /// Discards an in-progress session entirely.
  Future<void> cancelWorkout(int workoutId) => _db.deleteWorkout(workoutId);

  // ------------------------------------------------------------ finish

  /// Finalises a workout: rolls up totals, updates records, activity, plan
  /// progress, goals and badges, then reports what changed.
  Future<WorkoutResult> finishWorkout({
    required int workoutId,
    SessionFeedback? feedback,
    String notes = '',
  }) async {
    final workout = await _db.workoutById(workoutId);
    if (workout == null) {
      throw StateError('Workout $workoutId no longer exists');
    }

    final day = Day.fromEpochKey(workout.dayKey);
    final streakBefore = (await computeStreak()).current;
    // Only sessions with real work count, so an earlier abandoned session
    // does not make this one look like a bonus.
    final priorWorkoutsToday = (await _db.qualifyingWorkoutsOnDay(day)).length;

    final pairs = await _db.setsForWorkout(workoutId);
    final catalogue = {
      for (final e in await _db.getExercises(includeArchived: true)) e.id: e,
    };

    var totalReps = 0;
    var totalSeconds = 0;
    var totalVolume = 0.0;

    // exerciseId -> best values in this session
    final bestReps = <int, int>{};
    final bestWeight = <int, double>{};
    final bestDuration = <int, int>{};

    for (final (we, set) in pairs) {
      final type = we.trackingType;
      if (type.tracksReps) {
        totalReps += set.reps;
        bestReps[we.exerciseId] = math.max(
          bestReps[we.exerciseId] ?? 0,
          set.reps,
        );
      }
      if (type.tracksDuration) {
        totalSeconds += set.durationSeconds;
        bestDuration[we.exerciseId] = math.max(
          bestDuration[we.exerciseId] ?? 0,
          set.durationSeconds,
        );
      }
      if (type.tracksWeight && set.weightKg > 0) {
        bestWeight[we.exerciseId] = math.max(
          bestWeight[we.exerciseId] ?? 0,
          set.weightKg,
        );
      }

      final factor = catalogue[we.exerciseId]?.intensityFactor ?? 1.0;
      totalVolume += switch (type) {
        TrackingType.repsWeight =>
          set.reps * math.max(set.weightKg, 1) * factor,
        TrackingType.reps => set.reps * factor,
        TrackingType.duration => (set.durationSeconds / 3.0) * factor,
        TrackingType.distanceDuration => (set.distanceMeters / 10.0) * factor,
      };
    }

    final elapsed = DateTime.now().difference(workout.startedAt).inSeconds;

    await _db.updateWorkout(
      workoutId,
      WorkoutsCompanion(
        isCompleted: const Value(true),
        completedAt: Value(DateTime.now()),
        feedback: Value(feedback),
        notes: Value(notes),
        totalReps: Value(totalReps),
        totalDurationSeconds: Value(totalSeconds),
        totalVolume: Value(totalVolume),
        // Guard against a device clock that moved backwards mid-session.
        durationSeconds: Value(elapsed.clamp(0, 24 * 3600)),
      ),
    );

    await _db.recomputeDailyActivity(day);

    // --- records ---------------------------------------------------------
    final newRecords = <String>[];
    for (final entry in bestReps.entries) {
      final isNew = await _db.upsertRecordIfBetter(
        exerciseId: entry.key,
        metric: PrMetric.bestSetReps,
        value: entry.value.toDouble(),
        day: day,
        workoutId: workoutId,
      );
      if (isNew) {
        newRecords.add(
          '${catalogue[entry.key]?.name ?? 'Exercise'} · ${entry.value} reps',
        );
      }
    }
    for (final entry in bestDuration.entries) {
      final isNew = await _db.upsertRecordIfBetter(
        exerciseId: entry.key,
        metric: PrMetric.bestSetDuration,
        value: entry.value.toDouble(),
        day: day,
        workoutId: workoutId,
      );
      if (isNew) {
        newRecords.add(
          '${catalogue[entry.key]?.name ?? 'Exercise'} · '
          '${_formatSeconds(entry.value)}',
        );
      }
    }
    for (final entry in bestWeight.entries) {
      final isNew = await _db.upsertRecordIfBetter(
        exerciseId: entry.key,
        metric: PrMetric.bestSetWeight,
        value: entry.value,
        day: day,
        workoutId: workoutId,
      );
      if (isNew) {
        newRecords.add(
          '${catalogue[entry.key]?.name ?? 'Exercise'} · '
          '${entry.value.toStringAsFixed(1)} kg',
        );
      }
    }

    // --- plan progress ---------------------------------------------------
    if (workout.source == WorkoutSource.plan &&
        workout.planId != null &&
        feedback != null) {
      await advancePlan(
        planId: workout.planId!,
        currentLevel: workout.planLevel ?? 1,
        currentDay: workout.planDay ?? 1,
        feedback: feedback,
        day: day,
      );
    }

    // --- streak, goals, badges -------------------------------------------
    final streakAfter = await computeStreak();
    final completedGoals = await refreshGoals();
    final newBadges = await evaluateBadges(
      streak: streakAfter.current,
      day: day,
      finishedAt: DateTime.now(),
    );

    return WorkoutResult(
      workoutId: workoutId,
      day: day,
      totalReps: totalReps,
      totalDurationSeconds: totalSeconds,
      newRecords: newRecords,
      newBadges: newBadges,
      completedGoalIds: completedGoals,
      streakBefore: streakBefore,
      streakAfter: streakAfter.current,
      isFirstWorkoutOfDay: priorWorkoutsToday == 0,
    );
  }

  // ------------------------------------------------------------ plan

  Future<void> advancePlan({
    required String planId,
    required int currentLevel,
    required int currentDay,
    required SessionFeedback feedback,
    required Day day,
    int daysPerLevel = 16,
    int levelCount = 3,
  }) async {
    var level = currentLevel;
    var next = currentDay + feedback.dayAdvance;

    if (feedback == SessionFeedback.tooEasy && level < levelCount) {
      // "Too easy" jumps a level rather than sprinting through the days.
      level += 1;
      next = math.max(1, currentDay);
    }

    while (next > daysPerLevel) {
      if (level < levelCount) {
        level += 1;
        next -= daysPerLevel;
      } else {
        // Top of the final level: hold there rather than wrapping around.
        next = daysPerLevel;
        break;
      }
    }

    await _db.savePlanProgress(
      PlanProgressesCompanion.insert(
        planId: planId,
        level: Value(level.clamp(1, levelCount)),
        currentDay: Value(next.clamp(1, daysPerLevel)),
        lastCompletedDayKey: Value(day.key),
        updatedAt: Value(DateTime.now()),
      ),
    );
  }

  // ------------------------------------------------------------ streak

  Future<StreakSummary> computeStreak({Day? today}) async {
    final rows = await _db.allActivity();
    final active = <Day>{};
    final freezes = <Day>{};
    for (final r in rows) {
      final d = Day.fromEpochKey(r.dayKey);
      if (r.workoutCount > 0) {
        active.add(d);
      } else if (r.isFreeze) {
        freezes.add(d);
      }
    }
    return StreakEngine.compute(
      activeDays: active,
      freezeDays: freezes,
      today: today,
    );
  }

  /// Spends up to [available] freeze tokens on the days missed since the last
  /// qualifying day, oldest first. Returns how many were spent.
  ///
  /// Called on app resume, so a user who missed a day while the app was closed
  /// still has their streak protected.
  Future<int> applyFreezes({required int available, Day? today}) async {
    if (available <= 0) return 0;
    final now = today ?? Day.today();

    final rows = await _db.allActivity();
    final qualifying = <Day>{
      for (final r in rows)
        if (r.workoutCount > 0 || r.isFreeze) Day.fromEpochKey(r.dayKey),
    };
    if (qualifying.isEmpty) return 0;

    final missed = StreakEngine.missedDaysSince(
      qualifyingDays: qualifying,
      today: now,
    );
    if (missed.isEmpty) return 0;

    // Only bridge a gap the tokens can fully cover. Half-covering a three-day
    // gap would burn tokens and still break the streak.
    if (missed.length > available) return 0;

    for (final d in missed) {
      await _db.markFreezeDay(d);
    }
    return missed.length;
  }

  // ------------------------------------------------------------ goals

  /// Recomputes progress for every open goal and marks the finished ones.
  /// Returns the ids completed by this call.
  Future<List<int>> refreshGoals({Day? today}) async {
    final now = today ?? Day.today();
    final open = await _db.getGoals();
    if (open.isEmpty) return const [];

    final streak = await computeStreak(today: now);
    final activity = await _db.allActivity();
    final justCompleted = <int>[];

    for (final goal in open) {
      if (goal.isCompleted) continue;

      final start = Day.fromEpochKey(goal.startDayKey);
      final value = await _goalProgress(goal, start, now, streak, activity);

      final done = value >= goal.targetValue;
      await _db.updateGoal(
        goal.id,
        GoalsCompanion(
          achievedValue: Value(value),
          isCompleted: Value(done),
          completedDayKey: done ? Value(now.key) : const Value.absent(),
        ),
      );
      if (done) justCompleted.add(goal.id);
    }
    return justCompleted;
  }

  Future<double> _goalProgress(
    GoalRow goal,
    Day start,
    Day now,
    StreakSummary streak,
    List<DailyActivityRow> activity,
  ) async {
    switch (goal.type) {
      case GoalType.streakDays:
        return streak.current.toDouble();

      case GoalType.workoutCount:
        return activity
            .where((a) => a.dayKey >= start.key && a.dayKey <= now.key)
            .fold<int>(0, (a, r) => a + r.workoutCount)
            .toDouble();

      case GoalType.weeklyFrequency:
        final weekStart = now.startOfWeek;
        return activity
            .where((a) => a.dayKey >= weekStart.key && a.dayKey <= now.key)
            .where((a) => a.workoutCount > 0)
            .length
            .toDouble();

      case GoalType.singleSetRecord:
        final exId = goal.exerciseId;
        if (exId == null) return 0;
        final ex = await _db.exerciseById(exId);
        final metric = ex != null && ex.trackingType.tracksDuration
            ? PrMetric.bestSetDuration
            : PrMetric.bestSetReps;
        final pr = await _db.record(exId, metric);
        return pr?.value ?? 0;

      case GoalType.totalVolume:
        final exId = goal.exerciseId;
        if (exId == null) return 0;
        final history = await _db.setHistoryForExercise(exId, limit: 100000);
        final ex = await _db.exerciseById(exId);
        final isDuration = ex?.trackingType.tracksDuration ?? false;
        return history
            .where((p) => p.$1.dayKey >= start.key)
            .fold<double>(
              0,
              (a, p) =>
                  a +
                  (isDuration ? p.$2.durationSeconds : p.$2.reps).toDouble(),
            );
    }
  }

  // ------------------------------------------------------------ badges

  /// Awards any badge whose condition is now met. Returns the new codes.
  Future<List<String>> evaluateBadges({
    required int streak,
    required Day day,
    required DateTime finishedAt,
  }) async {
    final earned = {for (final b in await _db.allBadges()) b.code};
    final awarded = <String>[];

    final activity = await _db.allActivity();
    final totalReps = activity.fold<int>(0, (a, r) => a + r.totalReps);
    final totalWorkouts = activity.fold<int>(0, (a, r) => a + r.workoutCount);

    final records = await _db.allRecords();
    final catalogue = {
      for (final e in await _db.getExercises(includeArchived: true)) e.id: e,
    };

    var bestSetReps = 0.0;
    var bestPlankSeconds = 0.0;
    for (final r in records) {
      if (r.metric == PrMetric.bestSetReps) {
        bestSetReps = math.max(bestSetReps, r.value);
      }
      if (r.metric == PrMetric.bestSetDuration) {
        final slug = catalogue[r.exerciseId]?.slug ?? '';
        if (slug.contains('plank')) {
          bestPlankSeconds = math.max(bestPlankSeconds, r.value);
        }
      }
    }

    for (final def in BadgeCatalog.all) {
      if (earned.contains(def.code)) continue;

      final met = switch (def.category) {
        BadgeCategory.streak => streak >= def.threshold,
        BadgeCategory.maxRep => bestSetReps >= def.threshold,
        BadgeCategory.plank => bestPlankSeconds >= def.threshold,
        BadgeCategory.volume =>
          def.code == 'workouts_50'
              ? totalWorkouts >= def.threshold
              : totalReps >= def.threshold,
        BadgeCategory.special => switch (def.code) {
          'early_bird' => finishedAt.hour < def.threshold,
          'night_owl' => finishedAt.hour >= def.threshold,
          _ => false,
        },
      };

      if (met && await _db.awardBadge(def.code, day)) {
        awarded.add(def.code);
      }
    }
    return awarded;
  }

  static String _formatSeconds(int seconds) {
    final m = seconds ~/ 60;
    final s = seconds % 60;
    return m > 0 ? '$m:${s.toString().padLeft(2, '0')}' : '${s}s';
  }
}
