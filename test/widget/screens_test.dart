import 'package:exstreak/core/branding.dart';
import 'package:exstreak/data/repositories/exercise_repository.dart';
import 'package:exstreak/domain/app_settings.dart';
import 'package:exstreak/domain/enums.dart';
import 'package:exstreak/screens/exercises/library_screen.dart';
import 'package:exstreak/screens/goals/goals_screen.dart';
import 'package:exstreak/screens/onboarding/onboarding_screen.dart';
import 'package:exstreak/screens/profile/profile_screen.dart';
import 'package:exstreak/screens/progress/progress_screen.dart';
import 'package:exstreak/screens/streaks/streaks_screen.dart';
import 'package:exstreak/state/providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../helpers/test_app.dart';

void main() {
  late TestEnv env;

  tearDown(() async => env.dispose());

  group('onboarding', () {
    testWidgets('opens on the welcome step', (tester) async {
      env = await TestEnv.create();
      await tester.pumpWidget(env.wrap(const OnboardingScreen()));
      await tester.pumpAndSettle();

      expect(find.text(Branding.appName), findsOneWidget);
      expect(find.text('Get started'), findsOneWidget);
      expect(find.text('1/6'), findsOneWidget);
    });

    testWidgets('advances to the name step', (tester) async {
      env = await TestEnv.create();
      await tester.pumpWidget(env.wrap(const OnboardingScreen()));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Get started'));
      await tester.pumpAndSettle();

      expect(find.text('What should we call you?'), findsOneWidget);
      expect(find.text('2/6'), findsOneWidget);
      expect(find.text('Continue'), findsOneWidget);
    });

    testWidgets('reaches the final step and offers to start', (tester) async {
      env = await TestEnv.create();
      await tester.pumpWidget(env.wrap(const OnboardingScreen()));
      await tester.pumpAndSettle();

      for (var i = 0; i < 5; i++) {
        final label = i == 0 ? 'Get started' : 'Continue';
        await tester.tap(find.text(label));
        await tester.pumpAndSettle();
      }

      expect(find.text('6/6'), findsOneWidget);
      expect(find.text('Start training'), findsOneWidget);
      expect(find.text('How often will you train?'), findsOneWidget);
    });
  });

  group('library', () {
    testWidgets('lists seeded exercises', (tester) async {
      env = await TestEnv.create(initialSettings: onboardedSettings);
      await tester.pumpWidget(env.wrap(const LibraryScreen()));
      await tester.pumpAndSettle();

      expect(find.text('Exercise library'), findsOneWidget);
      expect(find.text('Push-ups'), findsOneWidget);
    });

    testWidgets('search narrows the list', (tester) async {
      env = await TestEnv.create(initialSettings: onboardedSettings);
      await tester.pumpWidget(env.wrap(const LibraryScreen()));
      await tester.pumpAndSettle();

      await tester.enterText(find.byType(TextField).first, 'plank');
      await tester.pumpAndSettle();

      expect(find.text('Plank'), findsOneWidget);
      expect(find.text('Push-ups'), findsNothing);
    });

    testWidgets('an unmatched search shows a helpful empty state', (
      tester,
    ) async {
      env = await TestEnv.create(initialSettings: onboardedSettings);
      await tester.pumpWidget(env.wrap(const LibraryScreen()));
      await tester.pumpAndSettle();

      await tester.enterText(find.byType(TextField).first, 'zzzzz');
      await tester.pumpAndSettle();

      expect(find.text('No exercises match'), findsOneWidget);
      expect(find.text('Clear filters'), findsOneWidget);
    });

    testWidgets('the "my exercises" chip filters to custom entries', (
      tester,
    ) async {
      env = await TestEnv.create(initialSettings: onboardedSettings);
      await tester.pumpWidget(env.wrap(const LibraryScreen()));
      await tester.pumpAndSettle();

      await tester.tap(find.text('My exercises'));
      await tester.pumpAndSettle();

      // Nothing custom exists yet, so the list empties out.
      expect(find.text('Push-ups'), findsNothing);
      expect(find.text('No exercises match'), findsOneWidget);
    });

    testWidgets('a muscle-group filter narrows the list', (tester) async {
      env = await TestEnv.create(initialSettings: onboardedSettings);
      await tester.pumpWidget(env.wrap(const LibraryScreen()));
      await tester.pumpAndSettle();

      // The chip lives in a horizontally scrolling row; driving the filter
      // through its provider keeps the test about filtering, not scrolling.
      env.container.read(exerciseFilterProvider.notifier).state =
          const ExerciseFilter(muscleGroup: MuscleGroup.core);
      await tester.pumpAndSettle();

      expect(find.text('Plank'), findsOneWidget);
      expect(find.text('Push-ups'), findsNothing);
    });
  });

  group('streaks', () {
    testWidgets('shows a zero streak and the rules for a new user', (
      tester,
    ) async {
      // A tall viewport renders the whole page, so the assertions below do not
      // depend on scroll mechanics.
      await tester.binding.setSurfaceSize(const Size(420, 2200));
      addTearDown(() => tester.binding.setSurfaceSize(null));

      env = await TestEnv.create(initialSettings: onboardedSettings);
      await tester.pumpWidget(env.wrap(const StreaksScreen()));
      await tester.pumpAndSettle();

      expect(find.text('Streaks'), findsOneWidget);
      expect(find.text('Start your streak today'), findsOneWidget);
      expect(find.text('Streak protection'), findsOneWidget);
      // SectionHeader renders its title in caps.
      expect(find.text('HOW STREAKS WORK'), findsOneWidget);
      expect(find.text('CONSISTENCY'), findsOneWidget);
      expect(find.text('CALENDAR'), findsOneWidget);
    });
  });

  group('progress', () {
    testWidgets('shows an empty state before any workout', (tester) async {
      env = await TestEnv.create(initialSettings: onboardedSettings);
      await tester.pumpWidget(env.wrap(const ProgressScreen()));
      await tester.pumpAndSettle();

      expect(find.text('Progress'), findsOneWidget);
      expect(find.text('No data yet'), findsOneWidget);
    });

    testWidgets('the history tab has its own empty state', (tester) async {
      env = await TestEnv.create(initialSettings: onboardedSettings);
      await tester.pumpWidget(env.wrap(const ProgressScreen()));
      await tester.pumpAndSettle();

      await tester.tap(find.text('History'));
      await tester.pumpAndSettle();

      expect(find.text('No sessions yet'), findsOneWidget);
    });
  });

  group('goals', () {
    testWidgets('shows an empty state with a call to action', (tester) async {
      env = await TestEnv.create(initialSettings: onboardedSettings);
      await tester.pumpWidget(env.wrap(const GoalsScreen()));
      await tester.pumpAndSettle();

      expect(find.text('No goals yet'), findsOneWidget);
      expect(find.text('Create a goal'), findsOneWidget);
    });
  });

  group('profile', () {
    testWidgets('shows the name, motto placeholder and badge case', (
      tester,
    ) async {
      env = await TestEnv.create(initialSettings: onboardedSettings);
      await tester.pumpWidget(env.wrap(const ProfileScreen()));
      await tester.pumpAndSettle();

      expect(find.text('Sam'), findsOneWidget);
      expect(find.text('Add your personal motto.'), findsOneWidget);
      expect(find.text('My badges'), findsOneWidget);
      expect(find.text('Streaks'), findsOneWidget);
    });

    testWidgets('locked badges are shown alongside earned ones', (
      tester,
    ) async {
      env = await TestEnv.create(initialSettings: onboardedSettings);
      await tester.pumpWidget(env.wrap(const ProfileScreen()));
      await tester.pumpAndSettle();

      expect(find.text('First step'), findsOneWidget);
      expect(find.byIcon(Icons.lock_rounded), findsWidgets);
    });
  });

  group('settings persistence', () {
    testWidgets('a settings change is written through to storage', (
      tester,
    ) async {
      env = await TestEnv.create(initialSettings: onboardedSettings);

      await env.container
          .read(settingsProvider.notifier)
          .update((s) => s.copyWith(motto: 'No zero days', weeklyTarget: 6));

      // A fresh read of the repository sees the change, as a relaunch would.
      final reloaded = env.settings.load();
      expect(reloaded.motto, 'No zero days');
      expect(reloaded.weeklyTarget, 6);
      expect(reloaded.hasCompletedOnboarding, isTrue);
    });

    testWidgets('malformed stored settings fall back to defaults', (
      tester,
    ) async {
      env = await TestEnv.create();
      // Simulates a partially written or downgraded preferences file.
      final fallback = AppSettings.fromJson({
        'weeklyTarget': 'not-a-number',
        'themeMode': 'nonsense',
        'reminderHour': 99,
      });

      expect(fallback.weeklyTarget, 4);
      expect(fallback.themeMode, AppThemeMode.dark);
      expect(fallback.reminderHour, 23);
      expect(fallback.hasCompletedOnboarding, isFalse);
    });
  });
}
