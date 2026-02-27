import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:goodfellow/common/dialogs/custom_dialog.dart';
import 'package:goodfellow/common/dialogs/packages/package_dialogs.dart';
import 'package:goodfellow/common/widgets/loaders/loaders.dart';
import 'package:goodfellow/features/Home/services/packages/package_service.dart';
import 'package:goodfellow/utils/constants/colors.dart';
import 'package:goodfellow/utils/constants/sizes.dart';

class PackagesController extends GetxController {
  static PackagesController get instance => Get.find();

  final accountNumber = TextEditingController();

  late String packageCode;
  late String amount;
  late String packageName;
  late String channelCode;

  PackagesController({
    required this.packageCode,
    required this.amount,
    required this.packageName,
    required this.channelCode,
  });

  GlobalKey<FormState> packagesFormKey = GlobalKey<FormState>();
  final deviceStorage = GetStorage();
  final PackageService packageService = PackageService();

  Future<void> fetchUserData() async {
    try {
      fetchUserDetails();
      final response = await packageService.fetchCustomerDetails(
        accountNumber.text,
        channelCode,
      );

      if (response["status"] == 200) {
        Navigator.of(Get.context!).pop();
        confirmAndMakePurchase("${response["data"]?["names"] ?? ""} ", false);
      } else if (response["success"] == false) {
        Navigator.of(Get.context!).pop(); // Dismiss the dialog
        confirmAndMakePurchase("${response["data"]?["names"] ?? ""}", true);
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
    bool? confirmed = await showConfirmationDialog(
      name,
      accountNumber.text,
      amount,
      packageName,
      isFailed,
    );
    if (confirmed == true) {
      makePackagePurchase();
    }
  }

  Future<void> makePackagePurchase() async {
    if (!packagesFormKey.currentState!.validate()) return;
    showCustomDialog(
      title: "Initiating Payment",
      content: Column(
        children: [
          const SizedBox(height: APPSizes.spaceBtwItem),
          LoadingAnimationWidget.threeArchedCircle(
            color: APPColors.primary,
            size: 30,
          ),
        ],
      ),
    );

    var response = await packageService.makePackagePurchase(
      accountNumber.text,
      packageCode,
    );

    Get.back(); // Close loading dialog

    if (response['status'] == 200) {
      showCustomDialog(
        icon: Icons.check_circle,
        iconColor: Colors.green,
        title: "Success",
        content: Column(children: [Text(response["messsage"])]),
      );
    } else {
      showCustomDialog(
        icon: Icons.error,
        iconColor: Colors.red,
        title: "Error",
        content: Column(children: [Text(response["messsage"])]),
      );
    }
  }
}

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
