import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quitease/shared/repositories/auth/authentication_repository.dart';
import 'package:quitease/features/auth/presentation/screens/auth_screen.dart';
import 'package:quitease/features/auth/presentation/widgets/social_signin_button.dart';
import '../controllers/signup_controller.dart';

class SignUpScreen extends StatelessWidget {
  final VoidCallback? onSignUpSuccess;
  final SignUpController controller;

  SignUpScreen({
    super.key,
    this.onSignUpSuccess,
    SignUpController? signUpController,
  }) : controller = signUpController ?? Get.put(SignUpController());
  final _authRepo = AuthenticationRepository.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 12.0),
              child: Align(
                alignment: Alignment.topLeft,
                child: IconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed: () {
                    Get.offAll(() => AuthScreen());
                  },
                ),
              ),
            ),

            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'Welcome Back',
                      style: Theme.of(context).textTheme.headlineLarge,
                    ),
                    const SizedBox(height: 8),

                    Text(
                      'Sign in to your account',
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    const SizedBox(height: 48),

                    ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 240),
                      child: Column(
                        children: [
                          SocialSignInButton(
                            imageString: 'assets/logo/google-logo.png',
                            text: 'Sign in with Google',
                            color: Colors.grey,
                            onPressed: () {
                              _authRepo.signInWithGoogle();
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        // ),
      ),
    );
  }
}
