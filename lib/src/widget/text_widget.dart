import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';

class TextWidget extends Text {
  TextWidget(
      String text, {
        Key? key,
        double? fontSize,
        FontWeight? fontWeight,
        Color? color,
        TextAlign? textAlign,
        TextOverflow? overflow,
        int? maxLines,
        FontStyle? fontStyle,
        TextDecoration? textDecoration,
        double? lineHeight,
        double? letterSpacing,
        bool? softWrap,
        BuildContext? context,
        List<dynamic> args = const [],
        TextStyle? style,
      }) : super(
    context == null ? text : context.formatString(text, args),
    key: key,
    textAlign: textAlign,
    overflow: overflow,
    maxLines: maxLines,
    textScaler: TextScaler.noScaling,
    softWrap: softWrap,
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
