import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:iconsax/iconsax.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:goodfellow/common/containers/app_rounded_container.dart';
import 'package:goodfellow/common/dialogs/custom_dialog.dart';
import 'package:goodfellow/common/widgets/loaders/loaders.dart';
import 'package:goodfellow/features/Home/screens/transaction_history/history.dart';
import 'package:goodfellow/features/Home/services/Bills/bill_services.dart';
import 'package:goodfellow/utils/constants/api_constants.dart';
import 'package:goodfellow/utils/constants/colors.dart';
import 'package:goodfellow/utils/constants/image_strings.dart';
import 'package:goodfellow/utils/constants/sizes.dart';
import 'package:goodfellow/utils/constants/text_string.dart';
import 'package:goodfellow/utils/helpers/helper_functions.dart';
import 'package:goodfellow/utils/http/http_client.dart';

class BillPurchaseController extends GetxController {
  static BillPurchaseController get instance => Get.find();

  final accountNumber = TextEditingController();
  final amount = TextEditingController();
  final String collectionChannel;
  final deviceStorage = GetStorage();

  final isLoading = false.obs;
  final accountDetails = Rxn<Map<String, dynamic>>();
  final transactionResult = Rxn<Map<String, dynamic>>();
  late String channelCode;

  BillPurchaseController({
    required this.collectionChannel,
    required this.channelCode,
  });

  GlobalKey<FormState> collectionFormKey = GlobalKey<FormState>();

  final deviceStoage = GetStorage();

  final BillPurchaseService billPurchaseService = BillPurchaseService();

  Future<void> fetchUserData() async {
    if (!collectionFormKey.currentState!.validate()) return;
    try {
      fetchUserDetails();
      var response = await billPurchaseService.getCustomerDetails(
        accountNumber: accountNumber.text,
        channelCode: channelCode,
      );

      if (response["status"] == 200) {
        if (Get.isDialogOpen == true) {
          Navigator.of(Get.context!).pop(); // Dismiss the dialog
        }

        confirmAndMakePurchase(
          "${response["data"]?["customer_name"] ?? ""} ${response["data"]?["family_name"] ?? ""}",
          false,
        );
      } else if (response["success"] == false) {
        Navigator.of(Get.context!).pop(); // Dismiss the dialog
        confirmAndMakePurchase(
          "${response["data"]?["customer_name"] ?? ""} ${response["data"]?["family_name"] ?? ""}",
          true,
        );
      }
    } catch (e) {
      if (Get.isDialogOpen == true) {
        Navigator.of(Get.context!).pop(); // Dismiss the dialog
      }

      APPLoaders.errorSnackBar(
        title: "Error!",
        message: e.toString().substring(10),
      );
    }
  }

