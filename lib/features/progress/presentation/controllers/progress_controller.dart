import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:quitease/shared/services/storage/data_persistence_service.dart';

class ProgressController extends GetxController {
  static ProgressController get instance => Get.find();

  // Dependencies - Updated to use centralized services
  final DataPersistenceService _dataService = Get.find();

  // Reactive variables for UI display
  final isLoading = false.obs;

  // Projection data variables
  final cigarettesPerDay = '0'.obs;
  final cigarettesPerWeek = '0'.obs;
  final cigarettesPerMonth = '0'.obs;
  final cigarettesPerYear = '0'.obs;

  final moneySavedPerDay = '0.0'.obs;
  final moneySavedPerWeek = '0.0'.obs;
  final moneySavedPerMonth = '0.0'.obs;
  final moneySavedPerYear = '0.0'.obs;

  final timeSavedPerDay = '0 min'.obs;
  final timeSavedPerWeek = '0 hours'.obs;
  final timeSavedPerMonth = '0 hours'.obs;
  final timeSavedPerYear = '0 days'.obs;

  @override
  void onInit() {
    super.onInit();
    calculateProgress();
  }

  Future<void> calculateProgress() async {
    try {
      isLoading.value = true;

      // Use data from the centralized service
      final cigsPerDay = _dataService.cigarettesPerDay.value;
      final cigsPerPack = _dataService.cigarettesPerPack.value;
      final pricePerPack = _dataService.pricePerPack.value;

      if (cigsPerDay > 0 && cigsPerPack > 0 && pricePerPack > 0) {
        // A more robust implementation would use a dedicated projection calculator.
        cigarettesPerDay.value = cigsPerDay.toString();
        cigarettesPerWeek.value = (cigsPerDay * 7).toString();
        cigarettesPerMonth.value = (cigsPerDay * 30).toString();
        cigarettesPerYear.value = (cigsPerDay * 365).toString();

        final costPerCig = pricePerPack / cigsPerPack;
        moneySavedPerDay.value = (cigsPerDay * costPerCig).toStringAsFixed(1);
        moneySavedPerWeek.value = (cigsPerDay * costPerCig * 7).toStringAsFixed(
          1,
        );
        moneySavedPerMonth.value = (cigsPerDay * costPerCig * 30)
            .toStringAsFixed(1);
        moneySavedPerYear.value = (cigsPerDay * costPerCig * 365)
            .toStringAsFixed(1);

        timeSavedPerDay.value = '${cigsPerDay * 7} min';
        timeSavedPerWeek.value = '${(cigsPerDay * 7 * 7) ~/ 60} hours';
        timeSavedPerMonth.value = '${(cigsPerDay * 7 * 30) ~/ 60} hours';
        timeSavedPerYear.value = '${(cigsPerDay * 7 * 365) ~/ (60 * 24)} days';
      }
    } catch (e) {
      // Handle error silently or show error state
      debugPrint('Error calculating progress: $e');
    } finally {
      isLoading.value = false;
    }
  }
}
