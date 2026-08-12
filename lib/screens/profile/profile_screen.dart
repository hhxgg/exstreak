import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:share_plus/share_plus.dart';

import '../../core/branding.dart';
import '../../core/formatters.dart';
import '../../domain/app_settings.dart';
import '../../domain/badges/badge_catalog.dart';
import '../../router.dart';
import '../../state/providers.dart';
import '../../theme/app_dimens.dart';
import '../../theme/app_theme.dart';
import '../../theme/app_typography.dart';
import '../../widgets/buttons.dart';
import '../../widgets/surfaces.dart';

/// Identity, motto and the full badge case.
class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final c = context.colors;
    final settings = ref.watch(settingsProvider);
    final earned = ref.watch(earnedBadgesProvider).valueOrNull ?? const {};
    final streak = ref.watch(streakProvider).valueOrNull;
    final totals = ref.watch(lifetimeTotalsProvider).valueOrNull;

    return Scaffold(
      backgroundColor: c.background,
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(
            Gap.screenH,
            Gap.md,
            Gap.screenH,
            Sizes.scrollBottomInset,
          ),
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    'Profile',
                    style: AppTypography.displayS.copyWith(
                      fontSize: 28,
                      color: c.textPrimary,
                    ),
                  ),
                ),
                IconPill(
                  icon: Icons.share_outlined,
                  tooltip: 'Share your progress',
                  onPressed: () => _share(context, ref),
                ),
                const SizedBox(width: Gap.sm),
                IconPill(
                  icon: Icons.settings_outlined,
                  tooltip: 'Settings',
                  onPressed: () => context.push(Routes.settings),
                ),
              ],
            ),
            const SizedBox(height: Gap.xl),

            AppCard(
              padding: const EdgeInsets.symmetric(
                horizontal: Gap.xl,
                vertical: Gap.xxl,
              ),
              child: Column(
                children: [
                  GestureDetector(
                    onTap: () => _pickAvatar(context, ref, settings),
                    child: Container(
                      width: 96,
                      height: 96,
                      decoration: BoxDecoration(
                        gradient: c.brandGradient,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: c.accent.withValues(alpha: 0.35),
                            blurRadius: 28,
                            spreadRadius: -6,
                          ),
                        ],
                      ),
                      child: Center(
                        child: Text(
                          Avatars.emoji(settings.avatarId),
                          style: const TextStyle(fontSize: 46),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: Gap.lg),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Flexible(
                        child: Text(
                          settings.displayName.trim().isEmpty
                              ? 'Add your name'
                              : settings.displayName,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppTypography.titleL.copyWith(
                            color: settings.displayName.trim().isEmpty
                                ? c.textTertiary
                                : c.textPrimary,
                          ),
                        ),
                      ),
                      const SizedBox(width: Gap.sm),
                      IconPill(
                        icon: Icons.edit_outlined,
                        size: 28,
                        tooltip: 'Edit name',
                        onPressed: () => _editName(context, ref, settings),
                      ),
                    ],
                  ),
                  if (settings.memberSince != null) ...[
                    const SizedBox(height: Gap.xs),
                    Text(
                      'Member since '
                      '${DateFormat.yMMMM().format(settings.memberSince!)}',
                      style: AppTypography.bodySmall.copyWith(
                        color: c.textSecondary,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(height: Gap.md),

            AppCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          'MY MOTTO',
                          style: AppTypography.overline.copyWith(
                            color: c.accent,
                          ),
                        ),
                      ),
                      TextButton.icon(
                        onPressed: () => _editMotto(context, ref, settings),
                        icon: const Icon(Icons.edit_outlined, size: 15),
                        label: const Text('Edit'),
                        style: TextButton.styleFrom(
                          minimumSize: const Size(0, 32),
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: Gap.sm),
                  Text(
                    settings.motto.trim().isEmpty
                        ? 'Add your personal motto.'
                        : '"${settings.motto}"',
                    style: AppTypography.titleM.copyWith(
                      color: settings.motto.trim().isEmpty
                          ? c.textTertiary
                          : c.textPrimary,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: Gap.md),

            Row(
              children: [
                Expanded(
                  child: _MiniStat(
                    value: '${streak?.current ?? 0}',
                    label: 'Streak',
                    icon: Icons.local_fire_department_rounded,
                    color: c.streakFlame,
                  ),
                ),
                const SizedBox(width: Gap.md),
                Expanded(
                  child: _MiniStat(
                    value: Fmt.compact(totals?.totalReps ?? 0),
                    label: 'Total reps',
                    icon: Icons.repeat_rounded,
                    color: c.accent,
                  ),
                ),
                const SizedBox(width: Gap.md),
                Expanded(
                  child: _MiniStat(
                    value: '${earned.length}',
                    label: 'Badges',
                    icon: Icons.workspace_premium_rounded,
                    color: c.warning,
                  ),
                ),
              ],
            ),
            const SizedBox(height: Gap.xxl),

            Text(
              'My badges',
              style: AppTypography.titleL.copyWith(color: c.textPrimary),
            ),
            const SizedBox(height: Gap.lg),

            for (final category in BadgeCategory.values) ...[
              _BadgeGroup(category: category, earned: earned),
              const SizedBox(height: Gap.md),
            ],
          ],
        ),
      ),
    );
  }

  Future<void> _share(BuildContext context, WidgetRef ref) async {
    final streak = ref.read(streakProvider).valueOrNull;
    final totals = ref.read(lifetimeTotalsProvider).valueOrNull;
    final name = ref.read(settingsProvider).greetingName;

    final text = [
      '$name on ${Branding.appName}',
      'Current streak: ${streak?.current ?? 0} days',
      'Longest streak: ${streak?.longest ?? 0} days',
      'Total reps: ${Fmt.count(totals?.totalReps ?? 0)}',
      '',
      Branding.tagline,
    ].join('\n');

    try {
      await SharePlus.instance.share(
        ShareParams(text: text, subject: '${Branding.appName} progress'),
      );
    } on Object catch (e) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(SnackBar(content: Text('Could not share: $e')));
    }
  }

  Future<void> _editName(
    BuildContext context,
    WidgetRef ref,
    AppSettings settings,
  ) async {
    final result = await _promptText(
      context,
      title: 'Your name',
      initial: settings.displayName,
      hint: 'Name or nickname',
      maxLength: 24,
    );
    if (result == null) return;
    await ref
        .read(settingsProvider.notifier)
        .update((s) => s.copyWith(displayName: result));
  }

  Future<void> _editMotto(
    BuildContext context,
    WidgetRef ref,
    AppSettings settings,
  ) async {
    final result = await _promptText(
      context,
      title: 'Your motto',
      initial: settings.motto,
      hint: 'What keeps you going?',
      maxLength: 90,
    );
    if (result == null) return;
    await ref
        .read(settingsProvider.notifier)
        .update((s) => s.copyWith(motto: result));
  }

  Future<String?> _promptText(
    BuildContext context, {
    required String title,
    required String initial,
    required String hint,
    required int maxLength,
  }) {
    final controller = TextEditingController(text: initial);
    return showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: TextField(
          controller: controller,
          autofocus: true,
          maxLength: maxLength,
          textCapitalization: TextCapitalization.sentences,
          decoration: InputDecoration(hintText: hint, counterText: ''),
        ),
        actions: [
          TextButton(
            onPressed: () => context.pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => context.pop(controller.text.trim()),
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  Future<void> _pickAvatar(
    BuildContext context,
    WidgetRef ref,
    AppSettings settings,
  ) async {
    final c = context.colors;
    final picked = await showModalBottomSheet<String>(
      context: context,
      builder: (context) => Padding(
        padding: const EdgeInsets.fromLTRB(
          Gap.screenH,
          Gap.sm,
          Gap.screenH,
          Gap.xxxl,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Choose your avatar',
              style: AppTypography.titleM.copyWith(color: c.textPrimary),
            ),
            const SizedBox(height: Gap.lg),
            Wrap(
              spacing: Gap.md,
              runSpacing: Gap.md,
              children: [
                for (final id in Avatars.ids)
                  GestureDetector(
                    onTap: () => context.pop(id),
                    child: Container(
                      width: 58,
                      height: 58,
                      decoration: BoxDecoration(
                        color: id == settings.avatarId
                            ? c.accentSoft
                            : c.surfaceSunken,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: id == settings.avatarId ? c.accent : c.border,
                          width: id == settings.avatarId ? 2 : 1,
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
              ],
            ),
          ],
        ),
      ),
    );

    if (picked == null) return;
    await ref
        .read(settingsProvider.notifier)
        .update((s) => s.copyWith(avatarId: picked));
  }
}

class _MiniStat extends StatelessWidget {
  const _MiniStat({
    required this.value,
    required this.label,
    required this.icon,
    required this.color,
  });

  final String value;
  final String label;
  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return AppCard(
      padding: const EdgeInsets.symmetric(horizontal: Gap.md, vertical: Gap.lg),
      child: Column(
        children: [
          Icon(icon, size: 20, color: color),
          const SizedBox(height: Gap.sm),
          Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTypography.titleM.copyWith(
              color: c.textPrimary,
              fontFeatures: AppTypography.tabular,
            ),
          ),
          Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTypography.caption.copyWith(color: c.textSecondary),
          ),
        ],
      ),
    );
  }
}

