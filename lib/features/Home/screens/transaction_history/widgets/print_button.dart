import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:goodfellow/features/Home/controllers/transactions/details_controller.dart';
import 'package:goodfellow/utils/constants/text_string.dart';
import 'package:goodfellow/utils/helpers/printerhepler.dart';

class PrintButton extends StatelessWidget {
  final bool isZesco;
  final TransactionController controller;
  final String businessName;

  const PrintButton({
    super.key,
    required this.isZesco,
    required this.controller,
    required this.businessName,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () {
          final receiptLog = GetStorage('receipt_logs');
          final txnId = controller.transactionId;

          final isReprint = receiptLog.read(txnId) != null;

          if (isZesco) {
            PrintHelper.printZescoUnits(
              token: controller.zescoToken.value,
              meterNumber: controller.phone.value,
              numberOfUnits: controller.units.value,
              amountPaid: controller.amount.value,
              vat: controller.totalVat.value,
              businessName: businessName,
              imageData: controller.deviceStorage.read("imageData") ?? "",
              address: controller.customerAddress.value,
              kwhAmount: controller.kwhAmount.value,
              customerName: controller.customerName.value,
              voucherSerial: controller.voucherSerial.value,
              date: controller.date.value,
            );
            Get.snackbar(
              'Print Receipt',
              'Printing Zesco units receipt...',
              snackPosition: SnackPosition.BOTTOM,
            );
          } else {
            PrintHelper.printReceipt(
              phone: controller.phone.value,
              amount: "${controller.currency.value} ${controller.amount.value}",
              paymentChannel: controller.paymentChannel.value,
              transactionId: controller.transactionId,
              transactionType: controller.txnType.value,
              date: controller.date.value,
              status: controller.status.value,
              businessName: businessName,
              imagePath: controller.deviceStorage.read("imagePath") ?? "",
              isReprint: isReprint,
            );
          }

          final currentCount = receiptLog.read(txnId) ?? 0;
          receiptLog.write(txnId, currentCount + 1);
        },
        child: Text(
          APPTexts.printReciept,
          style: Theme.of(
            context,
          ).textTheme.bodyLarge!.apply(color: Colors.white),
        ),
      ),
    );
  }
}
