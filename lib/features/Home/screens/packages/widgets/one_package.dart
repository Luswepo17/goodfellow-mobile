import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:goodfellow/common/appbar/appbar.dart';
import 'package:goodfellow/common/text/offline_text.dart';
import 'package:goodfellow/features/Home/screens/packages/widgets/packages_form.dart';
import 'package:goodfellow/utils/constants/sizes.dart';

class OnePackageScreen extends StatelessWidget {
  const OnePackageScreen({
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
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: APPAPPBar(
          showBackArrow: true,
          onBackPressed: Get.back,
          title: Text(
            packageName,
            style: Theme.of(context).textTheme.headlineSmall,
          ),
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(APPSizes.defaultSpace),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const OfflineText(),
                  Text(
                    "Account number",
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const SizedBox(height: APPSizes.spaceBtwSections),
                  PackagesForm(
                    packageCode: packageCode,
                    packagePrice: packagePrice,
                    packageName: packageName,
                    channelCode: channelCode,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
