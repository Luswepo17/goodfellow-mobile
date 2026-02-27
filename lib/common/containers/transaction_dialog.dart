import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:goodfellow/utils/constants/colors.dart';
import 'package:goodfellow/utils/constants/sizes.dart';
import 'package:goodfellow/utils/helpers/helper_functions.dart';

class TransactionDialog extends StatelessWidget {
  final String message;
  final String transactionId;
  final bool isPending;
  final bool isProcessing;
  final String status;

  const TransactionDialog({
    super.key,
    required this.message,
    required this.transactionId,
    required this.isPending,
    required this.isProcessing,
    required this.status,
  });

  String getDialogTitle() {
    switch (status) {
      case "successful":
      case "success":
        return "Transaction Success";
      case "error":
      case "failed":
      case "failure":
        return "Transaction Failed";
      default:
        return "Transaction Pending";
    }
  }

  Widget getDialogContent(BuildContext context) {
    final dark = APPHelperFunctions.isDarkMode(context);
    switch (status) {
      case "successful":
      case "success":
        return Column(
          children: [
            const Icon(
              Icons.check_circle_outline,
              size: 50,
              color: Colors.green,
            ),
            const SizedBox(height: APPSizes.spaceBtwItem),
            Text(
              message,
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
              maxLines: 7,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        );
      case "error":
      case "failure":
      case "failed":
        return Column(
          children: [
            const Icon(Icons.error_outline, size: 50, color: Colors.red),
            const SizedBox(height: APPSizes.spaceBtwItem),
            Text(
              message,
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
              maxLines: 7,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        );
      default:
        return Column(
          children: [
            LoadingAnimationWidget.threeArchedCircle(
              size: APPSizes.defaultSpace * 3,
              color: dark ? Colors.white : Colors.blue,
            ),
            const SizedBox(height: APPSizes.spaceBtwItem),
            Text(
              message,
              overflow: TextOverflow.ellipsis,
              maxLines: 3,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    final dark = APPHelperFunctions.isDarkMode(context);

    return Dialog(
      backgroundColor: dark ? APPColors.dark : APPColors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.all(APPSizes.defaultSpace),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              getDialogTitle(),
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: APPSizes.spaceBtwItem),
            Center(child: getDialogContent(context)),
            const SizedBox(height: APPSizes.spaceBtwItem),
            if (transactionId.isNotEmpty)
              Row(
                children: [
                  Text(
                    "Transaction ID: ",
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                ],
              ),
            Text(
              transactionId,
              overflow: TextOverflow.ellipsis,
              maxLines: 4,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: APPSizes.spaceBtwItem),
            if (status == "success" ||
                status == "error" ||
                status == "successful" ||
                status == "failed")
              Center(
                child: TextButton(
                  style: TextButton.styleFrom(
                    backgroundColor: APPColors.primary,
                  ),
                  onPressed: () => {Navigator.pop(context)},
                  child: Text(
                    "Close",
                    style: Theme.of(
                      context,
                    ).textTheme.bodyMedium!.apply(color: APPColors.white),
                  ),
                ),
              ),
            const SizedBox(height: APPSizes.defaultSpace),
          ],
        ),
      ),
    );
  }
}

// Helper method to show the animated dialog
void showSlideUpDialog({
  required String message,
  required String transactionId,
  required bool isPending,
  required bool isProcessing,
  required String status,
}) {
  Get.dialog(
    Builder(
      builder: (context) {
        final animationController = AnimationController(
          duration: const Duration(milliseconds: 300),
          vsync: NavigatorState(),
        )..forward();

        final slideAnimation =
            Tween<Offset>(
              begin: const Offset(0, 1), // Starts off-screen at the bottom
              end: Offset.zero, // Ends in place
            ).animate(
              CurvedAnimation(
                parent: animationController,
                curve: Curves.easeOut,
              ),
            );

        return SlideTransition(
          position: slideAnimation,
          child: TransactionDialog(
            message: message,
            transactionId: transactionId,
            isPending: isPending,
            isProcessing: isProcessing,
            status: status,
          ),
        );
      },
    ),
    barrierDismissible: true,
  );
}
