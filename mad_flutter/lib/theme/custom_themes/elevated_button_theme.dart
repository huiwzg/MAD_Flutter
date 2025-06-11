import 'package:flutter/material.dart';
import 'package:mad_flutter/theme/custom_themes/AppColors.dart';

class TElevatedButtonTheme {
  TElevatedButtonTheme._();

  static final lightElevatedButtonTheme = ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      elevation: 0,
      minimumSize: Size(100, 40),
      foregroundColor: AppColors.white,
      backgroundColor: AppColors.blue,
      disabledForegroundColor: Colors.grey,
      disabledBackgroundColor: Colors.grey,
      side: const BorderSide(color: AppColors.blue),
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
      textStyle: const TextStyle(fontSize: 16, color: AppColors.white, fontWeight: FontWeight.w600),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    ),
  );

  static final darkElevatedButtonTheme = ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      elevation: 0,
      minimumSize: Size(100, 40),
      foregroundColor: AppColors.white,
      backgroundColor: AppColors.dark_blue,
      disabledForegroundColor: AppColors.grey,
      disabledBackgroundColor: Colors.grey,
      side: const BorderSide(color: AppColors.dark_blue),
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
      textStyle: const TextStyle(fontSize: 16, color: AppColors.white, fontWeight: FontWeight.w600),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    ),
  );
}