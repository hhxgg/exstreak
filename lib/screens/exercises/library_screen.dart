import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../data/database.dart';
import '../../data/repositories/exercise_repository.dart';
import '../../domain/enums.dart';
import '../../domain/exercise_icons.dart';
import '../../router.dart';
import '../../state/providers.dart';
import '../../theme/app_dimens.dart';
import '../../theme/app_theme.dart';
import '../../theme/app_typography.dart';
import '../../widgets/buttons.dart';
import '../../widgets/surfaces.dart';

/// Browse, search and filter the exercise catalogue.
class LibraryScreen extends ConsumerStatefulWidget {
  const LibraryScreen({super.key});

  @override
  ConsumerState<LibraryScreen> createState() => _LibraryScreenState();
}

class _LibraryScreenState extends ConsumerState<LibraryScreen> {
  final _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final filter = ref.watch(exerciseFilterProvider);
    final listAsync = ref.watch(filteredExercisesProvider);

    return Scaffold(
      backgroundColor: c.background,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push(Routes.newExercise),
        backgroundColor: c.accent,
        foregroundColor: c.accentContrast,
        icon: const Icon(Icons.add_rounded),
        label: Text('New exercise', style: AppTypography.button),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(
                Gap.screenH,
                Gap.md,
                Gap.screenH,
                Gap.md,
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      'Exercise library',
                      style: AppTypography.displayS.copyWith(
                        fontSize: 28,
                        color: c.textPrimary,
                      ),
                    ),
                  ),
                  IconPill(
                    icon: filter.favouritesOnly
                        ? Icons.star_rounded
                        : Icons.star_outline_rounded,
                    tooltip: 'Favourites only',
                    foreground: filter.favouritesOnly ? c.warning : null,
                    onPressed: () => ref
                        .read(exerciseFilterProvider.notifier)
                        .update(
                          (f) => f.copyWith(favouritesOnly: !f.favouritesOnly),
                        ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: Gap.screenH),
              child: TextField(
                controller: _searchController,
                textInputAction: TextInputAction.search,
                onChanged: (v) => ref
                    .read(exerciseFilterProvider.notifier)
                    .update((f) => f.copyWith(query: v)),
                decoration: InputDecoration(
                  hintText: 'Search by name, muscle or equipment',
                  prefixIcon: const Icon(Icons.search_rounded),
                  suffixIcon: filter.query.isEmpty
                      ? null
                      : IconButton(
                          icon: const Icon(Icons.close_rounded, size: 18),
                          tooltip: 'Clear search',
                          onPressed: () {
                            _searchController.clear();
                            ref
                                .read(exerciseFilterProvider.notifier)
                                .update((f) => f.copyWith(query: ''));
                          },
                        ),
                ),
              ),
            ),
            const SizedBox(height: Gap.md),
            SizedBox(
              height: 36,
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: Gap.screenH),
                children: [
                  _FilterChip(
                    label: 'All',
                    isSelected: !filter.isActive,
                    onTap: () =>
                        ref.read(exerciseFilterProvider.notifier).state =
                            const ExerciseFilter(),
                  ),
                  const SizedBox(width: Gap.sm),
                  _FilterChip(
                    label: 'My exercises',
                    isSelected: filter.customOnly,
                    onTap: () => ref
                        .read(exerciseFilterProvider.notifier)
                        .update((f) => f.copyWith(customOnly: !f.customOnly)),
                  ),
                  for (final group in MuscleGroup.values) ...[
                    const SizedBox(width: Gap.sm),
                    _FilterChip(
                      label: group.label,
                      icon: group.icon,
                      isSelected: filter.muscleGroup == group,
                      onTap: () => ref
                          .read(exerciseFilterProvider.notifier)
                          .update(
                            (f) => f.muscleGroup == group
                                ? f.copyWith(clearMuscleGroup: true)
                                : f.copyWith(muscleGroup: group),
                          ),
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(height: Gap.md),
            Expanded(
              child: listAsync.when(
                loading: () =>
                    Center(child: CircularProgressIndicator(color: c.accent)),
                error: (e, _) => EmptyState(
                  icon: Icons.error_outline_rounded,
                  title: 'Could not load the library',
                  message: '$e',
                ),
                data: (list) {
                  if (list.isEmpty) {
                    return EmptyState(
                      icon: Icons.search_off_rounded,
                      title: 'No exercises match',
                      message: filter.isActive
                          ? 'Try clearing a filter or searching for something '
                                'else.'
                          : 'Add your first custom exercise to get started.',
                      actionLabel: filter.isActive ? 'Clear filters' : null,
                      onAction: filter.isActive
                          ? () =>
                                ref
                                        .read(exerciseFilterProvider.notifier)
                                        .state =
                                    const ExerciseFilter()
                          : null,
                    );
                  }

                  return ListView.separated(
                    padding: const EdgeInsets.fromLTRB(
                      Gap.screenH,
                      0,
                      Gap.screenH,
                      Sizes.scrollBottomInset,
                    ),
                    itemCount: list.length,
                    separatorBuilder: (_, _) => const SizedBox(height: Gap.sm),
                    itemBuilder: (context, i) =>
                        _ExerciseTile(exercise: list[i]),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  const _FilterChip({
    required this.label,
    required this.isSelected,
    required this.onTap,
    this.icon,
  });

  final String label;
  final bool isSelected;
  final VoidCallback onTap;
  final IconData? icon;

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
            padding: const EdgeInsets.symmetric(horizontal: Gap.lg),
            decoration: BoxDecoration(
              borderRadius: Radii.pillRadius,
              border: Border.all(color: isSelected ? c.accent : c.border),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (icon != null) ...[
                  Icon(
                    icon,
                    size: 14,
                    color: isSelected ? c.accentContrast : c.textTertiary,
                  ),
                  const SizedBox(width: Gap.xs),
                ],
                Text(
                  label,
                  style: AppTypography.caption.copyWith(
                    color: isSelected ? c.accentContrast : c.textSecondary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ExerciseTile extends ConsumerWidget {
  const _ExerciseTile({required this.exercise});

  final ExerciseRow exercise;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final c = context.colors;
    return AppCard(
      padding: const EdgeInsets.symmetric(horizontal: Gap.lg, vertical: Gap.md),
      onTap: () => context.push(Routes.exercise(exercise.id)),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: c.accentSoft,
              borderRadius: BorderRadius.circular(Radii.xs),
            ),
            child: Icon(
              ExerciseIcons.resolve(exercise.iconName),
              size: 21,
              color: c.accent,
            ),
          ),
          const SizedBox(width: Gap.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Flexible(
                      child: Text(
                        exercise.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppTypography.titleS.copyWith(
                          color: c.textPrimary,
                        ),
                      ),
                    ),
                    if (exercise.isCustom) ...[
                      const SizedBox(width: Gap.sm),
                      TagChip(label: 'Custom', color: c.info, dense: true),
                    ],
                  ],
                ),
                const SizedBox(height: 4),
                Wrap(
                  spacing: Gap.xs,
                  runSpacing: Gap.xs,
                  children: [
                    TagChip(
                      label: exercise.muscleGroup.label,
                      icon: exercise.muscleGroup.icon,
                      dense: true,
                    ),
                    TagChip(
                      label: exercise.trackingType.label,
                      icon: exercise.trackingType.icon,
                      dense: true,
                    ),
                    if (exercise.equipment != Equipment.none)
                      TagChip(label: exercise.equipment.label, dense: true),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: Gap.sm),
          IconButton(
            tooltip: exercise.isFavourite
                ? 'Remove from favourites'
                : 'Add to favourites',
            icon: Icon(
              exercise.isFavourite
                  ? Icons.star_rounded
                  : Icons.star_outline_rounded,
              size: 20,
              color: exercise.isFavourite ? c.warning : c.textTertiary,
            ),
            onPressed: () =>
                ref.read(exerciseRepositoryProvider).toggleFavourite(exercise),
          ),
        ],
      ),
    );
  }
}
