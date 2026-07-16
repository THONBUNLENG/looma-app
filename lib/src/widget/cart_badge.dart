import 'package:flutter/material.dart';
import 'package:shopping_app/manager/cart_manager.dart';
import 'package:shopping_app/src/screen/home_screen/shopping_bag/shopping_bag_screen.dart';
import 'package:shopping_app/constants/app_color.dart';
import 'package:shopping_app/src/widget/text_widget.dart';

class CartBadge extends StatelessWidget {
  final Color? iconColor;
  final double iconSize;
  final bool showBackground;

  const CartBadge({
    super.key,
    this.iconColor,
    this.iconSize = 30,
    this.showBackground = false,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final effectiveIconColor = iconColor ?? (isDark ? Colors.white : Colors.black);

    Widget iconButton = IconButton(
      padding: EdgeInsets.zero,
      constraints: const BoxConstraints(),
      splashRadius: 24,
      icon: Icon(
        Icons.shopping_bag_outlined,
        color: effectiveIconColor,
        size: iconSize,
      ),
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const ShoppingBagScreen(),
          ),
        );
      },
    );

    if (showBackground) {
      iconButton = CircleAvatar(
        radius: 22,
        backgroundColor: Colors.black26,
        child: iconButton,
      );
    }

    return Padding(
      padding: const EdgeInsets.only(right: 14),
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.center,
        children: [
          iconButton,
          Positioned(
            right: showBackground ? 2 : -2,
            top: showBackground ? 2 : -2,
            child: ListenableBuilder(
              listenable: CartManager(),
              builder: (context, _) {
                final int count = CartManager().totalQuantity;
                if (count == 0) return const SizedBox.shrink();
                
                return Container(
                  width: 20,
                  height: 20,
                  decoration: BoxDecoration(
                    color: AppColor.pink100Color,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Colors.white,
                      width: 1.5,
                    ),
                  ),
                  child: Center(
                    child: TextWidget(
                      count > 99 ? '99+' : count.toString(),
                      color: Colors.white,
                      fontSize: 9,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
