import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:quitease/features/dashboard/presentation/screens/dashboard_screen.dart';
import 'package:quitease/features/auth/presentation/screens/auth_screen.dart';

void onTaskCompleteAndGoToDashboard() {
  // 1. Get the currently signed-in user.
  final currentUser = FirebaseAuth.instance.currentUser;

  // 2. Check if the user exists (they always should if you're inside the app).
  if (currentUser != null) {
    // 3. Pass the user object to the DashboardScreen.
    Get.to(() => DashboardScreen(user: currentUser));
  } else {
    // This is a safety net. If for some reason the user is null,
    // it's best to send them back to the authentication screen.
    Get.offAll(() => AuthScreen());
  }
}
