# Google Play Data safety form — answers for ExStreak

These answers reflect what the code actually does. Every claim below was
checked against the implementation, not assumed.

**Verification basis**

- No HTTP client is used anywhere in the app. The only packages that could
  reach the network (`share_plus`, `package_info_plus`) do not send data off
  the device on their own.
- No analytics, crash-reporting or advertising SDK is present. Check
  `pubspec.yaml` — there is no Firebase, no Google Analytics, no AdMob.
- All training data is written to a local SQLite database
  (`lib/data/database.dart`) and preferences (`lib/data/repositories/settings_repository.dart`).
- The release manifest requests no `INTERNET` permission. Flutter injects it
  into debug/profile builds only (`android/app/src/debug/AndroidManifest.xml`).

---

## Section 1 — Data collection and sharing

> **Does your app collect or share any of the required user data types?**

**No.**

Google's definition: "collect" means transmitting data off the device.
ExStreak stores data **on the device only** and transmits nothing, so nothing
is "collected" for the purposes of this form.

Answering **No** here closes out the rest of the questionnaire. The sections
below record the reasoning in case a reviewer asks.

---

## Section 2 — Security practices

| Question | Answer |
|---|---|
| Is all user data encrypted in transit? | **Not applicable — no data is transmitted.** Select this option if offered; otherwise leave the in-transit question unanswered, since answering "yes" would imply transmission occurs. |
| Do you provide a way for users to request data deletion? | **Yes.** Settings → Your data offers "Delete training data" and "Reset the app". Uninstalling also removes everything. |
| Has your app been independently validated against a global security standard? | **No.** Do not claim any certification. |

---

## Section 3 — Reasoning per data type

Kept for reference; none of these should be ticked on the form.

| Play data type | In ExStreak? | Collected / transmitted? |
|---|---|---|
| Name | Optional display name, stored locally | No |
| Email address | Not requested | No |
| User IDs | None — no accounts | No |
| Address, phone number | Not requested | No |
| Approximate / precise location | Not requested, no location permission | No |
| Health and fitness info | Workouts, reps, durations — **stored locally only** | No |
| Photos and videos | No camera or gallery access; avatars are built-in emoji | No |
| Audio | No microphone permission | No |
| Files and docs | Export writes a file only when the user taps Export, then hands it to the system share sheet | No |
| Calendar, contacts | Not requested | No |
| App activity / interactions | Not tracked; no analytics | No |
| Web browsing history | Not accessed | No |
| App info and performance (crash logs) | No crash SDK. Play's own crash reporting is independent of the app. | No |
| Device or other IDs | Not read | No |

---

## Section 4 — Related declarations elsewhere in the console

### Ads
- **Does your app contain ads?** → **No.**
  There is no ad SDK and no ad-supported content.

### Government apps
- **No.**

### Financial features
- **No.**

### Health apps declaration
ExStreak is a general fitness tracker. It does **not**:
- provide medical advice, diagnosis or treatment;
- connect to Health Connect or any health platform;
- handle medical records.

If Play asks whether the app is a "health app", declare it as **fitness /
general wellness**, not medical.

### Photo and video permissions
- Not requested. `READ_MEDIA_IMAGES` and friends are absent from the manifest.

### Package visibility (`QUERY_ALL_PACKAGES`)
- **Not used.** The manifest declares only two narrow `<queries>` intents
  (`PROCESS_TEXT`, `TTS_SERVICE`), which do not require the broad permission.

### Foreground services
- **None declared.** Screen-on during a workout uses `WAKE_LOCK`, not a
  foreground service.

### Data deletion (account deletion policy)
- The app has **no account system**, so the "account deletion URL" requirement
  does not apply. In-app deletion is described in the privacy policy.

---

## Section 5 — Content rating questionnaire

Expected outcome: **PEGI 3 / ESRB Everyone / rated for all ages.**

| Question | Answer |
|---|---|
| Violence | None |
| Sexuality / nudity | None |
| Profanity | None |
| Controlled substances (drugs, alcohol, tobacco) | None |
| Gambling or simulated gambling | None |
| User-generated content shared with others | **No.** Custom exercise names and the motto stay on the device. |
| In-app communication between users | None |
| Sharing user location with others | None |
| Digital purchases | None |
| Personal information collection | None |
| Miscellaneous: does the app promote unhealthy behaviour? | No. It does not set calorie targets, restrict eating, or push extreme volume. Plans start at a beginner-appropriate level and adapt down when a session is reported as too hard. |

---

## Section 6 — Target audience and content

- **Target age group:** 18 and over (recommended), or 13+.
  Do **not** select an under-13 age group — that would put the app under
  Families policy and require additional declarations that this app is not
  designed for.
- **Appeals to children?** No. The visual design, copy and content are aimed
  at adults.
- **Ads shown to children?** Not applicable — no ads.

---

## Section 7 — App access

> **Is any part of your app restricted behind a login?**

**No — all functionality is available without any credentials.**

This matters: reviewers must be able to reach every screen. There is nothing to
unlock, no subscription and no test account needed.
