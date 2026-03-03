import 'package:flutter/material.dart';
import 'package:goodfellow/common/appbar/appbar.dart';
import 'package:goodfellow/features/Home/screens/pay/widgets/make_payment_form.dart';
import 'package:goodfellow/utils/constants/sizes.dart';

class PayNow extends StatelessWidget {
  const PayNow({super.key, required this.installmentId});

  final String installmentId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: APPAPPBar(
        showBackArrow: true,
        title: Text(
          "Make Payment",
          style: Theme.of(context).textTheme.headlineSmall,
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(APPSizes.defaultSpace),
        child: Column(
          children: [MakePaymentForm(installmentId: installmentId)],
        ),
      ),
    );
  }
}
