import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/branding.dart';
import 'core/day.dart';
import 'router.dart';
import 'state/providers.dart';
import 'theme/app_theme.dart';

/// Root widget: theme, router and the app-lifecycle housekeeping that keeps
/// streaks honest when the app has been in the background.
class ExStreakApp extends ConsumerStatefulWidget {
  const ExStreakApp({super.key});

  @override
  ConsumerState<ExStreakApp> createState() => _ExStreakAppState();
}

class _ExStreakAppState extends ConsumerState<ExStreakApp>
    with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    WidgetsBinding.instance.addPostFrameCallback((_) => _onResume());
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) _onResume();
  }

  /// Runs on every foreground transition.
  ///
  /// The app may have been closed for days, or open across midnight, so this
  /// re-reads the date, spends any freeze the user has earned on the days they
  /// missed, and re-arms the streak-risk notification.
  Future<void> _onResume() async {
    if (!mounted) return;

    final today = Day.today();
    if (ref.read(todayProvider) != today) {
      ref.read(todayProvider.notifier).state = today;
    }

    final settings = ref.read(settingsProvider);
    if (!settings.hasCompletedOnboarding) return;

    final workouts = ref.read(workoutRepositoryProvider);

    // 1. Spend freezes on any gap since the last qualifying day.
    if (settings.freezesAvailable > 0) {
      final spent = await workouts.applyFreezes(
        available: settings.freezesAvailable,
        today: today,
      );
      if (spent > 0 && mounted) {
        await ref
            .read(settingsProvider.notifier)
            .update(
              (s) => s.copyWith(
                freezesAvailable: (s.freezesAvailable - spent).clamp(0, 5),
              ),
            );
      }
    }

    if (!mounted) return;
    final streak = await workouts.computeStreak(today: today);
    if (!mounted) return;

    // 2. Grant a freeze at each 14-day milestone, at most two in reserve.
    final milestone = (streak.current ~/ 14) * 14;
    final current = ref.read(settingsProvider);
    if (milestone > 0 && milestone > current.freezeGrantedAtStreak) {
      await ref
          .read(settingsProvider.notifier)
          .update(
            (s) => s.copyWith(
              freezesAvailable: (s.freezesAvailable + 1).clamp(0, 2),
              freezeGrantedAtStreak: milestone,
            ),
          );
    }

    if (!mounted) return;

    // 3. Keep goal progress current even if the change came from elsewhere.
    await workouts.refreshGoals(today: today);

    if (!mounted) return;

    // 4. Re-arm reminders.
    final latest = ref.read(settingsProvider);
    final notifications = ref.read(notificationServiceProvider);
    if (latest.streakRiskReminderEnabled && !streak.trainedToday) {
      await notifications.scheduleStreakRiskAlert(
        currentStreak: streak.current,
      );
    } else {
      await notifications.cancelStreakRiskAlert();
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeMode = ref.watch(themeModeProvider);
    final router = ref.watch(routerProvider);

    return MaterialApp.router(
      title: Branding.appName,
      debugShowCheckedModeBanner: false,
      routerConfig: router,
      theme: AppTheme.light(),
      darkTheme: AppTheme.dark(),
      themeMode: themeMode.material,
      builder: (context, child) {
        // Clamp text scaling so dense layouts stay usable at extreme settings
        // while still honouring the user's accessibility preference.
        final scale = MediaQuery.textScalerOf(
          context,
        ).scale(1).clamp(0.85, 1.35);
        return MediaQuery(
          data: MediaQuery.of(
            context,
          ).copyWith(textScaler: TextScaler.linear(scale)),
          child: child ?? const SizedBox.shrink(),
        );
      },
    );
  }
}
