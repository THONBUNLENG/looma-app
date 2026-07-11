

import 'package:flutter/material.dart';

import '../../../constants/color.dart';
import '../../widget/button_cus.dart';

class AlertInfo extends StatelessWidget {
  const AlertInfo({super.key, required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Stack(
        clipBehavior: Clip.none,
        children: [_buildContent(), _buildHeaderIcon()],
      ),
    );
  }

  Positioned _buildHeaderIcon() {
    return Positioned(
      top: -50,
      left: 0,
      right: 0,
      child: Container(
        width: 100,
        height: 100,
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              offset: Offset(0, 3),
              blurRadius: 24,
              color: Colors.black12,
            ),
          ],
          shape: BoxShape.circle,
          color: whiteColor,
        ),
        padding: EdgeInsets.all(16),
        child: Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: pinkColor.withValues(alpha: 0.1),
          ),
          child: Icon(
            Icons.error_sharp,
            color: pinkColor.withValues(alpha: 0.5),
            size: 42,
          ),
        ),
      ),
    );
  }

  Container _buildContent() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: whiteColor,
      ),
      padding: EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(height: 50),
          Text(
            "You reached out maximum \namount of attempts. \nPlease, try later.",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
          ),
          SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 54),
            child: ButtonCus(
              buttonName: "Okay",
              bgColor: textColor,
              onPressed: onTap,
            ),
          ),
        ],
      ),
    );
  }
}
