import 'package:flutter/material.dart';

import '../constants/app_color.dart';

class TTextFormFieldTheme {
  TTextFormFieldTheme._();

  static InputDecorationTheme lightInputDecorationTheme = InputDecorationTheme(
    errorMaxLines: 3,
    prefixIconColor: AppColor.lightChipTheme,
    // Using your grey
    suffixIconColor: AppColor.lightChipTheme,
    labelStyle: const TextStyle().copyWith(
      fontSize: 14.0,
      color: AppColor.darkMode,
    ),
    hintStyle: const TextStyle().copyWith(
      fontSize: 14.0,
      color: AppColor.darkMode.withValues(alpha: 0.5),
    ),
    errorStyle: const TextStyle().copyWith(fontStyle: FontStyle.normal),
    floatingLabelStyle: const TextStyle().copyWith(
      color: AppColor.primaryColor,
    ),
    border: const OutlineInputBorder().copyWith(
      borderRadius: BorderRadius.circular(SizesIcon.inputFieldRadius),
      borderSide: const BorderSide(width: 1, color: AppColor.lightChipTheme),
    ),
    enabledBorder: const OutlineInputBorder().copyWith(
      borderRadius: BorderRadius.circular(SizesIcon.inputFieldRadius),
      borderSide: const BorderSide(width: 1, color: AppColor.lightChipTheme),
    ),
    focusedBorder: const OutlineInputBorder().copyWith(
      borderRadius: BorderRadius.circular(SizesIcon.inputFieldRadius),
      borderSide: const BorderSide(
        width: 1,
        color: AppColor.primaryColor,
      ), // Blue Focus
    ),
    errorBorder: const OutlineInputBorder().copyWith(
      borderRadius: BorderRadius.circular(SizesIcon.inputFieldRadius),
      borderSide: const BorderSide(width: 1, color: Colors.red),
    ),
    focusedErrorBorder: const OutlineInputBorder().copyWith(
      borderRadius: BorderRadius.circular(SizesIcon.inputFieldRadius),
      borderSide: const BorderSide(width: 2, color: Colors.red),
    ),
  );

  static InputDecorationTheme darkInputDecorationTheme = InputDecorationTheme(
    errorMaxLines: 2,
    prefixIconColor: AppColor.lightChipTheme,
    suffixIconColor: AppColor.lightChipTheme,
    labelStyle: const TextStyle().copyWith(
      fontSize: 14.0,
      color: AppColor.lightMode,
    ),
    hintStyle: const TextStyle().copyWith(
      fontSize: 14.0,
      color: AppColor.lightMode.withValues(alpha: 0.5),
    ),
    floatingLabelStyle: const TextStyle().copyWith(
      color: AppColor.primaryColor,
    ),
    border: const OutlineInputBorder().copyWith(
      borderRadius: BorderRadius.circular(SizesIcon.inputFieldRadius),
      borderSide: const BorderSide(width: 1, color: AppColor.lightChipTheme),
    ),
    enabledBorder: const OutlineInputBorder().copyWith(
      borderRadius: BorderRadius.circular(SizesIcon.inputFieldRadius),
      borderSide: const BorderSide(width: 1, color: AppColor.lightChipTheme),
    ),
    focusedBorder: const OutlineInputBorder().copyWith(
      borderRadius: BorderRadius.circular(SizesIcon.inputFieldRadius),
      borderSide: const BorderSide(width: 1, color: AppColor.lightMode),
    ),
    errorBorder: const OutlineInputBorder().copyWith(
      borderRadius: BorderRadius.circular(SizesIcon.inputFieldRadius),
      borderSide: const BorderSide(width: 1, color: Colors.red),
    ),
    focusedErrorBorder: const OutlineInputBorder().copyWith(
      borderRadius: BorderRadius.circular(SizesIcon.inputFieldRadius),
      borderSide: const BorderSide(width: 2, color: Colors.red),
    ),
  );
}
