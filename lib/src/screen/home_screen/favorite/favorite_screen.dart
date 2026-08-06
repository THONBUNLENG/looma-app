import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:lottie/lottie.dart';
import 'package:shopping_app/constants/string_extension.dart';
import 'package:shopping_app/manager/wishlist_manager.dart';
import 'package:shopping_app/manager/cart_manager.dart';
import 'package:shopping_app/src/network/datastor/auth_service.dart';
import 'package:shopping_app/src/screen/login_screen/login_screen.dart';
import 'package:shopping_app/src/screen/main_screen/main_holder.dart';

import 'package:shopping_app/src/widget/cart_badge.dart';
import 'package:shopping_app/src/widget/text_widget.dart';

import '../../../../manager/callback_manager.dart';
import '../product_detail/product_detail_screen.dart';

class WishlistScreen extends StatefulWidget {
  const WishlistScreen({super.key});

  @override
  State<WishlistScreen> createState() => _WishlistScreenState();
}

class _WishlistScreenState extends State<WishlistScreen> {
  bool _isLoading = true;
  bool _isLoggedIn = false;
  int _selectedTab = 0; // 0: All items, 1: Boards
  List<Map<String, dynamic>> get _wishlistItems => WishlistManager().wishlistItems;

  @override
  void initState() {
    super.initState();
    _checkAuth();
    CallbackManager().refreshWishlist = () {
      if (mounted) setState(() {});
    };
  }

  Future<void> _checkAuth() async {
    final loggedIn = await AuthService.isLoggedIn();
    if (mounted) {
      setState(() {
        _isLoggedIn = loggedIn;
        _isLoading = false;
      });
    }
  }

  void _removeFromWishlist(int index) {
    setState(() {
      WishlistManager().removeFromWishlist(index);
    });
  }

