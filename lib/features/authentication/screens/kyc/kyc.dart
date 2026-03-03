import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:goodfellow/common/appbar/appbar.dart';
import 'package:goodfellow/common/images/app_rounded_image.dart';
import 'package:goodfellow/features/authentication/controllers/sign_in/sign_in_controller.dart';
import 'package:goodfellow/features/authentication/screens/kyc/widgets/kyc_form.dart';
import 'package:goodfellow/features/authentication/screens/login/login.dart';
import 'package:goodfellow/utils/constants/colors.dart';
import 'package:goodfellow/utils/constants/image_strings.dart';
import 'package:goodfellow/utils/constants/sizes.dart';
import 'package:goodfellow/utils/helpers/helper_functions.dart';

class KYCScreen extends StatelessWidget {
  const KYCScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final deviceStorage = GetStorage();
    final kycStatus = deviceStorage.read("kyc_status");

    return Scaffold(
      appBar: APPAPPBar(
        showBackArrow: false,
        title: const Text(
          "Identity Verification",
        ), // More professional phrasing
        actions: [
          IconButton(
            onPressed: _showLogoutConfirmationDialog,
            icon: const Icon(CupertinoIcons.power),
          ),
        ],
      ),
      body: kycStatus == "pending"
          ? _buildPendingWidget(context) // Beautiful pending state
          : SingleChildScrollView(
              padding: const EdgeInsets.all(APPSizes.defaultSpace),
              child: const KycForm(),
            ),
    );
  }

  Widget _buildPendingWidget(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(APPSizes.defaultSpace),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // 1. Visual Element (Use an Icon or Lottie/Image)
          const Icon(
            CupertinoIcons.doc_text_search,
            size: 100,
            color: APPColors.primary, // Or your brand color
          ),
          const SizedBox(height: APPSizes.spaceBtwSections),

          // 2. Status Title
          Text(
            "Verification in Progress",
            style: Theme.of(context).textTheme.headlineMedium,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: APPSizes.spaceBtwItem),

          // 3. Informative Description
          Text(
            "We're currently reviewing your documents. This usually takes 24–48 hours. We'll notify you as soon as your account is ready.",
            style: Theme.of(context).textTheme.bodyMedium,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: APPSizes.spaceBtwSections),

          // 4. Interactive Element (Refresh or Check Status)
          SizedBox(
            width: double.infinity,
            child: OutlinedButton(
              onPressed: () {
                // Logic to re-fetch KYC status from API
              },
              child: const Text("Check Status"),
            ),
          ),

          const SizedBox(height: APPSizes.spaceBtwItem),

          // 5. Secondary Action (Support)
          TextButton(
            onPressed: () {
              // Navigate to Support
            },
            child: const Text("Contact Support"),
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
