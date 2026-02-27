import 'package:flutter/material.dart';
import 'package:goodfellow/common/styles/spacing_styles.dart';
import 'package:goodfellow/features/authentication/screens/login/widgets/login_form.dart';
import 'package:goodfellow/features/authentication/screens/login/widgets/login_header.dart';
import 'package:goodfellow/utils/constants/image_strings.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: APPSpacingStyle.paddingWithAppBarHeight,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [APPLoginHeader(), APPLoginForm()],
              ),
              Image(height: 80, image: AssetImage(APPImages.poweredBy)),
            ],
          ),
        ),
      ),
    );
  }
}
