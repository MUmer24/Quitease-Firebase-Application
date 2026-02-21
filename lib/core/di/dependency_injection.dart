import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quitease/shared/services/storage/shared_prefs_provider.dart';
import 'package:quitease/features/achievements/presentation/controllers/achievement_controller.dart';
import 'package:quitease/features/settings/presentation/controllers/settings_controller.dart';
import 'package:quitease/shared/utils/network_manager.dart';
import 'package:quitease/shared/utils/savings_calculator.dart';
import 'package:quitease/shared/utils/time_calculator.dart';
import 'package:quitease/shared/repositories/auth/user_repository.dart';
import 'package:quitease/shared/services/storage/data_persistence_service.dart';
import 'package:quitease/features/dashboard/data/app_data_controller.dart';
import 'package:quitease/features/auth/data/auth_wrapper/auth_wrapper_controller.dart';
import 'package:quitease/shared/services/notification/notification_service.dart';
import 'package:quitease/shared/services/notification/notification_scheduler.dart';

class DependencyInjection {
  static void init() {
    // --- CORE SERVICES ---
    Get.put<NetworkManager>(NetworkManager());
    Get.put<SharedPrefsProvider>(SharedPrefsProvider());
    Get.put<SavingsCalculator>(SavingsCalculator());
    Get.put<TimeWonBackCalculator>(TimeWonBackCalculator());
    Get.put<UserRepository>(UserRepository());

    // --- NEW CENTRALIZED DATA SERVICES ---
    Get.put<DataPersistenceService>(DataPersistenceService());
    Get.put<AppDataController>(AppDataController());

    // --- NOTIFICATION SERVICE ---
    Get.put<NotificationService>(NotificationService());
    Get.put<NotificationScheduler>(NotificationScheduler());

    // --- CONTROLLERS ---
    // Only controllers needed at app startup should be registered here
    // Screen-specific controllers will be created when their screens are accessed

    Get.put<AuthWrapperController>(AuthWrapperController());

    // Lazy-load AchievementController - needed during onboarding completion
    Get.lazyPut(() => AchievementController(), fenix: true);

    // DashboardController, HealthController, ProgressController are NOT registered here
    // They will be created by GetX when their screens are accessed
    // This prevents them from loading data before user signs in or data is available

    Get.put<SettingsController>(SettingsController());

    debugPrint('✅ Dependency injection complete');
  }
}
