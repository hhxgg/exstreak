import 'package:intl/intl.dart';

import '../domain/enums.dart';
import 'day.dart';

/// Shared value formatting, so the same number never appears two ways.
abstract final class Fmt {
  /// `1 234` — thin-space grouping keeps big totals readable.
  static String count(num value) {
    final n = value.round();
    if (n.abs() < 1000) return '$n';
    return NumberFormat('#,###').format(n).replaceAll(',', ' ');
  }

  /// `12.3k` for axis labels and dense tiles.
  static String compact(num value) {
    final v = value.abs();
    if (v >= 1000000) return '${(value / 1000000).toStringAsFixed(1)}M';
    if (v >= 10000) return '${(value / 1000).round()}k';
    if (v >= 1000) return '${(value / 1000).toStringAsFixed(1)}k';
    return value.round().toString();
  }

  /// `4:05` or `45s`, whichever reads better.
  static String duration(int seconds) {
    if (seconds < 60) return '${seconds}s';
    final m = seconds ~/ 60;
    final s = seconds % 60;
    if (m < 60) return '$m:${s.toString().padLeft(2, '0')}';
    final h = m ~/ 60;
    return '${h}h ${(m % 60).toString().padLeft(2, '0')}m';
  }

  /// `4m 05s` — the long form used in totals.
  static String durationLong(int seconds) {
    if (seconds <= 0) return '0s';
    final h = seconds ~/ 3600;
    final m = (seconds % 3600) ~/ 60;
    final s = seconds % 60;
    if (h > 0) return '${h}h ${m}m';
    if (m > 0) return '${m}m ${s.toString().padLeft(2, '0')}s';
    return '${s}s';
  }

  /// `1:28` countdown display.
  static String clock(int seconds) {
    final safe = seconds < 0 ? 0 : seconds;
    final m = safe ~/ 60;
    final s = safe % 60;
    return '$m:${s.toString().padLeft(2, '0')}';
  }

  /// Weight in the user's chosen unit, without trailing `.0`.
  static String weight(double kg, UnitSystem units) {
    final value = units == UnitSystem.metric ? kg : kg / 0.453592;
    final rounded = value.round();
    final text = (value - rounded).abs() < 0.05
        ? '$rounded'
        : value.toStringAsFixed(1);
    return '$text ${units.weightUnit}';
  }

  static String height(double cm, UnitSystem units) {
    if (units == UnitSystem.metric) return '${cm.round()} cm';
    final inches = cm / 2.54;
    final feet = inches ~/ 12;
    final rest = (inches % 12).round();
    return "$feet'$rest\"";
  }

  /// Achieved value rendered in the exercise's own unit.
  static String trackedValue(int value, TrackingType type) => switch (type) {
    TrackingType.reps || TrackingType.repsWeight => '$value',
    TrackingType.duration => duration(value),
    TrackingType.distanceDuration => distance(value.toDouble()),
  };

  static String distance(double meters) {
    if (meters < 1000) return '${meters.round()} m';
    return '${(meters / 1000).toStringAsFixed(2)} km';
  }

  /// `Today`, `Yesterday`, `Mon 12 Aug` — the format history lists use.
  static String relativeDay(Day day) {
    final today = Day.today();
    final diff = today.differenceInDays(day);
    if (diff == 0) return 'Today';
    if (diff == 1) return 'Yesterday';
    if (diff > 1 && diff < 7) {
      return DateFormat.EEEE().format(day.startOfDay);
    }
    if (day.year == today.year) {
      return DateFormat('EEE d MMM').format(day.startOfDay);
    }
    return DateFormat('d MMM yyyy').format(day.startOfDay);
  }

  static String dayLong(Day day) =>
      DateFormat('EEEE, d MMMM y').format(day.startOfDay);

  static String monthYear(Day day) => DateFormat.yMMMM().format(day.startOfDay);

  static String time(DateTime dt) => DateFormat.Hm().format(dt);

  /// `Good morning` / `Good afternoon` / `Good evening`.
  static String greeting([DateTime? now]) {
    final hour = (now ?? DateTime.now()).hour;
    if (hour < 12) return 'Good morning';
    if (hour < 18) return 'Good afternoon';
    return 'Good evening';
  }

  /// Signed percentage, for momentum readouts.
  static String signedPercent(double value) {
    final rounded = value.round();
    return rounded >= 0 ? '+$rounded%' : '$rounded%';
  }
}
