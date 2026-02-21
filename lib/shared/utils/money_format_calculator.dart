import 'package:get/get.dart';
import 'package:intl/intl.dart';

class MoneyFormatCalculator extends GetxController {
  String formatSavedMoney(double moneySaved, {String currency = 'Rs '}) {
    return NumberFormat.currency(
      symbol: currency,
      decimalDigits: 1,
    ).format(moneySaved);
  }
}
