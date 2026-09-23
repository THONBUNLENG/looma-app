import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';

class TextWidget extends Text {
  TextWidget(
      String text, {
        super.key,
        double? fontSize,
        FontWeight? fontWeight,
        Color? color,
        super.textAlign,
        super.overflow,
        super.maxLines,
        FontStyle? fontStyle,
        TextDecoration? textDecoration,
        double? lineHeight,
        double? letterSpacing,
        super.softWrap,
        BuildContext? context,
        List<dynamic> args = const [],
        TextStyle? style,
      }) : super(
    context == null ? text : context.formatString(text, args),
    textScaler: TextScaler.noScaling,
    style:
    style ??
        TextStyle(
          fontFamily: 'english',
          fontFamilyFallback:['khmer'],
          fontSize: fontSize,
          color: color,
          fontWeight: fontWeight,
          fontStyle: fontStyle,
          decoration: textDecoration,
          height: lineHeight,
          letterSpacing: letterSpacing,
        ),
  );
}
