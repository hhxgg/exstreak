import 'package:flutter/foundation.dart';

import 'enums.dart';
import 'plan/plan_templates.dart';

/// All user preferences and profile fields.
///
/// Small, flat and serialisable — this lives in key/value storage rather than
/// the database because none of it is relational and it must be readable
/// synchronously during the first frame.
@immutable
class AppSettings {
  const AppSettings({
    this.hasCompletedOnboarding = false,
    this.displayName = '',
    this.motto = '',
    this.avatarId = 'wolf',
    this.birthYear,
    this.heightCm,
    this.weightKg,
    this.fitnessLevel = FitnessLevel.beginner,
    this.primaryGoal = PrimaryGoal.consistency,
    this.weeklyTarget = 4,
    this.unitSystem = UnitSystem.metric,
    this.themeMode = AppThemeMode.dark,
    this.languageCode = 'en',
    this.restSecondsOverride,
    this.repInputMode = RepInputMode.tap,
    this.soundEnabled = true,
    this.voiceCoachEnabled = false,
    this.hapticsEnabled = true,
    this.keepScreenAwake = true,
    this.reminderEnabled = false,
    this.reminderHour = 18,
    this.reminderMinute = 0,
    this.streakRiskReminderEnabled = true,
    this.freezesAvailable = 0,
    this.freezeGrantedAtStreak = 0,
    this.activePlanId = PlanTemplates.defaultPlanId,
    this.memberSince,
  });

  final bool hasCompletedOnboarding;

  final String displayName;
  final String motto;

  /// Key into the built-in avatar set. No photo upload, so the app never
  /// touches the camera or the photo library.
  final String avatarId;

  final int? birthYear;
  final double? heightCm;
  final double? weightKg;

  final FitnessLevel fitnessLevel;
  final PrimaryGoal primaryGoal;

  /// Target training days per week, 1…7.
  final int weeklyTarget;

  final UnitSystem unitSystem;
  final AppThemeMode themeMode;

  /// Reserved for localisation; only 'en' ships today.
  final String languageCode;

  /// Overrides each exercise's own default rest, in seconds.
  final int? restSecondsOverride;

  final RepInputMode repInputMode;
  final bool soundEnabled;
  final bool voiceCoachEnabled;
  final bool hapticsEnabled;
  final bool keepScreenAwake;

  final bool reminderEnabled;
  final int reminderHour;
  final int reminderMinute;
  final bool streakRiskReminderEnabled;

  /// Unspent streak freezes.
  final int freezesAvailable;

  /// Streak length at which the last freeze was granted, so a token is not
  /// granted twice for the same milestone.
  final int freezeGrantedAtStreak;

  final String activePlanId;

  final DateTime? memberSince;

  int? get age {
    if (birthYear == null) return null;
    final a = DateTime.now().year - birthYear!;
    return (a >= 5 && a <= 120) ? a : null;
  }

  String get greetingName =>
      displayName.trim().isEmpty ? 'athlete' : displayName.trim();

  AppSettings copyWith({
    bool? hasCompletedOnboarding,
    String? displayName,
    String? motto,
    String? avatarId,
    int? birthYear,
    bool clearBirthYear = false,
    double? heightCm,
    bool clearHeight = false,
    double? weightKg,
    bool clearWeight = false,
    FitnessLevel? fitnessLevel,
    PrimaryGoal? primaryGoal,
    int? weeklyTarget,
    UnitSystem? unitSystem,
    AppThemeMode? themeMode,
    String? languageCode,
    int? restSecondsOverride,
    bool clearRestOverride = false,
    RepInputMode? repInputMode,
    bool? soundEnabled,
    bool? voiceCoachEnabled,
    bool? hapticsEnabled,
    bool? keepScreenAwake,
    bool? reminderEnabled,
    int? reminderHour,
    int? reminderMinute,
    bool? streakRiskReminderEnabled,
    int? freezesAvailable,
    int? freezeGrantedAtStreak,
    String? activePlanId,
    DateTime? memberSince,
  }) {
    return AppSettings(
      hasCompletedOnboarding:
          hasCompletedOnboarding ?? this.hasCompletedOnboarding,
      displayName: displayName ?? this.displayName,
      motto: motto ?? this.motto,
      avatarId: avatarId ?? this.avatarId,
      birthYear: clearBirthYear ? null : (birthYear ?? this.birthYear),
      heightCm: clearHeight ? null : (heightCm ?? this.heightCm),
      weightKg: clearWeight ? null : (weightKg ?? this.weightKg),
      fitnessLevel: fitnessLevel ?? this.fitnessLevel,
      primaryGoal: primaryGoal ?? this.primaryGoal,
      weeklyTarget: weeklyTarget ?? this.weeklyTarget,
      unitSystem: unitSystem ?? this.unitSystem,
      themeMode: themeMode ?? this.themeMode,
      languageCode: languageCode ?? this.languageCode,
      restSecondsOverride: clearRestOverride
          ? null
          : (restSecondsOverride ?? this.restSecondsOverride),
      repInputMode: repInputMode ?? this.repInputMode,
      soundEnabled: soundEnabled ?? this.soundEnabled,
      voiceCoachEnabled: voiceCoachEnabled ?? this.voiceCoachEnabled,
      hapticsEnabled: hapticsEnabled ?? this.hapticsEnabled,
      keepScreenAwake: keepScreenAwake ?? this.keepScreenAwake,
      reminderEnabled: reminderEnabled ?? this.reminderEnabled,
      reminderHour: reminderHour ?? this.reminderHour,
      reminderMinute: reminderMinute ?? this.reminderMinute,
      streakRiskReminderEnabled:
          streakRiskReminderEnabled ?? this.streakRiskReminderEnabled,
      freezesAvailable: freezesAvailable ?? this.freezesAvailable,
      freezeGrantedAtStreak:
          freezeGrantedAtStreak ?? this.freezeGrantedAtStreak,
      activePlanId: activePlanId ?? this.activePlanId,
      memberSince: memberSince ?? this.memberSince,
    );
  }

