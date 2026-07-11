
import 'package:flutter/material.dart';

import '../../../constants/color.dart';

class ChipSelect extends StatelessWidget {
  const ChipSelect({
    super.key,
    this.isSelected = true,
    this.chipColor = mainColor,
    this.textColor = mainColor,
    this.chipLabel = "N/A",
    this.fontWeight = FontWeight.w700,
  });
  final bool isSelected;
  final Color chipColor;
  final Color textColor;
  final String chipLabel;
  final FontWeight fontWeight;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 80),
      padding: EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: chipColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(45),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SizedBox(width: 30, height: 30),
          Text(
            chipLabel,
            style: TextStyle(
              fontWeight: fontWeight,
              fontSize: 20,
              color: textColor,
            ),
          ),
          checkCHip(),
        ],
      ),
    );
  }

  Widget checkCHip() {
    return Container(
      width: 30,
      height: 30,
      decoration: BoxDecoration(shape: BoxShape.circle, color: whiteColor),
      child: isSelected
          ? Icon(Icons.check_circle, size: 28, color: chipColor)
          : Icon(
        Icons.circle,
        size: 28,
        color: chipColor.withValues(alpha: 0.5),
      ),
    );
  }
}
