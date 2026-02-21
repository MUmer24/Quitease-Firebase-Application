import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:quitease/features/auth/data/auth_wrapper/auth_wrapper_controller.dart';
import 'package:quitease/features/settings/presentation/controllers/profile_controller.dart';
import 'package:quitease/features/settings/services/share_service.dart';
import 'package:quitease/core/constants/app_constants.dart';

class ProfileScreen extends StatelessWidget {
  final ProfileController controller = Get.put(ProfileController());

  ProfileScreen({super.key});
  final GlobalKey cardKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: Text(
          AppConstants.profileScreenAppbarTitle,
          style: Theme.of(context).textTheme.titleMedium,
        ),
        backgroundColor: Colors.grey[100],
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Get.back(),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildUserProfileHeader(context),
              const SizedBox(height: 20),
              _buildDetailedStats(context),
              const SizedBox(height: 20),
              _buildAccountInfoCard(context),
              const SizedBox(height: 20),
              _buildActionsCard(context),
              const SizedBox(height: 20),
              _buildLogoutButton(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildUserProfileHeader(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 20.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Obx(() {
        return Row(
          children: [
            // Profile Picture
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.blue[400],
              ),
              child: controller.profilePicture.value.isNotEmpty
                  ? ClipOval(
                      child: CachedNetworkImage(
                        imageUrl: controller.profilePicture.value,
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
                            size: 30,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    )
                  : Icon(Icons.person, size: 30, color: Colors.white),
            ),
            const SizedBox(width: 16),
            // User Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    controller.username.value,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    // Apply the guest account email display rule
                    controller.email.value == 'user@example.com'
                        ? 'EmailAddress'
                        : controller.email.value,
                    style: Theme.of(
                      context,
                    ).textTheme.bodyMedium?.copyWith(color: Colors.grey[600]),
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        );
      }),
    );
  }

  Widget _buildAccountInfoCard(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Account Information',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 16),
          Obx(() {
            return Column(
              children: [
                _buildInfoRow(
                  // context,
                  'Email Verified',
                  controller.isEmailVerified.value ? 'Yes' : 'No',
                  valueColor: controller.isEmailVerified.value
                      ? Colors.green
                      : Colors.red,
                ),
                const SizedBox(height: 11),
                Obx(() {
                  final createdDate = controller.accountCreatedAt.value;
                  final formattedDate = createdDate != null
                      ? DateFormat('d/M/yyyy').format(createdDate)
                      : 'N/A';
                  return _buildInfoRow('Account Created', formattedDate);
                }),
                const SizedBox(height: 11),
                Obx(() {
                  final lastSignIn = controller.lastSignInAt.value;
                  final formattedDate = lastSignIn != null
                      ? DateFormat('d/M/yyyy').format(lastSignIn)
                      : 'N/A';
                  return _buildInfoRow('Last Sign In', formattedDate);
                }),
              ],
            );
          }),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value, {Color? valueColor}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: TextStyle(fontSize: 14, color: Colors.grey[600])),
        Text(
          value,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: valueColor ?? Colors.black87,
          ),
        ),
      ],
    );
  }

  Widget _buildDetailedStats(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            AppConstants.detailStatCardTitle,
            style: Theme.of(
              context,
            ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),

          // Quit Date Card
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.blue.shade50,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.calendar_today,
                  color: Colors.blue.shade400,
                  size: 24,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Quit Date',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Colors.grey[600],
                        ),
                      ),
                      const SizedBox(height: 4),
                      Obx(() {
                        final quitDate = controller.quitDate;
                        final formattedDate = quitDate != null
                            ? DateFormat('MMMM d, yyyy').format(quitDate)
                            : 'Not set';
                        return Text(
                          formattedDate,
                          style: Theme.of(context).textTheme.titleMedium
                              ?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                        );
                      }),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          Obx(
            () => GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              childAspectRatio: 1.7,
              mainAxisSpacing: 8,
              crossAxisSpacing: 8,
              children: [
                _buildStatCard(
                  context,
                  icon: AppConstants.statCardIcon1,
                  label: AppConstants.statCardLabel1,
                  value: controller.cigarettesSkipped.toString(),
                  color: AppConstants.statCardIconColor1,
                ),
                _buildStatCard(
                  context,
                  icon: AppConstants.statCardIcon2,
                  label: AppConstants.statCardLabel2,
                  value: controller.moneySaved,
                  color: AppConstants.statCardIconColor2,
                ),
                _buildStatCard(
                  context,
                  icon: AppConstants.statCardIcon3,
                  label: AppConstants.statCardLabel3,
                  value: controller.timeWonBack,

                  color: AppConstants.statCardIconColor3,
                ),
                _buildStatCard(
                  context,
                  icon: AppConstants.statCardIcon4,
                  label: AppConstants.statCardLabel4,
                  value:
                      '${controller.completedAchievements.value} / ${controller.totalAchievements.value}',
                  color: AppConstants.statCardIconColor4,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(
    BuildContext context, {
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
      ),

      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: color, size: 32),
              const SizedBox(width: 5),
              Expanded(
                child: Text(
                  value,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),

          Expanded(
            child: Text(
              label,
              style: Theme.of(
                context,
              ).textTheme.bodySmall?.copyWith(color: Colors.grey[600]),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionsCard(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Quick Actions',
            style: Theme.of(
              context,
            ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          _buildActionButton(
            context: context,
            // AppConstants.shareProgressBtn,
            title: 'Share Progress',
            subtitle: 'Share your quit smoking journey',
            icon: Icons.share,
            iconColor: Colors.blue,
            iconBgColor: Colors.blue[50]!,
            onPressed: () => _showShareOptions(context),
          ),
          const SizedBox(height: 12),
          _buildActionButton(
            context: context,
            // AppConstants.resetDataBtn,
            title: 'Reset Progress',
            subtitle: 'Start your quit journey over',
            icon: AppConstants.resetDataIcon,
            iconColor: Colors.orange,
            iconBgColor: Colors.orange[50]!,
            onPressed: () => controller.resetProgress(context),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton({
    required BuildContext context,
    required String title,
    required String subtitle,
    required IconData icon,
    required Color iconColor,
    required Color iconBgColor,
    required VoidCallback onPressed,
  }) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: iconBgColor,
        elevation: 0,
        padding: const EdgeInsets.all(16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      child: Row(
        children: [
          Icon(icon, color: iconColor),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: iconColor,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                ),
              ],
            ),
          ),
          Icon(Icons.arrow_forward_ios, color: iconColor, size: 16),
        ],
      ),
    );
  }

  void _showShareOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Share Your Progress',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              ListTile(
                leading: const Icon(Icons.image, color: Colors.blue),
                title: const Text('Share as Image'),
                onTap: () {
                  Get.back();
                  ShareService.captureAndShareProfileCard(context);
                },
              ),
              ListTile(
                leading: const Icon(Icons.text_snippet, color: Colors.green),
                title: const Text('Share as Text'),
                onTap: () {
                  Get.back();
                  controller.shareProgress();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildLogoutButton(BuildContext context) {
    final AuthWrapperController authController =
        Get.find<AuthWrapperController>();

    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () => authController.logout(),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.red,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 0,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.logout, size: 20),
            const SizedBox(width: 8),
            Text(
              'Logout',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
