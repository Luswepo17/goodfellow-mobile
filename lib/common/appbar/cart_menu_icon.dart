import 'package:flutter/material.dart';
import 'package:get/get.dart';
import "package:iconsax/iconsax.dart";
import 'package:goodfellow/utils/constants/colors.dart';

class APPCounterIcon extends StatelessWidget {
  const APPCounterIcon({super.key, this.iconColor, this.onPressed});

  final Color? iconColor;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        IconButton(
          onPressed: () => Get.to(
            transition: Transition.rightToLeft,
            duration: const Duration(milliseconds: 500),
            () => {},
          ),
          icon: Icon(Iconsax.bill, color: iconColor),
        ),
        Positioned(
          right: 0,
          child: Container(
            width: 18,
            height: 18,
            decoration: BoxDecoration(
              color: APPColors.black,
              borderRadius: BorderRadius.circular(100),
            ),
            child: Center(
              child: Text(
                '0',
                style: Theme.of(context).textTheme.labelLarge!.apply(
                  color: APPColors.white,
                  fontSizeFactor: 0.8,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
