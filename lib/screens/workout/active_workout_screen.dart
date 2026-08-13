import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:proximity_sensor/proximity_sensor.dart';
import 'package:wakelock_plus/wakelock_plus.dart';

import '../../core/formatters.dart';
import '../../domain/enums.dart';
import '../../domain/workout/workout_models.dart';
import '../../router.dart';
import '../../state/providers.dart';
import '../../theme/app_dimens.dart';
import '../../theme/app_theme.dart';
import '../../theme/app_typography.dart';
import '../../widgets/buttons.dart';
import '../../widgets/indicators.dart';
import '../../widgets/surfaces.dart';

/// What the session screen is doing right now.
enum _Phase { counting, resting, finished }

/// The live workout screen: one exercise at a time, one set at a time.
///
/// Deliberately single-purpose — a big counter, the set targets, and two
/// buttons. Every completed set is written to the database immediately, so
/// closing the app mid-session loses nothing.
class ActiveWorkoutScreen extends ConsumerStatefulWidget {
  const ActiveWorkoutScreen({super.key, required this.workoutId});

  final int? workoutId;

  @override
  ConsumerState<ActiveWorkoutScreen> createState() =>
      _ActiveWorkoutScreenState();
}

class _ActiveWorkoutScreenState extends ConsumerState<ActiveWorkoutScreen> {
  ActiveWorkout? _workout;
  bool _loading = true;
  String? _loadError;

  _Phase _phase = _Phase.counting;

  /// Live rep count for the set in progress.
  int _reps = 0;

  /// Elapsed seconds for a duration set.
  int _heldSeconds = 0;
  bool _holdRunning = false;

  double _weightKg = 0;

  int _restRemaining = 0;
  int _restTotal = 0;

  Timer? _ticker;
  StreamSubscription<int>? _proximity;
  bool _proximityNear = false;
  bool _finishing = false;

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void dispose() {
    _ticker?.cancel();
    _proximity?.cancel();
    WakelockPlus.disable();
    super.dispose();
  }

  Future<void> _load() async {
    final id = widget.workoutId;
    final repo = ref.read(workoutRepositoryProvider);

    try {
      final workout = id == null
          ? await repo.resumableWorkout()
          : await repo.loadActive(id);

      if (!mounted) return;
      if (workout == null || workout.isEmpty) {
        setState(() {
          _loading = false;
          _loadError = 'This session is no longer available.';
        });
        return;
      }

      setState(() {
        _workout = workout;
        _loading = false;
        _weightKg = _currentSet(workout)?.weightKg ?? 0;
      });

      if (ref.read(settingsProvider).keepScreenAwake) {
        await WakelockPlus.enable();
      }
      _maybeStartProximity();
    } on Object catch (e) {
      if (!mounted) return;
      setState(() {
        _loading = false;
        _loadError = 'Could not open the session: $e';
      });
    }
  }

  // -------------------------------------------------------------- accessors

  LiveExercise? _currentExercise([ActiveWorkout? w]) =>
      (w ?? _workout)?.currentExercise;

  LiveSet? _currentSet([ActiveWorkout? w]) {
    final ex = _currentExercise(w);
    if (ex == null) return null;
    final index = ex.nextSetIndex;
    if (index == null) return null;
    return ex.sets[index];
  }

  TrackingType get _trackingType =>
      _currentExercise()?.trackingType ?? TrackingType.reps;

  int get _target {
    final t = _currentSet()?.target ?? 0;
    return t <= 0 ? 0 : t;
  }

  bool get _isOpenEnded => _target == 0;

  // ------------------------------------------------------------- proximity

  /// Enables nose-to-screen counting when the user has chosen it.
  ///
  /// Failure is silent: on a device without the sensor the tap counter keeps
  /// working, which is exactly the fallback the user needs.
  void _maybeStartProximity() {
    if (ref.read(settingsProvider).repInputMode != RepInputMode.proximity) {
      return;
    }
    if (!_trackingType.tracksReps) return;

    try {
      _proximity = ProximitySensor.events.listen((event) {
        final near = event > 0;
        if (near == _proximityNear) return;
        _proximityNear = near;
        // Count on release, i.e. at the top of the rep.
        if (!near && _phase == _Phase.counting) _addRep();
      });
    } on Object catch (_) {
      _proximity = null;
    }
  }

  // ------------------------------------------------------------ interaction

  void _addRep() {
    if (_phase != _Phase.counting) return;
    HapticFeedback.lightImpact();
    setState(() => _reps++);
  }

