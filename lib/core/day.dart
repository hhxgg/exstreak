import 'package:flutter/foundation.dart';

/// A calendar date with no time component and no timezone.
///
/// The streak system is defined in *local calendar days*, not instants. Storing
/// a `DateTime` and comparing it across a DST boundary or a timezone change
/// produces off-by-one streaks, so activity is keyed by [Day] instead.
///
/// Persisted as an `int` in the form `yyyyMMdd`, which sorts correctly and
/// survives timezone changes on the device.
@immutable
class Day implements Comparable<Day> {
  const Day(this.year, this.month, this.dayOfMonth);

  factory Day.fromDateTime(DateTime dt) => Day(dt.year, dt.month, dt.day);

  /// Today in the device's current local timezone.
  factory Day.today() => Day.fromDateTime(DateTime.now());

  /// Rebuilds a [Day] from its `yyyyMMdd` integer encoding.
  factory Day.fromEpochKey(int key) {
    assert(key > 10000000, 'Not a yyyyMMdd key: $key');
    return Day(key ~/ 10000, (key ~/ 100) % 100, key % 100);
  }

  final int year;
  final int month;
  final int dayOfMonth;

  /// `yyyyMMdd`. Monotonic, so it can be range-queried and ordered in SQL.
  int get key => year * 10000 + month * 100 + dayOfMonth;

  /// Local midnight at the start of this day.
  DateTime get startOfDay => DateTime(year, month, dayOfMonth);

  /// The instant just before the next day begins.
  DateTime get endOfDay => DateTime(year, month, dayOfMonth, 23, 59, 59, 999);

  /// 1 = Monday … 7 = Sunday.
  int get weekday => startOfDay.weekday;

  Day addDays(int days) =>
      Day.fromDateTime(DateTime(year, month, dayOfMonth + days));

  Day get previous => addDays(-1);

  Day get next => addDays(1);

  /// Monday of the week containing this day.
  Day get startOfWeek => addDays(-(weekday - 1));

  Day get startOfMonth => Day(year, month, 1);

  /// Whole days from [other] to this day. Negative when this day is earlier.
  ///
  /// Uses UTC internally so DST transitions cannot shift the result.
  int differenceInDays(Day other) {
    final a = DateTime.utc(year, month, dayOfMonth);
    final b = DateTime.utc(other.year, other.month, other.dayOfMonth);
    return a.difference(b).inDays;
  }

  bool isBefore(Day other) => key < other.key;

  bool isAfter(Day other) => key > other.key;

  bool get isToday => this == Day.today();

  bool get isInFuture => isAfter(Day.today());

  @override
  int compareTo(Day other) => key.compareTo(other.key);

  @override
  bool operator ==(Object other) => other is Day && other.key == key;

  @override
  int get hashCode => key.hashCode;

  @override
  String toString() =>
      '${year.toString().padLeft(4, '0')}-'
      '${month.toString().padLeft(2, '0')}-'
      '${dayOfMonth.toString().padLeft(2, '0')}';
}

/// Inclusive range of [Day]s, used for chart windows and calendar grids.
@immutable
class DayRange {
  const DayRange(this.start, this.end);

  /// The [count] days ending today (inclusive).
  factory DayRange.lastDays(int count, {Day? endingOn}) {
    final end = endingOn ?? Day.today();
    return DayRange(end.addDays(-(count - 1)), end);
  }

  final Day start;
  final Day end;

  int get length => end.differenceInDays(start) + 1;

  bool contains(Day day) => !day.isBefore(start) && !day.isAfter(end);

  Iterable<Day> get days sync* {
    var d = start;
    while (!d.isAfter(end)) {
      yield d;
      d = d.next;
    }
  }
}
