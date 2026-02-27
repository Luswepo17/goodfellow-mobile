import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:goodfellow/utils/constants/colors.dart';
import 'package:goodfellow/utils/constants/sizes.dart';
import 'package:goodfellow/utils/constants/text_string.dart';
import 'package:goodfellow/utils/helpers/helper_functions.dart';

class BillPurchaseConfirmationDialog extends StatelessWidget {
  const BillPurchaseConfirmationDialog({
    super.key,
    required this.name,
    required this.amount,
    required this.accountNumber,
    this.isFailed = false,
  });

  final String name;
  final String amount;
  final String accountNumber;
  final bool isFailed;
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Material(
        color: Colors.transparent,
        child: Container(
          padding: const EdgeInsets.all(APPSizes.defaultSpace),
          margin: const EdgeInsets.symmetric(horizontal: APPSizes.defaultSpace),
          decoration: BoxDecoration(
            color: APPHelperFunctions.isDarkMode(context)
                ? APPColors.dark
                : APPColors.white,
            borderRadius: BorderRadius.circular(15),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Iconsax.shield_tick, color: Colors.green, size: 32),
              const SizedBox(height: APPSizes.spaceBtwItem),
              Text(
                APPTexts.confirmTransaction,
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: APPSizes.spaceBtwItem),
              if (!isFailed)
                Text(
                  "Name: $name",
                  style: Theme.of(
                    context,
                  ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold),
                ),
              if (isFailed)
                Text(
                  "Failed to fetch user details, do you want to proceed?",
                  textAlign: TextAlign.center,
                  style: Theme.of(
                    context,
                  ).textTheme.bodyMedium?.copyWith(color: Colors.red),
                ),
              const SizedBox(height: APPSizes.spaceBtwItem / 2),
              Text(
                "Amount: K$amount",
                style: Theme.of(
                  context,
                ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: APPSizes.spaceBtwItem / 2),
              Text(
                "Account Number: $accountNumber",
                style: Theme.of(
                  context,
                ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: APPSizes.spaceBtwSections),
              Text(
                "Please review the details before proceeding.",
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.labelSmall,
              ),
              const SizedBox(height: APPSizes.spaceBtwSections / 2),
              // Buttons Row
              if (isFailed)
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      height: 55,
                      width: 100,
                      child: ElevatedButton(
                        onPressed: () => Navigator.pop(context, 'retry'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.amber,
                          side: BorderSide.none,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                        child: const Text('Retry'),
                      ),
                    ),
                    SizedBox(
                      height: 55,
                      width: 100,
                      child: ElevatedButton(
                        onPressed: () => Navigator.pop(context, true),
                        style: ElevatedButton.styleFrom(
                          side: BorderSide.none,
                          backgroundColor: Colors.green,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                        child: const Text('Proceed'),
                      ),
                    ),
                  ],
                ),
              if (!isFailed)
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => Navigator.pop(context, true),
                    style: ElevatedButton.styleFrom(
                      side: BorderSide.none,
                      backgroundColor: Colors.green,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    child: const Text('Confirm'),
                  ),
                ),
              const SizedBox(height: APPSizes.spaceBtwItem),
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text(
                  'Cancel',
                  style: TextStyle(color: Colors.red),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
