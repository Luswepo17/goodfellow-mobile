import 'package:flutter/material.dart';
import 'package:goodfellow/common/appbar/appbar.dart';
import 'package:goodfellow/common/text/offline_text.dart';
import 'package:goodfellow/features/Home/screens/bill_purchase/widgets/bill_purchase_form.dart';
import 'package:goodfellow/utils/constants/sizes.dart';
import 'package:goodfellow/utils/constants/text_string.dart';

class ZescoCollectionScreen extends StatelessWidget {
  const ZescoCollectionScreen({
    super.key,
    required this.mode,
    required this.code,
    required this.title,
  });

  final String mode;
  final String code;
  final String title;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: APPAPPBar(
          showBackArrow: true,
          title: Text(
            "Make $title Purchase",
            style: Theme.of(context).textTheme.headlineSmall,
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(APPSizes.defaultSpace),
          child: Column(
            children: [
              const OfflineText(),
              Text(
                APPTexts.billPurchaseSubTitle,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: APPSizes.spaceBtwSections),
              BillPurchaseForm(collectionChannel: mode, channelCode: code),
            ],
          ),
        ),
      ),
    );
  }
}
