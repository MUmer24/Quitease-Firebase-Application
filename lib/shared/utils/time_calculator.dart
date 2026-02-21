import 'package:get/get.dart';

class TimeWonBackCalculator extends GetxController {
  String calculateTimeWonBack({
    required int cigarettesSkipped,
    int minutesPerCigarette = 7,
  }) {
    // Guard against negative values
    if (cigarettesSkipped < 0) {
      return '0 minutes';
    }

    final totalMinutes = cigarettesSkipped * minutesPerCigarette;
    final duration = Duration(minutes: totalMinutes);

    if (duration.inMinutes < 60) {
      return '${duration.inMinutes} ${duration.inMinutes == 1 ? 'minute' : 'minutes'} ';
    } else if (duration.inHours < 24) {
      return '${duration.inHours} ${duration.inHours == 1 ? 'hour' : 'hours'} ';
    } else {
      final days = duration.inDays;
      if (days < 10) {
        final preciseDays = totalMinutes / (60 * 24);
        return '${preciseDays.toStringAsFixed(1)} ${preciseDays == 1 ? 'day' : 'days'} ';
      }
      return '$days ${days == 1 ? 'day' : 'days'} saved';
    }
  }
}
