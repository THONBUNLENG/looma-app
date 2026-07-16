import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:shopping_app/constants/string_extension.dart';
import 'package:shopping_app/src/widget/cart_badge.dart';
import 'package:shopping_app/src/widget/text_widget.dart';

import '../../../../constants/app_color.dart';
import '../card_detail/product_clothes_screen.dart';
import '../filter/filter_screen.dart';


class FlashSaleDiscountScreen extends StatefulWidget {
  final String imageUrl;

  const FlashSaleDiscountScreen({
    super.key,
    required this.imageUrl,
  });

  @override
  State<FlashSaleDiscountScreen> createState() =>
      _FlashSaleDiscountScreenState();
}

class _FlashSaleDiscountScreenState extends State<FlashSaleDiscountScreen> {
  String selectedDiscount = "50%";
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

    final List<String> filters = [
    "All",
    "10%",
    "20%",
    "30%",
    "40%",
    "50%",
  ].map((e) => e.tr).toList();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<Map<String, String>> get currentProducts {
    List<Map<String, String>> products;
    if (selectedDiscount == "All") {
      products = allProducts;
    } else {
      products = discountProducts[selectedDiscount] ?? [];
    }

    if (_searchQuery.isEmpty) {
      return products;
    }

    final query = _searchQuery.toLowerCase();
    return products.where((product) {
      final title = (product['title'] ?? '').toLowerCase();
      return title.contains(query);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = isDark ? const Color(0xFF121212) : AppColor.white;
    final textColor = isDark ? Colors.white : AppColor.black;
    final products = currentProducts;

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
        actions: const [
          CartBadge(),
          SizedBox(width: 8),
        ],
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
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(18, 14, 18, 8),  
            child: Row(
              children: [
                TextWidget(
                  selectedDiscount == "All"
                      ? "All Discounts"
                      : "$selectedDiscount Discount",
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
                    "${products.length} items",
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: textColor,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: _buildProductGrid(isDark, products),
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
                  hintText: "Search products...",
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
                  "Filter",
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
                        colors: [
                          Color(0xFFFF3D5A),
                          Color(0xFFFF8A00),
                        ],
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

  Widget _buildProductGrid(bool isDark, List<Map<String, String>> products) {
    if (products.isEmpty) {
      return Center(
        child: TextWidget(
          "No products available.",
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
          product: item,
          imageUrl: item['image'] ?? '',
          title: item['title'] ?? '',
          price: item['price'] ?? '',
          oldPrice: item['oldPrice'] ?? '',
          discountLabel: selectedDiscount == "All"
              ? "-${item['discount'] ?? ''}"
              : "-$selectedDiscount",
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
            builder: (_) => ProductClothesScreen(
              product: product,
            ),
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
                          child: CachedNetworkImage(
                            imageUrl:
                                'https://www.pngitem.com/pimgs/m/255-2550411_no-image-available-png-transparent-no-image-available.png',
                            fit: BoxFit.contain,
                          ),
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
                  title,
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
                        "${product['sold'] ?? '0'} sold",
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

List<Map<String, String>> get allProducts =>
    discountProducts.values.expand((list) => list).toList();
final Map<String, List<Map<String, String>>> discountProducts = {
  "10%": [
    {
      'image':
          "https://eu.louisvuitton.com/images/is/image/lv/1/PP_VP_L/louis-vuitton-lv-padlock-bracelet--M8275E_PM2_Front%20view.png?wid=490&hei=490",
      'title': "Wireless Mouse Basic",
      'price': "\$18.00",
      'oldPrice': "\$20.00",
      'discount': "10%",
      'rating': "4.2",
      'sold': "210",
      'reviews': "160",
    },
    {
      'image':
          "https://eu.louisvuitton.com/images/is/image/lv/1/PP_VP_L/louis-vuitton-capucines-xs-wallet--M26705_PM2_Front%20view.png?wid=490&hei=490",
      'title': "Bluetooth Speaker Pocket",
      'price': "\$27.00",
      'oldPrice': "\$30.00",
      'discount': "10%",
      'rating': "4.4",
      'sold': "144",
      'reviews': "108",
    },
    {
      'image':
          "https://eu.louisvuitton.com/images/is/image/lv/1/PP_VP_L/louis-vuitton-duo-slingbag--M24467_PM2_Front%20view.png?wid=490&hei=490",
      'title': "Gaming Keyboard Compact",
      'price': "\$45.00",
      'oldPrice': "\$50.00",
      'discount': "10%",
      'rating': "4.5",
      'sold': "98",
      'reviews': "71",
    },
    {
      'image':
          "https://eu.louisvuitton.com/images/is/image/lv/1/PP_VP_L/louis-vuitton-keepall-bandouliere-50--M14840_PM2_Front%20view.png?wid=490&hei=490",
      'title': "USB-C Charging Cable",
      'price': "\$9.00",
      'oldPrice': "\$10.00",
      'discount': "10%",
      'rating': "4.1",
      'sold': "320",
      'reviews': "240",
    },
    {
      'image':
          "https://eu.louisvuitton.com/images/is/image/lv/1/PP_VP_L/louis-vuitton-noe-trunk-pm--M13484_PM2_Front%20view.png?wid=490&hei=490",
      'title': "Laptop Sleeve Case",
      'price': "\$22.50",
      'oldPrice': "\$25.00",
      'discount': "10%",
      'rating': "4.3",
      'sold': "132",
      'reviews': "99",
    },
    {
      'image':
          "https://eu.louisvuitton.com/images/is/image/lv/1/PP_VP_L/louis-vuitton-pocket-organizer--M14786_PM2_Front%20view.png?wid=490&hei=490",
      'title': "Fitness Tracker Mini",
      'price': "\$36.00",
      'oldPrice': "\$40.00",
      'discount': "10%",
      'rating': "4.4",
      'sold': "121",
      'reviews': "88",
    },
    {
      'image':
          "https://eu.louisvuitton.com/images/is/image/lv/1/PP_VP_L/louis-vuitton-aspen-platform-clog--ASTF1ASC31_PM2_Front%20view.png?wid=490&hei=490",
      'title': "Tablet Holder Stand",
      'price': "\$13.50",
      'oldPrice': "\$15.00",
      'discount': "10%",
      'rating': "4.0",
      'sold': "176",
      'reviews': "130",
    },
    {
      'image':
          "https://eu.louisvuitton.com/images/is/image/lv/1/PP_VP_L/louis-vuitton-dauphine-chain-wallet--M82997_PM2_Front%20view.png?wid=490&hei=490",
      'title': "LED Desk Light",
      'price': "\$31.50",
      'oldPrice': "\$35.00",
      'discount': "10%",
      'rating': "4.5",
      'sold': "87",
      'reviews': "64",
    },
    {
      'image':
          "https://eu.louisvuitton.com/images/is/image/lv/1/PP_VP_L/louis-vuitton-lv-stadium-sneaker--ARBU2ADJAK_PM2_Front%20view.png?wid=490&hei=490",
      'title': "Wireless Earbuds Basic",
      'price': "\$54.00",
      'oldPrice': "\$60.00",
      'discount': "10%",
      'rating': "4.6",
      'sold': "110",
      'reviews': "82",
    },
    {
      'image':
          "https://eu.louisvuitton.com/images/is/image/lv/1/PP_VP_L/louis-vuitton-discovery-backpack--M31033_PM2_Front%20view.png?wid=490&hei=490",
      'title': "Portable SSD 256GB",
      'price': "\$63.00",
      'oldPrice': "\$70.00",
      'discount': "10%",
      'rating': "4.7",
      'sold': "72",
      'reviews': "53",
    },
    {
      'image':
          "https://eu.louisvuitton.com/images/is/image/lv/1/PP_VP_L/louis-vuitton-long-sleeved-fitted-shirt--FHBL14AQV000_PM2_Front%20view.png?wid=490&hei=490",
      'title': "Gaming Headset Lite",
      'price': "\$40.50",
      'oldPrice': "\$45.00",
      'discount': "10%",
      'rating': "4.5",
      'sold': "94",
      'reviews': "68",
    },
    {
      'image':
          "https://eu.louisvuitton.com/images/is/image/lv/1/PP_VP_L/louis-vuitton-lv-signature-round-sunglasses---size-m--Z2434U_PM2_Front%20view.png?wid=490&hei=490",
      'title': "Smartphone Car Mount",
      'price': "\$11.70",
      'oldPrice': "\$13.00",
      'discount': "10%",
      'rating': "4.2",
      'sold': "205",
      'reviews': "154",
    },
    {
      'image':
          "https://eu.louisvuitton.com/images/is/image/lv/1/PP_VP_L/louis-vuitton-monogram-french-terry-zip-through-hoodie--HPY41WY44900_PM2_Front%20view.png?wid=490&hei=490",
      'title': "Portable Mini Speaker",
      'price': "\$24.30",
      'oldPrice': "\$27.00",
      'discount': "10%",
      'rating': "4.3",
      'sold': "141",
      'reviews': "104",
    },
    {
      'image':
          "https://eu.louisvuitton.com/images/is/image/lv/1/PP_VP_L/louis-vuitton-coussin-pm--M24336_PM2_Front%20view.png?wid=490&hei=490",
      'title': "Smart LED Strip",
      'price': "\$18.00",
      'oldPrice': "\$20.00",
      'discount': "10%",
      'rating': "4.4",
      'sold': "190",
      'reviews': "148",
    },
    {
      'image':
          "https://eu.louisvuitton.com/images/is/image/lv/1/PP_VP_L/louis-vuitton-met-pump--ASAE1FSS02_PM2_Front%20view.png?wid=490&hei=490",
      'title': "Wireless Charger Mini",
      'price': "\$22.50",
      'oldPrice': "\$25.00",
      'discount': "10%",
      'rating': "4.3",
      'sold': "118",
      'reviews': "87",
    },
    {
      'image':
          "https://eu.louisvuitton.com/images/is/image/lv/1/PP_VP_L/louis-vuitton-lv-mare-mule--ASGH1DLK02_PM2_Front%20view.png?wid=490&hei=490",
      'title': "Mechanical Keyboard Lite",
      'price': "\$72.00",
      'oldPrice': "\$80.00",
      'discount': "10%",
      'rating': "4.6",
      'sold': "65",
      'reviews': "47",
    },
    {
      'image':
          "https://eu.louisvuitton.com/images/is/image/lv/1/PP_VP_L/louis-vuitton-lv-mare-open-back-loafer--ASGL2AGC02_PM2_Front%20view.png?wid=490&hei=490",
      'title': "Noise Reduction Headphones",
      'price': "\$81.00",
      'oldPrice': "\$90.00",
      'discount': "10%",
      'rating': "4.8",
      'sold': "74",
      'reviews': "56",
    },
    {
      'image':
          "https://eu.louisvuitton.com/images/is/image/lv/1/PP_VP_L/louis-vuitton-lv-mare-flat-loafer--ARGL1PGC02_PM2_Front%20view.png?wid=490&hei=490",
      'title': "Mini Portable Projector",
      'price': "\$117.00",
      'oldPrice': "\$130.00",
      'discount': "10%",
      'rating': "4.5",
      'sold': "34",
      'reviews': "25",
    },
    {
      'image':
          "https://eu.louisvuitton.com/images/is/image/lv/1/PP_VP_L/louis-vuitton-camera-box-monogram-beige--M10329_PM2_Front%20view.png?wid=490&hei=490",
      'title': "Action Camera Basic",
      'price': "\$72.00",
      'oldPrice': "\$80.00",
      'discount': "10%",
      'rating': "4.4",
      'sold': "48",
      'reviews': "35",
    },
    {
      'image':
          "https://eu.louisvuitton.com/images/is/image/lv/1/PP_VP_L/louis-vuitton-monogram-denim-overalls--FVPT07EFY610_PM2_Front%20view.png?wid=490&hei=490",
      'title': "Multiport Adapter",
      'price': "\$27.00",
      'oldPrice': "\$30.00",
      'discount': "10%",
      'rating': "4.3",
      'sold': "126",
      'reviews': "92",
    }
  ],
  "20%": [
    {
      'image':
          "https://eu.louisvuitton.com/images/is/image/lv/1/PP_VP_L/louis-vuitton-escale--M28503_PM2_Front%20view.png?wid=490&hei=490",
      'title': "Wireless Mouse Slim",
      'price': "\$24.00",
      'oldPrice': "\$30.00",
      'discount': "20%",
      'rating': "4.4",
      'sold': "145",
      'reviews': "108",
    },
    {
      'image':
          "https://obeyclothing.com/cdn/shop/files/172120130_FNC_1_cb9494ad-23f9-404c-ace4-f0ad488a723d.png?v=1773698611&width=1200",
      'title': "Portable Bluetooth Speaker",
      'price': "\$40.00",
      'oldPrice': "\$50.00",
      'discount': "20%",
      'rating': "4.6",
      'sold': "112",
      'reviews': "84",
    },
    {
      'image':
          "https://obeyclothing.com/cdn/shop/files/142010109_RNB_2.png?v=1754529462&width=700",
      'title': "Gaming Keyboard Mini",
      'price': "\$72.00",
      'oldPrice': "\$90.00",
      'discount': "20%",
      'rating': "4.7",
      'sold': "96",
      'reviews': "75",
    },
    {
      'image':
          "https://obeyclothing.com/cdn/shop/files/151000123_DNV_2.png?v=1776182122&width=700",
      'title': "USB-C Fast Cable",
      'price': "\$12.00",
      'oldPrice': "\$15.00",
      'discount': "20%",
      'rating': "4.3",
      'sold': "220",
      'reviews': "170",
    },
    {
      'image':
          "https://obeyclothing.com/cdn/shop/files/151000125_BMU_2.png?v=1776181948&width=700",
      'title': "Laptop Backpack Urban",
      'price': "\$56.00",
      'oldPrice': "\$70.00",
      'discount': "20%",
      'rating': "4.5",
      'sold': "88",
      'reviews': "66",
    },
    {
      'image':
          "https://obeyclothing.com/cdn/shop/files/181210464_SFB_2.png?v=1776114324&width=700",
      'title': "Fitness Smart Band",
      'price': "\$48.00",
      'oldPrice': "\$60.00",
      'discount': "20%",
      'rating': "4.4",
      'sold': "134",
      'reviews': "99",
    },
    {
      'image':
          "https://obeyclothing.com/cdn/shop/files/167924341_DBA_2.png?v=1776116902&width=700",
      'title': "Tablet Stand Foldable",
      'price': "\$20.00",
      'oldPrice': "\$25.00",
      'discount': "20%",
      'rating': "4.2",
      'sold': "165",
      'reviews': "122",
    },
    {
      'image':
          "https://obeyclothing.com/cdn/shop/files/167924340_DBA_2.png?v=1776117130&width=700",
      'title': "LED Desk Lamp Smart",
      'price': "\$36.00",
      'oldPrice': "\$45.00",
      'discount': "20%",
      'rating': "4.5",
      'sold': "73",
      'reviews': "55",
    },
    {
      'image':
          "https://obeyclothing.com/cdn/shop/files/100580433_BLK_1.png?v=1776183732&width=1200",
      'title': "Wireless Earbuds Lite",
      'price': "\$64.00",
      'oldPrice': "\$80.00",
      'discount': "20%",
      'rating': "4.6",
      'sold': "121",
      'reviews': "90",
    },
    {
      'image':
          "https://obeyclothing.com/cdn/shop/files/172100108_BAH_1_20b25227-1686-480b-8d29-04d3a4c25b5e.png?v=1773697666&width=1200",
      'title': "External SSD 512GB",
      'price': "\$88.00",
      'oldPrice': "\$110.00",
      'discount': "20%",
      'rating': "4.8",
      'sold': "67",
      'reviews': "49",
    },
    {
      'image':
          "https://obeyclothing.com/cdn/shop/files/100050041_BLK_1.png?v=1770744424&width=700",
      'title': "Gaming Headset RGB",
      'price': "\$52.00",
      'oldPrice': "\$65.00",
      'discount': "20%",
      'rating': "4.7",
      'sold': "101",
      'reviews': "77",
    },
    {
      'image':
          "https://obeyclothing.com/cdn/shop/files/100010168_BLK_2.png?v=1770744421&width=700",
      'title': "Smartphone Holder Car",
      'price': "\$16.00",
      'oldPrice': "\$20.00",
      'discount': "20%",
      'rating': "4.1",
      'sold': "189",
      'reviews': "140",
    },
    {
      'image':
          "https://obeyclothing.com/cdn/shop/files/268072739_DIB_1.png?v=1776110348&width=700",
      'title': "Portable Mini Fan",
      'price': "\$18.40",
      'oldPrice': "\$23.00",
      'discount': "20%",
      'rating': "4.3",
      'sold': "154",
      'reviews': "113",
    },
    {
      'image':
          "https://obeyclothing.com/cdn/shop/files/268052729_DIB_1.png?v=1776111049&width=700",
      'title': "Smart LED Bulb",
      'price': "\$14.40",
      'oldPrice': "\$18.00",
      'discount': "20%",
      'rating': "4.5",
      'sold': "210",
      'reviews': "168",
    },
    {
      'image':
          "https://obeyclothing.com/cdn/shop/files/268062737_WHT_1.png?v=1776112147&width=700",
      'title': "Wireless Charger Pad",
      'price': "\$28.00",
      'oldPrice': "\$35.00",
      'discount': "20%",
      'rating': "4.4",
      'sold': "119",
      'reviews': "92",
    },
    {
      'image':
          "https://obeyclothing.com/cdn/shop/files/142030046_DIB_2.png?v=1752000714&width=700",
      'title': "Mechanical Keyboard RGB",
      'price': "\$96.00",
      'oldPrice': "\$120.00",
      'discount': "20%",
      'rating': "4.8",
      'sold': "58",
      'reviews': "43",
    },
    {
      'image':
          "https://obeyclothing.com/cdn/shop/files/151010047_NAT_1_e58a91fe-1ed8-4831-8619-4059a12cafd2.png?v=1776182298&width=1200",
      'title': "Noise Cancelling Headphones",
      'price': "\$120.00",
      'oldPrice': "\$150.00",
      'discount': "20%",
      'rating': "4.9",
      'sold': "72",
      'reviews': "54",
    },
    {
      'image':
          "https://obeyclothing.com/cdn/shop/files/151000123_UBL_1.png?v=1776182105&width=1200",
      'title': "Portable Projector Mini",
      'price': "\$160.00",
      'oldPrice': "\$200.00",
      'discount': "20%",
      'rating': "4.6",
      'sold': "36",
      'reviews': "26",
    },
    {
      'image':
          "https://obeyclothing.com/cdn/shop/files/134050061_WHT_1.png?v=1754529813&width=1200",
      'title': "Action Camera Lite",
      'price': "\$104.00",
      'oldPrice': "\$130.00",
      'discount': "20%",
      'rating': "4.5",
      'sold': "49",
      'reviews': "37",
    },
    {
      'image':
          "https://obeyclothing.com/cdn/shop/files/181210451_BID_1.png?v=1770745433&width=1200",
      'title': "USB Hub Multiport",
      'price': "\$32.00",
      'oldPrice': "\$40.00",
      'discount': "20%",
      'rating': "4.4",
      'sold': "142",
      'reviews': "105",
    }
  ],
  "30%": [
    {
      'image':
          "https://obeyclothing.com/cdn/shop/files/181210463_MGN_1.png?v=1776114675&width=1200",
      'title': "Smartphone Lite",
      'price': "\$350.00",
      'oldPrice': "\$500.00",
      'discount': "30%",
      'rating': "4.7",
      'sold': "130",
      'reviews': "98",
    },
    {
      'image':
          "https://obeyclothing.com/cdn/shop/files/181210451_FBL_1_a136be1a-1d17-4daa-b21f-60218c37cea5.png?v=1770940477&width=1200",
      'title': "Wireless Keyboard",
      'price': "\$42.00",
      'oldPrice': "\$60.00",
      'discount': "30%",
      'rating': "4.5",
      'sold': "88",
      'reviews': "66",
    },
    {
      'image':
          "https://obeyclothing.com/cdn/shop/files/131080331_BKM_1.png?v=1754529819&width=1200",
      'title': "Gaming Headset",
      'price': "\$70.00",
      'oldPrice': "\$100.00",
      'discount': "30%",
      'rating': "4.8",
      'sold': "102",
      'reviews': "80",
    },
    {
      'image':
          "https://obeyclothing.com/cdn/shop/files/131080300_BLK_1_f57561b0-a6f0-4232-803b-ea95af5db78b.png?v=1773441235&width=1200",
      'title': "Portable Bluetooth Speaker",
      'price': "\$28.00",
      'oldPrice': "\$40.00",
      'discount': "30%",
      'rating': "4.4",
      'sold': "190",
      'reviews': "150",
    },
    {
      'image':
          "https://obeyclothing.com/cdn/shop/files/112460022_AGRY_1.png?v=1754529839&width=1200",
      'title': "Fitness Tracker Watch",
      'price': "\$56.00",
      'oldPrice': "\$80.00",
      'discount': "30%",
      'rating': "4.6",
      'sold': "97",
      'reviews': "73",
    },
    {
      'image':
          "https://obeyclothing.com/cdn/shop/files/112480152_BLK_1.png?v=1754529830&width=1200",
      'title': "USB-C Hub Adapter",
      'price': "\$21.00",
      'oldPrice': "\$30.00",
      'discount': "30%",
      'rating': "4.3",
      'sold': "160",
      'reviews': "121",
    },
    {
      'image':
          "https://obeyclothing.com/cdn/shop/files/112480152_EID_1_f7075517-e8b1-4543-a1f6-0bc300d86f6e.png?v=1771009713&width=1200",
      'title': "Laptop Stand Adjustable",
      'price': "\$35.00",
      'oldPrice': "\$50.00",
      'discount': "30%",
      'rating': "4.5",
      'sold': "79",
      'reviews': "58",
    },
    {
      'image':
          "https://obeyclothing.com/cdn/shop/files/172120116_BLK_1.png?v=1754529766&width=1200",
      'title': "4K Webcam",
      'price': "\$63.00",
      'oldPrice': "\$90.00",
      'discount': "30%",
      'rating': "4.7",
      'sold': "68",
      'reviews': "49",
    },
    {
      'image':
          "https://obeyclothing.com/cdn/shop/files/151000119_SKW_1.png?v=1770924051&width=1200",
      'title': "Gaming Controller",
      'price': "\$49.00",
      'oldPrice': "\$70.00",
      'discount': "30%",
      'rating': "4.6",
      'sold': "120",
      'reviews': "91",
    },
    {
      'image':
          "https://obeyclothing.com/cdn/shop/files/100490148_RYB_1.png?v=1770744444&width=1200",
      'title': "Wireless Charging Dock",
      'price': "\$31.50",
      'oldPrice': "\$45.00",
      'discount': "30%",
      'rating': "4.4",
      'sold': "84",
      'reviews': "60",
    },
    {
      'image':
          "https://obeyclothing.com/cdn/shop/files/172100107_LIN_1.png?v=1773697406&width=1200",
      'title': "Mini LED Projector",
      'price': "\$105.00",
      'oldPrice': "\$150.00",
      'discount': "30%",
      'rating': "4.5",
      'sold': "41",
      'reviews': "30",
    },
    {
      'image':
          "https://obeyclothing.com/cdn/shop/files/181210453_UBL_1_330d2d1c-b0f4-474c-92e9-6fbcb903ac95.png?v=1770940607&width=1200",
      'title': "Mechanical Gaming Mouse",
      'price': "\$38.50",
      'oldPrice': "\$55.00",
      'discount': "30%",
      'rating': "4.6",
      'sold': "111",
      'reviews': "84",
    },
    {
      'image':
          "https://obeyclothing.com/cdn/shop/files/121800618_PDM_1.png?v=1770936114&width=1200",
      'title': "Noise Reduction Earbuds",
      'price': "\$52.50",
      'oldPrice': "\$75.00",
      'discount': "30%",
      'rating': "4.7",
      'sold': "95",
      'reviews': "71",
    },
    {
      'image':
          "https://obeyclothing.com/cdn/shop/files/151010046_BKM_1_b7972cfe-f1be-436d-9749-47f6b4c0d9fc.png?v=1770934637&width=1200",
      'title': "Tablet Stand Holder",
      'price': "\$17.50",
      'oldPrice': "\$25.00",
      'discount': "30%",
      'rating': "4.2",
      'sold': "145",
      'reviews': "110",
    },
    {
      'image':
          "https://obeyclothing.com/cdn/shop/files/121800620_BLK_1_96756bfc-55c3-4505-9bc3-92b495001f85.png?v=1770936535&width=1200",
      'title': "Smart Security Camera",
      'price': "\$84.00",
      'oldPrice': "\$120.00",
      'discount': "30%",
      'rating': "4.6",
      'sold': "52",
      'reviews': "38",
    },
    {
      'image':
          "https://obeyclothing.com/cdn/shop/files/121800615_RID_1_10c8f49d-d984-4e99-bd0a-145e0694be2e.png?v=1770935254&width=1200",
      'title': "RGB Desk Light",
      'price': "\$24.50",
      'oldPrice': "\$35.00",
      'discount': "30%",
      'rating': "4.3",
      'sold': "137",
      'reviews': "101",
    },
    {
      'image':
          "https://obeyclothing.com/cdn/shop/files/151010042_BLK_1.png?v=1754529410&width=1200",
      'title': "External Hard Drive 2TB",
      'price': "\$91.00",
      'oldPrice': "\$130.00",
      'discount': "30%",
      'rating': "4.8",
      'sold': "74",
      'reviews': "57",
    },
    {
      'image':
          "https://obeyclothing.com/cdn/shop/files/142010113_IDS_1.jpg?v=1760979876&width=1200",
      'title': "Wireless Presenter Remote",
      'price': "\$19.60",
      'oldPrice': "\$28.00",
      'discount': "30%",
      'rating': "4.4",
      'sold': "89",
      'reviews': "64",
    },
    {
      'image':
          "https://obeyclothing.com/cdn/shop/files/142020261_RSI_1.png?v=1754529434&width=1200",
      'title': "Portable Power Bank",
      'price': "\$46.20",
      'oldPrice': "\$66.00",
      'discount': "30%",
      'rating': "4.7",
      'sold': "125",
      'reviews': "93",
    },
    {
      'image':
          "https://obeyclothing.com/cdn/shop/files/142010095_WTU_1.jpg?v=1752000851&width=1200",
      'title': "Smart LED Strip Lights",
      'price': "\$29.40",
      'oldPrice': "\$42.00",
      'discount': "30%",
      'rating': "4.5",
      'sold': "154",
      'reviews': "118",
    }
  ],
  "40%": [
    {
      'image':
          "https://eu.louisvuitton.com/images/is/image/lv/1/PP_VP_L/louis-vuitton-scallop-hem-crop-top--FUJT91UOL900_PM2_Front%20view.png?wid=490&hei=490",
      'title': "Gaming Laptop Pro",
      'price': "\$720.00",
      'oldPrice': "\$1200.00",
      'discount': "40%",
      'rating': "4.9",
      'sold': "82",
      'reviews': "61",
    },
    {
      'image':
          "https://eu.louisvuitton.com/images/is/image/lv/1/PP_VP_L/louis-vuitton-open-back-denim-top--FUTO63GOW620_PM2_Front%20view.png?wid=490&hei=490",
      'title': "Wireless Earbuds Max",
      'price': "\$48.00",
      'oldPrice': "\$80.00",
      'discount': "40%",
      'rating': "4.7",
      'sold': "145",
      'reviews': "110",
    },
    {
      'image':
          "https://eu.louisvuitton.com/images/is/image/lv/1/PP_VP_L/louis-vuitton-knot-front-knit-top--FUKM98B8O900_PM2_Front%20view.png?wid=490&hei=490",
      'title': "Smartphone Ultra",
      'price': "\$540.00",
      'oldPrice': "\$900.00",
      'discount': "40%",
      'rating': "4.8",
      'sold': "96",
      'reviews': "74",
    },
    {
      'image':
          "https://eu.louisvuitton.com/images/is/image/lv/1/PP_VP_L/louis-vuitton-lv-twist-knit-tank-top--FUKW06SH2900_PM2_Front%20view.png?wid=490&hei=490",
      'title': "Bluetooth Speaker Mini",
      'price': "\$30.00",
      'oldPrice': "\$50.00",
      'discount': "40%",
      'rating': "4.5",
      'sold': "170",
      'reviews': "122",
    },
    {
      'image':
          "https://eu.louisvuitton.com/images/is/image/lv/1/PP_VP_L/louis-vuitton-bell-sleeve-knit-top--FUKS84A6Z740_PM2_Front%20view.png?wid=490&hei=490",
      'title': "Mechanical Keyboard RGB",
      'price': "\$66.00",
      'oldPrice': "\$110.00",
      'discount': "40%",
      'rating': "4.6",
      'sold': "88",
      'reviews': "64",
    },
    {
      'image':
          "https://eu.louisvuitton.com/images/is/image/lv/1/PP_VP_L/louis-vuitton-monogram-accent-knit-top--FUKS17SO5900_PM2_Front%20view.png?wid=490&hei=490",
      'title': "USB-C Fast Charger",
      'price': "\$18.00",
      'oldPrice': "\$30.00",
      'discount': "40%",
      'rating': "4.4",
      'sold': "250",
      'reviews': "180",
    },
    {
      'image':
          "https://eu.louisvuitton.com/images/is/image/lv/1/PP_VP_L/louis-vuitton-monogram-scarf-pajama-top--FUTP06ZBI900_PM2_Front%20view.png?wid=490&hei=490",
      'title': "Action Camera Go",
      'price': "\$90.00",
      'oldPrice': "\$150.00",
      'discount': "40%",
      'rating': "4.7",
      'sold': "55",
      'reviews': "39",
    },
    {
      'image':
          "https://eu.louisvuitton.com/images/is/image/lv/1/PP_VP_L/louis-vuitton-striped-signature-polo-top--FUTE04VE1417_PM2_Front%20view.png?wid=490&hei=490",
      'title': "Portable SSD 512GB",
      'price': "\$54.00",
      'oldPrice': "\$90.00",
      'discount': "40%",
      'rating': "4.8",
      'sold': "103",
      'reviews': "80",
    },
    {
      'image':
          "https://eu.louisvuitton.com/images/is/image/lv/1/PP_VP_L/louis-vuitton-ribbed-knit-zip-up-cardigan--FVKC15499512_PM2_Front%20view.png?wid=490&hei=490",
      'title': "Fitness Smart Band",
      'price': "\$24.00",
      'oldPrice': "\$40.00",
      'discount': "40%",
      'rating': "4.3",
      'sold': "190",
      'reviews': "145",
    },
    {
      'image':
          "https://eu.louisvuitton.com/images/is/image/lv/1/PP_VP_L/louis-vuitton-side-trunk-mm--M28749_PM2_Front%20view.png?wid=490&hei=490",
      'title': "4K Monitor Display",
      'price': "\$210.00",
      'oldPrice': "\$350.00",
      'discount': "40%",
      'rating': "4.9",
      'sold': "44",
      'reviews': "30",
    },
    {
      'image':
          "https://eu.louisvuitton.com/images/is/image/lv/1/PP_VP_L/louis-vuitton-multipass--M28029_PM2_Front%20view.png?wid=490&hei=490",
      'title': "Gaming Mouse Pad XL",
      'price': "\$15.00",
      'oldPrice': "\$25.00",
      'discount': "40%",
      'rating': "4.2",
      'sold': "230",
      'reviews': "176",
    },
    {
      'image':
          "https://eu.louisvuitton.com/images/is/image/lv/1/PP_VP_L/louis-vuitton-vendome-mm--M26338_PM2_Front%20view.png?wid=490&hei=490",
      'title': "Drone Camera Air",
      'price': "\$300.00",
      'oldPrice': "\$500.00",
      'discount': "40%",
      'rating': "4.8",
      'sold': "31",
      'reviews': "24",
    },
    {
      'image':
          "https://eu.louisvuitton.com/images/is/image/lv/1/PP_VP_L/louis-vuitton-graphic-monogram-bikini-top--FQSW26TRR900_PM2_Front%20view.png?wid=490&hei=490",
      'title': "VR Gaming Headset",
      'price': "\$180.00",
      'oldPrice': "\$300.00",
      'discount': "40%",
      'rating': "4.7",
      'sold': "39",
      'reviews': "27",
    },
    {
      'image':
          "https://eu.louisvuitton.com/images/is/image/lv/1/PP_VP_L/louis-vuitton-candy-signature-t-shirt--FVTS45789001_PM2_Front%20view.png?wid=1090&hei=1090",
      'title': "LED Desk Lamp",
      'price': "\$21.00",
      'oldPrice': "\$35.00",
      'discount': "40%",
      'rating': "4.5",
      'sold': "120",
      'reviews': "94",
    },
    {
      'image':
          "https://eu.louisvuitton.com/images/is/image/lv/1/PP_VP_L/louis-vuitton-signature-patch-t-shirt--FVTS39UOL001_PM2_Front%20view.png?wid=490&hei=490",
      'title': "Laptop Backpack",
      'price': "\$42.00",
      'oldPrice': "\$70.00",
      'discount': "40%",
      'rating': "4.6",
      'sold': "89",
      'reviews': "66",
    },
    {
      'image':
          "https://eu.louisvuitton.com/images/is/image/lv/1/PP_VP_L/louis-vuitton-mermaid-print-long-sleeved-t-shirt--FVJT06785703_PM2_Front%20view.png?wid=490&hei=490",
      'title': "Tablet Android Plus",
      'price': "\$150.00",
      'oldPrice': "\$250.00",
      'discount': "40%",
      'rating': "4.4",
      'sold': "58",
      'reviews': "40",
    },
    {
      'image':
          "https://eu.louisvuitton.com/images/is/image/lv/1/PP_VP_L/louis-vuitton-sleeveless-fringe-hem-toweling-hoodie--FVKC36689545_PM2_Front%20view.png?wid=490&hei=490",
      'title': "Smart Home Camera",
      'price': "\$72.00",
      'oldPrice': "\$120.00",
      'discount': "40%",
      'rating': "4.5",
      'sold': "70",
      'reviews': "51",
    },
    {
      'image':
          "https://eu.louisvuitton.com/images/is/image/lv/1/PP_VP_L/louis-vuitton-fringe-hem-toweling-jacket--FVKC35689000_PM2_Front%20view.png?wid=490&hei=490",
      'title': "Wireless Charger Pad",
      'price': "\$27.00",
      'oldPrice': "\$45.00",
      'discount': "40%",
      'rating': "4.3",
      'sold': "144",
      'reviews': "109",
    },
    {
      'image':
          "https://eu.louisvuitton.com/images/is/image/lv/1/PP_VP_L/louis-vuitton-short-sleeved-linen-pajama-shirt--FVTP13450002_PM2_Front%20view.png?wid=490&hei=490",
      'title': "Mini Projector Smart",
      'price': "\$132.00",
      'oldPrice': "\$220.00",
      'discount': "40%",
      'rating': "4.6",
      'sold': "36",
      'reviews': "25",
    },
    {
      'image':
          "https://eu.louisvuitton.com/images/is/image/lv/1/PP_VP_L/louis-vuitton-broderie-trim-cropped-shirt--FVBB01YF4000_PM2_Front%20view.png?wid=490&hei=490",
      'title': "Noise Cancel Headphones",
      'price': "\$84.00",
      'oldPrice': "\$140.00",
      'discount': "40%",
      'rating': "4.8",
      'sold': "112",
      'reviews': "86",
    }
  ],
  "50%": [
    {
      'image':
          "https://eu.louisvuitton.com/images/is/image/lv/1/PP_VP_L/louis-vuitton-button-top--FUTO70FEL019_PM2_Front%20view.png?wid=490&hei=490",
      'title': "Tech Processor",
      'price': "\$180.00",
      'oldPrice': "\$360.00",
      'discount': "50%",
      'rating': "4.9",
      'sold': "95",
      'reviews': "70",
    },
    {
      'image':
          "https://eu.louisvuitton.com/images/is/image/lv/1/PP_VP_L/louis-vuitton-asymmetrical-bib-pinstriped-top--FVBL01XN3613_PM2_Front%20view.png?wid=490&hei=490",
      'title': "Wireless Gaming Mouse",
      'price': "\$45.00",
      'oldPrice': "\$90.00",
      'discount': "50%",
      'rating': "4.8",
      'sold': "120",
      'reviews': "88",
    },
    {
      'image':
          "https://eu.louisvuitton.com/images/is/image/lv/1/PP_VP_L/louis-vuitton-structured-cropped-top--FULB77MCV900_PM2_Front%20view.png?wid=490&hei=490",
      'title': "Bluetooth Headphones",
      'price': "\$60.00",
      'oldPrice': "\$120.00",
      'discount': "50%",
      'rating': "4.7",
      'sold': "140",
      'reviews': "102",
    },
    {
      'image':
          "https://eu.louisvuitton.com/images/is/image/lv/1/PP_VP_L/louis-vuitton-embossed-monogram-body--FUTP22QJ3900_PM2_Front%20view.png?wid=490&hei=490",
      'title': "Smart Watch X",
      'price': "\$95.00",
      'oldPrice': "\$190.00",
      'discount': "50%",
      'rating': "4.9",
      'sold': "200",
      'reviews': "156",
    },
    {
      'image':
          "https://eu.louisvuitton.com/images/is/image/lv/1/PP_VP_L/louis-vuitton-flared-sleeve-lavalliere-blouse--FUBL79PHL006_PM2_Front%20view.png?wid=490&hei=490",
      'title': "4K Action Camera",
      'price': "\$110.00",
      'oldPrice': "\$220.00",
      'discount': "50%",
      'rating': "4.6",
      'sold': "85",
      'reviews': "61",
    },
    {
      'image':
          "https://eu.louisvuitton.com/images/is/image/lv/1/PP_VP_L/louis-vuitton-lv-sneakerina-mary-jane--AWU01AMI02_PM2_Front%20view.png?wid=490&hei=490",
      'title': "Portable SSD 1TB",
      'price': "\$75.00",
      'oldPrice': "\$150.00",
      'discount': "50%",
      'rating': "4.8",
      'sold': "175",
      'reviews': "130",
    },
    {
      'image':
          "https://eu.louisvuitton.com/images/is/image/lv/1/PP_VP_L/louis-vuitton-lv-trainer-sneaker--AWU04MLV54_PM2_Front%20view.png?wid=490&hei=490",
      'title': "RGB Mechanical Keyboard",
      'price': "\$55.00",
      'oldPrice': "\$110.00",
      'discount': "50%",
      'rating': "4.7",
      'sold': "112",
      'reviews': "90",
    },
    {
      'image':
          "https://eu.louisvuitton.com/images/is/image/lv/1/PP_VP_L/louis-vuitton-onthego-pm--M28181_PM2_Front%20view.png?wid=490&hei=490",
      'title': "Ultra HD Monitor",
      'price': "\$160.00",
      'oldPrice': "\$320.00",
      'discount': "50%",
      'rating': "4.9",
      'sold': "65",
      'reviews': "50",
    },
    {
      'image':
          "https://eu.louisvuitton.com/images/is/image/lv/1/PP_VP_L/louis-vuitton-side-strap-t-shirt--FGTS03JG2900_PM2_Front%20view.png?wid=490&hei=490",
      'title': "Noise Cancelling Earbuds",
      'price': "\$40.00",
      'oldPrice': "\$80.00",
      'discount': "50%",
      'rating': "4.5",
      'sold': "145",
      'reviews': "109",
    },
    {
      'image':
          "https://eu.louisvuitton.com/images/is/image/lv/1/PP_VP_L/louis-vuitton-lv-trainer-sneaker--AQ9U2ADN02_PM2_Front%20view.png?wid=490&hei=490",
      'title': "Laptop Cooling Pad",
      'price': "\$22.00",
      'oldPrice': "\$44.00",
      'discount': "50%",
      'rating': "4.4",
      'sold': "98",
      'reviews': "70",
    },
    {
      'image':
          "https://eu.louisvuitton.com/images/is/image/lv/1/PP_VP_L/louis-vuitton-lv-trainer-sneaker--AQ9U1APC01_PM2_Front%20view.png?wid=490&hei=490",
      'title': "Gaming Chair Pro",
      'price': "\$130.00",
      'oldPrice': "\$260.00",
      'discount': "50%",
      'rating': "4.8",
      'sold': "54",
      'reviews': "40",
    },
    {
      'image':
          "https://eu.louisvuitton.com/images/is/image/lv/1/PP_VP_L/louis-vuitton-on-my-side-pm--M57729_PM2_Front%20view.png?wid=490&hei=490",
      'title': "USB-C Dock Station",
      'price': "\$48.00",
      'oldPrice': "\$96.00",
      'discount': "50%",
      'rating': "4.6",
      'sold': "76",
      'reviews': "58",
    },
    {
      'image':
          "https://eu.louisvuitton.com/images/is/image/lv/1/PP_VP_L/louis-vuitton--frill-blouse--FHBL13AQV000_PM2_Front%20view.png?wid=490&hei=490",
      'title': "Drone Mini Air",
      'price': "\$210.00",
      'oldPrice': "\$420.00",
      'discount': "50%",
      'rating': "4.9",
      'sold': "33",
      'reviews': "25",
    },
    {
      'image':
          "https://eu.louisvuitton.com/images/is/image/lv/1/PP_VP_L/louis-vuitton-damier-mink-vest--HUF22WAI9MU1_PM2_Front%20view.png?wid=490&hei=490",
      'title': "VR Headset Lite",
      'price': "\$140.00",
      'oldPrice': "\$280.00",
      'discount': "50%",
      'rating': "4.7",
      'sold': "47",
      'reviews': "36",
    },
    {
      'image':
          "https://eu.louisvuitton.com/images/is/image/lv/1/PP_VP_L/louis-vuitton-beverly-hills-sneaker--BTU00KTG02_PM2_Front%20view.png?wid=490&hei=490",
      'title': "Smart Home Speaker",
      'price': "\$35.00",
      'oldPrice': "\$70.00",
      'discount': "50%",
      'rating': "4.5",
      'sold': "180",
      'reviews': "142",
    },
    {
      'image':
          "https://eu.louisvuitton.com/images/is/image/lv/1/PP_VP_L/louis-vuitton-time-out-sneaker--AO3U1APC01_PM2_Front%20view.png?wid=490&hei=490",
      'title': "LED Ring Light",
      'price': "\$18.00",
      'oldPrice': "\$36.00",
      'discount': "50%",
      'rating': "4.3",
      'sold': "210",
      'reviews': "160",
    },
    {
      'image':
          "https://eu.louisvuitton.com/images/is/image/lv/1/PP_VP_L/louis-vuitton-ribbed-tank-top--FVTS46XY4900_PM2_Front%20view.png?wid=490&hei=490",
      'title': "Tablet 10 Inch",
      'price': "\$125.00",
      'oldPrice': "\$250.00",
      'discount': "50%",
      'rating': "4.6",
      'sold': "58",
      'reviews': "41",
    },
    {
      'image':
          "https://eu.louisvuitton.com/images/is/image/lv/1/PP_VP_L/louis-vuitton-monogram-denim-buckle-strap-crop-top--FVBL44EFY610_PM2_Front%20view.png?wid=490&hei=490",
      'title': "Fitness Tracker Band",
      'price': "\$28.00",
      'oldPrice': "\$56.00",
      'discount': "50%",
      'rating': "4.4",
      'sold': "132",
      'reviews': "99",
    },
    {
      'image':
          "https://eu.louisvuitton.com/images/is/image/lv/1/PP_VP_L/louis-vuitton-ruffle-hem-denim-top--FVBL37355650_PM2_Front%20view.png?wid=490&hei=490",
      'title': "Smartphone Gimbal",
      'price': "\$50.00",
      'oldPrice': "\$100.00",
      'discount': "50%",
      'rating': "4.7",
      'sold': "44",
      'reviews': "31",
    },
    {
      'image':
          "https://eu.louisvuitton.com/images/is/image/lv/1/PP_VP_L/louis-vuitton-nautical-scarf-crop-top--FVTS11WRT703_PM2_Front%20view.png?wid=490&hei=490",
      'title': "Mini Projector HD",
      'price': "\$145.00",
      'oldPrice': "\$290.00",
      'discount': "50%",
      'rating': "4.8",
      'sold': "39",
      'reviews': "29",
    }
  ],
};

