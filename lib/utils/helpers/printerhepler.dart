import 'package:flutter/services.dart';
import 'package:get_storage/get_storage.dart';
import 'package:goodfellow/common/widgets/loaders/loaders.dart';

class PrintHelper {
  static final deviceStorage = GetStorage();

  static const platform = MethodChannel('com.example.goodfellow/print');

  static Future<void> printReceipt({
    required String phone,
    required String amount,
    required String paymentChannel,
    required String transactionId,
    required String transactionType,
    required String date,
    required String status,
    required String imagePath,
    required String businessName,
    required bool isReprint,
  }) async {
    final username = deviceStorage.read("userName");
    final branchName = deviceStorage.read("branchName");

    final receiptLog = GetStorage("receipt_logs");

    final Map<String, String> arguments = {
      'phone': phone,
      'amount': amount,
      'paymentChannel': paymentChannel,
      'transactionId': transactionId,
      'transactionType': transactionType,
      'date': date,
      'status': status,
      'imagePath': imagePath,
      'businessName': businessName,
      "username": username,
      "branchName": branchName,
      "isReprint": isReprint.toString(),
      "reprintCount": receiptLog.read(transactionId).toString(),
    };

    try {
      await platform.invokeMethod('printReceipt', arguments);
      APPLoaders.successSnackBar(
        title: "Success!",
        message: "Receipt printed successfully",
      );
    } catch (e) {
      APPLoaders.errorSnackBar(
        title: "Error",
        message: "Failed to print receipt",
      );
    }
  }

  static void printZescoUnits({
    required String token,
    required String meterNumber,
    required String numberOfUnits,
    required String amountPaid,
    required String vat,
    required String businessName,
    required String imageData,
    required String address,
    required String kwhAmount,
    required String customerName,
    required String voucherSerial,
    required String date,
  }) {
    final username = deviceStorage.read("userName");
    final branchName = deviceStorage.read("branchName");

    try {
      platform.invokeMethod('printZesco', {
        'token': token,
        'meterNumber': meterNumber,
        'numberOfUnits': numberOfUnits,
        'amountPaid': amountPaid,
        'vat': vat,
        'businessName': businessName,
        "username": username,
        "branchName": branchName,
        'imageData': imageData,
        'customerName': customerName,
        "address": address,
        "serialNumber": voucherSerial,
        "kwhAmount": kwhAmount,
        "date": date,
      });
    } catch (e) {
      APPLoaders.errorSnackBar(
        message: 'Failed to print Zesco receipt: $e',
        title: "Error",
      );
    }
  }
}
