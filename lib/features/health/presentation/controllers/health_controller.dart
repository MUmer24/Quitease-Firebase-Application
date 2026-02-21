import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quitease/shared/models/benefit_model.dart';
import 'package:quitease/shared/services/storage/shared_prefs_provider.dart';

class HealthController extends GetxController {
  final SharedPrefsProvider _sharedPrefsProvider = Get.find();

  final benefits = <Benefit>[].obs;
  final sortedBenefits = <Benefit>[].obs;
  final completedBenefitsCount = 0.obs;

  @override
  void onReady() {
    super.onReady();
    // Delay loading to ensure SharedPreferences data is available
    Future.delayed(const Duration(milliseconds: 300), () {
      loadBenefits();
    });
  }

  Future<void> loadBenefits() async {
    DateTime? quitDate = await _sharedPrefsProvider.getQuitDate();

    // Retry if quit date is null (data might not be ready yet)
    if (quitDate == null) {
      debugPrint('⚠️ HealthController: Quit date is null, retrying...');
      for (int i = 0; i < 3; i++) {
        await Future.delayed(const Duration(milliseconds: 300));
        quitDate = await _sharedPrefsProvider.getQuitDate();
        if (quitDate != null) {
          debugPrint('✅ HealthController: Quit date loaded on retry ${i + 1}');
          break;
        }
      }
    }

    if (quitDate != null) {
      final daysSinceQuitting = DateTime.now().difference(quitDate).inDays;
      benefits.assignAll(_calculateBenefits(daysSinceQuitting));
      sortedBenefits.assignAll(
        List<Benefit>.from(benefits)
          ..sort((a, b) => b.progressPercent.compareTo(a.progressPercent)),
      );
      completedBenefitsCount.value = benefits
          .where((b) => b.isCompleted)
          .length;
    }
  }

  List<Benefit> _calculateBenefits(int daysSinceQuitting) {
    return [
      Benefit(
        progressPercent: _calculateProgress(
          daysSinceQuitting,
          0,
          10,
        ), // Starts immediately, completes in 20 days
        description: "Your heart rate and blood pressure drops to normal",
      ),
      Benefit(
        progressPercent: _calculateProgress(
          daysSinceQuitting,
          0,
          24,
        ), // Completes in 24 hours (1 day)
        description: "The carbon monoxide level in your blood drops to normal",
      ),
      Benefit(
        progressPercent: _calculateProgress(
          daysSinceQuitting,
          0,
          14,
        ), // Completes in 2 weeks
        description:
            "Your circulation improves and your lung function increases",
      ),
      Benefit(
        progressPercent: _calculateProgress(
          daysSinceQuitting,
          30,
          365,
        ), // Starts after 1 month, completes in 1 year
        description:
            "Your risk of respiratory infections decreases significantly",
      ),
      Benefit(
        progressPercent: _calculateProgress(
          daysSinceQuitting,
          14,
          90,
        ), // Starts after 2 weeks, completes in 3 months
        description: "Coughing and shortness of breath decrease",
      ),
      Benefit(
        progressPercent: _calculateProgress(
          daysSinceQuitting,
          365,
          7300,
        ), // Starts after 1 year, completes in ~20 years
        description:
            "Your risk of coronary heart disease is about half that of a smoker's",
      ),
      Benefit(
        progressPercent: _calculateProgress(
          daysSinceQuitting,
          30,
          90,
        ), // Starts after 1 month, completes in 3 months
        description: "Your immune system begins to recover",
      ),
      Benefit(
        progressPercent: _calculateProgress(
          daysSinceQuitting,
          0,
          7,
        ), // Completes in 1 week
        description:
            "Sense of taste and smell improves within days of quitting",
      ),
      Benefit(
        progressPercent: _calculateProgress(
          daysSinceQuitting,
          30,
          90,
        ), // Starts after 1 month, completes in 3 months
        description:
            "Cilia in the lungs regain normal function, helping clear mucus",
      ),
      Benefit(
        progressPercent: _calculateProgress(
          daysSinceQuitting,
          365,
          7300,
        ), // Starts after 1 year, completes in ~20 years
        description: "The stroke risk is that of a nonsmoker's",
      ),
    ];
  }

  int _calculateProgress(int days, int startDay, int completionDay) {
    if (days <= startDay) return 0;
    if (days >= completionDay) return 100;

    double progress = ((days - startDay) / (completionDay - startDay)) * 100;
    return progress.clamp(0, 100).toInt();
  }
}
