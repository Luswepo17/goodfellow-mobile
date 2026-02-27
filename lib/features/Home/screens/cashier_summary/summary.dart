import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';
import 'package:goodfellow/common/appbar/appbar.dart';
import 'package:goodfellow/common/containers/app_rounded_container.dart';
import 'package:goodfellow/features/Home/screens/cashier_summary/summary_transactions.dart';
import 'package:goodfellow/utils/constants/colors.dart';
import 'package:goodfellow/utils/constants/sizes.dart';
import 'package:goodfellow/utils/helpers/helper_functions.dart';

class CashierSummaryPage extends StatefulWidget {
  final List<dynamic> transactions;

  const CashierSummaryPage({super.key, required this.transactions});

  @override
  State<CashierSummaryPage> createState() => _CashierSummaryPageState();
}

class _CashierSummaryPageState extends State<CashierSummaryPage> {
  late Map<String, Map<String, dynamic>> groupedByDay;
  String? selectedDate;
  String selectedFilter = 'All';

  @override
  void initState() {
    super.initState();
    groupedByDay = _groupTransactionsByDay(widget.transactions);
    if (groupedByDay.isNotEmpty) {
      selectedDate = groupedByDay.keys.first;
    }
  }

  Map<String, Map<String, dynamic>> _groupTransactionsByDay(
    List<dynamic> txns,
  ) {
    final Map<String, Map<String, dynamic>> grouped = {};

    for (var txn in txns) {
      if ((txn['transaction_type'] ?? '').toString().toLowerCase() !=
          'mobile money collection') {
        continue;
      }
      final createdAt = DateTime.parse(txn['created_at']);
      final rawDate = DateFormat('yyyy-MM-dd').format(createdAt);
      final displayDate = DateFormat('EEEE, d MMMM yyyy').format(createdAt);

      if (!grouped.containsKey(rawDate)) {
        grouped[rawDate] = {
          'display': displayDate,
          'transactions': <dynamic>[],
        };
      }

      grouped[rawDate]!['transactions'].add(txn);
    }

    return grouped;
  }

