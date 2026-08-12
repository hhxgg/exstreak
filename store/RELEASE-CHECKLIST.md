# Publishing ExStreak to Google Play

Everything that could be built, signed and written has been. What remains
requires a human: a Google account, a payment, an identity check and a legal
agreement. Those cannot be automated, and none of them have been done.

**Current status: the signed release bundle is built and validated. Nothing has
been uploaded to Google Play.**

---

## What is already done

| | |
|---|---|
| ✅ | Package ID `com.exstreak.app`, version `1.0.0+1` |
| ✅ | `targetSdk 36` — meets Play's 31 Aug 2026 requirement for new apps |
| ✅ | Upload keystore generated (RSA 4096, valid to Dec 2053) at `android/exstreak-upload.jks` |
| ✅ | Signed Android App Bundle built and signature-verified |
| ✅ | Launcher icon, adaptive + themed monochrome layers, splash screen |
| ✅ | Play icon (512×512) and feature graphic (1024×500) in `store/graphics/` |
| ✅ | Store listing copy in `store/listing.md` |
| ✅ | Privacy policy page in `store/privacy-policy.html` |
| ✅ | Data safety and content rating answers in `store/data-safety.md` |
| ✅ | Source pushed to https://github.com/hhxgg/exstreak |

Build artefact:

```
build/app/outputs/bundle/release/app-release.aab
```

Its 61.7 MB is expected: ~32 MB is native debug symbols (used by Play for crash
deobfuscation, never sent to devices) and the rest covers three CPU
architectures. **Each user downloads roughly 11–12 MB.**

---

## ⚠️ Back up the keystore before anything else

```
android/exstreak-upload.jks
android/key.properties      ← contains the password
```

Both are git-ignored and exist **only on this machine**. If you lose them you
can never publish an update to this app under the same listing — you would have
to ship a new app with a new package name and lose all installs and reviews.

Copy both files somewhere safe and offline **now**. A password manager entry or
an encrypted backup, not a cloud folder that syncs to a machine you might wipe.

---

## Step 1 — Create the developer account (you)

1. Go to https://play.google.com/console and sign in.
2. Choose **Personal** or **Organisation**. This choice matters — see step 6.
3. Pay the **one-time US$25 registration fee**.
4. Complete **identity verification** (government ID; Google may take a few
   days).
5. Accept the **Developer Distribution Agreement**.

> I cannot do any of this. Payment, identity verification and accepting a legal
> agreement are actions only the account holder can take.

---

## Step 2 — Host the privacy policy (you, ~5 minutes)

Play requires a publicly reachable privacy policy URL. The page is already
written at `store/privacy-policy.html`.

The app already points at `https://hhxgg.github.io/exstreak/privacy.html`
(see `lib/core/branding.dart`). To make that URL live via GitHub Pages:

```bash
cd D:\ExStreak
git checkout --orphan gh-pages
git rm -rf . --quiet
mkdir -p .
cp store/privacy-policy.html privacy.html
git add privacy.html
git commit -m "docs: publish privacy policy"
git push -u origin gh-pages
git checkout main
```

Then in the repo: **Settings → Pages → Source: `gh-pages` branch, `/ (root)`**.

Give it a minute, then confirm the URL loads. If you host it elsewhere instead,
update `Branding.privacyPolicyUrl` in `lib/core/branding.dart` and rebuild.

---

## Step 3 — Create the app in Play Console (you)

**All apps → Create app**

| Field | Value |
|---|---|
| App name | `ExStreak: Workout Streaks` |
| Default language | English (United Kingdom) or (United States) |
| App or game | App |
| Free or paid | Free |
| Declarations | Tick Developer Programme Policies and US export laws |

---

## Step 4 — Fill in the listing

Copy from `store/listing.md`:

- **Short description** (80 char limit)
- **Full description** (4 000 char limit)
- **App icon** → `store/graphics/play-icon-512.png`
- **Feature graphic** → `store/graphics/feature-graphic.png`
- **Phone screenshots** → 2–8 required. See "Screenshots" below.
- **Category** → Health & Fitness
- **Contact email** → simonsvabenicky@gmail.com
- **Privacy policy URL** → the URL from step 2

### Screenshots

**Not yet captured.** Taking them needs a running instance of the app, and this
machine cannot run an Android emulator — CPU virtualisation is disabled in the
firmware (`VirtualizationFirmwareEnabled: False`) and no hypervisor is
installed. Both fixes need BIOS access and administrator rights.

Two ways to get them:

- **Plug in your Android phone** with USB debugging enabled. Then:
  ```bash
  flutter install --release
  ```
  Take screenshots on the device, or capture them over ADB:
  ```bash
  adb exec-out screencap -p > store/graphics/screenshots/01-home.png
  ```
  Ask me to drive this and I will install the app and script the capture.

- **Enable virtualisation**: reboot into BIOS/UEFI, turn on Intel VT-x or
  AMD-V, then run Android Studio's SDK Manager as administrator and install the
  *Android Emulator hypervisor driver*. The AVD `exstreak_test` is already
  created and waiting.

Screens worth capturing: Home dashboard, an active set with the rep ring, the
"How did that feel?" prompt, the streak calendar, the Progress charts, and the
badge case on Profile.

---

## Step 5 — Complete the policy questionnaires

Answers are pre-written in `store/data-safety.md`:

- **App content → Privacy policy** — paste the URL
- **App content → Ads** — *No ads*
- **App content → App access** — *All functionality available without special access*
- **App content → Content rating** — complete the questionnaire; expect PEGI 3 / Everyone
- **App content → Target audience** — 18+ (or 13+); **not** under 13
- **App content → Data safety** — answer **No** to data collection and sharing;
  answer **Yes** to "users can request data deletion"
- **App content → Government apps / Financial features / Health apps** — No,
  No, and *fitness / general wellness* respectively

---

## Step 6 — ⚠️ The closed-testing requirement (personal accounts)

If you registered a **personal** developer account (created after 13 Nov 2023),
Google requires a closed test with **at least 12 testers opted in continuously
for 14 days** before the "Apply for production" button unlocks. Organisation
accounts, which need a D-U-N-S number, are exempt.

So the realistic path is:

1. **Testing → Closed testing → Create a track**, upload the `.aab`.
2. Create an email list with **12+ real testers** and send them the opt-in link.
3. Make sure all 12 stay opted in for **14 consecutive days** — if someone opts
   out the clock can reset.
4. After 14 days, **Apply for production access**, then promote the release.

Budget at least two weeks between finishing the listing and going live. If you
have an organisation account, skip straight to a production release.

---

## Step 7 — Upload the bundle

**Testing → Closed testing → Create new release** (or **Production** if
eligible), then upload:

```
build/app/outputs/bundle/release/app-release.aab
```

- **Let Google manage and protect your signing key** — accept **Play App
  Signing**. Your `.jks` then acts as the *upload* key, which Google can help
  you reset if it is ever lost. This is the safer option; take it.
- **Release notes** — copy the "What's new" block from `store/listing.md`.
- Roll out.

---

## Rebuilding later

```bash
flutter build appbundle --release
```

Bump the version in `pubspec.yaml` before every upload — Play rejects a bundle
whose `versionCode` it has already seen:

```yaml
version: 1.0.1+2    # versionName+versionCode
```

---

## Honest summary

Everything up to the Play Console is finished and verified. From step 1 onward
the work is gated on your Google account, a payment, an identity check and a
legal agreement — plus, most likely, a two-week closed test. **Nothing has been
submitted or published.**
