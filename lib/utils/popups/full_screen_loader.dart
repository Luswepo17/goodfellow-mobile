import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:goodfellow/common/widgets/loaders/animation_loader.dart';
import 'package:goodfellow/utils/constants/colors.dart';
import 'package:goodfellow/utils/helpers/helper_functions.dart';

class APPFullScreenLoader {
  static void openLoadingDialog(String text, String animation) {
    showDialog(
      context: Get.overlayContext!,
      barrierDismissible: false,
      builder: (_) => PopScope(
        canPop: false,
        child: Container(
          color: APPHelperFunctions.isDarkMode(Get.context!)
              ? APPColors.dark
              : APPColors.white,
          width: double.infinity,
          height: double.infinity,
          child: Column(
            children: [
              const SizedBox(height: 250),
              APPAnimationLoaderWidget(text: text, animation: animation),
            ],
          ),
        ),
      ),
    );
  }

  static stopLoader() {
    Navigator.of(Get.overlayContext!).pop();
  }
}
