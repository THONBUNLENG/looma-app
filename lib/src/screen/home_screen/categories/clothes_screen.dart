import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:shopping_app/src/widget/cart_badge.dart';
import 'package:shopping_app/src/widget/text_widget.dart';

import '../../../../constants/app_color.dart';
import '../card_detail/product_clothes_screen.dart';
import '../filter/filter_screen.dart';


class ClothesScreen extends StatefulWidget {
  final String categoryName;
  final List<Map<String, dynamic>> clothes;
  final List<Map<String, dynamic>> polos;
  final List<Map<String, dynamic>> activewear;
  final List<Map<String, dynamic>> jackets;
  final List<Map<String, dynamic>> jeans;
  final List<Map<String, dynamic>> joggers;
  final List<Map<String, dynamic>> leggings;
  final List<Map<String, dynamic>> pants;
  final List<Map<String, dynamic>> shirts;
  final List<Map<String, dynamic>> skirt;
  final List<Map<String, dynamic>> suits;
  final List<Map<String, dynamic>> sweatshirts;
  final List<Map<String, dynamic>> tShirts;
  final List<Map<String, dynamic>> blouses;
  final List<Map<String, dynamic>> cardigans;
  final List<Map<String, dynamic>> coats;
  final List<Map<String, dynamic>> dresses;
  final List<Map<String, dynamic>> essentialHoodies;
  final List<Map<String, dynamic>> shorts;
  final List<Map<String, dynamic>> skirts;

  const ClothesScreen({
    super.key,
    this.categoryName = "Clothes",
    required this.clothes,
    required this.polos,
    required this.activewear,
    required this.jackets,
    required this.jeans,
    required this.joggers,
    required this.leggings,
    required this.pants,
    required this.shirts,
    required this.skirt,
    required this.suits,
    required this.sweatshirts,
    required this.tShirts,
    required this.blouses,
    required this.cardigans,
    required this.coats,
    required this.dresses,
    required this.essentialHoodies,
    required this.shorts,
    required this.skirts,
  });

  @override
  State<ClothesScreen> createState() => _ClothesScreenState();
}

