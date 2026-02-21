import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:quitease/features/onboarding/presentation/controllers/quit_date_time_controller.dart';
import 'package:quitease/core/constants/app_constants.dart';

class QuitDateTimeScreen extends StatelessWidget {
  final QuitDateTimeController controller = Get.put(QuitDateTimeController());

  QuitDateTimeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Check if this screen is accessed after reset
    final bool isAfterReset =
        Get.arguments != null && Get.arguments['isAfterReset'] == true;

    final size = MediaQuery.of(context).size;

    return PopScope(
      // Prevent back navigation when accessed after reset
      canPop: !isAfterReset,
      onPopInvokedWithResult: (bool didPop, Object? result) {
        if (isAfterReset && !didPop) {
          // Exit the app or go to home screen instead of going back
          // For mobile apps, this will typically minimize the app
          SystemNavigator.pop();
        }
      },
      child: Scaffold(
        appBar: AppBar(
          // Remove back button when accessed after reset
          automaticallyImplyLeading: !isAfterReset,
          leading: isAfterReset
              ? null
              : IconButton(
                  onPressed: () => Get.back(),
                  icon: AppConstants.backIcon,
                ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                children: [
                  Text(
                    AppConstants.quest1,
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    AppConstants.questAltrnt,
                    style: Theme.of(context).textTheme.bodyLarge,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 32),
                  Obx(
                    () => Text(
                      DateFormat(
                        AppConstants.dateFormat,
                      ).format(controller.selectedDateTime.value),
                      style: Theme.of(context).textTheme.headlineSmall
                          ?.copyWith(fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(height: 16),
                  OutlinedButton(
                    onPressed: () => controller.pickDateTime(context),
                    child: Text(AppConstants.dateTimeSelectionBtn),
                  ),
                  SizedBox(
                    height: size.height * 0.3,
                    child: Image.asset(
                      AppConstants.quitImg,
                      fit: BoxFit.contain,
                    ),
                  ),
                ],
              ),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: controller.navigateToHealthTracking,
                  child: Text(AppConstants.navigateToHealthTrackingBtn),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