  void _removeRep() {
    if (_reps <= 0) return;
    HapticFeedback.selectionClick();
    setState(() => _reps--);
  }

  void _toggleHold() {
    if (_holdRunning) {
      _ticker?.cancel();
      setState(() => _holdRunning = false);
      return;
    }
    setState(() => _holdRunning = true);
    _ticker?.cancel();
    _ticker = Timer.periodic(const Duration(seconds: 1), (_) {
      if (!mounted) return;
      setState(() => _heldSeconds++);
      // A targeted hold ends itself so the user need not watch the screen.
      if (!_isOpenEnded && _heldSeconds >= _target) {
        HapticFeedback.mediumImpact();
        _completeSet();
      }
    });
  }

  Future<void> _completeSet() async {
    final workout = _workout;
    final set = _currentSet();
    final exercise = _currentExercise();
    if (workout == null || set == null || exercise == null) return;

    _ticker?.cancel();
    _holdRunning = false;

    final repo = ref.read(workoutRepositoryProvider);
    await repo.completeSet(
      setId: set.id,
      reps: _trackingType.tracksReps ? _reps : 0,
      weightKg: _trackingType.tracksWeight ? _weightKg : 0,
      durationSeconds: _trackingType.tracksDuration ? _heldSeconds : 0,
    );

    final refreshed = await repo.loadActive(workout.id);
    if (!mounted || refreshed == null) return;

    HapticFeedback.mediumImpact();

    final restSeconds =
        ref.read(settingsProvider).restSecondsOverride ?? exercise.restSeconds;

    setState(() {
      _workout = refreshed;
      _reps = 0;
      _heldSeconds = 0;
      _weightKg = _currentSet(refreshed)?.weightKg ?? _weightKg;

      if (refreshed.allDone) {
        _phase = _Phase.finished;
      } else if (restSeconds > 0) {
        _phase = _Phase.resting;
        _restTotal = restSeconds;
        _restRemaining = restSeconds;
        _startRestTicker();
      } else {
        _phase = _Phase.counting;
      }
    });

    if (refreshed.allDone) await _finish();
  }

  void _startRestTicker() {
    _ticker?.cancel();
    _ticker = Timer.periodic(const Duration(seconds: 1), (_) {
      if (!mounted) return;
      if (_restRemaining <= 1) {
        HapticFeedback.mediumImpact();
        _skipRest();
        return;
      }
      setState(() => _restRemaining--);
    });
  }

  void _skipRest() {
    _ticker?.cancel();
    if (!mounted) return;
    setState(() {
      _phase = _Phase.counting;
      _restRemaining = 0;
    });
  }

  Future<void> _skipExercise() async {
    final workout = _workout;
    final exercise = _currentExercise();
    if (workout == null || exercise == null) return;

    final repo = ref.read(workoutRepositoryProvider);
    await repo.skipExercise(exercise.id);
    final refreshed = await repo.loadActive(workout.id);
    if (!mounted || refreshed == null) return;

    _ticker?.cancel();
    setState(() {
      _workout = refreshed;
      _reps = 0;
      _heldSeconds = 0;
      _phase = refreshed.allDone ? _Phase.finished : _Phase.counting;
    });

    if (refreshed.allDone) await _finish();
  }

  /// Appends another set — how "one more" and free practice both work.
  Future<void> _addAnotherSet() async {
    final workout = _workout;
    final exercise = _currentExercise();
    if (workout == null || exercise == null) return;

    final repo = ref.read(workoutRepositoryProvider);
    await repo.addSet(exercise.id, weightKg: _weightKg);
    final refreshed = await repo.loadActive(workout.id);
    if (!mounted || refreshed == null) return;

    setState(() {
      _workout = refreshed;
      _reps = 0;
      _heldSeconds = 0;
      _phase = _Phase.counting;
    });
  }

