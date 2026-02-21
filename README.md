<div align="center">

# 🚭 QuitEase

### Your Smart Companion for a Smoke-Free Life

[![Flutter](https://img.shields.io/badge/Flutter-3.10%2B-02569B?logo=flutter)](https://flutter.dev)
[![Firebase](https://img.shields.io/badge/Firebase-Enabled-FFCA28?logo=firebase)](https://firebase.google.com)
[![GetX](https://img.shields.io/badge/GetX-State%20Management-9E7CE0)](https://pub.dev/packages/get)
[![License](https://img.shields.io/badge/License-MIT-green)](LICENSE)
[![Version](https://img.shields.io/badge/Version-1.0.0-blue)](pubspec.yaml)

*Track every smoke-free second. Earn achievements. Reclaim your health.*

</div>

---

## 📖 About

**QuitEase** is a beautiful Flutter app that keeps you motivated every step of your quitting journey. Enter when you quit, how much you smoked, and what cigarettes cost, and QuitEase will show you in real time exactly how many cigarettes you've avoided, how much money you've saved, how much time you've won back, and how your body is healing — all backed by World Health Organization data.

Whether you've already quit or are planning to, QuitEase is there from day one to day 730 and beyond.

---

## ✨ Features

### 🕐 Live Smoke-Free Timer
Counts up to the second from your quit time. The digital dashboard clock never stops celebrating your resolve.

### 📊 Real-Time Progress Tracking
Automatically calculated from your smoking history:

| Metric | Tracked |
|--------|---------|
| ⏱ Days / Hours smoke-free | Continuous from quit date |
| 🚬 Cigarettes avoided | Based on daily habit |
| 💰 Money saved | Based on pack price |
| ⌛ Time won back | Minutes regained per cigarette |

Progress is shown for **Today**, **This Week**, **This Month**, and **This Year**.

### 🏆 20 Achievement Badges
Two achievement tracks — cigarettes skipped and consecutive days — keep you reaching for the next milestone:

<details>
<summary>See all cigarette-based badges</summary>

| Badge | Milestone |
|-------|-----------|
| Puff Passer | 1 cigarette |
| Ash-Free Apprentice | 10 cigarettes |
| Craving Crusher | 25 cigarettes |
| Butt Breaker | 50 cigarettes |
| Nicotine Ninja | 100 cigarettes |
| Smoke-Free Streaker | 250 cigarettes |
| Habit Hacker | 500 cigarettes |
| Freedom Fighter | 1,000 cigarettes |
| Oxygen Overload | 2,500 cigarettes |
| Breathe Boss | 5,000 cigarettes |

</details>

<details>
<summary>See all days-based badges</summary>

| Badge | Milestone |
|-------|-----------|
| One Day Warrior | 1 day |
| Smoke-Free Starter | 3 days |
| Week One Wonder | 7 days |
| Lung Liberator | 14 days |
| Smoke-Free Sentinel | 30 days |
| Trigger Tamer | 60 days |
| Craving Commander | 90 days |
| Habit Hero | 6 months |
| Year of You | 1 year |
| Lifetime Legend | 2 years |

</details>

### 💪 Health Improvement Timeline (WHO-Based)
Track 10 clinically recognized health benefits as animated progress bars. Benefits show when your body will achieve each milestone based on your quit date:

- ❤️ Heart rate & blood pressure normalize
- 🫁 Carbon monoxide levels return to normal
- 👃 Taste and smell improve
- 🌬️ Coughing and shortness of breath decrease
- 💪 Immune system recovers
- 🧠 Stroke risk returns to non-smoker level
- ...and more

### 🔔 Smart Milestone Notifications
Get notified the moment you cross a milestone. QuitEase fires an instant push notification when you:
- Unlock an achievement
- Skip 10 / 25 / 50 / 100 / ... cigarettes
- Save $20 / $50 / $100 / $500 / ... in money

### 👤 Guest Mode + Account Linking
Try the app immediately without creating an account. When ready, link your anonymous session to a real Google account — **no progress is lost**.

### 📤 Share Your Journey
Share your stats and achievement card with friends, or invite them to download the app with a tap.

---

## 📱 Screenshots

> *Coming soon — run the app locally to explore the interface*

| Auth | Dashboard | Achievements | Health | Progress | Settings |
|------|-----------|--------------|--------|----------|----------|
| Sign in or continue as guest | Real-time smoke-free counter | 20 badge collection | WHO timeline | Weekly/monthly stats | Profile & notifications |

---

## 🏗 Architecture

```
lib/
├── core/           # Theme, constants, DI, Firebase config
├── features/       # Feature-first modules
│   ├── auth/         # Login, signup, auth wrapper
│   ├── onboarding/   # Quit date, smoking data, summary
│   ├── dashboard/    # Home screen + live AppDataController
│   ├── achievements/ # 20-badge achievement engine
│   ├── health/       # WHO health benefit timeline
│   ├── progress/     # Periodic statistics
│   ├── settings/     # App settings & profile
│   └── account_linking/  # Guest → Google upgrade
├── routes/         # Named routes
└── shared/         # Models, repos, services, utils
```

**State Management:** GetX (`Rx<T>` + `Obx`) — fully reactive, no `setState`  
**Navigation:** `Get.to` / `Get.offAll`  
**Architecture Pattern:** Feature-first Clean Architecture

For a deep dive, see [docs/DOCUMENTATION.md](docs/DOCUMENTATION.md).

---

## 🛠 Tech Stack

| Layer | Technology |
|-------|-----------|
| Framework | Flutter 3.10+ |
| State Management | GetX 4.6+ |
| Authentication | Firebase Auth (Google OAuth + Anonymous) |
| Database | Cloud Firestore + SharedPreferences |
| Notifications | flutter_local_notifications |
| UI Components | Poppins font, Iconsax, FontAwesome, Lottie |
| Connectivity | connectivity_plus |
| Sharing | share_plus |

---

## 🚀 Getting Started

### Prerequisites

- Flutter SDK `^3.10.8` — [Install Flutter](https://docs.flutter.dev/get-started/install)
- Dart SDK included with Flutter
- Android SDK (min API 21)
- A Firebase project with Android app registered
- Google Sign-In credentials configured in Firebase Console

### Setup

1. **Clone the repository**
   ```bash
   git clone https://github.com/MUmer24/Quitease-Firebase-Application.git
   cd Quitease-Firebase-Application
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Set up your Firebase project**

   > `google-services.json` and `firebase_options.dart` are **not committed** to this repo (they contain real API keys). You need to connect your own Firebase project.

   - Create a project at [console.firebase.google.com](https://console.firebase.google.com)
   - Enable **Authentication** → Google provider and Anonymous
   - Enable **Cloud Firestore** and deploy the included [`firestore.rules`](firestore.rules)
   - Download `google-services.json` → place it at `android/app/google-services.json`
   - Install the FlutterFire CLI and regenerate the Dart config:
     ```bash
     dart pub global activate flutterfire_cli
     flutterfire configure
     ```
     This creates `lib/core/config/firebase_options.dart` automatically.

4. **Set up environment variables**
   ```bash
   cp .env.example .env
   ```
   Open `.env` and fill in your Firebase keys and Google OAuth `serverClientId`.  
   See [`.env.example`](.env.example) for all required variables and where to find them.

5. **Run the app**
   ```bash
   flutter run
   ```


### Building for Release

```bash
# Android APK
flutter build apk --release

# Android App Bundle (for Play Store)
flutter build appbundle --release
```

---

## 🔥 Firebase Configuration

The app uses:

| Firebase Service | Usage |
|-----------------|-------|
| **Authentication** | Email, Google Sign-In, Anonymous |
| **Cloud Firestore** | User data storage and sync |

**Firestore Collection:** `/Users/{userId}`

```json
{
  "id": "string",
  "fullName": "string",
  "email": "string",
  "profilePicture": "string (URL)",
  "cigarettesCount": 20,
  "smokesPerPack": 20,
  "pricePerPack": 8.5,
  "quitDate": "Timestamp",
  "isOnboardingComplete": true,
  "createdAt": "Timestamp",
  "updatedAt": "Timestamp"
}
```

> ⚠️ **Security Notice:** Update `firestore.rules` before any public deployment. The default rules expire June 2026 and should be replaced with user-scoped rules.

---

## 📋 Onboarding Flow

```
Sign In / Guest Mode
       ↓
 Pick your quit date & time
       ↓
 Enter smoking data (cigs/day, pack size, pack price)
       ↓
 Review your summary
       ↓
      Dashboard 🎉
```

If you haven't quit yet, you can select a future date — QuitEase will countdown to your quit time.

---

## 📁 Project Documentation

| File | Description |
|------|-------------|
| [`docs/DOCUMENTATION.md`](docs/DOCUMENTATION.md) | Full internal technical documentation |
| [`pubspec.yaml`](pubspec.yaml) | Dependencies and assets |
| [`firestore.rules`](firestore.rules) | Database security rules |
| [`flutter_launcher_icons.yaml`](flutter_launcher_icons.yaml) | App icon config |
| [`splash.yaml`](splash.yaml) | Native splash screen config |

---

## 🤝 Contributing

Contributions are welcome! Here's how:

1. Fork the repository
2. Create a feature branch: `git checkout -b feature/amazing-feature`
3. Commit your changes: `git commit -m 'Add amazing feature'`
4. Push to the branch: `git push origin feature/amazing-feature`
5. Open a Pull Request

Please follow the existing code style and GetX patterns.

---

## 📄 License

This project is licensed under the MIT License — see the [LICENSE](LICENSE) file for details.

---

## 👨‍💻 Author

**Muhammad Umer Khan**  
GitHub: [@MUmer24](https://github.com/MUmer24)

---

<div align="center">

*Stop smoking. Start living. QuitEase — every second counts.* 🚭

⭐ **Star this repo if QuitEase helped you or someone you love!** ⭐

</div>
