import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:goodfellow/common/appbar/appbar.dart';
import 'package:goodfellow/common/text/offline_text.dart';
import 'package:goodfellow/features/Home/controllers/transactions/details_controller.dart';
import 'package:goodfellow/features/Home/screens/transaction_history/widgets/basic_payment_details.dart';
import 'package:goodfellow/features/Home/screens/transaction_history/widgets/loading_card.dart';
import 'package:goodfellow/features/Home/screens/transaction_history/widgets/print_button.dart';
import 'package:goodfellow/features/Home/screens/transaction_history/widgets/transaction_header.dart';
import 'package:goodfellow/features/Home/screens/transaction_history/widgets/zesco_payment_details.dart';
import 'package:goodfellow/utils/constants/colors.dart';
import 'package:goodfellow/utils/constants/sizes.dart';
import 'package:goodfellow/utils/constants/text_string.dart';
import 'package:goodfellow/utils/helpers/helper_functions.dart';

class TransactionDetails extends StatelessWidget {
  final String transactionId;

  const TransactionDetails({super.key, required this.transactionId});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(
      TransactionController(transactionId: transactionId),
    );
    final businessName = controller.deviceStorage.read("businessName") ?? "";
    final dark = APPHelperFunctions.isDarkMode(context);

    return SafeArea(
      child: Scaffold(
        appBar: APPAPPBar(
          showBackArrow: true,
          title: Text(
            APPTexts.transactionDetails,
            style: Theme.of(context).textTheme.headlineSmall,
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(APPSizes.defaultSpace),
          child: SingleChildScrollView(
            child: Column(
              children: [
                const OfflineText(),
                Obx(
                  () => controller.isLoading.value
                      ? const LoadingDetailsCard()
                      : Card(
                          color: dark ? APPColors.dark : APPColors.lightgrey,
                          elevation: 1,
                          child: Padding(
                            padding: const EdgeInsets.all(
                              APPSizes.defaultSpace,
                            ),
                            child: Column(
                              children: [
                                TransactionHeader(
                                  status: controller.status.value,
                                ),
                                const Divider(),
                                const SizedBox(
                                  height: APPSizes.spaceBtwSections,
                                ),
                                PaymentDetails(
                                  phone: controller.phone.value,
                                  currency: controller.currency.value,
                                  amount: controller.amount.value,
                                  paymentChannel:
                                      controller.paymentChannel.value,
                                  transactionId: transactionId,
                                  txnType: controller.txnType.value,
                                  date: controller.date.value,
                                ),
                                ZescoDetails(
                                  zescoToken: controller.zescoToken.value,
                                  units: controller.units.value,
                                  customerName: controller.customerName.value,
                                  customerAddress:
                                      controller.customerAddress.value,
                                  kwhAmount: controller.kwhAmount.value,
                                  totalVat: controller.totalVat.value,
                                  voucherSerial: controller.voucherSerial.value,
                                ),
                                const SizedBox(
                                  height: APPSizes.spaceBtwSections,
                                ),
                                PrintButton(
                                  isZesco:
                                      controller.zescoToken.value.isNotEmpty,
                                  controller: controller,
                                  businessName: businessName,
                                ),
                              ],
                            ),
                          ),
                        ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