  Future<void> _finish() async {
    final workout = _workout;
    if (workout == null || _finishing) return;

    // Nothing logged means nothing to save — discard rather than record a
    // zero-rep session that would wrongly extend the streak.
    if (workout.completedSets == 0) {
      await _cancel(confirm: false);
      return;
    }

    setState(() => _finishing = true);
    _ticker?.cancel();

    final repo = ref.read(workoutRepositoryProvider);
    final isPlan = workout.source == WorkoutSource.plan;

    SessionFeedback? feedback;
    if (isPlan && mounted) {
      feedback = await _askFeedback();
      // Backing out of the feedback sheet keeps the session open.
      if (feedback == null) {
        if (mounted) setState(() => _finishing = false);
        return;
      }
    }

    try {
      final result = await repo.finishWorkout(
        workoutId: workout.id,
        feedback: feedback,
      );
      if (!mounted) return;

      refreshAll(ref);
      await WakelockPlus.disable();

      if (!mounted) return;
      context.pushReplacement(Routes.workoutSummary(workout.id), extra: result);
    } on Object catch (e) {
      if (!mounted) return;
      setState(() => _finishing = false);
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(SnackBar(content: Text('Could not save: $e')));
    }
  }

  Future<SessionFeedback?> _askFeedback() {
    return showModalBottomSheet<SessionFeedback>(
      context: context,
      isScrollControlled: true,
      builder: (context) => const _FeedbackSheet(),
    );
  }

  /// Leaves the session screen.
  ///
  /// The screen is normally pushed on top of the shell, but it is also
  /// reachable directly (deep link, or as the first route in a test), where
  /// there is nothing to pop — fall back to home rather than throwing.
  void _leave() {
    if (!mounted) return;
    if (context.canPop()) {
      context.pop();
    } else {
      context.go(Routes.home);
    }
  }

