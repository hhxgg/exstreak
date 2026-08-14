/// Single source of truth for product naming and outward-facing links.
///
/// Renaming the product means editing this file plus:
///   - `pubspec.yaml` (package name, description)
///   - `android/app/build.gradle.kts` (applicationId, namespace)
///   - `android/app/src/main/AndroidManifest.xml` (android:label)
///   - `assets/branding/*` (icon + splash sources)
abstract final class Branding {
  static const String appName = 'ExStreak';
  static const String tagline = 'Consistency beats intensity.';
  static const String packageId = 'com.exstreak.app';

  /// Shown in Settings → About and used as the export filename prefix.
  static const String exportPrefix = 'exstreak';

  static const String supportEmail = 'simonsvabenicky@gmail.com';
  static const String privacyPolicyUrl =
      'https://simonsvabenicky-lang.github.io/exstreak/privacy.html';
  static const String sourceUrl =
      'https://github.com/simonsvabenicky-lang/exstreak';
}
