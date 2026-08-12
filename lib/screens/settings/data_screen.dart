import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

import '../../core/branding.dart';
import '../../core/day.dart';
import '../../router.dart';
import '../../state/providers.dart';
import '../../theme/app_dimens.dart';
import '../../theme/app_theme.dart';
import '../../widgets/buttons.dart';
import '../../widgets/surfaces.dart';

/// Export, reset and delete. Everything the user needs to stay in control of
/// their own data — which is all local to the device in the first place.
class DataScreen extends ConsumerStatefulWidget {
  const DataScreen({super.key});

  @override
  ConsumerState<DataScreen> createState() => _DataScreenState();
}

class _DataScreenState extends ConsumerState<DataScreen> {
  bool _busy = false;

  Future<void> _export({required bool asCsv}) async {
    if (_busy) return;
    setState(() => _busy = true);

    try {
      final db = ref.read(databaseProvider);
      final workouts = await db.completedWorkouts();
      final exercises = await db.getExercises(includeArchived: true);
      final byId = {for (final e in exercises) e.id: e};

      final stamp = DateTime.now().toIso8601String().split('T').first;
      final dir = await getTemporaryDirectory();
      final file = File(
        '${dir.path}/${Branding.exportPrefix}-export-$stamp'
        '.${asCsv ? 'csv' : 'json'}',
      );

      if (asCsv) {
        final buffer = StringBuffer()
          ..writeln(
            'date,workout_id,source,title,exercise,set_number,reps,'
            'weight_kg,duration_seconds,distance_meters,target',
          );
        for (final w in workouts) {
          final day = Day.fromEpochKey(w.dayKey);
          final pairs = await db.setsForWorkout(w.id);
          var index = 0;
          var lastExercise = -1;
          for (final (we, set) in pairs) {
            if (we.id != lastExercise) {
              index = 0;
              lastExercise = we.id;
            }
            index++;
            buffer.writeln(
              [
                day.toString(),
                w.id,
                w.source.name,
                _csv(w.title),
                _csv(we.exerciseName),
                index,
                set.reps,
                set.weightKg,
                set.durationSeconds,
                set.distanceMeters,
                set.targetValue ?? '',
              ].join(','),
            );
          }
        }
        await file.writeAsString(buffer.toString());
      } else {
        final activity = await db.allActivity();
        final goals = await db.getGoals(includeArchived: true);
        final records = await db.allRecords();
        final badges = await db.allBadges();

        final payload = {
          'app': Branding.appName,
          'schemaVersion': db.schemaVersion,
          'exportedAt': DateTime.now().toIso8601String(),
          'settings': ref.read(settingsProvider).toJson(),
          'workouts': [
            for (final w in workouts)
              {
                'id': w.id,
                'day': Day.fromEpochKey(w.dayKey).toString(),
                'startedAt': w.startedAt.toIso8601String(),
                'source': w.source.name,
                'title': w.title,
                'totalReps': w.totalReps,
                'totalDurationSeconds': w.totalDurationSeconds,
                'durationSeconds': w.durationSeconds,
                'feedback': w.feedback?.name,
                'exercises': [
                  for (final (we, set) in await db.setsForWorkout(w.id))
                    {
                      'exercise': we.exerciseName,
                      'trackingType': we.trackingType.name,
                      'reps': set.reps,
                      'weightKg': set.weightKg,
                      'durationSeconds': set.durationSeconds,
                      'distanceMeters': set.distanceMeters,
                      'target': set.targetValue,
                    },
                ],
              },
          ],
          'dailyActivity': [
            for (final a in activity)
              {
                'day': Day.fromEpochKey(a.dayKey).toString(),
                'workouts': a.workoutCount,
                'reps': a.totalReps,
                'durationSeconds': a.totalDurationSeconds,
                'isFreeze': a.isFreeze,
              },
          ],
          'personalRecords': [
            for (final r in records)
              {
                'exercise': byId[r.exerciseId]?.name ?? 'unknown',
                'metric': r.metric,
                'value': r.value,
                'day': Day.fromEpochKey(r.dayKey).toString(),
              },
          ],
          'goals': [
            for (final g in goals)
              {
                'title': g.title,
                'type': g.type.name,
                'target': g.targetValue,
                'achieved': g.achievedValue,
                'isCompleted': g.isCompleted,
              },
          ],
          'badges': [for (final b in badges) b.code],
          'customExercises': [
            for (final e in exercises)
              if (e.isCustom)
                {
                  'name': e.name,
                  'muscleGroup': e.muscleGroup.name,
                  'equipment': e.equipment.name,
                  'trackingType': e.trackingType.name,
                },
          ],
        };

        await file.writeAsString(
          const JsonEncoder.withIndent('  ').convert(payload),
        );
      }

      if (!mounted) return;
      await SharePlus.instance.share(
        ShareParams(
          files: [XFile(file.path)],
          subject: '${Branding.appName} data export',
        ),
      );
    } on Object catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(SnackBar(content: Text('Export failed: $e')));
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  static String _csv(String value) {
    if (!value.contains(',') && !value.contains('"')) return value;
    return '"${value.replaceAll('"', '""')}"';
  }

  Future<void> _deleteWorkoutData() async {
    final c = context.colors;
    final confirmed = await _confirm(
      title: 'Delete all training data?',
      body:
          'Every workout, streak, record, goal and badge will be permanently '
          'removed. Your profile and settings are kept. This cannot be undone.',
      action: 'Delete everything',
      tone: c.danger,
    );
    if (confirmed != true || !mounted) return;

    setState(() => _busy = true);
    try {
      await ref.read(databaseProvider).wipeUserData();
      await ref
          .read(settingsProvider.notifier)
          .update(
            (s) => s.copyWith(freezesAvailable: 0, freezeGrantedAtStreak: 0),
          );
      if (!mounted) return;
      refreshAll(ref);
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(const SnackBar(content: Text('Training data deleted')));
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _resetEverything() async {
    final c = context.colors;
    final confirmed = await _confirm(
      title: 'Reset the app?',
      body:
          'Deletes all training data and your profile, then returns you to the '
          'first-run setup. This cannot be undone.',
      action: 'Reset app',
      tone: c.danger,
    );
    if (confirmed != true || !mounted) return;

    setState(() => _busy = true);
    try {
      await ref.read(notificationServiceProvider).cancelAll();
      await ref.read(databaseProvider).wipeUserData();
      await ref.read(settingsProvider.notifier).reset();
      if (!mounted) return;
      refreshAll(ref);
      context.go(Routes.onboarding);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<bool?> _confirm({
    required String title,
    required String body,
    required String action,
    required Color tone,
  }) {
    return showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(body),
        actions: [
          TextButton(
            onPressed: () => context.pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => context.pop(true),
            child: Text(action, style: TextStyle(color: tone)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final c = context.colors;

    return AppScreen(
      title: 'Your data',
      padded: false,
      child: ListView(
        padding: const EdgeInsets.fromLTRB(
          Gap.screenH,
          Gap.lg,
          Gap.screenH,
          Gap.giant,
        ),
        children: [
          InfoBanner(
            message:
                'All of your training data lives on this device only. '
                '${Branding.appName} has no account and no server.',
            icon: Icons.lock_outline_rounded,
            tone: BannerTone.success,
          ),
          const SizedBox(height: Gap.xl),

          const SectionHeader(title: 'Export'),
          AppCard(
            padding: const EdgeInsets.symmetric(vertical: Gap.sm),
            child: Column(
              children: [
                AppListTile(
                  title: 'Export as CSV',
                  subtitle: 'One row per set — opens in any spreadsheet',
                  leadingIcon: Icons.table_chart_outlined,
                  leadingColor: c.success,
                  onTap: _busy ? null : () => _export(asCsv: true),
                ),
                AppListTile(
                  title: 'Export as JSON',
                  subtitle: 'Complete backup including goals and records',
                  leadingIcon: Icons.code_rounded,
                  leadingColor: c.info,
                  onTap: _busy ? null : () => _export(asCsv: false),
                ),
              ],
            ),
          ),
          const SizedBox(height: Gap.xl),

          const SectionHeader(title: 'Danger zone'),
          AppCard(
            borderColor: c.danger.withValues(alpha: 0.35),
            padding: const EdgeInsets.symmetric(vertical: Gap.sm),
            child: Column(
              children: [
                AppListTile(
                  title: 'Delete training data',
                  subtitle: 'Keeps your profile and settings',
                  leadingIcon: Icons.delete_sweep_outlined,
                  leadingColor: c.danger,
                  titleColor: c.danger,
                  onTap: _busy ? null : _deleteWorkoutData,
                ),
                AppListTile(
                  title: 'Reset the app',
                  subtitle: 'Wipes everything and restarts setup',
                  leadingIcon: Icons.restart_alt_rounded,
                  leadingColor: c.danger,
                  titleColor: c.danger,
                  onTap: _busy ? null : _resetEverything,
                ),
              ],
            ),
          ),

          if (_busy) ...[
            const SizedBox(height: Gap.xl),
            Center(child: CircularProgressIndicator(color: c.accent)),
          ],
        ],
      ),
    );
  }
}
