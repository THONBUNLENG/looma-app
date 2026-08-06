import 'package:flutter/material.dart';
import 'package:shopping_app/manager/wishlist_manager.dart';
import 'package:shopping_app/src/network/datastor/auth_service.dart';
import 'package:shopping_app/src/screen/login_screen/login_screen.dart';
import 'package:shopping_app/constants/string_extension.dart';
import 'text_widget.dart';

class FavoriteButton extends StatelessWidget {
  final Map<String, dynamic> product;
  final double size;
  final Color? color;
  final bool showBackground;

  const FavoriteButton({
    super.key,
    required this.product,
    this.size = 24,
    this.color,
    this.showBackground = false,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final manager = WishlistManager();

    return ListenableBuilder(
      listenable: manager,
      builder: (context, _) {
        final isFavorite = manager.isFavorite(product);
        
        Widget icon = Icon(
          isFavorite ? Icons.favorite : Icons.favorite_border,
          size: size,
          color: isFavorite ? Colors.red : (color ?? (isDark ? Colors.white60 : Colors.black26)),
        );

        if (showBackground) {
          return GestureDetector(
            onTap: () => _handleTap(context),
            child: CircleAvatar(
              radius: size * 0.85,
              backgroundColor: isDark 
                  ? Colors.black38 
                  : Colors.white.withValues(alpha: 0.9),
              child: icon,
            ),
          );
        }

        return GestureDetector(
          onTap: () => _handleTap(context),
          child: icon,
        );
      },
    );
  }

  void _handleTap(BuildContext context) async {
    if (await AuthService.isLoggedIn()) {
      final manager = WishlistManager();
      final isFavorite = manager.isFavorite(product);
      manager.toggleWishlist(product);
      
      if (!isFavorite) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).clearSnackBars();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: TextWidget("Added to Wishlist".tr, color: Colors.white),
              backgroundColor: Colors.black87,
              duration: const Duration(seconds: 1),
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
          );
        }
      }
    } else {
      if (context.mounted) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => LoginScreen()),
        );
      }
    }
  }
}
