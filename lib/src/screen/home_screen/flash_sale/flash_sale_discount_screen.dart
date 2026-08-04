import 'package:cached_network_image/cached_network_image.dart';
import 'package:shopping_app/src/model/product_model.dart';
import 'package:shopping_app/src/network/crud_firebase/firestore_service.dart';
import 'package:shopping_app/src/screen/login_screen/login_screen.dart';
import 'package:shopping_app/src/network/datastor/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:shopping_app/constants/string_extension.dart';
import 'package:shopping_app/src/widget/cart_badge.dart';
import 'package:shopping_app/src/widget/text_widget.dart';
import '../../../../constants/app_color.dart';
import '../filter/filter_screen.dart';
import '../product_detail/product_detail_screen.dart';

class FlashSaleDiscountScreen extends StatefulWidget {
  final String imageUrl;

  const FlashSaleDiscountScreen({super.key, required this.imageUrl});

  @override
  State<FlashSaleDiscountScreen> createState() =>
      _FlashSaleDiscountScreenState();
}

class _FlashSaleDiscountScreenState extends State<FlashSaleDiscountScreen> {
  String selectedDiscount = "All";
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  final FirestoreService _firestoreService = FirestoreService();

  late final List<String> filters;

  @override
  void initState() {
    super.initState();
    filters = [
      "All",
      "10%",
      "20%",
      "30%",
      "40%",
      "50%",
    ].map((e) => e.tr).toList();
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
    final textColor = isDark ? Colors.white : AppColor.black;

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: bgColor,
        elevation: 0,
        centerTitle: true,
        iconTheme: IconThemeData(color: textColor),
        title: TextWidget(
          "Flash Sale".tr,
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: textColor,
        ),
        actions: const [CartBadge(), SizedBox(width: 8)],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(125),
          child: Column(
            children: [
              _buildSearchBar(isDark),
              _buildDiscountFilters(isDark),
              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
      body: StreamBuilder<List<ProductModel>>(
        stream: _firestoreService.getProducts(category: 'FLASH_SALE'),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          var products = snapshot.data ?? [];
          
          if (selectedDiscount != "All") {
            products = products.where((p) => (p.stockStatus ?? '').contains(selectedDiscount)).toList();
          }

          if (_searchQuery.isNotEmpty) {
            products = products.where((p) => p.title.toLowerCase().contains(_searchQuery.toLowerCase())).toList();
          }

          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(18, 14, 18, 8),
                child: Row(
                  children: [
                    TextWidget(
                      selectedDiscount == "All"
                          ? "All Discounts".tr
                          : "$selectedDiscount ${'Discount'.tr}",
                      fontSize: 22,
                      fontWeight: FontWeight.w900,
                      color: textColor,
                    ),
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: isDark ? Colors.white10 : AppColor.grey100,
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: TextWidget(
                        "${products.length} ${'items'.tr}",
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: textColor,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(child: _buildProductGrid(isDark, products)),
            ],
          );
        },
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
                  hintText: "Search products...".tr,
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
                  "Filter".tr,
                  fontWeight: FontWeight.bold,
                  color: textColor,
                  fontSize: 14,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDiscountFilters(bool isDark) {
    return SizedBox(
      height: 58,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 14),
        itemCount: filters.length,
        itemBuilder: (context, index) {
          final filter = filters[index];
          final selected = filter == selectedDiscount;

          return GestureDetector(
            onTap: () {
              setState(() {
                selectedDiscount = filter;
              });
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 220),
              margin: const EdgeInsets.symmetric(horizontal: 6, vertical: 8),
              padding: const EdgeInsets.symmetric(horizontal: 20),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                gradient: selected
                    ? const LinearGradient(
                        colors: [Color(0xFFFF3D5A), Color(0xFFFF8A00)],
                      )
                    : null,
                color: selected
                    ? null
                    : (isDark ? Colors.white10 : AppColor.grey100),
                borderRadius: BorderRadius.circular(30),
              ),
              child: Row(
                children: [
                  if (filter.contains("%")) ...[
                    Icon(
                      Icons.local_offer_rounded,
                      size: 15,
                      color: selected
                          ? Colors.white
                          : (isDark ? Colors.white60 : Colors.black45),
                    ),
                    const SizedBox(width: 6),
                  ],
                  TextWidget(
                    filter,
                    fontWeight: FontWeight.bold,
                    color: selected
                        ? Colors.white
                        : (isDark ? Colors.white70 : AppColor.black),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildProductGrid(bool isDark, List<ProductModel> products) {
    if (products.isEmpty) {
      return Center(
        child: TextWidget(
          "No products available.".tr,
          color: isDark ? Colors.white38 : AppColor.grey,
          fontSize: 16,
        ),
      );
    }

    return GridView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      physics: const BouncingScrollPhysics(),
      itemCount: products.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 20,
        crossAxisSpacing: 16,
        childAspectRatio: 0.60,
      ),
      itemBuilder: (context, index) {
        final item = products[index];

        return DiscountProductCard(
          product: item.toMap(),
          imageUrl: item.images.isNotEmpty ? item.images[0] : '',
          title: item.title,
          price: "\$${item.price.toStringAsFixed(2)}",
          oldPrice: "\$${(item.price * 1.5).toStringAsFixed(2)}",
          discountLabel: "-50%",
          isDark: isDark,
        );
      },
    );
  }
}

class DiscountProductCard extends StatelessWidget {
  final Map<String, dynamic> product;
  final String imageUrl;
  final String title;
  final String price;
  final String oldPrice;
  final String discountLabel;
  final bool isDark;

  const DiscountProductCard({
    super.key,
    required this.product,
    required this.imageUrl,
    required this.title,
    required this.price,
    required this.oldPrice,
    required this.discountLabel,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => ProductClothesScreen(product: product),
          ),
        );
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(22),
                color: isDark
                    ? Colors.white.withValues(alpha: 0.05)
                    : AppColor.grey100,
                boxShadow: [
                  if (!isDark)
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.04),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(22),
                child: Stack(
                  children: [
                    Positioned.fill(
                      child: CachedNetworkImage(
                        imageUrl: imageUrl,
                        fit: BoxFit.cover,
                        placeholder: (_, _) => Container(
                          color: isDark ? Colors.white10 : AppColor.grey100,
                          child: const Center(
                            child: CircularProgressIndicator(strokeWidth: 2),
                          ),
                        ),
                        errorWidget: (_, _, _) => Container(
                          color: isDark ? Colors.white10 : AppColor.grey100,
                          child: const Icon(Icons.broken_image_outlined),
                        ),
                      ),
                    ),
                    Positioned(
                      top: 10,
                      left: 10,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 9,
                          vertical: 5,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFF3D5A),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: TextWidget(
                          discountLabel,
                          color: AppColor.white,
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Positioned(
                      top: 10,
                      right: 10,
                      child: GestureDetector(
                        onTap: () async {
                          if (await AuthService.isLoggedIn()) {
                            // Toggle wishlist logic here
                          } else {
                            if (context.mounted) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => LoginScreen(),
                                ),
                              );
                            }
                          }
                        },
                        child: CircleAvatar(
                          radius: 17,
                          backgroundColor: Colors.white.withValues(alpha: 0.9),
                          child: const Icon(
                            Icons.favorite_border,
                            size: 19,
                            color: Colors.black45,
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
                  fontSize: 13,
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
                const SizedBox(height: 6),
                Row(
                  children: [
                    TextWidget(
                      price,
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                      color: AppColor.primaryColor,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        oldPrice,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: Colors.grey,
                          decoration: TextDecoration.lineThrough,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    const Icon(
                      Icons.star_rounded,
                      color: Colors.orange,
                      size: 16,
                    ),
                    const SizedBox(width: 4),
                    TextWidget(
                      product['rating']?.toString() ?? '4.8',
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: isDark ? Colors.white70 : Colors.black54,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: TextWidget(
                        "${product['sold'] ?? '0'} ${'sold'.tr}",
                        fontSize: 11,
                        color: isDark ? Colors.white54 : Colors.black45,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
