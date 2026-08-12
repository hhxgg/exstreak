import 'package:exstreak/core/day.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Day', () {
    test('encodes and decodes yyyyMMdd keys', () {
      const day = Day(2026, 8, 12);
      expect(day.key, 20260812);
      expect(Day.fromEpochKey(20260812), day);
    });

    test('keys sort chronologically', () {
      final days = [
        const Day(2026, 1, 5),
        const Day(2025, 12, 31),
        const Day(2026, 1, 15),
      ]..sort();
      expect(days.map((d) => d.toString()), [
        '2025-12-31',
        '2026-01-05',
        '2026-01-15',
      ]);
    });

    test('addDays rolls over month and year boundaries', () {
      expect(const Day(2026, 1, 31).addDays(1), const Day(2026, 2, 1));
      expect(const Day(2026, 12, 31).addDays(1), const Day(2027, 1, 1));
      expect(const Day(2026, 3, 1).addDays(-1), const Day(2026, 2, 28));
    });

    test('handles leap years', () {
      expect(const Day(2028, 2, 28).next, const Day(2028, 2, 29));
      expect(const Day(2028, 2, 29).next, const Day(2028, 3, 1));
      expect(const Day(2026, 2, 28).next, const Day(2026, 3, 1));
    });

    test('differenceInDays is unaffected by DST shifts', () {
      // Late March is when most northern-hemisphere zones spring forward.
      const before = Day(2026, 3, 28);
      const after = Day(2026, 3, 30);
      expect(after.differenceInDays(before), 2);
      expect(before.differenceInDays(after), -2);
    });

    test('startOfWeek is Monday', () {
      // 2026-08-12 is a Wednesday.
      expect(const Day(2026, 8, 12).startOfWeek, const Day(2026, 8, 10));
      // A Monday is its own week start.
      expect(const Day(2026, 8, 10).startOfWeek, const Day(2026, 8, 10));
      // Sunday belongs to the week that started six days earlier.
      expect(const Day(2026, 8, 16).startOfWeek, const Day(2026, 8, 10));
    });

    test('equality and hashing work in sets and maps', () {
      // Built from separate instances so this exercises hashCode/== rather
      // than a compile-time constant literal being folded.
      final set = <Day>{}
        ..add(Day.fromDateTime(DateTime(2026, 8, 12)))
        ..add(Day.fromEpochKey(20260812))
        ..add(const Day(2026, 8, 12));
      expect(set.length, 1);

      final map = <Day, String>{const Day(2026, 8, 12): 'first'};
      map[Day.fromEpochKey(20260812)] = 'second';
      expect(map.length, 1);
      expect(map.values.single, 'second');
    });
  });

  group('DayRange', () {
    test('lastDays is inclusive of both ends', () {
      final range = DayRange.lastDays(7, endingOn: const Day(2026, 8, 12));
      expect(range.start, const Day(2026, 8, 6));
      expect(range.end, const Day(2026, 8, 12));
      expect(range.length, 7);
      expect(range.days.length, 7);
    });

    test('contains respects boundaries', () {
      final range = DayRange(const Day(2026, 8, 1), const Day(2026, 8, 31));
      expect(range.contains(const Day(2026, 8, 1)), isTrue);
      expect(range.contains(const Day(2026, 8, 31)), isTrue);
      expect(range.contains(const Day(2026, 7, 31)), isFalse);
      expect(range.contains(const Day(2026, 9, 1)), isFalse);
    });
  });
}
