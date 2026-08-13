import 'package:exstreak/domain/enums.dart';
import 'package:exstreak/domain/workout/workout_models.dart';
import 'package:exstreak/screens/workout/active_workout_screen.dart';
import 'package:exstreak/screens/workout/workout_summary_screen.dart';
import 'package:exstreak/state/providers.dart';
import 'package:exstreak/widgets/indicators.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

import '../helpers/test_app.dart';

/// Covers the live workout screen — the highest-risk flow in the app, and the
/// one that most needs verification given hardware testing is unavailable here.
void main() {
  late TestEnv env;

  setUp(installFakeWakelock);
  tearDown(() async => env.dispose());

  /// Creates a three-set push-up session and returns its id.
  Future<int> seedSession({
    List<int> targets = const [10, 8, 6],
    WorkoutSource source = WorkoutSource.custom,
  }) async {
    final pushup = (await env.database.exerciseBySlug('pushup'))!;
    return env.container
        .read(workoutRepositoryProvider)
        .createWorkout(
          WorkoutDraft(
            source: source,
            title: 'Test session',
            planId: source == WorkoutSource.plan ? 'pushup-100' : null,
            planLevel: source == WorkoutSource.plan ? 1 : null,
            planDay: source == WorkoutSource.plan ? 1 : null,
            exercises: [
              PlannedExercise(
                exerciseId: pushup.id,
                name: pushup.name,
                trackingType: pushup.trackingType,
                sets: [for (final t in targets) PlannedSet(target: t)],
              ),
            ],
          ),
        );
  }

  Widget routedWorkout(int id) => env.wrapRouted([
    // A home route so leaving the session has somewhere to land, mirroring
    // the real app where the session is pushed on top of the shell.
    GoRoute(
      path: '/home',
      builder: (context, state) =>
          const Scaffold(body: Center(child: Text('Home stub'))),
    ),
    GoRoute(
      path: '/',
      builder: (context, state) => ActiveWorkoutScreen(workoutId: id),
    ),
    GoRoute(
      path: '/workout/summary/:id',
      builder: (context, state) => WorkoutSummaryScreen(
        workoutId: int.parse(state.pathParameters['id']!),
        result: state.extra,
      ),
    ),
  ]);

  /// Taps the counter ring [times] times.
  Future<void> tapRing(WidgetTester tester, int times) async {
    for (var i = 0; i < times; i++) {
      await tester.tap(find.byType(ProgressRing));
      await tester.pump();
    }
  }

  /// Scrolls a target into view before tapping it.
  ///
  /// The counter and rest views scroll on short viewports, and a tap on an
  /// off-screen widget silently misses the hit test.
  Future<void> tapVisible(WidgetTester tester, Finder finder) async {
    await tester.ensureVisible(finder);
    await tester.pump();
    await tester.tap(finder);
    await tester.pump();
  }

  /// Advances time without waiting for the tree to go idle.
  ///
  /// `pumpAndSettle` cannot be used once a session starts finishing: the
  /// primary button shows an indeterminate spinner, which schedules frames
  /// forever by design.
  Future<void> settleBusy(WidgetTester tester) async {
    for (var i = 0; i < 12; i++) {
      await tester.pump(const Duration(milliseconds: 80));
    }
  }

  group('rendering', () {
    testWidgets('shows the exercise, set targets and the first target', (
      tester,
    ) async {
      env = await TestEnv.create(initialSettings: onboardedSettings);
      final id = await seedSession();

      await tester.pumpWidget(env.wrap(ActiveWorkoutScreen(workoutId: id)));
      await tester.pumpAndSettle();

      expect(find.text('Push-ups'), findsOneWidget);
      expect(find.text('REPS'), findsOneWidget);
      expect(find.text('Target 10'), findsOneWidget);
      // Three set chips carrying the targets.
      expect(find.text('10'), findsWidgets);
      expect(find.text('8'), findsOneWidget);
      expect(find.text('6'), findsOneWidget);
      expect(find.text('Done'), findsOneWidget);
    });

    testWidgets('a missing session shows a recoverable error state', (
      tester,
    ) async {
      env = await TestEnv.create(initialSettings: onboardedSettings);

      await tester.pumpWidget(
        env.wrap(const ActiveWorkoutScreen(workoutId: 987654)),
      );
      await tester.pumpAndSettle();

      expect(find.text('Session unavailable'), findsOneWidget);
      expect(find.text('Back to home'), findsOneWidget);
    });
  });

  group('counting', () {
    testWidgets('tapping the ring increments the counter', (tester) async {
      env = await TestEnv.create(initialSettings: onboardedSettings);
      final id = await seedSession();

      await tester.pumpWidget(env.wrap(ActiveWorkoutScreen(workoutId: id)));
      await tester.pumpAndSettle();

      await tapRing(tester, 3);
      expect(find.text('3'), findsWidgets);
    });

    testWidgets('long-pressing the ring undoes a rep', (tester) async {
      env = await TestEnv.create(initialSettings: onboardedSettings);
      final id = await seedSession();

      await tester.pumpWidget(env.wrap(ActiveWorkoutScreen(workoutId: id)));
      await tester.pumpAndSettle();

      await tapRing(tester, 4);
      await tester.longPress(find.byType(ProgressRing));
      await tester.pump();

      expect(find.text('Long-press the ring to undo a rep'), findsOneWidget);
      // 4 taps minus one undo.
      expect(find.text('3'), findsWidgets);
    });

    testWidgets('Done is disabled until at least one rep is logged', (
      tester,
    ) async {
      env = await TestEnv.create(initialSettings: onboardedSettings);
      final id = await seedSession();

      await tester.pumpWidget(env.wrap(ActiveWorkoutScreen(workoutId: id)));
      await tester.pumpAndSettle();

      // Tapping Done with zero reps must not complete a set.
      await tester.tap(find.text('Done'));
      await tester.pump(const Duration(milliseconds: 100));

      final sets = await env.database.setsForWorkout(id, completedOnly: true);
      expect(sets, isEmpty);
    });

    testWidgets('passing the target invites more reps rather than stopping', (
      tester,
    ) async {
      env = await TestEnv.create(initialSettings: onboardedSettings);
      final id = await seedSession(targets: const [2, 2, 2]);

      await tester.pumpWidget(env.wrap(ActiveWorkoutScreen(workoutId: id)));
      await tester.pumpAndSettle();

      await tapRing(tester, 3);
      expect(find.text('Target hit — squeeze out more'), findsOneWidget);
    });
  });

  group('completing a set', () {
    testWidgets('persists the reps and moves into rest', (tester) async {
      env = await TestEnv.create(initialSettings: onboardedSettings);
      final id = await seedSession();

      await tester.pumpWidget(env.wrap(ActiveWorkoutScreen(workoutId: id)));
      await tester.pumpAndSettle();

      await tapRing(tester, 11);
      await tester.tap(find.text('Done'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 200));

      // Written straight through, so a cold read sees it.
      final sets = await env.database.setsForWorkout(id, completedOnly: true);
      expect(sets, hasLength(1));
      expect(sets.single.$2.reps, 11);

      expect(find.text('Set complete'), findsOneWidget);
      expect(find.text('REST'), findsOneWidget);
      expect(find.text('Skip rest'), findsOneWidget);
    });

    testWidgets('skipping rest returns to counting on the next set', (
      tester,
    ) async {
      env = await TestEnv.create(initialSettings: onboardedSettings);
      final id = await seedSession();

      await tester.pumpWidget(env.wrap(ActiveWorkoutScreen(workoutId: id)));
      await tester.pumpAndSettle();

      await tapRing(tester, 10);
      await tester.tap(find.text('Done'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 200));

      await tapVisible(tester, find.text('Skip rest'));

      expect(find.text('REPS'), findsOneWidget);
      // The second set's target is now showing.
      expect(find.text('Target 8'), findsOneWidget);
      // The counter restarted.
      expect(find.text('Target hit — squeeze out more'), findsNothing);
    });

    testWidgets('the completed set chip switches to a tick', (tester) async {
      env = await TestEnv.create(initialSettings: onboardedSettings);
      final id = await seedSession();

      await tester.pumpWidget(env.wrap(ActiveWorkoutScreen(workoutId: id)));
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.check_rounded), findsNothing);

      await tapRing(tester, 10);
      await tester.tap(find.text('Done'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 200));

      expect(find.byIcon(Icons.check_rounded), findsWidgets);
    });
  });

  group('finishing', () {
    testWidgets('End & save completes the workout and opens the summary', (
      tester,
    ) async {
      env = await TestEnv.create(initialSettings: onboardedSettings);
      final id = await seedSession();

      await tester.pumpWidget(routedWorkout(id));
      await tester.pumpAndSettle();

      await tapRing(tester, 12);
      await tester.tap(find.text('Done'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 200));

      await tapVisible(tester, find.text('Skip rest'));

      await tester.tap(find.text('End & save'));
      await settleBusy(tester);

      final workout = await env.database.workoutById(id);
      expect(workout!.isCompleted, isTrue);
      expect(workout.totalReps, 12);

      // The summary took over.
      expect(find.text('WORKOUT COMPLETE'), findsOneWidget);
      expect(find.text('12'), findsWidgets);
    });

    testWidgets('finishing a first session starts the streak at one', (
      tester,
    ) async {
      env = await TestEnv.create(initialSettings: onboardedSettings);
      final id = await seedSession(targets: const [5]);

      await tester.pumpWidget(routedWorkout(id));
      await tester.pumpAndSettle();

      await tapRing(tester, 5);
      await tester.tap(find.text('Done'));
      await settleBusy(tester);

      final streak = await env.container
          .read(workoutRepositoryProvider)
          .computeStreak();
      expect(streak.current, 1);
      expect(streak.trainedToday, isTrue);
    });

    testWidgets('a plan session asks how it felt before saving', (
      tester,
    ) async {
      env = await TestEnv.create(initialSettings: onboardedSettings);
      final id = await seedSession(
        targets: const [5],
        source: WorkoutSource.plan,
      );

      await tester.pumpWidget(routedWorkout(id));
      await tester.pumpAndSettle();

      await tapRing(tester, 5);
      await tester.tap(find.text('Done'));
      await settleBusy(tester);

      expect(find.text('How did that feel?'), findsOneWidget);
      expect(find.text('Choose to continue'), findsOneWidget);

      await tester.tap(find.text('Just right'));
      await tester.pump();
      await tester.tap(find.text('Save & finish'));
      await settleBusy(tester);

      final workout = await env.database.workoutById(id);
      expect(workout!.isCompleted, isTrue);
      expect(workout.feedback, SessionFeedback.justRight);

      // "Just right" advances one plan day.
      final progress = await env.database.planProgress('pushup-100');
      expect(progress!.currentDay, 2);
    });

    testWidgets('an all-skipped session does not count as a training day', (
      tester,
    ) async {
      env = await TestEnv.create(initialSettings: onboardedSettings);
      final id = await seedSession(targets: const [5]);

      await tester.pumpWidget(routedWorkout(id));
      await tester.pumpAndSettle();

      // Skip the only exercise, which finishes the session with nothing logged.
      await tester.tap(find.text('Skip'));
      await settleBusy(tester);

      final streak = await env.container
          .read(workoutRepositoryProvider)
          .computeStreak();
      expect(streak.current, 0);
    });
  });

  group('cancelling', () {
    testWidgets('discarding a session with work asks first', (tester) async {
      env = await TestEnv.create(initialSettings: onboardedSettings);
      final id = await seedSession();

      await tester.pumpWidget(routedWorkout(id));
      await tester.pumpAndSettle();

      await tapRing(tester, 6);
      await tester.tap(find.text('Done'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 200));
      await tapVisible(tester, find.text('Skip rest'));

      await tester.tap(find.byIcon(Icons.close_rounded));
      await tester.pumpAndSettle();

      expect(find.text('Discard this session?'), findsOneWidget);
      expect(find.text('Keep going'), findsOneWidget);

      // Backing out leaves the session intact.
      await tester.tap(find.text('Keep going'));
      await tester.pumpAndSettle();

      expect(await env.database.workoutById(id), isNotNull);
    });
  });
}
