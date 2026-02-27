import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:goodfellow/common/images/app_rounded_image.dart';
import 'package:goodfellow/features/authentication/controllers/sign_in/sign_in_controller.dart';
import 'package:goodfellow/features/authentication/screens/login/login.dart';
import 'package:goodfellow/utils/constants/colors.dart';
import 'package:goodfellow/utils/constants/image_strings.dart';
import 'package:goodfellow/utils/constants/sizes.dart';
import 'package:goodfellow/utils/helpers/helper_functions.dart';
// import 'package:workmanager/workmanager.dart';

class StickyHeader extends StatelessWidget {
  const StickyHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: APPSizes.defaultSpace,
        vertical: 5,
      ),
      decoration: BoxDecoration(
        color: APPHelperFunctions.isDarkMode(context)
            ? APPColors.dark
            : APPColors.light,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(
              (0.2 * 255).toInt(),
            ), // Shadow color with some opacity
            spreadRadius: .5, // How wide the shadow will spread
            blurRadius: 8, // The blurriness of the shadow
            offset: const Offset(
              0,
              4,
            ), // Offset in the x and y direction (x: 0, y: 4)
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const APPRoundedImage(
            backgroundColor: Colors.transparent,
            height: 30,
            imageUrl: APPImages.lightAppLogo,
          ),
          IconButton(
            onPressed: _showLogoutConfirmationDialog,
            icon: const Icon(CupertinoIcons.power),
          ),
        ],
      ),
    );
  }

  void _showLogoutConfirmationDialog() {
    showGeneralDialog(
      context: Get.context!,
      barrierDismissible: true,
      barrierLabel: 'Logout Confirmation',
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
                color: APPHelperFunctions.isDarkMode(context)
                    ? APPColors.dark
                    : Colors.white,
                borderRadius: BorderRadius.circular(15),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Confirm Logout',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: APPSizes.spaceBtwSections),
                  Text(
                    'Are you sure you want to logout?',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const SizedBox(height: APPSizes.spaceBtwSections),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      SizedBox(
                        height: 55,
                        width: 100,
                        child: ElevatedButton(
                          onPressed: () => Get.back(),
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                            side: const BorderSide(
                              width: 0,
                              color: Colors.transparent,
                            ),
                            backgroundColor: Colors.red,
                          ),
                          child: const Text('No'),
                        ),
                      ),
                      SizedBox(
                        height: 55,
                        width: 100,
                        child: ElevatedButton(
                          onPressed: () {
                            Get.back();
                            _handleLogout();
                          },
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
                          child: const Text('Yes'),
                        ),
                      ),
                    ],
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

  void _handleLogout() {
    final deviceStorage = GetStorage();
    final signinController = SigninController.instance;

    deviceStorage.erase();
    signinController.email.clear();
    signinController.password.clear();
    signinController.isLoading.value = false;
    // Workmanager().cancelAll();
    // Display a snackbar or any success message here
    Get.offAll(() => const LoginScreen());
  }
}
