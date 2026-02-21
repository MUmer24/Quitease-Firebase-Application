import 'package:get/get.dart';

class AuthController extends GetxController {
  // All user/session/onboarding state and logic is now handled by AuthWrapperController.
  // This controller can be removed or reduced to screen-specific logic if needed.
  static AuthController get instance => Get.find();
}
