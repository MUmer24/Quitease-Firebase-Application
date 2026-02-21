import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'auth_screen.dart';
import '../../../../../core/theme/app_theme.dart';
import '../../../../shared/utils/enums.dart';
import '../controllers/login_controller.dart';

class LoginScreen extends StatelessWidget {
  final VoidCallback? onSignUpPressed;
  final VoidCallback? onLoginSuccess;
  final LoginController controller;

  LoginScreen({
    super.key,
    this.onSignUpPressed,
    this.onLoginSuccess,
    LoginController? loginController,
  }) : controller = loginController ?? Get.put(LoginController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Get.offAll(() => AuthScreen()),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: controller.formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 32),
              Text(
                'Welcome Back',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                'Sign in to continue',
                style: Theme.of(
                  context,
                ).textTheme.bodyLarge?.copyWith(color: Colors.grey[600]),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 48),
              TextFormField(
                controller: controller.emailController,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  prefixIcon: Icon(Icons.email_outlined),
                ),
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your email';
                  }
                  if (!GetUtils.isEmail(value)) {
                    return 'Please enter a valid email';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: controller.passwordController,
                decoration: const InputDecoration(
                  labelText: 'Password',
                  prefixIcon: Icon(Icons.lock_outline),
                ),
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your password';
                  }
                  if (value.length < 6) {
                    return 'Password must be at least 6 characters';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),
              Obx(
                () => ElevatedButton(
                  // Disable button when loading
                  onPressed: controller.isLoading.value
                      ? null
                      : () {
                          controller.login();
                        },
                  child: controller.isLoading.value
                      ? const CircularProgressIndicator()
                      : const Text('Login'),
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'OR Continue With',
                style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                  color: SereneAscentTheme.getColor(
                    SereneAscentPaletteColor.deepBlue,
                  ),
                ),
                textAlign: TextAlign.center,
              ),
              Divider(
                color: Colors.grey,
                thickness: 1,
                endIndent: 30,
                indent: 30,
              ),
              const SizedBox(height: 11),
              TextButton(
                onPressed: onSignUpPressed,
                child: const Text("Don't have an account? Sign Up"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
