import 'package:drift/drift.dart' show Value;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/branding.dart';
import '../../data/database.dart';
import '../../domain/app_settings.dart';
import '../../domain/enums.dart';
import '../../domain/plan/plan_templates.dart';
import '../../router.dart';
import '../../state/providers.dart';
import '../../theme/app_dimens.dart';
import '../../theme/app_theme.dart';
import '../../theme/app_typography.dart';
import '../../widgets/buttons.dart';
import '../../widgets/indicators.dart';
import '../../widgets/surfaces.dart';

/// First-run flow. Six short steps — the last one starts training.
///
/// Everything collected here is either used immediately (name, plan level,
/// reminder) or genuinely useful later (units, weekly target). Nothing is
/// asked for the sake of a longer funnel.
class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  static const int _stepCount = 6;

  final _pageController = PageController();
  final _nameController = TextEditingController();
  final _ageController = TextEditingController();
  final _heightController = TextEditingController();
  final _weightController = TextEditingController();

  int _step = 0;
  String _avatarId = 'wolf';
  FitnessLevel _level = FitnessLevel.beginner;
  PrimaryGoal _goal = PrimaryGoal.consistency;
  UnitSystem _units = UnitSystem.metric;
  int _weeklyTarget = 4;
  bool _reminderEnabled = true;
  TimeOfDay _reminderTime = const TimeOfDay(hour: 18, minute: 0);
  bool _saving = false;

  @override
  void dispose() {
    _pageController.dispose();
    _nameController.dispose();
    _ageController.dispose();
    _heightController.dispose();
    _weightController.dispose();
    super.dispose();
  }

  void _next() {
    if (_step >= _stepCount - 1) {
      _finish();
      return;
    }
    HapticFeedback.selectionClick();
    FocusScope.of(context).unfocus();
    _pageController.nextPage(duration: Motion.normal, curve: Motion.emphasized);
  }

  void _back() {
    if (_step == 0) return;
    FocusScope.of(context).unfocus();
    _pageController.previousPage(
      duration: Motion.normal,
      curve: Motion.emphasized,
    );
  }

  Future<void> _finish() async {
    if (_saving) return;
    setState(() => _saving = true);

    try {
      final name = _nameController.text.trim();
      final age = int.tryParse(_ageController.text.trim());
      final height = double.tryParse(
        _heightController.text.trim().replaceAll(',', '.'),
      );
      final weight = double.tryParse(
        _weightController.text.trim().replaceAll(',', '.'),
      );

      await ref
          .read(settingsProvider.notifier)
          .update(
            (s) => s.copyWith(
              hasCompletedOnboarding: true,
              displayName: name,
              avatarId: _avatarId,
              birthYear: age == null || age < 5 || age > 120
                  ? null
                  : DateTime.now().year - age,
              heightCm: _toCm(height),
              weightKg: _toKg(weight),
              fitnessLevel: _level,
              primaryGoal: _goal,
              unitSystem: _units,
              weeklyTarget: _weeklyTarget,
              reminderEnabled: _reminderEnabled,
              reminderHour: _reminderTime.hour,
              reminderMinute: _reminderTime.minute,
              memberSince: DateTime.now(),
            ),
          );

      // Start the plan at the level that matches the stated ability, so the
      // first session is neither trivial nor demoralising.
      final db = ref.read(databaseProvider);
      await db.savePlanProgress(
        PlanProgressesCompanion.insert(
          planId: PlanTemplates.defaultPlanId,
          level: Value(_level.suggestedPlanLevel),
          currentDay: const Value(1),
        ),
      );

      if (_reminderEnabled) {
        final notifications = ref.read(notificationServiceProvider);
        final granted = await notifications.requestPermission();
        if (granted) {
          await notifications.scheduleDailyReminder(
            hour: _reminderTime.hour,
            minute: _reminderTime.minute,
          );
        } else if (mounted) {
          // Permission denied is a normal outcome, not an error — record it so
          // Settings shows the real state rather than a lie.
          await ref
              .read(settingsProvider.notifier)
              .update((s) => s.copyWith(reminderEnabled: false));
        }
      }

      if (mounted) context.go(Routes.home);
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  double? _toCm(double? raw) {
    if (raw == null || raw <= 0) return null;
    return _units == UnitSystem.metric ? raw : raw * 2.54;
  }

  double? _toKg(double? raw) {
    if (raw == null || raw <= 0) return null;
    return _units == UnitSystem.metric ? raw : raw * 0.453592;
  }

  @override
  Widget build(BuildContext context) {
    final c = context.colors;

    return Scaffold(
      backgroundColor: c.background,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(
                Gap.screenH,
                Gap.md,
                Gap.screenH,
                Gap.lg,
              ),
              child: Row(
                children: [
                  SizedBox(
                    width: 40,
                    child: _step == 0
                        ? null
                        : IconPill(
                            icon: Icons.arrow_back_rounded,
                            size: 36,
                            onPressed: _back,
                            tooltip: 'Back',
                          ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: Gap.lg),
                      child: LinearMeter(
                        progress: (_step + 1) / _stepCount,
                        height: 6,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 40,
                    child: Center(
                      child: Text(
                        '${_step + 1}/$_stepCount',
                        style: AppTypography.caption.copyWith(
                          color: c.textTertiary,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: PageView(
                controller: _pageController,
                physics: const NeverScrollableScrollPhysics(),
                onPageChanged: (i) => setState(() => _step = i),
                children: [
                  _WelcomeStep(),
                  _NameStep(
                    controller: _nameController,
                    avatarId: _avatarId,
                    onAvatarChanged: (id) => setState(() => _avatarId = id),
                  ),
                  _LevelStep(
                    selected: _level,
                    onChanged: (v) => setState(() => _level = v),
                  ),
                  _GoalStep(
                    selected: _goal,
                    onChanged: (v) => setState(() => _goal = v),
                  ),
                  _BodyStep(
                    units: _units,
                    onUnitsChanged: (v) => setState(() => _units = v),
                    ageController: _ageController,
                    heightController: _heightController,
                    weightController: _weightController,
                  ),
                  _ScheduleStep(
                    weeklyTarget: _weeklyTarget,
                    onWeeklyChanged: (v) => setState(() => _weeklyTarget = v),
                    reminderEnabled: _reminderEnabled,
                    onReminderChanged: (v) =>
                        setState(() => _reminderEnabled = v),
                    reminderTime: _reminderTime,
                    onTimeChanged: (v) => setState(() => _reminderTime = v),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(
                Gap.screenH,
                Gap.lg,
                Gap.screenH,
                Gap.xl,
              ),
              child: Column(
                children: [
                  PrimaryButton(
                    label: _step == 0
                        ? 'Get started'
                        : _step == _stepCount - 1
                        ? 'Start training'
                        : 'Continue',
                    gradient: _step == _stepCount - 1,
                    loading: _saving,
                    onPressed: _next,
                  ),
                  if (_step == 4) ...[
                    const SizedBox(height: Gap.sm),
                    TextButton(
                      onPressed: _next,
                      child: Text(
                        'Skip — I will add this later',
                        style: AppTypography.bodySmall.copyWith(
                          color: c.textTertiary,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------

class _StepScaffold extends StatelessWidget {
  const _StepScaffold({
    required this.title,
    required this.subtitle,
    required this.child,
  });

  final String title;
  final String subtitle;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: Gap.screenH),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: Gap.lg),
          Text(
            title,
            style: AppTypography.displayS.copyWith(color: c.textPrimary),
          ),
          const SizedBox(height: Gap.sm),
          Text(
            subtitle,
            style: AppTypography.body.copyWith(color: c.textSecondary),
          ),
          const SizedBox(height: Gap.xxxl),
          child,
          const SizedBox(height: Gap.xl),
        ],
      ),
    );
  }
}

class _WelcomeStep extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: Gap.screenH),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 88,
            height: 88,
            decoration: BoxDecoration(
              gradient: c.brandGradient,
              borderRadius: BorderRadius.circular(Radii.xl),
              boxShadow: [
                BoxShadow(
                  color: c.accent.withValues(alpha: 0.4),
                  blurRadius: 32,
                  spreadRadius: -8,
                ),
              ],
            ),
            child: Icon(
              Icons.local_fire_department_rounded,
              size: 48,
              color: c.accentContrast,
            ),
          ),
          const SizedBox(height: Gap.xxl),
          GradientText(Branding.appName, style: AppTypography.displayM),
          const SizedBox(height: Gap.sm),
          Text(
            Branding.tagline,
            style: AppTypography.titleM.copyWith(color: c.textSecondary),
          ),
          const SizedBox(height: Gap.xxxl),
          const _Bullet(
            icon: Icons.calendar_today_rounded,
            title: 'A plan that adapts',
            body: 'Tell it how the session felt and tomorrow adjusts.',
          ),
          const _Bullet(
            icon: Icons.local_fire_department_rounded,
            title: 'Streaks that survive real life',
            body: 'Earn freezes so one busy day does not undo a month.',
          ),
          const _Bullet(
            icon: Icons.insights_rounded,
            title: 'Progress you can actually see',
            body: 'Records, charts and per-exercise trends. All offline.',
          ),
        ],
      ),
    );
  }
}

class _Bullet extends StatelessWidget {
  const _Bullet({required this.icon, required this.title, required this.body});

  final IconData icon;
  final String title;
  final String body;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Padding(
      padding: const EdgeInsets.only(bottom: Gap.xl),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: c.accentSoft,
              borderRadius: BorderRadius.circular(Radii.xs),
            ),
            child: Icon(icon, size: 19, color: c.accent),
          ),
          const SizedBox(width: Gap.lg),
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
                  body,
                  style: AppTypography.bodySmall.copyWith(
                    color: c.textSecondary,
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

class _NameStep extends StatelessWidget {
  const _NameStep({
    required this.controller,
    required this.avatarId,
    required this.onAvatarChanged,
  });

  final TextEditingController controller;
  final String avatarId;
  final ValueChanged<String> onAvatarChanged;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return _StepScaffold(
      title: 'What should we call you?',
      subtitle: 'Used to greet you on the home screen. Nothing leaves the app.',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextField(
            controller: controller,
            textCapitalization: TextCapitalization.words,
            textInputAction: TextInputAction.done,
            maxLength: 24,
            decoration: const InputDecoration(
              hintText: 'Your name or nickname',
              counterText: '',
              prefixIcon: Icon(Icons.person_outline_rounded),
            ),
          ),
          const SizedBox(height: Gap.xxl),
          Text(
            'Pick an avatar',
            style: AppTypography.titleS.copyWith(color: c.textPrimary),
          ),
          const SizedBox(height: Gap.md),
          Wrap(
            spacing: Gap.md,
            runSpacing: Gap.md,
            children: [
              for (final id in Avatars.ids)
                _AvatarOption(
                  id: id,
                  isSelected: id == avatarId,
                  onTap: () => onAvatarChanged(id),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

class _AvatarOption extends StatelessWidget {
  const _AvatarOption({
    required this.id,
    required this.isSelected,
    required this.onTap,
  });

  final String id;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Semantics(
      selected: isSelected,
      button: true,
      label: 'Avatar $id',
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: Motion.fast,
          width: 58,
          height: 58,
          decoration: BoxDecoration(
            color: isSelected ? c.accentSoft : c.surfaceSunken,
            shape: BoxShape.circle,
            border: Border.all(
              color: isSelected ? c.accent : c.border,
              width: isSelected ? 2 : 1,
            ),
          ),
          child: Center(
            child: Text(
              Avatars.emoji(id),
              style: const TextStyle(fontSize: 26),
            ),
          ),
        ),
      ),
    );
  }
}

class _LevelStep extends StatelessWidget {
  const _LevelStep({required this.selected, required this.onChanged});

  final FitnessLevel selected;
  final ValueChanged<FitnessLevel> onChanged;

  @override
  Widget build(BuildContext context) {
    return _StepScaffold(
      title: 'Where are you starting?',
      subtitle: 'This sets your first plan level. You can change it any time.',
      child: Column(
        children: [
          for (final level in FitnessLevel.values)
            Padding(
              padding: const EdgeInsets.only(bottom: Gap.md),
              child: _ChoiceCard(
                title: level.label,
                subtitle: level.subtitle,
                trailing: 'Level ${level.suggestedPlanLevel}',
                isSelected: level == selected,
                onTap: () => onChanged(level),
              ),
            ),
        ],
      ),
    );
  }
}

class _GoalStep extends StatelessWidget {
  const _GoalStep({required this.selected, required this.onChanged});

  final PrimaryGoal selected;
  final ValueChanged<PrimaryGoal> onChanged;

  @override
  Widget build(BuildContext context) {
    return _StepScaffold(
      title: 'What matters most right now?',
      subtitle: 'We will highlight the stats that track it.',
      child: Column(
        children: [
          for (final goal in PrimaryGoal.values)
            Padding(
              padding: const EdgeInsets.only(bottom: Gap.md),
              child: _ChoiceCard(
                title: goal.label,
                icon: goal.icon,
                isSelected: goal == selected,
                onTap: () => onChanged(goal),
              ),
            ),
        ],
      ),
    );
  }
}

class _BodyStep extends StatelessWidget {
  const _BodyStep({
    required this.units,
    required this.onUnitsChanged,
    required this.ageController,
    required this.heightController,
    required this.weightController,
  });

  final UnitSystem units;
  final ValueChanged<UnitSystem> onUnitsChanged;
  final TextEditingController ageController;
  final TextEditingController heightController;
  final TextEditingController weightController;

  @override
  Widget build(BuildContext context) {
    return _StepScaffold(
      title: 'A few optional basics',
      subtitle:
          'Only used to show your numbers in the units you prefer. '
          'Skip it if you would rather not.',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SegmentedToggle<UnitSystem>(
            options: UnitSystem.values,
            selected: units,
            labelOf: (u) => u.label,
            onChanged: onUnitsChanged,
          ),
          const SizedBox(height: Gap.xl),
          TextField(
            controller: ageController,
            keyboardType: TextInputType.number,
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
              LengthLimitingTextInputFormatter(3),
            ],
            decoration: const InputDecoration(
              labelText: 'Age',
              hintText: 'Optional',
              prefixIcon: Icon(Icons.cake_outlined),
            ),
          ),
          const SizedBox(height: Gap.md),
          TextField(
            controller: heightController,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'[0-9.,]')),
              LengthLimitingTextInputFormatter(6),
            ],
            decoration: InputDecoration(
              labelText: 'Height (${units.heightUnit})',
              hintText: 'Optional',
              prefixIcon: const Icon(Icons.straighten_rounded),
            ),
          ),
          const SizedBox(height: Gap.md),
          TextField(
            controller: weightController,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'[0-9.,]')),
              LengthLimitingTextInputFormatter(6),
            ],
            decoration: InputDecoration(
              labelText: 'Weight (${units.weightUnit})',
              hintText: 'Optional',
              prefixIcon: const Icon(Icons.monitor_weight_outlined),
            ),
          ),
        ],
      ),
    );
  }
}

class _ScheduleStep extends StatelessWidget {
  const _ScheduleStep({
    required this.weeklyTarget,
    required this.onWeeklyChanged,
    required this.reminderEnabled,
    required this.onReminderChanged,
    required this.reminderTime,
    required this.onTimeChanged,
  });

  final int weeklyTarget;
  final ValueChanged<int> onWeeklyChanged;
  final bool reminderEnabled;
  final ValueChanged<bool> onReminderChanged;
  final TimeOfDay reminderTime;
  final ValueChanged<TimeOfDay> onTimeChanged;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return _StepScaffold(
      title: 'How often will you train?',
      subtitle: 'Be realistic — a streak you can keep beats one you cannot.',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              for (var days = 1; days <= 7; days++)
                _DayCountChip(
                  days: days,
                  isSelected: days == weeklyTarget,
                  onTap: () => onWeeklyChanged(days),
                ),
            ],
          ),
          const SizedBox(height: Gap.sm),
          Text(
            weeklyTarget >= 6
                ? 'Ambitious. Rest days still count as recovery.'
                : '$weeklyTarget sessions a week',
            style: AppTypography.bodySmall.copyWith(color: c.textSecondary),
          ),
          const SizedBox(height: Gap.xxl),
          AppCard(
            padding: const EdgeInsets.all(Gap.lg),
            child: Column(
              children: [
                Row(
                  children: [
                    Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        color: c.accentSoft,
                        borderRadius: BorderRadius.circular(Radii.xs),
                      ),
                      child: Icon(
                        Icons.notifications_active_outlined,
                        size: 18,
                        color: c.accent,
                      ),
                    ),
                    const SizedBox(width: Gap.md),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Daily reminder',
                            style: AppTypography.titleS.copyWith(
                              color: c.textPrimary,
                            ),
                          ),
                          Text(
                            'One nudge a day. Nothing else.',
                            style: AppTypography.bodySmall.copyWith(
                              color: c.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Switch(
                      value: reminderEnabled,
                      onChanged: onReminderChanged,
                    ),
                  ],
                ),
                if (reminderEnabled) ...[
                  const SizedBox(height: Gap.md),
                  const Divider(),
                  const SizedBox(height: Gap.md),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          'Remind me at',
                          style: AppTypography.body.copyWith(
                            color: c.textSecondary,
                          ),
                        ),
                      ),
                      SecondaryButton(
                        label: reminderTime.format(context),
                        expanded: false,
                        height: Sizes.buttonHeightCompact,
                        icon: Icons.schedule_rounded,
                        onPressed: () async {
                          final picked = await showTimePicker(
                            context: context,
                            initialTime: reminderTime,
                          );
                          if (picked != null) onTimeChanged(picked);
                        },
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _DayCountChip extends StatelessWidget {
  const _DayCountChip({
    required this.days,
    required this.isSelected,
    required this.onTap,
  });

  final int days;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Semantics(
      selected: isSelected,
      button: true,
      label: '$days days per week',
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: Motion.fast,
          width: 40,
          height: 48,
          decoration: BoxDecoration(
            color: isSelected ? c.accent : c.surfaceSunken,
            borderRadius: BorderRadius.circular(Radii.sm),
            border: Border.all(color: isSelected ? c.accent : c.border),
          ),
          child: Center(
            child: Text(
              '$days',
              style: AppTypography.titleM.copyWith(
                color: isSelected ? c.accentContrast : c.textSecondary,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _ChoiceCard extends StatelessWidget {
  const _ChoiceCard({
    required this.title,
    required this.isSelected,
    required this.onTap,
    this.subtitle,
    this.icon,
    this.trailing,
  });

  final String title;
  final String? subtitle;
  final IconData? icon;
  final String? trailing;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Semantics(
      selected: isSelected,
      button: true,
      child: AppCard(
        onTap: onTap,
        accented: isSelected,
        background: isSelected ? c.accentSoft : null,
        padding: const EdgeInsets.all(Gap.lg),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: isSelected ? c.accent : c.surfaceSunken,
                borderRadius: BorderRadius.circular(Radii.xs),
              ),
              child: Icon(
                icon ??
                    (isSelected ? Icons.check_rounded : Icons.circle_outlined),
                size: 19,
                color: isSelected ? c.accentContrast : c.textTertiary,
              ),
            ),
            const SizedBox(width: Gap.lg),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    title,
                    style: AppTypography.titleS.copyWith(color: c.textPrimary),
                  ),
                  if (subtitle != null) ...[
                    const SizedBox(height: 2),
                    Text(
                      subtitle!,
                      style: AppTypography.bodySmall.copyWith(
                        color: c.textSecondary,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            if (trailing != null)
              TagChip(
                label: trailing!,
                color: isSelected ? c.accent : c.textTertiary,
                dense: true,
              ),
          ],
        ),
      ),
    );
  }
}
