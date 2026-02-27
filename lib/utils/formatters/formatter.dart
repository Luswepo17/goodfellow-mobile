import 'package:intl/intl.dart';

class APPFormatter {
  static String formatDate(DateTime? dateTime) {
    dateTime ??= DateTime.now();
    return DateFormat('dd-MMM-yyyy').format(dateTime);
  }

  static String formatCurrency(double amount) {
    return NumberFormat.currency(locale: 'en_US', symbol: 'ZMW').format(amount);
  }

  static String formatPhoneNumber(String phoneNumber) {
    if (phoneNumber.length == 10) {
      return '(${phoneNumber.substring(0, 3)}) ${phoneNumber.substring(3, 6)} ${phoneNumber.substring(6)}';
    }

    return phoneNumber;
  }
}
