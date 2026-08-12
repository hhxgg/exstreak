import 'package:drift/drift.dart';

import '../../core/day.dart';
import '../../domain/enums.dart';
import '../database.dart';

/// A goal joined with the exercise it targets, ready for display.
class GoalView {
  const GoalView({required this.goal, this.exercise});

  final GoalRow goal;
  final ExerciseRow? exercise;

  double get progress => goal.targetValue <= 0
      ? 0
      : (goal.achievedValue / goal.targetValue).clamp(0.0, 1.0);

  bool get isOverdue {
    final deadline = goal.deadlineDayKey;
    if (deadline == null || goal.isCompleted) return false;
    return Day.today().key > deadline;
  }

  int? get daysRemaining {
    final deadline = goal.deadlineDayKey;
    if (deadline == null) return null;
    return Day.fromEpochKey(deadline).differenceInDays(Day.today());
  }

  /// The unit that goal values are expressed in.
  String get unit => switch (goal.type) {
    GoalType.streakDays => 'days',
    GoalType.workoutCount => 'workouts',
    GoalType.weeklyFrequency => 'per week',
    GoalType.singleSetRecord || GoalType.totalVolume =>
      exercise?.trackingType.tracksDuration ?? false ? 'sec' : 'reps',
  };
}

class GoalRepository {
  GoalRepository(this._db);

  final AppDatabase _db;

  Stream<List<GoalRow>> watchAll() => _db.watchGoals();

  Future<List<GoalView>> allWithExercises() async {
    final goals = await _db.getGoals();
    final byId = {
      for (final e in await _db.getExercises(includeArchived: true)) e.id: e,
    };
    return [
      for (final g in goals)
        GoalView(
          goal: g,
          exercise: g.exerciseId == null ? null : byId[g.exerciseId],
        ),
    ];
  }

  Future<int> create({
    required String title,
    required GoalType type,
    required double targetValue,
    int? exerciseId,
    Day? deadline,
  }) {
    return _db.insertGoal(
      GoalsCompanion.insert(
        title: title.trim(),
        type: type,
        exerciseId: Value(type.needsExercise ? exerciseId : null),
        targetValue: targetValue,
        startDayKey: Day.today().key,
        deadlineDayKey: Value(deadline?.key),
      ),
    );
  }

  Future<void> update(
    int id, {
    String? title,
    double? targetValue,
    Day? deadline,
    bool clearDeadline = false,
  }) {
    return _db.updateGoal(
      id,
      GoalsCompanion(
        title: title == null ? const Value.absent() : Value(title.trim()),
        targetValue: targetValue == null
            ? const Value.absent()
            : Value(targetValue),
        deadlineDayKey: clearDeadline
            ? const Value(null)
            : (deadline == null ? const Value.absent() : Value(deadline.key)),
      ),
    );
  }

  Future<void> delete(int id) => _db.deleteGoal(id);

  Future<void> archive(int id) =>
      _db.updateGoal(id, const GoalsCompanion(isArchived: Value(true)));

  /// Marks a goal done by hand, for targets the app cannot observe.
  Future<void> markComplete(int id) => _db.updateGoal(
    id,
    GoalsCompanion(
      isCompleted: const Value(true),
      completedDayKey: Value(Day.today().key),
    ),
  );

  Future<void> reopen(int id) => _db.updateGoal(
    id,
    const GoalsCompanion(
      isCompleted: Value(false),
      completedDayKey: Value(null),
    ),
  );
}
