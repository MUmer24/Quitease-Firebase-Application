import 'package:get/get.dart';

class SavingsCalculator extends GetxController {
  Map<String, dynamic> calculateSavings({
    required DateTime quitDate,
    required int cigarettesPerDay,
    required int cigarettesPerPack,
    required double pricePerPack,
  }) {
    // Guard against division by zero
    if (cigarettesPerPack == 0) {
      return {
        'cigarettesSkipped': 0,
        'moneySaved': 0.0,
        'daysSinceQuit': 0,
        'hoursSinceQuit': 0,
        'quitTime': Duration.zero,
      };
    }

    final now = DateTime.now();
    final quitDuration = now.difference(quitDate);
    final daysSinceQuit = quitDuration.inDays.abs();
    final hoursSinceQuit = quitDuration.inHours % 24;
    final totalHours = (daysSinceQuit * 24) + hoursSinceQuit;

    final cigarettesPerHour = cigarettesPerDay / 24;
    final cigarettesSkipped = (cigarettesPerHour * totalHours).round();

    final costPerCigarette = pricePerPack / cigarettesPerPack;
    final moneySaved = (cigarettesSkipped * costPerCigarette);

    return {
      'cigarettesSkipped': cigarettesSkipped,
      'moneySaved': moneySaved,
      'daysSinceQuit': daysSinceQuit,
      'hoursSinceQuit': hoursSinceQuit.abs(),
      'quitTime': quitDuration,
    };
  }
}
