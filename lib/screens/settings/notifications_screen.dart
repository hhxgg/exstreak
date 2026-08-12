import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../state/providers.dart';
import '../../theme/app_dimens.dart';
import '../../theme/app_theme.dart';
import '../../theme/app_typography.dart';
import '../../widgets/buttons.dart';
import '../../widgets/surfaces.dart';

/// Reminder settings, plus an honest read-out of the OS permission state.
class NotificationsScreen extends ConsumerStatefulWidget {
  const NotificationsScreen({super.key});

  @override
  ConsumerState<NotificationsScreen> createState() =>
      _NotificationsScreenState();
}

class _NotificationsScreenState extends ConsumerState<NotificationsScreen> {
  bool? _permissionGranted;

  @override
  void initState() {
    super.initState();
    _checkPermission();
  }

  Future<void> _checkPermission() async {
    final granted = await ref.read(notificationServiceProvider).hasPermission();
    if (mounted) setState(() => _permissionGranted = granted);
  }

  Future<void> _requestPermission() async {
    final granted = await ref
        .read(notificationServiceProvider)
        .requestPermission();
    if (!mounted) return;
    setState(() => _permissionGranted = granted);

    if (!granted) {
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          const SnackBar(
            content: Text(
              'Notifications are blocked. Enable them for ExStreak in your '
              'Android settings.',
            ),
          ),
        );
    }
  }

  Future<void> _setDailyEnabled(bool enabled) async {
    final notifications = ref.read(notificationServiceProvider);

    if (enabled) {
      final granted = _permissionGranted ?? await notifications.hasPermission();
      if (!granted) {
        await _requestPermission();
        if (!mounted) return;
        if (!(_permissionGranted ?? false)) return;
      }
    }

    final settings = ref.read(settingsProvider);
    await ref
        .read(settingsProvider.notifier)
        .update((s) => s.copyWith(reminderEnabled: enabled));

    if (enabled) {
      await notifications.scheduleDailyReminder(
        hour: settings.reminderHour,
        minute: settings.reminderMinute,
      );
    } else {
      await notifications.cancelDailyReminder();
    }
  }

  Future<void> _pickTime() async {
    final settings = ref.read(settingsProvider);
    final picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay(
        hour: settings.reminderHour,
        minute: settings.reminderMinute,
      ),
    );
    if (picked == null || !mounted) return;

    await ref
        .read(settingsProvider.notifier)
        .update(
          (s) => s.copyWith(
            reminderHour: picked.hour,
            reminderMinute: picked.minute,
          ),
        );

    if (ref.read(settingsProvider).reminderEnabled) {
      await ref
          .read(notificationServiceProvider)
          .scheduleDailyReminder(hour: picked.hour, minute: picked.minute);
    }
  }

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final settings = ref.watch(settingsProvider);
    final blocked = _permissionGranted == false;

    return AppScreen(
      title: 'Notifications',
      padded: false,
      child: ListView(
        padding: const EdgeInsets.fromLTRB(
          Gap.screenH,
          Gap.lg,
          Gap.screenH,
          Gap.giant,
        ),
        children: [
          if (blocked) ...[
            InfoBanner(
              message:
                  'Android is blocking notifications for ExStreak, so no '
                  'reminders can be delivered.',
              icon: Icons.notifications_off_outlined,
              tone: BannerTone.warning,
              actionLabel: 'Allow',
              onAction: _requestPermission,
            ),
            const SizedBox(height: Gap.xl),
          ],

          const SectionHeader(title: 'Daily reminder'),
          AppCard(
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Remind me to train',
                            style: AppTypography.titleS.copyWith(
                              color: c.textPrimary,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            'One notification a day, at the time you choose.',
                            style: AppTypography.bodySmall.copyWith(
                              color: c.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Switch(
                      value: settings.reminderEnabled,
                      onChanged: _setDailyEnabled,
                    ),
                  ],
                ),
                if (settings.reminderEnabled) ...[
                  const SizedBox(height: Gap.lg),
                  const Divider(),
                  const SizedBox(height: Gap.lg),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          'Reminder time',
                          style: AppTypography.body.copyWith(
                            color: c.textSecondary,
                          ),
                        ),
                      ),
                      SecondaryButton(
                        label: TimeOfDay(
                          hour: settings.reminderHour,
                          minute: settings.reminderMinute,
                        ).format(context),
                        icon: Icons.schedule_rounded,
                        expanded: false,
                        height: Sizes.buttonHeightCompact,
                        onPressed: _pickTime,
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(height: Gap.xl),

          const SectionHeader(title: 'Streak protection'),
          AppCard(
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Warn me before a streak expires',
                        style: AppTypography.titleS.copyWith(
                          color: c.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Only sent in the evening, and only if you have an '
                        'active streak and have not trained yet.',
                        style: AppTypography.bodySmall.copyWith(
                          color: c.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                Switch(
                  value: settings.streakRiskReminderEnabled,
                  onChanged: (v) async {
                    await ref
                        .read(settingsProvider.notifier)
                        .update(
                          (s) => s.copyWith(streakRiskReminderEnabled: v),
                        );
                    if (!v) {
                      await ref
                          .read(notificationServiceProvider)
                          .cancelStreakRiskAlert();
                    }
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: Gap.xl),

          InfoBanner(
            message:
                'ExStreak sends at most two notifications a day and never '
                'sends marketing.',
            icon: Icons.verified_user_outlined,
            tone: BannerTone.info,
          ),
        ],
      ),
    );
  }
}
