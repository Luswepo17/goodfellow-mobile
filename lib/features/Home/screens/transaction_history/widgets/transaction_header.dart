import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:goodfellow/utils/constants/colors.dart';
import 'package:goodfellow/utils/constants/sizes.dart';
import 'package:goodfellow/utils/constants/text_string.dart';

class TransactionHeader extends StatelessWidget {
  final String status;

  const TransactionHeader({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            status == APPTexts.successStatus
                ? APPTexts.successfulPayment
                : status == APPTexts.pendingStatus
                ? APPTexts.pendingPayment
                : APPTexts.failedPayment,
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
            style: Theme.of(context).textTheme.headlineSmall,
          ),
        ),
        const SizedBox(width: APPSizes.spaceBtwItem),
        Icon(
          status == APPTexts.successStatus
              ? LucideIcons.badgeCheck
              : status == APPTexts.pendingStatus
              ? LucideIcons.badgeInfo
              : LucideIcons.badgeX,
          color: status == APPTexts.successStatus
              ? Colors.green
              : status == APPTexts.pendingStatus
              ? APPColors.warning
              : Colors.red,
        ),
      ],
    );
  }
}