  Future<void> _cancel({bool confirm = true}) async {
    final workout = _workout;
    if (workout == null) {
      _leave();
      return;
    }

    if (confirm && workout.completedSets > 0) {
      final discard = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Discard this session?'),
          content: Text(
            '${workout.completedSets} completed '
            '${workout.completedSets == 1 ? 'set' : 'sets'} will be lost.',
          ),
          actions: [
            TextButton(
              onPressed: () => context.pop(false),
              child: const Text('Keep going'),
            ),
            TextButton(
              onPressed: () => context.pop(true),
              child: Text(
                'Discard',
                style: TextStyle(color: context.colors.danger),
              ),
            ),
          ],
        ),
      );
      if (discard != true) return;
    }

    await ref.read(workoutRepositoryProvider).cancelWorkout(workout.id);
    await WakelockPlus.disable();
    if (!mounted) return;
    ref.invalidate(resumableWorkoutProvider);
    _leave();
  }

  /// Ends early but keeps what was already completed.
  Future<void> _finishEarly() async {
    _ticker?.cancel();
    await _finish();
  }

  // ------------------------------------------------------------------ build

  @override
  Widget build(BuildContext context) {
    final c = context.colors;

    if (_loading) {
      return Scaffold(
        backgroundColor: c.background,
        body: Center(child: CircularProgressIndicator(color: c.accent)),
      );
    }

    final workout = _workout;
    if (workout == null || _loadError != null) {
      return Scaffold(
        backgroundColor: c.background,
        appBar: AppBar(title: const Text('Workout')),
        body: Center(
          child: EmptyState(
            icon: Icons.error_outline_rounded,
            title: 'Session unavailable',
            message: _loadError ?? 'This workout could not be opened.',
            actionLabel: 'Back to home',
            onAction: () => context.go(Routes.home),
          ),
        ),
      );
    }

    final exercise = _currentExercise()!;

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) _cancel();
      },
      child: Scaffold(
        backgroundColor: c.background,
        body: SafeArea(
          child: Column(
            children: [
              _Header(
                title: exercise.name,
                subtitle: workout.source == WorkoutSource.plan
                    ? 'Day ${workout.planDay} · Level ${workout.planLevel}'
                    : workout.source.label,
                progress: workout.progress,
                onClose: _cancel,
              ),
              const SizedBox(height: Gap.lg),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: Gap.screenH),
                child: SetChipRow(
                  targets: [
                    for (final s in exercise.sets)
                      s.target ??
                          (s.isCompleted
                              ? s.achievedFor(exercise.trackingType)
                              : 0),
                  ],
                  completed: [for (final s in exercise.sets) s.isCompleted],
                  activeIndex: exercise.nextSetIndex ?? exercise.sets.length,
                ),
              ),
              Expanded(
                child: Center(
                  child: switch (_phase) {
                    _Phase.resting => _RestView(
                      remaining: _restRemaining,
                      total: _restTotal,
                      onSkip: _skipRest,
                    ),
                    _ => _CounterView(
                      trackingType: exercise.trackingType,
                      reps: _reps,
                      heldSeconds: _heldSeconds,
                      holdRunning: _holdRunning,
                      target: _target,
                      isOpenEnded: _isOpenEnded,
                      inputMode: ref.watch(
                        settingsProvider.select((s) => s.repInputMode),
                      ),
                      onTapCount: _addRep,
                      onRemove: _removeRep,
                      onToggleHold: _toggleHold,
                    ),
                  },
                ),
              ),
              _Controls(
                phase: _phase,
                trackingType: exercise.trackingType,
                canComplete: _trackingType.tracksReps
                    ? _reps > 0
                    : _heldSeconds > 0,
                isLastSet: exercise.nextSetIndex == exercise.sets.length - 1,
                finishing: _finishing,
                weightKg: _weightKg,
                unitSystem: ref.watch(unitSystemProvider),
                onWeightChanged: (v) => setState(() => _weightKg = v),
                onCompleteSet: _completeSet,
                onSkipExercise: _skipExercise,
                onAddSet: _addAnotherSet,
                onFinish: _finishEarly,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------

class _Header extends StatelessWidget {
  const _Header({
    required this.title,
    required this.subtitle,
    required this.progress,
    required this.onClose,
  });

  final String title;
  final String subtitle;
  final double progress;
  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Padding(
      padding: const EdgeInsets.fromLTRB(Gap.md, Gap.sm, Gap.md, 0),
      child: Column(
        children: [
          Row(
            children: [
              IconPill(
                icon: Icons.close_rounded,
                size: 36,
                tooltip: 'Cancel workout',
                onPressed: onClose,
              ),
              Expanded(
                child: Column(
                  children: [
                    Text(
                      title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTypography.titleL.copyWith(
                        color: c.textPrimary,
                      ),
                    ),
                    Text(
                      subtitle,
                      style: AppTypography.caption.copyWith(
                        color: c.textTertiary,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 44),
            ],
          ),
          const SizedBox(height: Gap.md),
          LinearMeter(progress: progress, height: 4),
        ],
      ),
    );
  }
}

class _CounterView extends StatelessWidget {
  const _CounterView({
    required this.trackingType,
    required this.reps,
    required this.heldSeconds,
    required this.holdRunning,
    required this.target,
    required this.isOpenEnded,
    required this.inputMode,
    required this.onTapCount,
    required this.onRemove,
    required this.onToggleHold,
  });

  final TrackingType trackingType;
  final int reps;
  final int heldSeconds;
  final bool holdRunning;
  final int target;
  final bool isOpenEnded;
  final RepInputMode inputMode;
  final VoidCallback onTapCount;
  final VoidCallback onRemove;
  final VoidCallback onToggleHold;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final isDuration = trackingType.tracksDuration;
    final value = isDuration ? heldSeconds : reps;
    final progress = isOpenEnded ? 1.0 : value / target;
    final reached = !isOpenEnded && value >= target;

    // The ring is the biggest thing on screen, so it has to yield on short
    // displays — a fixed size overflows in landscape and on small phones.
    final available = MediaQuery.sizeOf(context);
    final ringSize = math
        .min(available.width - Gap.screenH * 2, available.height * 0.42)
        .clamp(180.0, 268.0);

    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (reached)
            Container(
              margin: const EdgeInsets.only(bottom: Gap.xl),
              padding: const EdgeInsets.symmetric(
                horizontal: Gap.lg,
                vertical: Gap.sm,
              ),
              decoration: BoxDecoration(
                color: c.warningSoft,
                borderRadius: Radii.pillRadius,
                border: Border.all(color: c.warning.withValues(alpha: 0.5)),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.bolt_rounded, size: 16, color: c.warning),
                  const SizedBox(width: Gap.sm),
                  Text(
                    'Target hit — squeeze out more',
                    style: AppTypography.caption.copyWith(color: c.warning),
                  ),
                ],
              ),
            ),
          GestureDetector(
            onTap: isDuration ? onToggleHold : onTapCount,
            onLongPress: isDuration ? null : onRemove,
            behavior: HitTestBehavior.opaque,
            child: ProgressRing(
              progress: progress,
              size: ringSize,
              strokeWidth: 18,
              semanticsLabel: isDuration ? 'Hold timer' : 'Rep counter',
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    GradientText(
                      isDuration ? Fmt.clock(heldSeconds) : '$value',
                      style: AppTypography.displayXL.copyWith(
                        fontSize: isDuration ? 72 : 96,
                      ),
                    ),
                    const SizedBox(height: Gap.xs),
                    Text(
                      isDuration ? 'HOLD' : 'REPS',
                      style: AppTypography.overline.copyWith(
                        color: c.textTertiary,
                      ),
                    ),
                    const SizedBox(height: Gap.sm),
                    Text(
                      isOpenEnded
                          ? 'No limit'
                          : 'Target ${isDuration ? Fmt.duration(target) : target}',
                      style: AppTypography.titleS.copyWith(
                        color: c.textPrimary,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: Gap.xxl),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                isDuration
                    ? (holdRunning
                          ? Icons.pause_circle_outline
                          : Icons.play_circle_outline)
                    : inputMode == RepInputMode.proximity
                    ? Icons.sensors_rounded
                    : Icons.touch_app_outlined,
                size: 16,
                color: c.textTertiary,
              ),
              const SizedBox(width: Gap.sm),
              Flexible(
                child: Text(
                  isDuration
                      ? (holdRunning
                            ? 'Tap the ring to pause'
                            : 'Tap the ring to start')
                      : inputMode.hint,
                  textAlign: TextAlign.center,
                  style: AppTypography.bodySmall.copyWith(
                    color: c.textTertiary,
                  ),
                ),
              ),
            ],
          ),
          if (!isDuration && reps > 0) ...[
            const SizedBox(height: Gap.sm),
            Text(
              'Long-press the ring to undo a rep',
              style: AppTypography.caption.copyWith(color: c.textTertiary),
            ),
          ],
        ],
      ),
    );
  }
}

