import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:shopping_app/constants/string_extension.dart';

import '../../../../../constants/app_color.dart';
import '../../../../widget/text_widget.dart';
import '../../card_detail/product_shoes_screen.dart';
import '../../filter/filter_screen.dart';
import '../../shopping_bag/shopping_bag_screen.dart';

class FlatsScreen extends StatefulWidget {
  final String categoryName;
  final List<Map<String, dynamic>> flats;

  const FlatsScreen({
    super.key,
    required this.categoryName,
    required this.flats,
  });

  @override
  State<FlatsScreen> createState() => _FlatsScreenState();
}

class _FlatsScreenState extends State<FlatsScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = "";
  late List<Map<String, dynamic>> _filteredFlats;

  @override
  void initState() {
    super.initState();
    _filteredFlats = widget.flats;
  }

  void _onSearchChanged(String query) {
    setState(() {
      _searchQuery = query;
      _filteredFlats = widget.flats
          .where(
            (item) => (item['title'] ?? '').toLowerCase().contains(
                  query.toLowerCase(),
                ),
          )
          .toList();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = isDark ? const Color(0xFF121212) : AppColor.white;

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        leading: BackButton(
          color: isDark ? Colors.white : Colors.black,
        ),
        toolbarHeight: 90,
        backgroundColor: isDark ? const Color(0xFF121212) : const Color(0xFFF9F9F9),
        elevation: 0,
        centerTitle: true,
        leadingWidth: 70,
        title: ShaderMask(
          shaderCallback: (bounds) => LinearGradient(
            colors: isDark
                ? const [
                    Colors.white,
                    Colors.white70,
                  ]
                : const [
                    Colors.black,
                    Colors.black54,
                  ],
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
        actions: [_buildCartIcon(isDark)],
        bottom: _buildPromoBar(isDark),
      ),
      body: Column(
        children: [
          _buildSearchBar(context, isDark),
          Expanded(
            child: _filteredFlats.isEmpty
                ? _buildEmptyState(isDark)
                : GridView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    physics: const BouncingScrollPhysics(),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 0.65,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 20,
                    ),
                    itemCount: _filteredFlats.length,
                    itemBuilder: (context, index) {
                      final item = _filteredFlats[index];
                      return _buildFlatsCard(context, item, isDark, index);
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildCartIcon(bool isDark) {
    return Padding(
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
                  builder: (context) => const ShoppingBagScreen(),
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
    );
  }

  PreferredSizeWidget _buildPromoBar(bool isDark) {
    return PreferredSize(
      preferredSize: const Size.fromHeight(8),
      child: Container(
        width: double.infinity,
        alignment: Alignment.center,
        padding: const EdgeInsets.symmetric(
          vertical: 4,
        ),
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
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: isDark ? Colors.white10 : Colors.transparent,
                ),
              ),
              child: TextField(
                controller: _searchController,
                onChanged: _onSearchChanged,
                style: TextStyle(
                  color: textColor,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
                textAlignVertical: TextAlignVertical.center,
                decoration: InputDecoration(
                  hintText: "Search in ${widget.categoryName}...".tr,
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
                            _searchController.clear();
                            _onSearchChanged("");
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
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const FilterScreen()),
            ),
            borderRadius: BorderRadius.circular(12),
            child: Container(
              height: 48,
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Row(
                children: [
                  Icon(
                    Icons.tune_rounded,
                    size: 20,
                    color: isDark ? Colors.white : Colors.black,
                  ),
                  const SizedBox(width: 4),
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

  Widget _buildFlatsCard(
    BuildContext context,
    Map<String, dynamic> item,
    bool isDark,
    int index,
  ) {
    final subTextColor = isDark ? Colors.white70 : Colors.black54;
    final String imageUrl = (item['images'] != null && (item['images'] as List).isNotEmpty)
        ? item['images'][0]
        : (item['image'] ?? '');

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
                borderRadius: BorderRadius.circular(18),
                color: isDark ? Colors.white.withValues(alpha: 0.05) : AppColor.grey100,
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(18),
                child: Stack(
                  children: [
                    Positioned.fill(
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Hero(
                          tag: imageUrl + index.toString(),
                          child: CachedNetworkImage(
                            imageUrl: imageUrl,
                            fit: BoxFit.contain,
                            placeholder: (context, url) => Center(
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: isDark ? Colors.white24 : Colors.grey[300],
                              ),
                            ),
                            errorWidget: (context, url, error) =>
                                const Icon(Icons.broken_image_outlined),
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      top: 10,
                      right: 10,
                      child: Icon(
                        Icons.favorite_border,
                        size: 20,
                        color: isDark ? Colors.white38 : Colors.black26,
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
                  "LOOMA".tr.toUpperCase(),
                  fontSize: 16,
                  letterSpacing: 1.2,
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white54 : Colors.black45,
                ),
                const SizedBox(height: 4),
                Text(
                  (item['title'] ?? 'Product').toString().tr,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: isDark ? Colors.white : AppColor.black,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(Icons.star_rounded, color: Colors.orange, size: 16),
                    const SizedBox(width: 4),
                    Text(
                      item['rating'] ?? '4.5',
                      style: TextStyle(color: subTextColor, fontSize: 12),
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 6),
                      child: Text(
                        "|",
                        style: TextStyle(color: Colors.grey, fontSize: 12),
                      ),
                    ),
                    Expanded(
                      child: Text(
                        "${item['sold'] ?? '0'} ${'sold'.tr}",
                        style: TextStyle(color: subTextColor, fontSize: 11),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  item['price'] ?? '\$0.00',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppColor.primaryColor,
                  ),
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
          Icon(
            _searchQuery.isEmpty ? Icons.shopping_bag_outlined : Icons.search_off_rounded,
            size: 70,
            color: isDark ? Colors.white10 : Colors.grey[300],
          ),
          const SizedBox(height: 16),
          TextWidget(
            _searchQuery.isEmpty ? "No flats available".tr : "${'No results for'.tr} '$_searchQuery'",
            color: isDark ? Colors.white38 : Colors.grey,
            fontSize: 16,
          ),
        ],
      ),
    );
  }
}

