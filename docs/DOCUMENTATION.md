# QuitEase — Complete App Documentation

> *A comprehensive smoking cessation companion to help users quit smoking with real-time progress tracking, achievements, and health insights.*

---

## Table of Contents

1. [Project Overview](#1-project-overview)
2. [Architecture](#2-architecture)
3. [Tech Stack & Dependencies](#3-tech-stack--dependencies)
4. [Project Structure](#4-project-structure)
5. [Features](#5-features)
   - [Auth & Onboarding](#51-auth--onboarding)
   - [Dashboard](#52-dashboard)
   - [Progress](#53-progress)
   - [Achievements](#54-achievements)
   - [Health Improvements](#55-health-improvements)
   - [Settings & Profile](#56-settings--profile)
   - [Notifications](#57-notifications)
6. [Data Models](#6-data-models)
7. [Services & Repositories](#7-services--repositories)
8. [State Management](#8-state-management)
9. [Design System](#9-design-system)
10. [Firebase & Backend](#10-firebase--backend)
11. [App Navigation & Routing](#11-app-navigation--routing)
12. [Dependency Injection](#12-dependency-injection)

---

## 1. Project Overview

| Property | Value |
|----------|-------|
| **App Name** | QuitEase |
| **Package Name** | `quitease` |
| **Version** | 1.0.0+1 |
| **Platform** | Android (primary), Flutter cross-platform |
| **Flutter SDK** | ^3.10.8 |
| **Theme Name** | Serene Ascent: Azure Edition |

**QuitEase** is a Flutter mobile application designed to support smokers on their journey to quit. Users enter their quit date, daily cigarette count, pack price, and the app tracks every second — calculating cigarettes avoided, money saved, time won back, and health improvements — all backed by Firebase.

---

## 2. Architecture

QuitEase follows a **feature-first clean architecture** with GetX as the state management, DI, and navigation layer:

```
lib/
├── core/              # App-wide constants, DI, theme, Firebase config
├── features/          # Vertical feature slices (auth, dashboard, etc.)
│   └── <feature>/
│       ├── data/      # Controllers/data sources specific to the feature
│       └── presentation/
│           ├── controllers/   # GetxController(s)
│           ├── screens/       # Full screens (pages)
│           └── widgets/       # Reusable feature-local widgets
├── routes/            # AppRoutes constants + AppPages
└── shared/            # Cross-feature models, repos, services, utils
    ├── models/
    ├── repositories/
    ├── services/
    └── utils/
```

### Architectural Decisions

| Decision | Choice | Reason |
|----------|--------|--------|
| State Management | GetX (`Rx` + `Obx`) | Minimal boilerplate, built-in DI & navigation |
| Navigation | `Get.to / Get.offAll` | Tight coupling with GetX controllers |
| Auth | Firebase Auth (Google + Anonymous) | OAuth + guest mode without login friction |
| Local Storage | `SharedPreferences` + `GetStorage` | Dual-layer: cross-session data + fast reactive storage |
| Persistent DB | `sqflite` (available), Cloud Firestore | Offline-first with cloud sync |
| Notifications | `flutter_local_notifications` + `timezone` | Local milestone & motivational push notifications |

---

## 3. Tech Stack & Dependencies

### Runtime Dependencies

| Category | Package | Version | Purpose |
|----------|---------|---------|---------|
| **State/DI** | `get` | ^4.6.6 | State management, DI, navigation |
| **State/DI** | `get_storage` | ^2.1.1 | Fast reactive local key-value store |
| **Firebase** | `firebase_core` | ^3.8.1 | Firebase initialization |
| **Firebase** | `firebase_auth` | ^5.3.4 | Authentication |
| **Firebase** | `cloud_firestore` | ^5.5.1 | Cloud database |
| **Auth** | `google_sign_in` | ^7.2.0 | Google OAuth (v7 API) |
| **Storage** | `shared_preferences` | ^2.3.3 | Session-persistent local storage |
| **Storage** | `sqflite` | ^2.4.1 | Local SQL database |
| **Notifications** | `flutter_local_notifications` | ^18.0.1 | Push notifications |
| **Notifications** | `timezone` | ^0.9.4 | Timezone support for scheduled notifications |
| **UI** | `iconsax_flutter` | ^1.0.0 | Icon pack |
| **UI** | `font_awesome_flutter` | ^10.8.0 | Font Awesome icons |
| **UI** | `lottie` | ^3.2.2 | Lottie animation support |
| **UI** | `cached_network_image` | ^3.4.1 | Network image cache |
| **Utilities** | `intl` | ^0.20.1 | Date/number formatting |
| **Utilities** | `connectivity_plus` | ^6.1.1 | Network connectivity detection |
| **Utilities** | `share_plus` | ^10.1.3 | Share sheet integration |
| **Utilities** | `app_links` | ^6.3.3 | Deep linking |
| **UI** | `flutter_native_splash` | ^2.4.3 | Native splash screen |

### Dev Dependencies

| Package | Version | Purpose |
|---------|---------|---------|
| `flutter_lints` | ^6.0.0 | Lint rules |
| `flutter_launcher_icons` | ^0.14.4 | App icon generation |

---

## 4. Project Structure

```
quitease/
├── android/                   # Android native project
├── assets/
│   ├── icons/                 # UI icons (coin.png, chronometer.png, boost.png)
│   ├── imgs/                  # Dashboard & screen images
│   │   └── achievements_imgs/ # 20 achievement images (colored + grayscale)
│   └── logo/                  # App logo assets
├── docs/                      # Documentation (this file)
├── lib/
│   ├── main.dart              # Entry point
│   ├── firebase_options.dart  # Firebase platform config (root-level copy)
│   ├── core/
│   │   ├── config/
│   │   │   └── firebase_options.dart
│   │   ├── constants/
│   │   │   └── app_constants.dart   # All UI strings, colors, icon, image paths
│   │   ├── di/
│   │   │   └── dependency_injection.dart
│   │   └── theme/
│   │       └── app_theme.dart       # SereneAscentTheme
│   ├── features/
│   │   ├── account_linking/   # Guest-to-Google account upgrade
│   │   ├── achievements/      # Achievement system (20 badges)
│   │   ├── auth/              # Login, Signup, Auth Wrapper
│   │   ├── dashboard/         # Main home screen + AppDataController
│   │   ├── health/            # WHO health improvement timeline
│   │   ├── onboarding/        # Quit date, health tracking, summary
│   │   ├── progress/          # Daily/weekly/monthly/yearly stats
│   │   └── settings/          # Settings, profile, notifications
│   ├── routes/
│   │   ├── app_pages.dart
│   │   └── app_routes.dart
│   └── shared/
│       ├── models/
│       │   ├── user_model.dart
│       │   ├── achievement_model.dart
│       │   ├── benefit_model.dart
│       │   └── notification_config.dart
│       ├── repositories/
│       │   └── auth/
│       │       ├── authentication_repository.dart
│       │       ├── user_account.dart
│       │       ├── user_database.dart
│       │       └── user_repository.dart (implied)
│       ├── services/
│       │   ├── notification/
│       │   │   ├── notification_service.dart
│       │   │   └── notification_scheduler.dart
│       │   └── storage/
│       │       ├── data_persistence_service.dart
│       │       └── shared_prefs_provider.dart
│       ├── utils/
│       │   ├── enums.dart
│       │   ├── error_handler.dart
│       │   ├── loading_overlay.dart
│       │   ├── network_manager.dart
│       │   ├── savings_calculator.dart
│       │   ├── time_calculator.dart
│       │   ├── formatters/
│       │   │   └── formatter.dart
│       │   └── exceptions/
│       │       ├── firebase_auth_exceptions.dart
│       │       ├── firebase_exceptions.dart
│       │       ├── format_exceptions.dart
│       │       └── platform_exceptions.dart
│       └── widgets/
│           └── digital_clock.dart
├── firestore.rules
├── firebase.json
├── pubspec.yaml
└── splash.yaml
```

---

## 5. Features

### 5.1 Auth & Onboarding

#### Authentication (`features/auth/`)

Three entry points into the app:

| Method | Flow |
|--------|------|
| **Google Sign-In** | Uses `GoogleSignIn.authenticate()` (v7+ API) → Firebase credential → Firestore user record |
| **Anonymous (Guest)** | Firebase `signInAnonymously()` → full app access without account |
| **Account Linking** | Guest users can link their anonymous account to Google to preserve progress |

**`AuthWrapper`** reads the Firebase auth state stream and routes:
- No user → Auth screen (onboarding-auth)
- User logged in, onboarding incomplete → `QuitDateTimeScreen`
- User logged in, onboarding complete → `DashboardScreen`

**`AuthWrapperController`** manages session state, logout with cleanup of local data.

#### Onboarding Flow (3 Screens)

```
QuitDateTimeScreen → HealthTrackingScreen → SummaryScreen → Dashboard
```

| Screen | Collects |
|--------|---------|
| `QuitDateTimeScreen` | Quit date + time (past = already quit, future = planning) |
| `HealthTrackingScreen` | Cigarettes per day, cigarettes per pack, price per pack |
| `SummaryScreen` | Confirmation — displays stats preview, then saves to Firestore + SharedPreferences |

After finishing onboarding, `ontask_completion.dart` fires to save all data and mark `isOnboardingComplete = true`.

---

### 5.2 Dashboard

**File:** `features/dashboard/presentation/screens/dashboard_screen.dart`

The home screen is the central hub. It shows live-updating stats via `Obx`, driven by `AppDataController` which maintains a `Timer.periodic(Duration(seconds: 1))` feed.

#### Section: Timer Hero

A full-width landscape banner image (`dashboard_landscape_background.png`) with the stopwatch image overlaid, and below it a **`DigitalClockWidget`** displaying `HH MM SS` of smoke-free time.

#### Section: Overall Progress (4-card grid)

| Stat | Icon | Calculation |
|------|------|-------------|
| Days/hours quit | 🔥 orange | `DateTime.now().difference(quitDate)` |
| Cigarettes avoided | 🚬 red | `timeSinceQuit / 24h × cigarettesPerDay` |
| Money saved | 💰 coin image | `cigarettesAvoided / cigarettesPerPack × pricePerPack` |
| Time won back | ⏱ chronometer | Minutes saved (5 min/cigarette estimate) |

#### Section: Achievements Preview

Horizontal scrollable list of the 5 most recently unlocked achievements. Grayscale badges for locked; colored for unlocked. Tapping navigates to full `AchievementScreen`.

#### Section: Vitality Boost

A teaser card that describes the health improvement section with a boost icon. Tapping navigates to `HealthImprovementScreen`.

#### Guest Account Banner

Shown only when account is anonymous. Blue gradient banner with "Link Now" button that triggers `AccountLinkingController.linkWithGoogle()`.

#### Share Button

Toolbar action launches the native share sheet with a predefined `shareAppDescription` + GitHub link.

---

### 5.3 Progress

**File:** `features/progress/presentation/screens/progress_screen.dart`

Shows cigarette avoidance, money savings, and time won back across 4 time horizons:

| Card | Period |
|------|--------|
| Today's Progress | Since midnight |
| Weekly Progress | Last 7 days |
| Monthly Progress | Last 30 days |
| Yearly Progress | Last 365 days |

Each card is a 3-column layout (cigarettes | money | time) with color coding:
- 🔴 Red for cigarettes
- 🟢 Green for money
- 🔵 Blue for time

Driven by `ProgressController` which calculates proportional stats from the `AppDataController` data.

---

### 5.4 Achievements

**File:** `features/achievements/presentation/controllers/achievement_controller.dart`

20 total achievements across two tracks:

#### Cigarette-Based Badges (10)

| ID | Title | Required |
|----|-------|---------|
| 1 | Puff Passer | 1 cig skipped |
| 2 | Ash-Free Apprentice | 10 |
| 3 | Craving Crusher | 25 |
| 4 | Butt Breaker | 50 |
| 5 | Nicotine Ninja | 100 |
| 6 | Smoke-Free Streaker | 250 |
| 7 | Habit Hacker | 500 |
| 8 | Freedom Fighter | 1,000 |
| 9 | Oxygen Overload | 2,500 |
| 10 | Breathe Boss | 5,000 |

#### Days-Based Badges (10)

| ID | Title | Required |
|----|-------|---------|
| 11 | One Day Warrior | 1 day |
| 12 | Smoke-Free Starter | 3 days |
| 13 | Week One Wonder | 7 days |
| 14 | Lung Liberator | 14 days |
| 15 | Smoke-Free Sentinel | 30 days |
| 16 | Trigger Tamer | 60 days |
| 17 | Craving Commander | 90 days |
| 18 | Habit Hero | 180 days |
| 19 | Year of You | 365 days |
| 20 | Lifetime Legend | 730 days (2 years) |

Each achievement:
- Has a **colored** image (unlocked) and **grayscale** image (locked)
- Triggers a **push notification** when first unlocked
- Is sorted: completed achievements shown first, then by ascending `requiredValue`
- The first 5 completed appear in the Dashboard preview

---

### 5.5 Health Improvements

**File:** `features/health/presentation/screens/health_improvement_screen.dart`

Based on **WHO data**. Displays 10 health benefits as `LinearProgressIndicator` bars, each with a color that changes based on completion percentage:

| Color | Threshold | Meaning |
|-------|-----------|---------|
| 🔴 Red | < 20% | Just started |
| 🟠 Orange | 20–79% | In progress |
| 🔵 Blue | ≥ 80% | Nearly complete |

Benefits are sorted by completion (highest first). A completed benefit shows strikethrough text in green with a ✅ icon.

#### Health Benefits Timeline

| Benefit | Starts | Completes |
|---------|--------|-----------|
| Heart rate & blood pressure normalize | Day 0 | Day 10 |
| CO levels in blood drop to normal | Day 0 | Day 24 |
| Circulation improves, lung function increases | Day 0 | Day 14 |
| Taste and smell improve | Day 0 | Day 7 |
| Coughing & shortness of breath decrease | Day 14 | Day 90 |
| Risk of respiratory infections decreases | Day 30 | Day 365 |
| Immune system begins to recover | Day 30 | Day 90 |
| Cilia in lungs regain function | Day 30 | Day 90 |
| Risk of coronary heart disease halves | Day 365 | Day 7,300 |
| Stroke risk equals non-smoker | Day 365 | Day 7,300 |

The screen displays the WHO logo and source attribution at the bottom.

---

### 5.6 Settings & Profile

**File:** `features/settings/presentation/screens/settings_screen.dart`

Blue gradient header with profile card. Sections:

| Section | Options |
|---------|---------|
| **ACCOUNT** | Profile, Email (read-only) |
| **APP PREFERENCES** | Notifications, Share App, About App (version 1.0.0, build 2026.1.0) |
| **SUPPORT** | Logout button |

**Profile Screen** (`profile_screen.dart`) shows:
- User avatar (Google photo or initials fallback)
- Journey stats: Cigarettes Avoided, Money Saved, Time Won Back, Achievements Unlocked
- Shareable journey card (`profile_shareable_card.dart`) via `share_plus`

**Notification Settings Screen** lets users control which notification types they receive.

#### Reset Data

Settings controller provides a "Reset Data" flow that:
1. Clears SharedPreferences
2. Clears GetStorage
3. Navigates back to onboarding (QuitDateTimeScreen with `isAfterReset: true`)
4. `AppDataController.resetToZero()` resets all reactive stats

---

### 5.7 Notifications

**Files:** `shared/services/notification/`

| Service | Responsibility |
|---------|---------------|
| `NotificationService` | Initialize `flutter_local_notifications`, request permissions |
| `NotificationScheduler` | Fire immediate notifications for milestones and achievements |

#### Notification Triggers

| Trigger | Type |
|---------|------|
| Achievement unlocked | `showMilestoneNotification(title, body)` |
| Cigarette milestone reached | `showCigaretteMilestone(threshold)` — 10, 25, 50, 100, 250, 500, 1K, 2.5K, 5K, 10K |
| Money milestone reached | `showMoneySavedMilestone(threshold)` — $20, $50, $100, $500, $1K, $5K, $10K |

Milestone detection logic runs every second inside `AppDataController._checkMilestones()` comparing current value to previous to detect threshold crossings.

---

## 6. Data Models

### `UserModel` (`shared/models/user_model.dart`)

| Field | Type | Description |
|-------|------|-------------|
| `id` | `String` | Firebase UID |
| `fullName` | `String` | Display name |
| `email` | `String` | User email |
| `profilePicture` | `String` | URL from Google |
| `cigarettesCount` | `double` | Cigarettes per day |
| `smokesPerPack` | `double` | Cigarettes per pack |
| `pricePerPack` | `double` | Price per pack |
| `quitDate` | `DateTime?` | The pivotal quit date/time |
| `isOnboardingComplete` | `bool` | Onboarding completion flag |
| `deviceToken` | `String` | Push notification token |
| `createdAt` | `DateTime?` | Account creation timestamp |
| `updatedAt` | `DateTime?` | Last updated timestamp |

Methods: `toJson()`, `fromJson()`, `fromDocSnapshot()`, `copyWithSmokingData()`, `copyWithProfile()`, `isOnboardingCompleteCheck` (computed from non-zero smoking data + quitDate).

### `Achievement` (`shared/models/achievement_model.dart`)

| Field | Type | Description |
|-------|------|-------------|
| `coloredImage` | `String` | Asset path for unlocked state |
| `grayscaleImage` | `String` | Asset path for locked state |
| `title` | `String` | Achievement name |
| `subtitle` | `String` | Short description |
| `description` | `String` | Full motivation text |
| `requiredValue` | `int` | Days or cigarettes threshold |
| `isDaysBased` | `bool` | `true` = days, `false` = cigarettes |
| `isCompleted` | `bool` | Mutable completion status |

### `Benefit` (`shared/models/benefit_model.dart`)

| Field | Type | Description |
|-------|------|-------------|
| `progressPercent` | `int` | 0–100 as calculated from days |
| `description` | `String` | WHO benefit description |
| `isCompleted` | `bool` | Auto-derived: `progressPercent == 100` |

---

## 7. Services & Repositories

### `AuthenticationRepository`

Singleton `GetxController`. Handles:
- `signInWithGoogle()` — full Google OAuth → Firebase flow with user creation/update in Firestore
- `signInAnonymously()` — quick guest login
- `signOut()` — Firebase sign out

On successful Google Sign-In:
1. Checks if user already exists in Firestore  
2. **New user**: creates `UserModel`, saves to Firestore and SharedPreferences, navigates to `QuitDateTimeScreen`  
3. **Existing user (onboarding complete)**: syncs data from Firestore to SharedPreferences via `SharedPrefsProvider.loadFromFirebase()`, navigates to `DashboardScreen`  
4. **Existing user (onboarding incomplete)**: navigates to `QuitDateTimeScreen`

### `DataPersistenceService`

Centralized source of truth for smoking data. Reactive `Rx` fields:
- `quitDate`, `cigarettesPerDay`, `cigarettesPerPack`, `pricePerPack`

Loads data from SharedPreferences and exposes it to all controllers that depend on it.

### `SharedPrefsProvider`

Provides typed accessors to SharedPreferences. Key methods:
- `getQuitDate()`, `getCigarettesPerDay()`, `getPricePerPack()`
- `loadFromFirebase(uid)` — pulls latest Firestore data and writes to prefs

### `UserRepository`

Firestore CRUD for `UserModel`:
- `saveUserRecord(user)` — create
- `getUserIfExists(uid)` — read with null safety
- `updateUserDetails(user)` — update

### Calculator Utilities

| Class | Method | Formula |
|-------|--------|---------|
| `SavingsCalculator` | `calculateSavings()` | `cigarettesSkipped = durationHours / 24 × cigs_per_day`; `moneySaved = cigarettesSkipped / cigs_per_pack × price_per_pack` |
| `TimeWonBackCalculator` | `calculateTimeWonBack()` | Estimates minutes saved per cigarette not smoked |

---

## 8. State Management

QuitEase uses **GetX** exclusively.

### Reactive Pattern

```dart
// Observable variable
final RxInt totalCigarettesSkipped = 0.obs;

// Reactive widget rebuild
Obx(() => Text('${controller.totalCigarettesSkipped}'));

// Side-effect listener
ever(_appDataController.totalCigarettesSkipped, (_) => _updateAchievements());
```

### Controller Lifecycle

| Controller | Registration | When Created |
|------------|-------------|-------------|
| `AuthenticationRepository` | `Get.put` at startup | App launch |
| `AppDataController` | `Get.put` via DI | App launch, starts timer immediately |
| `AchievementController` | `Get.lazyPut(fenix: true)` | First access |
| `DashboardController` | `Get.put` in screen | On screen creation |
| `HealthController` | `Get.put` in screen | On screen creation |
| `ProgressController` | `Get.put` in screen | On screen creation |
| `SettingsController` | `Get.put` via DI | App launch |

`fenix: true` on `AchievementController` means it recreates automatically if disposed.

---

## 9. Design System

### Theme: `SereneAscentTheme`

**Font Family:** Poppins (all weights via `fontFamily: 'Poppins'`)

#### Color Palette

| Name | Enum | Hex | Usage |
|------|------|-----|-------|
| Background White | `backgroundWhite` | `#FFFFFF` | Scaffold/card background |
| Sky Blue | `skyBlue` | `#64B5F6` | Accent, `titleSmall` text |
| Deep Blue | `deepBlue` | `#1976D2` | Primary, buttons, links |
| Growth Green | `growthGreen` | `#81C784` | Tertiary |
| Light Grey Blue | `lightGreyBlue` | `#F8F9FA` | Section backgrounds |
| Charcoal Grey | `charcoalGrey` | `#2F3E46` | Body text, headings |
| Medium Grey | `mediumGrey` | `#6C757D` | Subtitles, hints |
| Warning Yellow | `warningYellow` | `#FFC107` | Warnings |
| Success Green | `successGreen` | `#28A745` | Positive states |
| Error Red | `errorRed` | `#DC3545` | Errors, destructive |

#### Typography Scale

| Style | Size | Weight | Usage |
|-------|------|--------|-------|
| `displayLarge` | 36px | Bold (700) | Large hero text |
| `headlineLarge` | 28px | SemiBold (600) | Screen titles |
| `headlineMedium` | 22px | Medium (500) | Section headers |
| `headlineSmall` | 20px | Medium (500) | Card titles |
| `titleMedium` | 18px | SemiBold (600) | AppBar, button labels |
| `titleSmall` | 16px | Medium (500) | Secondary actions |
| `bodyLarge` | 16px | Regular (400) | Main content |
| `bodyMedium` | 14px | Regular (400) | Secondary content |
| `labelSmall` | 12px | Regular (400) | Captions, metadata |

#### Component Tokens

| Token | Value |
|-------|-------|
| Button border radius | 8px |
| Card border radius | 12px |
| Input border radius | 6px |
| Button shadow alpha | 26/255 (~10%) |
| Card shadow blur | 10px, offset (0, 4) |
| Card elevation | 4.0 |

---

## 10. Firebase & Backend

### Services Used

| Service | Usage |
|---------|-------|
| **Firebase Auth** | User authentication (Google + Anonymous) |
| **Cloud Firestore** | User data storage |

### Firestore Collections

```
/Users/{userId}
  id: string
  fullName: string
  email: string
  profilePicture: string
  deviceToken: string
  createdAt: Timestamp
  updatedAt: Timestamp
  cigarettesCount: number
  smokesPerPack: number
  pricePerPack: number
  quitDate: Timestamp | null
  isOnboardingComplete: boolean
```

### Security Rules

Current rules allow read/write if `request.time < 2026-06-01`.

> ⚠️ **These rules must be tightened before production release.** Replace with user-scoped rules: `allow read, write: if request.auth != null && request.auth.uid == userId;`

### Data Sync Strategy

```
Firestore (source of truth)
    ↓ (on login)
SharedPreferences (local cache)
    ↓ (reactive)
DataPersistenceService (Rx<> layer)
    ↓
AppDataController (computed stats)
    ↓
All UI screens (Obx rebuilds)
```

---

## 11. App Navigation & Routing

### Routes (`lib/routes/app_routes.dart`)

| Route Constant | Path | Screen |
|---------------|------|--------|
| `splash` | `/` | Splash / Auth entry |
| `onboardingAuth` | `/onboarding-auth` | `AuthScreen` |
| `onboardingQuitDate` | `/onboarding-quit-date` | `QuitDateTimeScreen` |
| `onboardingHealthTracking` | `/onboarding-health-tracking` | `HealthTrackingScreen` |
| `onboardingSummary` | `/onboarding-summary` | `SummaryScreen` |
| `dashboard` | `/dashboard` | `DashboardScreen` |
| `achievements` | `/achievements` | `AchievementScreen` |
| `health` | `/health` | `HealthImprovementScreen` |
| `progress` | `/progress` | `ProgressScreen` |
| `settings` | `/settings` | `SettingsScreen` |
| `profile` | `/profile` | `ProfileScreen` |

### Navigation Flow

```
App Start
    ↓
FlutterNativeSplash → AuthWrapper
    ├── Not authenticated → AuthScreen
    │       ├── Google Sign-In  ─────────────────┐
    │       └── Anonymous Login ──────────────────┤
    │                                             ↓
    └── Authenticated ──────────────────→ isOnboardingComplete?
                                            ├── NO  → QuitDateTimeScreen
                                            │           → HealthTrackingScreen
                                            │               → SummaryScreen
                                            │                   → Dashboard
                                            └── YES → Dashboard
                                                          ├── Progress
                                                          ├── Achievements
                                                          ├── Health Improvements
                                                          └── Settings
                                                                ├── Profile
                                                                └── Notification Settings
```

---

## 12. Dependency Injection

**File:** `core/di/dependency_injection.dart`

Initialization order in `DependencyInjection.init()`:

```
1. NetworkManager
2. SharedPrefsProvider
3. SavingsCalculator
4. TimeWonBackCalculator
5. UserRepository
6. DataPersistenceService
7. AppDataController
8. NotificationService
9. NotificationScheduler
10. AuthWrapperController
11. AchievementController (lazyPut, fenix: true)
12. SettingsController
```

Screen-specific controllers (`DashboardController`, `HealthController`, `ProgressController`) are **not** registered at startup—they are created lazily when their screens are opened to avoid premature data loading before the user is authenticated.

---

*Documentation generated February 2026. App version 1.0.0+1.*
