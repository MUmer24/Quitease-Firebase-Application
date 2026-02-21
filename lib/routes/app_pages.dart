import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:quitease/features/achievements/presentation/screens/achievement_screen.dart';
import 'package:quitease/features/dashboard/presentation/screens/dashboard_screen.dart';
import 'package:quitease/features/health/presentation/screens/health_improvement_screen.dart';
import 'package:quitease/features/auth/presentation/screens/auth_screen.dart';
import 'package:quitease/features/onboarding/presentation/screens/health_tracking_screen.dart';
import 'package:quitease/features/onboarding/presentation/screens/quit_date_time_screen.dart';
import 'package:quitease/features/onboarding/presentation/screens/summary_screen.dart';
import 'package:quitease/features/progress/presentation/screens/progress_screen.dart';
import 'package:quitease/features/settings/presentation/screens/profile_screen.dart';
import 'package:quitease/features/settings/presentation/screens/settings_screen.dart';
import 'app_routes.dart';

class AppPages {
  static const initial = Routes.splash;

  static final routes = [
    GetPage(name: Routes.onboardingAuth, page: () => AuthScreen()),
    GetPage(name: Routes.onboardingQuitDate, page: () => QuitDateTimeScreen()),
    GetPage(
      name: Routes.onboardingHealthTracking,
      page: () => HealthTrackingScreen(),
    ),
    GetPage(name: Routes.onboardingSummary, page: () => SummaryScreen()),
    GetPage(
      name: Routes.dashboardViaFirebaseCurrentUser,
      page: () => DashboardScreen(user: FirebaseAuth.instance.currentUser!),
    ),
    GetPage(name: Routes.achievements, page: () => AchievementScreen()),
    GetPage(name: Routes.health, page: () => HealthImprovementScreen()),
    GetPage(name: Routes.progress, page: () => ProgressScreen()),
    GetPage(name: Routes.settings, page: () => SettingsScreen()),
    GetPage(name: Routes.profile, page: () => ProfileScreen()),
  ];
}
