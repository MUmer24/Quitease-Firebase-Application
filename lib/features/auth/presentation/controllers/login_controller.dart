import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quitease/shared/utils/popups/loaders.dart';

class LoginController extends GetxController {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  final isLoading = false.obs;

  Future<void> login() async {
    try {
      if (!formKey.currentState!.validate()) return;

      // Start loading
      isLoading.value = true;
    } catch (e) {
      TLoaders.errorSnackBar(title: 'Login Failed', message: e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}
