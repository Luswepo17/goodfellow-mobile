import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:goodfellow/bindings/general_bindings.dart';
import 'package:goodfellow/features/authentication/screens/splash/splash_screen.dart';
import 'package:goodfellow/utils/constants/colors.dart';
import 'package:goodfellow/utils/theme/theme.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Container(
      color: APPColors.accent,
      child: SafeArea(
        child: GetMaterialApp(
          debugShowCheckedModeBanner: false,
          theme: AppTheme.lightTheme,
          themeMode: ThemeMode.system,
          initialBinding: GeneralBindings(),
          darkTheme: AppTheme.darkTheme,
          home: const SplashScreen(),
        ),
      ),
    );
  }
}
