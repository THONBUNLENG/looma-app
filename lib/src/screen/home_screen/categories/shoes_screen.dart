import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:shopping_app/constants/string_extension.dart';

import '../../../../constants/app_color.dart';
import 'package:shopping_app/src/widget/cart_badge.dart';
import '../../../widget/text_widget.dart';
import '../card_detail/product_shoes_screen.dart';
import '../filter/filter_screen.dart';


class ShoesScreen extends StatefulWidget {
  final String categoryName;
  final List<Map<String, dynamic>> shoes;
  final List<Map<String, dynamic>> shoesBoots;
  final List<Map<String, dynamic>> heeled;
  final List<Map<String, dynamic>> flats;
  final List<Map<String, dynamic>> loafers;
  final List<Map<String, dynamic>> sandals;
  final List<Map<String, dynamic>> slippers;
  final List<Map<String, dynamic>> sneakers;
  final List<Map<String, dynamic>> sportsShoes;

  const ShoesScreen({
    super.key,
    required this.categoryName,
    required this.shoes,
    required this.shoesBoots,
    required this.heeled,
    required this.flats,
    required this.loafers,
    required this.sandals,
    required this.slippers,
    required this.sneakers,
    required this.sportsShoes,
  });

  @override
  State<ShoesScreen> createState() => _ShoesScreenState();
}

class _ShoesScreenState extends State<ShoesScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  static const int _tabCount = 9;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _tabCount, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  List<List<Map<String, dynamic>>> get _tabItems {
    final List<List<Map<String, dynamic>>> allTabs = [
      widget.shoes,
      widget.shoesBoots,
      widget.heeled,
      widget.flats,
      widget.loafers,
      widget.sandals,
      widget.slippers,
      widget.sneakers,
      widget.sportsShoes,
    ];

    if (_searchQuery.isEmpty) {
      return allTabs;
    }

