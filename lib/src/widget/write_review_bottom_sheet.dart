import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shopping_app/constants/app_color.dart';
import 'package:shopping_app/constants/string_extension.dart';
import 'package:shopping_app/src/widget/text_widget.dart';

class WriteReviewBottomSheet extends StatefulWidget {
  final Function(double rating, String comment) onSubmit;

  const WriteReviewBottomSheet({super.key, required this.onSubmit});

  @override
  State<WriteReviewBottomSheet> createState() => _WriteReviewBottomSheetState();
}

class _WriteReviewBottomSheetState extends State<WriteReviewBottomSheet> {
  double _rating = 0;
  final TextEditingController _commentController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = isDark ? AppColor.darkMode : Colors.white;
    final textColor = isDark ? Colors.white : Colors.black;

    return Container(
      padding: EdgeInsets.only(
        left: 20,
        right: 20,
        top: 20,
        bottom: MediaQuery.of(context).viewInsets.bottom + 40,
      ),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: isDark ? Colors.white24 : Colors.black12,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 24),
          TextWidget(
            "Write a Review".tr,
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: textColor,
          ),
          const SizedBox(height: 24),
          TextWidget(
            "How was your experience?".tr,
            fontSize: 16,
            color: isDark ? Colors.white70 : Colors.black87,
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(5, (index) {
              return GestureDetector(
                onTap: () => setState(() => _rating = index + 1.0),
                child: Icon(
                  index < _rating ? Icons.star_rounded : Icons.star_outline_rounded,
                  color: Colors.orange,
                  size: 40,
                ),
              );
            }),
          ),
          const SizedBox(height: 24),
          CupertinoTextField(
            controller: _commentController,
            placeholder: "Write your comment here...".tr,
            placeholderStyle: TextStyle(
              color: isDark ? Colors.white38 : Colors.black38,
              fontSize: 14,
            ),
            style: TextStyle(color: textColor),
            maxLines: 4,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: isDark ? Colors.white10 : Colors.grey[100],
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: CupertinoButton(
              color: AppColor.primaryColor,
              borderRadius: BorderRadius.circular(12),
              onPressed: _rating == 0
                  ? null
                  : () {
                      widget.onSubmit(_rating, _commentController.text);
                      Navigator.pop(context);
                    },
              child: TextWidget(
                "Submit Review".tr,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
