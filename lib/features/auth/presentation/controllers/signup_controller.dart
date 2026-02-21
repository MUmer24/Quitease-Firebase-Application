import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quitease/shared/repositories/auth/authentication_repository.dart';
import 'package:quitease/shared/utils/network_manager.dart';
import 'package:quitease/shared/utils/popups/loaders.dart';

class SignUpController extends GetxController {
  final _authService = AuthenticationRepository.instance;
  final emailController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  final isLoading = false.obs;

  Future<void> signIn() async {
    // --- Pre-checks (these happen before the try block) ---

    // Network Validation
    final isConnected = await NetworkManager.instance.isConnected();
    if (!isConnected) {
      TLoaders.errorSnackBar(title: 'Error', message: 'No internet connection');
      return;
    }

    //  GATEKEEPER: Validate the form data
    // if (!formKey.currentState!.validate())
    // return; // Stop execution if the form is not valid

    // --- Main Logic with Error Handling ---
    try {
      // If validation passes, show loading and proceed
      isLoading.value = true;

      // The controller's ONLY job is now to call the repository to send the link.
      _authService.signInWithGoogle();

      // Show a message telling the user to check their email
      TLoaders.successSnackBar(
        title: 'Link Sent!',
        message: 'Please check your email to continue.',
      );
    } catch (e) {
      // rethrow;
      TLoaders.errorSnackBar(title: 'Oh Snap!', message: e.toString());
    } finally {
      // Stop the loading indicator
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    emailController.dispose();
    super.onClose();
  }
}
