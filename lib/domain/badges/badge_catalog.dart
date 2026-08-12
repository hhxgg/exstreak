import 'package:flutter/material.dart';

/// Which section of the profile a badge belongs to.
enum BadgeCategory {
  streak,
  volume,
  maxRep,
  plank,
  special;

  String get label => switch (this) {
    BadgeCategory.streak => 'Streaks',
    BadgeCategory.volume => 'Volume',
    BadgeCategory.maxRep => 'Max reps',
    BadgeCategory.plank => 'Planks',
    BadgeCategory.special => 'Specials',
  };

  IconData get icon => switch (this) {
    BadgeCategory.streak => Icons.local_fire_department_rounded,
    BadgeCategory.volume => Icons.stacked_bar_chart_rounded,
    BadgeCategory.maxRep => Icons.bolt_rounded,
    BadgeCategory.plank => Icons.timer_outlined,
    BadgeCategory.special => Icons.auto_awesome_rounded,
  };
}

@immutable
class BadgeDef {
  const BadgeDef({
    required this.code,
    required this.category,
    required this.title,
    required this.description,
    required this.icon,
    required this.threshold,
  });

  final String code;
  final BadgeCategory category;
  final String title;
  final String description;
  final IconData icon;

  /// The value that must be reached, interpreted per category.
  final num threshold;
}

/// Every badge the app can award.
///
/// Awarding is driven entirely by this list, so adding an achievement needs no
/// new logic — see `BadgeEvaluator`.
abstract final class BadgeCatalog {
  static const List<BadgeDef> all = [
    // ---- streaks (threshold = consecutive days) --------------------------
    BadgeDef(
      code: 'streak_1',
      category: BadgeCategory.streak,
      title: 'First step',
      description: 'Complete your first workout',
      icon: Icons.play_arrow_rounded,
      threshold: 1,
    ),
    BadgeDef(
      code: 'streak_7',
      category: BadgeCategory.streak,
      title: '1 week',
      description: 'Train 7 days in a row',
      icon: Icons.local_fire_department_rounded,
      threshold: 7,
    ),
    BadgeDef(
      code: 'streak_14',
      category: BadgeCategory.streak,
      title: '2 weeks',
      description: 'Train 14 days in a row',
      icon: Icons.whatshot_rounded,
      threshold: 14,
    ),
    BadgeDef(
      code: 'streak_30',
      category: BadgeCategory.streak,
      title: '1 month',
      description: 'Train 30 days in a row',
      icon: Icons.calendar_month_rounded,
      threshold: 30,
    ),
    BadgeDef(
      code: 'streak_90',
      category: BadgeCategory.streak,
      title: '3 months',
      description: 'Train 90 days in a row',
      icon: Icons.event_available_rounded,
      threshold: 90,
    ),
    BadgeDef(
      code: 'streak_180',
      category: BadgeCategory.streak,
      title: '6 months',
      description: 'Train 180 days in a row',
      icon: Icons.workspace_premium_rounded,
      threshold: 180,
    ),

    // ---- max single set, rep-based (threshold = reps) --------------------
    BadgeDef(
      code: 'maxrep_25',
      category: BadgeCategory.maxRep,
      title: 'Max-rep 25',
      description: '25 reps in a single set',
      icon: Icons.filter_2_rounded,
      threshold: 25,
    ),
    BadgeDef(
      code: 'maxrep_50',
      category: BadgeCategory.maxRep,
      title: 'Max-rep 50',
      description: '50 reps in a single set',
      icon: Icons.filter_5_rounded,
      threshold: 50,
    ),
    BadgeDef(
      code: 'maxrep_75',
      category: BadgeCategory.maxRep,
      title: 'Max-rep 75',
      description: '75 reps in a single set',
      icon: Icons.filter_7_rounded,
      threshold: 75,
    ),
    BadgeDef(
      code: 'maxrep_100',
      category: BadgeCategory.maxRep,
      title: 'Max-rep 100',
      description: '100 reps in a single set',
      icon: Icons.emoji_events_rounded,
      threshold: 100,
    ),

    // ---- planks (threshold = seconds in one hold) ------------------------
    BadgeDef(
      code: 'plank_60',
      category: BadgeCategory.plank,
      title: '1 minute',
      description: 'Hold a plank for 1 minute',
      icon: Icons.timer_outlined,
      threshold: 60,
    ),
    BadgeDef(
      code: 'plank_120',
      category: BadgeCategory.plank,
      title: '2 minutes',
      description: 'Hold a plank for 2 minutes',
      icon: Icons.timer_outlined,
      threshold: 120,
    ),
    BadgeDef(
      code: 'plank_180',
      category: BadgeCategory.plank,
      title: '3 minutes',
      description: 'Hold a plank for 3 minutes',
      icon: Icons.timer_rounded,
      threshold: 180,
    ),
    BadgeDef(
      code: 'plank_240',
      category: BadgeCategory.plank,
      title: '4 minutes',
      description: 'Hold a plank for 4 minutes',
      icon: Icons.timer_rounded,
      threshold: 240,
    ),
    BadgeDef(
      code: 'plank_300',
      category: BadgeCategory.plank,
      title: '5 minutes',
      description: 'Hold a plank for 5 minutes',
      icon: Icons.military_tech_rounded,
      threshold: 300,
    ),
    BadgeDef(
      code: 'plank_360',
      category: BadgeCategory.plank,
      title: '6 minutes',
      description: 'Hold a plank for 6 minutes',
      icon: Icons.workspace_premium_rounded,
      threshold: 360,
    ),

    // ---- lifetime volume (threshold = total reps) ------------------------
    BadgeDef(
      code: 'volume_1000',
      category: BadgeCategory.volume,
      title: '1 000 reps',
      description: '1 000 reps logged all time',
      icon: Icons.bar_chart_rounded,
      threshold: 1000,
    ),
    BadgeDef(
      code: 'volume_5000',
      category: BadgeCategory.volume,
      title: '5 000 reps',
      description: '5 000 reps logged all time',
      icon: Icons.stacked_bar_chart_rounded,
      threshold: 5000,
    ),
    BadgeDef(
      code: 'volume_10000',
      category: BadgeCategory.volume,
      title: '10 000 reps',
      description: '10 000 reps logged all time',
      icon: Icons.insights_rounded,
      threshold: 10000,
    ),
    BadgeDef(
      code: 'workouts_50',
      category: BadgeCategory.volume,
      title: '50 workouts',
      description: 'Finish 50 sessions',
      icon: Icons.checklist_rounded,
      threshold: 50,
    ),

    // ---- specials --------------------------------------------------------
    BadgeDef(
      code: 'early_bird',
      category: BadgeCategory.special,
      title: 'Early bird',
      description: 'Finish a workout before 7:00',
      icon: Icons.wb_twilight_rounded,
      threshold: 7,
    ),
    BadgeDef(
      code: 'night_owl',
      category: BadgeCategory.special,
      title: 'Night owl',
      description: 'Finish a workout after 22:00',
      icon: Icons.nightlight_round,
      threshold: 22,
    ),
  ];

  static List<BadgeDef> byCategory(BadgeCategory category) =>
      all.where((b) => b.category == category).toList(growable: false);

  static BadgeDef? byCode(String code) {
    for (final b in all) {
      if (b.code == code) return b;
    }
    return null;
  }
}
