import 'package:drift/drift.dart';

import '../domain/enums.dart';

/// The exercise catalogue. Ships seeded with a built-in library and can be
/// extended by the user at runtime.
@DataClassName('ExerciseRow')
class Exercises extends Table {
  IntColumn get id => integer().autoIncrement()();

  /// Stable identifier for seeded exercises (`pushup`, `plank`, …) so the seed
  /// can be upgraded across app versions without duplicating rows. Null for
  /// user-created exercises.
  TextColumn get slug => text().nullable().unique()();

  TextColumn get name => text().withLength(min: 1, max: 60)();
  TextColumn get muscleGroup => textEnum<MuscleGroup>()();
  TextColumn get equipment => textEnum<Equipment>()();
  TextColumn get difficulty => textEnum<Difficulty>()();
  TextColumn get trackingType => textEnum<TrackingType>()();

  TextColumn get description => text().withDefault(const Constant(''))();

  /// Newline-separated coaching cues.
  TextColumn get instructions => text().withDefault(const Constant(''))();

  /// Key into `ExerciseIcons.registry`. Stored as a name rather than a raw
  /// codepoint so Flutter can still tree-shake the icon font in release builds.
  TextColumn get iconName => text().withDefault(const Constant('dumbbell'))();

  BoolColumn get isBodyweight => boolean().withDefault(const Constant(true))();

  /// Approximate MET-style factor, used to weight "volume" across exercises
  /// so that 10 pull-ups do not read as equal effort to 10 crunches.
  RealColumn get intensityFactor => real().withDefault(const Constant(1.0))();

  /// Default rest between sets, in seconds.
  IntColumn get defaultRestSeconds =>
      integer().withDefault(const Constant(90))();

  BoolColumn get isCustom => boolean().withDefault(const Constant(false))();
  BoolColumn get isFavourite => boolean().withDefault(const Constant(false))();

  /// Soft delete: keeps historical workouts intact when a user removes an
  /// exercise from their library.
  BoolColumn get isArchived => boolean().withDefault(const Constant(false))();

  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
}

/// One training session.
@DataClassName('WorkoutRow')
class Workouts extends Table {
  IntColumn get id => integer().autoIncrement()();

  /// Calendar day the workout is credited to, as `yyyyMMdd`. Denormalised from
  /// [startedAt] at insert time so streak queries never re-derive local dates.
  IntColumn get dayKey => integer()();

  DateTimeColumn get startedAt => dateTime()();
  DateTimeColumn get completedAt => dateTime().nullable()();

  TextColumn get source => textEnum<WorkoutSource>()();
  TextColumn get title => text().withDefault(const Constant(''))();

  /// Plan identity, when [source] is [WorkoutSource.plan].
  TextColumn get planId => text().nullable()();
  IntColumn get planLevel => integer().nullable()();
  IntColumn get planDay => integer().nullable()();

  TextColumn get feedback => textEnum<SessionFeedback>().nullable()();
  TextColumn get notes => text().withDefault(const Constant(''))();

  /// True once the session has been finished and committed to history.
  BoolColumn get isCompleted => boolean().withDefault(const Constant(false))();

  /// Cached rollups so history and stats lists do not need to join sets.
  IntColumn get totalReps => integer().withDefault(const Constant(0))();
  IntColumn get totalDurationSeconds =>
      integer().withDefault(const Constant(0))();
  RealColumn get totalVolume => real().withDefault(const Constant(0))();
  IntColumn get durationSeconds => integer().withDefault(const Constant(0))();

  @override
  List<Set<Column>> get uniqueKeys => [];
}

/// An exercise as it appears inside one workout, with its ordering.
@DataClassName('WorkoutExerciseRow')
class WorkoutExercises extends Table {
  IntColumn get id => integer().autoIncrement()();

