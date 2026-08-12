import '../../core/day.dart';
import '../../domain/enums.dart';
import '../../domain/stats/stats_engine.dart';
import '../database.dart';
import 'workout_repository.dart';

/// Everything the Progress tab needs for one exercise.
class ExerciseProgress {
  const ExerciseProgress({
    required this.exercise,
    required this.totals,
    required this.dailyActivity,
    required this.bestSetSeries,
    required this.topWeightSeries,
    required this.estimatedOneRepMax,
    required this.recordReps,
    required this.recordDuration,
    required this.recordWeight,
  });

  final ExerciseRow exercise;
  final TotalsSummary totals;
  final List<ActivityPoint> dailyActivity;
  final List<SeriesPoint> bestSetSeries;
  final List<SeriesPoint> topWeightSeries;
  final List<SeriesPoint> estimatedOneRepMax;

  final double recordReps;
  final double recordDuration;
  final double recordWeight;

  bool get hasHistory => dailyActivity.isNotEmpty;
}

/// A completed workout with enough joined detail to render a history row.
class WorkoutSummary {
  const WorkoutSummary({
    required this.workout,
    required this.exerciseNames,
    required this.setCount,
  });

  final WorkoutRow workout;
  final List<String> exerciseNames;
  final int setCount;

  Day get day => Day.fromEpochKey(workout.dayKey);

  String get subtitle =>
      exerciseNames.isEmpty ? workout.source.label : exerciseNames.join(' · ');
}

/// Reads aggregated statistics out of the database.
class StatsRepository {
  StatsRepository(this._db);

  final AppDatabase _db;

  /// Whole-app activity, densified over [window] so rest days render as gaps.
  Future<List<ActivityPoint>> activityWindow(StatsWindow window) async {
    final range = DayRange.lastDays(window.days);
    final rows = await _db.activityBetween(range);
    final points = [
      for (final r in rows)
        ActivityPoint(
          day: Day.fromEpochKey(r.dayKey),
          workoutCount: r.workoutCount,
          reps: r.totalReps,
          durationSeconds: r.totalDurationSeconds,
          volume: r.totalVolume,
          isFreeze: r.isFreeze,
        ),
    ];
    return StatsEngine.densify(points, range);
  }

  /// Every recorded day, for the streak calendar and lifetime totals.
  Future<List<ActivityPoint>> allActivity() async {
    final rows = await _db.allActivity();
    return [
      for (final r in rows)
        ActivityPoint(
          day: Day.fromEpochKey(r.dayKey),
          workoutCount: r.workoutCount,
          reps: r.totalReps,
          durationSeconds: r.totalDurationSeconds,
          volume: r.totalVolume,
          isFreeze: r.isFreeze,
        ),
    ];
  }

  Future<TotalsSummary> lifetimeTotals() async {
    final activity = await allActivity();
    final records = await _db.allRecords();
    var bestSet = 0.0;
    for (final r in records) {
      if (r.metric == PrMetric.bestSetReps) {
        bestSet = bestSet > r.value ? bestSet : r.value;
      }
    }
    final base = StatsEngine.totals(activity: activity);
    return TotalsSummary(
      totalReps: base.totalReps,
      totalDurationSeconds: base.totalDurationSeconds,
      totalVolume: base.totalVolume,
      workoutCount: base.workoutCount,
      activeDays: base.activeDays,
      bestSetValue: bestSet,
      bestDayValue: base.bestDayValue,
    );
  }

  /// Exercises that have at least one logged set, for the progress picker.
  Future<List<ExerciseRow>> exercisesWithHistory() async {
    final ids = (await _db.exerciseIdsWithHistory()).toSet();
    final all = await _db.getExercises(includeArchived: true);
    return all.where((e) => ids.contains(e.id)).toList();
  }

