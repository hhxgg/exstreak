import 'package:exstreak/core/day.dart';
import 'package:exstreak/domain/enums.dart';
import 'package:exstreak/domain/stats/stats_engine.dart';
import 'package:flutter_test/flutter_test.dart';

const Day today = Day(2026, 8, 12);

void main() {
  group('densify', () {
    test('fills rest days with zeroes', () {
      final range = DayRange.lastDays(5, endingOn: today);
      final points = [
        ActivityPoint(day: today, workoutCount: 1, reps: 30),
        ActivityPoint(day: today.addDays(-3), workoutCount: 1, reps: 20),
      ];

      final dense = StatsEngine.densify(points, range);
      expect(dense, hasLength(5));
      expect(dense.map((p) => p.reps).toList(), [0, 20, 0, 0, 30]);
      expect(dense.first.day, today.addDays(-4));
      expect(dense.last.day, today);
    });
  });

  group('trend', () {
    test('one bar per day for short windows', () {
      final dense = StatsEngine.densify(
        [ActivityPoint(day: today, reps: 10, workoutCount: 1)],
        DayRange.lastDays(7, endingOn: today),
      );
      final series = StatsEngine.trend(
        dense,
        StatsWindow.week,
        (p) => p.reps.toDouble(),
      );
      expect(series, hasLength(7));
    });

    test('buckets longer windows and sums within each bucket', () {
      final dense = [
        for (var i = 0; i < 14; i++)
          ActivityPoint(
            day: today.addDays(-13 + i),
            reps: 10,
            workoutCount: 1,
          ),
      ];
      final series = StatsEngine.trend(
        dense,
        StatsWindow.quarter, // 7-day buckets
        (p) => p.reps.toDouble(),
      );
      expect(series, hasLength(2));
      expect(series.every((p) => p.value == 70), isTrue);
    });

    test('handles an empty input', () {
      expect(
        StatsEngine.trend(const [], StatsWindow.month, (p) => p.reps.toDouble()),
        isEmpty,
      );
    });
  });

  group('per-exercise aggregation', () {
    final samples = [
      SetSample(day: today, trackingType: TrackingType.reps, reps: 12),
      SetSample(day: today, trackingType: TrackingType.reps, reps: 8),
      SetSample(
        day: today.addDays(-2),
        trackingType: TrackingType.reps,
        reps: 15,
      ),
    ];

    test('dailyFromSets groups by day and sums reps', () {
      final daily = StatsEngine.dailyFromSets(samples);
      expect(daily, hasLength(2));
      expect(daily.first.day, today.addDays(-2));
      expect(daily.first.reps, 15);
      expect(daily.last.reps, 20);
    });

    test('bestSetPerDay reports the peak set, not the sum', () {
      final best = StatsEngine.bestSetPerDay(samples);
      expect(best, hasLength(2));
      expect(best.last.value, 12);
    });

    test('bestSetPerDay ignores zero-value sets', () {
      final best = StatsEngine.bestSetPerDay([
        SetSample(day: today, trackingType: TrackingType.reps, reps: 0),
      ]);
      expect(best, isEmpty);
    });

    test('topWeightPerDay only considers loaded sets', () {
      final weighted = [
        SetSample(
          day: today,
          trackingType: TrackingType.repsWeight,
          reps: 10,
          weightKg: 20,
        ),
        SetSample(
          day: today,
          trackingType: TrackingType.repsWeight,
          reps: 6,
          weightKg: 30,
        ),
        SetSample(day: today, trackingType: TrackingType.reps, reps: 20),
      ];
      final top = StatsEngine.topWeightPerDay(weighted);
      expect(top, hasLength(1));
      expect(top.single.value, 30);
    });

    test('estimated 1RM uses the Epley formula', () {
      final e1rm = StatsEngine.estimatedOneRepMaxPerDay([
        SetSample(
          day: today,
          trackingType: TrackingType.repsWeight,
          reps: 10,
          weightKg: 60,
        ),
      ]);
      // 60 * (1 + 10/30) = 80
      expect(e1rm.single.value, closeTo(80, 0.001));
    });

    test('estimated 1RM is empty for bodyweight work', () {
      final e1rm = StatsEngine.estimatedOneRepMaxPerDay([
        SetSample(day: today, trackingType: TrackingType.reps, reps: 30),
      ]);
      expect(e1rm, isEmpty);
    });
  });

  group('SetSample volume', () {
    test('weighted sets use reps times load', () {
      const s = SetSample(
        day: today,
        trackingType: TrackingType.repsWeight,
        reps: 10,
        weightKg: 25,
      );
      expect(s.volume, 250);
    });

    test('bodyweight sets fall back to reps', () {
      const s = SetSample(
        day: today,
        trackingType: TrackingType.reps,
        reps: 18,
      );
      expect(s.volume, 18);
    });

    test('holds use seconds', () {
      const s = SetSample(
        day: today,
        trackingType: TrackingType.duration,
        durationSeconds: 90,
      );
      expect(s.volume, 90);
      expect(s.primaryValue, 90);
    });
  });

  group('totals', () {
    test('averages over active days only, not rest days', () {
      final activity = StatsEngine.densify(
        [
          ActivityPoint(day: today, workoutCount: 1, reps: 40),
          ActivityPoint(day: today.addDays(-6), workoutCount: 1, reps: 20),
        ],
        DayRange.lastDays(7, endingOn: today),
      );

      final totals = StatsEngine.totals(activity: activity);
      expect(totals.totalReps, 60);
      expect(totals.activeDays, 2);
      // 60 / 2 active days, not 60 / 7 calendar days.
      expect(totals.averageRepsPerActiveDay, 30);
    });

    test('is empty-safe', () {
      final totals = StatsEngine.totals(activity: const []);
      expect(totals.totalReps, 0);
      expect(totals.averageRepsPerActiveDay, 0);
      expect(totals.averageDurationPerActiveDay, 0);
    });

    test('tracks the best single day', () {
      final totals = StatsEngine.totals(
        activity: [
          ActivityPoint(day: today, workoutCount: 1, reps: 40),
          ActivityPoint(day: today.previous, workoutCount: 1, reps: 95),
        ],
      );
      expect(totals.bestDayValue, 95);
    });
  });

  group('weekdayDistribution', () {
    test('counts active days per weekday', () {
      // 2026-08-12 is a Wednesday (weekday 3).
      final dist = StatsEngine.weekdayDistribution([
        ActivityPoint(day: today, workoutCount: 1),
        ActivityPoint(day: today.addDays(-7), workoutCount: 1),
        ActivityPoint(day: today.addDays(-1), workoutCount: 0),
      ]);
      expect(dist[3], 2);
      expect(dist[2], 0);
      expect(dist.keys.length, 7);
    });
  });

  group('momentum', () {
    test('is null when the earlier half is empty', () {
      final dense = [
        ActivityPoint(day: today.addDays(-3)),
        ActivityPoint(day: today.addDays(-2)),
        ActivityPoint(day: today.previous, reps: 10, workoutCount: 1),
        ActivityPoint(day: today, reps: 10, workoutCount: 1),
      ];
      expect(StatsEngine.momentum(dense), isNull);
    });

    test('is null for very short series', () {
      expect(StatsEngine.momentum([ActivityPoint(day: today)]), isNull);
    });

    test('reports a positive percentage when volume rises', () {
      final dense = [
        ActivityPoint(day: today.addDays(-3), reps: 10, workoutCount: 1),
        ActivityPoint(day: today.addDays(-2), reps: 10, workoutCount: 1),
        ActivityPoint(day: today.previous, reps: 15, workoutCount: 1),
        ActivityPoint(day: today, reps: 15, workoutCount: 1),
      ];
      expect(StatsEngine.momentum(dense), closeTo(50, 0.001));
    });
  });
}
