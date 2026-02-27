import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:goodfellow/features/authentication/auth_wrapper.dart';
import 'package:goodfellow/features/Home/screens/home/home.dart';
import 'package:goodfellow/features/authentication/screens/login/login.dart';
import 'package:goodfellow/features/authentication/screens/setup/setup.dart';
import 'package:goodfellow/features/authentication/screens/splash/widgets/splash_content.dart';
import 'package:goodfellow/utils/constants/colors.dart';
import 'package:goodfellow/utils/helpers/helper_functions.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final dark = APPHelperFunctions.isDarkMode(context);
    final deviceStorage = GetStorage("setup");
    final firstTimeLogin = deviceStorage.read("firstSetup") ?? true;

    return Scaffold(
      body: AnimatedSplashScreen(
        duration: 3500,
        splashIconSize: APPHelperFunctions.screenWidth() / 0.5,
        backgroundColor: dark ? APPColors.dark : APPColors.white,
        splash: const SplashContent(),
        nextScreen: AuthenticationWrapper(
          loginPage: LoginScreen(),
          homePage: const HomeScreen(),
        ),
      ),
    );
  }
}
