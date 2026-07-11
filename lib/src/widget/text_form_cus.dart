
import 'package:flutter/material.dart';

import '../../constants/color.dart';

class TextFormCus extends StatelessWidget {
  const TextFormCus({
    super.key,
    required this.hintText,
    this.suffixIcon,
    this.preffixIcon,
    this.controller,
    this.validator,
  });
  final String hintText;
  final Widget? suffixIcon;
  final Widget? preffixIcon;
  final TextEditingController? controller;
  final String? Function(String?)? validator;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      validator: validator,
      decoration: InputDecoration(
        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        filled: true,

        hintText: hintText,
        prefixIcon: preffixIcon,
        suffixIcon: suffixIcon,
        fillColor: grey30Color,
        helperStyle: TextStyle(color: Colors.black12),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(32),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}
