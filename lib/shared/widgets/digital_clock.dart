import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:quitease/features/dashboard/data/app_data_controller.dart';
import 'package:quitease/shared/services/storage/data_persistence_service.dart';
import 'package:quitease/features/dashboard/presentation/controllers/dashboard_controller.dart';

class DigitalClockWidget extends StatelessWidget {
  final bool showDate;
  final AppDataController appDataController;
  final DataPersistenceService dataService;

  DigitalClockWidget({
    super.key,
    required DashboardController controller, // Keep for backward compatibility
    this.showDate = true,
  }) : appDataController = Get.find(),
       dataService = Get.find();

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final duration = appDataController.timeSinceQuit.value;
      final days = duration.inDays;
      final hours = duration.inHours % 24;
      final minutes = duration.inMinutes % 60;
      final seconds = duration.inSeconds % 60;

      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (days > 0) _buildTimeSegment(days.toString(), 'Days'),
              if (days > 0) const SizedBox(width: 8),
              _buildTimeSegment(hours.toString().padLeft(2, '0'), 'Hours'),
              const SizedBox(width: 8),
              _buildTimeSegment(minutes.toString().padLeft(2, '0'), 'Minutes'),
              const SizedBox(width: 8),
              _buildTimeSegment(seconds.toString().padLeft(2, '0'), 'Seconds'),
            ],
          ),
          if (showDate && dataService.quitDate.value != null)
            Padding(
              padding: const EdgeInsets.only(top: 12.0),
              child: Text(
                'Quit on: ${DateFormat('MMM d, y • h:mm a').format(dataService.quitDate.value!.toLocal())}',
                style: TextStyle(
                  fontSize: 14,
                  color: Theme.of(context).hintColor,
                ),
              ),
            ),
        ],
      );
    });
  }

  Widget _buildTimeSegment(String value, String label) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          value,
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            color: Theme.of(Get.context!).hintColor,
          ),
        ),
      ],
    );
  }
}