class _RestView extends StatelessWidget {
  const _RestView({
    required this.remaining,
    required this.total,
    required this.onSkip,
  });

  final int remaining;
  final int total;
  final VoidCallback onSkip;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final available = MediaQuery.sizeOf(context);
    final ringSize = math
        .min(available.width - Gap.screenH * 2, available.height * 0.42)
        .clamp(180.0, 268.0);

    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            margin: const EdgeInsets.only(bottom: Gap.xl),
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
                  'Set complete',
                  style: AppTypography.caption.copyWith(color: c.success),
                ),
              ],
            ),
          ),
          ProgressRing(
            progress: total == 0 ? 0 : remaining / total,
            size: ringSize,
            strokeWidth: 18,
            useGradient: false,
            color: c.success,
            semanticsLabel: 'Rest timer',
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    Fmt.clock(remaining),
                    style: AppTypography.displayL.copyWith(
                      color: c.success,
                      fontFeatures: AppTypography.tabular,
                    ),
                  ),
                  const SizedBox(height: Gap.xs),
                  Text(
                    'REST',
                    style: AppTypography.overline.copyWith(
                      color: c.textTertiary,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: Gap.xxl),
          SecondaryButton(
            label: 'Skip rest',
            icon: Icons.fast_forward_rounded,
            expanded: false,
            onPressed: onSkip,
          ),
        ],
      ),
    );
  }
}

class _Controls extends StatelessWidget {
  const _Controls({
    required this.phase,
    required this.trackingType,
    required this.canComplete,
    required this.isLastSet,
    required this.finishing,
    required this.weightKg,
    required this.unitSystem,
    required this.onWeightChanged,
    required this.onCompleteSet,
    required this.onSkipExercise,
    required this.onAddSet,
    required this.onFinish,
  });

  final _Phase phase;
  final TrackingType trackingType;
  final bool canComplete;
  final bool isLastSet;
  final bool finishing;
  final double weightKg;
  final UnitSystem unitSystem;
  final ValueChanged<double> onWeightChanged;
  final VoidCallback onCompleteSet;
  final VoidCallback onSkipExercise;
  final VoidCallback onAddSet;
  final VoidCallback onFinish;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;