class _BadgeGroup extends StatelessWidget {
  const _BadgeGroup({required this.category, required this.earned});

  final BadgeCategory category;
  final Set<String> earned;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final defs = BadgeCatalog.byCategory(category);
    final earnedCount = defs.where((d) => earned.contains(d.code)).length;

    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 30,
                height: 30,
                decoration: BoxDecoration(
                  color: c.accentSoft,
                  borderRadius: BorderRadius.circular(Radii.xs),
                ),
                child: Icon(category.icon, size: 16, color: c.accent),
              ),
              const SizedBox(width: Gap.md),
              Text(
                category.label,
                style: AppTypography.titleS.copyWith(color: c.textPrimary),
              ),
              const SizedBox(width: Gap.sm),
              Text(
                '$earnedCount / ${defs.length}',
                style: AppTypography.bodySmall.copyWith(color: c.textTertiary),
              ),
            ],
          ),
          const SizedBox(height: Gap.lg),
          Wrap(
            spacing: Gap.lg,
            runSpacing: Gap.lg,
            children: [
              for (final def in defs)
                _BadgeTile(def: def, isEarned: earned.contains(def.code)),
            ],
          ),
        ],
      ),
    );
  }
}

class _BadgeTile extends StatelessWidget {
  const _BadgeTile({required this.def, required this.isEarned});

