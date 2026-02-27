import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:iconsax/iconsax.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:goodfellow/common/appbar/appbar.dart';
import 'package:goodfellow/common/text/offline_text.dart';
import 'package:goodfellow/common/widgets/loaders/loaders.dart';
import 'package:goodfellow/features/Home/screens/cashier_summary/summary.dart';
import 'package:goodfellow/features/Home/screens/home/home.dart';
import 'package:goodfellow/features/Home/screens/session_exp/session.dart';
import 'package:goodfellow/features/Home/screens/transaction_history/widgets/history_card.dart';
import 'package:goodfellow/utils/constants/api_constants.dart';
import 'package:goodfellow/utils/constants/colors.dart';
import 'package:goodfellow/utils/constants/sizes.dart';
import 'package:goodfellow/utils/constants/text_string.dart';
import 'package:goodfellow/utils/helpers/helper_functions.dart';
import 'package:goodfellow/utils/http/http_client.dart';

class TransactionHistory extends StatefulWidget {
  const TransactionHistory({super.key});

  @override
  State<TransactionHistory> createState() => _TransactionHistoryState();
}

class _TransactionHistoryState extends State<TransactionHistory> {
  final deviceStorage = GetStorage();
  final List<dynamic> transactions = [];
  late bool loading = true;
  String errorMessage = '';

  String selectedStatus = 'All';

  List<dynamic> get filteredTransactions {
    if (selectedStatus == 'All') return transactions;
    return transactions
        .where(
          (t) =>
              (t['status'] ?? '').toString().toLowerCase() ==
              selectedStatus.toLowerCase(),
        )
        .toList();
  }

  Future<void> getHistory() async {
    setState(() {
      loading = true;
      errorMessage = "";
    });
    final token = deviceStorage.read("token");

    try {
      final res = await APPHttpHelper.get(
        "",
        "",
        // APIConstants.transactionhistoryendpoint,
        token,
      ).timeout(const Duration(seconds: 60));

      print(res);
      if (res["status"] == "success") {
        setState(() {
          transactions.clear();
          transactions.addAll(
            res["transactions"],
          ); // Add transactions to the list
          loading = false;
        });
      } else if (res["code"] == "401") {
        setState(() {
          loading = false;
        });
        Get.to(
          transition: Transition.rightToLeft,
          duration: const Duration(milliseconds: 500),
          () => const SessionExpiredScreen(),
        );
      } else {
        setState(() {
          loading = false;
          errorMessage = "Failed to load transactions!";
        });

        APPLoaders.errorSnackBar(
          title: "Error!",
          message: "Failed to retrieve transactions!",
        );
      }
    } catch (e) {
      setState(() {
        loading = false;
        errorMessage = "Failed to load transactions!";
        APPLoaders.errorSnackBar(
          title: "Error!",
          message: "Something went wrong!",
        );
      });
    }
  }

