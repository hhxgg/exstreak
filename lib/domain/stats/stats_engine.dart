import 'dart:math' as math;

import 'package:flutter/foundation.dart';

import '../../core/day.dart';
import '../enums.dart';

/// One day's training totals, as the stats layer sees it.
@immutable
class ActivityPoint {
  const ActivityPoint({
    required this.day,
    this.workoutCount = 0,
    this.reps = 0,
    this.durationSeconds = 0,
    this.volume = 0,
    this.isFreeze = false,
  });

  final Day day;
  final int workoutCount;
  final int reps;
  final int durationSeconds;
  final double volume;
  final bool isFreeze;

  bool get hasWorkout => workoutCount > 0;
}

/// A single completed set, flattened for per-exercise analysis.
@immutable
class SetSample {
  const SetSample({
    required this.day,
    required this.trackingType,
    this.reps = 0,
    this.weightKg = 0,
    this.durationSeconds = 0,
    this.distanceMeters = 0,
  });

  final Day day;
  final TrackingType trackingType;
  final int reps;
  final double weightKg;
  final int durationSeconds;
  final double distanceMeters;

  /// The number this set contributes to a "best set" comparison.
  double get primaryValue => switch (trackingType) {
    TrackingType.reps || TrackingType.repsWeight => reps.toDouble(),
    TrackingType.duration => durationSeconds.toDouble(),
    TrackingType.distanceDuration => distanceMeters,
  };

  /// Load moved by this set. Bodyweight sets have no external load, so reps
  /// stand in for volume; weighted sets use the familiar reps × weight.
  double get volume => switch (trackingType) {
    TrackingType.repsWeight => reps * weightKg,
    TrackingType.reps => reps.toDouble(),
    TrackingType.duration => durationSeconds.toDouble(),
    TrackingType.distanceDuration => distanceMeters,
  };
}

/// A charted point: a bucket label plus its value.
@immutable
class SeriesPoint {
  const SeriesPoint({required this.day, required this.value, this.label = ''});

  final Day day;
  final double value;
  final String label;
}

/// Bucket width for trend charts.
enum StatsWindow {
  week(7, 'Week'),
  month(30, 'Month'),
  quarter(90, '3 months'),
  year(365, 'Year');

  const StatsWindow(this.days, this.label);

  final int days;
  final String label;

  /// Days per bar. Longer windows aggregate so bars stay readable.
  int get bucketDays => switch (this) {
    StatsWindow.week => 1,
    StatsWindow.month => 1,
    StatsWindow.quarter => 7,
    StatsWindow.year => 30,
  };
}

/// Headline numbers for one exercise or for the whole app.
@immutable
class TotalsSummary {
  const TotalsSummary({
    required this.totalReps,
    required this.totalDurationSeconds,
    required this.totalVolume,
    required this.workoutCount,
    required this.activeDays,
    required this.bestSetValue,
    required this.bestDayValue,
  });

  const TotalsSummary.empty()
    : totalReps = 0,
      totalDurationSeconds = 0,
      totalVolume = 0,
      workoutCount = 0,
      activeDays = 0,
      bestSetValue = 0,
      bestDayValue = 0;

  final int totalReps;
  final int totalDurationSeconds;
  final double totalVolume;
  final int workoutCount;
  final int activeDays;

  /// Best single set ever recorded.
  final double bestSetValue;

  /// Best single day total ever recorded.
  final double bestDayValue;

  /// Average per *active* day — averaging over rest days would understate
  /// what the user actually does in a session.
  double get averageRepsPerActiveDay =>
      activeDays == 0 ? 0 : totalReps / activeDays;

  double get averageDurationPerActiveDay =>
      activeDays == 0 ? 0 : totalDurationSeconds / activeDays;
}

/// Aggregations that turn raw rows into things a chart can draw.
///
/// Pure functions over plain value types, so every calculation is unit-testable
/// without a database or a widget tree.
abstract final class StatsEngine {
  /// Fills gaps so a chart shows rest days as zero rather than skipping them.
  static List<ActivityPoint> densify(
    List<ActivityPoint> points,
    DayRange range,
  ) {
    final byDay = {for (final p in points) p.day: p};
    return [for (final d in range.days) byDay[d] ?? ActivityPoint(day: d)];
  }

  /// Buckets a dense activity list into chart bars.
  static List<SeriesPoint> trend(
    List<ActivityPoint> dense,
    StatsWindow window,
    double Function(ActivityPoint) select,
  ) {
    if (dense.isEmpty) return const [];
    final bucket = window.bucketDays;
    if (bucket <= 1) {
      return [for (final p in dense) SeriesPoint(day: p.day, value: select(p))];
    }

    final out = <SeriesPoint>[];
    for (var i = 0; i < dense.length; i += bucket) {
      final slice = dense.sublist(i, math.min(i + bucket, dense.length));
      final sum = slice.fold(0.0, (a, p) => a + select(p));
      out.add(SeriesPoint(day: slice.first.day, value: sum));
    }
    return out;
  }

