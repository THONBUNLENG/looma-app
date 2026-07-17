import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:shopping_app/constants/string_extension.dart';

import '../../../../constants/app_color.dart';
import 'package:shopping_app/src/widget/cart_badge.dart';
import '../../../widget/text_widget.dart';
import '../card_detail/product_lingerie_screen.dart';
import '../filter/filter_screen.dart';


class LingerieScreen extends StatefulWidget {
  final String categoryName;
  final List<Map<String, dynamic>> lingerie;
  final List<Map<String, dynamic>> bodysuitProduct;
  final List<Map<String, dynamic>> nightwearProducts;
  final List<Map<String, dynamic>> pantyProducts;
  final List<Map<String, dynamic>> shapewearProducts;
  final List<Map<String, dynamic>> sockProducts;
  final List<Map<String, dynamic>> tightsProducts;
  final List<Map<String, dynamic>> braProducts;
  final List<Map<String, dynamic>> bridalLingerieProducts;

  const LingerieScreen({
    super.key,
    required this.categoryName,
    required this.lingerie,
    required this.bodysuitProduct,
    required this.nightwearProducts,
    required this.pantyProducts,
    required this.shapewearProducts,
    required this.sockProducts,
    required this.tightsProducts,
    required this.braProducts,
    required this.bridalLingerieProducts,
  });

  @override
  State<LingerieScreen> createState() => _LingerieScreenState();
}

class _LingerieScreenState extends State<LingerieScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;
  late TextEditingController _searchController;
  String _searchQuery = "";

  static const int _tabCount = 9;

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
      widget.lingerie,
      widget.bodysuitProduct,
      widget.nightwearProducts,
      widget.pantyProducts,
      widget.shapewearProducts,
      widget.sockProducts,
      widget.tightsProducts,
      widget.braProducts,
      widget.bridalLingerieProducts,
    ];

    if (_searchQuery.isEmpty) {
      return allTabs;
    }

    return allTabs.map((list) {
      return list.where((item) {
        final title = (item['title'] ?? '').toString().toLowerCase();
        return title.contains(_searchQuery.toLowerCase());
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
          widget.categoryName.tr.toUpperCase(),
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
                tabs: [
                  Tab(text: "All".tr),
                  Tab(text: "Bodysuit".tr),
                  Tab(text: "Nightwear".tr),
                  Tab(text: "Panty".tr),
                  Tab(text: "Shapewear".tr),
                  Tab(text: "Socks".tr),
                  Tab(text: "Tights".tr),
                  Tab(text: "Bra".tr),
                  Tab(text: "Bridal".tr),
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
                  .map((items) => _buildLingerieGrid(items, isDark))
                  .toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar(BuildContext context, bool isDark) {
    final textColor = isDark ? Colors.white : Colors.black;
    final searchBg = isDark
        ? Colors.white.withValues(alpha: 0.1)
        : AppColor.grey100;
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
                  hintText: "Search in ${widget.categoryName.tr}...".tr,
                  hintStyle: TextStyle(color: hintColor, fontSize: 14),
                  prefixIcon: Icon(
                    Icons.search_rounded,
                    size: 22,
                    color: hintColor,
                  ),
                  suffixIcon: _searchQuery.isNotEmpty
                      ? IconButton(
                          icon: Icon(
                            Icons.cancel_rounded,
                            size: 20,
                            color: hintColor,
                          ),
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
                    "filter".tr,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white : Colors.black,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLingerieGrid(List<Map<String, dynamic>> items, bool isDark) {
    if (items.isEmpty) {
      return _buildEmptyState(isDark);
    }

    return GridView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      physics: const BouncingScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.60,
        crossAxisSpacing: 16,
        mainAxisSpacing: 20,
      ),
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];
        return _buildLingerieCard(context, item, isDark, index);
      },
    );
  }

  Widget _buildLingerieCard(
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

    final String title = (item['title'] ?? 'Lingerie Piece').toString();
    final String price = (item['price'] ?? '\$0.00').toString();
    final String rating = (item['rating'] ?? '4.8').toString();
    final String sold = (item['sold'] ?? '0').toString();
    final bool isFavorite = item['is_favorite'] ?? false;

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProductLingerieScreen(product: item),
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
                              tag: 'lingerie_${item['id'] ?? index}',
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
                  title.tr,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: isDark ? Colors.white : AppColor.black,
                ),
                const SizedBox(height: 4),
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
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 6),
                      child: TextWidget(
                        "|",
                        color: subTextColor.withValues(alpha: 0.3),
                      ),
                    ),
                    Expanded(
                      child: TextWidget(
                        "$sold ${"sold".tr}",
                        color: subTextColor,
                        fontSize: 11,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
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
                ? "No collection available".tr
                : "${"No items found for".tr} '$_searchQuery'",
            color: isDark ? Colors.white38 : Colors.grey,
            fontSize: 16,
          ),
        ],
      ),
    );
  }
}

