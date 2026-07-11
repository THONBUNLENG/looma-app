import 'package:flutter/material.dart';
import 'package:shopping_app/constants/app_color.dart';
import 'package:shopping_app/src/widget/text_widget.dart';

class StatusDialog extends StatelessWidget {
  final String title;
  final String message;
  final String btn1Text;
  final String btn2Text;
  final IconData icon;
  final String? imagePath;
  final Color iconColor;
  final VoidCallback onBtn1Pressed;
  final VoidCallback onBtn2Pressed;

  const StatusDialog({
    super.key,
    required this.title,
    required this.message,
    this.btn1Text = "Try Again",
    this.btn2Text = "Change",
    this.icon = Icons.priority_high,
    this.imagePath,
    this.iconColor = AppColor.mutedRed,
    required this.onBtn1Pressed,
    required this.onBtn2Pressed,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: Stack(
        alignment: Alignment.topCenter,
        clipBehavior: Clip.none,
        children: [
          Container(
            padding: const EdgeInsets.fromLTRB(20, 70, 20, 20),
            decoration: BoxDecoration(
              color: AppColor.white,
              borderRadius: BorderRadius.circular(30),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  title,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: AppColor.black,
                  ),
                ),
                const SizedBox(height: 15),
                TextWidget(
                  message,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 15, color: AppColor.black),
                ),
                const SizedBox(height: 30),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor:AppColor.mutedRed,
                          foregroundColor: AppColor.white,
                          padding: const EdgeInsets.symmetric(vertical: 15),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                        onPressed: onBtn1Pressed,
                        child: Text(
                          btn1Text,
                          style: const TextStyle(fontSize: 16),
                        ),
                      ),
                    ),
                    const SizedBox(width: 15),
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColor.black,
                          foregroundColor: AppColor.white,
                          elevation: 0,
                          padding: const EdgeInsets.symmetric(vertical: 15),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                        onPressed: onBtn2Pressed,
                        child: Text(
                          btn2Text,
                          style: const TextStyle(fontSize: 16),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Positioned(
            top: -50,
            child: Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                color: AppColor.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 10,
                    spreadRadius: 5,
                  ),
                ],
              ),
              child: Center(
                child: Container(
                  width: 70,
                  height: 70,
                  padding: const EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    color: iconColor.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: imagePath != null
                      ? Image.asset(
                    imagePath!,
                    color: iconColor,
                    fit: BoxFit.contain,
                  )
                      : Icon(icon, size: 40, color: iconColor),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}