import 'package:flutter/material.dart';
import 'package:goodfellow/utils/constants/colors.dart';
import 'package:goodfellow/utils/constants/sizes.dart';
import 'package:goodfellow/utils/helpers/helper_functions.dart';

class HomeCardButton extends StatelessWidget {
  const HomeCardButton({
    super.key,
    required this.icon,
    required this.text,
    required this.onPressed,
  });

  final IconData icon;
  final String text;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    // final dark = APPHelperFunctions.isDarkMode(context);
    return GestureDetector(
      onTap: onPressed,
      child: Card(
        elevation: 3,
        color: Colors.transparent,
        child: Container(
          padding: const EdgeInsets.all(APPSizes.defaultSpace / 2),
          height: 110,
          width: APPHelperFunctions.screenWidth() / 2.5,
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(15)),
            color: APPColors.primary,
          ),
          child: Column(
            children: [
              Icon(icon, color: APPColors.white, size: APPSizes.iconLg),
              const SizedBox(height: APPSizes.spaceBtwItem / 2),
              Expanded(
                child: Text(
                  text,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyMedium!.apply(
                    color: APPColors.white,
                    fontWeightDelta: 4,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
