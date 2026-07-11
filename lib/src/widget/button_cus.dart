
import 'package:flutter/material.dart';

import '../../constants/color.dart';

class ButtonCus extends StatelessWidget {
  const ButtonCus({
    super.key,
    required this.buttonName,
    this.onPressed,
    this.bgColor = mainColor,
  });
  final String buttonName;
  final VoidCallback? onPressed;
  final Color bgColor;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 61,
      width: double.infinity,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadiusGeometry.circular(16),
          ),
          backgroundColor: bgColor,
        ),
        child: Text(
          buttonName,
          style: TextStyle(
            fontWeight: FontWeight.w300,
            fontSize: 19,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
