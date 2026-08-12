import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/day.dart';
import '../data/database.dart';
import '../data/repositories/exercise_repository.dart';
import '../data/repositories/goal_repository.dart';
import '../data/repositories/settings_repository.dart';
import '../data/repositories/stats_repository.dart';
import '../data/repositories/workout_repository.dart';
import '../domain/app_settings.dart';
import '../domain/badges/badge_catalog.dart';
import '../domain/plan/plan_templates.dart';
import '../domain/stats/stats_engine.dart';
import '../domain/streak/streak_engine.dart';
import '../services/notification_service.dart';

// ---------------------------------------------------------------- overrides

/// Overridden in `main()` once the async singletons are ready.
final databaseProvider = Provider<AppDatabase>(
  (ref) => throw UnimplementedError('databaseProvider must be overridden'),
);

final settingsRepositoryProvider = Provider<SettingsRepository>(
  (ref) =>
      throw UnimplementedError('settingsRepositoryProvider must be overridden'),
);

final notificationServiceProvider = Provider<NotificationService>(
  (ref) => throw UnimplementedError(
    'notificationServiceProvider must be overridden',
  ),
);

// -------------------------------------------------------------- repositories

final exerciseRepositoryProvider = Provider<ExerciseRepository>(
  (ref) => ExerciseRepository(ref.watch(databaseProvider)),
);

final workoutRepositoryProvider = Provider<WorkoutRepository>(
  (ref) => WorkoutRepository(ref.watch(databaseProvider)),
);

final goalRepositoryProvider = Provider<GoalRepository>(
  (ref) => GoalRepository(ref.watch(databaseProvider)),
);

final statsRepositoryProvider = Provider<StatsRepository>(
  (ref) => StatsRepository(ref.watch(databaseProvider)),
);

// ------------------------------------------------------------------ settings

/// Holds [AppSettings] and writes through to storage on every change.
class SettingsController extends StateNotifier<AppSettings> {
  SettingsController(this._repo) : super(_repo.load());

  final SettingsRepository _repo;

  Future<void> update(AppSettings Function(AppSettings) mutate) async {
    state = mutate(state);
    await _repo.save(state);
  }

  Future<void> reset() async {
    await _repo.clear();
    state = const AppSettings();
  }
}

final settingsProvider = StateNotifierProvider<SettingsController, AppSettings>(
  (ref) => SettingsController(ref.watch(settingsRepositoryProvider)),
);

/// Convenience selector so widgets rebuild only on theme changes.
final themeModeProvider = Provider(
  (ref) => ref.watch(settingsProvider.select((s) => s.themeMode)),
);

final unitSystemProvider = Provider(
  (ref) => ref.watch(settingsProvider.select((s) => s.unitSystem)),
);

// --------------------------------------------------------------------- clock

/// Today's date, refreshed when the app resumes so a session left open across
/// midnight does not keep crediting yesterday.
final todayProvider = StateProvider<Day>((ref) => Day.today());

// ----------------------------------------------------------------- catalogue

final exercisesProvider = StreamProvider<List<ExerciseRow>>(
  (ref) => ref.watch(exerciseRepositoryProvider).watchAll(),
);

final archivedExercisesProvider = FutureProvider<List<ExerciseRow>>((
  ref,
) async {
  final all = await ref
      .watch(exerciseRepositoryProvider)
      .all(includeArchived: true);
  return all.where((e) => e.isArchived).toList();
});

final exerciseFilterProvider = StateProvider<ExerciseFilter>(
  (ref) => const ExerciseFilter(),
);

final filteredExercisesProvider = Provider<AsyncValue<List<ExerciseRow>>>((
  ref,
) {
  final filter = ref.watch(exerciseFilterProvider);
  return ref
      .watch(exercisesProvider)
      .whenData((list) => list.where(filter.matches).toList());
});

final exerciseByIdProvider = FutureProvider.family<ExerciseRow?, int>(
  (ref, id) => ref.watch(exerciseRepositoryProvider).byId(id),
);

// -------------------------------------------------------------------- streak

/// Recomputed whenever the daily-activity table changes, so every screen sees
/// the same streak without anyone having to remember to refresh.
final streakProvider = StreamProvider<StreakSummary>((ref) async* {
  final db = ref.watch(databaseProvider);
  final repo = ref.watch(workoutRepositoryProvider);
  final today = ref.watch(todayProvider);

  yield await repo.computeStreak(today: today);
  await for (final _ in db.watchActivity()) {
    yield await repo.computeStreak(today: today);
  }
});

/// How many freezes the user holds and when the next one arrives.
final freezeStatusProvider = Provider<({int available, int daysUntilNext})>((
  ref,
) {
  final settings = ref.watch(settingsProvider);
  final streak = ref.watch(streakProvider).valueOrNull;
  return (
    available: settings.freezesAvailable,
    daysUntilNext: StreakEngine.daysUntilNextFreeze(streak?.current ?? 0),
  );
});

// --------------------------------------------------------------------- stats

final activityProvider = StreamProvider<List<ActivityPoint>>((ref) async* {
  final db = ref.watch(databaseProvider);
  final stats = ref.watch(statsRepositoryProvider);

  yield await stats.allActivity();
  await for (final _ in db.watchActivity()) {
    yield await stats.allActivity();
  }
});

final statsWindowProvider = StateProvider<StatsWindow>(
  (ref) => StatsWindow.month,
);

