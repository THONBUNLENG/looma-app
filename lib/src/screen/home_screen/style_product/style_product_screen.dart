import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:shopping_app/src/widget/text_widget.dart';
import '../../../../constants/app_color.dart';
import '../../../../constants/string_extension.dart';
import '../../../widget/favorite_button.dart';
import 'bloc/style_product_bloc.dart';

class StyleProductScreen extends StatefulWidget {
  final String imageUrl;

  const StyleProductScreen({super.key, required this.imageUrl});

  @override
  State<StyleProductScreen> createState() => _StyleProductScreenState();
}

class _StyleProductScreenState extends State<StyleProductScreen> {
  final TextEditingController _searchController = TextEditingController();

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

    return BlocProvider(
      create: (context) => StyleProductBloc()..add(StyleProductStarted()),
      child: BlocBuilder<StyleProductBloc, StyleProductState>(
        builder: (context, state) {
          final products = state is StyleProductLoaded ? state.products : <Map<String, dynamic>>[];
          final selectedStyle = state is StyleProductLoaded ? state.selectedStyle : "ALL";

          return Scaffold(
            backgroundColor: bgColor,
            appBar: AppBar(
              backgroundColor: bgColor,
              elevation: 0,
              centerTitle: true,
              iconTheme: IconThemeData(color: textColor),
              title: TextWidget(
                "Styles".tr,
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: textColor,
              ),
              bottom: PreferredSize(
                preferredSize: const Size.fromHeight(125),
                child: Column(
                  children: [
                    _buildSearchBar(context, isDark),
                    _buildStyleFilters(context, selectedStyle, isDark),
                    const SizedBox(height: 8),
                  ],
                ),
              ),
            ),
            body: state is StyleProductLoading
                ? const Center(child: CircularProgressIndicator())
                : Column(
                    children: [
                      _buildSectionHeader(selectedStyle, products.length, isDark),
                      Expanded(child: _buildProductGrid(products, selectedStyle, isDark)),
                    ],
                  ),
          );
        },
      ),
    );
  }

  Widget _buildSearchBar(BuildContext context, bool isDark) {
    final textColor = isDark ? Colors.white : Colors.black;
    final searchBg = isDark ? Colors.grey[850] : Colors.grey[100];
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                color: searchBg,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.search,
                    color: isDark ? Colors.white70 : Colors.black54,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: TextField(
                      controller: _searchController,
                      onChanged: (query) {
                        context.read<StyleProductBloc>().add(StyleSearchQueryChanged(query));
                      },
                      style: TextStyle(color: textColor),
                      decoration: InputDecoration(
                        hintText: "Search style products...".tr,
                        hintStyle: TextStyle(
                          color: isDark ? Colors.white70 : Colors.black54,
                        ),
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(vertical: 10),
                      ),
                    ),
                  ),
                  if (_searchController.text.isNotEmpty)
                    GestureDetector(
                      onTap: () {
                        _searchController.clear();
                        context.read<StyleProductBloc>().add(StyleSearchQueryChanged(""));
                      },
                      child: Icon(
                        Icons.clear,
                        size: 18,
                        color: isDark ? Colors.white70 : Colors.black54,
                      ),
                    ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 12),
          Icon(Icons.tune, size: 20, color: textColor),
          const SizedBox(width: 4),
          TextWidget(
            "filter".tr,
            fontWeight: FontWeight.bold,
            color: textColor,
          ),
        ],
      ),
    );
  }

  Widget _buildStyleFilters(BuildContext context, String selectedStyle, bool isDark) {
    final filters = [
      "ALL",
      "Old Money",
      "Streetwear",
      "Minimalist",
      "Vintage",
      "Casual",
      "Luxury",
      "Y2K",
    ];
    return SizedBox(
      height: 58,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 14),
        itemCount: filters.length,
        itemBuilder: (context, index) {
          final filter = filters[index];
          final selected = filter == selectedStyle;
          return GestureDetector(
            onTap: () {
              context.read<StyleProductBloc>().add(StyleFilterChanged(filter));
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 220),
              margin: const EdgeInsets.symmetric(horizontal: 6, vertical: 8),
              padding: const EdgeInsets.symmetric(horizontal: 20),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: selected
                    ? AppColor.primaryColor
                    : (isDark ? Colors.white10 : AppColor.grey100),
                borderRadius: BorderRadius.circular(30),
              ),
              child: TextWidget(
                filter.tr,
                fontWeight: FontWeight.bold,
                color: selected
                    ? AppColor.white
                    : (isDark ? Colors.white70 : AppColor.black),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildSectionHeader(String selectedStyle, int count, bool isDark) {
    final textColor = isDark ? Colors.white : Colors.black;
    return Padding(
      padding: const EdgeInsets.fromLTRB(18, 14, 18, 8),
      child: Row(
        children: [
          TextWidget(
            selectedStyle == "ALL"
                ? "All Styles".tr
                : "$selectedStyle ${'Style'.tr}",
            fontSize: 22,
            fontWeight: FontWeight.w900,
            color: textColor,
          ),
          const Spacer(),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: isDark ? Colors.white10 : AppColor.grey100,
              borderRadius: BorderRadius.circular(30),
            ),
            child: TextWidget(
              "$count ${'items'.tr}",
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: textColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProductGrid(List<Map<String, dynamic>> products, String selectedStyle, bool isDark) {
    if (products.isEmpty) {
      return Center(
        child: TextWidget(
          "No items found".tr,
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
        childAspectRatio: 0.60,
        crossAxisSpacing: 16,
        mainAxisSpacing: 20,
      ),
      itemBuilder: (context, index) {
        final item = products[index];
        final label = selectedStyle == "ALL"
            ? (item['style'] ?? "New")
            : selectedStyle;
        return StyleProductCard(
          product: item,
          imageUrl: item['image'] ?? '',
          title: item['title'] ?? '',
          price: item['price'] ?? '',
          oldPrice: item['oldPrice'] ?? '',
          styleLabel: label,
          isDark: isDark,
        );
      },
    );
  }
}

class StyleProductCard extends StatelessWidget {
  final Map<String, dynamic> product;
  final String imageUrl;
  final String title;
  final String price;
  final String oldPrice;
  final String styleLabel;
  final bool isDark;

  const StyleProductCard({
    super.key,
    required this.product,
    required this.imageUrl,
    required this.title,
    required this.price,
    required this.oldPrice,
    required this.styleLabel,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
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
                      errorWidget: (_, _, _) => Icon(
                        Icons.broken_image_outlined,
                        color: isDark ? Colors.white24 : AppColor.grey200,
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
                        color: AppColor.primaryColor,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: TextWidget(
                        styleLabel,
                        color: AppColor.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Positioned(
                    top: 10,
                    right: 10,
                    child: FavoriteButton(
                      product: product,
                      size: 19,
                      showBackground: true,
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
                    child: TextWidget(
                      oldPrice,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      color: Colors.grey,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