  IntColumn get workoutId =>
      integer().references(Workouts, #id, onDelete: KeyAction.cascade)();

  /// Restricted rather than cascaded: deleting an exercise must not silently
  /// erase the history that references it. The repository archives instead.
  IntColumn get exerciseId =>
      integer().references(Exercises, #id, onDelete: KeyAction.restrict)();

  IntColumn get position => integer()();

  /// Snapshot of the name at the time of the workout, so renaming an exercise
  /// later does not rewrite history.
  TextColumn get exerciseName => text()();
  TextColumn get trackingType => textEnum<TrackingType>()();

  BoolColumn get isSkipped => boolean().withDefault(const Constant(false))();

  @override
  List<Set<Column>> get uniqueKeys => [
    {workoutId, position},
  ];
}

/// A single logged set.
@DataClassName('SetRow')
class WorkoutSets extends Table {
  IntColumn get id => integer().autoIncrement()();

  IntColumn get workoutExerciseId => integer().references(
    WorkoutExercises,
    #id,
    onDelete: KeyAction.cascade,
  )();

  IntColumn get position => integer()();

  /// What the plan asked for, in the exercise's target unit.
  IntColumn get targetValue => integer().nullable()();

  /// What the user actually did.
  IntColumn get reps => integer().withDefault(const Constant(0))();
  RealColumn get weightKg => real().withDefault(const Constant(0))();
  IntColumn get durationSeconds => integer().withDefault(const Constant(0))();
  RealColumn get distanceMeters => real().withDefault(const Constant(0))();

  IntColumn get restSeconds => integer().withDefault(const Constant(0))();

  BoolColumn get isCompleted => boolean().withDefault(const Constant(false))();

  DateTimeColumn get completedAt => dateTime().nullable()();
}

/// One row per calendar day on which the user trained.
///
/// Derived from [Workouts], but materialised so the streak engine and the
/// calendar can read a compact table instead of scanning every session.
@DataClassName('DailyActivityRow')
class DailyActivities extends Table {
  /// `yyyyMMdd`.
  IntColumn get dayKey => integer()();

  IntColumn get workoutCount => integer().withDefault(const Constant(0))();
  IntColumn get totalReps => integer().withDefault(const Constant(0))();
  IntColumn get totalDurationSeconds =>
      integer().withDefault(const Constant(0))();
  RealColumn get totalVolume => real().withDefault(const Constant(0))();

  /// True when the day was covered by a streak freeze rather than a workout.
  BoolColumn get isFreeze => boolean().withDefault(const Constant(false))();

  @override
  Set<Column> get primaryKey => {dayKey};
}

/// Best-ever result per exercise and metric.
@DataClassName('PersonalRecordRow')
class PersonalRecords extends Table {
  IntColumn get id => integer().autoIncrement()();

  IntColumn get exerciseId =>
      integer().references(Exercises, #id, onDelete: KeyAction.cascade)();

  /// `bestSetReps` | `bestSetWeight` | `bestSetDuration` | `bestDayVolume`
  TextColumn get metric => text()();

  RealColumn get value => real()();

  /// Secondary figure for context, e.g. the weight at which a rep PR was set.
  RealColumn get secondaryValue => real().withDefault(const Constant(0))();

  IntColumn get dayKey => integer()();
  IntColumn get workoutId => integer().nullable()();
  DateTimeColumn get achievedAt => dateTime()();

  @override
  List<Set<Column>> get uniqueKeys => [
    {exerciseId, metric},
  ];
}

/// A user-defined target.
@DataClassName('GoalRow')
class Goals extends Table {
  IntColumn get id => integer().autoIncrement()();

  TextColumn get title => text().withLength(min: 1, max: 80)();
  TextColumn get type => textEnum<GoalType>()();

  IntColumn get exerciseId => integer().nullable().references(
    Exercises,
    #id,
    onDelete: KeyAction.cascade,
  )();

  RealColumn get targetValue => real()();

  /// Snapshot of progress at completion time; live goals recompute on read.
  RealColumn get achievedValue => real().withDefault(const Constant(0))();

  IntColumn get startDayKey => integer()();
  IntColumn get deadlineDayKey => integer().nullable()();

  BoolColumn get isCompleted => boolean().withDefault(const Constant(false))();
  IntColumn get completedDayKey => integer().nullable()();

  BoolColumn get isArchived => boolean().withDefault(const Constant(false))();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
}

/// Progress through a structured plan, one row per plan the user has started.
@DataClassName('PlanProgressRow')
class PlanProgresses extends Table {
  TextColumn get planId => text()();

  IntColumn get level => integer().withDefault(const Constant(1))();
  IntColumn get currentDay => integer().withDefault(const Constant(1))();

  IntColumn get lastCompletedDayKey => integer().nullable()();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {planId};
}

/// Earned achievement badges.
@DataClassName('BadgeRow')
class Badges extends Table {
  TextColumn get code => text()();
  IntColumn get earnedDayKey => integer()();
  DateTimeColumn get earnedAt => dateTime()();

  @override
  Set<Column> get primaryKey => {code};
}
