import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:goodfellow/common/styles/spacing_styles.dart';
import 'package:goodfellow/utils/constants/image_strings.dart';
import 'package:goodfellow/utils/constants/sizes.dart';
import 'package:goodfellow/utils/constants/text_string.dart';
import 'package:goodfellow/utils/helpers/helper_functions.dart';

class SystemError extends StatelessWidget {
  const SystemError({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: APPSpacingStyle.paddingWithAppBarHeight * 2,
          child: Column(
            children: [
              Lottie.asset(
                APPImages.noConnection,
                width: APPHelperFunctions.screenWidth() * 0.6,
              ),
              // Image(
              //   width: APPHelperFunctions.screenWidth() * 0.6,
              //   image: const AssetImage(APPImages.noConnection),
              // ),
              const SizedBox(height: APPSizes.spaceBtwSections),
              Text(
                APPTexts.connectionError,
                style: Theme.of(context).textTheme.headlineMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: APPSizes.spaceBtwItem),
              Text(
                APPTexts.connectionErrorSubText,
                style: Theme.of(context).textTheme.labelMedium,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
