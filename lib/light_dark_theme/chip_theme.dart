import 'package:flutter/material.dart';
import 'package:shopping_app/constants/app_color.dart';

class TChipTheme {
  TChipTheme._();

  static ChipThemeData lightChipTheme = ChipThemeData(
    disabledColor: AppColor.lightChipTheme.withValues(alpha: 0.4),
    labelStyle: const TextStyle(color: AppColor.darkMode),
    selectedColor: AppColor.lightChipTheme,
    padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 12),
    checkmarkColor: AppColor.lightMode,
  );

  static ChipThemeData darkChipTheme = const ChipThemeData(
    disabledColor: AppColor.lightChipTheme,
    labelStyle: TextStyle(color: AppColor.lightMode),
    selectedColor: AppColor.lightChipTheme,
    padding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 12),
    checkmarkColor: AppColor.lightMode,
  );
}
