import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/exercise_icons.dart';
import '../../state/providers.dart';
import '../../theme/app_dimens.dart';
import '../../theme/app_theme.dart';
import '../../theme/app_typography.dart';
import '../../widgets/surfaces.dart';

/// Exercises the user hid from the library, and a way to bring them back.
///
/// Built-in exercises — and any exercise referenced by a logged workout — are
/// archived rather than deleted so history stays intact. Without this screen
/// there would be no way to undo that.
class HiddenExercisesScreen extends ConsumerWidget {
  const HiddenExercisesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final c = context.colors;
    final hiddenAsync = ref.watch(archivedExercisesProvider);

    return AppScreen(
      title: 'Hidden exercises',
      padded: false,
      child: hiddenAsync.when(
        loading: () =>
            Center(child: CircularProgressIndicator(color: c.accent)),
        error: (e, _) => EmptyState(
          icon: Icons.error_outline_rounded,
          title: 'Could not load',
          message: '$e',
        ),
        data: (hidden) {
          if (hidden.isEmpty) {
            return EmptyState(
              icon: Icons.visibility_outlined,
              title: 'Nothing is hidden',
              message:
                  'Exercises you hide from the library show up here so you can '
                  'bring them back.',
            );
          }

          return ListView.separated(
            padding: const EdgeInsets.fromLTRB(
              Gap.screenH,
              Gap.lg,
              Gap.screenH,
              Gap.giant,
            ),
            itemCount: hidden.length + 1,
            separatorBuilder: (_, _) => const SizedBox(height: Gap.sm),
            itemBuilder: (context, i) {
              if (i == 0) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: Gap.md),
                  child: InfoBanner(
                    message:
                        'Hidden exercises keep all of their history. Restoring '
                        'one puts it back in the library exactly as it was.',
                    icon: Icons.history_rounded,
                  ),
                );
              }

              final exercise = hidden[i - 1];
              return AppCard(
                padding: const EdgeInsets.symmetric(
                  horizontal: Gap.lg,
                  vertical: Gap.md,
                ),
                child: Row(
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: c.surfaceSunken,
                        borderRadius: BorderRadius.circular(Radii.xs),
                      ),
                      child: Icon(
                        ExerciseIcons.resolve(exercise.iconName),
                        size: 20,
                        color: c.textTertiary,
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
                            style: AppTypography.titleS.copyWith(
                              color: c.textSecondary,
                            ),
                          ),
                          Text(
                            exercise.muscleGroup.label,
                            style: AppTypography.caption.copyWith(
                              color: c.textTertiary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    TextButton.icon(
                      onPressed: () async {
                        await ref
                            .read(exerciseRepositoryProvider)
                            .restore(exercise.id);
                        ref.invalidate(archivedExercisesProvider);
                        if (!context.mounted) return;
                        ScaffoldMessenger.of(context)
                          ..hideCurrentSnackBar()
                          ..showSnackBar(
                            SnackBar(
                              content: Text('${exercise.name} restored'),
                            ),
                          );
                      },
                      icon: const Icon(Icons.undo_rounded, size: 18),
                      label: const Text('Restore'),
                      style: TextButton.styleFrom(foregroundColor: c.accent),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
