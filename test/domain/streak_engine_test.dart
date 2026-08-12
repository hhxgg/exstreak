import 'package:exstreak/core/day.dart';
import 'package:exstreak/domain/streak/streak_engine.dart';
import 'package:flutter_test/flutter_test.dart';

/// 2026-08-12 is a Wednesday; every case is anchored to it so the weekday
/// windows are deterministic.
const Day today = Day(2026, 8, 12);

Set<Day> daysBack(int count, {Day from = today}) => {
  for (var i = 0; i < count; i++) from.addDays(-i),
};

void main() {
  group('current streak', () {
    test('is zero with no history', () {
      final s = StreakEngine.compute(activeDays: const {}, today: today);
      expect(s.current, 0);
      expect(s.longest, 0);
      expect(s.trainedToday, isFalse);
      expect(s.isAtRisk, isFalse);
    });

    test('counts the first workout as a one-day streak', () {
      final s = StreakEngine.compute(activeDays: {today}, today: today);
      expect(s.current, 1);
      expect(s.longest, 1);
      expect(s.trainedToday, isTrue);
      expect(s.streakStartDay, today);
    });

    test('counts consecutive days ending today', () {
      final s = StreakEngine.compute(activeDays: daysBack(5), today: today);
      expect(s.current, 5);
      expect(s.streakStartDay, today.addDays(-4));
    });

    test('survives today until midnight when yesterday was active', () {
      // Trained through yesterday, nothing yet today: the run is intact but
      // at risk, not broken.
      final active = daysBack(4, from: today.previous);
      final s = StreakEngine.compute(activeDays: active, today: today);
      expect(s.current, 4);
      expect(s.trainedToday, isFalse);
      expect(s.isAtRisk, isTrue);
    });

    test('breaks after a full missed day', () {
      // Last trained two days ago — yesterday was missed entirely.
      final active = daysBack(3, from: today.addDays(-2));
      final s = StreakEngine.compute(activeDays: active, today: today);
      expect(s.current, 0);
      expect(s.longest, 3);
      expect(s.isAtRisk, isFalse);
    });

    test('multiple workouts on one day still count as one day', () {
      // The engine takes a set of days, so duplicates collapse by construction.
      final s = StreakEngine.compute(
        activeDays: {today, today, today.previous},
        today: today,
      );
      expect(s.current, 2);
      expect(s.totalActiveDays, 2);
    });

    test('ignores days in the future', () {
      // A device clock jumped forward and back; tomorrow must not count.
      final s = StreakEngine.compute(
        activeDays: {today, today.next, today.addDays(5)},
        today: today,
      );
      expect(s.current, 1);
      expect(s.totalActiveDays, 1);
    });
  });

  group('longest streak', () {
    test('finds the best historical run, not just the current one', () {
      final active = <Day>{
        // A ten-day run a while back.
        for (var i = 0; i < 10; i++) today.addDays(-40 + i),
        // A three-day run ending today.
        today.addDays(-2),
        today.previous,
        today,
      };
      final s = StreakEngine.compute(activeDays: active, today: today);
      expect(s.current, 3);
      expect(s.longest, 10);
    });

    test('never reports a longest shorter than the current run', () {
      final s = StreakEngine.compute(activeDays: daysBack(12), today: today);
      expect(s.longest, 12);
      expect(s.isRecord, isTrue);
    });
  });

  group('freezes', () {
    test('bridge a single missed day', () {
      final active = {
        today,
        today.addDays(-2),
        today.addDays(-3),
        today.addDays(-4),
      };
      final s = StreakEngine.compute(
        activeDays: active,
        freezeDays: {today.previous},
        today: today,
      );
      expect(s.current, 5);
    });

    test('do not manufacture a streak on their own', () {
      // A freeze with no workout anywhere in the run is not a streak.
      final s = StreakEngine.compute(
        activeDays: const {},
        freezeDays: {today, today.previous},
        today: today,
      );
      expect(s.current, 0);
    });

    test('a freeze on a day that was trained is ignored', () {
      final s = StreakEngine.compute(
        activeDays: {today, today.previous},
        freezeDays: {today},
        today: today,
      );
      expect(s.current, 2);
      expect(s.totalActiveDays, 2);
    });

    test('missedDaysSince lists the gap oldest first', () {
      final qualifying = {today.addDays(-4), today.addDays(-5)};
      final missed = StreakEngine.missedDaysSince(
        qualifyingDays: qualifying,
        today: today,
      );
      expect(missed, [
        today.addDays(-3),
        today.addDays(-2),
        today.addDays(-1),
      ]);
    });

    test('missedDaysSince is empty when yesterday was active', () {
      final missed = StreakEngine.missedDaysSince(
        qualifyingDays: {today.previous},
        today: today,
      );
      expect(missed, isEmpty);
    });

    test('missedDaysSince is empty with no history at all', () {
      expect(
        StreakEngine.missedDaysSince(qualifyingDays: const {}, today: today),
        isEmpty,
      );
    });

    test('freezesEarned grants one per fortnight, capped at two', () {
      expect(StreakEngine.freezesEarned(0), 0);
      expect(StreakEngine.freezesEarned(13), 0);
      expect(StreakEngine.freezesEarned(14), 1);
      expect(StreakEngine.freezesEarned(28), 2);
      expect(StreakEngine.freezesEarned(200), 2);
    });

    test('daysUntilNextFreeze counts down within the cycle', () {
      expect(StreakEngine.daysUntilNextFreeze(0), 14);
      expect(StreakEngine.daysUntilNextFreeze(1), 13);
      expect(StreakEngine.daysUntilNextFreeze(13), 1);
      expect(StreakEngine.daysUntilNextFreeze(14), 14);
    });
  });

  group('consistency windows', () {
    test('weekly consistency covers the trailing seven days', () {
      final s = StreakEngine.compute(activeDays: daysBack(3), today: today);
      expect(s.activeDaysThisWeek, 3);
      expect(s.weeklyConsistency, closeTo(3 / 7, 0.001));
    });

    test('monthly consistency uses elapsed days, not the whole month', () {
      // Trained on the 10th, 11th and 12th of a 12-day-old month.
      final s = StreakEngine.compute(
        activeDays: {
          const Day(2026, 8, 10),
          const Day(2026, 8, 11),
          const Day(2026, 8, 12),
        },
        today: today,
      );
      expect(s.daysInMonthSoFar, 12);
      expect(s.activeDaysThisMonth, 3);
      expect(s.monthlyConsistency, closeTo(3 / 12, 0.001));
    });

    test('days before the first workout are not counted as missed', () {
      // Started only two days ago, so the previous 28 days are not "missed".
      final s = StreakEngine.compute(
        activeDays: {today, today.previous},
        today: today,
      );
      expect(s.missedDaysLast30, 0);
    });

    test('counts genuine gaps as missed days', () {
      final s = StreakEngine.compute(
        activeDays: {today, today.addDays(-5)},
        today: today,
      );
      // Days -4, -3, -2 and -1 were missed after training started.
      expect(s.missedDaysLast30, 4);
    });
  });

  group('long absences', () {
    test('a month away resets the current streak but keeps the record', () {
      final active = daysBack(20, from: today.addDays(-30));
      final s = StreakEngine.compute(activeDays: active, today: today);
      expect(s.current, 0);
      expect(s.longest, 20);
      expect(s.lastActiveDay, today.addDays(-30));
    });
  });
}
