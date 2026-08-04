import 'package:flutter/material.dart';
import 'package:shopping_app/constants/string_extension.dart';
import '../../../widget/cart_badge.dart';
import '../../../widget/text_widget.dart';
import '../notification_page.dart';

class SearchMenuScreen extends StatefulWidget {
  const SearchMenuScreen({super.key});

  @override
  State<SearchMenuScreen> createState() => _SearchMenuScreenState();
}

class _SearchMenuScreenState extends State<SearchMenuScreen> {
  int _selectedCategoryIndex = 0;
  final List<String> _categories = [
    "WOMEN",
    "MEN",
    "KIDS",
    "L.HOME",
    "LIFESTYLE",
  ];
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme
        .of(context)
        .brightness == Brightness.dark;
    final primaryColor = isDark ? Colors.white : Colors.black;
    final secondaryColor = isDark ? Colors.white38 : Colors.grey[400]!;

    return Scaffold(
      backgroundColor: Theme
          .of(context)
          .scaffoldBackgroundColor,
      appBar: _buildSearchHeader(context, isDark, primaryColor),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSearchBar(isDark, primaryColor),
          _buildCategoryTabs(primaryColor, secondaryColor),
          _buildBanner(isDark),
          Expanded(
            child: _buildMenuList(isDark),
          ),
        ],
      ),
    );
  }

  Widget _buildBanner(bool isDark) {
    return Container(
      width: double.infinity,
      alignment: Alignment.center,
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        color: isDark ? Colors.white10 : const Color(0xFFF5F5F5),
      ),
      child: TextWidget(
        "Spend \$160+ and enjoy Discount 15% + FREE Delivery!".tr,
        color: isDark ? Colors.white : Colors.black,
        fontSize: 12,
        fontWeight: FontWeight.w700,
      ),
    );
  }

  Widget _buildMenuList(bool isDark) {
    final items = [
      {"label": "New In", "color": null},
      {"label": "Clothing", "color": null},
      {"label": "Accessories", "color": null},
      {"label": "Shoes", "color": null},
      {"label": "Shop by collection", "color": null},
      {"label": "SALE", "color": Colors.red},
    ];

    return ListView.separated(
      itemCount: items.length,
      separatorBuilder: (context, index) =>
          Divider(
            height: 1,
            color: isDark ? Colors.white12 : Colors.grey[300],
            indent: 16,
            endIndent: 16,
          ),
      itemBuilder: (context, index) {
        final item = items[index];
        final label = item["label"] as String;
        final color = item["color"] as Color?;

        return ListTile(
          onTap: () {},
          title: TextWidget(
            label.tr,
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: color ?? (isDark ? Colors.white : Colors.black),
          ),
          trailing: Icon(
            Icons.chevron_right,
            size: 20,
            color: color ?? (isDark ? Colors.white54 : Colors.black54),
          ),
          contentPadding: const EdgeInsets.symmetric(
              horizontal: 16, vertical: 4),
        );
      },
    );
  }

  PreferredSizeWidget _buildSearchHeader(BuildContext context,
      bool isDark,
      Color color,) {
    return AppBar(
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
        shaderCallback: (bounds) =>
            LinearGradient(
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
    );
  }

  Widget _buildSearchBar(bool isDark, Color color) {
    final textColor = isDark ? Colors.white : Colors.black;
    final searchBg = isDark ? Colors.white.withValues(alpha: 0.1) : const Color(
        0xFFF5F5F5);
    final hintColor = isDark ? Colors.white60 : Colors.black45;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Container(
        height: 44,
        decoration: BoxDecoration(
          color: searchBg,
          borderRadius: BorderRadius.circular(4),
        ),
        child: TextField(
          controller: _searchController,
          style: TextStyle(
              color: textColor, fontSize: 15, fontWeight: FontWeight.w400),
          decoration: InputDecoration(
            hintText: "What are you searching for?".tr,
            hintStyle: TextStyle(color: hintColor, fontSize: 15),
            prefixIcon: Icon(Icons.search_rounded, size: 22, color: hintColor),
            border: InputBorder.none,
            contentPadding: const EdgeInsets.symmetric(vertical: 10),
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryTabs(Color active, Color inactive) {
    return Container(
      height: 44,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(
            color: Colors.grey.withValues(alpha: 0.1),
            width: 1,
          ),
        ),
      ),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 10),
        itemCount: _categories.length,
        itemBuilder: (context, index) {
          bool isActive = _selectedCategoryIndex == index;
          return GestureDetector(
            onTap: () => setState(() => _selectedCategoryIndex = index),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: isActive ? Colors.black : Colors.transparent,
                    width: 3,
                  ),
                ),
              ),
              child: Center(
                child: TextWidget(
                  _categories[index].tr,
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                  color: isActive ? Colors.black : Colors.grey[400],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