    return Padding(
      padding: const EdgeInsets.fromLTRB(
        Gap.screenH,
        Gap.lg,
        Gap.screenH,
        Gap.xl,
      ),
      child: Column(
        children: [
          if (trackingType.tracksWeight && phase == _Phase.counting) ...[
            _WeightStepper(
              weightKg: weightKg,
              units: unitSystem,
              onChanged: onWeightChanged,
            ),
            const SizedBox(height: Gap.lg),
          ],
          Row(
            children: [
              Expanded(
                child: SecondaryButton(
                  label: 'Skip',
                  onPressed: finishing ? null : onSkipExercise,
                  tone: c.textSecondary,
                ),
              ),
              const SizedBox(width: Gap.md),
              Expanded(
                flex: 2,
                child: phase == _Phase.resting
                    ? PrimaryButton(
                        label: 'Finish workout',
                        loading: finishing,
                        onPressed: finishing ? null : onFinish,
                      )
                    : PrimaryButton(
                        label: 'Done',
                        gradient: true,
                        loading: finishing,
                        onPressed: canComplete && !finishing
                            ? onCompleteSet
                            : null,
                      ),
              ),
            ],
          ),
          const SizedBox(height: Gap.sm),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextButton.icon(
                onPressed: finishing ? null : onAddSet,
                icon: const Icon(Icons.add_rounded, size: 18),
                label: const Text('Add set'),
                style: TextButton.styleFrom(foregroundColor: c.textSecondary),
              ),
              const SizedBox(width: Gap.lg),
              TextButton.icon(
                onPressed: finishing ? null : onFinish,
                icon: const Icon(Icons.flag_outlined, size: 18),
                label: const Text('End & save'),
                style: TextButton.styleFrom(foregroundColor: c.textSecondary),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _WeightStepper extends StatelessWidget {
  const _WeightStepper({
    required this.weightKg,
    required this.units,
    required this.onChanged,
  });

  final double weightKg;
  final UnitSystem units;
  final ValueChanged<double> onChanged;

  /// Step in kg — 2.5 kg is the smallest plate pair on most bars.
  static const double _step = 2.5;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: Gap.sm, vertical: Gap.sm),
      decoration: BoxDecoration(
        color: c.surface,
        borderRadius: Radii.pillRadius,
        border: Border.all(color: c.border),
      ),
      child: Row(
        children: [
          IconPill(
            icon: Icons.remove_rounded,
            size: 34,
            tooltip: 'Less weight',
            onPressed: weightKg <= 0
                ? null
                : () => onChanged((weightKg - _step).clamp(0, 999)),
          ),
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  weightKg <= 0 ? 'Bodyweight' : Fmt.weight(weightKg, units),
                  style: AppTypography.titleS.copyWith(color: c.textPrimary),
                ),
                Text(
                  'Load',
                  style: AppTypography.caption.copyWith(color: c.textTertiary),
                ),
              ],
            ),
          ),
          IconPill(
            icon: Icons.add_rounded,
            size: 34,
            tooltip: 'More weight',
            onPressed: () => onChanged((weightKg + _step).clamp(0, 999)),
          ),
        ],
      ),
    );
  }
}

/// Post-session prompt that drives the adaptive plan.
class _FeedbackSheet extends StatefulWidget {
  const _FeedbackSheet();

  @override
  State<_FeedbackSheet> createState() => _FeedbackSheetState();
}

class _FeedbackSheetState extends State<_FeedbackSheet> {
  SessionFeedback? _selected;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Padding(
      padding: EdgeInsets.fromLTRB(
        Gap.screenH,
        Gap.sm,
        Gap.screenH,
        MediaQuery.viewInsetsOf(context).bottom + Gap.xl,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'How did that feel?',
            style: AppTypography.displayS.copyWith(
              color: c.accent,
              fontSize: 28,
            ),
          ),
          const SizedBox(height: Gap.xs),
          Text(
            'Your answer sets your next workout.',
            style: AppTypography.body.copyWith(color: c.textSecondary),
          ),
          const SizedBox(height: Gap.xxl),
          for (final option in SessionFeedback.values)
            Padding(
              padding: const EdgeInsets.only(bottom: Gap.md),
              child: _FeedbackOption(
                option: option,
                isSelected: option == _selected,
                onTap: () => setState(() => _selected = option),
              ),
            ),
          const SizedBox(height: Gap.lg),
          PrimaryButton(
            label: _selected == null ? 'Choose to continue' : 'Save & finish',
            gradient: _selected != null,
            onPressed: _selected == null
                ? null
                : () => Navigator.of(context).pop(_selected),
          ),
        ],
      ),
    );
  }
}

class _FeedbackOption extends StatelessWidget {
  const _FeedbackOption({
    required this.option,
    required this.isSelected,
    required this.onTap,
  });

  final SessionFeedback option;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return AppCard(
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
              option.icon,
              size: 20,
              color: isSelected ? c.accentContrast : c.textTertiary,
            ),
          ),
          const SizedBox(width: Gap.lg),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  option.label,
                  style: AppTypography.titleS.copyWith(color: c.textPrimary),
                ),
                Text(
                  option.subtitle,
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
