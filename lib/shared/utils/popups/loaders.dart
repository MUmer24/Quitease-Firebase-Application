import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:quitease/shared/utils/enums.dart';
import 'package:quitease/core/theme/app_theme.dart';

class TLoaders {
  static void hideSnackBar() =>
      ScaffoldMessenger.of(Get.context!).hideCurrentSnackBar();

  static void customToast({required String message}) {
    ScaffoldMessenger.of(Get.context!).showSnackBar(
      SnackBar(
        elevation: 0,
        duration: const Duration(seconds: 5),
        backgroundColor: Colors.grey,
        content: Container(
          padding: const EdgeInsets.all(12.0),
          margin: const EdgeInsets.symmetric(horizontal: 30),
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(30)),
          child: Center(
            child: Text(
              message,
              style: Theme.of(Get.context!).textTheme.bodySmall,
            ),
          ),
        ),
      ),
    );
  }

  static void successSnackBar({
    required String title,
    String message = '',
    int duration = 5,
  }) {
    Get.snackbar(
      title,
      message,
      isDismissible: true,
      shouldIconPulse: true,
      colorText: SereneAscentTheme.getColor(SereneAscentPaletteColor.pureWhite),
      backgroundColor: SereneAscentTheme.getColor(
        SereneAscentPaletteColor.successGreen,
      ),
      snackPosition: SnackPosition.BOTTOM,
      duration: Duration(seconds: duration),
      margin: const EdgeInsets.all(10),
      icon: Icon(
        Iconsax.check,
        color: SereneAscentTheme.getColor(SereneAscentPaletteColor.pureWhite),
      ),
    );
  }

  static void warningSnackBar({required String title, String message = ''}) {
    Get.snackbar(
      title,
      message,
      isDismissible: true,
      shouldIconPulse: true,
      colorText: SereneAscentTheme.getColor(
        SereneAscentPaletteColor.charcoalGrey,
      ),
      backgroundColor: SereneAscentTheme.getColor(
        SereneAscentPaletteColor.warningYellow,
      ),
      snackPosition: SnackPosition.BOTTOM,
      duration: const Duration(seconds: 5),
      margin: const EdgeInsets.all(20),
      icon: Icon(
        Iconsax.warning_2,
        color: SereneAscentTheme.getColor(
          SereneAscentPaletteColor.charcoalGrey,
        ),
      ),
    );
  }

  static void errorSnackBar({required String title, String message = ''}) {
    Get.snackbar(
      title,
      message,
      isDismissible: true,
      shouldIconPulse: true,
      colorText: SereneAscentTheme.getColor(SereneAscentPaletteColor.pureWhite),

      backgroundColor: SereneAscentTheme.getColor(
        SereneAscentPaletteColor.errorRed,
      ),
      snackPosition: SnackPosition.BOTTOM,
      duration: const Duration(seconds: 5),
      margin: const EdgeInsets.all(20),
      icon: Icon(
        Iconsax.warning_2,
        color: SereneAscentTheme.getColor(SereneAscentPaletteColor.pureWhite),
      ),
    );
  }

  static void infoSnackBar({required String title, String message = ''}) {
    Get.snackbar(
      title,
      message,
      isDismissible: true,
      shouldIconPulse: true,
      colorText: SereneAscentTheme.getColor(SereneAscentPaletteColor.pureWhite),
      backgroundColor: SereneAscentTheme.getColor(
        SereneAscentPaletteColor.skyBlue,
      ),
      snackPosition: SnackPosition.BOTTOM,
      duration: const Duration(seconds: 5),
      margin: const EdgeInsets.all(20),
      icon: Icon(
        Iconsax.info_circle,
        color: SereneAscentTheme.getColor(SereneAscentPaletteColor.pureWhite),
      ),
    );
  }
}
