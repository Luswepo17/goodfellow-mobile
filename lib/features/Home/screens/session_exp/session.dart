import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:goodfellow/common/images/app_rounded_image.dart';
import 'package:goodfellow/features/authentication/controllers/sign_in/sign_in_controller.dart';
import 'package:goodfellow/features/authentication/screens/login/login.dart';
import 'package:goodfellow/utils/constants/image_strings.dart';
import 'package:goodfellow/utils/constants/sizes.dart';
import 'package:goodfellow/utils/constants/text_string.dart';

class SessionExpiredScreen extends StatelessWidget {
  const SessionExpiredScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final deviceStorage = GetStorage();
    final signinController = SigninController.instance;
    return PopScope(
      canPop: false,
      child: Scaffold(
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(APPSizes.defaultSpace),
            child: Column(
              children: [
                const SizedBox(height: APPSizes.appBarHeight),
                const Center(
                  child: APPRoundedImage(
                    backgroundColor: Colors.transparent,
                    imageUrl: APPImages.timeout,
                  ),
                ),
                const SizedBox(height: APPSizes.spaceBtwSections),
                Text(
                  APPTexts.sessionExpiredTitle,
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                const SizedBox(height: APPSizes.spaceBtwItem),
                Text(
                  APPTexts.sessionExpiredSubTitle,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(height: APPSizes.spaceBtwSections),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => {
                      deviceStorage.erase(),
                      signinController.email.clear(),
                      signinController.password.clear(),
                      Get.to(
                        transition: Transition.rightToLeft,
                        duration: const Duration(milliseconds: 500),
                        () => const LoginScreen(),
                      ),
                    },
                    child: Text(
                      "Login",
                      style: Theme.of(context).textTheme.bodyMedium,
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
}
