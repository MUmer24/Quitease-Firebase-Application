import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quitease/features/onboarding/presentation/controllers/summary_controller.dart';
import 'package:quitease/core/constants/app_constants.dart';

class SummaryScreen extends StatelessWidget {
  final SummaryController controller = Get.put(SummaryController());

  SummaryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(AppConstants.summaryScreenAppbarTitle)),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Spacer(),
            Text(
              AppConstants.congratsTxt,
              style: Theme.of(context).textTheme.headlineMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            Obx(
              () => Text(
                AppConstants.summaryTxt(controller.daysSinceQuit.value),
                style: Theme.of(context).textTheme.titleLarge,
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 32),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Obx(
                  () => _buildStatCard(
                    context,
                    icon: Icons.smoking_rooms,
                    value: controller.cigarettesSkipped.value.toString(),
                    label: AppConstants.label1,
                  ),
                ),
                Obx(
                  () => _buildStatCard(
                    context,
                    icon: Icons.attach_money,
                    value: ' ${controller.moneySaved.value}',
                    label: AppConstants.label2,
                  ),
                ),
              ],
            ),
            const Spacer(),
            ElevatedButton(
              onPressed: controller.finishOnboarding,
              child: Text(AppConstants.summaryScreenNextBtn),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(
    BuildContext context, {
    required IconData icon,
    required String value,
    required String label,
  }) {
    return Column(
      children: [
        Icon(icon, size: 40, color: Theme.of(context).primaryColor),
        const SizedBox(height: 8),
        Text(value, style: Theme.of(context).textTheme.headlineSmall),
        Text(label, style: Theme.of(context).textTheme.bodyMedium),
      ],
    );
  }
}
