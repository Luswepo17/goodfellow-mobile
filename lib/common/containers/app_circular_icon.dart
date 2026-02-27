import 'package:flutter/material.dart';
import 'package:goodfellow/utils/constants/colors.dart';
import 'package:goodfellow/utils/constants/sizes.dart';
import 'package:goodfellow/utils/helpers/helper_functions.dart';

class APPCircularIcon extends StatelessWidget {
  const APPCircularIcon({
    super.key,
    this.width,
    this.height,
    this.size = APPSizes.lg,
    required this.icon,
    this.color,
    this.backgroundColor,
    this.onPressed,
  });

  final double? width, height, size;
  final IconData icon;
  final Color? color;
  final Color? backgroundColor;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: backgroundColor != null
            ? backgroundColor!
            : APPHelperFunctions.isDarkMode(context)
            ? APPColors.black.withAlpha((0.9 * 255).toInt())
            : APPColors.white.withAlpha((0.9 * 255).toInt()),
        borderRadius: BorderRadius.circular(100),
      ),
      child: IconButton(
        onPressed: onPressed,
        icon: Icon(icon, color: color, size: size),
      ),
    );
  }
}
