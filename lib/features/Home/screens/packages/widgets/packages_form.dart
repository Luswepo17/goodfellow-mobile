import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:goodfellow/features/Home/controllers/packages/packages_controller.dart';
import 'package:goodfellow/utils/constants/colors.dart';
import 'package:goodfellow/utils/constants/sizes.dart';
import 'package:goodfellow/utils/constants/text_string.dart';

class PackagesForm extends StatefulWidget {
  const PackagesForm({
    super.key,
    required this.packageCode,
    required this.packagePrice,
    required this.packageName,
    required this.channelCode,
  });

  final String packageCode;
  final String packagePrice;
  final String packageName;
  final String channelCode;

  @override
  State<PackagesForm> createState() => _PackagesFormState();
}

class _PackagesFormState extends State<PackagesForm> {
  final deviceStorage = GetStorage();
  late bool loading = false;
  String errorMessage = '';

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(
      PackagesController(
        packageCode: widget.packageCode,
        amount: widget.packagePrice,
        packageName: widget.packageName,
        channelCode: widget.channelCode,
      ),
    );
    return Form(
      key: controller.packagesFormKey,
      child: Column(
        children: [
          TextFormField(
            controller: controller.accountNumber,
            // validator: (value) => APPValidator.validatePhoneNumber(value),
            keyboardType: TextInputType.phone,
            maxLength: 25,
            decoration: const InputDecoration(
              prefixIcon: Icon(Icons.pin_outlined),
              labelText: APPTexts.accountNumber,
              hintText: 'Account number',
            ),
          ),
          Text(
            "For example 078426781, or an account number",
            style: Theme.of(
              context,
            ).textTheme.labelSmall!.apply(color: APPColors.darkGrey),
          ),
          const SizedBox(height: APPSizes.spaceBtwSections),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => controller.fetchUserData(),
              child: const Text(APPTexts.submit),
            ),
          ),
        ],
      ),
    );
  }
}
