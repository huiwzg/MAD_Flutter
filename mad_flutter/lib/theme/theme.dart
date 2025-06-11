import 'package:flutter/material.dart';
import 'package:mad_flutter/theme/custom_themes//text_theme.dart';
import 'package:mad_flutter/theme/custom_themes/elevated_button_theme.dart';
import 'package:mad_flutter/theme/custom_themes/AppColors.dart';
import 'package:mad_flutter/theme/custom_themes/appbar_theme.dart';
import 'package:mad_flutter/theme/custom_themes/bottom_sheet_theme.dart';
import 'package:mad_flutter/theme/custom_themes/checkbox_theme.dart';
import 'package:mad_flutter/theme/custom_themes/chip_theme.dart';
import 'package:mad_flutter/theme/custom_themes/outlined_button_theme.dart';
import 'package:mad_flutter/theme/custom_themes/text_field_theme.dart';

class AppTheme {
  AppTheme._();

  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    primaryColor: AppColors.blue,
    scaffoldBackgroundColor: AppColors.white,
    textTheme: TTextTheme.lightTextTheme,
    chipTheme: TChipTheme.lightChipTheme,
    appBarTheme: TAppbarTheme.lightAppbarTheme,
    checkboxTheme: TCheckboxTheme.lightCheckboxTheme,
    bottomSheetTheme: TBottomSheetTheme.lightBottomSheetTheme,
    elevatedButtonTheme: TElevatedButtonTheme.lightElevatedButtonTheme,
    outlinedButtonTheme: TOutlinedButtonTheme.lightOutLinedButtonTheme,
    inputDecorationTheme: TTextFormatFielTheme.lightInputDecorationTheme,
  );


  static ThemeData darkTheme = ThemeData (
    useMaterial3: true,
    brightness: Brightness.dark,
    primaryColor: AppColors.dark_blue,
    scaffoldBackgroundColor: AppColors.black,
    textTheme: TTextTheme.darkTextTheme,
    chipTheme: TChipTheme.darkChipTheme,
    appBarTheme: TAppbarTheme.darkAppbarTheme,
    checkboxTheme: TCheckboxTheme.darkCheckboxTheme,
    bottomSheetTheme: TBottomSheetTheme.darkBottomSheetTheme,
    elevatedButtonTheme: TElevatedButtonTheme.darkElevatedButtonTheme,
    outlinedButtonTheme: TOutlinedButtonTheme.darkOutLinedButtonTheme,
    inputDecorationTheme: TTextFormatFielTheme.darkInputDecorationTheme,
  );

}