class _ClothesScreenState extends State<ClothesScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;
  late TextEditingController _searchController;
  String _searchQuery = "";

  static const int _tabCount = 20;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _tabCount, vsync: this);
    _searchController = TextEditingController();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  List<List<Map<String, dynamic>>> get _tabItems {
    final List<List<Map<String, dynamic>>> allTabs = [
      widget.clothes,
      widget.polos,
      widget.activewear,
      widget.jackets,
      widget.jeans,
      widget.joggers,
      widget.leggings,
      widget.pants,
      widget.shirts,
      widget.skirt,
      widget.suits,
      widget.sweatshirts,
      widget.tShirts,
      widget.blouses,
      widget.cardigans,
      widget.coats,
      widget.dresses,
      widget.essentialHoodies,
      widget.shorts,
      widget.skirts,
    ];

    if (_searchQuery.isEmpty) {
      return allTabs;
    }

    return allTabs.map((list) {
      return list.where((item) {
        final title = (item['title'] ?? '').toString().toLowerCase();
        final description = (item['description'] ?? '').toString().toLowerCase();
        return title.contains(_searchQuery.toLowerCase()) || 
               description.contains(_searchQuery.toLowerCase());
      }).toList();
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = isDark ? const Color(0xFF121212) : AppColor.white;
    final textColor = isDark ? Colors.white : Colors.black;

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: bgColor,
        elevation: 0,
        centerTitle: true,
        iconTheme: IconThemeData(color: textColor),
        title: TextWidget(
          widget.categoryName.toUpperCase(),
          fontSize: 18,
          fontWeight: FontWeight.w900,
          color: textColor,
          letterSpacing: 1.2,
        ),
        actions: [
          CartBadge(),
          SizedBox(width: 8),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(115),
          child: Column(
            children: [
              _buildSearchBar(context, isDark),
              TabBar(
                controller: _tabController,
                isScrollable: true,
                indicatorColor: textColor,
                labelColor: textColor,
                unselectedLabelColor: Colors.grey,
                indicatorWeight: 3,
                labelStyle: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
                tabs: const [
                  Tab(text: "All"),
                  Tab(text: "Polos"),
                  Tab(text: "Activewear"),
                  Tab(text: "Jackets"),
                  Tab(text: "Jeans"),
                  Tab(text: "Joggers"),
                  Tab(text: "Leggings"),
                  Tab(text: "Pants"),
                  Tab(text: "Shirts"),
                  Tab(text: "Skirt"),
                  Tab(text: "Suits"),
                  Tab(text: "Sweatshirts"),
                  Tab(text: "T-Shirts"),
                  Tab(text: "Blouses"),
                  Tab(text: "Cardigans"),
                  Tab(text: "Coats"),
                  Tab(text: "Dresses"),
                  Tab(text: "Essential Hoodies"),
                  Tab(text: "Shorts"),
                  Tab(text: "Skirts"),
                ],
              ),
            ],
          ),
        ),
      ),
      body: Column(
        children: [
          AnimatedBuilder(
            animation: Listenable.merge([_tabController, _searchController]),
            builder: (context, _) {
              final items = _tabItems[_tabController.index];
              final count = items.length;

              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 12),
                child: TextWidget(
                  "$count items found",
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
                  .map((items) => _buildProductGrid(items, isDark))
                  .toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar(BuildContext context, bool isDark) {
    final textColor = isDark ? Colors.white : Colors.black;
    final searchBg = isDark ? Colors.white.withValues(alpha: 0.1) : AppColor.grey100;
    final hintColor = isDark ? Colors.white60 : Colors.black45;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Row(
        children: [
          Expanded(
            child: Container(
              height: 48,
              decoration: BoxDecoration(
                color: searchBg,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: isDark ? Colors.white10 : Colors.transparent,
                ),
              ),
              child: TextField(
                controller: _searchController,
                onChanged: (value) {
                  setState(() {
                    _searchQuery = value;
                  });
                },
                style: TextStyle(
                  color: textColor,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
                textAlignVertical: TextAlignVertical.center,
                decoration: InputDecoration(
                  hintText: "Search in ${widget.categoryName}...",
                  hintStyle: TextStyle(color: hintColor, fontSize: 14),
                  prefixIcon: Icon(Icons.search_rounded, size: 22, color: hintColor),
                  suffixIcon: _searchQuery.isNotEmpty
                      ? IconButton(
                          icon: Icon(Icons.cancel_rounded, size: 20, color: hintColor),
                          onPressed: () {
                            setState(() {
                              _searchController.clear();
                              _searchQuery = "";
                            });
                          },
                        )
                      : null,
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const FilterScreen()),
              );
            },
            borderRadius: BorderRadius.circular(12),
            child: Container(
              height: 48,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  Icon(
                    Icons.tune_rounded,
                    size: 20,
                    color: isDark ? Colors.white : Colors.black,
                  ),
                  const SizedBox(width: 8),
                  TextWidget(
                    "Filter",
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color:isDark ? Colors.white : Colors.black,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProductGrid(List<Map<String, dynamic>> items, bool isDark) {
    if (items.isEmpty) {
      return _buildEmptyState(isDark);
    }

    return GridView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      physics: const BouncingScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.58,
        crossAxisSpacing: 16,
        mainAxisSpacing: 20,
      ),
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];
        return _buildProductCard(context, item, isDark, index);
      },
    );
  }

  Widget _buildProductCard(
    BuildContext context,
    Map<String, dynamic> item,
    bool isDark,
    int index,
  ) {
    final dynamic images = item['images'];
    final String imageUrl = images is List && images.isNotEmpty
        ? images.first.toString()
        : (item['image'] ?? '').toString();

    final String title = (item['title'] ?? 'Fashion Item').toString();
    final String price = (item['price'] ?? '\$0.00').toString();
    final bool isFavorite = item['is_favorite'] ?? false;

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProductClothesScreen(product: item),
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
                boxShadow: [
                  if (!isDark)
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 5),
                    ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Stack(
                  children: [
                    Positioned.fill(
                      child: imageUrl.isNotEmpty
                          ? Hero(
                              tag: 'clothes_${item['id'] ?? index}',
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
                                  color: isDark
                                      ? Colors.white10
                                      : AppColor.grey100,
                                  child: CachedNetworkImage(
                                    imageUrl:
                                        'https://www.pngitem.com/pimgs/m/255-2550411_no-image-available-png-transparent-no-image-available.png',
                                    fit: BoxFit.contain,
                                  ),
                                ),
                              ),
                            )
                          : Container(
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
                    Positioned(
                      bottom: 12,
                      left: 12,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.black.withValues(alpha: 0.6),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.wb_sunny, color: Colors.yellow, size: 12),
                            SizedBox(width: 4),
                            Text(
                              "New In",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),
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
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: isDark ? Colors.white : AppColor.black,
                ),
                const SizedBox(height: 4),
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
            width: 150,
          ),
          const SizedBox(height: 16),
          TextWidget(
            _searchQuery.isEmpty
                ? "No clothes found in this category"
                : "No items found for '$_searchQuery'",
            color: isDark ? Colors.white38 : Colors.grey,
            fontSize: 16,
          ),
        ],
      ),
    );
  }
}

