import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'screens/exercises/exercise_detail_screen.dart';
import 'screens/exercises/exercise_editor_screen.dart';
import 'screens/exercises/library_screen.dart';
import 'screens/goals/goal_editor_screen.dart';
import 'screens/goals/goals_screen.dart';
import 'screens/history/workout_detail_screen.dart';
import 'screens/home/home_screen.dart';
import 'screens/onboarding/onboarding_screen.dart';
import 'screens/profile/profile_screen.dart';
import 'screens/progress/exercise_progress_screen.dart';
import 'screens/progress/progress_screen.dart';
import 'screens/settings/about_screen.dart';
import 'screens/settings/data_screen.dart';
import 'screens/settings/notifications_screen.dart';
import 'screens/settings/settings_screen.dart';
import 'screens/settings/workout_prefs_screen.dart';
import 'screens/shell/app_shell.dart';
import 'screens/streaks/streaks_screen.dart';
import 'screens/workout/active_workout_screen.dart';
import 'screens/workout/free_practice_screen.dart';
import 'screens/workout/plan_picker_screen.dart';
import 'screens/workout/workout_builder_screen.dart';
import 'screens/workout/workout_summary_screen.dart';
import 'state/providers.dart';

/// Route path constants, so navigation calls never hard-code strings.
abstract final class Routes {
  static const String onboarding = '/onboarding';

  static const String home = '/home';
  static const String library = '/library';
  static const String streaks = '/streaks';
  static const String progress = '/progress';
  static const String profile = '/profile';

  static const String planPicker = '/workout/plan';
  static const String builder = '/workout/builder';
  static const String freePractice = '/workout/free';
  static const String activeWorkout = '/workout/active';

  static String workoutSummary(int id) => '/workout/summary/$id';
  static String exercise(int id) => '/exercise/$id';
  static const String newExercise = '/exercise/new';
  static String editExercise(int id) => '/exercise/$id/edit';
  static String exerciseProgress(int id) => '/progress/exercise/$id';
  static String workoutDetail(int id) => '/history/$id';

  static const String goals = '/goals';
  static const String newGoal = '/goals/new';
  static String editGoal(int id) => '/goals/$id/edit';

  static const String settings = '/settings';
  static const String settingsNotifications = '/settings/notifications';
  static const String settingsWorkout = '/settings/workout';
  static const String settingsData = '/settings/data';
  static const String about = '/settings/about';
}

final _rootKey = GlobalKey<NavigatorState>(debugLabel: 'root');

final routerProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    navigatorKey: _rootKey,
    initialLocation: Routes.home,
    debugLogDiagnostics: false,
    redirect: (context, state) {
      final onboarded = ref.read(settingsProvider).hasCompletedOnboarding;
      final atOnboarding = state.matchedLocation == Routes.onboarding;

      if (!onboarded && !atOnboarding) return Routes.onboarding;
      if (onboarded && atOnboarding) return Routes.home;
      return null;
    },
    routes: [
      GoRoute(
        path: Routes.onboarding,
        builder: (context, state) => const OnboardingScreen(),
      ),

      // ---- bottom-navigation shell ------------------------------------
      StatefulShellRoute.indexedStack(
        builder: (context, state, shell) => AppShell(shell: shell),
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: Routes.home,
                builder: (context, state) => const HomeScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: Routes.library,
                builder: (context, state) => const LibraryScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: Routes.streaks,
                builder: (context, state) => const StreaksScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: Routes.progress,
                builder: (context, state) => const ProgressScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: Routes.profile,
                builder: (context, state) => const ProfileScreen(),
              ),
            ],
          ),
        ],
      ),

      // ---- full-screen routes -----------------------------------------
      GoRoute(
        path: Routes.planPicker,
        parentNavigatorKey: _rootKey,
        builder: (context, state) => const PlanPickerScreen(),
      ),
      GoRoute(
        path: Routes.builder,
        parentNavigatorKey: _rootKey,
        builder: (context, state) => const WorkoutBuilderScreen(),
      ),
      GoRoute(
        path: Routes.freePractice,
        parentNavigatorKey: _rootKey,
        builder: (context, state) => const FreePracticeScreen(),
      ),
      GoRoute(
        path: Routes.activeWorkout,
        parentNavigatorKey: _rootKey,
        builder: (context, state) {
          final id = state.extra;
          return ActiveWorkoutScreen(workoutId: id is int ? id : null);
        },
      ),
      GoRoute(
        path: '/workout/summary/:id',
        parentNavigatorKey: _rootKey,
        builder: (context, state) => WorkoutSummaryScreen(
          workoutId: _intParam(state, 'id'),
          result: state.extra,
        ),
      ),
      GoRoute(
        path: Routes.newExercise,
        parentNavigatorKey: _rootKey,
        builder: (context, state) => const ExerciseEditorScreen(),
      ),
      GoRoute(
        path: '/exercise/:id/edit',
        parentNavigatorKey: _rootKey,
        builder: (context, state) =>
            ExerciseEditorScreen(exerciseId: _intParam(state, 'id')),
      ),
      GoRoute(
        path: '/exercise/:id',
        parentNavigatorKey: _rootKey,
        builder: (context, state) =>
            ExerciseDetailScreen(exerciseId: _intParam(state, 'id')),
      ),
      GoRoute(
        path: '/progress/exercise/:id',
        parentNavigatorKey: _rootKey,
        builder: (context, state) =>
            ExerciseProgressScreen(exerciseId: _intParam(state, 'id')),
      ),
      GoRoute(
        path: '/history/:id',
        parentNavigatorKey: _rootKey,
        builder: (context, state) =>
            WorkoutDetailScreen(workoutId: _intParam(state, 'id')),
      ),
      GoRoute(
        path: Routes.goals,
        parentNavigatorKey: _rootKey,
        builder: (context, state) => const GoalsScreen(),
      ),
      GoRoute(
        path: Routes.newGoal,
        parentNavigatorKey: _rootKey,
        builder: (context, state) => const GoalEditorScreen(),
      ),
      GoRoute(
        path: '/goals/:id/edit',
        parentNavigatorKey: _rootKey,
        builder: (context, state) =>
            GoalEditorScreen(goalId: _intParam(state, 'id')),
      ),
      GoRoute(
        path: Routes.settings,
        parentNavigatorKey: _rootKey,
        builder: (context, state) => const SettingsScreen(),
      ),
      GoRoute(
        path: Routes.settingsNotifications,
        parentNavigatorKey: _rootKey,
        builder: (context, state) => const NotificationsScreen(),
      ),
      GoRoute(
        path: Routes.settingsWorkout,
        parentNavigatorKey: _rootKey,
        builder: (context, state) => const WorkoutPrefsScreen(),
      ),
      GoRoute(
        path: Routes.settingsData,
        parentNavigatorKey: _rootKey,
        builder: (context, state) => const DataScreen(),
      ),
      GoRoute(
        path: Routes.about,
        parentNavigatorKey: _rootKey,
        builder: (context, state) => const AboutScreen(),
      ),
    ],
    errorBuilder: (context, state) => _RouteErrorScreen(
      message: state.error?.toString() ?? 'That screen could not be opened.',
    ),
  );
});

/// A malformed id in a deep link must not throw — fall back to 0, which the
/// destination screens render as a friendly "not found" state.
int _intParam(GoRouterState state, String name) =>
    int.tryParse(state.pathParameters[name] ?? '') ?? 0;

class _RouteErrorScreen extends StatelessWidget {
  const _RouteErrorScreen({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Something went wrong')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.error_outline_rounded, size: 48),
              const SizedBox(height: 16),
              Text(message, textAlign: TextAlign.center),
              const SizedBox(height: 24),
              FilledButton(
                onPressed: () => context.go(Routes.home),
                child: const Text('Back to home'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
