import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:goodfellow/utils/constants/colors.dart';
import 'package:goodfellow/utils/constants/sizes.dart';
import 'package:goodfellow/utils/helpers/helper_functions.dart';

class CustomDialog extends StatelessWidget {
  final String? title;
  final String? message;
  final Widget? content;
  final List<Widget>? actions;
  final Widget? icon;
  final bool isLoading;
  final Color? iconBackgroundColor;
  final bool barrierDismissible;
  final EdgeInsets? contentPadding;

  const CustomDialog({
    super.key,
    this.title,
    this.message,
    this.content,
    this.actions,
    this.icon,
    this.isLoading = false,
    this.iconBackgroundColor,
    this.barrierDismissible = true,
    this.contentPadding,
  });

  @override
  Widget build(BuildContext context) {
    final dark = APPHelperFunctions.isDarkMode(context);
    return PopScope(
      canPop: barrierDismissible,
      child: AnimatedDialog(
        child: Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          elevation: 0,
          backgroundColor: dark ? APPColors.dark : APPColors.white,
          child: Container(
            padding: contentPadding ?? const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: dark ? APPColors.dark : APPColors.white,
              borderRadius: BorderRadius.circular(15),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withAlpha((0.1 * 255).toInt()),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (icon != null) ...[
                    Center(
                      child: CircleAvatar(
                        radius: 30,
                        backgroundColor: iconBackgroundColor ?? Colors.blue,
                        child: icon,
                      ),
                    ),
                    const SizedBox(height: APPSizes.spaceBtwSections),
                  ],
                  if (title != null) ...[
                    Text(
                      title!,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    const SizedBox(height: APPSizes.spaceBtwItem),
                  ],
                  if (isLoading) ...[
                    Center(
                      child: LoadingAnimationWidget.threeArchedCircle(
                        color: APPColors.primary,
                        size: 30,
                      ),
                    ),
                    const SizedBox(height: APPSizes.spaceBtwItem),
                  ],
                  if (message != null) ...[
                    Text(
                      message!,
                      style: TextStyle(
                        fontSize: 16,
                        color: APPHelperFunctions.isDarkMode(Get.context!)
                            ? APPColors.white
                            : Colors.black87,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                  ],
                  if (content != null) ...[
                    content!,
                    const SizedBox(height: 24),
                  ],
                  if (actions != null) ...[
                    Column(
                      children: actions!.map((action) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 8.0),
                          child: SizedBox(
                            width: double.infinity,
                            child: action,
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class AnimatedDialog extends StatefulWidget {
  final Widget child;

  const AnimatedDialog({super.key, required this.child});

  @override
  State<AnimatedDialog> createState() => _AnimatedDialogState();
}

class _AnimatedDialogState extends State<AnimatedDialog>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );

    // Create a sliding animation from bottom to center
    _slideAnimation =
        Tween<Offset>(
          begin: const Offset(0, 1), // Start from bottom (y = 1)
          end: Offset.zero, // End at center (y = 0)
        ).animate(
          CurvedAnimation(
            parent: _animationController,
            curve: Curves.easeOutQuart, // Smoother easing curve
          ),
        );

    // Start the animation when the dialog is shown
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SlideTransition(position: _slideAnimation, child: widget.child);
  }
}
