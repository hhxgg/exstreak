import 'dart:math' as math;

import 'package:flutter/foundation.dart';

import '../enums.dart';

/// One day of a structured plan: an ordered list of set targets.
@immutable
class PlanDay {
  const PlanDay({
    required this.level,
    required this.day,
    required this.targets,
    required this.trackingType,
  });

  final int level;
  final int day;

  /// Target per set, in [TrackingType.targetUnit] (reps or seconds).
  final List<int> targets;

  final TrackingType trackingType;

  int get total => targets.fold(0, (a, b) => a + b);

  int get setCount => targets.length;

  /// `5 · 8 · 6 · 4 · 4`
  String get summary => targets.join(' · ');
}

/// A progressive training plan built around one primary exercise.
///
/// Targets are generated from a curve rather than stored as a table, so a plan
/// is roughly twenty lines of configuration instead of hundreds of literals.
@immutable
class PlanTemplate {
  const PlanTemplate({
    required this.id,
    required this.name,
    required this.exerciseSlug,
    required this.trackingType,
    required this.levelTitles,
    required this.levelRanges,
    this.daysPerLevel = 16,
    this.setCount = 5,
    this.minPerSet = 1,
  });

  final String id;
  final String name;

  /// Which catalogue exercise the plan trains.
  final String exerciseSlug;

  final TrackingType trackingType;

  /// Display title per level, e.g. `25 push-ups`.
  final List<String> levelTitles;

  /// `(startTotal, endTotal)` for each level, in the target unit.
  final List<({int start, int end})> levelRanges;

  final int daysPerLevel;
  final int setCount;
  final int minPerSet;

  int get levelCount => levelTitles.length;

  /// Relative share of the daily total per set.
  ///
  /// Front-loaded with a peak on set two, then tapering — the shape that lets
  /// a trainee accumulate volume without failing halfway through.
  static const List<double> _setShape = [0.18, 0.29, 0.22, 0.16, 0.15];

  /// Total workload prescribed on [day] of [level] (1-based).
  int totalFor(int level, int day) {
    final range = levelRanges[(level - 1).clamp(0, levelCount - 1)];
    final d = day.clamp(1, daysPerLevel);
    if (daysPerLevel == 1) return range.end;

    // Slightly concave: faster early gains, gentler at the top of the level.
    final t = (d - 1) / (daysPerLevel - 1);
    final eased = math.pow(t, 0.85).toDouble();
    return (range.start + (range.end - range.start) * eased).round();
  }

  /// The full prescription for one day.
  PlanDay dayFor(int level, int day) {
    final total = totalFor(level, day);
    final shape = _shapeFor(setCount);

    final raw = <int>[];
    for (var i = 0; i < setCount; i++) {
      raw.add(math.max(minPerSet, (total * shape[i]).round()));
    }

    // Rounding drifts the sum; push the remainder onto the peak set so the
    // displayed sets always add up to the displayed total.
    var diff = total - raw.fold(0, (a, b) => a + b);
    var guard = 0;
    while (diff != 0 && guard++ < 64) {
      final peak = _peakIndex(shape);
      if (diff > 0) {
        raw[peak] += 1;
        diff -= 1;
      } else {
        // Take from the largest set that can still spare a unit.
        var idx = -1;
        var best = minPerSet;
        for (var i = 0; i < raw.length; i++) {
          if (raw[i] > best) {
            best = raw[i];
            idx = i;
          }
        }
        if (idx < 0) break;
        raw[idx] -= 1;
        diff += 1;
      }
    }

    return PlanDay(
      level: level,
      day: day,
      targets: raw,
      trackingType: trackingType,
    );
  }

  /// Every day of a level, for the day-picker list.
  List<PlanDay> level(int level) => [
    for (var d = 1; d <= daysPerLevel; d++) dayFor(level, d),
  ];

  static List<double> _shapeFor(int count) {
    if (count == _setShape.length) return _setShape;
    // Resample the canonical shape to an arbitrary set count, then normalise.
    final resampled = <double>[
      for (var i = 0; i < count; i++)
        _setShape[(i * _setShape.length ~/ count).clamp(
          0,
          _setShape.length - 1,
        )],
    ];
    final sum = resampled.fold(0.0, (a, b) => a + b);
    return [for (final v in resampled) v / sum];
  }

  static int _peakIndex(List<double> shape) {
    var idx = 0;
    for (var i = 1; i < shape.length; i++) {
      if (shape[i] > shape[idx]) idx = i;
    }
    return idx;
  }
}

/// The plans shipped with the app.
///
/// A new plan is one entry here plus a matching exercise slug in the seed.
abstract final class PlanTemplates {
  static const PlanTemplate pushups = PlanTemplate(
    id: 'pushup-100',
    name: 'Push-up plan',
    exerciseSlug: 'pushup',
    trackingType: TrackingType.reps,
    levelTitles: ['25 push-ups', '50 push-ups', '100 push-ups'],
    levelRanges: [
      (start: 13, end: 46),
      (start: 32, end: 88),
      (start: 62, end: 155),
    ],
  );

  static const PlanTemplate plank = PlanTemplate(
    id: 'plank-core',
    name: 'Plank plan',
    exerciseSlug: 'plank',
    trackingType: TrackingType.duration,
    levelTitles: ['2 minute hold', '4 minute hold', '6 minute hold'],
    levelRanges: [
      (start: 70, end: 195),
      (start: 165, end: 380),
      (start: 330, end: 640),
    ],
    minPerSet: 10,
  );

  static const PlanTemplate pullups = PlanTemplate(
    id: 'pullup-strength',
    name: 'Pull-up plan',
    exerciseSlug: 'pullup',
    trackingType: TrackingType.reps,
    levelTitles: ['5 pull-ups', '12 pull-ups', '20 pull-ups'],
    levelRanges: [
      (start: 5, end: 18),
      (start: 14, end: 36),
      (start: 28, end: 62),
    ],
  );

  static const PlanTemplate squats = PlanTemplate(
    id: 'squat-legs',
    name: 'Squat plan',
    exerciseSlug: 'squat',
    trackingType: TrackingType.reps,
    levelTitles: ['50 squats', '100 squats', '200 squats'],
    levelRanges: [
      (start: 26, end: 85),
      (start: 60, end: 155),
      (start: 120, end: 265),
    ],
  );

  static const PlanTemplate situps = PlanTemplate(
    id: 'situp-core',
    name: 'Sit-up plan',
    exerciseSlug: 'situp',
    trackingType: TrackingType.reps,
    levelTitles: ['50 sit-ups', '100 sit-ups', '200 sit-ups'],
    levelRanges: [
      (start: 22, end: 72),
      (start: 52, end: 128),
      (start: 100, end: 215),
    ],
  );

  static const PlanTemplate dips = PlanTemplate(
    id: 'dip-strength',
    name: 'Dip plan',
    exerciseSlug: 'dip',
    trackingType: TrackingType.reps,
    levelTitles: ['10 dips', '25 dips', '50 dips'],
    levelRanges: [
      (start: 7, end: 24),
      (start: 18, end: 46),
      (start: 36, end: 80),
    ],
  );

  static const List<PlanTemplate> all = [
    pushups,
    plank,
    pullups,
    squats,
    situps,
    dips,
  ];

  static PlanTemplate? byId(String id) {
    for (final p in all) {
      if (p.id == id) return p;
    }
    return null;
  }

  /// The plan the app opens on for a brand-new user.
  static const String defaultPlanId = 'pushup-100';
}
