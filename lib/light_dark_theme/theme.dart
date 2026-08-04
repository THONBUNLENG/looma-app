import 'package:flutter/material.dart';
import 'package:shopping_app/light_dark_theme/text_field_theme.dart';
import 'package:shopping_app/light_dark_theme/text_theme.dart';

import '../constants/app_color.dart';
import 'appbar_theme.dart';
import 'bottom_sheet_theme.dart';
import 'checkbox_theme.dart';
import 'chip_theme.dart';
import 'elevated_button_theme.dart';
import 'outlined_button_theme.dart';

class TAppTheme {
  TAppTheme._();

  /// --- Light Theme ---
  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    fontFamily: 'Poppins',
    brightness: Brightness.light,
    primaryColor: AppColor.primaryColor,
    scaffoldBackgroundColor: AppColor.lightMode,

    progressIndicatorTheme: const ProgressIndicatorThemeData(
      color: AppColor.primaryColor,
      refreshBackgroundColor: Colors.white,
    ),

    disabledColor: Colors.grey[400],

    textSelectionTheme: const TextSelectionThemeData(
      cursorColor: AppColor.primaryColor,
      selectionColor: AppColor.primarySwatch,
      selectionHandleColor: AppColor.primaryColor,
    ),

    textTheme: TTextTheme.lightTextTheme,
    chipTheme: TChipTheme.lightChipTheme,
    appBarTheme: TAppBarTheme.lightAppBarTheme,
    checkboxTheme: TCheckboxTheme.lightCheckboxTheme,
    bottomSheetTheme: TBottomSheetTheme.lightBottomSheetTheme,
    elevatedButtonTheme: TElevatedButtonTheme.lightElevatedButtonTheme,
    outlinedButtonTheme: TOutlinedButtonTheme.lightOutlinedButtonTheme,
    inputDecorationTheme: TTextFormFieldTheme.lightInputDecorationTheme,
  );

  /// --- Dark Theme ---
  static ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    fontFamily: 'Poppins',
    brightness: Brightness.dark,
    primaryColor: AppColor.primaryColor,
    scaffoldBackgroundColor: AppColor.darkMode,

    progressIndicatorTheme: const ProgressIndicatorThemeData(
      color: AppColor.primaryColor,
      refreshBackgroundColor: Colors.black,
    ),

    disabledColor: Colors.grey[700],

    textSelectionTheme: const TextSelectionThemeData(
      cursorColor: AppColor.primaryColor,
      selectionColor: AppColor.primaryColor,
      selectionHandleColor: AppColor.primaryColor,
    ),

    textTheme: TTextTheme.darkTextTheme,
    chipTheme: TChipTheme.darkChipTheme,
    appBarTheme: TAppBarTheme.darkAppBarTheme,
    checkboxTheme: TCheckboxTheme.darkCheckboxTheme,
    bottomSheetTheme: TBottomSheetTheme.darkBottomSheetTheme,
    elevatedButtonTheme: TElevatedButtonTheme.darkElevatedButtonTheme,
    outlinedButtonTheme: TOutlinedButtonTheme.darkOutlinedButtonTheme,
    inputDecorationTheme: TTextFormFieldTheme.darkInputDecorationTheme,
  );
  static ValueNotifier<ThemeMode> themeMode = ValueNotifier(ThemeMode.light);

  static void toggleTheme(ThemeMode mode) {
    themeMode.value = ThemeMode.light;
  }
}
