import 'package:flutter/foundation.dart';

import '../../core/day.dart';
import '../../data/database.dart';
import '../enums.dart';

/// One planned set inside a [WorkoutDraft].
@immutable
class PlannedSet {
  const PlannedSet({this.target, this.weightKg = 0});

  /// Target in the exercise's own unit — reps, seconds or metres.
  final int? target;

  /// Pre-filled load for weighted exercises.
  final double weightKg;
}

/// One planned exercise inside a [WorkoutDraft].
@immutable
class PlannedExercise {
  const PlannedExercise({
    required this.exerciseId,
    required this.name,
    required this.trackingType,
    required this.sets,
    this.restSeconds = 90,
  });

  final int exerciseId;
  final String name;
  final TrackingType trackingType;
  final List<PlannedSet> sets;
  final int restSeconds;

  PlannedExercise copyWith({List<PlannedSet>? sets, int? restSeconds}) =>
      PlannedExercise(
        exerciseId: exerciseId,
        name: name,
        trackingType: trackingType,
        sets: sets ?? this.sets,
        restSeconds: restSeconds ?? this.restSeconds,
      );
}

/// A session about to be started: what to do, in what order.
@immutable
class WorkoutDraft {
  const WorkoutDraft({
    required this.source,
    required this.title,
    required this.exercises,
    this.planId,
    this.planLevel,
    this.planDay,
  });

  final WorkoutSource source;
  final String title;
  final List<PlannedExercise> exercises;

  final String? planId;
  final int? planLevel;
  final int? planDay;

  bool get isEmpty => exercises.isEmpty;

  int get totalSets => exercises.fold(0, (a, e) => a + e.sets.length);

  WorkoutDraft copyWith({String? title, List<PlannedExercise>? exercises}) =>
      WorkoutDraft(
        source: source,
        title: title ?? this.title,
        exercises: exercises ?? this.exercises,
        planId: planId,
        planLevel: planLevel,
        planDay: planDay,
      );
}

/// A set as it exists in an in-progress session: its database row plus the
/// live values the user is editing.
@immutable
class LiveSet {
  const LiveSet({
    required this.id,
    required this.position,
    required this.target,
    required this.reps,
    required this.weightKg,
    required this.durationSeconds,
    required this.distanceMeters,
    required this.isCompleted,
  });

  factory LiveSet.fromRow(SetRow row) => LiveSet(
    id: row.id,
    position: row.position,
    target: row.targetValue,
    reps: row.reps,
    weightKg: row.weightKg,
    durationSeconds: row.durationSeconds,
    distanceMeters: row.distanceMeters,
    isCompleted: row.isCompleted,
  );

  final int id;
  final int position;
  final int? target;
  final int reps;
  final double weightKg;
  final int durationSeconds;
  final double distanceMeters;
  final bool isCompleted;

  /// The achieved value in the exercise's own unit.
  int achievedFor(TrackingType type) => switch (type) {
    TrackingType.reps || TrackingType.repsWeight => reps,
    TrackingType.duration => durationSeconds,
    TrackingType.distanceDuration => distanceMeters.round(),
  };

  bool metTargetFor(TrackingType type) {
    final t = target;
    if (t == null || t <= 0) return isCompleted;
    return achievedFor(type) >= t;
  }

  LiveSet copyWith({
    int? reps,
    double? weightKg,
    int? durationSeconds,
    double? distanceMeters,
    bool? isCompleted,
    int? target,
  }) => LiveSet(
    id: id,
    position: position,
    target: target ?? this.target,
    reps: reps ?? this.reps,
    weightKg: weightKg ?? this.weightKg,
    durationSeconds: durationSeconds ?? this.durationSeconds,
    distanceMeters: distanceMeters ?? this.distanceMeters,
    isCompleted: isCompleted ?? this.isCompleted,
  );
}

/// An exercise inside an in-progress session.
@immutable
class LiveExercise {
  const LiveExercise({
    required this.id,
    required this.exerciseId,
    required this.name,
    required this.trackingType,
    required this.position,
    required this.sets,
    required this.isSkipped,
    required this.restSeconds,
    required this.iconName,
  });

