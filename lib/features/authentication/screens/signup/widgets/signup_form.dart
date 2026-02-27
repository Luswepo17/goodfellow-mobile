import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:goodfellow/features/authentication/controllers/sign_up/sign_up_controller.dart';
import 'package:iconsax/iconsax.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:goodfellow/utils/constants/colors.dart';
import 'package:goodfellow/utils/constants/sizes.dart';
import 'package:goodfellow/utils/constants/text_string.dart';
import 'package:goodfellow/utils/validators/validation.dart';
import 'package:lucide_icons/lucide_icons.dart';

class APPSignupForm extends StatelessWidget {
  const APPSignupForm({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(SignUpController());
    return Form(
      key: controller.signupFormKey,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: APPSizes.spaceBtwSections,
        ),
        child: Column(
          children: [
            Obx(
              () => TextFormField(
                controller: controller.fullname,
                validator: (value) =>
                    APPValidator.validateEmptyText("Name", value),
                decoration: InputDecoration(
                  prefixIcon: const Icon(LucideIcons.user),
                  labelText: "Full name",
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: controller.fullnameError.value
                          ? Colors.red
                          : Colors.grey,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: controller.fullnameError.value
                          ? Colors.red
                          : Colors.blue,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: APPSizes.spaceBtwInputFields),

            Obx(
              () => TextFormField(
                controller: controller.email,
                validator: (value) => APPValidator.validateEmail(value),
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.email_outlined),
                  labelText: APPTexts.email,
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: controller.emailError.value
                          ? Colors.red
                          : Colors.grey,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: controller.emailError.value
                          ? Colors.red
                          : Colors.blue,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: APPSizes.spaceBtwInputFields),
            Obx(
              () => TextFormField(
                controller: controller.password,
                validator: (value) => APPValidator.validatePassword(value),
                obscureText: controller.hidePassword.value,
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.password_outlined),
                  labelText: APPTexts.password,
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: controller.passwordError.value
                          ? Colors.red
                          : Colors.grey,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: controller.passwordError.value
                          ? Colors.red
                          : Colors.blue,
                    ),
                  ),
                  suffixIcon: IconButton(
                    onPressed: () => controller.hidePassword.value =
                        !controller.hidePassword.value,
                    icon: Icon(
                      controller.hidePassword.value
                          ? Iconsax.eye_slash
                          : Iconsax.eye,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: APPSizes.spaceBtwInputFields),

            Obx(
              () => TextFormField(
                maxLength: 10,
                keyboardType: TextInputType.numberWithOptions(),
                controller: controller.phone,
                validator: (value) =>
                    APPValidator.validateEmptyText("Phone number", value),
                decoration: InputDecoration(
                  prefixIcon: const Icon(LucideIcons.phoneCall),
                  labelText: APPTexts.phoneNumber,
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: controller.phoneError.value
                          ? Colors.red
                          : Colors.grey,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: controller.phoneError.value
                          ? Colors.red
                          : Colors.blue,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: APPSizes.spaceBtwInputFields),

            Obx(
              () => TextFormField(
                controller: controller.address,
                validator: (value) =>
                    APPValidator.validateEmptyText("Address", value),
                decoration: InputDecoration(
                  prefixIcon: const Icon(LucideIcons.home),
                  labelText: "Address",
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: controller.addressError.value
                          ? Colors.red
                          : Colors.grey,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: controller.addressError.value
                          ? Colors.red
                          : Colors.blue,
                    ),
                  ),
                ),
              ),
            ),

            const SizedBox(height: APPSizes.spaceBtwSections),
            Obx(() {
              if (controller.emailError.value ||
                  controller.passwordError.value ||
                  controller.fullnameError.value ||
                  controller.phoneError.value ||
                  controller.addressError.value) {
                return Text(
                  'Invalid details. Please try again.',
                  style: Theme.of(
                    context,
                  ).textTheme.bodyMedium!.apply(color: Colors.red),
                );
              }
              return const SizedBox.shrink(); // Empty space when there's no error
            }),
            const SizedBox(height: APPSizes.spaceBtwSections),
            Obx(
              () => SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    disabledBackgroundColor: controller.isLoading.value
                        ? APPColors
                              .primary // Keep the same color when disabled
                        : APPColors.primary, // Active button color
                    disabledForegroundColor: APPColors.white,
                  ),
                  onPressed: controller.isLoading.value
                      ? null
                      : () {
                          controller.signup();
                        },
                  child: controller.isLoading.value
                      ? LoadingAnimationWidget.threeArchedCircle(
                          color: APPColors.white,
                          size: 30,
                        )
                      : const Text(APPTexts.createAccount),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