  Map<String, Object?> toJson() => {
    'hasCompletedOnboarding': hasCompletedOnboarding,
    'displayName': displayName,
    'motto': motto,
    'avatarId': avatarId,
    'birthYear': birthYear,
    'heightCm': heightCm,
    'weightKg': weightKg,
    'fitnessLevel': fitnessLevel.name,
    'primaryGoal': primaryGoal.name,
    'weeklyTarget': weeklyTarget,
    'unitSystem': unitSystem.name,
    'themeMode': themeMode.name,
    'languageCode': languageCode,
    'restSecondsOverride': restSecondsOverride,
    'repInputMode': repInputMode.name,
    'soundEnabled': soundEnabled,
    'voiceCoachEnabled': voiceCoachEnabled,
    'hapticsEnabled': hapticsEnabled,
    'keepScreenAwake': keepScreenAwake,
    'reminderEnabled': reminderEnabled,
    'reminderHour': reminderHour,
    'reminderMinute': reminderMinute,
    'streakRiskReminderEnabled': streakRiskReminderEnabled,
    'freezesAvailable': freezesAvailable,
    'freezeGrantedAtStreak': freezeGrantedAtStreak,
    'activePlanId': activePlanId,
    'memberSince': memberSince?.toIso8601String(),
  };

  /// Tolerant of missing and malformed values so a partially written or
  /// downgraded preferences file can never crash startup.
  static AppSettings fromJson(Map<String, Object?> json) {
    T pick<T extends Enum>(List<T> values, Object? raw, T fallback) {
      if (raw is! String) return fallback;
      for (final v in values) {
        if (v.name == raw) return v;
      }
      return fallback;
    }

    int? asInt(Object? v) => v is int ? v : (v is num ? v.toInt() : null);
    double? asDouble(Object? v) => v is num ? v.toDouble() : null;
    bool asBool(Object? v, bool fallback) => v is bool ? v : fallback;

    DateTime? memberSince;
    final rawMember = json['memberSince'];
    if (rawMember is String) memberSince = DateTime.tryParse(rawMember);

    return AppSettings(
      hasCompletedOnboarding: asBool(json['hasCompletedOnboarding'], false),
      displayName: (json['displayName'] as String?) ?? '',
      motto: (json['motto'] as String?) ?? '',
      avatarId: (json['avatarId'] as String?) ?? 'wolf',
      birthYear: asInt(json['birthYear']),
      heightCm: asDouble(json['heightCm']),
      weightKg: asDouble(json['weightKg']),
      fitnessLevel: pick(
        FitnessLevel.values,
        json['fitnessLevel'],
        FitnessLevel.beginner,
      ),
      primaryGoal: pick(
        PrimaryGoal.values,
        json['primaryGoal'],
        PrimaryGoal.consistency,
      ),
      weeklyTarget: (asInt(json['weeklyTarget']) ?? 4).clamp(1, 7),
      unitSystem: pick(
        UnitSystem.values,
        json['unitSystem'],
        UnitSystem.metric,
      ),
      themeMode: pick(
        AppThemeMode.values,
        json['themeMode'],
        AppThemeMode.dark,
      ),
      languageCode: (json['languageCode'] as String?) ?? 'en',
      restSecondsOverride: asInt(json['restSecondsOverride']),
      repInputMode: pick(
        RepInputMode.values,
        json['repInputMode'],
        RepInputMode.tap,
      ),
      soundEnabled: asBool(json['soundEnabled'], true),
      voiceCoachEnabled: asBool(json['voiceCoachEnabled'], false),
      hapticsEnabled: asBool(json['hapticsEnabled'], true),
      keepScreenAwake: asBool(json['keepScreenAwake'], true),
      reminderEnabled: asBool(json['reminderEnabled'], false),
      reminderHour: (asInt(json['reminderHour']) ?? 18).clamp(0, 23),
      reminderMinute: (asInt(json['reminderMinute']) ?? 0).clamp(0, 59),
      streakRiskReminderEnabled: asBool(
        json['streakRiskReminderEnabled'],
        true,
      ),
      freezesAvailable: (asInt(json['freezesAvailable']) ?? 0).clamp(0, 5),
      freezeGrantedAtStreak: asInt(json['freezeGrantedAtStreak']) ?? 0,
      activePlanId:
          (json['activePlanId'] as String?) ?? PlanTemplates.defaultPlanId,
      memberSince: memberSince,
    );
  }
}

/// The built-in avatar set — emoji rather than uploads, which keeps the app
/// free of camera/storage permissions and of user-generated image hosting.
abstract final class Avatars {
  static const Map<String, String> all = {
    'wolf': '🐺',
    'gorilla': '🦍',
    'tiger': '🐯',
    'bear': '🐻',
    'eagle': '🦅',
    'shark': '🦈',
    'lion': '🦁',
    'fox': '🦊',
    'dragon': '🐲',
    'rhino': '🦏',
    'bull': '🐂',
    'panda': '🐼',
  };

  static String emoji(String id) => all[id] ?? all['wolf']!;

  static List<String> get ids => all.keys.toList(growable: false);
}
