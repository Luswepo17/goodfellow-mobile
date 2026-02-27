import 'package:flutter/material.dart';
import 'package:goodfellow/utils/constants/colors.dart';
import 'package:goodfellow/utils/theme/custome_themes/appbar_theme.dart';
import 'package:goodfellow/utils/theme/custome_themes/bottom_sheet_theme.dart';
import 'package:goodfellow/utils/theme/custome_themes/checkbox_theme.dart';
import 'package:goodfellow/utils/theme/custome_themes/chip_theme.dart';
import 'package:goodfellow/utils/theme/custome_themes/elevated_button_theme.dart';
import 'package:goodfellow/utils/theme/custome_themes/outline_button_theme.dart';
import 'package:goodfellow/utils/theme/custome_themes/text_field_theme.dart';
import 'package:goodfellow/utils/theme/custome_themes/text_theme.dart';

class AppTheme {
  AppTheme._();

  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    fontFamily: 'Poppins',
    brightness: Brightness.light,
    primaryColor: APPColors.primary,
    scaffoldBackgroundColor: Colors.white,
    textTheme: APPTextTheme.lightTextTheme,
    chipTheme: APPChipTheme.lightChipTheme,
    appBarTheme: APPAppBarTheme.lightAppBarTheme,
    checkboxTheme: APPCheckboxTheme.lightCheckboxTheme,
    bottomSheetTheme: APPBottomSheetTheme.lightBottomSheetTheme,
    elevatedButtonTheme: APPElevatedButtonTheme.lightElevatedButtonTheme,
    outlinedButtonTheme: APPOutlineButtonTheme.lightOutlineButtonTheme,
    inputDecorationTheme: APPTextFieldTheme.lightInputDecorationTheme,
  );

  static ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    fontFamily: 'Poppins',
    brightness: Brightness.dark,
    primaryColor: APPColors.primary,
    scaffoldBackgroundColor: Colors.black,
    textTheme: APPTextTheme.darkTextTheme,
    chipTheme: APPChipTheme.darkChipTheme,
    appBarTheme: APPAppBarTheme.darkAppBarTheme,
    checkboxTheme: APPCheckboxTheme.darkCheckboxTheme,
    bottomSheetTheme: APPBottomSheetTheme.darkBottomSheetTheme,
    outlinedButtonTheme: APPOutlineButtonTheme.darkOutlineButtonTheme,
    elevatedButtonTheme: APPElevatedButtonTheme.darkElevatedButtonTheme,
    inputDecorationTheme: APPTextFieldTheme.darkInputDecorationTheme,
  );
}
