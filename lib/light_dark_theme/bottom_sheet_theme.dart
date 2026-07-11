import 'package:flutter/material.dart';
import 'package:shopping_app/constants/app_color.dart';

class TBottomSheetTheme {
  TBottomSheetTheme._();

  static BottomSheetThemeData lightBottomSheetTheme = BottomSheetThemeData(
    showDragHandle: true,

    dragHandleColor: Colors.black12,
    backgroundColor: AppColor.lightMode,
    modalBackgroundColor: AppColor.lightMode,
    constraints: const BoxConstraints(minWidth: double.infinity),
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
    ),
  );

  static BottomSheetThemeData darkBottomSheetTheme = BottomSheetThemeData(
    showDragHandle: true,
    dragHandleColor: Colors.white24,
    backgroundColor: AppColor.darkMode,
    modalBackgroundColor: AppColor.darkMode,
    constraints: const BoxConstraints(minWidth: double.infinity),
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
    ),
  );
}