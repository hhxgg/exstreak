import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/formatters.dart';
import '../../domain/enums.dart';
import '../../domain/plan/plan_templates.dart';
import '../../state/providers.dart';
import '../../theme/app_dimens.dart';
import '../../theme/app_theme.dart';
import '../../theme/app_typography.dart';
import '../../widgets/buttons.dart';
import '../../widgets/surfaces.dart';

/// How workouts behave: rest, rep counting, screen and feedback.
class WorkoutPrefsScreen extends ConsumerWidget {
  const WorkoutPrefsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final c = context.colors;
    final settings = ref.watch(settingsProvider);
    final controller = ref.read(settingsProvider.notifier);
    final useOverride = settings.restSecondsOverride != null;

    return AppScreen(
      title: 'Workout preferences',
      padded: false,
      child: ListView(
        padding: const EdgeInsets.fromLTRB(
          Gap.screenH,
          Gap.lg,
          Gap.screenH,
          Gap.giant,
        ),
        children: [
          const SectionHeader(title: 'Rest between sets'),
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
                            'Use one rest time everywhere',
                            style: AppTypography.titleS.copyWith(
                              color: c.textPrimary,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            useOverride
                                ? 'Overrides each exercise\'s own default.'
                                : 'Each exercise uses its own recommended rest.',
                            style: AppTypography.bodySmall.copyWith(
                              color: c.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Switch(
                      value: useOverride,
                      onChanged: (v) => controller.update(
                        (s) => v
                            ? s.copyWith(restSecondsOverride: 90)
                            : s.copyWith(clearRestOverride: true),
                      ),
                    ),
                  ],
                ),
                if (useOverride) ...[
                  const SizedBox(height: Gap.lg),
                  const Divider(),
                  const SizedBox(height: Gap.md),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          'Rest time',
                          style: AppTypography.body.copyWith(
                            color: c.textSecondary,
                          ),
                        ),
                      ),
                      Text(
                        Fmt.duration(settings.restSecondsOverride!),
                        style: AppTypography.titleS.copyWith(
                          color: c.textPrimary,
                        ),
                      ),
                    ],
                  ),
                  Slider(
                    value: settings.restSecondsOverride!.toDouble(),
                    min: 0,
                    max: 300,
                    divisions: 20,
                    label: Fmt.duration(settings.restSecondsOverride!),
                    onChanged: (v) => controller.update(
                      (s) => s.copyWith(restSecondsOverride: v.round()),
                    ),
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(height: Gap.xl),

          const SectionHeader(title: 'How reps are counted'),
          for (final mode in RepInputMode.values)
            Padding(
              padding: const EdgeInsets.only(bottom: Gap.sm),
              child: AppCard(
                onTap: () =>
                    controller.update((s) => s.copyWith(repInputMode: mode)),
                accented: mode == settings.repInputMode,
                background: mode == settings.repInputMode ? c.accentSoft : null,
                padding: const EdgeInsets.all(Gap.lg),
                child: Row(
                  children: [
                    Icon(
                      mode == RepInputMode.tap
                          ? Icons.touch_app_outlined
                          : Icons.sensors_rounded,
                      size: 20,
                      color: mode == settings.repInputMode
                          ? c.accent
                          : c.textTertiary,
                    ),
                    const SizedBox(width: Gap.md),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            mode.label,
                            style: AppTypography.titleS.copyWith(
                              color: c.textPrimary,
                            ),
                          ),
                          Text(
                            mode.hint,
                            style: AppTypography.caption.copyWith(
                              color: c.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          const SizedBox(height: Gap.sm),
          InfoBanner(
            message:
                'Proximity counting needs a phone with a proximity sensor. '
                'If yours does not have one, tapping still works.',
            icon: Icons.info_outline_rounded,
          ),
          const SizedBox(height: Gap.xl),

          const SectionHeader(title: 'Active plan'),
          AppCard(
            padding: const EdgeInsets.symmetric(vertical: Gap.sm),
            child: Column(
              children: [
                for (final plan in PlanTemplates.all)
                  AppListTile(
                    title: plan.name,
                    subtitle: plan.levelTitles.join(' · '),
                    leadingIcon: plan.trackingType.icon,
                    showChevron: false,
                    trailing: plan.id == settings.activePlanId
                        ? Icon(
                            Icons.check_circle_rounded,
                            color: c.accent,
                            size: 20,
                          )
                        : Icon(
                            Icons.circle_outlined,
                            color: c.textTertiary,
                            size: 20,
                          ),
                    onTap: () => controller.update(
                      (s) => s.copyWith(activePlanId: plan.id),
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(height: Gap.xl),

          const SectionHeader(title: 'During a workout'),
          AppCard(
            child: Column(
              children: [
                _SwitchRow(
                  title: 'Keep the screen on',
                  subtitle: 'Stops the display sleeping mid-set.',
                  value: settings.keepScreenAwake,
                  onChanged: (v) =>
                      controller.update((s) => s.copyWith(keepScreenAwake: v)),
                ),
                const Divider(),
                _SwitchRow(
                  title: 'Vibration feedback',
                  subtitle: 'A short buzz on each rep and set.',
                  value: settings.hapticsEnabled,
                  onChanged: (v) =>
                      controller.update((s) => s.copyWith(hapticsEnabled: v)),
                ),
                const Divider(),
                _SwitchRow(
                  title: 'Sounds',
                  subtitle: 'Audio cue when a rest timer ends.',
                  value: settings.soundEnabled,
                  onChanged: (v) =>
                      controller.update((s) => s.copyWith(soundEnabled: v)),
                ),
              ],
            ),
          ),
          const SizedBox(height: Gap.xl),

          const SectionHeader(title: 'Weekly target'),
          AppCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${settings.weeklyTarget} '
                  '${settings.weeklyTarget == 1 ? 'session' : 'sessions'} a week',
                  style: AppTypography.titleS.copyWith(color: c.textPrimary),
                ),
                Slider(
                  value: settings.weeklyTarget.toDouble(),
                  min: 1,
                  max: 7,
                  divisions: 6,
                  label: '${settings.weeklyTarget}',
                  onChanged: (v) => controller.update(
                    (s) => s.copyWith(weeklyTarget: v.round()),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SwitchRow extends StatelessWidget {
  const _SwitchRow({
    required this.title,
    required this.subtitle,
    required this.value,
    required this.onChanged,
  });

  final String title;
  final String subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: Gap.sm),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTypography.titleS.copyWith(color: c.textPrimary),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: AppTypography.bodySmall.copyWith(
                    color: c.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          Switch(value: value, onChanged: onChanged),
        ],
      ),
    );
  }
}
