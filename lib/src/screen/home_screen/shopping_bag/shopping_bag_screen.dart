import 'package:flutter/material.dart';
import 'package:shopping_app/manager/callback_manager.dart';
import 'package:shopping_app/src/widget/text_widget.dart';

class ShoppingBagScreen extends StatelessWidget {
  const ShoppingBagScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryColor = isDark ? Colors.white : Colors.black;
    final secondaryTextColor = isDark ? Colors.white70 : Colors.black87;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        leading: BackButton(color: primaryColor),
        title: TextWidget(
          "My shopping bag",
          color: primaryColor,
          fontWeight: FontWeight.bold,
          fontSize: 18,
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.favorite_border, color: primaryColor),
            onPressed: () {
              Navigator.pop(context);
              CallbackManager().refreshIndexStack?.call(1);
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          children: [
            const Spacer(),
            TextWidget(
              "Your bag is empty",
              textAlign: TextAlign.center,
              color: primaryColor,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
            const SizedBox(height: 16),
            TextWidget(
              "Check out our latest arrivals stay up-to-date with latest styles",
              textAlign: TextAlign.center,
              color: secondaryTextColor,
              fontSize: 16,
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  CallbackManager().refreshIndexStack?.call(4);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: isDark ? Colors.white : Colors.black,
                  foregroundColor: isDark ? Colors.black : Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  elevation: 0,
                ),
                child: TextWidget(
                  "Start shopping",
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const Spacer(flex: 3),
          ],
        ),
      ),
    );
  }
}
