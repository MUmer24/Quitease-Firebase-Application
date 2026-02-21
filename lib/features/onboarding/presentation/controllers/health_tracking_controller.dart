import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:quitease/features/onboarding/presentation/screens/summary_screen.dart';

class HealthTrackingController extends GetxController {
  final formKey = GlobalKey<FormState>();
  final cigsPerDayController = TextEditingController();
  final cigsPerPackController = TextEditingController();
  final pricePerPackController = TextEditingController();

  final DateTime quitDate = Get.arguments['quitDate'];

  String? validateNumber(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter a value';
    }
    if (double.tryParse(value) == null) {
      return 'Please enter a valid number';
    }
    return null;
  }

  void navigateToSummary() {
    if (formKey.currentState!.validate()) {
      Get.to(
        () => SummaryScreen(),
        arguments: {
          'quitDate': quitDate,
          'cigsPerDay': double.parse(cigsPerDayController.text),
          'cigsPerPack': double.parse(cigsPerPackController.text),
          'pricePerPack': double.parse(pricePerPackController.text),
        },
      );
    }
  }

  @override
  void onClose() {
    cigsPerDayController.dispose();
    cigsPerPackController.dispose();
    pricePerPackController.dispose();
    super.onClose();
  }
}
