import 'package:flutter/material.dart';

/// What a set of an exercise actually measures.
///
/// The workout UI switches its input widgets off this value, so adding an
/// exercise never requires touching screen code.
enum TrackingType {
  /// Bodyweight reps: push-ups, pull-ups, sit-ups.
  reps,

  /// Reps against an external load: curls, bench press.
  repsWeight,

  /// A held position: plank, wall sit.
  duration,

  /// Covered ground over time: running, rowing.
  distanceDuration;

  bool get tracksReps => this == reps || this == repsWeight;

  bool get tracksWeight => this == repsWeight;

  bool get tracksDuration => this == duration || this == distanceDuration;

  bool get tracksDistance => this == distanceDuration;

  String get label => switch (this) {
    TrackingType.reps => 'Reps',
    TrackingType.repsWeight => 'Reps + weight',
    TrackingType.duration => 'Time',
    TrackingType.distanceDuration => 'Distance + time',
  };

  /// The unit that a target is expressed in for this tracking type.
  String get targetUnit => switch (this) {
    TrackingType.reps || TrackingType.repsWeight => 'reps',
    TrackingType.duration => 'sec',
    TrackingType.distanceDuration => 'm',
  };

  IconData get icon => switch (this) {
    TrackingType.reps => Icons.repeat_rounded,
    TrackingType.repsWeight => Icons.fitness_center_rounded,
    TrackingType.duration => Icons.timer_outlined,
    TrackingType.distanceDuration => Icons.route_rounded,
  };
}

enum MuscleGroup {
  chest,
  back,
  shoulders,
  arms,
  legs,
  core,
  fullBody,
  cardio;

  String get label => switch (this) {
    MuscleGroup.chest => 'Chest',
    MuscleGroup.back => 'Back',
    MuscleGroup.shoulders => 'Shoulders',
    MuscleGroup.arms => 'Arms',
    MuscleGroup.legs => 'Legs',
    MuscleGroup.core => 'Core',
    MuscleGroup.fullBody => 'Full body',
    MuscleGroup.cardio => 'Cardio',
  };

  IconData get icon => switch (this) {
    MuscleGroup.chest => Icons.accessibility_new_rounded,
    MuscleGroup.back => Icons.airline_seat_flat_rounded,
    MuscleGroup.shoulders => Icons.sports_gymnastics_rounded,
    MuscleGroup.arms => Icons.fitness_center_rounded,
    MuscleGroup.legs => Icons.directions_walk_rounded,
    MuscleGroup.core => Icons.self_improvement_rounded,
    MuscleGroup.fullBody => Icons.person_rounded,
    MuscleGroup.cardio => Icons.favorite_rounded,
  };
}

enum Equipment {
  none,
  dumbbell,
  barbell,
  pullUpBar,
  bench,
  resistanceBand,
  kettlebell,
  machine;

  String get label => switch (this) {
    Equipment.none => 'Bodyweight',
    Equipment.dumbbell => 'Dumbbells',
    Equipment.barbell => 'Barbell',
    Equipment.pullUpBar => 'Pull-up bar',
    Equipment.bench => 'Bench',
    Equipment.resistanceBand => 'Band',
    Equipment.kettlebell => 'Kettlebell',
    Equipment.machine => 'Machine',
  };
}

enum Difficulty {
  beginner,
  intermediate,
  advanced;

  String get label => switch (this) {
    Difficulty.beginner => 'Beginner',
    Difficulty.intermediate => 'Intermediate',
    Difficulty.advanced => 'Advanced',
  };
}

/// How hard the last session felt. Drives the adaptive plan progression.
enum SessionFeedback {
  tooEasy,
  justRight,
  tooHard;

  String get label => switch (this) {
    SessionFeedback.tooEasy => 'Too easy',
    SessionFeedback.justRight => 'Just right',
    SessionFeedback.tooHard => 'Too hard',
  };

  String get subtitle => switch (this) {
    SessionFeedback.tooEasy => 'Skip ahead a level',
    SessionFeedback.justRight => 'Stay on plan',
    SessionFeedback.tooHard => 'Repeat this day',
  };

  IconData get icon => switch (this) {
    SessionFeedback.tooEasy => Icons.keyboard_double_arrow_right_rounded,
    SessionFeedback.justRight => Icons.arrow_forward_rounded,
    SessionFeedback.tooHard => Icons.refresh_rounded,
  };

  /// How many plan days to advance after a session with this feedback.
  int get dayAdvance => switch (this) {
    SessionFeedback.tooEasy => 2,
    SessionFeedback.justRight => 1,
    SessionFeedback.tooHard => 0,
  };
}

/// Where a workout came from, which changes how it is summarised.
enum WorkoutSource {
  /// A day from a structured progressive plan.
  plan,

  /// A user-assembled session from the exercise library.
  custom,

  /// Unlimited single-exercise effort, no targets.
  freePractice;

