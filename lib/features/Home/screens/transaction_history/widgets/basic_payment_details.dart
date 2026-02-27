import 'package:flutter/material.dart';
import 'package:goodfellow/features/Home/screens/transaction_history/widgets/detail_text.dart';
import 'package:goodfellow/utils/constants/sizes.dart';
import 'package:goodfellow/utils/constants/text_string.dart';

class PaymentDetails extends StatelessWidget {
  final String phone;
  final String currency;
  final String amount;
  final String paymentChannel;
  final String transactionId;
  final String txnType;
  final String date;

  const PaymentDetails({
    super.key,
    required this.phone,
    required this.currency,
    required this.amount,
    required this.paymentChannel,
    required this.transactionId,
    required this.txnType,
    required this.date,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          APPTexts.paymentDetails,
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        const SizedBox(height: APPSizes.spaceBtwItem),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const DetailText(text: APPTexts.phoneNumber),
            DetailText(text: phone),
          ],
        ),
        const SizedBox(height: APPSizes.spaceBtwItem / 2),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const DetailText(text: APPTexts.amount),
            DetailText(
              text: "$currency ${double.parse(amount).toStringAsFixed(3)}",
            ),
          ],
        ),
        const SizedBox(height: APPSizes.spaceBtwItem / 2),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const DetailText(text: APPTexts.paymentChannel),
            DetailText(text: paymentChannel),
          ],
        ),
        const SizedBox(height: APPSizes.spaceBtwItem / 2),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const DetailText(text: APPTexts.transactionId),
            DetailText(text: transactionId),
          ],
        ),
        const SizedBox(height: APPSizes.spaceBtwItem / 2),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const DetailText(text: APPTexts.transactiontype),
            DetailText(text: txnType),
          ],
        ),
        const SizedBox(height: APPSizes.spaceBtwItem / 2),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const DetailText(text: APPTexts.date),
            DetailText(text: date),
          ],
        ),
      ],
    );
  }
}
