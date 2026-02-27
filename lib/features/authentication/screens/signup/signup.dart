import 'package:flutter/material.dart';
import 'package:goodfellow/common/appbar/appbar.dart';
import 'package:goodfellow/common/styles/spacing_styles.dart';
import 'package:goodfellow/features/authentication/screens/login/widgets/login_header.dart';
import 'package:goodfellow/features/authentication/screens/signup/widgets/signup_form.dart';
import 'package:goodfellow/utils/constants/image_strings.dart';

class SignUpScreen extends StatelessWidget {
  const SignUpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: APPAPPBar(showBackArrow: true),
      body: SingleChildScrollView(
        child: Padding(
          padding: APPSpacingStyle.paddingWithAppBarHeight,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Create an Account",
                style: Theme.of(context).textTheme.headlineSmall,
              ),

              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [APPSignupForm()],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
