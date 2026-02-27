import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:goodfellow/features/Home/screens/transaction_history/widgets/history_card.dart';
import 'package:goodfellow/utils/constants/sizes.dart';
import 'package:goodfellow/utils/helpers/helper_functions.dart';

class SummaryTransactions extends StatelessWidget {
  final List<dynamic> transactions;
  const SummaryTransactions({super.key, required this.transactions});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: transactions.length,
      separatorBuilder: (context, index) =>
          const SizedBox(height: APPSizes.spaceBtwItem),
      itemBuilder: (context, index) {
        final transaction = transactions[index];
        return AnimationConfiguration.staggeredList(
          position: index,
          duration: const Duration(milliseconds: 800),
          child: FadeInAnimation(
            child: HistoryCard(
              phoneNumber: transaction['customer'] ?? '',
              amount: transaction['amount'] ?? '',
              currency: transaction['currency'] ?? '',
              status: transaction['status'] ?? '',
              mode: transaction['payment_channel'] ?? '',
              txnId: transaction['id'].toString(),
              txnType: transaction['transaction_type'] ?? '',
              paymentIcon: APPHelperFunctions.getPaymentIcon(
                transaction['payment_channel'] ?? "",
              ),
              createdAt: transaction["created_at"] != null
                  ? APPHelperFunctions.parseIsoDate(
                      transaction["created_at"],
                    ).toString()
                  : "No Date Available",
              paymentChannel: transaction['payment_channel'] ?? "",
            ),
          ),
        );
      },
    );
  }
}
