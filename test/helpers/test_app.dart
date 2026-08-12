import 'package:drift/native.dart';
import 'package:exstreak/data/database.dart';
import 'package:exstreak/data/repositories/settings_repository.dart';
import 'package:exstreak/domain/app_settings.dart';
import 'package:exstreak/services/notification_service.dart';
import 'package:exstreak/state/providers.dart';
import 'package:exstreak/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Notification service that never touches a platform channel.
///
/// Widget tests have no Android runtime, so every method here short-circuits
/// rather than throwing MissingPluginException.
class FakeNotificationService extends NotificationService {
  FakeNotificationService() : super(FlutterLocalNotificationsPlugin());

  bool dailyScheduled = false;
  bool permissionGranted = true;

  @override
  Future<void> init() async {}

  @override
  Future<bool> requestPermission() async => permissionGranted;

  @override
  Future<bool> hasPermission() async => permissionGranted;

  @override
  Future<void> scheduleDailyReminder({
    required int hour,
    required int minute,
  }) async {
    dailyScheduled = true;
  }

  @override
  Future<void> scheduleStreakRiskAlert({
    required int currentStreak,
    int hour = 20,
    int minute = 30,
  }) async {}

  @override
  Future<void> cancelDailyReminder() async {
    dailyScheduled = false;
  }

  @override
  Future<void> cancelStreakRiskAlert() async {}

  @override
  Future<void> cancelAll() async {}
}

/// A ready-to-use test environment: in-memory database, seeded catalogue and
/// stubbed platform services.
class TestEnv {
  TestEnv._(this.database, this.settings, this.notifications, this.container);

  final AppDatabase database;
  final SettingsRepository settings;
  final FakeNotificationService notifications;
  final ProviderContainer container;

  static Future<TestEnv> create({AppSettings? initialSettings}) async {
    SharedPreferences.setMockInitialValues({});

    final database = AppDatabase.forTesting(NativeDatabase.memory());
    await database.syncSeedExercises();

    final settings = await SettingsRepository.open();
    if (initialSettings != null) await settings.save(initialSettings);

    final notifications = FakeNotificationService();

    final container = ProviderContainer(
      overrides: [
        databaseProvider.overrideWithValue(database),
        settingsRepositoryProvider.overrideWithValue(settings),
        notificationServiceProvider.overrideWithValue(notifications),
      ],
    );

    return TestEnv._(database, settings, notifications, container);
  }

  Future<void> dispose() async {
    container.dispose();
    await database.close();
  }

  /// Wraps [child] in the provider scope and app theme, without the router —
  /// keeps individual screen tests independent of navigation.
  Widget wrap(Widget child) {
    return UncontrolledProviderScope(
      container: container,
      child: MaterialApp(
        theme: AppTheme.light(),
        darkTheme: AppTheme.dark(),
        themeMode: ThemeMode.dark,
        home: child,
      ),
    );
  }
}

/// Settings representing a user who has already finished onboarding.
const AppSettings onboardedSettings = AppSettings(
  hasCompletedOnboarding: true,
  displayName: 'Sam',
  weeklyTarget: 4,
);
