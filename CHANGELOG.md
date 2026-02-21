# Changelog

All notable changes to QuitEase will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

---

## [1.0.0] — 2026-02-21

### 🎉 Initial Release

#### Added
- **Live Smoke-Free Timer** — real-time digital clock counting up from quit date/time
- **Real-Time Progress Tracking** — cigarettes avoided, money saved, time won back for Today / Week / Month / Year
- **20 Achievement Badges** — two tracks: cigarettes skipped & consecutive days (1 day → 2 years)
- **Health Improvement Timeline** — 10 WHO-backed health benefits shown as animated progress bars
- **Smart Milestone Notifications** — instant push notifications for achievement unlocks and money/cigarette thresholds
- **Guest Mode** — start tracking immediately without an account
- **Google Sign-In** — Firebase Auth with OAuth 2.0 ID token flow
- **Account Linking** — seamlessly upgrade guest session to Google account with zero progress loss
- **Onboarding Flow** — quit date picker → smoking data → summary → dashboard
- **Future Quit Date** — countdown mode if you haven't quit yet
- **Share Your Journey** — share stats and achievement card via system share sheet
- **GetX State Management** — fully reactive UI with `Rx<T>` + `Obx`, no `setState`
- **Feature-First Clean Architecture** — `auth`, `onboarding`, `dashboard`, `achievements`, `health`, `progress`, `settings`, `account_linking`
- **Cloud Firestore** — user data storage and sync with security rules
- **Environment Variables** — `flutter_dotenv` for safe credential management (`.env` gitignored)
- **Security Policy** — `SECURITY.md` with vulnerability reporting and architecture overview

#### Tech Stack
- Flutter 3.10+ / Dart 3+
- Firebase Auth + Cloud Firestore
- GetX 4.6+
- flutter_local_notifications
- flutter_dotenv
- Lottie animations, Iconsax, FontAwesome, Poppins font

---

## [Unreleased]

### Planned
- iOS support
- Dark / light theme toggle
- Weekly motivational tips
- Community leaderboard (opt-in)

---

[1.0.0]: https://github.com/MUmer24/Quitease-Firebase-Application/releases/tag/v1.0.0
