import 'package:flutter/material.dart';

import '../../../constants/color.dart';

enum PinStatus { typing, correct, wrong }

class PasswordDot extends StatelessWidget {
  const PasswordDot({
    super.key,
    required this.fillCount,
    this.totalCount = 8,
    this.status = PinStatus.typing,
  });

  final int fillCount;
  final int totalCount;
  final PinStatus status;

  Color checkColor(bool isFilled) {
    if (!isFilled) return greyColor;
    switch (status) {
      case PinStatus.correct:
        return mainColor;
      case PinStatus.wrong:
        return Colors.red;
      case PinStatus.typing:
        return mainColor;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          spacing: 16,
          children: List.generate(totalCount, (index) {
            final isFilled = index < fillCount;
            return Container(
              width: 18,
              height: 18,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: checkColor(isFilled),
              ),
            );
          }),
        ),
      ],
    );
  }
}