  Future<ExerciseProgress?> progressFor(int exerciseId) async {
    final exercise = await _db.exerciseById(exerciseId);
    if (exercise == null) return null;

    final history = await _db.setHistoryForExercise(exerciseId);
    final samples = [
      for (final (workout, set) in history)
        SetSample(
          day: Day.fromEpochKey(workout.dayKey),
          trackingType: exercise.trackingType,
          reps: set.reps,
          weightKg: set.weightKg,
          durationSeconds: set.durationSeconds,
          distanceMeters: set.distanceMeters,
        ),
    ];

    final daily = StatsEngine.dailyFromSets(samples);
    final records = await _db.recordsForExercise(exerciseId);
    double recordValue(String metric) {
      for (final r in records) {
        if (r.metric == metric) return r.value;
      }
      return 0;
    }

    return ExerciseProgress(
      exercise: exercise,
      totals: StatsEngine.totals(activity: daily, sets: samples),
      dailyActivity: daily,
      bestSetSeries: StatsEngine.bestSetPerDay(samples),
      topWeightSeries: StatsEngine.topWeightPerDay(samples),
      estimatedOneRepMax: StatsEngine.estimatedOneRepMaxPerDay(samples),
      recordReps: recordValue(PrMetric.bestSetReps),
      recordDuration: recordValue(PrMetric.bestSetDuration),
      recordWeight: recordValue(PrMetric.bestSetWeight),
    );
  }

  /// Personal records across all exercises, best first.
  Future<List<(ExerciseRow, PersonalRecordRow)>> allRecords() async {
    final records = await _db.allRecords();
    final byId = {
      for (final e in await _db.getExercises(includeArchived: true)) e.id: e,
    };
    final out = <(ExerciseRow, PersonalRecordRow)>[];
    for (final r in records) {
      final ex = byId[r.exerciseId];
      if (ex != null) out.add((ex, r));
    }
    out.sort((a, b) => b.$2.achievedAt.compareTo(a.$2.achievedAt));
    return out;
  }

  Future<List<WorkoutSummary>> history({int limit = 200}) async {
    final workouts = await _db.completedWorkouts(limit: limit);
    final out = <WorkoutSummary>[];
    for (final w in workouts) {
      final exercises = await _db.exercisesForWorkout(w.id);
      final sets = await _db.setsForWorkout(w.id);
      out.add(
        WorkoutSummary(
          workout: w,
          exerciseNames: [
            for (final e in exercises)
              if (!e.isSkipped) e.exerciseName,
          ],
          setCount: sets.length,
        ),
      );
    }
    return out;
  }

  /// Full detail of one past workout, grouped by exercise.
  Future<List<(WorkoutExerciseRow, List<SetRow>)>> workoutDetail(
    int workoutId,
  ) async {
    final exercises = await _db.exercisesForWorkout(workoutId);
    final out = <(WorkoutExerciseRow, List<SetRow>)>[];
    for (final e in exercises) {
      final sets = await _db.setsForWorkoutExercise(e.id);
      out.add((e, sets.where((s) => s.isCompleted).toList()));
    }
    return out;
  }

  Future<WorkoutRow?> workoutById(int id) => _db.workoutById(id);

  /// Which weekday the user actually trains on, over all history.
  Future<Map<int, int>> weekdayDistribution() async =>
      StatsEngine.weekdayDistribution(await allActivity());

  /// Muscle-group split by set count over [window], for a balance readout.
  Future<Map<MuscleGroup, int>> muscleSplit(StatsWindow window) async {
    final range = DayRange.lastDays(window.days);
    final workouts = await _db.completedWorkoutsBetween(range);
    final byId = {
      for (final e in await _db.getExercises(includeArchived: true)) e.id: e,
    };

    final out = <MuscleGroup, int>{};
    for (final w in workouts) {
      final pairs = await _db.setsForWorkout(w.id);
      for (final (we, _) in pairs) {
        final group = byId[we.exerciseId]?.muscleGroup;
        if (group == null) continue;
        out[group] = (out[group] ?? 0) + 1;
      }
    }
    return out;
  }
}
