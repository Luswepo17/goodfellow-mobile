import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:goodfellow/common/text/offline_text.dart';
import 'package:goodfellow/features/Home/screens/collections/widgets/collection_form.dart';
import 'package:goodfellow/features/Home/screens/home/home.dart';
import 'package:goodfellow/utils/constants/colors.dart';
import 'package:goodfellow/utils/constants/sizes.dart';
import 'package:goodfellow/utils/constants/text_string.dart';
import 'package:goodfellow/utils/helpers/helper_functions.dart';

class CollectionScreen extends StatelessWidget {
  const CollectionScreen({super.key, required this.mode});

  final String mode;

  @override
  Widget build(BuildContext context) {
    final dark = APPHelperFunctions.isDarkMode(context);
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            APPTexts.collectionTitle,
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          iconTheme: IconThemeData(
            color: dark
                ? APPColors.white
                : Colors.black, //change your color here
          ),
          leading: IconButton(
            onPressed: () => Get.offAll(() => const HomeScreen()),
            icon: const Icon(CupertinoIcons.arrow_left),
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
                    APPTexts.collectionSubTitle,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const SizedBox(height: APPSizes.spaceBtwSections),
                  CollectionForm(collectionChannel: mode),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
