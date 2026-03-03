import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:goodfellow/features/Home/controllers/payment/payment_controller.dart';
import 'package:goodfellow/utils/constants/colors.dart';
import 'package:goodfellow/utils/constants/sizes.dart';
import 'package:goodfellow/utils/constants/text_string.dart';
import 'package:goodfellow/utils/validators/validation.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class MakePaymentForm extends StatelessWidget {
  const MakePaymentForm({super.key, required this.installmentId});
  final String installmentId;

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(PaymentController());
    return Form(
      key: controller.signinFormKey,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: APPSizes.spaceBtwSections,
        ),
        child: Column(
          children: [
            Obx(
              () => TextFormField(
                controller: controller.phone,
                maxLength: 9,
                keyboardType: TextInputType.numberWithOptions(),
                validator: (value) =>
                    APPValidator.validateEmptyText("Phone number", value),
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.call),
                  labelText: APPTexts.phoneNumber,
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
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
                controller: controller.amount,
                validator: (value) =>
                    APPValidator.validateEmptyText("Amount", value),

                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.numbers),
                  labelText: APPTexts.amount,
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: BorderSide(
                      color: controller.amountError.value
                          ? Colors.red
                          : Colors.grey,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: controller.amountError.value
                          ? Colors.red
                          : Colors.blue,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: APPSizes.spaceBtwSections),
            Obx(() {
              if (controller.amountError.value || controller.phoneError.value) {
                return Text(
                  'Invalid email or password. Please try again.',
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
                      borderRadius: BorderRadiusGeometry.circular(15),
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
                          controller.makeCollection(installmentId);
                        },
                  child: controller.isLoading.value
                      ? LoadingAnimationWidget.threeArchedCircle(
                          color: APPColors.white,
                          size: 30,
                        )
                      : const Text("Pay Now"),
                ),
              ),
            ),
            const SizedBox(height: APPSizes.spaceBtwInputFields),
          ],
        ),
      ),
    );
  }
}
