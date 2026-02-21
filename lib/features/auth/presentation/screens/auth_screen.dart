import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quitease/features/auth/data/auth_wrapper/auth_wrapper_controller.dart';
import 'package:quitease/core/constants/app_constants.dart';
import 'login_screen.dart';
import 'signup_screen.dart';

class AuthScreen extends StatelessWidget {
  final AuthWrapperController controller = Get.find<AuthWrapperController>();

  AuthScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(AppConstants.welcomeImg, height: size.height * 0.2),
            Text(
              AppConstants.welcomeTxt,
              style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                fontWeight: FontWeight.bold,
                height: 1.06,
              ),
              textAlign: TextAlign.center,
            ),
            Container(
              margin: EdgeInsets.only(top: size.height * 0.05),
              width: size.width * 0.9,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 12),

                  ElevatedButton(
                    onPressed: () async {
                      // Navigate to SignUpScreen and wait for a result.
                      final result = await Get.to<bool>(
                        () => SignUpScreen(
                          onSignUpSuccess: () => Get.back(result: true),
                        ),
                      );

                      // Handle the result from SignUpScreen.
                      if (result == true) {
                        // On successful sign-up, start onboarding.
                        controller.startOnboarding();
                      } else if (result == false) {
                        // If user chose to log in, replace the current screen with LoginScreen.
                        await Get.off(
                          () => LoginScreen(
                            // Navigates back to the previous screen in the stack.
                            // See the note below about its behavior with Get.off.
                            onSignUpPressed: () =>
                                Get.off(() => SignUpScreen()),
                          ),
                        );
                      }
                    },
                    child: const Text('Sign Up'),
                  ),
                  const SizedBox(height: 12),
                  Divider(
                    color: Colors.grey,
                    thickness: 1,
                    endIndent: 30,
                    indent: 30,
                  ),
                  TextButton(
                    onPressed: controller.signInAsGuest,
                    child: Text(
                      'Continue as Guest',
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