  final int id;
  final int exerciseId;
  final String name;
  final TrackingType trackingType;
  final int position;
  final List<LiveSet> sets;
  final bool isSkipped;
  final int restSeconds;
  final String iconName;

  int get completedSetCount => sets.where((s) => s.isCompleted).length;

  bool get isFinished => isSkipped || completedSetCount >= sets.length;

  /// Index of the next set to perform, or null when the exercise is done.
  int? get nextSetIndex {
    for (var i = 0; i < sets.length; i++) {
      if (!sets[i].isCompleted) return i;
    }
    return null;
  }

  int get achievedTotal => sets
      .where((s) => s.isCompleted)
      .fold(0, (a, s) => a + s.achievedFor(trackingType));

  int get targetTotal => sets.fold(0, (a, s) => a + (s.target ?? 0));

  LiveExercise copyWith({List<LiveSet>? sets, bool? isSkipped}) => LiveExercise(
    id: id,
    exerciseId: exerciseId,
    name: name,
    trackingType: trackingType,
    position: position,
    sets: sets ?? this.sets,
    isSkipped: isSkipped ?? this.isSkipped,
    restSeconds: restSeconds,
    iconName: iconName,
  );
}

/// The full hydrated state of a workout in progress.
///
/// Reconstructed from the database on every read, so killing the app mid-set
/// loses nothing that was already committed.
@immutable
class ActiveWorkout {
  const ActiveWorkout({
    required this.id,
    required this.source,
    required this.title,
    required this.startedAt,
    required this.day,
    required this.exercises,
    this.planId,
    this.planLevel,
    this.planDay,
  });

  final int id;
  final WorkoutSource source;
  final String title;
  final DateTime startedAt;
  final Day day;
  final List<LiveExercise> exercises;

  final String? planId;
  final int? planLevel;
  final int? planDay;

  /// True when there is nothing to perform. An exercise carrying no sets is
  /// as unusable as no exercise at all, so the session screen shows its
  /// "no longer available" state instead of an inert counter.
  bool get isEmpty => exercises.isEmpty || totalSets == 0;

  int get totalSets => exercises.fold(0, (a, e) => a + e.sets.length);

  int get completedSets => exercises.fold(0, (a, e) => a + e.completedSetCount);

  double get progress => totalSets == 0 ? 0 : completedSets / totalSets;

  bool get allDone => exercises.every((e) => e.isFinished);

  /// Index of the exercise the user should be working on now.
  int get currentExerciseIndex {
    for (var i = 0; i < exercises.length; i++) {
      if (!exercises[i].isFinished) return i;
    }
    return exercises.isEmpty ? 0 : exercises.length - 1;
  }

  LiveExercise? get currentExercise =>
      exercises.isEmpty ? null : exercises[currentExerciseIndex];

  int get totalReps => exercises
      .where((e) => e.trackingType.tracksReps)
      .fold(0, (a, e) => a + e.achievedTotal);

  int get totalDurationSeconds => exercises
      .where((e) => e.trackingType.tracksDuration)
      .fold(0, (a, e) => a + e.achievedTotal);
}

/// What changed as a result of finishing a workout — used to drive the
/// celebration screens.
@immutable
class WorkoutResult {
  const WorkoutResult({
    required this.workoutId,
    required this.day,
    required this.totalReps,
    required this.totalDurationSeconds,
    required this.newRecords,
    required this.newBadges,
    required this.completedGoalIds,
    required this.streakBefore,
    required this.streakAfter,
    required this.isFirstWorkoutOfDay,
  });

  final int workoutId;
  final Day day;
  final int totalReps;
  final int totalDurationSeconds;

  /// Human-readable descriptions of records broken this session.
  final List<String> newRecords;

  /// Badge codes awarded this session.
  final List<String> newBadges;

  final List<int> completedGoalIds;

  final int streakBefore;
  final int streakAfter;

  /// False when the user already trained earlier today — the streak screen is
  /// skipped in that case rather than claiming a second increase.
  final bool isFirstWorkoutOfDay;

  bool get streakIncreased => streakAfter > streakBefore;

  bool get hasCelebration =>
      streakIncreased || newRecords.isNotEmpty || newBadges.isNotEmpty;
}
