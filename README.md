# ExStreak

**Consistency beats intensity.** A fully offline Android training app built around
streaks: a plan that adapts to how hard the last session felt, a rep counter you
can use with your nose on the screen, and progress tracking that survives real
life.

Every feature is available to every user. There is no subscription, no account,
and no server.

---

## What it does

| | |
|---|---|
| **Adaptive plans** | Six progressive plans (push-ups, pull-ups, dips, squats, sit-ups, plank), three levels each, sixteen days per level. After each session you say whether it was too easy, just right or too hard, and the next day adjusts. |
| **Streaks that survive real life** | Streaks are computed from your actual activity history, not an incrementing counter. Earn a freeze every 14 days (max two) that is spent automatically to bridge a missed day. |
| **Two ways to count reps** | Tap the ring, or switch on proximity counting and let the phone count each rep as your nose covers the sensor. Devices without the sensor fall back to tapping. |
| **34 exercises, 4 tracking types** | Reps, reps + weight, timed holds, and distance + duration. Adding an exercise never requires touching screen code. |
| **Custom exercises and sessions** | Create your own exercises and build sessions by hand, or run free practice with no targets at all. |
| **Progress you can read** | Volume trends, best-set progression, estimated one-rep max, muscle-group split, personal records and a full session history. |
| **Goals** | Single-set records, lifetime volume, streak length, workout count and weekly frequency — all recomputed from real data. |
| **Badges** | 22 achievements across streaks, volume, max reps, plank holds and specials. |
| **Reminders** | One optional daily nudge, plus an evening warning when a live streak is about to expire. Nothing else. |
| **Your data stays yours** | Export to CSV or JSON, delete training data, or reset the app entirely. |

---

## Technology

| Concern | Choice | Why |
|---|---|---|
| Framework | Flutter 3.44 / Dart 3.12 | One codebase, native performance, excellent animation control. |
| State | [Riverpod](https://riverpod.dev) 2.x | Compile-safe dependency injection and testable providers without a widget-tree dependency. |
| Database | [Drift](https://drift.simonbinder.eu) over SQLite | A real relational schema with foreign keys, so statistics aggregate in SQL rather than in Dart. |
| Routing | [go_router](https://pub.dev/packages/go_router) | Declarative routes with a stateful bottom-navigation shell. |
| Charts | [fl_chart](https://pub.dev/packages/fl_chart) | Themeable enough to look native to the app rather than like a library default. |
| Notifications | flutter_local_notifications + timezone | Local-only scheduling that survives reboots and timezone changes. |

### Design notes

- **`Day` instead of `DateTime`.** Streaks are defined in local calendar days.
  Storing instants and comparing them across a DST boundary or a flight produces
  off-by-one streaks, so activity is keyed by a timezone-free `Day`
  (`yyyyMMdd`) that sorts and range-queries correctly in SQL.
- **The streak engine is pure.** `StreakEngine` takes a set of days and what
  "today" is, and returns a summary. No clock, no database. That is what makes
  midnight, missed days, freezes and long absences testable rather than hopeful.
- **Writes go straight to SQLite.** Every completed set is committed
  immediately, so killing the app mid-session loses nothing.
- **Nothing branches on a specific exercise.** All behaviour derives from
  `TrackingType`, so a new exercise is one entry in the seed file.
- **Daily activity is recomputed, never incremented.** Deleting or editing a
  workout leaves the streak and statistics correct.

---

## Project structure

```
lib/
  core/          Day arithmetic, formatting, branding constants
  data/
    tables.dart      Drift table definitions
    database.dart    Schema, migrations, queries
    seed/            Built-in exercise catalogue
    repositories/    Exercise, workout, goal, stats, settings
  domain/
    enums.dart       TrackingType, MuscleGroup, GoalType, …
    streak/          Pure streak arithmetic
    stats/           Pure aggregation and chart series
    plan/            Progressive plan generation
    badges/          Achievement catalogue
    workout/         Session models
  screens/       One folder per feature area
  services/      Notifications
  state/         Riverpod providers
  theme/         Colours, type scale, spacing, component themes
  widgets/       Shared UI: cards, buttons, rings, charts, calendar
tool/            Branding image generator
test/
  domain/        Pure unit tests
  data/          Database integration tests
  widget/        Screen tests
```

---

## Running it

```bash
flutter pub get
flutter run
```

Drift's generated code (`lib/data/database.g.dart`) is committed, so a fresh
clone builds without running codegen. After changing `lib/data/tables.dart`:

```bash
dart run build_runner build
```

### Tests

```bash
flutter test
```

119 tests cover streak arithmetic (including midnight, missed days, freezes,
timezone shifts and multi-year absences), plan progression, statistics, the
database layer, persistence across restarts, and the main screens.

### Analysis and formatting

```bash
flutter analyze
dart format lib test
```

---

## Building a release

Release signing reads `android/key.properties`, which is **not** in the
repository. Create it alongside your keystore:

```properties
storePassword=…
keyPassword=…
keyAlias=exstreak-upload
storeFile=exstreak-upload.jks
```

Generate a keystore if you do not have one:

```bash
keytool -genkeypair -v -keystore android/exstreak-upload.jks -alias exstreak-upload -keyalg RSA -keysize 4096 -validity 10000 -storetype PKCS12
```

Then:

```bash
flutter build appbundle --release
```

Without `key.properties` the release build falls back to the debug signing
config so the build still succeeds for local verification — such a bundle
cannot be uploaded to Google Play.

> **Back up the keystore.** It is the one artefact that cannot be regenerated.
> Lose it and the app can never be updated under the same Play listing.

### Regenerating branding

The launcher icon, adaptive layers and splash art are generated from code:

```bash
pwsh -File tool/generate_branding.ps1   # Windows only (System.Drawing)
dart run flutter_launcher_icons
dart run flutter_native_splash:create
```

Renaming the product means editing `lib/core/branding.dart`, `pubspec.yaml`,
`android/app/build.gradle.kts` (applicationId, namespace) and the
`android:label` in the manifest.

---

## Privacy

ExStreak has no account, no analytics and no network calls in any core flow.
All training data lives in a SQLite database on the device.

| Permission | Used for |
|---|---|
| `POST_NOTIFICATIONS` | Only the reminders you switch on. |
| `SCHEDULE_EXACT_ALARM` / `USE_EXACT_ALARM` | Firing the daily reminder at the time you picked. |
| `RECEIVE_BOOT_COMPLETED` | Re-scheduling reminders after a reboot. |
| `WAKE_LOCK` | Keeping the screen on during an active workout. |
| Proximity sensor | Read only while a workout is open, and only if you choose proximity rep counting. Optional hardware — the app works without it. |

---

## Licence

Source code © 2026. The bundled [Outfit](https://fonts.google.com/specimen/Outfit)
typeface is used under the SIL Open Font License 1.1.
