import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/formatters.dart';
import '../../domain/enums.dart';
import '../../router.dart';
import '../../state/providers.dart';
import '../../theme/app_dimens.dart';
import '../../theme/app_theme.dart';
import '../../widgets/buttons.dart';
import '../../widgets/surfaces.dart';

/// Settings hub.
class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final c = context.colors;
    final settings = ref.watch(settingsProvider);

    return AppScreen(
      title: 'Settings',
      padded: false,
      child: ListView(
        padding: const EdgeInsets.fromLTRB(
          Gap.screenH,
          Gap.lg,
          Gap.screenH,
          Gap.giant,
        ),
        children: [
          const SectionHeader(title: 'Training'),
          AppCard(
            padding: const EdgeInsets.symmetric(vertical: Gap.sm),
            child: Column(
              children: [
                AppListTile(
                  title: 'Workout preferences',
                  subtitle:
                      'Rest ${settings.restSecondsOverride == null ? 'per exercise' : Fmt.duration(settings.restSecondsOverride!)}'
                      ' · ${settings.repInputMode.label}',
                  leadingIcon: Icons.tune_rounded,
                  onTap: () => context.push(Routes.settingsWorkout),
                ),
                AppListTile(
                  title: 'Notifications',
                  subtitle: settings.reminderEnabled
                      ? 'Daily at '
                            '${TimeOfDay(hour: settings.reminderHour, minute: settings.reminderMinute).format(context)}'
                      : 'Reminders are off',
                  leadingIcon: Icons.notifications_outlined,
                  leadingColor: c.info,
                  onTap: () => context.push(Routes.settingsNotifications),
                ),
                AppListTile(
                  title: 'Goals',
                  subtitle: 'Create and track your targets',
                  leadingIcon: Icons.flag_outlined,
                  leadingColor: c.success,
                  onTap: () => context.push(Routes.goals),
                ),
              ],
            ),
          ),
          const SizedBox(height: Gap.xl),

          const SectionHeader(title: 'Appearance'),
          AppCard(
            padding: const EdgeInsets.symmetric(vertical: Gap.sm),
            child: Column(
              children: [
                AppListTile(
                  title: 'Theme',
                  subtitle: settings.themeMode.label,
                  leadingIcon: Icons.palette_outlined,
                  leadingColor: c.warning,
                  onTap: () => _pickTheme(context, ref),
                ),
                AppListTile(
                  title: 'Units',
                  subtitle: settings.unitSystem.label,
                  leadingIcon: Icons.straighten_rounded,
                  onTap: () => _pickUnits(context, ref),
                ),
                AppListTile(
                  title: 'Language',
                  subtitle: 'English',
                  leadingIcon: Icons.language_rounded,
                  leadingColor: c.info,
                  onTap: () => _showLanguageNote(context),
                ),
              ],
            ),
          ),
          const SizedBox(height: Gap.xl),

          const SectionHeader(title: 'Data'),
          AppCard(
            padding: const EdgeInsets.symmetric(vertical: Gap.sm),
            child: Column(
              children: [
                AppListTile(
                  title: 'Your data',
                  subtitle: 'Export, reset or delete everything',
                  leadingIcon: Icons.storage_rounded,
                  onTap: () => context.push(Routes.settingsData),
                ),
                AppListTile(
                  title: 'About',
                  subtitle: 'Version, privacy and licences',
                  leadingIcon: Icons.info_outline_rounded,
                  leadingColor: c.textSecondary,
                  onTap: () => context.push(Routes.about),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _pickTheme(BuildContext context, WidgetRef ref) async {
    final current = ref.read(settingsProvider).themeMode;
    final picked = await _pickOption<AppThemeMode>(
      context,
      title: 'Theme',
      options: AppThemeMode.values,
      current: current,
      labelOf: (v) => v.label,
    );
    if (picked == null) return;
    await ref
        .read(settingsProvider.notifier)
        .update((s) => s.copyWith(themeMode: picked));
  }

  Future<void> _pickUnits(BuildContext context, WidgetRef ref) async {
    final current = ref.read(settingsProvider).unitSystem;
    final picked = await _pickOption<UnitSystem>(
      context,
      title: 'Units',
      options: UnitSystem.values,
      current: current,
      labelOf: (v) => v.label,
    );
    if (picked == null) return;
    await ref
        .read(settingsProvider.notifier)
        .update((s) => s.copyWith(unitSystem: picked));
  }

  void _showLanguageNote(BuildContext context) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        const SnackBar(
          content: Text(
            'English is the only language available right now. '
            'The app is built to add more.',
          ),
        ),
      );
  }

  Future<T?> _pickOption<T>(
    BuildContext context, {
    required String title,
    required List<T> options,
    required T current,
    required String Function(T) labelOf,
  }) {
    return showModalBottomSheet<T>(
      context: context,
      builder: (context) {
        final c = context.colors;
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(
                  Gap.screenH,
                  Gap.sm,
                  Gap.screenH,
                  Gap.md,
                ),
                child: Text(
                  title,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ),
              for (final option in options)
                AppListTile(
                  title: labelOf(option),
                  showChevron: false,
                  trailing: option == current
                      ? Icon(Icons.check_rounded, color: c.accent, size: 20)
                      : null,
                  onTap: () => context.pop(option),
                ),
              const SizedBox(height: Gap.lg),
            ],
          ),
        );
      },
    );
  }
}
