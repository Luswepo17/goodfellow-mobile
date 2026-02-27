import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:goodfellow/utils/constants/colors.dart';
import 'package:goodfellow/utils/constants/sizes.dart';
import 'package:goodfellow/utils/helpers/helper_functions.dart';

class CustomDialog extends StatelessWidget {
  final String title;
  final String message;
  final Icon icon;

  const CustomDialog({
    super.key,
    required this.title,
    required this.message,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Material(
        color: Colors.transparent,
        child: Container(
          padding: const EdgeInsets.all(APPSizes.defaultSpace),
          margin: const EdgeInsets.all(APPSizes.defaultSpace),
          decoration: BoxDecoration(
            color: APPHelperFunctions.isDarkMode(context)
                ? APPColors.dark
                : APPColors.white,
            borderRadius: BorderRadius.circular(15),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              icon,
              const SizedBox(height: APPSizes.spaceBtwItem),
              Text(title, style: Get.textTheme.headlineSmall),
              const SizedBox(height: APPSizes.spaceBtwItem / 2),
              Text(message, textAlign: TextAlign.center),
              const SizedBox(height: APPSizes.spaceBtwItem),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Get.back(),
                  child: const Text('OK'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
