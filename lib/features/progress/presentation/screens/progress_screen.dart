import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quitease/features/progress/presentation/controllers/progress_controller.dart';
import 'package:quitease/core/constants/app_constants.dart';
import 'package:quitease/shared/utils/enums.dart';
import 'package:quitease/core/theme/app_theme.dart';

class ProgressScreen extends StatelessWidget {
  final ProgressController controller = Get.put(ProgressController());

  ProgressScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: Text(AppConstants.progressScreenAppbarTitle),
        centerTitle: true,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Get.back(),
        ),
      ),

      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        return SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _TodayProgressCard(controller: controller),
                const SizedBox(height: 16.0),
                _ProgressCard(
                  title: AppConstants.progressCardLabel2Txt,
                  stat1: controller.cigarettesPerWeek.value,
                  label1: AppConstants.progressTypeCigarettesLabelTxt,
                  stat2: 'Rs ${controller.moneySavedPerWeek.value}',
                  label2: AppConstants.progressTypeMoneyLabelTxt,
                  stat3: controller.timeSavedPerWeek.value,
                  label3: AppConstants.progressTypeTimeLabelTxt,
                ),
                const SizedBox(height: 11.0),
                _ProgressCard(
                  title: AppConstants.progressCardLabel3Txt,
                  stat1: controller.cigarettesPerMonth.value,
                  label1: AppConstants.progressTypeCigarettesLabelTxt,
                  stat2: 'Rs ${controller.moneySavedPerMonth.value}',
                  label2: AppConstants.progressTypeMoneyLabelTxt,
                  stat3: controller.timeSavedPerMonth.value,
                  label3: AppConstants.progressTypeTimeLabelTxt,
                ),
                const SizedBox(height: 11.0),
                _ProgressCard(
                  title: AppConstants.progressCardLabel4Txt,
                  stat1: controller.cigarettesPerYear.value,
                  label1: AppConstants.progressTypeCigarettesLabelTxt,
                  stat2: 'Rs ${controller.moneySavedPerYear.value}',
                  label2: AppConstants.progressTypeMoneyLabelTxt,
                  stat3: controller.timeSavedPerYear.value,
                  label3: AppConstants.progressTypeTimeLabelTxt,
                ),
              ],
            ),
          ),
        );
      }),
    );
  }
}

class _TodayProgressCard extends StatelessWidget {
  final ProgressController controller;

  const _TodayProgressCard({required this.controller});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Card(
      // Card theme is applied from your MaterialApp theme
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "TODAY'S PROGRESS", // Or "DAILY PROGRESS" if you prefer
              style: textTheme.bodyMedium?.copyWith(
                color: SereneAscentTheme.getColor(
                  SereneAscentPaletteColor.deepBlue,
                ),
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 20.0),
            _ProgressRowItem(
              icon: Icons.smoking_rooms_sharp,
              iconColor: SereneAscentTheme.getColor(
                SereneAscentPaletteColor.errorRed,
              ),
              backgroundColor: SereneAscentTheme.getColor(
                SereneAscentPaletteColor.lightGreyBlue,
              ),
              value: controller.cigarettesPerDay.value,
              label: 'cigarettes avoided',
            ),
            const SizedBox(height: 16.0),
            _ProgressRowItem(
              icon: Icons.payments_sharp,
              iconColor: SereneAscentTheme.getColor(
                SereneAscentPaletteColor.successGreen,
              ),
              backgroundColor: SereneAscentTheme.getColor(
                SereneAscentPaletteColor.lightGreyBlue,
              ),
              value:
                  'Rs ${controller.moneySavedPerDay.value}', // Added 'Rs' for consistency
              label: AppConstants.progressTypeMoneyLabelTxt,
            ),
            const SizedBox(height: 16.0),
            _ProgressRowItem(
              icon: Icons.hourglass_top_sharp,
              iconColor: SereneAscentTheme.getColor(
                SereneAscentPaletteColor.deepBlue,
              ),
              backgroundColor: SereneAscentTheme.getColor(
                SereneAscentPaletteColor.lightGreyBlue,
              ),
              value: controller.timeSavedPerDay.value,
              label: AppConstants.progressTypeTimeLabelTxt,
            ),
          ],
        ),
      ),
    );
  }
}

// --- UI Widgets Copied from main.dart ---
// These are used by the widgets above

class _ProgressRowItem extends StatelessWidget {
  const _ProgressRowItem({
    required this.icon,
    required this.iconColor,
    required this.backgroundColor,
    required this.value,
    required this.label,
  });

  final IconData icon;
  final Color iconColor;
  final Color backgroundColor;
  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return Row(
      children: [
        CircleAvatar(
          radius: 20,
          backgroundColor: backgroundColor,
          child: Icon(icon, color: iconColor, size: 24),
        ),
        const SizedBox(width: 16.0),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                value,
                style: textTheme.titleLarge?.copyWith(
                  color: colorScheme.onSurface,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                label,
                style: textTheme.bodyMedium?.copyWith(color: Colors.grey[600]),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _ProgressCard extends StatelessWidget {
  const _ProgressCard({
    required this.title,
    required this.stat1,
    required this.label1,
    required this.stat2,
    required this.label2,
    required this.stat3,
    required this.label3,
  });

  final String title;
  final String stat1;
  final String label1;
  final String stat2;
  final String label2;
  final String stat3;
  final String label3;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final borderColor = isDarkMode
        ? const Color(0xFF334155)
        : const Color(0xFFE2E8F0);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: textTheme.titleMedium?.copyWith(
                color: colorScheme.onSurface,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 16.0),
            IntrinsicHeight(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _ProjectionColumnItem(
                    value: stat1,
                    label: label1,
                    color: SereneAscentTheme.getColor(
                      SereneAscentPaletteColor.errorRed,
                    ),
                  ),
                  Container(width: 1, color: borderColor),
                  _ProjectionColumnItem(
                    value: stat2,
                    label: label2,
                    color: SereneAscentTheme.getColor(
                      SereneAscentPaletteColor.successGreen,
                    ),
                  ),
                  Container(width: 1, color: borderColor),
                  _ProjectionColumnItem(
                    value: stat3,
                    label: label3,
                    color: SereneAscentTheme.getColor(
                      SereneAscentPaletteColor.deepBlue,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ProjectionColumnItem extends StatelessWidget {
  const _ProjectionColumnItem({
    required this.value,
    required this.label,
    required this.color,
  });

  final String value;
  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Expanded(
      child: Column(
        children: [
          Text(
            label,
            style: textTheme.bodySmall?.copyWith(color: Colors.grey[600]),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 4.0),
          Text(
            value,
            style: textTheme.titleLarge?.copyWith(
              color: color,
              fontWeight: FontWeight.w700,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
