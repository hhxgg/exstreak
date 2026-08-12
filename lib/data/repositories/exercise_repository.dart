import 'package:drift/drift.dart';

import '../../domain/enums.dart';
import '../database.dart';

/// Filters applied to the exercise library screen.
class ExerciseFilter {
  const ExerciseFilter({
    this.query = '',
    this.muscleGroup,
    this.equipment,
    this.difficulty,
    this.favouritesOnly = false,
    this.customOnly = false,
  });

  final String query;
  final MuscleGroup? muscleGroup;
  final Equipment? equipment;
  final Difficulty? difficulty;
  final bool favouritesOnly;
  final bool customOnly;

  bool get isActive =>
      query.trim().isNotEmpty ||
      muscleGroup != null ||
      equipment != null ||
      difficulty != null ||
      favouritesOnly ||
      customOnly;

  ExerciseFilter copyWith({
    String? query,
    MuscleGroup? muscleGroup,
    bool clearMuscleGroup = false,
    Equipment? equipment,
    bool clearEquipment = false,
    Difficulty? difficulty,
    bool clearDifficulty = false,
    bool? favouritesOnly,
    bool? customOnly,
  }) => ExerciseFilter(
    query: query ?? this.query,
    muscleGroup: clearMuscleGroup ? null : (muscleGroup ?? this.muscleGroup),
    equipment: clearEquipment ? null : (equipment ?? this.equipment),
    difficulty: clearDifficulty ? null : (difficulty ?? this.difficulty),
    favouritesOnly: favouritesOnly ?? this.favouritesOnly,
    customOnly: customOnly ?? this.customOnly,
  );

  bool matches(ExerciseRow e) {
    if (favouritesOnly && !e.isFavourite) return false;
    if (customOnly && !e.isCustom) return false;
    if (muscleGroup != null && e.muscleGroup != muscleGroup) return false;
    if (equipment != null && e.equipment != equipment) return false;
    if (difficulty != null && e.difficulty != difficulty) return false;

    final q = query.trim().toLowerCase();
    if (q.isEmpty) return true;
    return e.name.toLowerCase().contains(q) ||
        e.muscleGroup.label.toLowerCase().contains(q) ||
        e.equipment.label.toLowerCase().contains(q);
  }
}

/// Reads and writes the exercise catalogue.
class ExerciseRepository {
  ExerciseRepository(this._db);

  final AppDatabase _db;

  Stream<List<ExerciseRow>> watchAll() => _db.watchExercises();

  Future<List<ExerciseRow>> all({bool includeArchived = false}) =>
      _db.getExercises(includeArchived: includeArchived);

  Future<ExerciseRow?> byId(int id) => _db.exerciseById(id);

  Future<ExerciseRow?> bySlug(String slug) => _db.exerciseBySlug(slug);

  Future<void> toggleFavourite(ExerciseRow row) =>
      _db.setExerciseFavourite(row.id, !row.isFavourite);

  Future<int> createCustom({
    required String name,
    required MuscleGroup muscleGroup,
    required Equipment equipment,
    required Difficulty difficulty,
    required TrackingType trackingType,
    String description = '',
    List<String> instructions = const [],
    String iconName = 'dumbbell',
    int defaultRestSeconds = 90,
    double intensityFactor = 1.0,
  }) {
    return _db.insertExercise(
      ExercisesCompanion.insert(
        name: name.trim(),
        muscleGroup: muscleGroup,
        equipment: equipment,
        difficulty: difficulty,
        trackingType: trackingType,
        description: Value(description.trim()),
        instructions: Value(instructions.join('\n')),
        iconName: Value(iconName),
        isBodyweight: Value(equipment == Equipment.none),
        intensityFactor: Value(intensityFactor),
        defaultRestSeconds: Value(defaultRestSeconds),
        isCustom: const Value(true),
      ),
    );
  }

  Future<void> updateExercise(
    ExerciseRow original, {
    String? name,
    MuscleGroup? muscleGroup,
    Equipment? equipment,
    Difficulty? difficulty,
    TrackingType? trackingType,
    String? description,
    List<String>? instructions,
    String? iconName,
    int? defaultRestSeconds,
  }) {
    return _db.updateExercise(
      original.copyWith(
        name: name?.trim() ?? original.name,
        muscleGroup: muscleGroup ?? original.muscleGroup,
        equipment: equipment ?? original.equipment,
        difficulty: difficulty ?? original.difficulty,
        // Changing the tracking type of an exercise with history would make
        // its past sets unreadable, so it is only editable on custom entries.
        trackingType: original.isCustom
            ? (trackingType ?? original.trackingType)
            : original.trackingType,
        description: description?.trim() ?? original.description,
        instructions: instructions?.join('\n') ?? original.instructions,
        iconName: iconName ?? original.iconName,
        defaultRestSeconds: defaultRestSeconds ?? original.defaultRestSeconds,
      ),
    );
  }

  /// Archives or deletes, depending on whether history references the row.
  Future<void> remove(int id) => _db.removeExercise(id);

  Future<void> restore(int id) => _db.restoreExercise(id);
}
