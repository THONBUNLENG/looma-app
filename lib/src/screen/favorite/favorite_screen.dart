import 'package:flutter/material.dart';
import 'package:shopping_app/constants/string_extension.dart';
import 'package:shopping_app/src/screen/home_screen/shopping_bag/shopping_bag_screen.dart';
import 'package:shopping_app/src/screen/main_screen/main_holder.dart';

import '../../widget/text_widget.dart';

class WishlistScreen extends StatelessWidget {
  const WishlistScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryTextColor = isDark ? Colors.white : Colors.black;
    final secondaryTextColor = isDark ? Colors.white70 : Colors.black54;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        automaticallyImplyLeading: false,
        title: TextWidget(
          "wishlist".tr,
          textAlign: TextAlign.center,
          color: primaryTextColor,
          fontWeight: FontWeight.bold,
          fontSize: 18,
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 14),
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                IconButton(
                  splashRadius: 24,
                  icon: Icon(
                    Icons.shopping_bag_outlined,
                    color: isDark ? Colors.white : Colors.black,
                    size: 30,
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ShoppingBagScreen(),
                      ),
                    );
                  },
                ),
                Positioned(
                  right: 0,
                  top: -2,
                  child: Container(
                    width: 22,
                    height: 22,
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(100),
                      border: Border.all(
                        color: isDark ? const Color(0xFF121212) : Colors.white,
                        width: 2,
                      ),
                    ),
                    child: Center(
                      child: TextWidget(
                        '0',
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          children: [
            TextWidget(
              "Aww ..Snap. Your wish list is empty!".tr,
              textAlign: TextAlign.center,
              color: primaryTextColor,
              fontSize: 26,
              fontWeight: FontWeight.w900,
              letterSpacing: -0.5,
            ),
            const SizedBox(height: 16),
            TextWidget(
              "Check out our latest arrivals and stay up to date with our latest styles!".tr,
              textAlign: TextAlign.center,
              color: secondaryTextColor,
              fontSize: 16,
            ),
            const SizedBox(height: 48),
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: () {
                  MainHolder.of(context)?.setSelectedIndex(4);
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
                  "Start shopping".tr,
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
