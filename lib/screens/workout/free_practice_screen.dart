import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/database.dart';
import '../../domain/exercise_icons.dart';
import '../../state/providers.dart';
import '../../theme/app_dimens.dart';
import '../../theme/app_theme.dart';
import '../../theme/app_typography.dart';
import '../../widgets/surfaces.dart';
import 'workout_launcher.dart';

/// Pick one exercise and go until you cannot. No targets, no sets to fill.
class FreePracticeScreen extends ConsumerStatefulWidget {
  const FreePracticeScreen({super.key});

  @override
  ConsumerState<FreePracticeScreen> createState() => _FreePracticeScreenState();
}

class _FreePracticeScreenState extends ConsumerState<FreePracticeScreen> {
  final _searchController = TextEditingController();
  String _query = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final exercisesAsync = ref.watch(exercisesProvider);

    return AppScreen(
      title: 'Free practice',
      padded: false,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(
              Gap.screenH,
              Gap.md,
              Gap.screenH,
              Gap.lg,
            ),
            child: Column(
              children: [
                InfoBanner(
                  message:
                      'One exercise, no target. Perfect for testing a max or '
                      'squeezing in a quick set.',
                  icon: Icons.bolt_rounded,
                  tone: BannerTone.warning,
                ),
                const SizedBox(height: Gap.lg),
                TextField(
                  controller: _searchController,
                  onChanged: (v) => setState(() => _query = v),
                  textInputAction: TextInputAction.search,
                  decoration: InputDecoration(
                    hintText: 'Search exercises',
                    prefixIcon: const Icon(Icons.search_rounded),
                    suffixIcon: _query.isEmpty
                        ? null
                        : IconButton(
                            icon: const Icon(Icons.close_rounded, size: 18),
                            onPressed: () {
                              _searchController.clear();
                              setState(() => _query = '');
                            },
                          ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: exercisesAsync.when(
              loading: () =>
                  Center(child: CircularProgressIndicator(color: c.accent)),
              error: (e, _) => EmptyState(
                icon: Icons.error_outline_rounded,
                title: 'Could not load exercises',
                message: '$e',
              ),
              data: (all) {
                final q = _query.trim().toLowerCase();
                final list = q.isEmpty
                    ? all
                    : all
                          .where(
                            (e) =>
                                e.name.toLowerCase().contains(q) ||
                                e.muscleGroup.label.toLowerCase().contains(q),
                          )
                          .toList();

                if (list.isEmpty) {
                  return EmptyState(
                    icon: Icons.search_off_rounded,
                    title: 'Nothing matched',
                    message: 'Try a different search term.',
                  );
                }

                return ListView.separated(
                  padding: const EdgeInsets.fromLTRB(
                    Gap.screenH,
                    0,
                    Gap.screenH,
                    Gap.giant,
                  ),
                  itemCount: list.length,
                  separatorBuilder: (_, _) => const SizedBox(height: Gap.sm),
                  itemBuilder: (context, i) => _ExerciseRow(exercise: list[i]),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _ExerciseRow extends ConsumerWidget {
  const _ExerciseRow({required this.exercise});

  final ExerciseRow exercise;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final c = context.colors;
    return AppCard(
      padding: const EdgeInsets.symmetric(horizontal: Gap.lg, vertical: Gap.md),
      onTap: () => startFreePractice(context, ref, exercise: exercise),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: c.accentSoft,
              borderRadius: BorderRadius.circular(Radii.xs),
            ),
            child: Icon(
              ExerciseIcons.resolve(exercise.iconName),
              size: 20,
              color: c.accent,
            ),
          ),
          const SizedBox(width: Gap.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  exercise.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTypography.titleS.copyWith(color: c.textPrimary),
                ),
                Text(
                  '${exercise.muscleGroup.label} · '
                  '${exercise.trackingType.label}',
                  style: AppTypography.caption.copyWith(color: c.textSecondary),
                ),
              ],
            ),
          ),
          Icon(Icons.play_circle_outline_rounded, color: c.accent, size: 24),
        ],
      ),
    );
  }
}
