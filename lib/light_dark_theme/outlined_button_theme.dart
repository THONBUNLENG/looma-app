import 'package:flutter/material.dart';

import '../constants/app_color.dart';
// Import your AppColor and SizesIcon files

class TOutlinedButtonTheme {
  TOutlinedButtonTheme._();

  /* -- Light Theme -- */
  static final lightOutlinedButtonTheme = OutlinedButtonThemeData(
    style: OutlinedButton.styleFrom(
      elevation: 0,
      foregroundColor: AppColor.darkMode,
      side: const BorderSide(color: AppColor.primaryColor),
      textStyle: const TextStyle(
        fontSize: 16,
        color: AppColor.darkMode,
        fontWeight: FontWeight.w600,
      ),
      padding: const EdgeInsets.symmetric(
        vertical: SizesIcon.buttonHeight,
        horizontal: 20,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(SizesIcon.buttonRadius),
      ),
    ),
  );

  /* -- Dark Theme -- */
  static final darkOutlinedButtonTheme = OutlinedButtonThemeData(
    style: OutlinedButton.styleFrom(
      elevation: 0,
      foregroundColor: AppColor.lightMode,
      side: const BorderSide(color: AppColor.primaryColor),
      textStyle: const TextStyle(
        fontSize: 16,
        color: AppColor.lightMode,
        fontWeight: FontWeight.w600,
      ),
      padding: const EdgeInsets.symmetric(
        vertical: SizesIcon.buttonHeight,
        horizontal: 20,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(SizesIcon.buttonRadius),
      ),
    ),
  );
}