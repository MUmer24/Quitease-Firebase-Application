import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quitease/shared/services/storage/shared_prefs_provider.dart';
import 'package:quitease/features/achievements/presentation/controllers/achievement_controller.dart';
import 'package:quitease/features/dashboard/presentation/controllers/dashboard_controller.dart';
import 'package:quitease/features/account_linking/presentation/controllers/account_linking_controller.dart';
import 'package:quitease/core/constants/app_constants.dart';
import 'package:quitease/shared/widgets/digital_clock.dart';
import 'package:share_plus/share_plus.dart';

class DashboardScreen extends StatelessWidget {
  // Use Get.put to create the controllers when the screen is shown for the first time
  // This ensures they only initialize after login, not at app startup
  final DashboardController controller = Get.put(DashboardController());
  final AchievementController achievementController = Get.put(
    AchievementController(),
  );
  final AccountLinkingController linkingController = Get.put(
    AccountLinkingController(),
  );
  final SharedPrefsProvider prefsProvider = Get.find();

  final User user;

  DashboardScreen({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: Text(
          AppConstants.dashboardScreenAppbarTitle,
          style: Theme.of(context).textTheme.titleMedium,
          textAlign: TextAlign.start,
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.share, size: 20),
            onPressed: () async {
              await Share.share(
                AppConstants.shareAppDescription,
                subject: 'Try QuitEase - Quit Smoking App',
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.settings, size: 20),
            onPressed: controller.navigateToSettings,
          ),
        ],
        elevation: 0,
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }
        return SingleChildScrollView(
          child: Column(
            children: [
              // Guest Account Link Banner
              Obx(() {
                if (!linkingController.isGuestAccount.value) {
                  return const SizedBox.shrink();
                }
                return Container(
                  margin: const EdgeInsets.fromLTRB(8, 8, 8, 0),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.blue[400]!, Colors.blue[600]!],
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.cloud_upload,
                        color: Colors.white,
                        size: 20,
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Save Your Progress',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              'Link your account to never lose your data',
                              style: TextStyle(
                                color: Colors.white.withValues(alpha: 0.9),
                                fontSize: 11,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Obx(
                        () => TextButton(
                          onPressed: linkingController.isLinking.value
                              ? null
                              : () => linkingController.linkWithGoogle(),
                          style: TextButton.styleFrom(
                            backgroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            minimumSize: const Size(60, 30),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(6),
                            ),
                          ),
                          child: linkingController.isLinking.value
                              ? const SizedBox(
                                  width: 16,
                                  height: 16,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: Colors.blue,
                                  ),
                                )
                              : Text(
                                  'Link Now',
                                  style: TextStyle(
                                    color: Colors.blue[700],
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                        ),
                      ),
                    ],
                  ),
                );
              }),

              _buildTimerSection(context),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildProgressSection(context),
                    const SizedBox(height: 12),
                    _buildAchievementsSection(context),
                    const SizedBox(height: 12),
                    _buildHealthImprovements(context),
                  ],
                ),
              ),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildTimerSection(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return SizedBox(
      width: size.width,
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.center,
        children: [
          Image.asset(
            AppConstants.timerSectionBgImg,
            width: size.width,
            height: size.height * 0.25,
            fit: BoxFit.cover,
          ),
          Positioned(
            top: size.height * 0.02,
            child: Image.asset(
              AppConstants.stopwatchImg,
              width: 100,
              height: 120,
            ),
          ),
          Positioned(
            bottom: 10,
            left: 0,
            right: 0,
            child: DigitalClockWidget(controller: controller, showDate: false),
          ),
        ],
      ),
    );
  }

  Widget _buildProgressSection(BuildContext context) {
    return Card(
      elevation: 2,
      child: InkWell(
        onTap: controller.navigateToProgress,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    AppConstants.overallProgressSectionTitle,
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    AppConstants.seeAllBtn,
                    style: Theme.of(
                      context,
                    ).textTheme.bodyMedium?.copyWith(color: Colors.blue),
                  ),
                ],
              ),
              const SizedBox(height: 5),
              Obx(() {
                final quit = controller.quitDate;
                var d = quit == null
                    ? Duration.zero
                    : DateTime.now().difference(quit);

                if (d.inHours < 0) {
                  d = Duration.zero;
                }
                final label = d.inHours <= 24
                    ? '${d.inHours} hours quit'
                    : '${d.inDays} days quit';
                return GridView.count(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisCount: 2,
                  childAspectRatio: 2,
                  crossAxisSpacing: 2,
                  mainAxisSpacing: 2,
                  children: [
                    _buildStatCard(
                      context,
                      text: label,
                      icon: AppConstants.stopwatchIcon,
                      trailingIconColor: AppConstants.stopwatchIconColor,
                    ),
                    _buildStatCard(
                      context,
                      text:
                          '${controller.totalCigarettesSkipped} cigarettes avoided',
                      icon: AppConstants.cigsIcon,
                      trailingIconColor: AppConstants.cigsIconColor,
                    ),
                    _buildStatCard(
                      context,
                      text: '\$ ${controller.moneySaved} saved',
                      imgLocation: AppConstants.coinImg,
                    ),
                    _buildStatCard(
                      context,
                      text: controller.timeWonBack,
                      imgLocation: AppConstants.chronometerImg,
                    ),
                  ],
                );
              }),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatCard(
    BuildContext context, {
    required String text,
    String? imgLocation,
    IconData? icon,
    Color? trailingIconColor,
  }) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(
        side: const BorderSide(
          color: Color.fromARGB(163, 162, 173, 182),
          width: 1.0,
        ),
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            if (icon != null)
              Icon(icon, color: trailingIconColor, size: 32)
            else if (imgLocation != null)
              Image.asset(imgLocation, width: 32, height: 32)
            else
              const Icon(Icons.help_outline, size: 32),
            const SizedBox(width: 8),
            Expanded(
              child: Text(text, style: Theme.of(context).textTheme.bodyLarge),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAchievementsSection(BuildContext context) {
    return Card(
      elevation: 2,
      child: InkWell(
        onTap: controller.navigateToAchievements,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    AppConstants.achievementSectionTitle,
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    AppConstants.seeAllBtn,
                    style: Theme.of(
                      context,
                    ).textTheme.bodyMedium?.copyWith(color: Colors.blue),
                  ),
                ],
              ),
              const SizedBox(height: 5),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.25,
                child: Obx(() {
                  final recentAchievements =
                      achievementController.dashboardAchievements;
                  // Show a message if no achievements are unlocked yet
                  if (recentAchievements.isEmpty) {
                    return Center(
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Text(
                          "Keep going to unlock your first achievement! 💪",
                        ),
                      ),
                    );
                  }
                  return ListView.separated(
                    scrollDirection: Axis.horizontal,
                    // Use the new preview list's length, which will be 5
                    itemCount: recentAchievements.length,
                    separatorBuilder: (context, index) =>
                        const SizedBox(width: 3),
                    itemBuilder: (context, index) {
                      // Get the achievement from the preview list
                      final achievement = recentAchievements[index];
                      return _buildAchievementItem(context, achievement);
                    },
                  );
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAchievementItem(BuildContext context, dynamic achievement) {
    final size = MediaQuery.of(context).size;
    return SizedBox(
      width: size.width * 0.4,
      child: InkWell(
        onTap: controller.navigateToAchievements,
        child: Card(
          shape: RoundedRectangleBorder(
            side: const BorderSide(
              color: Color.fromARGB(163, 162, 173, 182),
              width: 1.0,
            ),
            borderRadius: BorderRadius.circular(12.0),
          ),
          elevation: 3,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Image.asset(
                    achievement.isCompleted
                        ? achievement.coloredImage
                        : achievement.grayscaleImage,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(height: 5),
                SizedBox(
                  height: 50,
                  child: Center(
                    child: Column(
                      children: [
                        Text(
                          achievement.title,
                          style: Theme.of(context).textTheme.bodyLarge
                              ?.copyWith(fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          achievement.subtitle,
                          style: Theme.of(context).textTheme.bodySmall,
                          textAlign: TextAlign.center,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHealthImprovements(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return SizedBox(
      width: double.infinity,
      child: Card(
        elevation: 2,
        child: InkWell(
          onTap: controller.navigateToHealth,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      AppConstants.vitalitySectionTitle,
                      style: Theme.of(context).textTheme.headlineSmall
                          ?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    Text(
                      AppConstants.seeAllBtn,
                      style: Theme.of(
                        context,
                      ).textTheme.bodyMedium?.copyWith(color: Colors.blue),
                    ),
                  ],
                ),
                const SizedBox(height: 5),
                Row(
                  children: [
                    Image.asset(
                      AppConstants.vitalityBoostImg,
                      width: size.width * 0.1,
                    ),
                    const SizedBox(width: 8),
                    SizedBox(
                      width: size.width * 0.7,
                      child: Text(
                        AppConstants.vitalitySectionSubtitle,
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
