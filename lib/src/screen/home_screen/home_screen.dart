import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:shopping_app/constants/string_extension.dart';
import 'package:shopping_app/src/screen/home_screen/notification_page.dart';
import 'package:shopping_app/src/screen/home_screen/pick_up_your_style.dart';
import 'package:shopping_app/src/screen/home_screen/shop_buy_item_screen.dart';
import 'package:shopping_app/src/screen/home_screen/shopping_bag/shopping_bag_screen.dart';
import 'package:shopping_app/src/screen/home_screen/Brands_screen.dart';
import 'package:shopping_app/src/screen/home_screen/top_sale_screen.dart';
import 'package:shopping_app/src/widget/text_widget.dart';
import '../list_url.dart';
import '../profile_screen/story.dart';
import 'categories_screen.dart';
import 'flash_sale_screen.dart';
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
                        builder: (context) => ShoppingBagScreen(),
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
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(8),
          child: Container(
            width: double.infinity,
            alignment: Alignment.center,
            padding: const EdgeInsets.symmetric(vertical: 4),
            decoration: BoxDecoration(
              color: isDark ? Colors.white10 : const Color(0xFFF1F1F1),
            ),
            child: TextWidget(
              "Spend \$160+ and enjoy Discount 15% + FREE Delivery!".tr,
              color: isDark ? Colors.white : Colors.black,
              fontSize: 12,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ),
      backgroundColor: isDark
          ? Theme.of(context).scaffoldBackgroundColor
          : const Color(0xFFF8F9FA),
      body: FlashSalePopupTimer(
        child: SafeArea(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ShopHeaderSection(),
                SizedBox(height: 8),
                CategorySection(),
                SizedBox(height: 12),
                StoriesSection(),
                SizedBox(height: 20),
                BrandsScreen(),
                SizedBox(height: 25),
                NewItemsSection(),
                SizedBox(height: 12),
                PickStyleSection(),
                SizedBox(height: 18),
                FlashSalePopupTimer(child: TopSaleScreen()),
                SizedBox(height: 25),
                MostPopularSection(),
                ShopBuyItemScreen(categoryName: ''),
                SizedBox(height: 25),
                JustForYouSection(justForYouData: justForYouData),
                SizedBox(height: 30),
              ],
            ),
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
    _startTimer();
  }

  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 4), (timer) {
      if (_pageController.hasClients) {
        int next = (_currentPage + 1) % bannerData.length;
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

    return Column(
      children: [
        SizedBox(
          height: 250,
          child: PageView.builder(
            controller: _pageController,
            onPageChanged: (int index) => setState(() => _currentPage = index),
            itemCount: bannerData.length,
            itemBuilder: (context, index) {
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
                        imageUrl: bannerData[index]["image"]!,
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
                              bannerData[index]["title"]!.toUpperCase().tr,
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.w900,
                              letterSpacing: 2.0,
                            ),
                            const SizedBox(height: 4),
                            TextWidget(
                              bannerData[index]["subtitle"]!.toUpperCase(),
                              color: Colors.white.withValues(alpha: 0.8),
                              fontSize: 14,
                            ),
                          ],
                        ),
                      ),
                      Positioned(
                        left: 20,
                        bottom: 25,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(9),
                          ),
                          child: TextWidget(
                            bannerData[index]["desc"]!
                                .replaceAll('\n', ' ')
                                .toUpperCase(),
                            color: Colors.black,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.2,
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
        Padding(
          padding: const EdgeInsets.only(top: 15, bottom: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              bannerData.length,
              (index) => _buildDot(index == _currentPage, isDark),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDot(bool isActive, bool isDark) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      margin: const EdgeInsets.symmetric(horizontal: 3),
      height: 6,
      width: isActive ? 24 : 6,
      decoration: BoxDecoration(
        color: isActive
            ? (isDark ? Colors.white : const Color(0xFF0052D4))
            : (isDark ? Colors.white24 : const Color(0xFFDDE6F5)),
        borderRadius: BorderRadius.circular(10),
      ),
    );
  }
}
