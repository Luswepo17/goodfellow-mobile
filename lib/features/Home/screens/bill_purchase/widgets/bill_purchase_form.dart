import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:goodfellow/features/Home/controllers/bills/bill_purchase_controller.dart';
import 'package:goodfellow/utils/constants/sizes.dart';
import 'package:goodfellow/utils/constants/text_string.dart';
import 'package:goodfellow/utils/validators/validation.dart';

class BillPurchaseForm extends StatefulWidget {
  const BillPurchaseForm({
    super.key,
    required this.collectionChannel,
    required this.channelCode,
  });

  final String collectionChannel;
  final String channelCode;

  @override
  State<BillPurchaseForm> createState() => _BillPurchaseFormState();
}

class _BillPurchaseFormState extends State<BillPurchaseForm> {
  @override
  Widget build(BuildContext context) {
    final controller = Get.put(
      BillPurchaseController(
        collectionChannel: widget.collectionChannel,
        channelCode: widget.channelCode,
      ),
    );
    return Form(
      key: controller.collectionFormKey,
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                flex: 4,
                child: TextFormField(
                  controller: controller.accountNumber,
                  validator: (value) =>
                      APPValidator.validateEmptyText("Account Number", value),
                  keyboardType: TextInputType.phone,
                  decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.pin_outlined),
                    labelText: APPTexts.accountNumber,
                    counterText: '',
                  ),
                  maxLength: 15,
                ),
              ),
            ],
          ),
          const SizedBox(height: APPSizes.spaceBtwInputFields),
          TextFormField(
            controller: controller.amount,
            validator: (value) => APPValidator.validateAmount(value),
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              prefixIcon: Icon(Iconsax.money),
              labelText: APPTexts.amount,
              counterText: '',
            ),
            maxLength: 5,
          ),
          const SizedBox(height: APPSizes.spaceBtwSections),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => controller.fetchUserData(),
              child: const Text(APPTexts.submit),
            ),
          ),
        ],
      ),
    );
  }
}