  String get label => switch (this) {
    WorkoutSource.plan => 'Plan',
    WorkoutSource.custom => 'Custom',
    WorkoutSource.freePractice => 'Free practice',
  };
}

enum GoalType {
  /// Reach a single-set personal record (e.g. 25 push-ups in one set).
  singleSetRecord,

  /// Accumulate a total across all time (e.g. 10 000 push-ups).
  totalVolume,

  /// Hold a streak of N days.
  streakDays,

  /// Complete N workouts within the goal window.
  workoutCount,

  /// Train at least N times per week.
  weeklyFrequency;

  String get label => switch (this) {
    GoalType.singleSetRecord => 'Single-set record',
    GoalType.totalVolume => 'Total volume',
    GoalType.streakDays => 'Streak length',
    GoalType.workoutCount => 'Workout count',
    GoalType.weeklyFrequency => 'Weekly frequency',
  };

  String get description => switch (this) {
    GoalType.singleSetRecord => 'Hit a target in one single set',
    GoalType.totalVolume => 'Accumulate a total across all sessions',
    GoalType.streakDays => 'Keep the streak alive for N days',
    GoalType.workoutCount => 'Finish a number of workouts',
    GoalType.weeklyFrequency => 'Train N times every week',
  };

  IconData get icon => switch (this) {
    GoalType.singleSetRecord => Icons.emoji_events_rounded,
    GoalType.totalVolume => Icons.stacked_bar_chart_rounded,
    GoalType.streakDays => Icons.local_fire_department_rounded,
    GoalType.workoutCount => Icons.checklist_rounded,
    GoalType.weeklyFrequency => Icons.calendar_view_week_rounded,
  };

  /// Whether the goal is tied to one specific exercise.
  bool get needsExercise =>
      this == GoalType.singleSetRecord || this == GoalType.totalVolume;
}

enum FitnessLevel {
  beginner,
  returning,
  regular,
  athlete;

  String get label => switch (this) {
    FitnessLevel.beginner => 'Just starting',
    FitnessLevel.returning => 'Getting back into it',
    FitnessLevel.regular => 'Train regularly',
    FitnessLevel.athlete => 'Athlete',
  };

  String get subtitle => switch (this) {
    FitnessLevel.beginner => 'New to training or a long break',
    FitnessLevel.returning => 'Used to train, restarting now',
    FitnessLevel.regular => 'A few sessions every week',
    FitnessLevel.athlete => 'Structured, high-volume training',
  };

  /// Which plan level a new user starts on.
  int get suggestedPlanLevel => switch (this) {
    FitnessLevel.beginner => 1,
    FitnessLevel.returning => 1,
    FitnessLevel.regular => 2,
    FitnessLevel.athlete => 3,
  };
}

enum PrimaryGoal {
  consistency,
  strength,
  endurance,
  general;

  String get label => switch (this) {
    PrimaryGoal.consistency => 'Build the habit',
    PrimaryGoal.strength => 'Get stronger',
    PrimaryGoal.endurance => 'More endurance',
    PrimaryGoal.general => 'General fitness',
  };

  IconData get icon => switch (this) {
    PrimaryGoal.consistency => Icons.local_fire_department_rounded,
    PrimaryGoal.strength => Icons.fitness_center_rounded,
    PrimaryGoal.endurance => Icons.timer_outlined,
    PrimaryGoal.general => Icons.favorite_rounded,
  };
}

enum UnitSystem {
  metric,
  imperial;

  String get label => switch (this) {
    UnitSystem.metric => 'Metric (kg, cm)',
    UnitSystem.imperial => 'Imperial (lb, in)',
  };

  String get weightUnit => this == UnitSystem.metric ? 'kg' : 'lb';

  String get heightUnit => this == UnitSystem.metric ? 'cm' : 'in';

  String get distanceUnit => this == UnitSystem.metric ? 'km' : 'mi';
}

enum AppThemeMode {
  system,
  dark,
  light;

  String get label => switch (this) {
    AppThemeMode.system => 'Match system',
    AppThemeMode.dark => 'Always dark',
    AppThemeMode.light => 'Always light',
  };

  ThemeMode get material => switch (this) {
    AppThemeMode.system => ThemeMode.system,
    AppThemeMode.dark => ThemeMode.dark,
    AppThemeMode.light => ThemeMode.light,
  };
}

/// How reps are registered during an active set.
enum RepInputMode {
  /// Tap anywhere on the counter ring.
  tap,

  /// Proximity sensor: the phone lies on the floor and the user's nose
  /// covers the sensor at the bottom of each rep.
  proximity;

  String get label => switch (this) {
    RepInputMode.tap => 'Tap to count',
    RepInputMode.proximity => 'Proximity sensor',
  };

  String get hint => switch (this) {
    RepInputMode.tap => 'Tap the ring after every rep',
    RepInputMode.proximity => 'Touch the screen with your nose to count',
  };
}
