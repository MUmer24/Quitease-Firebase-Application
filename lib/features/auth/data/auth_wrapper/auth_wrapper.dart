import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quitease/features/dashboard/presentation/screens/dashboard_screen.dart';
import 'package:quitease/features/auth/presentation/screens/auth_screen.dart';
import 'package:quitease/features/onboarding/presentation/screens/quit_date_time_screen.dart';
import 'auth_wrapper_controller.dart';

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(AuthWrapperController());
    // Obx will automatically rebuild when controller values change
    return Obx(() {
      final user = controller.firebaseUser.value;
      final onboardingComplete = controller.isOnboardingComplete.value;
      final isDataLoading = controller.isDataLoading.value;

      // Show loading screen while data is being loaded
      if (isDataLoading) {
        return const Scaffold(body: Center(child: CircularProgressIndicator()));
      }

      // User is not signed in -> Show AuthScreen
      if (user == null) {
        return AuthScreen();
      }

      // User is signed in but hasn't completed onboarding -> Show onboarding
      if (!onboardingComplete) {
        return QuitDateTimeScreen();
      }

      // User is signed in AND onboarding is complete -> Show Dashboard
      return DashboardScreen(user: user);
    });
  }
}
