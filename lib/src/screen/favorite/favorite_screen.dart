import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:shopping_app/constants/app_color.dart';
import 'package:shopping_app/constants/string_extension.dart';
import 'package:shopping_app/manager/wishlist_manager.dart';
import 'package:shopping_app/src/screen/main_screen/main_holder.dart';

import 'package:shopping_app/src/widget/cart_badge.dart';
import 'package:shopping_app/src/widget/text_widget.dart';

import '../home_screen/card_detail/product_clothes_screen.dart';

class WishlistScreen extends StatefulWidget {
  const WishlistScreen({super.key});

  @override
  State<WishlistScreen> createState() => _WishlistScreenState();
}

class _WishlistScreenState extends State<WishlistScreen> {
  List<Map<String, dynamic>> get _wishlistItems => WishlistManager().wishlistItems;

  void _removeFromWishlist(int index) {
    setState(() {
      WishlistManager().removeFromWishlist(index);
    });
  }

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
          const CartBadge(),
        ],
      ),
      body: _wishlistItems.isEmpty
          ? _buildEmptyState(isDark, primaryTextColor, secondaryTextColor)
          : _buildWishlist(isDark),
    );
  }

  Widget _buildEmptyState(bool isDark, Color primaryTextColor, Color secondaryTextColor) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
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
          const SizedBox(height: 100),
        ],
      ),
    );
  }

  Widget _buildWishlist(bool isDark) {
    return ListView.builder(
      padding: const EdgeInsets.all(20),
      itemCount: _wishlistItems.length,
      itemBuilder: (context, index) {
        final item = _wishlistItems[index];
        return _buildWishlistItem(item, index, isDark);
      },
    );
  }

  Widget _buildWishlistItem(Map<String, dynamic> item, int index, bool isDark) {
    final String imageUrl = _getImage(item);
    
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProductClothesScreen(product: item),
          ),
        ).then((_) => setState(() {}));
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 20),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isDark ? Colors.white.withValues(alpha: 0.05) : Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            if (!isDark)
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.03),
                blurRadius: 10,
                offset: const Offset(0, 5),
              ),
          ],
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: imageUrl.isNotEmpty
                  ? CachedNetworkImage(
                      imageUrl: imageUrl,
                      width: 80,
                      height: 80,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => Container(color: Colors.grey[200]),
                      errorWidget: (context, url, error) => const Icon(Icons.broken_image),
                    )
                  : Container(
                      width: 80,
                      height: 80,
                      color: Colors.grey[200],
                      child: const Icon(Icons.image_not_supported),
                    ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextWidget(
                    item['title'] ?? 'Product',
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  TextWidget(
                    item['price']?.toString() ?? '\$0.00',
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppColor.primaryColor,
                  ),
                ],
              ),
            ),
            IconButton(
              icon: const Icon(Icons.favorite, color: Colors.red),
              onPressed: () => _removeFromWishlist(index),
            ),
          ],
        ),
      ),
    );
  }

  String _getImage(Map<String, dynamic> item) {
    if (item['images'] != null && item['images'] is List && (item['images'] as List).isNotEmpty) {
      return item['images'][0].toString();
    }
    return item['image']?.toString() ?? '';
  }
}

