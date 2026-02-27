import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:goodfellow/common/widgets/loaders/loaders.dart';
import 'package:goodfellow/features/authentication/controllers/sign_in/sign_in_controller.dart';
import 'package:goodfellow/features/authentication/screens/login/login.dart';
import 'package:goodfellow/utils/constants/api_constants.dart';
import 'package:goodfellow/utils/helpers/helper_functions.dart';
import 'package:goodfellow/utils/http/http_client.dart';
import 'package:iconsax/iconsax.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:goodfellow/features/authentication/controllers/setup/setup_controller.dart';
import 'package:goodfellow/utils/constants/colors.dart';
import 'package:goodfellow/utils/constants/sizes.dart';
import 'package:goodfellow/utils/constants/text_string.dart';
import 'package:goodfellow/utils/validators/validation.dart';
import 'package:package_info_plus/package_info_plus.dart';

class SetupForm extends StatefulWidget {
  const SetupForm({super.key});

  @override
  State<SetupForm> createState() => _SetupFormState();
}

class _SetupFormState extends State<SetupForm> {
  final List<dynamic> phoneTypes = [];
  late bool loading = true;
  String errorMessage = '';
  final deviceStorage = GetStorage();

  @override
  void initState() {
    super.initState();
    getPhoneTypes();
  }

  Future<void> getPhoneTypes() async {
    setState(() {
      loading = true;
      errorMessage = "";
    });
    final token = deviceStorage.read("token");

    try {
      final res = await APPHttpHelper.get(
        APIConstants.publicUrl,
        APIConstants.getPhoneTypesendpoint,
        token,
      ).timeout(const Duration(seconds: 60));

      print("Phone tYPES: $res");
      if (res["status"] == "success") {
        setState(() {
          phoneTypes.clear();
          phoneTypes.addAll(
            res["data"]?["types"],
          ); // Add transactions to the list
          loading = false;
        });
      } else if (res["code"] == "401") {
        setState(() {
          loading = false;
        });
        // Get.to(
        //   transition: Transition.rightToLeft,
        //   duration: const Duration(milliseconds: 500),
        //   // () => const SessionExpiredScreen(),
        // );
      } else {
        setState(() {
          loading = false;
          errorMessage = "Failed to load phone types!";
        });

        APPLoaders.errorSnackBar(
          title: "Error!",
          message: "Failed to retrieve phone types!",
        );
      }
    } catch (e) {
      print("Exception $e");
      setState(() {
        loading = false;
        errorMessage = "Failed to load phone types!";
        APPLoaders.errorSnackBar(
          title: "Error!",
          message: "Something went wrong!",
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(SetupController());
    return Form(
      key: controller.setupFormKey,
      child: Column(
        children: [
          //Drop down for phone type_id
          Obx(() {
            final controller = SetupController.instance;

            return DropdownButtonFormField<String>(
              value: controller.selectedPhoneTypeId.value.isEmpty
                  ? null
                  : controller.selectedPhoneTypeId.value,
              items: phoneTypes.map<DropdownMenuItem<String>>((type) {
                return DropdownMenuItem<String>(
                  value: type["type_id"],
                  child: Text("${type["name"]} (${type["model"]})"),
                );
              }).toList(),
              onChanged: (value) {
                final selected = phoneTypes.firstWhere(
                  (type) => type["type_id"] == value,
                );

                controller.selectedPhoneTypeId.value = value!;
                controller.selectedPrice.value = selected["price"].toString();
                controller.priceController.text = selected["price"].toString();
              },
              decoration: const InputDecoration(
                labelText: "Select Phone Type",
                prefixIcon: Icon(Icons.phone_android),
              ),
              validator: (value) =>
                  value == null ? "Please select a phone type" : null,
            );
          }),

          const SizedBox(height: APPSizes.spaceBtwInputFields),

          TextFormField(
            controller: controller.priceController,
            enabled: false,
            decoration: const InputDecoration(
              labelText: "Price",
              prefixIcon: Icon(Icons.money),
            ),
          ),

          const SizedBox(height: APPSizes.spaceBtwInputFields),
          TextFormField(
            controller: controller.imei,
            validator: (value) =>
                APPValidator.validateEmptyText("Imei Number", value),
            keyboardType: TextInputType.text,
            decoration: const InputDecoration(
              prefixIcon: Icon(Iconsax.direct_right),
              labelText: "Imei Number",
            ),
          ),
          const SizedBox(height: APPSizes.spaceBtwInputFields),
          TextFormField(
            controller: controller.serialNumber,
            validator: (value) =>
                APPValidator.validateEmptyText("Serial Number", value),
            keyboardType: TextInputType.text,
            decoration: const InputDecoration(
              prefixIcon: Icon(Iconsax.direct_right),
              labelText: "Serial Number",
            ),
          ),
          const SizedBox(height: APPSizes.spaceBtwInputFields),
          DropdownButtonFormField<String>(
            value: controller.paymentPlan.text.isEmpty
                ? null
                : controller.paymentPlan.text,
            items: ["3", "6", "9", "12"]
                .map(
                  (month) => DropdownMenuItem(
                    value: month,
                    child: Text("$month Months"),
                  ),
                )
                .toList(),
            onChanged: (value) {
              controller.paymentPlan.text = value!;
            },
            decoration: const InputDecoration(
              labelText: "Payment Plan",
              prefixIcon: Icon(Icons.calendar_month),
            ),
            validator: (value) =>
                value == null ? "Please select payment plan" : null,
          ),
          const SizedBox(height: APPSizes.spaceBtwInputFields),
          TextFormField(
            controller: controller.downPayment,
            validator: (value) =>
                APPValidator.validateEmptyText("Down Payment", value),
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              prefixIcon: Icon(Icons.numbers),
              labelText: "Down Payment",
            ),
          ),
          const SizedBox(height: APPSizes.spaceBtwInputFields),
          Obx(
            () => SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: controller.isLoading.value
                    ? null
                    : () => controller.setup(),
                style: ElevatedButton.styleFrom(
                  disabledBackgroundColor: controller.isLoading.value
                      ? APPColors
                            .primary // Keep the same color when disabled
                      : APPColors.primary, // Active button color
                  disabledForegroundColor: APPColors.white,
                ),
                child: controller.isLoading.value
                    ? LoadingAnimationWidget.threeArchedCircle(
                        color: APPColors.white,
                        size: 30,
                      )
                    : const Text(APPTexts.submit),
              ),
            ),
          ),
          const SizedBox(height: APPSizes.spaceBtwSections),
          // ElevatedButton(onPressed: onPressed, child: child)
        ],
      ),
    );
  }
}