  final BadgeDef def;
  final bool isEarned;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Tooltip(
      message: def.description,
      child: SizedBox(
        width: 84,
        child: Column(
          children: [
            Stack(
              alignment: Alignment.bottomRight,
              children: [
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    gradient: isEarned ? c.brandGradient : null,
                    color: isEarned ? null : c.surfaceSunken,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: isEarned ? Colors.transparent : c.border,
                    ),
                    boxShadow: isEarned
                        ? [
                            BoxShadow(
                              color: c.accent.withValues(alpha: 0.3),
                              blurRadius: 16,
                              spreadRadius: -4,
                            ),
                          ]
                        : null,
                  ),
                  child: Icon(
                    def.icon,
                    size: 27,
                    color: isEarned ? c.accentContrast : c.textTertiary,
                  ),
                ),
                if (!isEarned)
                  Container(
                    width: 20,
                    height: 20,
                    decoration: BoxDecoration(
                      color: c.surfaceElevated,
                      shape: BoxShape.circle,
                      border: Border.all(color: c.border),
                    ),
                    child: Icon(
                      Icons.lock_rounded,
                      size: 11,
                      color: c.textTertiary,
                    ),
                  ),
              ],
            ),
            const SizedBox(height: Gap.sm),
            Text(
              def.title,
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: AppTypography.caption.copyWith(
                color: isEarned ? c.textPrimary : c.textTertiary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
