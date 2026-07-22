import 'package:cached_network_image/cached_network_image.dart';
import 'package:shopping_app/src/screen/login_screen/login_screen.dart';
import 'package:shopping_app/src/network/datastor/auth_service.dart';
import 'package:shopping_app/src/widget/cart_badge.dart';
import 'package:flutter/material.dart';
import 'package:shopping_app/constants/string_extension.dart';
import '../../../../../constants/app_color.dart';
import '../../../../model/product_model.dart';
import '../../../../network/repository/product_repository.dart';
import '../../../../widget/text_widget.dart';
import '../../filter/filter_screen.dart';
import '../../product_detail/product_bag_screen.dart';
import '../../shopping_bag/shopping_bag_screen.dart';


class BeltsScreen extends StatefulWidget {
  final String categoryName;

  const BeltsScreen({
    super.key,
    required this.categoryName,
  });

  @override
  State<BeltsScreen> createState() => _BeltsScreenState();
}

class _BeltsScreenState extends State<BeltsScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = "";
  final ProductRepository _productRepository = ProductRepository();

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
        leading: BackButton(color: isDark ? Colors.white : Colors.black),
        toolbarHeight: 90,
        backgroundColor: isDark
            ? const Color(0xFF121212)
            : const Color(0xFFF9F9F9),
        elevation: 0,
        centerTitle: true,
        leadingWidth: 70,
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
        bottom: _buildPromoBar(isDark),
      ),
      body: Column(
        children: [
          _buildSearchBar(context, isDark),
          Expanded(
            child: StreamBuilder<List<ProductModel>>(
              stream: _productRepository.getProductsStream('belts'),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return Center(child: TextWidget("Error loading products".tr));
                }

                final products = snapshot.data ?? [];
                final filteredBelts = _searchQuery.isEmpty
                    ? products
                    : products.where((p) => p.title.toLowerCase().contains(_searchQuery.toLowerCase())).toList();

                if (filteredBelts.isEmpty) {
                  return _buildEmptyState(isDark);
                }

                return GridView.builder(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 10,
                  ),
                  physics: const BouncingScrollPhysics(),
                  gridDelegate:
                      const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 0.60,
                        crossAxisSpacing: 16,
                        mainAxisSpacing: 20,
                      ),
                  itemCount: filteredBelts.length,
                  itemBuilder: (context, index) {
                    final item = filteredBelts[index];
                    return _buildBeltCard(context, item, isDark, index);
                  },
                );
              },
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
    );
  }

  Widget _buildSearchBar(BuildContext context, bool isDark) {
    final textColor = isDark ? Colors.white : Colors.black;
    final searchBg = isDark ? Colors.white.withAlpha(25) : AppColor.grey100;
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
                  hintText: "Search in {0}...".trArgs([widget.categoryName]),
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

  Widget _buildBeltCard(
    BuildContext context,
    ProductModel item,
    bool isDark,
    int index,
  ) {
    final subTextColor = isDark ? Colors.white70 : Colors.black54;
    final String imageUrl = item.images.isNotEmpty ? item.images.first : '';
    final String title = item.title;
    final String price = '\$${item.price.toStringAsFixed(2)}';
    final String rating = item.rating.toString();
    final String sold = item.sold ?? '0';
    final bool isFavorite = item.isFavorite;

    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ProductBagScreen(product: item.toMap()),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: isDark ? Colors.white.withAlpha(13) : AppColor.grey100,
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Stack(
                  children: [
                    Positioned.fill(
                      child: Hero(
                        tag: 'belt_${item.id ?? index}',
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
                    Positioned(
                      top: 10,
                      right: 10,
                      child: GestureDetector(
                      onTap: () async {
                        if (await AuthService.isLoggedIn()) {
                          // Wishlist toggle
                        } else {
                          if (context.mounted) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => LoginScreen()),
                            );
                          }
                        }
                      },
                      child: Icon(
                        isFavorite ? Icons.favorite : Icons.favorite_border,
                        size: 20,
                        color: isFavorite ? Colors.redAccent : (isDark ? Colors.white60 : Colors.black26),
                      )
                    ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),
          TextWidget(
            "LOOMA".tr.toUpperCase(),
            fontSize: 14,
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
              const Icon(Icons.star_rounded, color: Colors.orange, size: 16),
              const SizedBox(width: 4),
              TextWidget(
                rating,
                color: subTextColor,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
              Text(
                ' | {0} sold'.trArgs([sold]),
                style: TextStyle(color: subTextColor, fontSize: 11),
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
    );
  }

  Widget _buildEmptyState(bool isDark) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.search_off_rounded,
            size: 70,
            color: isDark ? Colors.white10 : Colors.grey[300],
          ),
          const SizedBox(height: 16),
          TextWidget(
            "No results found for '{0}'".trArgs([_searchQuery]),
            color: isDark ? Colors.white38 : Colors.grey,
            fontSize: 16,
          ),
        ],
      ),
    );
  }
}
