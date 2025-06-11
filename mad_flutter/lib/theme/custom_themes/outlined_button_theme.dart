import 'package:mad_flutter/theme/custom_themes/AppColors.dart';
import 'package:flutter/material.dart';

class TOutlinedButtonTheme {
  TOutlinedButtonTheme._();

  static final lightOutLinedButtonTheme = OutlinedButtonThemeData (
    style: OutlinedButton.styleFrom(
      elevation: 0,
      foregroundColor: Colors.black,
      side: const BorderSide(color: AppColors.blue),
      textStyle: const TextStyle(fontSize: 16, color: Colors.black, fontWeight: FontWeight.w600),
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
    ),
  );

  static final darkOutLinedButtonTheme = OutlinedButtonThemeData (
    style: OutlinedButton.styleFrom(
      elevation: 0,
      foregroundColor: AppColors.white,
      side: const BorderSide(color: AppColors.blue),
      textStyle: const TextStyle(fontSize: 16, color: AppColors.white, fontWeight: FontWeight.w600),
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
    ),
  );
}