  Future<void> confirmAndMakePurchase(String name, bool isFailed) async {
    bool? confirmed = await showGeneralDialog(
      barrierDismissible: true,
      barrierLabel: "Confirm Transaction",
      transitionDuration: const Duration(milliseconds: 300),
      context: Get.context!,
      pageBuilder: (context, animation, secondaryAnimation) {
        return Center(
          child: Material(
            color: Colors.transparent,
            child: Container(
              padding: const EdgeInsets.all(APPSizes.defaultSpace),
              margin: const EdgeInsets.symmetric(
                horizontal: APPSizes.spaceBtwItem,
              ),
              decoration: BoxDecoration(
                color: APPHelperFunctions.isDarkMode(context)
                    ? APPColors.dark
                    : Colors.white,
                borderRadius: BorderRadius.circular(15),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Center(
                    child: APPRoundedContainer(
                      backgroundColor: Colors.transparent,
                      child: Icon(
                        Iconsax.shield_tick,
                        color: APPColors.primary,
                      ),
                    ),
                  ),
                  const SizedBox(height: APPSizes.spaceBtwItem),
                  Center(
                    child: Text(
                      APPTexts.confirmTransaction,
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                  ),
                  const SizedBox(height: APPSizes.spaceBtwItem),
                  if (!isFailed)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Name:",
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                          style: Theme.of(context).textTheme.labelLarge,
                        ),
                        const SizedBox(width: APPSizes.spaceBtwItem / 2),
                        Text(
                          name,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                          style: Theme.of(
                            context,
                          ).textTheme.bodyMedium!.apply(fontWeightDelta: 2),
                        ),
                      ],
                    ),
                  if (isFailed)
                    Text(
                      "Failed to fetch user details, do you still want to proceed?",
                      overflow: TextOverflow.ellipsis,
                      maxLines: 3,
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodyMedium!.apply(
                        fontWeightDelta: 2,
                        color: Colors.red,
                      ),
                    ),
                  const SizedBox(height: APPSizes.spaceBtwItem / 2),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Amount:",
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                        style: Theme.of(context).textTheme.labelLarge,
                      ),
                      const SizedBox(width: APPSizes.spaceBtwItem / 2),
                      Text(
                        "K${amount.text.trim()}",
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                        style: Theme.of(
                          context,
                        ).textTheme.bodyMedium!.apply(fontWeightDelta: 2),
                      ),
                    ],
                  ),
                  const SizedBox(height: APPSizes.spaceBtwItem / 2),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Account Number:",
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                        style: Theme.of(context).textTheme.labelLarge,
                      ),
                      const SizedBox(width: APPSizes.spaceBtwItem / 2),
                      Text(
                        accountNumber.text.trim(),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                        style: Theme.of(
                          context,
                        ).textTheme.bodyMedium!.apply(fontWeightDelta: 2),
                      ),
                    ],
                  ),
                  const SizedBox(height: APPSizes.spaceBtwSections),
                  Text(
                    "Please review the above details before proceeding.",
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.labelSmall,
                  ),
                  const SizedBox(height: APPSizes.spaceBtwSections / 2.0),
                  if (isFailed)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(
                          height: 55,
                          width: 100,
                          child: ElevatedButton(
                            onPressed: () => {
                              Navigator.pop(context),
                              fetchUserData(),
                            },
                            style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                              side: const BorderSide(
                                width: 0,
                                color: Colors.transparent,
                              ),
                              backgroundColor: Colors.amber,
                            ),
                            child: const Text('Retry'),
                          ),
                        ),
                        SizedBox(
                          height: 55,
                          width: 100,
                          child: ElevatedButton(
                            onPressed: () => Navigator.of(context).pop(true),
                            style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                              side: const BorderSide(
                                width: 0,
                                color: Colors.transparent,
                              ),
                              backgroundColor: Colors.green,
                            ),
                            child: const Text('Proceed'),
                          ),
                        ),
                      ],
                    ),
                  if (!isFailed)
                    SizedBox(
                      height: 55,
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () => Navigator.of(context).pop(true),
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          side: const BorderSide(
                            width: 0,
                            color: Colors.transparent,
                          ),
                          backgroundColor: Colors.green,
                        ),
                        child: const Text('Confirm Payment'),
                      ),
                    ),
                  const SizedBox(height: APPSizes.spaceBtwItem),
                  SizedBox(
                    height: 55,
                    width: double.infinity,
                    child: TextButton(
                      onPressed: () => Navigator.of(context).pop(false),
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        side: const BorderSide(
                          width: 0,
                          color: Colors.transparent,
                        ),
                      ),
                      child: Text(
                        'Cancel',
                        style: Theme.of(
                          context,
                        ).textTheme.bodyMedium!.apply(color: Colors.red),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        return SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(0, 1), // Start the animation from the bottom
            end: Offset.zero, // Slide to the center
          ).animate(animation),
          child: FadeTransition(opacity: animation, child: child),
        );
      },
    );
    if (confirmed == true) {
      makePurchase();
    }
  }

  Future<void> makePurchase() async {
    if (!collectionFormKey.currentState!.validate()) return;

    showCustomDialog(
      title: "Initiating Payment",
      content: Column(
        children: [
          LoadingAnimationWidget.threeArchedCircle(
            color: APPColors.primary,
            size: 30,
          ),
        ],
      ),
    );
    var body = {
      "accountNumber": accountNumber.text.trim(),
      "amount": amount.text.trim(),
      "channel_code": channelCode,
    };

    final token = deviceStoage.read("token") ?? "";
    final businessName = deviceStoage.read("businessName") ?? "";

    var response = await APPHttpHelper.post(
      "",
      APIConstants.payBill,
      token,
      body,
    );

    try {
      if (response['success'] == true) {
        String vouchertoken = response["data"]?["token"]?.toString() ?? "N/A";
        String units = response["data"]?["units"]?.toString() ?? "0.0";
        String voucherSerial =
            response["data"]?["voucher_serial"]?.toString() ?? "N/A";
        String address =
            response["data"]?["customer_address"]?.toString() ?? "N/A";
        String name = response["data"]?["customer_name"]?.toString() ?? "N/A";
        String vat = response["data"]?["total_vat"]?.toString() ?? "0.0";
        String kwhAmount = response["data"]?["kwh_amount"]?.toString() ?? "0.0";
        String date = response["data"]?["created_at"]?.toString() ?? "";

        if (Get.isDialogOpen == true) {
          Navigator.of(Get.context!).pop(); // Dismiss the dialog
        }

        await Future.delayed(const Duration(milliseconds: 300));

        showCustomDialog(
          icon: Icons.check_circle,
          iconColor: Colors.green,
          showClose: true,
          title: "Purchase Successful",
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (vouchertoken != "N/A") ...[
                Text('Name: $name'),
                const SizedBox(height: APPSizes.spaceBtwItem / 2),
                Text('Address: $address'),
                const SizedBox(height: APPSizes.spaceBtwItem / 2),
                Text('Token: $vouchertoken'),
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
              if (vouchertoken == "N/A") ...[
                Text("Account Number: ${accountNumber.text.trim()}"),
                const SizedBox(height: APPSizes.spaceBtwItem / 2),
                Text("Amount: ${amount.text.trim()}"),
                const SizedBox(height: APPSizes.spaceBtwItem / 2),
                const Text('Your purchase was successful!'),
                const SizedBox(height: APPSizes.spaceBtwItem),
              ],
              if (vouchertoken != "N/A")
                const SizedBox(height: APPSizes.spaceBtwItem),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    printZescoUnits(
                      token: vouchertoken,
                      meterNumber: accountNumber.text,
                      numberOfUnits:
                          units, // Replace with actual number of units if available
                      amountPaid: amount.text,
                      vat: vat, // Replace with the actual VAT if available
                      businessName: businessName, // Add your business name
                      imageData: APPImages.lightAppLogo,
                      address: address,
                      kwhAmount: kwhAmount,
                      customerName: name,
                      voucherSerial:
                          voucherSerial, // Add your image byte array data
                      date: date,
                    );
                    Get.snackbar(
                      'Print Receipt',
                      'Printing receipt...',
                      snackPosition: SnackPosition.BOTTOM,
                    );
                  },
                  child: const Text('Print Receipt'),
                ),
              ),
              if (vouchertoken == "N/A")
                const SizedBox(height: APPSizes.spaceBtwItem),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Get.to(
                      transition: Transition.rightToLeft,
                      duration: const Duration(milliseconds: 500),
                      () => const TransactionHistory(),
                    );
                  },
                  child: const Text('Transaction History'),
                ),
              ),
            ],
          ),
        );
      } else if (response["success"] == false) {
        if (Get.isDialogOpen == true) {
          Navigator.of(Get.context!).pop(); // Dismiss the dialog
        }
        showCustomDialog(
          showClose: true,
          icon: Icons.error,
          iconColor: Colors.red,
          title: "Transaction Failed",
          content: Column(
            children: [Text(response["message"] ?? "Unknown Error")],
          ),
        );
      }
    } catch (e) {
      showCustomDialog(
        icon: Icons.error,
        iconColor: Colors.red,
        showClose: true,
        title: "Error",
        content: const Column(children: [Text("Something went wrong")]),
      );
    }

    //  print(response);
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
  }) {
    const platform = MethodChannel('com.example.goodfellow/print');
    final businessName = deviceStorage.read("businessName");
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

  @override
  void onClose() {
    accountNumber.dispose();
    amount.dispose();
    super.onClose();
  }
}
// Helper method to show the dialog

Future<void> fetchUserDetails() async {
  showCustomDialog(
    title: "Fetching user details",
    content: Column(
      children: [
        LoadingAnimationWidget.threeArchedCircle(
          color: APPColors.primary,
          size: 30,
        ),
      ],
    ),
  );
}
