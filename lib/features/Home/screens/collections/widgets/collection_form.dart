import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:iconsax/iconsax.dart';
import 'package:goodfellow/features/Home/controllers/collections/collection_controller.dart';
import 'package:goodfellow/utils/constants/colors.dart';
import 'package:goodfellow/utils/constants/sizes.dart';
import 'package:goodfellow/utils/constants/text_string.dart';
import 'package:goodfellow/utils/helpers/helper_functions.dart';
import 'package:goodfellow/utils/validators/validation.dart';
import 'package:country_picker/country_picker.dart';

class CollectionForm extends StatefulWidget {
  const CollectionForm({super.key, required this.collectionChannel});

  final String collectionChannel;

  @override
  State<CollectionForm> createState() => _CollectionFormState();
}

class _CollectionFormState extends State<CollectionForm> {
  final deviceStorage = GetStorage();
  late bool loading = false;
  String errorMessage = '';

  // @override
  // void initState() {
  //   super.initState();
  //   getData();
  // }

  final List<String> countryCodes = ['+1', '+44', '+91', '+255', "ZM +260"];
  String selectedCountryCode = '260';

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(
      CollectionController(
        collectionChannel: widget.collectionChannel,
        selectedCountryCode: selectedCountryCode,
      ),
      tag: UniqueKey().toString(),
    );
    return Form(
      key: controller.collectionFormKey,
      child: Column(
        children: [
          TextFormField(
            controller: controller.phoneNumber,
            validator: (value) =>
                APPValidator.validateEmptyText("Phone number", value),
            keyboardType: TextInputType.phone,
            maxLength: 9,
            decoration: InputDecoration(
              prefixIcon: GestureDetector(
                onTap: () {
                  showCountryPicker(
                    context: context,
                    onSelect: (Country country) {
                      setState(() {
                        selectedCountryCode =
                            '${country.flagEmoji} +${country.phoneCode}';
                      });
                      controller.selectedCountryCode = country.phoneCode;
                    },
                  );
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        selectedCountryCode,
                        style: TextStyle(
                          color: APPHelperFunctions.isDarkMode(Get.context!)
                              ? APPColors.white
                              : APPColors.black,
                        ),
                      ),
                      const Icon(Icons.arrow_drop_down),
                    ],
                  ),
                ),
              ),
              labelText: APPTexts.phoneNumber,
              hintText: 'Enter phone number',
            ),
          ),
          const SizedBox(height: APPSizes.spaceBtwInputFields),
          TextFormField(
            controller: controller.amount,
            validator: (value) => APPValidator.validateAmount(value),
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              prefixIcon: Icon(Iconsax.money),
              labelText: APPTexts.amount,
              counterText: '',
            ),
            maxLength: 5,
          ),
          const SizedBox(height: APPSizes.spaceBtwSections),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => {},
              child: const Text(APPTexts.submit),
            ),
          ),
        ],
      ),
    );
  }

  void showLoadingDialog(BuildContext context, String message) {
    showGeneralDialog(
      context: context,
      barrierDismissible: false,
      barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
      barrierColor: Colors.black54,
      transitionDuration: const Duration(milliseconds: 300),
      pageBuilder: (_, __, ___) {
        return Dialog(
          backgroundColor: APPHelperFunctions.isDarkMode(context)
              ? APPColors.dark.withAlpha((0.9 * 255).toInt())
              : APPColors.white.withAlpha((0.9 * 255).toInt()),
          child: Padding(
            padding: const EdgeInsets.all(APPSizes.defaultSpace),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(message, style: Theme.of(context).textTheme.bodyLarge),
                const SizedBox(height: APPSizes.spaceBtwSections),
              ],
            ),
          ),
        );
      },
      transitionBuilder: (_, animation, __, child) {
        return FadeTransition(
          opacity: animation,
          child: SlideTransition(
            position: Tween<Offset>(begin: const Offset(0, 1), end: Offset.zero)
                .animate(
                  CurvedAnimation(parent: animation, curve: Curves.easeOut),
                ),
            child: child,
          ),
        );
      },
    );
  }
}