    final query = _searchQuery.toLowerCase();
    return allTabs.map((list) {
      return list.where((item) {
        final title = (item['title'] ?? '').toString().toLowerCase();
        return title.contains(query);
      }).toList();
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = isDark ? const Color(0xFF121212) : AppColor.white;
    final textColor = isDark ? Colors.white : AppColor.black;

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: bgColor,
        elevation: 0,
        centerTitle: true,
        leading: BackButton(color: textColor),
        title: TextWidget(
          widget.categoryName.tr.toUpperCase(),
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: textColor,
        ),
        actions: [
          CartBadge(),
          SizedBox(width: 8),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(110),
          child: Column(
            children: [
              _buildSearchBar(isDark),
              TabBar(
                controller: _tabController,
                isScrollable: true,
                indicatorColor: textColor,
                labelColor: textColor,
                unselectedLabelColor: Colors.grey,
                labelStyle: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
                tabs: [
                  Tab(text: "All".tr),
                  Tab(text: "Boots".tr),
                  Tab(text: "Heeled".tr),
                  Tab(text: "Flats".tr),
                  Tab(text: "Loafers".tr),
                  Tab(text: "Sandals".tr),
                  Tab(text: "Slippers".tr),
                  Tab(text: "Sneakers".tr),
                  Tab(text: "Sports".tr),
                ],
              ),
            ],
          ),
        ),
      ),
      body: Column(
        children: [
          AnimatedBuilder(
            animation: _tabController,
            builder: (context, _) {
              final count = _tabItems[_tabController.index].length;

              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 12),
                child: TextWidget(
                  "${count} ${"items found".tr}",
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: textColor,
                ),
              );
            },
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: _tabItems
                  .map((items) => _buildShoesGrid(items, isDark))
                  .toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar(bool isDark) {
    final textColor = isDark ? Colors.white : Colors.black;
    final searchBg = isDark ? Colors.grey[850] : Colors.grey[100];
    final hintColor = isDark ? Colors.white70 : Colors.black54;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: searchBg,
                borderRadius: BorderRadius.circular(12),
              ),
              child: TextField(
                controller: _searchController,
                onChanged: (value) {
                  setState(() {
                    _searchQuery = value;
                  });
                },
                style: TextStyle(color: textColor, fontSize: 14),
                decoration: InputDecoration(
                  hintText: "Search shoes...".tr,
                  hintStyle: TextStyle(color: hintColor, fontSize: 14),
                  prefixIcon: Icon(Icons.search, size: 20, color: hintColor),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(vertical: 12),
                  isDense: true,
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const FilterScreen()),
              );
            },
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.tune, size: 20, color: textColor),
                const SizedBox(width: 6),
                TextWidget(
                  "filter".tr,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: textColor,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildShoesGrid(List<Map<String, dynamic>> items, bool isDark) {
    if (items.isEmpty) {
      return _buildEmptyState(isDark);
    }

    return GridView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      physics: const BouncingScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.62,
        crossAxisSpacing: 16,
        mainAxisSpacing: 20,
      ),
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];
        return _buildShoeCard(context, item, isDark, index);
      },
    );
  }

  Widget _buildShoeCard(
    BuildContext context,
    Map<String, dynamic> item,
    bool isDark,
    int index,
  ) {
    final subTextColor = isDark ? Colors.white70 : Colors.black54;

    final dynamic images = item['images'];
    final String imageUrl = images is List && images.isNotEmpty
        ? images.first.toString()
        : (item['image'] ?? '').toString();

    final String title = (item['title'] ?? 'Shoe Item').toString();
    final String price = (item['price'] ?? '\$0.00').toString();
    final String rating = (item['rating'] ?? '4.8').toString();
    final String sold = (item['sold'] ?? '0').toString();
    final bool isFavorite = item['is_favorite'] ?? false;

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProductShoesScreen(product: item),
          ),
        );
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: isDark
                    ? Colors.white.withValues(alpha: 0.05)
                    : AppColor.grey100,
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Stack(
                  children: [
                    Positioned.fill(
                      child: imageUrl.isNotEmpty
                          ? Hero(
                              tag: '$imageUrl$index',
                              child: CachedNetworkImage(
                                imageUrl: imageUrl,
                                fit: BoxFit.cover,
                                placeholder: (context, url) => Center(
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: isDark
                                        ? Colors.white24
                                        : Colors.grey[300],
                                  ),
                                ),
                                errorWidget: (_, _, _) => Container(
                                  color: isDark ? Colors.white10 : AppColor.grey100,
                                  child: CachedNetworkImage(
                                    imageUrl:
                                    'https://www.pngitem.com/pimgs/m/255-2550411_no-image-available-png-transparent-no-image-available.png',
                                    fit: BoxFit.contain,
                                  ),
                                ),
                              ),
                            )
                          :  Container(
                        color: isDark ? Colors.white10 : AppColor.grey100,
                        child: CachedNetworkImage(
                          imageUrl:
                          'https://www.pngitem.com/pimgs/m/255-2550411_no-image-available-png-transparent-no-image-available.png',
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                    Positioned(
                      top: 12,
                      right: 12,
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            item['is_favorite'] = !isFavorite;
                          });
                        },
                        child: CircleAvatar(
                          radius: 18,
                          backgroundColor: Colors.white.withValues(alpha: 0.9),
                          child: Icon(
                            isFavorite ? Icons.favorite : Icons.favorite_border,
                            size: 20,
                            color: isFavorite
                                ? Colors.redAccent
                                : Colors.black26,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextWidget(
                  "LOOMA",
                  fontSize: 16,
                  letterSpacing: 1.2,
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white54 : Colors.black45,
                ),
                const SizedBox(height: 4),
                TextWidget(
                  title.tr,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white : AppColor.black,
                ),
                const SizedBox(height: 5),
                Row(
                  children: [
                    const Icon(
                      Icons.star_rounded,
                      color: Colors.orange,
                      size: 16,
                    ),
                    const SizedBox(width: 4),
                    TextWidget(
                      rating,
                      color: subTextColor,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: TextWidget(
                        "| ${sold} ${"sold".tr}",
                        color: subTextColor,
                        fontSize: 11,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                TextWidget(
                  price,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppColor.primaryColor,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(bool isDark) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CachedNetworkImage(
            imageUrl:
            'https://www.pngitem.com/pimgs/m/255-2550411_no-image-available-png-transparent-no-image-available.png',
            fit: BoxFit.contain,
            height: 200,
          ),
          const SizedBox(height: 16),
          TextWidget(
            "No shoes found".tr,
            color: isDark ? Colors.white38 : Colors.grey,
            fontSize: 16,
          ),
        ],
      ),
    );
  }
}

