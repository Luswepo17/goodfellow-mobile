import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:goodfellow/common/appbar/appbar.dart';
import 'package:goodfellow/features/Home/screens/card_payment/detect_card.dart';
import 'package:goodfellow/utils/constants/colors.dart';
import 'package:goodfellow/utils/constants/sizes.dart';
import 'package:goodfellow/utils/helpers/helper_functions.dart';

class CardPayment extends StatefulWidget {
  const CardPayment({super.key});

  @override
  State<CardPayment> createState() => _CardPaymentState();
}

class _CardPaymentState extends State<CardPayment> {
  String _amount = '';

  void _addToAmount(String value) {
    setState(() {
      if (_amount.length < 10) {
        _amount += value;
      }
    });
  }

  void _removeFromAmount() {
    setState(() {
      _amount = _amount.isNotEmpty
          ? _amount.substring(0, _amount.length - 1)
          : '';
    });
  }

  void _submitPin() {
    // Handle PIN submission
    // print('Submitted PIN: $_amount');
    // Clear the PIN after submission
    Get.to(() => const CardDetectionScreen());
    setState(() {
      _amount = '';
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: const APPAPPBar(showBackArrow: true),
        body: Padding(
          padding: const EdgeInsets.all(APPSizes.defaultSpace),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Enter your amount',
                style: Theme.of(
                  context,
                ).textTheme.bodyMedium!.apply(fontSizeDelta: 6),
              ),
              const SizedBox(height: APPSizes.spaceBtwSections),
              Text(
                _amount,
                style: Theme.of(
                  context,
                ).textTheme.headlineMedium!.apply(letterSpacingDelta: 5),
              ),
              const SizedBox(height: APPSizes.spaceBtwSections),
              GridView.count(
                crossAxisCount: 3,
                shrinkWrap: true,
                padding: const EdgeInsets.all(APPSizes.defaultSpace / 2.5),
                children: [
                  for (var i = 1; i <= 9; i++) _buildNumberButton(i.toString()),
                  _buildClearButton(),
                  _buildNumberButton('0'),
                  _buildSubmitButton(),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNumberButton(String number) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.transparent,
        side: const BorderSide(color: Colors.transparent),
        foregroundColor: APPHelperFunctions.isDarkMode(context)
            ? APPColors.white
            : APPColors.black,
      ),
      onPressed: () => _addToAmount(number),
      child: Text(number, style: Theme.of(context).textTheme.headlineMedium),
    );
  }

  Widget _buildClearButton() {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.transparent,
        side: const BorderSide(color: Colors.transparent),
        foregroundColor: APPHelperFunctions.isDarkMode(context)
            ? APPColors.white
            : APPColors.black,
      ),
      onPressed: _removeFromAmount,
      child: Text(
        '⌫',
        style: Theme.of(
          context,
        ).textTheme.headlineSmall!.apply(color: Colors.red),
      ),
    );
  }

  Widget _buildSubmitButton() {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.transparent,
        side: const BorderSide(color: Colors.transparent),
        foregroundColor: APPHelperFunctions.isDarkMode(context)
            ? APPColors.white
            : APPColors.black,
      ),
      onPressed: _submitPin,
      child: const Icon(Icons.check, size: 24, color: APPColors.primary),
    );
  }
}
