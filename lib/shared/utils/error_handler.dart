import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ErrorHandler {
  static void showError(String message) {
    Get.snackbar(
      'An Error Occurred',
      message,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.red,
      colorText: Colors.white,
    );
  }

  static void showInfo(String message) {
    Get.snackbar(
      'Info',
      message,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.blue,
      colorText: Colors.white,
    );
  }
}
