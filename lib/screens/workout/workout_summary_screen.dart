import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/formatters.dart';
import '../../domain/badges/badge_catalog.dart';
import '../../domain/workout/workout_models.dart';
import '../../router.dart';
import '../../state/providers.dart';
import '../../theme/app_dimens.dart';
import '../../theme/app_theme.dart';
import '../../theme/app_typography.dart';
import '../../widgets/buttons.dart';
import '../../widgets/indicators.dart';
import '../../widgets/surfaces.dart';

/// Celebration + summary after a finished session.
///
/// Shows the streak step only when the streak actually moved: a second workout
/// on the same day gets an honest "already counted today" instead.
class WorkoutSummaryScreen extends ConsumerStatefulWidget {
  const WorkoutSummaryScreen({super.key, required this.workoutId, this.result});

  final int workoutId;

  /// Passed via `extra` when arriving straight from a session.
  final Object? result;

  @override
  ConsumerState<WorkoutSummaryScreen> createState() =>
      _WorkoutSummaryScreenState();
}

class _WorkoutSummaryScreenState extends ConsumerState<WorkoutSummaryScreen> {
  int _page = 0;

  WorkoutResult? get _result =>
      widget.result is WorkoutResult ? widget.result! as WorkoutResult : null;

  List<_SummaryPage> get _pages {
    final result = _result;
    final pages = <_SummaryPage>[_SummaryPage.totals];
    if (result == null) return pages;

    if (result.streakIncreased) pages.add(_SummaryPage.streak);
    if (result.newRecords.isNotEmpty) pages.add(_SummaryPage.records);
    if (result.newBadges.isNotEmpty) pages.add(_SummaryPage.badges);
    return pages;
  }

  void _advance() {
    if (_page < _pages.length - 1) {
      setState(() => _page++);
      return;
    }
    _exit();
  }

  void _exit() {
    refreshAll(ref);
    if (context.canPop()) {
      context.pop();
    } else {
      context.go(Routes.home);
    }
  }

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final result = _result;
    final pages = _pages;
    final page = pages[_page.clamp(0, pages.length - 1)];

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) _exit();
      },
      child: Scaffold(
        backgroundColor: c.background,
        body: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: AnimatedSwitcher(
                  duration: Motion.normal,
                  switchInCurve: Motion.emphasized,
                  child: switch (page) {
                    _SummaryPage.totals => _TotalsPage(
                      key: const ValueKey('totals'),
                      workoutId: widget.workoutId,
                      result: result,
                    ),
                    _SummaryPage.streak => _StreakPage(
                      key: const ValueKey('streak'),
                      streak: result?.streakAfter ?? 0,
                    ),
                    _SummaryPage.records => _RecordsPage(
                      key: const ValueKey('records'),
                      records: result?.newRecords ?? const [],
                    ),
                    _SummaryPage.badges => _BadgesPage(
                      key: const ValueKey('badges'),
                      codes: result?.newBadges ?? const [],
                    ),
                  },
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
                    if (pages.length > 1) ...[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          for (var i = 0; i < pages.length; i++)
                            AnimatedContainer(
                              duration: Motion.fast,
                              margin: const EdgeInsets.symmetric(horizontal: 3),
                              width: i == _page ? 18 : 6,
                              height: 6,
                              decoration: BoxDecoration(
                                color: i == _page ? c.accent : c.border,
                                borderRadius: Radii.pillRadius,
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: Gap.lg),
                    ],
                    PrimaryButton(
                      label: _page < pages.length - 1 ? 'Continue' : 'Done',
                      gradient: true,
                      onPressed: _advance,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

enum _SummaryPage { totals, streak, records, badges }

class _TotalsPage extends ConsumerWidget {
  const _TotalsPage({super.key, required this.workoutId, this.result});

  final int workoutId;
  final WorkoutResult? result;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final c = context.colors;
    final detail = ref.watch(workoutDetailProvider(workoutId)).valueOrNull;

    final reps = result?.totalReps ?? 0;
    final seconds = result?.totalDurationSeconds ?? 0;
    final headlineValue = reps > 0 ? Fmt.count(reps) : Fmt.duration(seconds);
    final headlineLabel = reps > 0 ? 'REPS' : 'TIME UNDER TENSION';

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: Gap.screenH),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: Gap.xxl),
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: Gap.lg,
              vertical: Gap.sm,
            ),
            decoration: BoxDecoration(
              color: c.successSoft,
              borderRadius: Radii.pillRadius,
              border: Border.all(color: c.success.withValues(alpha: 0.5)),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.check_rounded, size: 16, color: c.success),
                const SizedBox(width: Gap.sm),
                Text(
                  'WORKOUT COMPLETE',
                  style: AppTypography.overline.copyWith(color: c.success),
                ),
              ],
            ),
          ),
          const SizedBox(height: Gap.giant),
          GradientText(
            headlineValue,
            style: AppTypography.displayXL,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: Gap.sm),
          Text(
            headlineLabel,
            style: AppTypography.overline.copyWith(color: c.textTertiary),
          ),
          const SizedBox(height: Gap.xxxl),
          Text(
            'Nice work.',
            style: AppTypography.titleL.copyWith(color: c.textPrimary),
          ),
          if (result != null && !result!.isFirstWorkoutOfDay) ...[
            const SizedBox(height: Gap.sm),
            Text(
              'Today was already counted — this is a bonus session.',
              textAlign: TextAlign.center,
              style: AppTypography.bodySmall.copyWith(color: c.textSecondary),
            ),
          ],
          const SizedBox(height: Gap.xxxl),
          if (detail != null && detail.isNotEmpty)
            AppCard(
              child: Column(
                children: [
                  for (final (exercise, sets) in detail)
                    Padding(
                      padding: const EdgeInsets.only(bottom: Gap.md),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              exercise.exerciseName,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: AppTypography.bodyStrong.copyWith(
                                color: c.textPrimary,
                              ),
                            ),
                          ),
                          Text(
                            sets
                                .map(
                                  (s) => Fmt.trackedValue(
                                    s.reps > 0 ? s.reps : s.durationSeconds,
                                    exercise.trackingType,
                                  ),
                                )
                                .join(' · '),
                            style: AppTypography.bodySmall.copyWith(
                              color: c.warning,
                              fontFeatures: AppTypography.tabular,
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ),
          const SizedBox(height: Gap.xl),
        ],
      ),
    );
  }
}

