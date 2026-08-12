import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/formatters.dart';
import '../../data/repositories/goal_repository.dart';
import '../../router.dart';
import '../../state/providers.dart';
import '../../theme/app_dimens.dart';
import '../../theme/app_theme.dart';
import '../../theme/app_typography.dart';
import '../../widgets/indicators.dart';
import '../../widgets/surfaces.dart';

/// List of goals, open ones first.
class GoalsScreen extends ConsumerWidget {
  const GoalsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final c = context.colors;
    final goalsAsync = ref.watch(goalsProvider);

    return Scaffold(
      backgroundColor: c.background,
      appBar: AppBar(title: const Text('Goals')),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push(Routes.newGoal),
        backgroundColor: c.accent,
        foregroundColor: c.accentContrast,
        icon: const Icon(Icons.add_rounded),
        label: Text('New goal', style: AppTypography.button),
      ),
      body: SafeArea(
        top: false,
        child: goalsAsync.when(
          loading: () =>
              Center(child: CircularProgressIndicator(color: c.accent)),
          error: (e, _) => EmptyState(
            icon: Icons.error_outline_rounded,
            title: 'Could not load goals',
            message: '$e',
          ),
          data: (goals) {
            if (goals.isEmpty) {
              return EmptyState(
                icon: Icons.flag_outlined,
                title: 'No goals yet',
                message:
                    'Pick something concrete to aim at — 25 push-ups in one '
                    'set, a 30-day streak, four sessions a week.',
                actionLabel: 'Create a goal',
                onAction: () => context.push(Routes.newGoal),
              );
            }

            final open = goals.where((g) => !g.goal.isCompleted).toList();
            final done = goals.where((g) => g.goal.isCompleted).toList();

            return ListView(
              padding: const EdgeInsets.fromLTRB(
                Gap.screenH,
                Gap.lg,
                Gap.screenH,
                Sizes.scrollBottomInset,
              ),
              children: [
                if (open.isNotEmpty) ...[
                  const SectionHeader(title: 'In progress'),
                  for (final g in open)
                    Padding(
                      padding: const EdgeInsets.only(bottom: Gap.md),
                      child: _GoalCard(view: g),
                    ),
                ],
                if (done.isNotEmpty) ...[
                  const SizedBox(height: Gap.lg),
                  SectionHeader(title: 'Completed · ${done.length}'),
                  for (final g in done)
                    Padding(
                      padding: const EdgeInsets.only(bottom: Gap.md),
                      child: _GoalCard(view: g),
                    ),
                ],
              ],
            );
          },
        ),
      ),
    );
  }
}

class _GoalCard extends ConsumerWidget {
  const _GoalCard({required this.view});

  final GoalView view;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final c = context.colors;
    final goal = view.goal;
    final isDone = goal.isCompleted;
    final days = view.daysRemaining;

    return AppCard(
      onTap: () => context.push(Routes.editGoal(goal.id)),
      borderColor: isDone ? c.success.withValues(alpha: 0.45) : null,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: isDone ? c.successSoft : c.accentSoft,
                  borderRadius: BorderRadius.circular(Radii.xs),
                ),
                child: Icon(
                  isDone ? Icons.check_rounded : goal.type.icon,
                  size: 18,
                  color: isDone ? c.success : c.accent,
                ),
              ),
              const SizedBox(width: Gap.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      goal.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: AppTypography.titleS.copyWith(
                        color: c.textPrimary,
                      ),
                    ),
                    Text(
                      view.exercise == null
                          ? goal.type.label
                          : '${goal.type.label} · ${view.exercise!.name}',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTypography.caption.copyWith(
                        color: c.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              if (view.isOverdue)
                TagChip(label: 'Overdue', color: c.danger, dense: true)
              else if (days != null && !isDone)
                TagChip(
                  label: days == 0 ? 'Today' : '${days}d left',
                  color: days <= 3 ? c.warning : c.textTertiary,
                  dense: true,
                ),
            ],
          ),
          const SizedBox(height: Gap.lg),
          LinearMeter(
            progress: view.progress,
            trailingLabel:
                '${Fmt.count(goal.achievedValue)} / '
                '${Fmt.count(goal.targetValue)} ${view.unit}',
            color: isDone ? c.success : c.accent,
          ),
        ],
      ),
    );
  }
}
