import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:quitease/features/onboarding/presentation/screens/health_tracking_screen.dart';

class QuitDateTimeController extends GetxController {
  final selectedDateTime = DateTime.now().obs;

  Future<void> pickDateTime(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: selectedDateTime.value,
      firstDate: DateTime(2000),
      lastDate: DateTime.now(), // Only allow today or earlier
    );

    if (pickedDate != null && context.mounted) {
      final TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(selectedDateTime.value),

        // -------------------------------------------------------------------
        // Restrict selectable times to now or earlier if pickedDate is today
        builder: (context, child) {
          if (pickedDate.isAtSameMomentAs(DateTime.now()) ||
              (pickedDate.year == DateTime.now().year &&
                  pickedDate.month == DateTime.now().month &&
                  pickedDate.day == DateTime.now().day)) {
            return TimePickerDialog(
              initialTime: TimeOfDay.fromDateTime(selectedDateTime.value),
              // Only allow times up to now
              // This disables future times for today
              onEntryModeChanged: (_) {},
              confirmText: 'OK',
              cancelText: 'CANCEL',
              helpText: 'Select Time',
              initialEntryMode: TimePickerEntryMode.dial,
              hourLabelText: 'Hour',
              minuteLabelText: 'Minute',
              // Custom logic for time restriction can be added here if needed
            );
          }
          return child!;
        },

        // -------------------------------------------------------------------
      );

      if (pickedTime != null) {
        selectedDateTime.value = DateTime(
          pickedDate.year,
          pickedDate.month,
          pickedDate.day,
          pickedTime.hour,
          pickedTime.minute,
        );
      }
    }
  }

  void navigateToHealthTracking() {
    Get.to(
      () => HealthTrackingScreen(),
      arguments: {'quitDate': selectedDateTime.value},
    );
  }
}