class _StreakPage extends StatelessWidget {
  const _StreakPage({super.key, required this.streak});

  final int streak;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: Gap.screenH),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'STREAK',
              style: AppTypography.overline.copyWith(color: c.textTertiary),
            ),
            const SizedBox(height: Gap.giant),
            TweenAnimationBuilder<double>(
              tween: Tween(begin: 0.6, end: 1),
              duration: Motion.celebrate,
              curve: Motion.springy,
              builder: (context, scale, child) =>
                  Transform.scale(scale: scale, child: child),
              child: StreakFlame(days: streak, size: 96),
            ),
            const SizedBox(height: Gap.giant),
            Text(
              'Streak increased',
              style: AppTypography.displayS.copyWith(color: c.textPrimary),
            ),
            const SizedBox(height: Gap.sm),
            Text(
              'Come back tomorrow to keep it burning.',
              textAlign: TextAlign.center,
              style: AppTypography.body.copyWith(color: c.textSecondary),
            ),
          ],
        ),
      ),
    );
  }
}

class _RecordsPage extends StatelessWidget {
  const _RecordsPage({super.key, required this.records});

  final List<String> records;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: Gap.screenH),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.emoji_events_rounded,
              size: 72,
              color: c.warning,
              shadows: [
                Shadow(color: c.warning.withValues(alpha: 0.5), blurRadius: 28),
              ],
            ),
            const SizedBox(height: Gap.xxl),
            Text(
              records.length == 1
                  ? 'New personal record'
                  : '${records.length} new records',
              textAlign: TextAlign.center,
              style: AppTypography.displayS.copyWith(color: c.textPrimary),
            ),
            const SizedBox(height: Gap.xxl),
            for (final r in records)
              Padding(
                padding: const EdgeInsets.only(bottom: Gap.sm),
                child: AppCard(
                  padding: const EdgeInsets.symmetric(
                    horizontal: Gap.lg,
                    vertical: Gap.md,
                  ),
                  borderColor: c.warning.withValues(alpha: 0.4),
                  child: Row(
                    children: [
                      Icon(
                        Icons.trending_up_rounded,
                        size: 18,
                        color: c.warning,
                      ),
                      const SizedBox(width: Gap.md),
                      Expanded(
                        child: Text(
                          r,
                          style: AppTypography.bodyStrong.copyWith(
                            color: c.textPrimary,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _BadgesPage extends StatelessWidget {
  const _BadgesPage({super.key, required this.codes});

  final List<String> codes;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final defs = [
      for (final code in codes)
        if (BadgeCatalog.byCode(code) != null) BadgeCatalog.byCode(code)!,
    ];

    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: Gap.screenH),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              defs.length == 1 ? 'BADGE UNLOCKED' : 'BADGES UNLOCKED',
              style: AppTypography.overline.copyWith(color: c.accent),
            ),
            const SizedBox(height: Gap.xxxl),
            Wrap(
              spacing: Gap.lg,
              runSpacing: Gap.lg,
              alignment: WrapAlignment.center,
              children: [
                for (final def in defs)
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 84,
                        height: 84,
                        decoration: BoxDecoration(
                          gradient: c.brandGradient,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: c.accent.withValues(alpha: 0.45),
                              blurRadius: 26,
                              spreadRadius: -6,
                            ),
                          ],
                        ),
                        child: Icon(
                          def.icon,
                          size: 40,
                          color: c.accentContrast,
                        ),
                      ),
                      const SizedBox(height: Gap.md),
                      SizedBox(
                        width: 110,
                        child: Text(
                          def.title,
                          textAlign: TextAlign.center,
                          style: AppTypography.titleS.copyWith(
                            color: c.textPrimary,
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 130,
                        child: Text(
                          def.description,
                          textAlign: TextAlign.center,
                          style: AppTypography.caption.copyWith(
                            color: c.textSecondary,
                          ),
                        ),
                      ),
                    ],
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
