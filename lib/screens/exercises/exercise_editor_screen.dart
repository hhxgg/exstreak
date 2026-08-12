import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../data/database.dart';
import '../../domain/enums.dart';
import '../../domain/exercise_icons.dart';
import '../../state/providers.dart';
import '../../theme/app_dimens.dart';
import '../../theme/app_theme.dart';
import '../../theme/app_typography.dart';
import '../../widgets/buttons.dart';
import '../../widgets/surfaces.dart';

/// Create or edit an exercise.
///
/// Adding an exercise is intentionally just this form — everything downstream
/// (workouts, stats, records, goals) branches on [TrackingType], so no other
/// code needs to know the new exercise exists.
class ExerciseEditorScreen extends ConsumerStatefulWidget {
  const ExerciseEditorScreen({super.key, this.exerciseId});

  final int? exerciseId;

  @override
  ConsumerState<ExerciseEditorScreen> createState() =>
      _ExerciseEditorScreenState();
}

class _ExerciseEditorScreenState extends ConsumerState<ExerciseEditorScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _instructionsController = TextEditingController();

  MuscleGroup _muscleGroup = MuscleGroup.chest;
  Equipment _equipment = Equipment.none;
  Difficulty _difficulty = Difficulty.beginner;
  TrackingType _trackingType = TrackingType.reps;
  String _iconName = 'dumbbell';
  int _restSeconds = 90;

  ExerciseRow? _existing;
  bool _loading = true;
  bool _saving = false;

  bool get _isEditing => widget.exerciseId != null;

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _instructionsController.dispose();
    super.dispose();
  }

  Future<void> _load() async {
    final id = widget.exerciseId;
    if (id == null) {
      setState(() => _loading = false);
      return;
    }

    final row = await ref.read(exerciseRepositoryProvider).byId(id);
    if (!mounted) return;

    if (row != null) {
      _nameController.text = row.name;
      _descriptionController.text = row.description;
      _instructionsController.text = row.instructions;
      _muscleGroup = row.muscleGroup;
      _equipment = row.equipment;
      _difficulty = row.difficulty;
      _trackingType = row.trackingType;
      _iconName = row.iconName;
      _restSeconds = row.defaultRestSeconds;
    }
    setState(() {
      _existing = row;
      _loading = false;
    });
  }

  Future<void> _save() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    setState(() => _saving = true);

    final repo = ref.read(exerciseRepositoryProvider);
    final instructions = _instructionsController.text
        .split('\n')
        .map((s) => s.trim())
        .where((s) => s.isNotEmpty)
        .toList();

    try {
      final existing = _existing;
      if (existing != null) {
        await repo.updateExercise(
          existing,
          name: _nameController.text,
          muscleGroup: _muscleGroup,
          equipment: _equipment,
          difficulty: _difficulty,
          trackingType: _trackingType,
          description: _descriptionController.text,
          instructions: instructions,
          iconName: _iconName,
          defaultRestSeconds: _restSeconds,
        );
        ref.invalidate(exerciseByIdProvider(existing.id));
      } else {
        await repo.createCustom(
          name: _nameController.text,
          muscleGroup: _muscleGroup,
          equipment: _equipment,
          difficulty: _difficulty,
          trackingType: _trackingType,
          description: _descriptionController.text,
          instructions: instructions,
          iconName: _iconName,
          defaultRestSeconds: _restSeconds,
        );
      }

      if (!mounted) return;
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          SnackBar(
            content: Text(
              _isEditing
                  ? 'Exercise updated'
                  : 'Exercise added to your library',
            ),
          ),
        );
      context.pop();
    } on Object catch (e) {
      if (!mounted) return;
      setState(() => _saving = false);
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(SnackBar(content: Text('Could not save: $e')));
    }
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

    final lockTracking = _existing != null && !_existing!.isCustom;

    return AppScreen(
      title: _isEditing ? 'Edit exercise' : 'New exercise',
      padded: false,
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
                  TextFormField(
                    controller: _nameController,
                    textCapitalization: TextCapitalization.sentences,
                    maxLength: 60,
                    decoration: const InputDecoration(
                      labelText: 'Name',
                      hintText: 'e.g. Archer push-ups',
                      counterText: '',
                    ),
                    validator: (v) {
                      final text = v?.trim() ?? '';
                      if (text.isEmpty) return 'Give the exercise a name';
                      if (text.length < 2) return 'That name is too short';
                      return null;
                    },
                  ),
                  const SizedBox(height: Gap.xl),

                  const SectionHeader(title: 'Icon'),
                  SizedBox(
                    height: 52,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: ExerciseIcons.pickerOptions.length,
                      separatorBuilder: (_, _) => const SizedBox(width: Gap.sm),
                      itemBuilder: (context, i) {
                        final entry = ExerciseIcons.pickerOptions[i];
                        final isSelected = entry.key == _iconName;
                        return GestureDetector(
                          onTap: () => setState(() => _iconName = entry.key),
                          child: Container(
                            width: 52,
                            decoration: BoxDecoration(
                              color: isSelected ? c.accent : c.surface,
                              borderRadius: BorderRadius.circular(Radii.sm),
                              border: Border.all(
                                color: isSelected ? c.accent : c.border,
                              ),
                            ),
                            child: Icon(
                              entry.value,
                              size: 22,
                              color: isSelected
                                  ? c.accentContrast
                                  : c.textSecondary,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: Gap.xl),

                  _DropdownField<TrackingType>(
                    label: 'What does it track?',
                    value: _trackingType,
                    items: TrackingType.values,
                    labelOf: (v) => v.label,
                    enabled: !lockTracking,
                    helper: lockTracking
                        ? 'Built-in exercises keep their tracking type so '
                              'existing history stays readable.'
                        : null,
                    onChanged: (v) => setState(() => _trackingType = v),
                  ),
                  const SizedBox(height: Gap.lg),

                  _DropdownField<MuscleGroup>(
                    label: 'Muscle group',
                    value: _muscleGroup,
                    items: MuscleGroup.values,
                    labelOf: (v) => v.label,
                    onChanged: (v) => setState(() => _muscleGroup = v),
                  ),
                  const SizedBox(height: Gap.lg),

                  _DropdownField<Equipment>(
                    label: 'Equipment',
                    value: _equipment,
                    items: Equipment.values,
                    labelOf: (v) => v.label,
                    onChanged: (v) => setState(() => _equipment = v),
                  ),
                  const SizedBox(height: Gap.lg),

                  _DropdownField<Difficulty>(
                    label: 'Difficulty',
                    value: _difficulty,
                    items: Difficulty.values,
                    labelOf: (v) => v.label,
                    onChanged: (v) => setState(() => _difficulty = v),
                  ),
                  const SizedBox(height: Gap.xl),

                  const SectionHeader(title: 'Rest between sets'),
                  AppCard(
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                '$_restSeconds seconds',
                                style: AppTypography.titleS.copyWith(
                                  color: c.textPrimary,
                                ),
                              ),
                            ),
                            Text(
                              _restSeconds == 0 ? 'No rest timer' : '',
                              style: AppTypography.caption.copyWith(
                                color: c.textTertiary,
                              ),
                            ),
                          ],
                        ),
                        Slider(
                          value: _restSeconds.toDouble(),
                          min: 0,
                          max: 300,
                          divisions: 20,
                          label: '$_restSeconds s',
                          onChanged: (v) =>
                              setState(() => _restSeconds = v.round()),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: Gap.xl),

                  TextFormField(
                    controller: _descriptionController,
                    textCapitalization: TextCapitalization.sentences,
                    maxLines: 3,
                    maxLength: 300,
                    decoration: const InputDecoration(
                      labelText: 'Description (optional)',
                      alignLabelWithHint: true,
                    ),
                  ),
                  const SizedBox(height: Gap.lg),

                  TextFormField(
                    controller: _instructionsController,
                    textCapitalization: TextCapitalization.sentences,
                    maxLines: 6,
                    decoration: const InputDecoration(
                      labelText: 'Instructions (optional)',
                      hintText: 'One coaching cue per line',
                      alignLabelWithHint: true,
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
              child: SafeArea(
                top: false,
                child: PrimaryButton(
                  label: _isEditing ? 'Save changes' : 'Add to library',
                  gradient: true,
                  loading: _saving,
                  onPressed: _save,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DropdownField<T> extends StatelessWidget {
  const _DropdownField({
    required this.label,
    required this.value,
    required this.items,
    required this.labelOf,
    required this.onChanged,
    this.enabled = true,
    this.helper,
  });

  final String label;
  final T value;
  final List<T> items;
  final String Function(T) labelOf;
  final ValueChanged<T> onChanged;
  final bool enabled;
  final String? helper;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        DropdownButtonFormField<T>(
          initialValue: value,
          isExpanded: true,
          decoration: InputDecoration(labelText: label),
          dropdownColor: c.surfaceElevated,
          borderRadius: BorderRadius.circular(Radii.sm),
          items: [
            for (final item in items)
              DropdownMenuItem(
                value: item,
                child: Text(
                  labelOf(item),
                  style: AppTypography.body.copyWith(color: c.textPrimary),
                ),
              ),
          ],
          onChanged: enabled
              ? (v) {
                  if (v != null) onChanged(v);
                }
              : null,
        ),
        if (helper != null) ...[
          const SizedBox(height: Gap.sm),
          Text(
            helper!,
            style: AppTypography.caption.copyWith(color: c.textTertiary),
          ),
        ],
      ],
    );
  }
}
