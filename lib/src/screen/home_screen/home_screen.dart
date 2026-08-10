import 'package:shopping_app/src/network/crud_firebase/all_product.dart';
import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:shopping_app/constants/string_extension.dart';
import 'package:shopping_app/src/screen/home_screen/notification_page.dart';
import 'package:shopping_app/src/screen/home_screen/pick_up_your_style.dart';
import 'package:shopping_app/src/screen/home_screen/shop_buy_item_screen.dart';
import 'package:shopping_app/src/screen/home_screen/brand/brands_screen.dart';
import 'package:shopping_app/src/screen/home_screen/top_sale_screen.dart';
import 'package:shopping_app/src/widget/cart_badge.dart';
import 'package:shopping_app/src/widget/text_widget.dart';
import 'categories_screen.dart';
import 'just_screen.dart';
import 'most_popular_screen.dart';
import 'new_item_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        toolbarHeight: 90,
        backgroundColor: isDark
            ? const Color(0xFF121212)
            : const Color(0xFFF9F9F9),
        elevation: 0,
        centerTitle: true,
        leadingWidth: 70,
        leading: Padding(
          padding: const EdgeInsets.only(left: 14),
          child: IconButton(
            splashRadius: 24,
            icon: ImageIcon(
              const AssetImage('assets/icon/notification.png'),
              color: isDark ? Colors.white : Colors.black,
              size: 26,
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => NotificationScreen()),
              );
            },
          ),
        ),

        title: ShaderMask(
          shaderCallback: (bounds) => LinearGradient(
            colors: isDark
                ? const [Colors.white, Colors.white70]
                : const [Colors.black, Colors.black54],
          ).createShader(bounds),
          child: TextWidget(
            'LOOMA',
            fontSize: 34,
            fontWeight: FontWeight.w900,
            letterSpacing: 0.5,
            color: Colors.white,
            fontStyle: FontStyle.italic,
          ),
        ),

        actions: [const CartBadge()],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(25),
          child: Container(
            width: double.infinity,
            alignment: Alignment.center,
            padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 16),
            decoration: BoxDecoration(
              color: isDark ? Colors.white10 : const Color(0xFFF1F1F1),
            ),
            child: TextWidget(
              "Spend \$160+ and enjoy Discount 15% + FREE Delivery!".tr,
              color: isDark ? Colors.white : Colors.black,
              fontSize: 12,
              fontWeight: FontWeight.w700,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
      backgroundColor: isDark
          ? Theme.of(context).scaffoldBackgroundColor
          : const Color(0xFFF8F9FA),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const ShopHeaderSection(),
              const SizedBox(height: 8),
              const BrandsScreen(),
              const SizedBox(height: 20),
              const NewItemsSection(),
              const SizedBox(height: 12),
              const ShopBuyItemScreen(categoryName: ''),
              const SizedBox(height: 20),
              CategorySection(),
              const SizedBox(height: 25),
              PickStyleSection(),
              const SizedBox(height: 18),
              const TopSaleScreen(),
              const SizedBox(height: 25),
              const MostPopularSection(),
              const SizedBox(height: 25),
              const JustForYouSection(),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}

class ShopHeaderSection extends StatefulWidget {
  const ShopHeaderSection({super.key});

  @override
  State<ShopHeaderSection> createState() => _ShopHeaderSectionState();
}

class _ShopHeaderSectionState extends State<ShopHeaderSection> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
  }

  void _startTimer(int totalItems) {
    _timer?.cancel();
    if (totalItems <= 1) return;
    _timer = Timer.periodic(const Duration(seconds: 4), (timer) {
      if (_pageController.hasClients) {
        int next = (_currentPage + 1) % totalItems;
        _pageController.animateToPage(
          next,
          duration: const Duration(milliseconds: 800),
          curve: Curves.easeInOutQuart,
        );
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final banners = bannerData;

    if (banners.isEmpty) {
      return Container(
        height: 180,
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          color: isDark
              ? Colors.white.withValues(alpha: 0.05)
              : Colors.grey[100],
          borderRadius: BorderRadius.circular(20),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/icon/i_color/no_image.png',
                height: 80,
                width: 80,
              ),
              const SizedBox(height: 10),
              TextWidget(
                "Check out our new arrivals!".tr,
                color: isDark ? Colors.white38 : Colors.black38,
              ),
            ],
          ),
        ),
      );
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_timer == null) _startTimer(banners.length);
    });

    return Column(
      children: [
        SizedBox(
          height: 250,
          child: PageView.builder(
            controller: _pageController,
            onPageChanged: (int index) => setState(() => _currentPage = index),
            itemCount: banners.length,
            itemBuilder: (context, index) {
              final banner = banners[index];
              final imageUrl = banner['image'] ?? '';
              return Container(
                margin: EdgeInsets.zero,
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.zero,
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.zero,
                  child: Stack(
                    children: [
                      CachedNetworkImage(
                        imageUrl: imageUrl,
                        height: double.infinity,
                        width: double.infinity,
                        fit: BoxFit.cover,
                        placeholder: (context, url) => Container(
                          color: isDark ? Colors.white10 : Colors.grey[200],
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.bottomCenter,
                            end: Alignment.topCenter,
                            colors: [
                              Colors.black.withValues(alpha: 0.7),
                              Colors.transparent,
                            ],
                          ),
                        ),
                      ),
                      Positioned(
                        left: 20,
                        bottom: 70,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            TextWidget(
                              (banner['title'] ?? ''),
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.w900,
                              letterSpacing: 2.0,
                            ),
                            const SizedBox(height: 4),
                            TextWidget(
                              (banner['subtitle'] ?? '').tr.toUpperCase(),
                              color: Colors.white.withValues(alpha: 0.8),
                              fontSize: 14,
                            ),
                          ],
                        ),
                      ),
                      Positioned(
                        left: 20,
                        bottom: 25,
                        child: InkWell(
                          onTap: () {},
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 14,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(9),
                            ),
                            child: Row(
                              children: [
                                TextWidget(
                                  (banner['desc'] ?? "SHOP NOW").tr
                                      .replaceAll('\n', ' ')
                                      .toUpperCase(),
                                  color: Colors.black,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                                const SizedBox(width: 6),
                                const Icon(
                                  Icons.arrow_forward_ios,
                                  color: Colors.black,
                                  size: 10,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
