import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:goodfellow/features/Home/screens/transaction_history/history.dart';
import 'package:goodfellow/utils/constants/image_strings.dart';
import 'package:goodfellow/utils/constants/sizes.dart';

class BillSuccessDialog extends StatelessWidget {
  const BillSuccessDialog({
    super.key,
    required this.token,
    required this.units,
    required this.address,
    required this.name,
    required this.vat,
    required this.voucherSerial,
    required this.kwhAmount,
    required this.date,
    required this.amount,
    required this.accountNumber,
  });

  final String token;
  final String units;
  final String address;
  final String name;
  final String vat;
  final String voucherSerial;
  final String kwhAmount;
  final String date;
  final String amount;
  final String accountNumber;

  @override
  Widget build(BuildContext context) {
    final GetStorage deviceStorage = GetStorage();

    final branchName = deviceStorage.read("branchName");
    final username = deviceStorage.read("userName");

    return Center(
      child: Material(
        color: Colors.transparent,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (token != "N/A") ...[
              Text('Name: $name'),
              const SizedBox(height: APPSizes.spaceBtwItem / 2),
              Text('Address: $address'),
              const SizedBox(height: APPSizes.spaceBtwItem / 2),
              Text('Token: $token'),
              const SizedBox(height: APPSizes.spaceBtwItem / 2),
              Text('Units: $units'),
              const SizedBox(height: APPSizes.spaceBtwItem / 2),
              Text('Serial: $voucherSerial'),
              const SizedBox(height: APPSizes.spaceBtwItem / 2),
              Text('VAT: $vat'),
              const SizedBox(height: APPSizes.spaceBtwItem / 2),
              Text('Kwh Amount: $kwhAmount'),
              const SizedBox(height: APPSizes.spaceBtwItem / 2),
              const Text('Your Units purchase was successful!'),
            ],
            if (token == "N/A") ...[
              Text("Account Number: ${accountNumber.trim()}"),
              const SizedBox(height: APPSizes.spaceBtwItem / 2),
              Text("Amount: ${amount.trim()}"),
              const SizedBox(height: APPSizes.spaceBtwItem / 2),
              const Text('Your purchase was successful!'),
            ],
            if (token != "N/A")
              ElevatedButton(
                onPressed: () {
                  printZescoUnits(
                    token: token,
                    meterNumber: accountNumber.trim(),
                    numberOfUnits:
                        units, // Replace with actual number of units if available
                    amountPaid: amount.trim(),
                    vat: vat, // Replace with the actual VAT if available
                    businessName: 'Geepay', // Add your business name
                    imageData: APPImages.lightAppLogo,
                    address: address,
                    kwhAmount: kwhAmount,
                    customerName: name,
                    voucherSerial:
                        voucherSerial, // Add your image byte array data
                    date: date,
                    username: username,
                    branchName: branchName,
                  );
                  Get.snackbar(
                    'Print Receipt',
                    'Printing Zesco units receipt...',
                    snackPosition: SnackPosition.BOTTOM,
                  );
                },
                child: const Text('Print Receipt'),
              ),
            if (token == "N/A")
              ElevatedButton(
                onPressed: () {
                  Get.to(
                    transition: Transition.rightToLeft,
                    duration: const Duration(milliseconds: 500),
                    () => const TransactionHistory(),
                  );
                },
                child: const Text('Transaction History'),
              ),
            TextButton(
              onPressed: () {
                Get.back();
                // Get.to(
                //     transition: Transition.rightToLeft,
                //     duration: const Duration(milliseconds: 500),
                //     () => const TransactionHistory());
              },
              child: const Text('Close'),
            ),
          ],
        ),
      ),
    );
  }
}

void printZescoUnits({
  required String token,
  required String meterNumber,
  required String numberOfUnits,
  required String amountPaid,
  required String vat,
  required String businessName,
  required String imageData, // Image data to be printed
  required String address,
  required String kwhAmount,
  required String customerName,
  required String voucherSerial,
  required String date,
  required String username,
  required String branchName,
}) {
  const platform = MethodChannel('com.example.goodfellow/print');

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
      'imageData': imageData, // Send the image as byte array
      'customerName': customerName,
      "address": address,
      "serialNumber": voucherSerial,
      "kwhAmount": kwhAmount,
      "date": date,
    });
  } catch (e) {
    Get.snackbar('Error', 'Failed to print Zesco receipt: $e');
  }
}