  @override
  void initState() {
    super.initState();
    getHistory();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        bottomNavigationBar: Padding(
          padding: const EdgeInsetsGeometry.only(
            left: APPSizes.defaultSpace,
            right: APPSizes.defaultSpace,
            bottom: APPSizes.defaultSpace,
          ),
          child: SizedBox(
            child: ElevatedButton(
              onPressed: () => {
                Get.to(() => CashierSummaryPage(transactions: transactions)),
              },
              child: const Text("View Summary"),
            ),
          ),
        ),
        appBar: APPAPPBar(
          showBackArrow: true,
          onBackPressed: () => {Get.to(() => const HomeScreen())},
          title: Text(
            APPTexts.transactionHistoryTitle,
            style: Theme.of(context).textTheme.headlineSmall,
          ),
        ),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(APPSizes.defaultSpace),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const OfflineText(),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Filter By",
                          style: Theme.of(context).textTheme.labelMedium,
                        ),
                        DropdownButton<String>(
                          dropdownColor: APPHelperFunctions.isDarkMode(context)
                              ? APPColors.darkContainer
                              : APPColors.lightContainer,
                          value: selectedStatus,
                          items: ['All', 'Successful', 'Failed', 'Pending']
                              .map<DropdownMenuItem<String>>(
                                (status) => DropdownMenuItem<String>(
                                  value: status,
                                  child: Text(status),
                                ),
                              )
                              .toList(),
                          onChanged: (value) {
                            if (value != null) {
                              setState(() {
                                selectedStatus = value;
                              });
                            }
                          },
                        ),
                      ],
                    ),
                    TextButton(
                      onPressed: getHistory,
                      child: Row(
                        children: [
                          Text(
                            "Refresh",
                            style: Theme.of(context).textTheme.labelMedium,
                          ),
                          const SizedBox(width: 4),
                          const Icon(
                            Iconsax.refresh,
                            color: APPColors.darkGrey,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: APPSizes.spaceBtwSections),
                loading
                    ? Center(
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(
                                top: APPSizes.appBarHeight,
                              ),
                              child: LoadingAnimationWidget.threeArchedCircle(
                                color: APPColors.primary,
                                size: APPHelperFunctions.screenWidth() / 4,
                              ),
                            ),
                          ],
                        ),
                      )
                    : errorMessage.isNotEmpty
                    ? Center(
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(
                                top: APPSizes.spaceBtwSections,
                              ),
                              child: Text(
                                errorMessage,
                                style: Theme.of(context).textTheme.bodyLarge,
                              ),
                            ),
                            const SizedBox(height: APPSizes.spaceBtwItem),
                            TextButton(
                              style: TextButton.styleFrom(
                                backgroundColor: APPColors.primary,
                              ),
                              onPressed: getHistory,
                              child: Text(
                                "Retry",
                                style: Theme.of(context).textTheme.bodyLarge,
                              ),
                            ),
                          ],
                        ),
                      )
                    : filteredTransactions.isEmpty
                    ? Center(
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(
                                top: APPSizes.appBarHeight,
                              ),
                              child: Text(
                                "No Transactions found!",
                                style: Theme.of(
                                  context,
                                ).textTheme.headlineSmall!.apply(),
                              ),
                            ),
                          ],
                        ),
                      )
                    : Expanded(
                        child: transactions.isEmpty
                            ? Center(
                                child: LoadingAnimationWidget.threeArchedCircle(
                                  size: APPHelperFunctions.screenWidth() / 3,
                                  color: APPColors.primary,
                                ),
                              )
                            : ListView.separated(
                                itemCount: filteredTransactions.length,
                                separatorBuilder: (context, index) =>
                                    const SizedBox(
                                      height: APPSizes.spaceBtwItem,
                                    ),
                                itemBuilder: (context, index) {
                                  final transaction =
                                      filteredTransactions[index];
                                  return AnimationConfiguration.staggeredList(
                                    position: index,
                                    duration: const Duration(milliseconds: 800),
                                    child: FadeInAnimation(
                                      child: HistoryCard(
                                        paymentChannel:
                                            transaction['payment_channel'] ??
                                            "",
                                        phoneNumber:
                                            transaction['customer'] ?? '',
                                        amount: transaction['amount'] ?? '',
                                        currency: transaction['currency'] ?? '',
                                        status: transaction['status'] ?? '',
                                        mode:
                                            transaction['payment_channel'] ??
                                            '',
                                        txnId: transaction['id'].toString(),
                                        txnType:
                                            transaction['transaction_type'] ??
                                            '',
                                        paymentIcon:
                                            APPHelperFunctions.getPaymentIcon(
                                              transaction['payment_channel'] ??
                                                  "",
                                            ),
                                        createdAt:
                                            transaction["created_at"] != null
                                            ? APPHelperFunctions.parseIsoDate(
                                                transaction["created_at"],
                                              ).toString()
                                            : "No Date Available",
                                      ),
                                    ),
                                  );
                                },
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
