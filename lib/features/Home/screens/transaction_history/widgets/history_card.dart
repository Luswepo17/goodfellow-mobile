import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:goodfellow/common/containers/app_rounded_container.dart';
import 'package:goodfellow/common/images/app_rounded_image.dart';
import 'package:goodfellow/features/Home/screens/transaction_history/details.dart';
import 'package:goodfellow/utils/constants/colors.dart';
import 'package:goodfellow/utils/constants/sizes.dart';
import 'package:goodfellow/utils/helpers/helper_functions.dart';

class HistoryCard extends StatelessWidget {
  const HistoryCard({
    super.key,
    required this.phoneNumber,
    required this.amount,
    required this.currency,
    required this.status,
    required this.mode,
    required this.txnId,
    required this.txnType,
    required this.paymentIcon,
    required this.createdAt,
    required this.paymentChannel,
  });

  final String phoneNumber;
  final String amount;
  final String currency;
  final String status;
  final String mode;
  final String txnId;
  final String txnType;
  final IconData paymentIcon;
  final String createdAt;
  final String paymentChannel;

  @override
  Widget build(BuildContext context) {
    final dark = APPHelperFunctions.isDarkMode(context);

    return GestureDetector(
      onTap: () => Get.to(
        transition: Transition.rightToLeft,
        duration: const Duration(milliseconds: 500),
        () => TransactionDetails(transactionId: txnId),
      ),
      child: Card(
        color: dark ? APPColors.dark : APPColors.white,
        elevation: 3,
        child: Container(
          height: APPHelperFunctions.screenHeight() / 6.5,
          padding: const EdgeInsets.all(APPSizes.defaultSpace / 3),
          child: Row(
            children: [
              APPRoundedContainer(
                backgroundColor: dark ? APPColors.darkerGrey : APPColors.grey,
                height: 40,
                width: 40,
                child: APPRoundedImage(
                  imageUrl: APPHelperFunctions.getPaymentImageString(
                    paymentChannel,
                  ),
                ), // Use the passed payment icon
              ),
              const SizedBox(width: APPSizes.spaceBtwItem),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      txnType == "Bill Payment"
                          ? "Account Number: $phoneNumber"
                          : "Phone Number: $phoneNumber",
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                      style: Theme.of(context).textTheme.labelMedium!.apply(
                        color: dark ? APPColors.white : APPColors.black,
                      ),
                    ),
                    Text(
                      "Amount: $currency ${double.parse(amount).toStringAsFixed(3)}",
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                      style: Theme.of(context).textTheme.labelMedium!.apply(
                        color: dark ? APPColors.white : APPColors.black,
                      ),
                    ),
                    Text(
                      "Transaction ID: $txnId",
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                      style: Theme.of(context).textTheme.labelMedium!.apply(
                        color: dark ? APPColors.white : APPColors.black,
                      ),
                    ),
                    SizedBox(
                      width: APPHelperFunctions.screenWidth() / 2,
                      child: const Divider(),
                    ),
                    Row(
                      children: [
                        Flexible(
                          child: Text(
                            txnType,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context).textTheme.bodySmall!.apply(
                              color: dark ? APPColors.white : APPColors.black,
                            ),
                          ),
                        ),
                        const SizedBox(width: APPSizes.spaceBtwItem / 1.5),
                        Container(color: Colors.grey, height: 15, width: 1),
                        const SizedBox(width: APPSizes.spaceBtwItem / 1.5),
                        Row(
                          children: [
                            Container(
                              height: 8,
                              width: 8,
                              decoration: BoxDecoration(
                                color: status == "successful"
                                    ? Colors.green
                                    : status == "pending"
                                    ? APPColors.warning
                                    : Colors.red,
                                borderRadius: const BorderRadius.all(
                                  Radius.circular(10),
                                ),
                              ),
                            ),
                            const SizedBox(width: APPSizes.spaceBtwItem / 2),
                            Text(
                              status.toUpperCase(),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                              style: Theme.of(context).textTheme.bodySmall!
                                  .apply(
                                    color: status == "successful"
                                        ? Colors.green
                                        : status == "pending"
                                        ? APPColors.warning
                                        : Colors.red,
                                  ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