  void _addToBag(Map<String, dynamic> item) {
    CartManager().addToCart({
      ...item,
      'quantity': 1,
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: TextWidget("Added to Bag".tr, color: Colors.white),
        backgroundColor: Colors.black,
        duration: const Duration(seconds: 1),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryTextColor = isDark ? Colors.white : Colors.black;
    final bgColor = isDark ? const Color(0xFF121212) : Colors.white;

    if (_isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (!_isLoggedIn) {
      return _buildLoginRequiredView(context, isDark);
    }

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: bgColor,
        elevation: 0,
        centerTitle: true,
        automaticallyImplyLeading: false,
        leading: Icon(Icons.sort_rounded, color: primaryTextColor),
        title: TextWidget(
          "WISHLIST".tr,
          textAlign: TextAlign.center,
          color: primaryTextColor,
          fontWeight: FontWeight.w900,
          fontSize: 18,
          letterSpacing: 1.2,
        ),
        actions: [
          const CartBadge(),
        ],
      ),
      body: Column(
        children: [
          _buildTabToggle(isDark),
          Expanded(
            child: ListenableBuilder(
              listenable: WishlistManager(),
              builder: (context, _) {
                if (_wishlistItems.isEmpty) {
                  return _buildEmptyState(isDark, primaryTextColor);
                }
                return _buildWishlist(isDark);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabToggle(bool isDark) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Container(
        height: 40,
        decoration: BoxDecoration(
          color: Colors.transparent,
          border: Border.all(color: isDark ? Colors.white24 : Colors.black, width: 1.2),
        ),
        child: Row(
          children: [
            _buildTabItem("All items".tr, 0, isDark),
            _buildTabItem("Boards".tr, 1, isDark),
          ],
        ),
      ),
    );
  }

  Widget _buildTabItem(String title, int index, bool isDark) {
    final isSelected = _selectedTab == index;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _selectedTab = index),
        child: Container(
          alignment: Alignment.center,
          color: isSelected ? (isDark ? Colors.white : Colors.black) : Colors.transparent,
          child: TextWidget(
            title,
            color: isSelected ? (isDark ? Colors.black : Colors.white) : (isDark ? Colors.white70 : Colors.black),
            fontWeight: FontWeight.bold,
            fontSize: 13,
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState(bool isDark, Color primaryTextColor) {
    final secondaryTextColor = isDark ? Colors.white70 : Colors.black54;
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Lottie.asset(
              'assets/lottie/love.json',
              width: 120,
              height: 120,
              fit: BoxFit.contain,
            ),
            const SizedBox(height: 24),
            TextWidget(
              "Your Wishlist is Empty".tr,
              textAlign: TextAlign.center,
              color: primaryTextColor,
              fontSize: 20,
              fontWeight: FontWeight.w900,
            ),
            const SizedBox(height: 8),
            TextWidget(
              "Tap heart button to start saving your favorite items.".tr,
              textAlign: TextAlign.center,
              color: secondaryTextColor,
              fontSize: 14,
            ),
            const SizedBox(height: 24),
            OutlinedButton(
              onPressed: () {
                MainHolder.of(context)?.setSelectedIndex(0);
              },
              style: OutlinedButton.styleFrom(
                side: BorderSide(color: isDark ? Colors.white24 : Colors.black12, width: 1.5),
                shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
              ),
              child: TextWidget(
                "Add Now".tr,
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: primaryTextColor,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWishlist(bool isDark) {
    if (_selectedTab == 1) {
      return Center(
        child: TextWidget(
          "Boards Coming Soon".tr,
          color: isDark ? Colors.white54 : Colors.black54,
          fontSize: 16,
        ),
      );
    }
    return ListView.separated(
      padding: const EdgeInsets.symmetric(vertical: 10),
      itemCount: _wishlistItems.length,
      separatorBuilder: (_, _) => Divider(
        height: 1,
        thickness: 0.5,
        color: isDark ? Colors.white12 : Colors.black12,
      ),
      itemBuilder: (context, index) {
        final item = _wishlistItems[index];
        return _buildWishlistItem(item, index, isDark);
      },
    );
  }

  Widget _buildWishlistItem(Map<String, dynamic> item, int index, bool isDark) {
    final String imageUrl = _getImage(item);
    final primaryTextColor = isDark ? Colors.white : Colors.black;
    final secondaryTextColor = isDark ? Colors.white54 : Colors.grey;
    final String itemId = "ITEM ID: ${item['id'] ?? '10972345'}";
    final String category = (item['subCategory'] ?? item['category'] ?? 'General').toString();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ProductClothesScreen(product: item),
                  ),
                );
              },
              child: ClipRRect(
                borderRadius: BorderRadius.zero,
                child: imageUrl.isNotEmpty
                    ? CachedNetworkImage(
                        imageUrl: imageUrl,
                        width: 100,
                        height: 130,
                        fit: BoxFit.cover,
                        placeholder: (context, url) => Container(color: Colors.grey[100]),
                        errorWidget: (context, url, error) => const Icon(Icons.broken_image),
                      )
                    : Container(
                        width: 100,
                        height: 130,
                        color: Colors.grey[100],
                        child: const Icon(Icons.image_not_supported),
                      ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: TextWidget(
                          (item['title'] ?? 'Product').toString().tr,
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: primaryTextColor,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  TextWidget(
                    itemId,
                    fontSize: 11,
                    color: secondaryTextColor,
                  ),
                  const SizedBox(height: 2),
                  TextWidget(
                    category,
                    fontSize: 11,
                    color: secondaryTextColor,
                  ),
                  const Spacer(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      TextWidget(
                        item['price']?.toString() ?? '\$0.00',
                        fontSize: 16,
                        fontWeight: FontWeight.w900,
                        color: primaryTextColor,
                      ),
                      GestureDetector(
                        onTap: () => _addToBag(item),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          decoration: BoxDecoration(
                            color: isDark ? Colors.white : Colors.black,
                            borderRadius: BorderRadius.zero,
                          ),
                          child: TextWidget(
                            "Add to Bag".tr,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: isDark ? Colors.black : Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            // Close button at top right
            Align(
              alignment: Alignment.topRight,
              child: IconButton(
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
                icon: Icon(Icons.close, color: secondaryTextColor, size: 18),
                onPressed: () => _removeFromWishlist(index),
              ),
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

  Widget _buildLoginRequiredView(BuildContext context, bool isDark) {
    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF121212) : Colors.white,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  color: isDark ? Colors.white10 : Colors.grey[100],
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.favorite_outline_rounded,
                  size: 50,
                  color: isDark ? Colors.white54 : Colors.grey,
                ),
              ),
              const SizedBox(height: 24),
              TextWidget(
                "Login Required".tr,
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: isDark ? Colors.white : Colors.black,
              ),
              const SizedBox(height: 12),
              TextWidget(
                "Please login to view your wishlist and save your favorite items.".tr,
                textAlign: TextAlign.center,
                fontSize: 14,
                color: isDark ? Colors.white60 : Colors.grey,
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => LoginScreen(),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor:  Colors.black,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
                  ),
                  child: TextWidget(
                    "Login Now".tr,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
