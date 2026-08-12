import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:timezone/data/latest_all.dart' as tzdata;
import 'package:timezone/timezone.dart' as tz;

import '../core/branding.dart';

/// Local reminder notifications.
///
/// Everything here is best-effort: reminders are a nicety, so a device that
/// denies the permission, lacks exact-alarm rights or has an unusual timezone
/// database must degrade quietly rather than break the app.
class NotificationService {
  NotificationService(this._plugin);

  static const int dailyReminderId = 1001;
  static const int streakRiskId = 1002;

  static const AndroidNotificationDetails _reminderChannel =
      AndroidNotificationDetails(
        'workout_reminders',
        'Workout reminders',
        channelDescription: 'Daily nudge to complete your training',
        importance: Importance.defaultImportance,
        priority: Priority.defaultPriority,
        category: AndroidNotificationCategory.reminder,
      );

  static const AndroidNotificationDetails _streakChannel =
      AndroidNotificationDetails(
        'streak_alerts',
        'Streak alerts',
        channelDescription: 'Warns you before an active streak expires',
        importance: Importance.high,
        priority: Priority.high,
        category: AndroidNotificationCategory.reminder,
      );

  final FlutterLocalNotificationsPlugin _plugin;

  bool _initialised = false;
  bool _timezoneReady = false;

  static Future<NotificationService> create() async {
    final service = NotificationService(FlutterLocalNotificationsPlugin());
    await service.init();
    return service;
  }

  Future<void> init() async {
    if (_initialised) return;
    try {
      await _plugin.initialize(
        settings: const InitializationSettings(
          android: AndroidInitializationSettings('@mipmap/ic_launcher'),
        ),
      );
      await _configureTimezone();
      _initialised = true;
    } on Object catch (e) {
      debugPrint('Notification init failed: $e');
    }
  }

  Future<void> _configureTimezone() async {
    try {
      tzdata.initializeTimeZones();
      final name = await FlutterTimezone.getLocalTimezone();
      tz.setLocalLocation(tz.getLocation(name.identifier));
      _timezoneReady = true;
    } on Object catch (e) {
      // An unknown zone name would throw; UTC keeps scheduling functional.
      debugPrint('Timezone setup failed, using UTC: $e');
      try {
        tz.setLocalLocation(tz.getLocation('UTC'));
        _timezoneReady = true;
      } on Object catch (_) {
        _timezoneReady = false;
      }
    }
  }

  /// Asks for POST_NOTIFICATIONS on Android 13+. Returns whether it is granted.
  Future<bool> requestPermission() async {
    if (!Platform.isAndroid) return false;
    try {
      final android = _plugin
          .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin
          >();
      if (android == null) return false;
      final granted = await android.requestNotificationsPermission();
      return granted ?? false;
    } on Object catch (e) {
      debugPrint('Notification permission request failed: $e');
      return false;
    }
  }

  Future<bool> hasPermission() async {
    if (!Platform.isAndroid) return false;
    try {
      final android = _plugin
          .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin
          >();
      return await android?.areNotificationsEnabled() ?? false;
    } on Object catch (_) {
      return false;
    }
  }

  /// Schedules the daily training reminder, replacing any previous one.
  Future<void> scheduleDailyReminder({
    required int hour,
    required int minute,
  }) async {
    if (!_initialised || !_timezoneReady) return;
    await cancelDailyReminder();
    try {
      await _plugin.zonedSchedule(
        id: dailyReminderId,
        title: 'Time to train',
        body:
            'Your ${Branding.appName} session is waiting. Keep the streak alive.',
        scheduledDate: _nextInstanceOf(hour, minute),
        notificationDetails: const NotificationDetails(
          android: _reminderChannel,
        ),
        androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
        matchDateTimeComponents: DateTimeComponents.time,
      );
    } on Object catch (e) {
      debugPrint('Failed to schedule daily reminder: $e');
    }
  }

  /// Warns late in the evening when a live streak has not been extended.
  ///
  /// Scheduled for today only; it is re-evaluated each time the app opens, so
  /// a user who trains in the morning never sees it.
  Future<void> scheduleStreakRiskAlert({
    required int currentStreak,
    int hour = 20,
    int minute = 30,
  }) async {
    if (!_initialised || !_timezoneReady || currentStreak <= 0) return;
    await cancelStreakRiskAlert();

    final when = _nextInstanceOf(hour, minute);
    // Only fire if that time is still ahead of us today.
    if (when.difference(tz.TZDateTime.now(tz.local)).inHours >= 24) return;

    try {
      await _plugin.zonedSchedule(
        id: streakRiskId,
        title: 'Your $currentStreak-day streak is at risk',
        body: 'A few minutes of training is all it takes to keep it going.',
        scheduledDate: when,
        notificationDetails: const NotificationDetails(android: _streakChannel),
        androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
      );
    } on Object catch (e) {
      debugPrint('Failed to schedule streak alert: $e');
    }
  }

  Future<void> cancelDailyReminder() async {
    try {
      await _plugin.cancel(id: dailyReminderId);
    } on Object catch (_) {
      // Nothing scheduled — not an error.
    }
  }

  Future<void> cancelStreakRiskAlert() async {
    try {
      await _plugin.cancel(id: streakRiskId);
    } on Object catch (_) {
      // Nothing scheduled — not an error.
    }
  }

  Future<void> cancelAll() async {
    try {
      await _plugin.cancelAll();
    } on Object catch (e) {
      debugPrint('Failed to cancel notifications: $e');
    }
  }

  tz.TZDateTime _nextInstanceOf(int hour, int minute) {
    final now = tz.TZDateTime.now(tz.local);
    var scheduled = tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      now.day,
      hour,
      minute,
    );
    if (!scheduled.isAfter(now)) {
      scheduled = scheduled.add(const Duration(days: 1));
    }
    return scheduled;
  }
}
