import 'package:flutter/foundation.dart';

import '../../core/day.dart';

/// A day that counts toward the streak, and why it counts.
@immutable
class StreakDay {
  const StreakDay({required this.day, required this.isFreeze});

  final Day day;

  /// True when the day had no workout but was covered by a streak freeze.
  final bool isFreeze;
}

/// Everything the UI needs to describe the user's consistency.
@immutable
class StreakSummary {
  const StreakSummary({
    required this.current,
    required this.longest,
    required this.trainedToday,
    required this.lastActiveDay,
    required this.streakStartDay,
    required this.totalActiveDays,
    required this.activeDaysThisWeek,
    required this.activeDaysThisMonth,
    required this.daysInMonthSoFar,
    required this.missedDaysLast30,
  });

  const StreakSummary.empty()
    : current = 0,
      longest = 0,
      trainedToday = false,
      lastActiveDay = null,
      streakStartDay = null,
      totalActiveDays = 0,
      activeDaysThisWeek = 0,
      activeDaysThisMonth = 0,
      daysInMonthSoFar = 0,
      missedDaysLast30 = 0;

  /// Consecutive qualifying days ending today or yesterday.
  final int current;

  /// Longest run ever recorded.
  final int longest;

  /// Whether a workout has already been logged today.
  final bool trainedToday;

  final Day? lastActiveDay;

  /// First day of the current run, or null when [current] is 0.
  final Day? streakStartDay;

  final int totalActiveDays;
  final int activeDaysThisWeek;
  final int activeDaysThisMonth;
  final int daysInMonthSoFar;
  final int missedDaysLast30;

  /// The streak survives today but will break at midnight if nothing is logged.
  bool get isAtRisk => current > 0 && !trainedToday;

  /// True when today's workout extended the run to a new personal best.
  bool get isRecord => current > 0 && current >= longest;

  /// Fraction of the last seven days that were active, 0…1.
  double get weeklyConsistency => (activeDaysThisWeek / 7).clamp(0.0, 1.0);

  /// Fraction of the elapsed days this month that were active, 0…1.
  double get monthlyConsistency => daysInMonthSoFar == 0
      ? 0
      : (activeDaysThisMonth / daysInMonthSoFar).clamp(0.0, 1.0);
}

/// Pure streak arithmetic over a set of qualifying days.
///
/// Nothing here touches the database, the clock or the timezone: the caller
/// passes in the day set and what "today" is. That is what makes the awkward
/// cases — a session finished at 23:59, a flight across timezones, an app that
/// was closed for a week — testable rather than hopeful.
abstract final class StreakEngine {
  /// Builds a summary from the days on which the user qualified.
  ///
  /// [activeDays] are days with at least one completed workout. [freezeDays]
  /// are days with no workout that a freeze token has already been spent on;
  /// they bridge a run but never start one.
  static StreakSummary compute({
    required Set<Day> activeDays,
    Set<Day> freezeDays = const {},
    Day? today,
  }) {
    final now = today ?? Day.today();

    // A day in the future cannot count — a device clock rolled forward and
    // back would otherwise leave phantom days in the run.
    final active = activeDays.where((d) => !d.isAfter(now)).toSet();
    final freezes = freezeDays
        .where((d) => !d.isAfter(now) && !active.contains(d))
        .toSet();
    final qualifying = {...active, ...freezes};

    if (qualifying.isEmpty) return const StreakSummary.empty();

    final trainedToday = active.contains(now);
    final sorted = qualifying.toList()..sort();
    final lastActive = active.isEmpty ? null : (active.toList()..sort()).last;

    // --- current run -------------------------------------------------------
    // The streak is not broken by "today, not yet". It breaks once a whole day
    // has passed with nothing logged, so counting may start at yesterday.
    Day? cursor;
    if (qualifying.contains(now)) {
      cursor = now;
    } else if (qualifying.contains(now.previous)) {
      cursor = now.previous;
    }

    var current = 0;
    Day? streakStart;
    while (cursor != null && qualifying.contains(cursor)) {
      current++;
      streakStart = cursor;
      cursor = cursor.previous;
    }

    // A run made only of freeze days is not a streak — a freeze preserves
    // progress, it does not manufacture it.
    if (current > 0 && streakStart != null) {
      final runHasWorkout = _rangeContainsActive(streakStart, now, active);
      if (!runHasWorkout) {
        current = 0;
        streakStart = null;
      }
    }

    // --- longest run -------------------------------------------------------
    var longest = 0;
    var run = 0;
    Day? runStart;
    Day? previous;
    for (final day in sorted) {
      if (previous != null && day.differenceInDays(previous) == 1) {
        run++;
      } else {
        run = 1;
        runStart = day;
      }
      if (runStart != null &&
          _rangeContainsActive(runStart, day, active) &&
          run > longest) {
        longest = run;
      }
      previous = day;
    }
    if (current > longest) longest = current;

    // --- windows -----------------------------------------------------------
    final weekWindow = DayRange.lastDays(7, endingOn: now);
    final activeThisWeek = weekWindow.days.where(qualifying.contains).length;

    final monthStart = now.startOfMonth;
    final monthWindow = DayRange(monthStart, now);
    final activeThisMonth = monthWindow.days.where(qualifying.contains).length;

    final last30 = DayRange.lastDays(30, endingOn: now);
    final firstEver = sorted.first;
    // Days before the user ever trained are not "missed".
    final missed = last30.days
        .where(
          (d) =>
              !d.isBefore(firstEver) &&
              !qualifying.contains(d) &&
              !(d == now && !trainedToday),
        )
        .length;

    return StreakSummary(
      current: current,
      longest: longest,
      trainedToday: trainedToday,
      lastActiveDay: lastActive,
      streakStartDay: streakStart,
      totalActiveDays: active.length,
      activeDaysThisWeek: activeThisWeek,
      activeDaysThisMonth: activeThisMonth,
      daysInMonthSoFar: monthWindow.length,
      missedDaysLast30: missed,
    );
  }

  static bool _rangeContainsActive(Day from, Day to, Set<Day> active) {
    var d = from;
    while (!d.isAfter(to)) {
      if (active.contains(d)) return true;
      d = d.next;
    }
    return false;
  }

  /// Days between the last qualifying day and [today], exclusive of both.
  ///
  /// These are the gaps a freeze can be spent on. Returned oldest-first.
  static List<Day> missedDaysSince({
    required Set<Day> qualifyingDays,
    required Day today,
  }) {
    if (qualifyingDays.isEmpty) return const [];
    final sorted = qualifyingDays.where((d) => d.isBefore(today)).toList()
      ..sort();
    if (sorted.isEmpty) return const [];

    final last = sorted.last;
    final gap = today.differenceInDays(last);
    if (gap <= 1) return const [];

    return [for (var i = 1; i < gap; i++) last.addDays(i)];
  }

  /// How many freeze tokens a run of [streakLength] days has earned in total.
  ///
  /// One token per [daysPerFreeze] consecutive days, capped at [maxFreezes].
  static int freezesEarned(
    int streakLength, {
    int daysPerFreeze = 14,
    int maxFreezes = 2,
  }) {
    if (streakLength <= 0) return 0;
    return (streakLength ~/ daysPerFreeze).clamp(0, maxFreezes);
  }

  /// Days remaining until the next freeze token is granted.
  static int daysUntilNextFreeze(int streakLength, {int daysPerFreeze = 14}) {
    if (daysPerFreeze <= 0) return 0;
    final remainder = streakLength % daysPerFreeze;
    return daysPerFreeze - remainder;
  }
}
