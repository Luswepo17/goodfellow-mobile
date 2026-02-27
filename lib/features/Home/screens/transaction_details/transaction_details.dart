import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:goodfellow/common/widgets/error/systemerror.dart';
import 'package:goodfellow/common/widgets/loaders/loaders.dart';
import 'package:goodfellow/features/Home/screens/collections/collections_screen.dart';
import 'package:goodfellow/utils/constants/api_constants.dart';
import 'package:goodfellow/utils/constants/colors.dart';
import 'package:goodfellow/utils/constants/image_strings.dart';
import 'package:goodfellow/utils/constants/sizes.dart';
import 'package:goodfellow/utils/constants/text_string.dart';
import 'package:goodfellow/utils/helpers/helper_functions.dart';
import 'package:goodfellow/utils/helpers/network_manager.dart';
import 'package:goodfellow/utils/http/http_client.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

class TransactionDetails extends StatefulWidget {
  final String? transactionID;
  const TransactionDetails({super.key, this.transactionID});

  @override
  State<TransactionDetails> createState() => _TransactionDetailsState();
}

class _TransactionDetailsState extends State<TransactionDetails> {
  late bool isLoading = true;
  late bool isconnected = true;
  late String? merchant = '';
  late String? transactionID = '';
  late String? customerNumber = '';
  late String? network = '';
  late String? amount = '';
  late String? charge = '';
  late String? total = '';
  late String? status = '';
  late String? date = '';
  late String? time = '';
  late String? operator = '';
  late String? branch = '';
  late String? state = '';
  late String? naration = '';
  static const printAction = MethodChannel(
    "com.digitalpaygo.merchantapp/printAction",
  );
  final deviceStorage = GetStorage();

  Future<void> getData() async {
    final isConnected = await NetworkManager.instance.isConnected();
    if (!isConnected) {
      setState(() {
        isconnected = false;
      });
      APPLoaders.errorSnackBar(
        title: "No Internet!",
        message: "Please check your internet.",
      );
      return;
    }
    String token = deviceStorage.read("token");
    try {
      var res = await APPHttpHelper.get(
        "",
        "${APIConstants.transactiondetailsendpoint}${widget.transactionID}",
        token,
      );
      if (res["status"] == "Timeout") {
        APPLoaders.errorSnackBar(
          title: "Oh snap!",
          message: "Something went wrong",
        );
        Get.offAll(() => const SystemError());
      } else {
        setState(() {
          operator = res['fullname'];
          merchant = res['merchantName'];
          branch = res['branch'];
          transactionID = res["transactionid"];
          amount = res["collectedAmount"];
          charge = res["collectionCharge"];
          network = res["mno"];
          customerNumber = res["phonenumber"];
          date = res["date"];
          time = res["time"];
          total = res["total"];
          status = res["status"];
          naration = res["narration"];
          isLoading = false;
        });
      }
    } catch (exception, stackTrace) {
      await Sentry.captureException(exception, stackTrace: stackTrace);
      APPLoaders.errorSnackBar(
        title: "Oh snap!",
        message: exception.toString().substring(11),
      );
      Get.offAll(() => const SystemError());
    }
  }

