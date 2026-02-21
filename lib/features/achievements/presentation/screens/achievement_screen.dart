import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quitease/features/achievements/presentation/controllers/achievement_controller.dart';
import 'package:quitease/core/constants/app_constants.dart';

class AchievementScreen extends StatelessWidget {
  // Use Get.put to create controller when screen is shown for the first time
  // This ensures it loads data AFTER user signs in, not at app startup
  final AchievementController controller = Get.put(AchievementController());

  AchievementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          AppConstants.achievementScreenAppbarTitle,
          style: Theme.of(
            context,
          ).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold),
        ),
        actions: [
          Obx(() {
            return Text(
              '${controller.completedAchievements.value}/${controller.totalAchievements.value}',
              style: Theme.of(context).textTheme.titleMedium,
            );
          }),
          const SizedBox(width: 5.0),
          Icon(Icons.emoji_events, size: 30, color: AppConstants.eventColor),
          const SizedBox(width: 5.0),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Obx(
          () => ListView.builder(
            shrinkWrap: true,
            physics: const BouncingScrollPhysics(),
            itemCount: controller.achievements.length,
            itemBuilder: (context, index) {
              final achievement = controller.achievements[index];
              return Card(
                elevation: 3.0,
                shape: RoundedRectangleBorder(
                  side: BorderSide(color: AppConstants.borderColor, width: 1.0),
                  borderRadius: BorderRadius.circular(12.0),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: size.width * 0.2,
                        height: size.width * 0.2,
                        child: Image.asset(
                          achievement.isCompleted
                              ? achievement.coloredImage
                              : achievement.grayscaleImage,
                          fit: BoxFit.contain,
                        ),
                      ),
                      SizedBox(width: size.width * 0.01),
                      Container(
                        width: size.width * 0.65,
                        margin: const EdgeInsets.only(bottom: 5.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              achievement.title,
                              style: Theme.of(context).textTheme.headlineSmall
                                  ?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: Theme.of(context).primaryColor,
                                  ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 3.0),
                            Text(
                              achievement.subtitle,
                              style: Theme.of(context).textTheme.bodyLarge
                                  ?.copyWith(fontWeight: FontWeight.bold),
                            ),
                            Text(
                              achievement.description,
                              style: Theme.of(context).textTheme.bodyMedium,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
