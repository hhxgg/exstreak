import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../domain/app_settings.dart';

/// Persists [AppSettings] as a single JSON blob in shared preferences.
///
/// One key rather than thirty means a settings change is one atomic write, and
/// adding a field never needs a migration.
class SettingsRepository {
  SettingsRepository(this._prefs);

  static const String _key = 'app_settings_v1';

  final SharedPreferences _prefs;

  static Future<SettingsRepository> open() async =>
      SettingsRepository(await SharedPreferences.getInstance());

  AppSettings load() {
    final raw = _prefs.getString(_key);
    if (raw == null || raw.isEmpty) return const AppSettings();
    try {
      final decoded = jsonDecode(raw);
      if (decoded is! Map) return const AppSettings();
      return AppSettings.fromJson(Map<String, Object?>.from(decoded));
    } on FormatException catch (e) {
      // Corrupt preferences must not brick the app; fall back to defaults.
      debugPrint('Settings decode failed, using defaults: $e');
      return const AppSettings();
    }
  }

  Future<void> save(AppSettings settings) async {
    await _prefs.setString(_key, jsonEncode(settings.toJson()));
  }

  Future<void> clear() async {
    await _prefs.remove(_key);
  }
}