  @override
  Widget build(BuildContext context) {
    final allTxnsForDay = selectedDate != null
        ? groupedByDay[selectedDate]!['transactions'] as List
        : [];
    List txnsForDay;
    if (selectedFilter == 'Successful') {
      txnsForDay = allTxnsForDay
          .where(
            (txn) => txn['status'].toString().toLowerCase() == 'successful',
          )
          .toList();
    } else if (selectedFilter == 'Failed') {
      txnsForDay = allTxnsForDay
          .where((txn) => txn['status'].toString().toLowerCase() == 'failed')
          .toList();
    } else {
      txnsForDay = allTxnsForDay;
    }
    final successfulTxns = txnsForDay
        .where((txn) => txn['status'] == 'successful')
        .toList();
    final failedTxns = txnsForDay
        .where((txn) => txn['status'] == 'failed')
        .toList();

    // Calculate totals
    double totalAmount = 0.0;
    double successfulAmount = 0.0;
    double failedAmount = 0.0;
    String currency = '';

    for (var txn in txnsForDay) {
      try {
        final amountStr = txn['amount']?.toString() ?? '0';
        final amount = double.tryParse(amountStr) ?? 0.0;
        totalAmount += amount;

        if (currency.isEmpty && txn['currency'] != null) {
          currency = txn['currency'].toString();
        }

        if (txn['status']?.toString().toLowerCase() == 'successful') {
          successfulAmount += amount;
        } else if (txn['status']?.toString().toLowerCase() == 'failed') {
          failedAmount += amount;
        }
      } catch (e) {
        // Skip invalid amounts
      }
    }

    // Default currency if not found
    if (currency.isEmpty) {
      currency = 'ZMW';
    }

    return Scaffold(
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.only(
          left: APPSizes.defaultSpace,
          right: APPSizes.defaultSpace,
          bottom: APPSizes.defaultSpace,
        ),
        child: ElevatedButton(
          onPressed: () => _printSummary(txnsForDay),
          child: const Text("Print Summary"),
        ),
      ),
      appBar: APPAPPBar(
        showBackArrow: true,
        title: Text(
          "Cashier Summary",
          style: Theme.of(context).textTheme.headlineSmall,
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(APPSizes.defaultSpace),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Transactions for:"),
            const SizedBox(height: APPSizes.spaceBtwItem),
            DropdownButton<String>(
              dropdownColor: APPHelperFunctions.isDarkMode(context)
                  ? APPColors.darkContainer
                  : APPColors.lightContainer,
              value: selectedDate,
              isExpanded: true,
              items: groupedByDay.entries
                  .map(
                    (entry) => DropdownMenuItem<String>(
                      value: entry.key,
                      child: Text(entry.value['display']),
                    ),
                  )
                  .toList(),
              onChanged: (value) {
                setState(() {
                  selectedDate = value;
                });
              },
            ),
            const SizedBox(height: 16),
            DropdownButton<String>(
              dropdownColor: APPHelperFunctions.isDarkMode(context)
                  ? APPColors.darkContainer
                  : APPColors.lightContainer,
              value: selectedFilter,
              isExpanded: true,
              items: ['All', 'Successful', 'Failed']
                  .map(
                    (filter) => DropdownMenuItem<String>(
                      value: filter,
                      child: Text(filter),
                    ),
                  )
                  .toList(),
              onChanged: (value) {
                setState(() {
                  selectedFilter = value!;
                });
              },
            ),
            const SizedBox(height: 16),
            // Total Amount Section
            APPRoundedContainer(
              width: double.infinity,
              backgroundColor: APPColors.primary.withOpacity(0.1),
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Text(
                    "Total Amount",
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "$currency ${totalAmount.toStringAsFixed(2)}",
                    style: Theme.of(context).textTheme.headlineMedium!.apply(
                      color: APPColors.primary,
                      fontWeightDelta: 2,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: APPSizes.spaceBtwItem),
            // Transaction Counts and Amounts
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: APPRoundedContainer(
                    backgroundColor: Colors.green.withOpacity(0.1),
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      children: [
                        Text(
                          "$currency ${successfulAmount.toStringAsFixed(2)}",
                          style: Theme.of(context).textTheme.headlineSmall!
                              .apply(color: Colors.green, fontWeightDelta: 1),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          "${successfulTxns.length} Successful",
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: APPSizes.spaceBtwItem),
                Expanded(
                  child: APPRoundedContainer(
                    backgroundColor: Colors.red.withOpacity(0.1),
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      children: [
                        Text(
                          "$currency ${failedAmount.toStringAsFixed(2)}",
                          style: Theme.of(context).textTheme.headlineSmall!
                              .apply(color: Colors.red, fontWeightDelta: 1),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          "${failedTxns.length} Failed",
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: APPSizes.spaceBtwItem),
            // Total Transactions Count
            APPRoundedContainer(
              width: double.infinity,
              backgroundColor: APPColors.lightContainer,
              padding: const EdgeInsets.all(10),
              child: Column(
                children: [
                  Text(
                    "${txnsForDay.length}",
                    style: Theme.of(
                      context,
                    ).textTheme.headlineSmall!.apply(color: Colors.blue),
                  ),
                  const SizedBox(height: 2),
                  const Text("Total Transactions"),
                ],
              ),
            ),
            const SizedBox(height: APPSizes.spaceBtwSections),
            SummaryTransactions(transactions: txnsForDay),
          ],
        ),
      ),
    );
  }

  void _printSummary(List<dynamic> txns) async {
    final deviceStorage = GetStorage();

    final businessName = deviceStorage.read("businessName") ?? "";
    final branchName = deviceStorage.read("branchName") ?? '';
    final userName = deviceStorage.read("userName") ?? '';

    // Apply filter before mapping
    List<dynamic> filteredTxns;
    if (selectedFilter == 'Successful') {
      filteredTxns = txns
          .where(
            (txn) => txn['status'].toString().toLowerCase() == 'successful',
          )
          .toList();
    } else if (selectedFilter == 'Failed') {
      filteredTxns = txns
          .where((txn) => txn['status'].toString().toLowerCase() == 'failed')
          .toList();
    } else {
      filteredTxns = txns;
    }

    final transactionsToPrint = filteredTxns
        .map(
          (txn) => {
            'transactionId': txn['id'].toString(),
            'amount': txn['amount'] ?? "0.00",
            'status': txn['status'].toString(),
            'date': APPHelperFunctions.parseIsoDate(
              txn['created_at'] ?? "2025-01-01T11:00:00.000000Z",
            ),
            'cashier': userName,
            'businessName': businessName,
            'branchName': branchName,
            'network': txn["payment_channel"] ?? '',
          },
        )
        .toList();

    try {
      const platform = MethodChannel('com.example.goodfellow/print');
      await platform.invokeMethod('printDailySummary', transactionsToPrint);
      Get.snackbar('Printing', 'Sending daily summary to printer');
    } catch (e) {
      Get.snackbar('Print Failed', 'Error: $e');
    }
  }
}
