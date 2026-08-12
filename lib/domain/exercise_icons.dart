import 'package:flutter/material.dart';

/// Icon registry for exercises.
///
/// The database stores an icon *name*; this map turns it back into a `const`
/// [IconData]. Keeping every icon const is what lets `flutter build` tree-shake
/// the Material icon font — constructing `IconData(codePoint)` dynamically
/// would disable that and add roughly a megabyte to the bundle.
abstract final class ExerciseIcons {
  static const IconData fallback = Icons.fitness_center_rounded;

  static const Map<String, IconData> registry = {
    'dumbbell': Icons.fitness_center_rounded,
    'pushup': Icons.trending_down_rounded,
    'pullup': Icons.trending_up_rounded,
    'dip': Icons.swap_vert_rounded,
    'press': Icons.arrow_upward_rounded,
    'raise': Icons.open_in_full_rounded,
    'row': Icons.rowing_rounded,
    'squat': Icons.airline_seat_legroom_reduced_rounded,
    'lunge': Icons.directions_walk_rounded,
    'calf': Icons.escalator_rounded,
    'plank': Icons.horizontal_rule_rounded,
    'situp': Icons.self_improvement_rounded,
    'crunch': Icons.compress_rounded,
    'legraise': Icons.vertical_align_top_rounded,
    'twist': Icons.rotate_right_rounded,
    'bridge': Icons.architecture_rounded,
    'burpee': Icons.bolt_rounded,
    'climber': Icons.terrain_rounded,
    'jump': Icons.accessibility_new_rounded,
    'run': Icons.directions_run_rounded,
    'bike': Icons.directions_bike_rounded,
    'rope': Icons.all_inclusive_rounded,
    'wallsit': Icons.chair_rounded,
    'stretch': Icons.spa_rounded,
    'heart': Icons.favorite_rounded,
    'star': Icons.star_rounded,
    'flame': Icons.local_fire_department_rounded,
    'timer': Icons.timer_outlined,
  };

  static IconData resolve(String? name) => registry[name] ?? fallback;

  /// Ordered list offered in the custom-exercise icon picker.
  static List<MapEntry<String, IconData>> get pickerOptions =>
      registry.entries.toList(growable: false);
}
