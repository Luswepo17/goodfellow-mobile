import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:goodfellow/utils/constants/colors.dart';
import 'package:goodfellow/utils/constants/sizes.dart';
import 'package:goodfellow/utils/helpers/helper_functions.dart';

class CustomDialog extends StatelessWidget {
  final String title;
  final Widget content;
  final String? confirmText;
  final VoidCallback? onConfirm;
  final String? cancelText;
  final VoidCallback? onCancel;
  final IconData? icon;
  final String? message;
  final Color? iconColor;
  final double? iconSize;
  final bool? showClose;

  const CustomDialog({
    super.key,
    required this.title,
    required this.content,
    this.confirmText,
    this.onConfirm,
    this.cancelText,
    this.onCancel,
    this.icon,
    this.message,
    this.iconColor,
    this.iconSize,
    this.showClose = true,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: APPHelperFunctions.isDarkMode(context)
          ? APPColors.black
          : APPColors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.all(APPSizes.defaultSpace),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const SizedBox(),
                  showClose == true
                      ? IconButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          icon: const Icon(Icons.close, size: APPSizes.iconMd),
                        )
                      : const SizedBox.shrink(),
                ],
              ),
              if (icon != null) Icon(icon, color: iconColor, size: iconSize),
              const SizedBox(height: APPSizes.spaceBtwItem),
              Text(title, style: Theme.of(context).textTheme.headlineSmall),
              const SizedBox(height: APPSizes.spaceBtwItem),
              content, // ✅ Dynamic content goes here
              const SizedBox(height: APPSizes.spaceBtwSections),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  if (cancelText != null)
                    TextButton(
                      onPressed: onCancel ?? () => Get.back(),
                      child: Text(cancelText!),
                    ),
                  if (confirmText != null)
                    ElevatedButton(
                      onPressed: onConfirm,
                      child: Text(confirmText!),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

void showCustomDialog({
  required String title,
  required Widget content,
  String? confirmText,
  VoidCallback? onConfirm,
  String? cancelText,
  VoidCallback? onCancel,
  IconData? icon,
  Color? iconColor,
  double? iconSize,
  bool? showClose,
}) {
  Get.dialog(
    CustomDialog(
      title: title,
      content: content,
      confirmText: confirmText,
      onConfirm: onConfirm,
      cancelText: cancelText,
      onCancel: onCancel,
      icon: icon,
      iconColor: iconColor,
      iconSize: iconSize,
      showClose: showClose,
    ),
    barrierDismissible: false,
  );
}
