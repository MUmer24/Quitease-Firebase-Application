import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quitease/core/constants/app_constants.dart';
import 'package:quitease/features/auth/data/auth_wrapper/auth_wrapper_controller.dart';
import 'package:quitease/features/settings/presentation/screens/profile_screen.dart';
import 'package:quitease/features/settings/presentation/screens/notification_settings_screen.dart';
import 'package:share_plus/share_plus.dart';
import 'package:quitease/features/settings/presentation/controllers/settings_controller.dart';

class SettingsScreen extends StatelessWidget {
  final AuthWrapperController authController =
      Get.find<AuthWrapperController>();
  final SettingsController settingsController = Get.put(SettingsController());

  SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Stack(
          children: [
            Container(
              height: MediaQuery.of(context).size.height * 0.3,
              width: double.infinity,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: AlignmentGeometry.topCenter,
                  end: AlignmentGeometry.bottomCenter,
                  colors: [Colors.blue.shade800, Colors.blue.shade400],
                ),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(35),
                  bottomRight: Radius.circular(35),
                ),
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 60,
                  width: double.infinity,
                  margin: EdgeInsets.only(top: 20, bottom: 10),
                  child: Stack(
                    children: [
                      Positioned(
                        left: 10,
                        top: 10,

                        child: IconButton(
                          icon: const Icon(
                            Icons.arrow_back,
                            color: Colors.white,
                            size: 30,
                          ),
                          onPressed: () => Get.back(),
                        ),
                      ),
                      Positioned.fill(
                        child: Center(
                          child: const Text(
                            'Settings',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // User Profile Card
                _buildUserProfileCard(),

                const SizedBox(height: 16),

                // Account Section
                _buildSectionHeader('ACCOUNT', context),

                _buildSettingsCard([
                  _buildSettingsTile(
                    icon: Icons.person_outline,
                    iconColor: Colors.blue,
                    iconBgColor: Colors.blue[50]!,
                    title: 'Profile',
                    subtitle: 'Manage your profile information',
                    onTap: () => Get.to(() => ProfileScreen()),
                  ),
                  Divider(height: 2, color: Colors.grey.withAlpha(50)),
                  _buildEmailTile(),
                ]),

                const SizedBox(height: 16),

                // App Settings Section
                _buildSectionHeader('APP PREFERENCES', context),
                _buildSettingsCard([
                  _buildSettingsTile(
                    icon: Icons.notifications_outlined,
                    iconColor: Colors.blue,
                    iconBgColor: Colors.blue[50]!,
                    title: 'Notifications',
                    subtitle: 'Manage notification preferences',
                    onTap: () =>
                        Get.to(() => const NotificationSettingsScreen()),
                  ),
                  Divider(height: 2, color: Colors.grey.withAlpha(50)),
                  _buildSettingsTile(
                    icon: Icons.share,
                    iconColor: Colors.blue,
                    iconBgColor: Colors.blue[50]!,
                    title: 'Share App',
                    subtitle: 'Share our app with your friends',
                    onTap: () async {
                      try {
                        await Share.share(
                          AppConstants.shareAppDescription,
                          subject: 'Try QuitEase - Quit Smoking App',
                        );
                      } catch (e) {
                        debugPrint('❌ Share failed: $e');
                        // Share cancelled or failed - this is normal, no need to show error
                      }
                    },
                  ),
                  Divider(height: 2, color: Colors.grey.withAlpha(50)),
                  _buildSettingsTile(
                    icon: Icons.info_outline,
                    iconColor: Colors.blue,
                    iconBgColor: Colors.blue[50]!,
                    title: 'About App',
                    subtitle: 'Version 1.0.0',
                    onTap: () => _showAboutDialog(context),
                  ),
                ]),

                const SizedBox(height: 16),

                // Support Section
                _buildSectionHeader('SUPPORT', context),

                // Logout Button
                Obx(
                  () => Container(
                    margin: const EdgeInsets.symmetric(horizontal: 16),
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: authController.isLoading.value
                          ? null
                          : () => authController.logout(),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 0,
                      ),
                      child: authController.isLoading.value
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.logout, size: 20),
                                const SizedBox(width: 8),
                                Text(
                                  'Logout',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                    ),
                  ),
                ),

                const SizedBox(height: 24),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUserProfileCard() {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(24),
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withAlpha(50),
            spreadRadius: 1,
            blurRadius: 7,
            offset: const Offset(0, 2), // changes position of shadow
          ),
        ],
      ),
      child: Obx(() {
        final email = settingsController.userEmail;
        final profilePicture = settingsController.userProfilePicture;

        // Apply the guest account email display rule
        final displayEmail = email == 'user@example.com' || email == 'None'
            ? 'No Email'
            : email;

        return Column(
          children: [
            // Profile Picture
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color.fromARGB(255, 219, 234, 255),
              ),

              child: profilePicture.isNotEmpty
                  ? ClipOval(
                      child: CachedNetworkImage(
                        imageUrl: profilePicture,
                        width: 80,
                        height: 80,
                        fit: BoxFit.cover,
                        memCacheWidth: 80,
                        memCacheHeight: 80,
                        placeholder: (context, url) => Container(
                          color: const Color.fromARGB(255, 219, 234, 255),
                          child: const Icon(
                            Icons.person,
                            size: 40,
                            color: Colors.blue,
                          ),
                        ),
                        errorWidget: (context, url, error) => Container(
                          color: const Color.fromARGB(255, 219, 234, 255),
                          child: const Icon(
                            Icons.person,
                            size: 40,
                            color: Colors.blue,
                          ),
                        ),
                      ),
                    )
                  : Icon(Icons.person, size: 40, color: Colors.blue[700]),
            ),
            const SizedBox(height: 16),
            Text(
              settingsController.username.value,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              displayEmail,
              style: TextStyle(fontSize: 14, color: Colors.grey[600]),
            ),
          ],
        );
      }),
    );
  }

  Widget _buildEmailTile() {
    return Obx(() {
      final email = settingsController.userEmail;
      final emailSubtitle = email == 'user@example.com' || email == 'None'
          ? 'No Email'
          : email;

      return _buildSettingsTile(
        icon: Icons.email_outlined,
        iconColor: Colors.blue,
        iconBgColor: Colors.blue[50]!,
        title: 'Email',
        subtitle: emailSubtitle,
        onTap: null,
        showArrow: false,
      );
    });
  }

  Widget _buildSectionHeader(String title, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
      child: Text(
        title,
        style: TextStyle(
          fontSize: Theme.of(context).textTheme.bodyMedium!.fontSize,
          fontWeight: FontWeight.bold,
          color: Colors.grey[600],
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  Widget _buildSettingsCard(List<Widget> children) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withAlpha(50),
            spreadRadius: 1,
            blurRadius: 7,
            offset: const Offset(0, 2), // changes position of shadow
          ),
        ],
      ),

      child: Column(children: children),
    );
  }

  Widget _buildSettingsTile({
    required IconData icon,
    required Color iconColor,
    Color? iconBgColor,
    required String title,
    required String subtitle,
    required VoidCallback? onTap,
    bool showArrow = true,
  }) {
    return ListTile(
      leading: SizedBox(
        width: 40,
        height: 40,
        child: Icon(icon, color: iconColor, size: 22),
      ),
      title: Text(
        title,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: Colors.black87,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: TextStyle(fontSize: 13, color: Colors.grey[600]),
      ),
      trailing: showArrow && onTap != null
          ? Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey[500])
          : null,
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    );
  }

  void _showAboutDialog(BuildContext context) {
    Get.dialog(
      AlertDialog(
        title: const Text('About QuitEase'),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('QuitEase - Your journey to a smoke-free life'),
            SizedBox(height: 16),
            Text('Version: 1.0.0'),
            SizedBox(height: 8),
            Text('Build: 2026.1.0'),
            SizedBox(height: 16),
            Text('© 2026 QuitEase. All rights reserved.'),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text('OK')),
        ],
      ),
    );
  }
}