  @override
  void initState() {
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    final dark = APPHelperFunctions.isDarkMode(context);
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: dark ? APPColors.white : Colors.black, //change your color here
        ),
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            onPressed: () => Get.offAll(() => const CollectionScreen(mode: '')),
            icon: const Icon(CupertinoIcons.clear),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(APPSizes.defaultSpace),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                isLoading
                    ? Center(
                        child: CircularProgressIndicator(
                          color: dark ? APPColors.white : Colors.black,
                        ),
                      )
                    : Column(
                        children: [
                          SizedBox(
                            width: 120,
                            child: Image.asset(
                              fit: BoxFit.cover,
                              APPImages.colorAppLogo,
                            ),
                          ),
                          Text(
                            status == "Successful"
                                ? "Purchase Successful"
                                : "Purchase Failed",
                            style: Theme.of(context).textTheme.headlineMedium,
                          ),
                          Center(
                            child: Padding(
                              padding: const EdgeInsets.only(
                                top: 0.0,
                                left: 5.0,
                                right: 5.0,
                                bottom: 20,
                              ),
                              child: Container(
                                width: 600,
                                height: 400,
                                decoration: BoxDecoration(
                                  color: !dark ? APPColors.white : Colors.black,
                                  borderRadius: BorderRadius.circular(5.0),
                                  boxShadow: [
                                    BoxShadow(
                                      offset: const Offset(0, 1),
                                      blurRadius: 5,
                                      color: !dark
                                          ? Colors.black.withAlpha(
                                              (0.3 * 255).toInt(),
                                            )
                                          : Colors.white24,
                                    ),
                                  ],
                                ),
                                child: Column(
                                  children: [
                                    Container(
                                      height: 100,
                                      decoration: const BoxDecoration(
                                        color: APPColors.primary,
                                        borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(5),
                                          topRight: Radius.circular(5),
                                        ),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(10.0),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Container(
                                                  height: 25,
                                                  width: 160,
                                                  decoration: BoxDecoration(
                                                    color: !dark
                                                        ? APPColors.white
                                                        : Colors.black,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                          5,
                                                        ),
                                                  ),
                                                  child: Center(
                                                    child: Text(
                                                      transactionID!,
                                                      style: Theme.of(
                                                        context,
                                                      ).textTheme.bodyLarge,
                                                    ),
                                                  ),
                                                ),
                                                const SizedBox(height: 5),
                                                Text(
                                                  "Total Amount",
                                                  style: Theme.of(
                                                    context,
                                                  ).textTheme.bodyMedium,
                                                ),
                                                Text(
                                                  'K${amount!}',
                                                  style: Theme.of(
                                                    context,
                                                  ).textTheme.bodyMedium,
                                                ),
                                              ],
                                            ),
                                            SizedBox(
                                              width: 60,
                                              child: Image.asset(
                                                fit: BoxFit.cover,
                                                color: APPColors.white,
                                                APPImages.colorAppLogo,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 5,
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                          top: 20.0,
                                          left: 10,
                                          right: 10,
                                        ),
                                        child: Column(
                                          children: [
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Expanded(
                                                  flex: 1,
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        "Payment Type",
                                                        style: Theme.of(
                                                          context,
                                                        ).textTheme.bodyMedium,
                                                      ),
                                                      const SizedBox(height: 2),
                                                      Text(
                                                        "Mobile Payment",
                                                        style: Theme.of(
                                                          context,
                                                        ).textTheme.bodyMedium,
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                Expanded(
                                                  flex: 1,
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        "Phone Number",
                                                        style: Theme.of(
                                                          context,
                                                        ).textTheme.bodyMedium,
                                                      ),
                                                      const SizedBox(height: 2),
                                                      Text(
                                                        "+260${customerNumber!}",
                                                        style: Theme.of(
                                                          context,
                                                        ).textTheme.bodyMedium,
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                            const SizedBox(height: 20),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Expanded(
                                                  flex: 1,
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        "Date",
                                                        style: Theme.of(
                                                          context,
                                                        ).textTheme.bodyMedium,
                                                      ),
                                                      const SizedBox(height: 2),
                                                      Text(
                                                        date!,
                                                        style: Theme.of(
                                                          context,
                                                        ).textTheme.bodyMedium,
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                Expanded(
                                                  flex: 1,
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        "Time",
                                                        style: Theme.of(
                                                          context,
                                                        ).textTheme.bodyMedium,
                                                      ),
                                                      const SizedBox(height: 2),
                                                      Text(
                                                        time!,
                                                        style: Theme.of(
                                                          context,
                                                        ).textTheme.bodyMedium,
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                            const SizedBox(height: 30),
                                            const DottedLine(
                                              dashLength: 10,
                                              dashColor: Colors.grey,
                                              dashGapLength: 10,
                                            ),
                                            const SizedBox(height: 20),
                                            Center(
                                              child: Text(
                                                status == "Successful"
                                                    ? "Approved"
                                                    : "Declined",
                                                style: Theme.of(
                                                  context,
                                                ).textTheme.bodyMedium,
                                              ),
                                            ),
                                            const SizedBox(height: 10),
                                            Center(
                                              child: Text(
                                                branch!,
                                                style: Theme.of(
                                                  context,
                                                ).textTheme.bodyMedium,
                                              ),
                                            ),
                                            const SizedBox(height: 2),
                                            Center(
                                              child: Text(
                                                operator!,
                                                style: Theme.of(
                                                  context,
                                                ).textTheme.bodyMedium,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: () => {
                                if (status == "Successful")
                                  {state = "Approved"}
                                else
                                  {state = "Declined"},
                                printDoc(
                                  merchant!,
                                  date!,
                                  time!,
                                  transactionID!,
                                  network!,
                                  amount!,
                                  charge!,
                                  total!,
                                  operator!,
                                  state!,
                                  "Customer Copy",
                                  naration!,
                                ),
                              },
                              child: const Text(APPTexts.printCustomer),
                            ),
                          ),
                          const SizedBox(height: APPSizes.spaceBtwItem),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: () => {
                                if (status == "Successful")
                                  {state = "Approved"}
                                else
                                  {state = "Declined"},
                                printDoc(
                                  merchant!,
                                  date!,
                                  time!,
                                  transactionID!,
                                  network!,
                                  amount!,
                                  charge!,
                                  total!,
                                  operator!,
                                  state!,
                                  "Merchant Copy",
                                  naration!,
                                ),
                              },
                              child: const Text(APPTexts.printMerchant),
                            ),
                          ),
                        ],
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> printDoc(
    String shopname,
    String date,
    String time,
    String transactionID,
    String network,
    String amount,
    String charge,
    String total,
    String operator,
    String state,
    String copyType,
    String narration,
  ) async {
    final arguments = {
      'shopname': shopname,
      'date': date,
      'time': time,
      'transactionid': transactionID,
      'network': network,
      'amount': amount,
      'charge': charge,
      'total': total,
      'operator': operator,
      'state': state,
      'copyType': copyType,
      'narration': narration,
    };

    await printAction.invokeMethod("printReceipt", arguments);
  }
}
