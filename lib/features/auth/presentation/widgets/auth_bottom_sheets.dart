import 'package:flutter/material.dart';

class AuthBottomSheets {
  static Future<void> showSignUpSheet(
    BuildContext context, {
    required void Function(String, String, String) onSignUp,
  }) async {
    final formKey = GlobalKey<FormState>();
    final TextEditingController emailController = TextEditingController();
    final TextEditingController passwordController = TextEditingController();
    final TextEditingController usernameController = TextEditingController();

    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder:
          (context) => Padding(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
              left: 24,
              right: 24,
              top: 24,
            ),
            child: Form(
              key: formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Sign Up',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: usernameController,
                    decoration: const InputDecoration(labelText: 'Username'),
                    validator:
                        (value) =>
                            value == null || value.isEmpty
                                ? 'Enter username'
                                : null,
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: emailController,
                    decoration: const InputDecoration(labelText: 'Email'),
                    validator:
                        (value) =>
                            value == null || value.isEmpty
                                ? 'Enter email'
                                : null,
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: passwordController,
                    decoration: const InputDecoration(labelText: 'Password'),
                    obscureText: true,
                    validator:
                        (value) =>
                            value == null || value.length < 6
                                ? 'Password too short'
                                : null,
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: () {
                      if (formKey.currentState!.validate()) {
                        onSignUp(
                          usernameController.text.trim(),
                          emailController.text.trim(),
                          passwordController.text.trim(),
                        );
                        Navigator.of(context).pop();
                      }
                    },
                    child: const Text('Create Account'),
                  ),
                  const SizedBox(height: 12),
                ],
              ),
            ),
          ),
    );
  }

  static Future<void> showLoginSheet(
    BuildContext context, {
    required void Function(String, String) onLogin,
  }) async {
    final formKey = GlobalKey<FormState>();
    final TextEditingController emailController = TextEditingController();
    final TextEditingController passwordController = TextEditingController();

    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder:
          (context) => Padding(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
              left: 24,
              right: 24,
              top: 24,
            ),
            child: Form(
              key: formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Login',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: emailController,
                    decoration: const InputDecoration(labelText: 'Email'),
                    validator:
                        (value) =>
                            value == null || value.isEmpty
                                ? 'Enter email'
                                : null,
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: passwordController,
                    decoration: const InputDecoration(labelText: 'Password'),
                    obscureText: true,
                    validator:
                        (value) =>
                            value == null || value.isEmpty
                                ? 'Enter password'
                                : null,
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: () {
                      if (formKey.currentState!.validate()) {
                        onLogin(
                          emailController.text.trim(),
                          passwordController.text.trim(),
                        );
                        Navigator.of(context).pop();
                      }
                    },
                    child: const Text('Login'),
                  ),
                  const SizedBox(height: 12),
                ],
              ),
            ),
          ),
    );
  }
}
