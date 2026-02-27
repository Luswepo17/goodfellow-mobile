import 'package:flutter/material.dart';
// import 'package:goodfellow/common/images/app_rounded_image.dart';
import 'package:goodfellow/utils/constants/colors.dart';
import 'package:goodfellow/utils/constants/image_strings.dart';
import 'package:goodfellow/utils/constants/sizes.dart';
import 'package:goodfellow/utils/constants/text_string.dart';
import 'package:goodfellow/utils/helpers/helper_functions.dart';

class APPLoginHeader extends StatelessWidget {
  const APPLoginHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final dark = APPHelperFunctions.isDarkMode(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // const UpdateAvailable(),
        Image(
          height: 150,
          image: AssetImage(
            dark ? APPImages.lightAppLogo : APPImages.darkAppLogo,
          ),
        ),

        // const APPRoundedImage(
        //     backgroundColor: Colors.transparent,
        //     height: 100,
        //     imageUrl: APPImages.lightAppLogo),
        Text(
          "${APPTexts.loginTitle},",
          style: Theme.of(context).textTheme.headlineMedium,
        ),
        const SizedBox(height: APPSizes.sm),

        const SizedBox(height: APPSizes.md),
        Row(
          children: [
            Text(
              APPTexts.loginSubTitle,
              style: Theme.of(
                context,
              ).textTheme.bodyMedium!.apply(color: APPColors.primary),
            ),
            Text(
              APPTexts.loginSubtitle2,
              style: Theme.of(
                context,
              ).textTheme.bodyMedium!.apply(color: APPColors.secondary),
            ),
          ],
        ),
      ],
    );
  }
}