  /// Per-day totals for one exercise, from its flattened set history.
  static List<ActivityPoint> dailyFromSets(List<SetSample> sets) {
    final byDay = <Day, ActivityPoint>{};
    for (final s in sets) {
      final existing = byDay[s.day];
      byDay[s.day] = ActivityPoint(
        day: s.day,
        workoutCount: existing?.workoutCount ?? 1,
        reps: (existing?.reps ?? 0) + s.reps,
        durationSeconds: (existing?.durationSeconds ?? 0) + s.durationSeconds,
        volume: (existing?.volume ?? 0) + s.volume,
      );
    }
    final out = byDay.values.toList()..sort((a, b) => a.day.compareTo(b.day));
    return out;
  }

  /// Best single set per day — the series that shows real strength progression,
  /// as opposed to volume, which rises just by doing more sets.
  static List<SeriesPoint> bestSetPerDay(List<SetSample> sets) {
    final byDay = <Day, double>{};
    for (final s in sets) {
      final v = s.primaryValue;
      if (v <= 0) continue;
      byDay[s.day] = math.max(byDay[s.day] ?? 0, v);
    }
    final days = byDay.keys.toList()..sort();
    return [for (final d in days) SeriesPoint(day: d, value: byDay[d]!)];
  }

  /// Heaviest weight used per day, for loaded exercises.
  static List<SeriesPoint> topWeightPerDay(List<SetSample> sets) {
    final byDay = <Day, double>{};
    for (final s in sets) {
      if (s.weightKg <= 0) continue;
      byDay[s.day] = math.max(byDay[s.day] ?? 0, s.weightKg);
    }
    final days = byDay.keys.toList()..sort();
    return [for (final d in days) SeriesPoint(day: d, value: byDay[d]!)];
  }

  /// Estimated one-rep max via the Epley formula, per day.
  ///
  /// Only meaningful for weighted work; returns empty for bodyweight sets.
  static List<SeriesPoint> estimatedOneRepMaxPerDay(List<SetSample> sets) {
    final byDay = <Day, double>{};
    for (final s in sets) {
      if (s.weightKg <= 0 || s.reps <= 0) continue;
      final e1rm = s.weightKg * (1 + s.reps / 30.0);
      byDay[s.day] = math.max(byDay[s.day] ?? 0, e1rm);
    }
    final days = byDay.keys.toList()..sort();
    return [for (final d in days) SeriesPoint(day: d, value: byDay[d]!)];
  }

  static TotalsSummary totals({
    required List<ActivityPoint> activity,
    List<SetSample> sets = const [],
  }) {
    if (activity.isEmpty && sets.isEmpty) return const TotalsSummary.empty();

    var reps = 0;
    var seconds = 0;
    var volume = 0.0;
    var workouts = 0;
    var active = 0;
    var bestDay = 0.0;

    for (final p in activity) {
      reps += p.reps;
      seconds += p.durationSeconds;
      volume += p.volume;
      workouts += p.workoutCount;
      if (p.hasWorkout) active++;
      final dayValue = p.reps > 0
          ? p.reps.toDouble()
          : p.durationSeconds.toDouble();
      bestDay = math.max(bestDay, dayValue);
    }

    var bestSet = 0.0;
    for (final s in sets) {
      bestSet = math.max(bestSet, s.primaryValue);
    }

    return TotalsSummary(
      totalReps: reps,
      totalDurationSeconds: seconds,
      totalVolume: volume,
      workoutCount: workouts,
      activeDays: active,
      bestSetValue: bestSet,
      bestDayValue: bestDay,
    );
  }

  /// Count of active days per weekday, 1 = Monday … 7 = Sunday.
  ///
  /// Surfaces the day of the week the user actually trains on.
  static Map<int, int> weekdayDistribution(List<ActivityPoint> activity) {
    final out = {for (var i = 1; i <= 7; i++) i: 0};
    for (final p in activity) {
      if (p.hasWorkout) out[p.day.weekday] = (out[p.day.weekday] ?? 0) + 1;
    }
    return out;
  }

  /// Percentage change between the two halves of a window.
  ///
  /// Returns null when the earlier half is empty, because "up from nothing"
  /// is not a meaningful percentage to show a user.
  static double? momentum(List<ActivityPoint> dense) {
    if (dense.length < 4) return null;
    final mid = dense.length ~/ 2;
    final older = dense.sublist(0, mid);
    final newer = dense.sublist(mid);

    double sum(List<ActivityPoint> xs) => xs.fold(
      0.0,
      (a, p) => a + (p.reps > 0 ? p.reps.toDouble() : p.durationSeconds / 10),
    );

    final a = sum(older);
    final b = sum(newer);
    if (a <= 0) return null;
    return ((b - a) / a) * 100;
  }
}
