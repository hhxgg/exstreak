import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/day.dart';
import '../../core/formatters.dart';
import '../../data/database.dart';
import '../../domain/enums.dart';
import '../../state/providers.dart';
import '../../theme/app_dimens.dart';
import '../../theme/app_theme.dart';
import '../../theme/app_typography.dart';
import '../../widgets/buttons.dart';
import '../../widgets/surfaces.dart';

/// Create or edit a goal.
class GoalEditorScreen extends ConsumerStatefulWidget {
  const GoalEditorScreen({super.key, this.goalId});

  final int? goalId;

  @override
  ConsumerState<GoalEditorScreen> createState() => _GoalEditorScreenState();
}

class _GoalEditorScreenState extends ConsumerState<GoalEditorScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _targetController = TextEditingController();

  GoalType _type = GoalType.singleSetRecord;
  int? _exerciseId;
  Day? _deadline;

  GoalRow? _existing;
  bool _loading = true;
  bool _saving = false;
  bool _titleEditedByUser = false;

  bool get _isEditing => widget.goalId != null;

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _targetController.dispose();
    super.dispose();
  }

  Future<void> _load() async {
    final id = widget.goalId;
    if (id == null) {
      final exercises = await ref.read(exerciseRepositoryProvider).all();
      if (!mounted) return;
      setState(() {
        _exerciseId = exercises.isEmpty ? null : exercises.first.id;
        _targetController.text = '25';
        _loading = false;
      });
      _syncSuggestedTitle();
      return;
    }

    final row = await ref.read(databaseProvider).goalById(id);
    if (!mounted) return;
    if (row != null) {
      _titleController.text = row.title;
      _targetController.text = _trimNumber(row.targetValue);
      _type = row.type;
      _exerciseId = row.exerciseId;
      _deadline = row.deadlineDayKey == null
          ? null
          : Day.fromEpochKey(row.deadlineDayKey!);
      _titleEditedByUser = true;
    }
    setState(() {
      _existing = row;
      _loading = false;
    });
  }

  static String _trimNumber(double v) =>
      v == v.roundToDouble() ? '${v.round()}' : v.toStringAsFixed(1);

  /// Keeps the title in step with the chosen type until the user types
  /// their own — then it is left alone.
  void _syncSuggestedTitle() {
    if (_titleEditedByUser) return;
    final exercises = ref.read(exercisesProvider).valueOrNull ?? const [];
    ExerciseRow? exercise;
    for (final e in exercises) {
      if (e.id == _exerciseId) exercise = e;
    }
    final target = _targetController.text.trim();

    final suggestion = switch (_type) {
      GoalType.singleSetRecord =>
        '$target ${exercise?.name ?? 'reps'} in one set',
      GoalType.totalVolume => '$target ${exercise?.name ?? 'reps'} total',
      GoalType.streakDays => '$target-day streak',
      GoalType.workoutCount => 'Complete $target workouts',
      GoalType.weeklyFrequency => 'Train $target times a week',
    };
    _titleController.text = suggestion;
  }

  Future<void> _save() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    setState(() => _saving = true);

    final repo = ref.read(goalRepositoryProvider);
    final target = double.tryParse(
      _targetController.text.trim().replaceAll(',', '.'),
    );
    if (target == null) {
      setState(() => _saving = false);
      return;
    }

    try {
      if (_existing != null) {
        await repo.update(
          _existing!.id,
          title: _titleController.text,
          targetValue: target,
          deadline: _deadline,
          clearDeadline: _deadline == null,
        );
      } else {
        await repo.create(
          title: _titleController.text,
          type: _type,
          targetValue: target,
          exerciseId: _exerciseId,
          deadline: _deadline,
        );
      }

      // Recompute immediately so the new goal shows real progress, not zero.
      await ref.read(workoutRepositoryProvider).refreshGoals();

      if (!mounted) return;
      context.pop();
    } on Object catch (e) {
      if (!mounted) return;
      setState(() => _saving = false);
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(SnackBar(content: Text('Could not save: $e')));
    }
  }

  Future<void> _delete() async {
    final existing = _existing;
    if (existing == null) return;
    final c = context.colors;

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete this goal?'),
        content: const Text('This cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => context.pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => context.pop(true),
            child: Text('Delete', style: TextStyle(color: c.danger)),
          ),
        ],
      ),
    );
    if (confirmed != true || !mounted) return;

    await ref.read(goalRepositoryProvider).delete(existing.id);
    if (mounted) context.pop();
  }

  @override
  Widget build(BuildContext context) {
    final c = context.colors;

    if (_loading) {
      return Scaffold(
        backgroundColor: c.background,
        appBar: AppBar(),
        body: Center(child: CircularProgressIndicator(color: c.accent)),
      );
    }

    final exercises = ref.watch(exercisesProvider).valueOrNull ?? const [];
    final needsExercise = _type.needsExercise;

    return Scaffold(
      backgroundColor: c.background,
      appBar: AppBar(
        title: Text(_isEditing ? 'Edit goal' : 'New goal'),
        actions: [
          if (_isEditing)
            IconButton(
              tooltip: 'Delete goal',
              icon: Icon(Icons.delete_outline_rounded, color: c.danger),
              onPressed: _delete,
            ),
        ],
      ),
      body: SafeArea(
        top: false,
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.fromLTRB(
                    Gap.screenH,
                    Gap.lg,
                    Gap.screenH,
                    Gap.xl,
                  ),
                  children: [
                    const SectionHeader(title: 'Type'),
                    if (_isEditing)
                      AppCard(
                        child: Row(
                          children: [
                            Icon(_type.icon, size: 18, color: c.accent),
                            const SizedBox(width: Gap.md),
                            Expanded(
                              child: Text(
                                _type.label,
                                style: AppTypography.titleS.copyWith(
                                  color: c.textPrimary,
                                ),
                              ),
                            ),
                            Text(
                              'Fixed',
                              style: AppTypography.caption.copyWith(
                                color: c.textTertiary,
                              ),
                            ),
                          ],
                        ),
                      )
                    else
                      for (final type in GoalType.values)
                        Padding(
                          padding: const EdgeInsets.only(bottom: Gap.sm),
                          child: AppCard(
                            onTap: () {
                              setState(() => _type = type);
                              _syncSuggestedTitle();
                            },
                            accented: type == _type,
                            background: type == _type ? c.accentSoft : null,
                            padding: const EdgeInsets.all(Gap.lg),
                            child: Row(
                              children: [
                                Icon(
                                  type.icon,
                                  size: 20,
                                  color: type == _type
                                      ? c.accent
                                      : c.textTertiary,
                                ),
                                const SizedBox(width: Gap.md),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        type.label,
                                        style: AppTypography.titleS.copyWith(
                                          color: c.textPrimary,
                                        ),
                                      ),
                                      Text(
                                        type.description,
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

                    if (needsExercise && !_isEditing) ...[
                      const SizedBox(height: Gap.xl),
                      const SectionHeader(title: 'Exercise'),
                      DropdownButtonFormField<int>(
                        initialValue: _exerciseId,
                        isExpanded: true,
                        dropdownColor: c.surfaceElevated,
                        borderRadius: BorderRadius.circular(Radii.sm),
                        decoration: const InputDecoration(
                          labelText: 'Which exercise?',
                        ),
                        items: [
                          for (final e in exercises)
                            DropdownMenuItem(
                              value: e.id,
                              child: Text(
                                e.name,
                                style: AppTypography.body.copyWith(
                                  color: c.textPrimary,
                                ),
                              ),
                            ),
                        ],
                        onChanged: (v) {
                          setState(() => _exerciseId = v);
                          _syncSuggestedTitle();
                        },
                        validator: (v) => needsExercise && v == null
                            ? 'Pick an exercise'
                            : null,
                      ),
                    ],

                    const SizedBox(height: Gap.xl),
                    const SectionHeader(title: 'Target'),
                    TextFormField(
                      controller: _targetController,
                      keyboardType: const TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(RegExp(r'[0-9.,]')),
                        LengthLimitingTextInputFormatter(7),
                      ],
                      onChanged: (_) => _syncSuggestedTitle(),
                      decoration: InputDecoration(
                        labelText: 'Target',
                        suffixText: _unitFor(_type, exercises),
                      ),
                      validator: (v) {
                        final value = double.tryParse(
                          (v ?? '').trim().replaceAll(',', '.'),
                        );
                        if (value == null) return 'Enter a number';
                        if (value <= 0) return 'Target must be above zero';
                        if (_type == GoalType.weeklyFrequency && value > 7) {
                          return 'A week has seven days';
                        }
                        return null;
                      },
                    ),

                    const SizedBox(height: Gap.xl),
                    const SectionHeader(title: 'Title'),
                    TextFormField(
                      controller: _titleController,
                      textCapitalization: TextCapitalization.sentences,
                      maxLength: 80,
                      onChanged: (_) => _titleEditedByUser = true,
                      decoration: const InputDecoration(
                        labelText: 'Goal name',
                        counterText: '',
                      ),
                      validator: (v) => (v ?? '').trim().isEmpty
                          ? 'Give the goal a name'
                          : null,
                    ),

                    const SizedBox(height: Gap.xl),
                    const SectionHeader(title: 'Deadline'),
                    AppCard(
                      onTap: () async {
                        final now = DateTime.now();
                        final picked = await showDatePicker(
                          context: context,
                          initialDate:
                              _deadline?.startOfDay ??
                              now.add(const Duration(days: 30)),
                          firstDate: now,
                          lastDate: now.add(const Duration(days: 365 * 3)),
                        );
                        if (picked != null) {
                          setState(() => _deadline = Day.fromDateTime(picked));
                        }
                      },
                      child: Row(
                        children: [
                          Icon(
                            Icons.event_outlined,
                            size: 20,
                            color: _deadline == null
                                ? c.textTertiary
                                : c.accent,
                          ),
                          const SizedBox(width: Gap.md),
                          Expanded(
                            child: Text(
                              _deadline == null
                                  ? 'No deadline — open-ended'
                                  : Fmt.dayLong(_deadline!),
                              style: AppTypography.body.copyWith(
                                color: _deadline == null
                                    ? c.textSecondary
                                    : c.textPrimary,
                              ),
                            ),
                          ),
                          if (_deadline != null)
                            IconButton(
                              tooltip: 'Clear deadline',
                              icon: const Icon(Icons.close_rounded, size: 18),
                              onPressed: () => setState(() => _deadline = null),
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.fromLTRB(
                  Gap.screenH,
                  Gap.lg,
                  Gap.screenH,
                  Gap.xl,
                ),
                decoration: BoxDecoration(
                  color: c.surface,
                  border: Border(top: BorderSide(color: c.border)),
                ),
                child: PrimaryButton(
                  label: _isEditing ? 'Save changes' : 'Create goal',
                  gradient: true,
                  loading: _saving,
                  onPressed: _save,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _unitFor(GoalType type, List<ExerciseRow> exercises) {
    switch (type) {
      case GoalType.streakDays:
        return 'days';
      case GoalType.workoutCount:
        return 'workouts';
      case GoalType.weeklyFrequency:
        return 'per week';
      case GoalType.singleSetRecord:
      case GoalType.totalVolume:
        for (final e in exercises) {
          if (e.id == _exerciseId) {
            return e.trackingType.tracksDuration ? 'seconds' : 'reps';
          }
        }
        return 'reps';
    }
  }
}
