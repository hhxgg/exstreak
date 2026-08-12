import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/formatters.dart';
import '../../domain/plan/plan_templates.dart';
import '../../state/providers.dart';
import '../../theme/app_dimens.dart';
import '../../theme/app_theme.dart';
import '../../theme/app_typography.dart';
import '../../widgets/buttons.dart';
import '../../widgets/surfaces.dart';
import 'workout_launcher.dart';

/// Choose a plan, a level, and which day to train.
///
/// The plan is laid out in advance so the user never has to design a session;
/// picking a specific day is there for the times real life does not line up
/// with the schedule.
class PlanPickerScreen extends ConsumerStatefulWidget {
  const PlanPickerScreen({super.key});

  @override
  ConsumerState<PlanPickerScreen> createState() => _PlanPickerScreenState();
}

class _PlanPickerScreenState extends ConsumerState<PlanPickerScreen> {
  PlanTemplate? _template;
  int _level = 1;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final progress = ref.watch(planProgressProvider).valueOrNull;
    final allProgress = ref.watch(allPlanProgressProvider).valueOrNull ?? {};

    final template = _template ?? progress?.template ?? PlanTemplates.pushups;
    final saved = allProgress[template.id];
    final level = _template == null ? (saved?.level ?? _level) : _level;
    final currentDay = saved?.day ?? 1;

    return AppScreen(
      title: 'Training plans',
      padded: false,
      child: ListView(
        padding: const EdgeInsets.fromLTRB(
          Gap.screenH,
          Gap.lg,
          Gap.screenH,
          Gap.giant,
        ),
        children: [
          const SectionHeader(title: 'Plan'),
          SizedBox(
            height: 44,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: PlanTemplates.all.length,
              separatorBuilder: (_, _) => const SizedBox(width: Gap.sm),
              itemBuilder: (context, i) {
                final p = PlanTemplates.all[i];
                final isSelected = p.id == template.id;
                return _PlanChip(
                  label: p.name,
                  isSelected: isSelected,
                  onTap: () => setState(() {
                    _template = p;
                    _level = allProgress[p.id]?.level ?? 1;
                  }),
                );
              },
            ),
          ),
          const SizedBox(height: Gap.xxl),

          if (saved != null) ...[
            const SectionHeader(title: 'Continue where you left off'),
            AppCard(
              accented: true,
              onTap: () => startPlanDay(
                context,
                ref,
                template: template,
                level: saved.level,
                day: saved.day,
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Level ${saved.level} · Day ${saved.day}',
                          style: AppTypography.titleM.copyWith(
                            color: c.textPrimary,
                          ),
                        ),
                        const SizedBox(height: Gap.xs),
                        Text(
                          _summaryFor(template, saved.level, saved.day),
                          style: AppTypography.bodyStrong.copyWith(
                            color: c.warning,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: c.accent,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: c.accent.withValues(alpha: 0.4),
                          blurRadius: 18,
                          spreadRadius: -4,
                        ),
                      ],
                    ),
                    child: Icon(
                      Icons.play_arrow_rounded,
                      color: c.accentContrast,
                      size: 26,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: Gap.xxl),
          ],

          const SectionHeader(title: 'Choose a level'),
          SegmentedToggle<int>(
            options: [for (var i = 1; i <= template.levelCount; i++) i],
            selected: level.clamp(1, template.levelCount),
            labelOf: (i) => 'Level $i',
            onChanged: (i) => setState(() {
              _template = template;
              _level = i;
            }),
          ),
          const SizedBox(height: Gap.lg),
          Center(
            child: Text(
              template.levelTitles[(level - 1).clamp(
                0,
                template.levelCount - 1,
              )],
              style: AppTypography.titleM.copyWith(color: c.warning),
            ),
          ),
          const SizedBox(height: Gap.xl),

          for (var day = 1; day <= template.daysPerLevel; day++)
            Padding(
              padding: const EdgeInsets.only(bottom: Gap.md),
              child: _DayRow(
                template: template,
                level: level.clamp(1, template.levelCount),
                day: day,
                isCurrent:
                    saved != null && saved.level == level && currentDay == day,
                onTap: () => startPlanDay(
                  context,
                  ref,
                  template: template,
                  level: level.clamp(1, template.levelCount),
                  day: day,
                ),
              ),
            ),
        ],
      ),
    );
  }

  String _summaryFor(PlanTemplate t, int level, int day) {
    final planDay = t.dayFor(level, day);
    if (t.trackingType.tracksDuration) {
      return planDay.targets.map(Fmt.duration).join(' · ');
    }
    return planDay.summary;
  }
}

class _PlanChip extends StatelessWidget {
  const _PlanChip({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Semantics(
      selected: isSelected,
      button: true,
      child: Material(
        color: isSelected ? c.accent : c.surface,
        borderRadius: Radii.pillRadius,
        child: InkWell(
          onTap: onTap,
          borderRadius: Radii.pillRadius,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: Gap.xl),
            decoration: BoxDecoration(
              borderRadius: Radii.pillRadius,
              border: Border.all(color: isSelected ? c.accent : c.border),
            ),
            child: Center(
              child: Text(
                label,
                style: AppTypography.titleS.copyWith(
                  color: isSelected ? c.accentContrast : c.textSecondary,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _DayRow extends StatelessWidget {
  const _DayRow({
    required this.template,
    required this.level,
    required this.day,
    required this.isCurrent,
    required this.onTap,
  });

  final PlanTemplate template;
  final int level;
  final int day;
  final bool isCurrent;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final planDay = template.dayFor(level, day);
    final summary = template.trackingType.tracksDuration
        ? planDay.targets.map(Fmt.duration).join(' · ')
        : planDay.summary;

    return AppCard(
      onTap: onTap,
      accented: isCurrent,
      background: isCurrent ? null : c.surfaceElevated,
      padding: const EdgeInsets.symmetric(horizontal: Gap.lg, vertical: Gap.lg),
      child: Row(
        children: [
          SizedBox(
            width: 74,
            child: Text(
              'Day $day',
              style: AppTypography.titleS.copyWith(color: c.textPrimary),
            ),
          ),
          Expanded(
            child: Text(
              summary,
              textAlign: TextAlign.end,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTypography.bodyStrong.copyWith(
                color: c.warning,
                fontFeatures: AppTypography.tabular,
              ),
            ),
          ),
          const SizedBox(width: Gap.sm),
          Icon(
            Icons.chevron_right_rounded,
            size: 20,
            color: isCurrent ? c.accent : c.textTertiary,
          ),
        ],
      ),
    );
  }
}
