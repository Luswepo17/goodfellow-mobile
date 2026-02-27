import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:goodfellow/utils/constants/colors.dart';
import 'package:goodfellow/utils/constants/sizes.dart';
import 'package:goodfellow/utils/device/device_utility.dart';
import 'package:goodfellow/utils/helpers/helper_functions.dart';

class APPAPPBar extends StatelessWidget implements PreferredSizeWidget {
  const APPAPPBar({
    super.key,
    this.title,
    this.showBackArrow = false,
    this.leadingIcon,
    this.actions,
    this.leadingOnPressed,
    this.onBackPressed,
    this.isOrderPage = false,
  });

  final Widget? title;
  final bool showBackArrow;
  final IconData? leadingIcon;
  final List<Widget>? actions;
  final VoidCallback? leadingOnPressed;
  final bool isOrderPage;

  final VoidCallback? onBackPressed;
  @override
  Widget build(BuildContext context) {
    final dark = APPHelperFunctions.isDarkMode(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: APPSizes.md),
      child: AppBar(
        automaticallyImplyLeading: false,
        leading: showBackArrow
            ? IconButton(
                color: dark ? APPColors.white : Colors.black,
                onPressed: () {
                  if (onBackPressed != null) {
                    onBackPressed!(); // Call the custom back action
                  } else {
                    Get.back();
                  }
                },
                icon: isOrderPage
                    ? const Icon(Iconsax.arrow_left)
                    : const Icon(Iconsax.arrow_left),
              )
            : leadingIcon != null
            ? IconButton(onPressed: leadingOnPressed, icon: Icon(leadingIcon))
            : null,
        title: title,
        actions: actions,
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(APPDeviceUtils.getAppBarHeight());
}
