import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:shopping_app/constants/string_extension.dart';

import '../../../../constants/app_color.dart';
import '../../../constants/color.dart';
import 'package:shopping_app/src/widget/cart_badge.dart';
import '../../widget/text_widget.dart';
import 'card_detail/product_clothes_screen.dart';
import 'filter/filter_screen.dart';

class AllNewItemScreen extends StatelessWidget {
  final String categoryName;
  final List<Map<String, dynamic>> newItems;

  const AllNewItemScreen({
    super.key,
    required this.categoryName,
    required this.newItems,
  });

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
          categoryName.toUpperCase().tr,
          fontSize: 18,
          fontWeight: FontWeight.w900,
          color: textColor,
          letterSpacing: 1.2,
        ),
        actions: const [
          CartBadge(),
          SizedBox(width: 8),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(64),
          child: _buildSearchBar(context, isDark),
        ),
      ),
      body: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
            color: isDark
                ? Colors.white.withValues(alpha: 0.02)
                : Colors.grey[50],
            child: Row(
              children: [
                Icon(
                  Icons.format_list_bulleted_rounded,
                  size: 16,
                  color: textColor.withValues(alpha: 0.6),
                ),
                const SizedBox(width: 8),
                TextWidget(
                  "${newItems.length} ${'items found'.tr}",
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: textColor.withValues(alpha: 0.7),
                ),
              ],
            ),
          ),
          Expanded(
            child: newItems.isEmpty
                ? _buildEmptyState(isDark)
                : GridView.builder(
                    padding: const EdgeInsets.fromLTRB(16, 10, 16, 20),
                    physics: const BouncingScrollPhysics(),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 0.58,
                          crossAxisSpacing: 16,
                          mainAxisSpacing: 20,
                        ),
                    itemCount: newItems.length,
                    itemBuilder: (context, index) {
                      final item = newItems[index];
                      return _buildAllItemCard(context, item, isDark, index);
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar(BuildContext context, bool isDark) {
    final textColor = isDark ? Colors.white : Colors.black;
    final searchBg = isDark ? Colors.grey[850] : Colors.grey[100];
    final hintColor = isDark ? Colors.white70 : Colors.black54;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: BoxDecoration(
                color: searchBg,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Icon(Icons.search_rounded, size: 20, color: hintColor),
                  const SizedBox(width: 10),
                  Expanded(
                    child: TextWidget(
                      "Search in $categoryName...",
                      color: hintColor,
                      fontSize: 13,
                      fontWeight: FontWeight.w400,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
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
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              decoration: BoxDecoration(
                border: Border.all(
                  color: isDark ? Colors.white10 : Colors.grey[300]!,
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.tune_rounded, size: 18, color: textColor),
                  const SizedBox(width: 6),
                  TextWidget(
                    "Filter",
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: textColor,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAllItemCard(
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

    final String title = (item['title'] ?? 'All New Product').toString();
    final String price = (item['price'] ?? '\$0.00').toString();
    final String rating = (item['rating'] ?? '4.7').toString();
    final String sold = (item['sold'] ?? '0').toString();

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
                      color: Colors.black.withValues(alpha: 0.03),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
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
                              tag: 'new_item_all_$index',
                              child: CachedNetworkImage(
                                imageUrl: imageUrl,
                                fit: BoxFit.cover,
                                placeholder: (context, url) => Container(
                                  color: isDark
                                      ? Colors.white10
                                      : Colors.grey[200],
                                  child: Center(
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      color: isDark
                                          ? Colors.white24
                                          : Colors.grey[400],
                                    ),
                                  ),
                                ),
                                errorWidget: (context, url, error) =>
                                    const Center(
                                      child: Icon(
                                        Icons.broken_image_outlined,
                                        color: Colors.grey,
                                      ),
                                    ),
                              ),
                            )
                          : Container(
                              color: isDark
                                  ? Colors.white.withValues(alpha: 0.05)
                                  : AppColor.grey100,
                              child: const Center(
                                child: Icon(
                                  Icons.image_not_supported_outlined,
                                  color: Colors.grey,
                                ),
                              ),
                            ),
                    ),
                    Positioned(
                      top: 10,
                      left: 10,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: AppColor.primaryColor,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child:  TextWidget(
                          "NEW",
                          color: Colors.white,
                          fontSize: 9,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                    Positioned(
                      top: 8,
                      right: 8,
                      child: Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.9),
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.1),
                              blurRadius: 4,
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.favorite_border_rounded,
                          size: 18,
                          color: Colors.black87,
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
            padding: const EdgeInsets.symmetric(horizontal: 2),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextWidget(
                  "LOOMA",
                  fontSize: 11,
                  letterSpacing: 1.0,
                  fontWeight: FontWeight.w800,
                  color: AppColor.primaryColor.withValues(alpha: 0.8),
                ),
                const SizedBox(height: 2),
                TextWidget(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: isDark ? Colors.white : Colors.black87,
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(
                      Icons.star_rounded,
                      color: Colors.orange,
                      size: 14,
                    ),
                    const SizedBox(width: 2),
                    TextWidget(
                      rating,
                      color: textColor.withValues(alpha: 0.8),
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                    ),
                    const SizedBox(width: 6),
                    Container(
                      width: 1,
                      height: 10,
                      color: subTextColor.withValues(alpha: 0.2),
                    ),
                    const SizedBox(width: 6),
                    TextWidget("$sold sold", color: subTextColor, fontSize: 11),
                  ],
                ),
                const SizedBox(height: 4),
                TextWidget(
                  price,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white : AppColor.black,
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
            Icons.inventory_2_outlined,
            size: 64,
            color: isDark ? Colors.white10 : Colors.grey[300],
          ),
          const SizedBox(height: 16),
          TextWidget(
            "No new items found",
            color: isDark ? Colors.white38 : Colors.grey,
            fontSize: 16,
          ),
        ],
      ),
    );
  }
}

