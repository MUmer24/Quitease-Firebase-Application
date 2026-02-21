import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quitease/features/health/presentation/controllers/health_controller.dart';
import 'package:quitease/core/constants/app_constants.dart';

class HealthImprovementScreen extends StatelessWidget {
  // Use Get.put to create controller when screen is shown for the first time
  // This ensures it loads data AFTER user signs in, not at app startup
  final HealthController controller = Get.put(HealthController());

  HealthImprovementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppConstants.healthImprovementsScreenAppbarTitle),
        actions: [
          Obx(
            () => Row(
              children: [
                Text(
                  " ${controller.completedBenefitsCount.value}/${controller.benefits.length}  ",
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                const Icon(Icons.favorite, color: Colors.red),
                const SizedBox(width: 5.0),
              ],
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        child: Column(
          children: [
            Expanded(
              child: Obx(
                () => ListView.separated(
                  itemCount: controller.sortedBenefits.length,
                  separatorBuilder: (context, index) =>
                      const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final benefit = controller.sortedBenefits[index];
                    return BenefitProgressItem(
                      progressPercent: benefit.progressPercent,
                      description: benefit.description,
                      isCompleted: benefit.isCompleted,
                    );
                  },
                ),
              ),
            ),
            const SizedBox(height: 5),
            const Text(
              AppConstants.bottomTxt,
              style: TextStyle(color: Colors.grey, fontSize: 12),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 5),
            SizedBox(
              height: 100,
              child: Image.asset(AppConstants.whoLogoImg, fit: BoxFit.contain),
            ),
            const SizedBox(height: 5),
          ],
        ),
      ),
    );
  }
}

class BenefitProgressItem extends StatelessWidget {
  final int progressPercent;
  final String description;
  final bool isCompleted;

  const BenefitProgressItem({
    super.key,
    required this.progressPercent,
    required this.description,
    required this.isCompleted,
  });

  Color getProgressColor(int progress) {
    if (progress >= 80) {
      return Colors.blue;
    } else if (progress >= 20) {
      return Colors.orangeAccent;
    } else {
      return Colors.redAccent;
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final progressColor = getProgressColor(progressPercent);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: size.width * 0.8,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: LinearProgressIndicator(
                  value: progressPercent / 100,
                  minHeight: 11,
                  color: progressColor,
                  backgroundColor: Colors.grey.shade300,
                ),
              ),
            ),
            const SizedBox(width: 5),
            SizedBox(
              width: size.width * 0.1,
              child: Text(
                '${progressPercent.toString()}%',
                style: Theme.of(context).textTheme.bodySmall,
                textAlign: TextAlign.start,
              ),
            ),
          ],
        ),
        const SizedBox(height: 5),
        SizedBox(
          width: size.width * 0.9,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5.0),
                child: SizedBox(
                  width: size.width * 0.8,
                  child: Text(
                    description,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      decoration: isCompleted
                          ? TextDecoration.lineThrough
                          : null,
                      color: isCompleted ? Colors.green : null,
                    ),
                  ),
                ),
              ),
              if (isCompleted)
                const Icon(Icons.check_circle, color: Colors.green, size: 16),
            ],
          ),
        ),
      ],
    );
  }
}
