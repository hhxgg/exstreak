import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';

import '../core/day.dart';
import '../domain/enums.dart';
import 'seed/exercise_seed.dart';
import 'tables.dart';

part 'database.g.dart';

/// The app's local SQLite database.
///
/// Everything the product needs works from this database alone — there is no
/// network dependency anywhere in the core flows. The schema is relational
/// rather than blobs of JSON so statistics can be aggregated in SQL.
@DriftDatabase(
  tables: [
    Exercises,
    Workouts,
    WorkoutExercises,
    WorkoutSets,
    DailyActivities,
    PersonalRecords,
    Goals,
    PlanProgresses,
    Badges,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase([QueryExecutor? executor]) : super(executor ?? _openConnection());

  /// In-memory instance for tests.
  AppDatabase.forTesting(super.executor);

  static QueryExecutor _openConnection() => driftDatabase(name: 'exstreak_db');

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (m) async {
      await m.createAll();
      await syncSeedExercises();
    },
    onUpgrade: (m, from, to) async {
      // Future schema changes are handled here. The seed is re-synced on every
      // upgrade so new catalogue entries reach existing installs.
      await syncSeedExercises();
    },
    beforeOpen: (details) async {
      // Required for the ON DELETE clauses declared on the tables.
      await customStatement('PRAGMA foreign_keys = ON');
      if (details.wasCreated) return;
      // Guard against an install that somehow has an empty catalogue.
      final count =
          await (selectOnly(exercises)..addColumns([exercises.id.count()]))
              .map((r) => r.read(exercises.id.count()) ?? 0)
              .getSingle();
      if (count == 0) await syncSeedExercises();
    },
  );

  // ---------------------------------------------------------------- seeding

  /// Inserts new catalogue entries and refreshes the descriptive fields of
  /// existing ones, matched on [Exercises.slug].
  ///
  /// User-owned state — favourites, archived flags, custom exercises — is
  /// deliberately left untouched.
  Future<void> syncSeedExercises() async {
    await batch((b) {
      for (final seed in ExerciseSeeds.all) {
        b.insert(
          exercises,
          ExercisesCompanion.insert(
            slug: Value(seed.slug),
            name: seed.name,
            muscleGroup: seed.muscleGroup,
            equipment: seed.equipment,
            difficulty: seed.difficulty,
            trackingType: seed.trackingType,
            description: Value(seed.description),
            instructions: Value(seed.instructions.join('\n')),
            iconName: Value(seed.iconName),
            isBodyweight: Value(seed.isBodyweight),
            intensityFactor: Value(seed.intensityFactor),
            defaultRestSeconds: Value(seed.defaultRestSeconds),
            isFavourite: Value(
              ExerciseSeeds.starterFavourites.contains(seed.slug),
            ),
          ),
          onConflict: DoUpdate(
            (old) => ExercisesCompanion(
              name: Value(seed.name),
              muscleGroup: Value(seed.muscleGroup),
              equipment: Value(seed.equipment),
              difficulty: Value(seed.difficulty),
              trackingType: Value(seed.trackingType),
              description: Value(seed.description),
              instructions: Value(seed.instructions.join('\n')),
              iconName: Value(seed.iconName),
              isBodyweight: Value(seed.isBodyweight),
              intensityFactor: Value(seed.intensityFactor),
              defaultRestSeconds: Value(seed.defaultRestSeconds),
            ),
            target: [exercises.slug],
          ),
        );
      }
    });
  }

  // --------------------------------------------------------------- exercises

  Stream<List<ExerciseRow>> watchExercises({bool includeArchived = false}) {
    final q = select(exercises)
      ..orderBy([
        (t) => OrderingTerm(expression: t.isFavourite, mode: OrderingMode.desc),
        (t) => OrderingTerm(expression: t.name),
      ]);
    if (!includeArchived) {
      q.where((t) => t.isArchived.equals(false));
    }
    return q.watch();
  }

  Future<List<ExerciseRow>> getExercises({bool includeArchived = false}) {
    final q = select(exercises)
      ..orderBy([
        (t) => OrderingTerm(expression: t.isFavourite, mode: OrderingMode.desc),
        (t) => OrderingTerm(expression: t.name),
      ]);
    if (!includeArchived) {
      q.where((t) => t.isArchived.equals(false));
    }
    return q.get();
  }

  Future<ExerciseRow?> exerciseById(int id) =>
      (select(exercises)..where((t) => t.id.equals(id))).getSingleOrNull();

  Future<ExerciseRow?> exerciseBySlug(String slug) =>
      (select(exercises)..where((t) => t.slug.equals(slug))).getSingleOrNull();

  Future<int> insertExercise(ExercisesCompanion entry) =>
      into(exercises).insert(entry);

  Future<bool> updateExercise(ExerciseRow row) =>
      update(exercises).replace(row);

  Future<void> setExerciseFavourite(int id, bool favourite) =>
      (update(exercises)..where((t) => t.id.equals(id))).write(
        ExercisesCompanion(isFavourite: Value(favourite)),
      );

  /// Removes an exercise. Seeded exercises and any exercise referenced by a
  /// logged workout are archived instead of deleted, so history stays intact.
  Future<void> removeExercise(int id) async {
    final usage =
        await (selectOnly(workoutExercises)
              ..addColumns([workoutExercises.id.count()])
              ..where(workoutExercises.exerciseId.equals(id)))
            .map((r) => r.read(workoutExercises.id.count()) ?? 0)
            .getSingle();
    final row = await exerciseById(id);
    if (row == null) return;

    if (usage > 0 || row.slug != null) {
      await (update(exercises)..where((t) => t.id.equals(id))).write(
        const ExercisesCompanion(
          isArchived: Value(true),
          isFavourite: Value(false),
        ),
      );
    } else {
      await (delete(exercises)..where((t) => t.id.equals(id))).go();
    }
  }

  Future<void> restoreExercise(int id) =>
      (update(exercises)..where((t) => t.id.equals(id))).write(
        const ExercisesCompanion(isArchived: Value(false)),
      );

  // ---------------------------------------------------------------- workouts

  Future<int> insertWorkout(WorkoutsCompanion entry) =>
      into(workouts).insert(entry);

  Future<WorkoutRow?> workoutById(int id) =>
      (select(workouts)..where((t) => t.id.equals(id))).getSingleOrNull();

  Stream<List<WorkoutRow>> watchCompletedWorkouts({int limit = 200}) {
    return (select(workouts)
          ..where((t) => t.isCompleted.equals(true))
          ..orderBy([
            (t) =>
                OrderingTerm(expression: t.startedAt, mode: OrderingMode.desc),
          ])
          ..limit(limit))
        .watch();
  }

  Future<List<WorkoutRow>> completedWorkouts({int? limit}) {
    final q = select(workouts)
      ..where((t) => t.isCompleted.equals(true))
      ..orderBy([
        (t) => OrderingTerm(expression: t.startedAt, mode: OrderingMode.desc),
      ]);
    if (limit != null) q.limit(limit);
    return q.get();
  }

  Future<List<WorkoutRow>> completedWorkoutsBetween(DayRange range) {
    return (select(workouts)
          ..where(
            (t) =>
                t.isCompleted.equals(true) &
                t.dayKey.isBiggerOrEqualValue(range.start.key) &
                t.dayKey.isSmallerOrEqualValue(range.end.key),
          )
          ..orderBy([(t) => OrderingTerm(expression: t.startedAt)]))
        .get();
  }

  Future<List<WorkoutRow>> workoutsOnDay(Day day) =>
      (select(workouts)
            ..where(
              (t) => t.isCompleted.equals(true) & t.dayKey.equals(day.key),
            )
            ..orderBy([(t) => OrderingTerm(expression: t.startedAt)]))
          .get();

  /// Whether a saved workout actually contains logged effort.
  ///
  /// A session can be finished with every set skipped. It is real history, but
  /// it must not count as a training day — otherwise the streak would reward
  /// opening the app rather than doing the work.
  static bool hasLoggedWork(WorkoutRow w) =>
      w.totalReps > 0 || w.totalDurationSeconds > 0 || w.totalVolume > 0;

  /// Workouts on [day] that count toward streaks and daily totals.
  Future<List<WorkoutRow>> qualifyingWorkoutsOnDay(Day day) async =>
      (await workoutsOnDay(day)).where(hasLoggedWork).toList();

  /// The most recent session that was started but never finished.
  Future<WorkoutRow?> latestUnfinishedWorkout() =>
      (select(workouts)
            ..where((t) => t.isCompleted.equals(false))
            ..orderBy([
              (t) => OrderingTerm(
                expression: t.startedAt,
                mode: OrderingMode.desc,
              ),
            ])
            ..limit(1))
          .getSingleOrNull();

  Future<void> updateWorkout(int id, WorkoutsCompanion patch) =>
      (update(workouts)..where((t) => t.id.equals(id))).write(patch);

  Future<void> deleteWorkout(int id) async {
    await (delete(workouts)..where((t) => t.id.equals(id))).go();
  }

  /// Removes sessions that were started and abandoned without a single
  /// completed set, so stale sessions do not pile up or get offered for resume.
  ///
  /// The newest unfinished session is always spared. A session the user just
  /// started has no completed sets *by definition*, so without this guard the
  /// purge would delete the workout that is open on screen — emptying it out
  /// from under the UI mid-session. Only older empties are truly abandoned.
  Future<int> purgeEmptyUnfinishedWorkouts() async {
    final stale =
        await (select(workouts)
              ..where((t) => t.isCompleted.equals(false))
              // Same ordering as [latestUnfinishedWorkout], so the row spared
              // here is exactly the one that would be offered for resume.
              ..orderBy([
                (t) => OrderingTerm(
                  expression: t.startedAt,
                  mode: OrderingMode.desc,
                ),
                (t) => OrderingTerm(expression: t.id, mode: OrderingMode.desc),
              ]))
            .get();

    var removed = 0;
    for (final w in stale.skip(1)) {
      final done = await _completedSetCount(w.id);
      if (done == 0) {
        await deleteWorkout(w.id);
        removed++;
      }
    }
    return removed;
  }

  Future<int> _completedSetCount(int workoutId) async {
    final query =
        selectOnly(workoutSets).join([
            innerJoin(
              workoutExercises,
              workoutExercises.id.equalsExp(workoutSets.workoutExerciseId),
            ),
          ])
          ..addColumns([workoutSets.id.count()])
          ..where(
            workoutExercises.workoutId.equals(workoutId) &
                workoutSets.isCompleted.equals(true),
          );
    final row = await query.getSingle();
    return row.read(workoutSets.id.count()) ?? 0;
  }

  // ------------------------------------------------------- workout exercises

  Future<int> insertWorkoutExercise(WorkoutExercisesCompanion entry) =>
      into(workoutExercises).insert(entry);

  Future<List<WorkoutExerciseRow>> exercisesForWorkout(int workoutId) =>
      (select(workoutExercises)
            ..where((t) => t.workoutId.equals(workoutId))
            ..orderBy([(t) => OrderingTerm(expression: t.position)]))
          .get();

  Future<void> updateWorkoutExercise(int id, WorkoutExercisesCompanion patch) =>
      (update(workoutExercises)..where((t) => t.id.equals(id))).write(patch);

  // -------------------------------------------------------------------- sets

  Future<int> insertSet(WorkoutSetsCompanion entry) =>
      into(workoutSets).insert(entry);

  Future<void> updateSet(int id, WorkoutSetsCompanion patch) =>
      (update(workoutSets)..where((t) => t.id.equals(id))).write(patch);

  Future<void> deleteSet(int id) =>
      (delete(workoutSets)..where((t) => t.id.equals(id))).go();

  Future<List<SetRow>> setsForWorkoutExercise(int workoutExerciseId) =>
      (select(workoutSets)
            ..where((t) => t.workoutExerciseId.equals(workoutExerciseId))
            ..orderBy([(t) => OrderingTerm(expression: t.position)]))
          .get();

  /// Every completed set of one workout, paired with its parent exercise row.
  Future<List<(WorkoutExerciseRow, SetRow)>> setsForWorkout(
    int workoutId, {
    bool completedOnly = true,
  }) async {
    final query = select(workoutExercises).join([
      innerJoin(
        workoutSets,
        workoutSets.workoutExerciseId.equalsExp(workoutExercises.id),
      ),
    ])..where(workoutExercises.workoutId.equals(workoutId));
    if (completedOnly) {
      query.where(workoutSets.isCompleted.equals(true));
    }
    query.orderBy([
      OrderingTerm(expression: workoutExercises.position),
      OrderingTerm(expression: workoutSets.position),
    ]);

    final rows = await query.get();
    return [
      for (final r in rows)
        (r.readTable(workoutExercises), r.readTable(workoutSets)),
    ];
  }

  /// All completed sets for one exercise across all history, newest first.
  Future<List<(WorkoutRow, SetRow)>> setHistoryForExercise(
    int exerciseId, {
    int limit = 500,
  }) async {
    final query =
        select(workouts).join([
            innerJoin(
              workoutExercises,
              workoutExercises.workoutId.equalsExp(workouts.id),
            ),
            innerJoin(
              workoutSets,
              workoutSets.workoutExerciseId.equalsExp(workoutExercises.id),
            ),
          ])
          ..where(
            workoutExercises.exerciseId.equals(exerciseId) &
                workoutSets.isCompleted.equals(true) &
                workouts.isCompleted.equals(true),
          )
          ..orderBy([
            OrderingTerm(expression: workouts.dayKey, mode: OrderingMode.desc),
          ])
          ..limit(limit);

    final rows = await query.get();
    return [
      for (final r in rows) (r.readTable(workouts), r.readTable(workoutSets)),
    ];
  }

  /// Exercise ids that appear in at least one completed workout.
  Future<List<int>> exerciseIdsWithHistory() async {
    final query = selectOnly(workoutExercises, distinct: true)
      ..addColumns([workoutExercises.exerciseId])
      ..join([
        innerJoin(workouts, workouts.id.equalsExp(workoutExercises.workoutId)),
      ])
      ..where(workouts.isCompleted.equals(true));
    final rows = await query.get();
    return [for (final r in rows) r.read(workoutExercises.exerciseId)!];
  }

  // ------------------------------------------------------------- daily stats

  Future<List<DailyActivityRow>> allActivity() => (select(
    dailyActivities,
  )..orderBy([(t) => OrderingTerm(expression: t.dayKey)])).get();

  Stream<List<DailyActivityRow>> watchActivity() => (select(
    dailyActivities,
  )..orderBy([(t) => OrderingTerm(expression: t.dayKey)])).watch();

  Future<List<DailyActivityRow>> activityBetween(DayRange range) =>
      (select(dailyActivities)
            ..where(
              (t) =>
                  t.dayKey.isBiggerOrEqualValue(range.start.key) &
                  t.dayKey.isSmallerOrEqualValue(range.end.key),
            )
            ..orderBy([(t) => OrderingTerm(expression: t.dayKey)]))
          .get();

  Future<DailyActivityRow?> activityForDay(Day day) => (select(
    dailyActivities,
  )..where((t) => t.dayKey.equals(day.key))).getSingleOrNull();

  /// Rebuilds the [DailyActivities] row for [day] from its workouts.
  ///
  /// Recomputing rather than incrementing keeps the table correct even if a
  /// workout is later edited or deleted.
  Future<void> recomputeDailyActivity(Day day) async {
    final dayWorkouts = await qualifyingWorkoutsOnDay(day);
    final existing = await activityForDay(day);

    if (dayWorkouts.isEmpty) {
      if (existing != null && existing.isFreeze) {
        // Keep a freeze marker on a day with no workout.
        await (update(
          dailyActivities,
        )..where((t) => t.dayKey.equals(day.key))).write(
          const DailyActivitiesCompanion(
            workoutCount: Value(0),
            totalReps: Value(0),
            totalDurationSeconds: Value(0),
            totalVolume: Value(0),
          ),
        );
      } else {
        await (delete(
          dailyActivities,
        )..where((t) => t.dayKey.equals(day.key))).go();
      }
      return;
    }

    var reps = 0;
    var seconds = 0;
    var volume = 0.0;
    for (final w in dayWorkouts) {
      reps += w.totalReps;
      seconds += w.totalDurationSeconds;
      volume += w.totalVolume;
    }

    await into(dailyActivities).insertOnConflictUpdate(
      DailyActivitiesCompanion.insert(
        dayKey: Value(day.key),
        workoutCount: Value(dayWorkouts.length),
        totalReps: Value(reps),
        totalDurationSeconds: Value(seconds),
        totalVolume: Value(volume),
        isFreeze: Value(existing?.isFreeze ?? false),
      ),
    );
  }

  Future<void> markFreezeDay(Day day) async {
    final existing = await activityForDay(day);
    await into(dailyActivities).insertOnConflictUpdate(
      DailyActivitiesCompanion.insert(
        dayKey: Value(day.key),
        workoutCount: Value(existing?.workoutCount ?? 0),
        totalReps: Value(existing?.totalReps ?? 0),
        totalDurationSeconds: Value(existing?.totalDurationSeconds ?? 0),
        totalVolume: Value(existing?.totalVolume ?? 0),
        isFreeze: const Value(true),
      ),
    );
  }

  // --------------------------------------------------------- personal records

  Future<List<PersonalRecordRow>> allRecords() => select(personalRecords).get();

  Stream<List<PersonalRecordRow>> watchRecords() =>
      select(personalRecords).watch();

  Future<List<PersonalRecordRow>> recordsForExercise(int exerciseId) => (select(
    personalRecords,
  )..where((t) => t.exerciseId.equals(exerciseId))).get();

  Future<PersonalRecordRow?> record(int exerciseId, String metric) =>
      (select(personalRecords)..where(
            (t) => t.exerciseId.equals(exerciseId) & t.metric.equals(metric),
          ))
          .getSingleOrNull();

  /// Writes a record only if [value] beats the stored one. Returns true when a
  /// new record was set.
  Future<bool> upsertRecordIfBetter({
    required int exerciseId,
    required String metric,
    required double value,
    required Day day,
    double secondaryValue = 0,
    int? workoutId,
  }) async {
    if (value <= 0) return false;
    final existing = await record(exerciseId, metric);
    if (existing != null && existing.value >= value) return false;

    // The (exerciseId, metric) uniqueness is a secondary key, not the primary
    // key, so an upsert would target the wrong column — branch explicitly.
    if (existing == null) {
      await into(personalRecords).insert(
        PersonalRecordsCompanion.insert(
          exerciseId: exerciseId,
          metric: metric,
          value: value,
          secondaryValue: Value(secondaryValue),
          dayKey: day.key,
          workoutId: Value(workoutId),
          achievedAt: DateTime.now(),
        ),
      );
    } else {
      await (update(
        personalRecords,
      )..where((t) => t.id.equals(existing.id))).write(
        PersonalRecordsCompanion(
          value: Value(value),
          secondaryValue: Value(secondaryValue),
          dayKey: Value(day.key),
          workoutId: Value(workoutId),
          achievedAt: Value(DateTime.now()),
        ),
      );
    }
    return true;
  }

  // ------------------------------------------------------------------- goals

  Future<int> insertGoal(GoalsCompanion entry) => into(goals).insert(entry);

  Stream<List<GoalRow>> watchGoals({bool includeArchived = false}) {
    final q = select(goals)
      ..orderBy([
        (t) => OrderingTerm(expression: t.isCompleted),
        (t) => OrderingTerm(expression: t.createdAt, mode: OrderingMode.desc),
      ]);
    if (!includeArchived) q.where((t) => t.isArchived.equals(false));
    return q.watch();
  }

  Future<List<GoalRow>> getGoals({bool includeArchived = false}) {
    final q = select(goals)
      ..orderBy([
        (t) => OrderingTerm(expression: t.isCompleted),
        (t) => OrderingTerm(expression: t.createdAt, mode: OrderingMode.desc),
      ]);
    if (!includeArchived) q.where((t) => t.isArchived.equals(false));
    return q.get();
  }

  Future<GoalRow?> goalById(int id) =>
      (select(goals)..where((t) => t.id.equals(id))).getSingleOrNull();

  Future<void> updateGoal(int id, GoalsCompanion patch) =>
      (update(goals)..where((t) => t.id.equals(id))).write(patch);

  Future<void> deleteGoal(int id) =>
      (delete(goals)..where((t) => t.id.equals(id))).go();

  // ------------------------------------------------------------ plan progress

  Future<PlanProgressRow?> planProgress(String planId) => (select(
    planProgresses,
  )..where((t) => t.planId.equals(planId))).getSingleOrNull();

  Stream<List<PlanProgressRow>> watchPlanProgress() =>
      select(planProgresses).watch();

  Future<void> savePlanProgress(PlanProgressesCompanion entry) =>
      into(planProgresses).insertOnConflictUpdate(entry);

  // ------------------------------------------------------------------ badges

  Stream<List<BadgeRow>> watchBadges() => select(badges).watch();

  Future<List<BadgeRow>> allBadges() => select(badges).get();

  Future<bool> awardBadge(String code, Day day) async {
    final existing = await (select(
      badges,
    )..where((t) => t.code.equals(code))).getSingleOrNull();
    if (existing != null) return false;
    await into(badges).insert(
      BadgesCompanion.insert(
        code: code,
        earnedDayKey: day.key,
        earnedAt: DateTime.now(),
      ),
    );
    return true;
  }

  // ------------------------------------------------------------ maintenance

  /// Wipes all user-generated data but keeps the seeded catalogue.
  Future<void> wipeUserData() async {
    await transaction(() async {
      await delete(workoutSets).go();
      await delete(workoutExercises).go();
      await delete(workouts).go();
      await delete(dailyActivities).go();
      await delete(personalRecords).go();
      await delete(goals).go();
      await delete(planProgresses).go();
      await delete(badges).go();
      await (delete(exercises)..where((t) => t.isCustom.equals(true))).go();
      await (update(
        exercises,
      )).write(const ExercisesCompanion(isArchived: Value(false)));
    });
    await syncSeedExercises();
  }
}
