import 'package:flutter/material.dart';
import 'package:goodfellow/common/appbar/appbar.dart';
import 'package:goodfellow/features/authentication/screens/kyc/widgets/kyc_form.dart';
import 'package:goodfellow/utils/constants/sizes.dart';

class KYCScreen extends StatelessWidget {
  const KYCScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: APPAPPBar(
        showBackArrow: false,
        title: Text("Know your Customer"),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(APPSizes.defaultSpace),
        child: KycForm(),
      ),
    );
  }
}