final windowedActivityProvider = FutureProvider<List<ActivityPoint>>((
  ref,
) async {
  // Depend on the raw stream so the chart refreshes after a workout.
  ref.watch(activityProvider);
  final window = ref.watch(statsWindowProvider);
  return ref.watch(statsRepositoryProvider).activityWindow(window);
});

final lifetimeTotalsProvider = FutureProvider<TotalsSummary>((ref) async {
  ref.watch(activityProvider);
  return ref.watch(statsRepositoryProvider).lifetimeTotals();
});

final exercisesWithHistoryProvider = FutureProvider<List<ExerciseRow>>((
  ref,
) async {
  ref.watch(activityProvider);
  return ref.watch(statsRepositoryProvider).exercisesWithHistory();
});

final selectedProgressExerciseProvider = StateProvider<int?>((ref) => null);

final exerciseProgressProvider = FutureProvider.family<ExerciseProgress?, int>((
  ref,
  id,
) async {
  ref.watch(activityProvider);
  return ref.watch(statsRepositoryProvider).progressFor(id);
});

final personalRecordsProvider =
    FutureProvider<List<(ExerciseRow, PersonalRecordRow)>>((ref) async {
      ref.watch(activityProvider);
      return ref.watch(statsRepositoryProvider).allRecords();
    });

final muscleSplitProvider = FutureProvider((ref) async {
  ref.watch(activityProvider);
  return ref
      .watch(statsRepositoryProvider)
      .muscleSplit(ref.watch(statsWindowProvider));
});

// ------------------------------------------------------------------- history

final historyProvider = FutureProvider<List<WorkoutSummary>>((ref) async {
  ref.watch(activityProvider);
  return ref.watch(statsRepositoryProvider).history();
});

final workoutDetailProvider =
    FutureProvider.family<List<(WorkoutExerciseRow, List<SetRow>)>, int>(
      (ref, id) => ref.watch(statsRepositoryProvider).workoutDetail(id),
    );

final workoutRowProvider = FutureProvider.family<WorkoutRow?, int>(
  (ref, id) => ref.watch(statsRepositoryProvider).workoutById(id),
);

// --------------------------------------------------------------------- goals

final goalsProvider = StreamProvider<List<GoalView>>((ref) async* {
  final db = ref.watch(databaseProvider);
  final repo = ref.watch(goalRepositoryProvider);

  yield await repo.allWithExercises();
  await for (final _ in db.watchGoals()) {
    yield await repo.allWithExercises();
  }
});

// -------------------------------------------------------------------- badges

final earnedBadgesProvider = StreamProvider<Set<String>>((ref) async* {
  final db = ref.watch(databaseProvider);
  await for (final rows in db.watchBadges()) {
    yield {for (final r in rows) r.code};
  }
});

final badgeProgressProvider = Provider<({int earned, int total})>((ref) {
  final earned = ref.watch(earnedBadgesProvider).valueOrNull ?? const {};
  return (earned: earned.length, total: BadgeCatalog.all.length);
});

// ---------------------------------------------------------------------- plan

/// The plan the user is currently following, plus where they are in it.
final planProgressProvider =
    StreamProvider<({PlanTemplate template, int level, int day})>((ref) async* {
      final db = ref.watch(databaseProvider);
      final planId = ref.watch(settingsProvider.select((s) => s.activePlanId));
      final template = PlanTemplates.byId(planId) ?? PlanTemplates.pushups;

      Future<({PlanTemplate template, int level, int day})> read() async {
        final row = await db.planProgress(template.id);
        return (
          template: template,
          level: row?.level ?? 1,
          day: row?.currentDay ?? 1,
        );
      }

      yield await read();
      await for (final _ in db.watchPlanProgress()) {
        yield await read();
      }
    });

/// Progress for every plan, for the plan switcher.
final allPlanProgressProvider =
    StreamProvider<Map<String, ({int level, int day})>>((ref) async* {
      final db = ref.watch(databaseProvider);
      await for (final rows in db.watchPlanProgress()) {
        yield {
          for (final r in rows) r.planId: (level: r.level, day: r.currentDay),
        };
      }
    });

// ------------------------------------------------------------------ resuming

/// An unfinished session the user can pick back up.
final resumableWorkoutProvider = FutureProvider((ref) async {
  ref.watch(activityProvider);
  return ref.watch(workoutRepositoryProvider).resumableWorkout();
});

/// Invalidates the derived read models after a write.
///
/// Drift streams cover the tables they watch, but the `Future` providers built
/// on top of them need a nudge when a write touches several tables at once.
void refreshAll(WidgetRef ref) {
  ref.invalidate(historyProvider);
  ref.invalidate(lifetimeTotalsProvider);
  ref.invalidate(windowedActivityProvider);
  ref.invalidate(personalRecordsProvider);
  ref.invalidate(exercisesWithHistoryProvider);
  ref.invalidate(resumableWorkoutProvider);
  ref.invalidate(muscleSplitProvider);
}

/// Same as [refreshAll] but usable from a `Ref` outside the widget tree.
void refreshAllFromRef(Ref ref) {
  ref.invalidate(historyProvider);
  ref.invalidate(lifetimeTotalsProvider);
  ref.invalidate(windowedActivityProvider);
  ref.invalidate(personalRecordsProvider);
  ref.invalidate(exercisesWithHistoryProvider);
  ref.invalidate(resumableWorkoutProvider);
  ref.invalidate(muscleSplitProvider);
  if (kDebugMode) debugPrint('ExStreak: derived providers refreshed');
}
