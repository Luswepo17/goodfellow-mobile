import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:goodfellow/common/containers/app_rounded_container.dart';
import 'package:goodfellow/utils/constants/colors.dart';
import 'package:goodfellow/utils/constants/sizes.dart';
import 'package:goodfellow/utils/helpers/helper_functions.dart';

void showLoadingDialog(String message) {
  Get.dialog(
    barrierDismissible: false,
    Center(
      child: Material(
        color: Colors.transparent,
        child: Container(
          padding: const EdgeInsets.all(APPSizes.defaultSpace),
          margin: const EdgeInsets.all(APPSizes.defaultSpace),
          decoration: BoxDecoration(
            color: APPHelperFunctions.isDarkMode(Get.context!)
                ? APPColors.dark
                : APPColors.white,
            borderRadius: BorderRadius.circular(15),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: APPSizes.spaceBtwItem / 2),
              Text(message, textAlign: TextAlign.center),
              const SizedBox(height: APPSizes.spaceBtwItem),
              LoadingAnimationWidget.threeArchedCircle(
                color: APPColors.primary,
                size: 30,
              ),
              const SizedBox(height: APPSizes.spaceBtwItem),
              SizedBox(
                width: double.infinity,
                child: TextButton(
                  onPressed: () => Get.back(),
                  child: Text(
                    'Close',
                    style: Theme.of(Get.context!).textTheme.bodyMedium!.apply(
                      color: APPHelperFunctions.isDarkMode(Get.context!)
                          ? APPColors.white
                          : APPColors.black,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}

Future<bool?> showConfirmationDialog(
  String name,
  String phoneNumber,
  String amount,
  String packageName,
  bool isFailed,
) async {
  return await showGeneralDialog(
    barrierDismissible: false,
    context: Get.context!,
    transitionDuration: const Duration(milliseconds: 300),
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
              color: APPHelperFunctions.isDarkMode(Get.context!)
                  ? APPColors.dark
                  : Colors.white,
              borderRadius: BorderRadius.circular(15),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const APPRoundedContainer(
                  backgroundColor: Colors.transparent,
                  child: Icon(Iconsax.shield_tick, color: Colors.green),
                ),
                const SizedBox(height: APPSizes.spaceBtwItem),
                Text("Confirm Transaction", style: Get.textTheme.headlineSmall),
                const SizedBox(height: APPSizes.spaceBtwItem),
                if (!isFailed) Text("Name: $name"),
                if (isFailed)
                  Text(
                    "Failed to fetch user details, do you still want to proceed?",
                    overflow: TextOverflow.ellipsis,
                    maxLines: 3,
                    textAlign: TextAlign.center,
                    style: Theme.of(Get.context!).textTheme.bodyMedium!.apply(
                      fontWeightDelta: 2,
                      color: Colors.red,
                    ),
                  ),
                const SizedBox(height: APPSizes.spaceBtwItem / 2),
                Text("Phone: $phoneNumber"),
                const SizedBox(height: APPSizes.spaceBtwItem / 2),
                Text("Amount: K$amount"),
                const SizedBox(height: APPSizes.spaceBtwItem / 2),
                Text("Package: $packageName"),
                const SizedBox(height: APPSizes.spaceBtwSections),
                Text(
                  "Please review the above details before proceeding.",
                  textAlign: TextAlign.center,
                  style: Theme.of(Get.context!).textTheme.labelSmall,
                ),
                const SizedBox(height: APPSizes.spaceBtwItem / 2),
                if (isFailed)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                        height: 55,
                        width: 100,
                        child: ElevatedButton(
                          onPressed: () => {Navigator.pop(Get.context!)},
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
                          onPressed: () => Navigator.of(Get.context!).pop(true),
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
                      onPressed: () => Navigator.of(Get.context!).pop(true),
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
                    onPressed: () => Navigator.of(Get.context!).pop(false),
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
                        Get.context!,
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
}
