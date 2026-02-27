import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
import 'package:goodfellow/utils/constants/image_strings.dart';

class APPHelperFunctions {
  static Color? getColor(String value) {
    if (value == 'Green') {
      return Colors.green;
    } else {
      return null;
    }
  }

  static void showSnackBar(String message) {
    ScaffoldMessenger.of(
      Get.context!,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  static void showAlert(String title, String message) {
    showDialog(
      context: Get.context!,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Ok'),
            ),
          ],
        );
      },
    );
  }

  static String truncateText(String text, int maxLength) {
    if (text.length <= maxLength) {
      return text;
    } else {
      return '${text.substring(0, maxLength)}...';
    }
  }

  static bool isDarkMode(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark;
  }

  static Size screenSize() {
    return MediaQuery.of(Get.context!).size;
  }

  static double screenHeight() {
    return MediaQuery.of(Get.context!).size.height;
  }

  static double screenWidth() {
    return MediaQuery.of(Get.context!).size.width;
  }

  static String getFormattedDate(
    DateTime dateTime, {
    String format = 'dd MMM yyyy',
  }) {
    return DateFormat(format).format(dateTime);
  }

  static List<T> removeDuplicates<T>(List<T> list) {
    return list.toSet().toList();
  }

  static List<Widget> wrapWidgets(List<Widget> widgets, int rowSize) {
    final wrappedList = <Widget>[];
    for (var i = 0; i < widgets.length; i += rowSize) {
      final rowChildren = widgets.sublist(
        i,
        i + rowSize > widgets.length ? widgets.length : i + rowSize,
      );
      wrappedList.add(Row(children: rowChildren));
    }

    return wrappedList;
  }

  static String parseIsoDate(String dateString) {
    DateTime parsedDate = DateTime.parse(dateString).toLocal();
    DateFormat formatter = DateFormat('MMMM d, y, h:mm a');
    return formatter.format(parsedDate);
  }

  // s
  static IconData getPaymentIcon(String paymentMode) {
    switch (paymentMode.toLowerCase()) {
      case 'mtn momo':
        return Iconsax.mobile; // Replace with actual MTN MoMo icon
      case 'airtel_money':
        return Iconsax.mobile;
      case 'zesco':
        return Icons.payments_rounded; // Replace with actual Airtel Money icon
      default:
        return Icons.payments_rounded; // Default icon if mode is not recognized
    }
  }

  static String getPaymentImageString(String paymentMode) {
    final normalized = paymentMode
        .toLowerCase()
        .replaceAll('_', ' ')
        .replaceAll('-', ' ')
        .replaceAll(RegExp(r'\s+'), ' ')
        .trim();

    if (normalized.contains('mtn') && normalized.contains('money')) {
      return APPImages.mtnImage;
    } else if (normalized.contains('airtel') && normalized.contains('money')) {
      return APPImages.airtelImage;
    } else if (normalized.contains('zamtel') && normalized.contains('money')) {
      return APPImages.zescoImage;
    } else if (normalized.contains('zesco')) {
      return APPImages.zescoImage;
    } else if (normalized.contains('dstv')) {
      return APPImages.dstvImage;
    } else if (normalized.contains('gotv')) {
      return APPImages.gotvImage;
    } else if (normalized.contains('zed')) {
      return APPImages.zedMobileLogo;
    }

    return APPImages.cardBg; // Fallback image
  }
}
