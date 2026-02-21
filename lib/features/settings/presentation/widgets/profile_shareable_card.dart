import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:quitease/features/settings/presentation/controllers/profile_controller.dart';
import 'package:quitease/core/constants/app_constants.dart';

class ProfileShareableCard extends StatelessWidget {
  final ProfileController controller;

  const ProfileShareableCard({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 10,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16),
        child: Container(
          width: 400,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            children: [
              // Header section with title
              Padding(
                padding: const EdgeInsets.only(top: 11),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.smoking_rooms,
                      color: Colors.red.shade700,
                      size: 30,
                    ),
                    const SizedBox(width: 10),
                    const Text(
                      'My Quit Journey',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),

              // Quit Date Card
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 30,
                  vertical: 22,
                ),
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
                            style: Theme.of(context).textTheme.bodySmall
                                ?.copyWith(color: Colors.grey[600]),
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

              const SizedBox(height: 8),

              Obx(
                () => GridView.count(
                  crossAxisCount: 2,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  childAspectRatio: 1.3,
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

              const SizedBox(height: 16),

              // Profile picture from Gmail
              Obx(() {
                final profilePicture = controller.profilePicture.value;
                return Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.blue[400],
                  ),
                  child: profilePicture.isNotEmpty
                      ? ClipOval(
                          child: CachedNetworkImage(
                            imageUrl: profilePicture,
                            width: 60,
                            height: 60,
                            fit: BoxFit.cover,
                            memCacheWidth: 60,
                            memCacheHeight: 60,
                            placeholder: (context, url) => Container(
                              color: Colors.blue[400],
                              child: const Icon(
                                Icons.person,
                                size: 30,
                                color: Colors.white,
                              ),
                            ),
                            errorWidget: (context, url, error) => Container(
                              color: Colors.blue[400],
                              child: const Icon(
                                Icons.person,
                                size: 30,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        )
                      : Icon(Icons.person, size: 40, color: Colors.white),
                );
              }),

              // Bottom branding section
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 11.0),
                child: Column(
                  children: [
                    const Text(
                      'QuitEase',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Your journey to a smoke-free life',
                      style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
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

          Text(
            label,
            style: Theme.of(
              context,
            ).textTheme.bodySmall?.copyWith(color: Colors.grey[600]),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
